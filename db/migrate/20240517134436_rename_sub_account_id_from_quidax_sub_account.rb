class RenameSubAccountIdFromQuidaxSubAccount < ActiveRecord::Migration[7.1]
  def change
    rename_column :quidax_sub_accounts, :id, :account_id
  end
end
