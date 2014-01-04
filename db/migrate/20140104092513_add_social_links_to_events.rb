class AddSocialLinksToEvents < ActiveRecord::Migration
  def change
    add_column :events, :social_link_fb, :string
    add_column :events, :social_link_lfm, :string
    add_column :events, :social_link_hcpl, :string
  end
end
