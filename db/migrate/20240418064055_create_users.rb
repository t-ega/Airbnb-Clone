class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.string :email

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
