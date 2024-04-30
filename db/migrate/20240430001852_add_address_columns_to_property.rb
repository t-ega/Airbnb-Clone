class AddAddressColumnsToProperty < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :address, :string
    add_column :properties, :string, :string
  end
end
