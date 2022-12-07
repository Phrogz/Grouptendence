# encoding: utf-8
class YaIn < Sinatra::Application
	get "/" do
		@title = "Welcome to YaIn"
		@user = cookies[:uname]
		if @user
			haml :main
		else
			redirect "/name"
		end
	end

	get "/name" do
		@title = "Set your YaIn Name"
		@user = cookies[:uname]
		haml :name
	end

	get "/:event" do
		redirect '/login' unless @user = cookies[:uname]
		@event = Event[id: params['event']]
		if @event
			@title = "YaIn for #{@event.name}"
			users = Signup.all_users
			haml :event
		else
			redirect '/'
		end
	end

	post "/name" do
		cookies[:uname] = params[:name]
		redirect '/'
	end

	post "/signup" do
		if user=cookies[:uname]
			signup = Signup[{event_time_id:params['time'], name:user}]
			next_type = ConfirmationType::NEXT[signup && signup.confirmation_type_id]
			if signup
				signup.update confirmation_type_id:next_type.id
			else
				Signup.insert(event_time_id:params['time'], name:user, confirmation_type_id:next_type.id)
			end

			content_type :json
			{
				status:next_type.label,
				stats:partial(:_event_signups, time:EventTime[params['time']])
			}.to_json
		end
	end

	get "/attendees/:time" do
		content_type :json
		DB
		.from(:signups)
		.where(event_time_id:params['time'])
		.join(:confirmation_types, id: :confirmation_type_id)
		.where{ confirmation_type_id > 0 }
		.select(:name, :label)
		.order_by(:confirmation_type_id)
		.all
		.group_by{ _1[:label].downcase }
		.map{ |label, people| [label, people.map{ _1[:name] }] }
		.to_h.to_json
	end
end