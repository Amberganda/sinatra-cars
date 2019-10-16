
require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }
  
    configure do
      enable :sessions
      set :session_secret, "secret"
    end

    get '/' do
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
            redirect "/cars"
        else 
            redirect "/failure"
        end
    end

    get "/cars" do
        if logged_in?
            erb :'car/index'
        else 
            redirect "/login"
        end
    end

    get "/cars/new" do
        erb :'car/new'    
    end

    post "/cars" do
        car = Car.new

        car.license_plate_number = params[:license]
        car.make = params[:make]
        car.model = params[:model]
        car.year = params[:year]

        car.save

        redirect "/cars/#{car.id}"
    end

    get "/cars/:id" do

        @car = Car.find(params[:id])

        erb :'/car/show'

    end

    get "/cars/:id/edit" do
        
        @car = Car.find(params[:id])

        erb :'car/edit'
    end

    patch "/cars/:id" do

        car = Car.find(params[:id])
        car.license_plate_number = params[:license]
        car.make = params[:make]
        car.model = params[:model]
        car.year = params[:year]

        car.save

        redirect "/cars/#{car.id}"

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


    delete '/cars/:id' do
        Car.delete(params[:id])
        redirect "/cars"
    end
    




        

end
