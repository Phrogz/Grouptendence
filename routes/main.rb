# encoding: utf-8
class Grouptendance < Sinatra::Application
	get "/" do
		@title = "Welcome to Grouptendance"
		@user = cookies[:uname]
		haml :main
	end

	get "/:event" do
		redirect '/login' unless @user = cookies[:uname]
		@event = Event[id: params['event']]
		users = Signup.all_users
		haml :event
	end

	post "/name" do
		cookies[:uname] = params[:name]
		redirect '/'
	end
end