
require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :views, Proc.new { File.join(root, "../views/") }
  
    configure do
      enable :sessions
      set :session_secret, "secret"
    end

    get "/" do
        if logged_in?
            redirect "/cars"
        else
            erb :index
        end
    end

    get "/users/signup" do
        erb :'user/signup'
    end

    post "/signup" do
        user = User.new
        user.name = params[:name]
        user.password = params[:password]
        begin
            if user.save
                redirect "/login"
            else
                redirect '/failure'
            end
    
        rescue ActiveRecord::RecordNotUnique
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
            @cars = current_user.cars
            # @cars = Car.all
            erb :'car/index'
        else 
            redirect "/login"
        end
    end

    get "/cars/new" do
        if logged_in?
            erb :'car/new'    
        else
            redirect "/login"
        end
    end

    post "/cars" do
        if logged_in?
            @car = Car.new

            @car.license_plate_number = params[:license]
            @car.make = params[:make]
            @car.model = params[:model]
            @car.year = params[:year]
            @car.user = current_user
    
            
            if @car.save
                redirect "/cars/#{@car.id}"
            else
                erb :'/car/error'
            end
     
        else
            redirect "/login"
        end

       
    end

    get "/cars/:id" do

        @car = Car.find(params[:id])
        if @car.user == current_user
            erb :'/car/show'
        else
            redirect "/cars"
        end
    end

    get "/cars/:id/edit" do
        
        @car = Car.find(params[:id])
        if @car.user == current_user
            erb :'car/edit'
        else
            redirect "/cars"
        end
    end

    patch "/cars/:id" do

        car = Car.find(params[:id])
        if car.user == current_user
            car.license_plate_number = params[:license]
            car.make = params[:make]
            car.model = params[:model]
            car.year = params[:year]

            car.save

            redirect "/cars/#{car.id}"
        else
            redirect "/cars"
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

    delete '/cars/:id' do
        car = Car.find(params[:id])
        if car.user == current_user
            car.delete
        end
        redirect "/cars"
    end
        

end
