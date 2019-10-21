class AddBelongsToToCars < ActiveRecord::Migration[5.1]
  def change
    add_reference :cars, :user, foreign_key: true
  end
end
