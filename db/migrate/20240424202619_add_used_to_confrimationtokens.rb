class AddUsedToConfrimationtokens < ActiveRecord::Migration[7.1]
  def change
    add_column :confirmation_tokens, :is_used, :boolean, default: false
  end
end
