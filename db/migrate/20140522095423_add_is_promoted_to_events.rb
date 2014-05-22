class AddIsPromotedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_promoted, :boolean, default: false
  end
end
