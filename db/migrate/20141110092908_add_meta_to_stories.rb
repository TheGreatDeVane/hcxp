class AddMetaToStories < ActiveRecord::Migration
  def change
    add_column :stories, :meta, :json
  end
end
