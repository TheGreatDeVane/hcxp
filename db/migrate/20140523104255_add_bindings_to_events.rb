class AddBindingsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :bindings, :hstore
  end
end
