
require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base

    get "/" do
        "hello world"
    end
    
end
