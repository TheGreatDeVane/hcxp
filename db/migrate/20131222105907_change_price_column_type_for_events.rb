class ChangePriceColumnTypeForEvents < ActiveRecord::Migration
  def change
    change_column :events, :price, :string
  end
end
