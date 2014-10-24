class AddSaveableIdAndSaveableTypeToSaves < ActiveRecord::Migration
  def change
    add_column :saves, :saveable_id, :integer
    add_column :saves, :saveable_type, :string
  end
end
