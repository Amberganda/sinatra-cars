class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :license_plate_number
      t.string :make
      t.string :model
      t.integer :year
    end
  end
end
