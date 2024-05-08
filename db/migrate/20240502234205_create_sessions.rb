class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions,:id => false do |t|
      t.integer :user_id, null: false
      t.string :session_id, null: false, primary_key: true
      t.datetime :logout_time, null: true
    end

    add_index :sessions, :user_id
  end
end
