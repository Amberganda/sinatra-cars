
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
        erb:'user/signup'
    end

    post "/signup" do
        user = User.new
        user.name = params[:name]
        user.password = params[:password]

        if user.save
            redirect '/login'

        else
            redirect '/failure'
        end
    end



        

end
