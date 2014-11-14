class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :url, unique: true
      t.text :body
      t.references :user, index: true

      t.timestamps
    end
  end
end
