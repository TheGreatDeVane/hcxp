class CreateStoryBands < ActiveRecord::Migration
  def change
    create_table :story_bands do |t|
      t.references :story, index: true
      t.references :band, index: true

      t.timestamps
    end
  end
end
