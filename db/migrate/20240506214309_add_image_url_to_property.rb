class AddImageUrlToProperty < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :image_url, :string
    add_column :users, :avatar_url, :string
  end
end
