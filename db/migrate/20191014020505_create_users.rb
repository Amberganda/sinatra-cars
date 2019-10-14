class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :drivers_license_number
      t.string :name, :null => false
      t.date :dob
      t.string :password_digest
      
      t.index :name, unique: true
    end
  end
end
