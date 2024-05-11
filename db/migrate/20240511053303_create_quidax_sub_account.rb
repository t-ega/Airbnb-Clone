class CreateQuidaxSubAccount < ActiveRecord::Migration[7.1]
  def change
    create_table :quidax_sub_accounts, id: false do |t|
      t.string :email, index: { unique: true }
      t.string :id

      t.timestamps
    end
    add_reference :quidax_sub_accounts, :user, foreign_key: true
  end
end
