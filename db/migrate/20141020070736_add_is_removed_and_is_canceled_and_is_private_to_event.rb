class AddIsRemovedAndIsCanceledAndIsPrivateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :is_removed, :boolean, default: false
    add_column :events, :is_canceled, :boolean, default: false
    add_column :events, :is_private, :boolean, default: false
  end
end
