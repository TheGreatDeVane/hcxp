class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.string :location
      t.string :city
      t.string :country_name
      t.string :country_code

      t.timestamps
    end
  end
end
