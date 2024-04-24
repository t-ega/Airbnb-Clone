class AddExpToConfirmationtokens < ActiveRecord::Migration[7.1]
  def change
    add_column :confirmation_tokens, :expires_at, :date, null: false
  end
end
