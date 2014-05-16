class AddShortIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :short_id, :string
    add_index :events, :short_id, :unique => true
  end
end
