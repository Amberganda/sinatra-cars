class Car < ActiveRecord::Base
    validates :make, :model, :year, presence: true
    validates :year, numericality: {only_integer: true, greater_than_or_equal_to: 1900}
    belongs_to :user



end
