class AddPurposeToToken < ActiveRecord::Migration[7.1]
  def change
    add_column :tokens, :purpose, :string, null: false, default: ""
  end
end
