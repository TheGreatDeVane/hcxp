class AddImpressionsCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :impressions_count, :integer, default: 0
  end
end
