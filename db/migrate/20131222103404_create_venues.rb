class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :address
      t.string :street
      t.string :city
      t.string :country_name
      t.string :country_code

      t.timestamps
    end
  end
end
