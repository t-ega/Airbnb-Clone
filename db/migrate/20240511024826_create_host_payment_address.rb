class CreateHostPaymentAddress < ActiveRecord::Migration[7.1]
  def change
    create_table :host_payment_addresses, id: false do |t|
      t.string :address
      t.integer :host
      t.string :currency
      t.string :network
      t.string :address_id
      t.string :sub_account_id
      t.string :email, index: { unique: true }

      t.timestamps
    end
  end
end
