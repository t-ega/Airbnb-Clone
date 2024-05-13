class RemoveEmailFromQuidaxSubAccount < ActiveRecord::Migration[7.1]
  def change
    remove_column :quidax_sub_accounts, :email
  end
end
