class CreateBandResources < ActiveRecord::Migration
  def change
    create_table :band_resources do |t|
      t.references :band, index: true
      t.string :type
      t.text :url
      t.text :data

      t.timestamps
    end
  end
end
