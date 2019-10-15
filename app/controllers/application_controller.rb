
require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }
  
    configure do
      enable :sessions
      set :session_secret, "secret"
    end

    get "/users/signup" do
        erb :'user/signup'
    end

    post "/signup" do
        user = User.new
        user.name = params[:name]
        user.password = params[:password]

        if user.save
            redirect "/login"

        else
            redirect '/failure'
        end
    end

    get "/login" do
        erb :'user/login'
    end


    post "/login" do
        user = User.find_by(:name => params[:name])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect "/success"
        else 
            redirect "/failure"
        end
    end

    get "/success" do
        if logged_in?
            erb :'user/success'
        else 
            redirect "/login"
        end
    end

    get "/failure" do
        erb :'user/failure'
    end

    get "/logout" do
		session.clear
		redirect "/login"
	end


    helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end

    end






        

end
