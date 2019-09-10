class AddCustomLinkToDecidimConferences < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_conferences, :custom_link_name, :jsonb
    add_column :decidim_conferences, :custom_link_url, :string
  end
end
