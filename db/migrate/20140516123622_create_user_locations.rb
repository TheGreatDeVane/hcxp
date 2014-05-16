class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.references :user, index: true
      t.string :city
      t.string :country_code

      t.timestamps
    end
  end
end
