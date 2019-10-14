
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


end
