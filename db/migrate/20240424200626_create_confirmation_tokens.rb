class CreateConfirmationTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :confirmation_tokens do |t|
      t.string :token, null: false
      t.references :user, null: false, foreign_key: true
    end
  end
end
