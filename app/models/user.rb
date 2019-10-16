class User < ActiveRecord::Base
    has_secure_password
    has_many :cars
    validates_presence_of :name, :password

    


end