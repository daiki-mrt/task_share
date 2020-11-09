class AddTextToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :communities, :text, :text
  end
end
