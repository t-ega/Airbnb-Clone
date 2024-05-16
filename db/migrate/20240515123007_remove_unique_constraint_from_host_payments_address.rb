class RemoveUniqueConstraintFromHostPaymentsAddress < ActiveRecord::Migration[
  7.1
]
  def change
    remove_index :host_payment_addresses, :email
  end
end
