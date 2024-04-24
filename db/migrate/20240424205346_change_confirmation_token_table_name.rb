class ChangeConfirmationTokenTableName < ActiveRecord::Migration[7.1]
  def change
    rename_table :confirmation_tokens, :tokens
  end
end
