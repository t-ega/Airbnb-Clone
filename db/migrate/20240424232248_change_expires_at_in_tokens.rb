class ChangeExpiresAtInTokens < ActiveRecord::Migration[7.1]
  def change
    change_column(:tokens, :expires_at, :datetime)
  end
end
