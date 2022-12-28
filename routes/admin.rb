# encoding: utf-8
class YaIn < Sinatra::Application
    get "/:event/edit" do
        @action = "editevent"
		@event = Event[id: params['event']]
		redirect '/' unless @event
        @title = "Edit #{@event.name}"
        haml :edit_event
	end

    post "/edit/save" do
        @event = Event[id: params['event']]
		redirect '/' unless @event

        DB.transaction do
            @event.update({
                name:params['name'],
                location:params['location'],
                description:params['description'],
            })

            # delete or update existing times
            params.keys.grep(/delete-\d+/).each do |key|
                time_id = key[/\d+/].to_i
                time = DB[:event_times].where(id:time_id)
                if params[key]=='true'
                    time.delete
                else
                    notes = params["notes-#{time_id}"].strip
                    time.update({
                        starts_at: params["starts_at-#{time_id}"],
                        minutes:   params["minutes-#{time_id}"],
                        notes:     notes.empty? ? nil : notes
                    })
                end
            end

            # add new times
            if params['starts_at']
                params['starts_at'].zip(params['minutes'], params['notes'].map(&:strip)).each do |(starts_at, minutes, notes)|
                    DB[:event_times] << {event_id:@event.id, starts_at:starts_at, minutes:minutes, notes:notes.empty? ? nil : notes}
                end
            end
        end

        redirect "/#{@event.id}"
    end
end