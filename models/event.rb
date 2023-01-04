# encoding: utf-8
class Event < Sequel::Model
	one_to_many :times, class: :EventTime
	def upcoming
		today = Time.now.to_date
		times
		.select{ |t| t.starts_at.to_date >= today }
		.sort_by{ |t| t.starts_at }
	end
	def has_upcoming?
		!upcoming.empty?
	end
end

class EventTime < Sequel::Model
	many_to_one :event
	one_to_many :signups
	def upcoming?
		starts_at > Time.now
	end
	def status_for(user)
		if signup = signups_dataset[name:user]
			signup.confirmation_type
		else
			ConfirmationType::UNKNOWN
		end
	end
	def signup_count_for_status(confirmation_id)
		signups_dataset.filter(confirmation_type_id: confirmation_id).count
	end
	def confirmed_count
		signup_count_for_status(ConfirmationType::CONFIRMED.id)
	end
	def tentative_count
		signup_count_for_status(ConfirmationType::TENTATIVE.id)
	end
	def declined_count
		signup_count_for_status(ConfirmationType::DECLINED.id)
	end
end

class Signup < Sequel::Model
	many_to_one :confirmation_type
	many_to_one :event_time
	def self.all_users
		select(:name).distinct.map(:name)
	end
end

class ConfirmationType < Sequel::Model
	UNKNOWN   = self[label:'Unknown']
	CONFIRMED = self[label:'Confirmed']
	TENTATIVE = self[label:'Tentative']
	DECLINED  = self[label:'Declined']

	NEXT = {
		nil => CONFIRMED,
		UNKNOWN.id => CONFIRMED,
		CONFIRMED.id => TENTATIVE,
		TENTATIVE.id => DECLINED,
		DECLINED.id => UNKNOWN
	}

	one_to_many :signups
end