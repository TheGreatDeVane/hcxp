class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :poster
      t.integer :user_id
      t.text :description
      t.date :beginning_at
      t.time :beginning_at_time
      t.date :ending_at
      t.time :ending_at_time
      t.decimal :price, precision: 30, scale: 10
      t.string :address

      t.timestamps
    end
  end
end
