class AddBindingsToEvents < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION hstore'
    add_column :events, :bindings, :hstore
  end
end
