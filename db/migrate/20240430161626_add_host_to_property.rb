class AddHostToProperty < ActiveRecord::Migration[7.1]
  def change
    add_reference :properties, :host, null: false, foreign_key: {to_table: :users}
    add_column :properties, :price, :decimal, null: false, default: 0.0
  end
end
