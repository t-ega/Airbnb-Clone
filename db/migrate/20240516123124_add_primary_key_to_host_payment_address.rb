class AddPrimaryKeyToHostPaymentAddress < ActiveRecord::Migration[7.1]
  def change
    change_column :host_payment_addresses,
                  :address_id,
                  :string,
                  primary_key: true
  end
end
