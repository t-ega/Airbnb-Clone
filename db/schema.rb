# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_11_053303) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "host_payment_addresses", id: false, force: :cascade do |t|
    t.string "address"
    t.integer "host"
    t.string "currency"
    t.string "network"
    t.string "address_id"
    t.string "sub_account_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_host_payment_addresses_on_email", unique: true
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.string "headline"
    t.text "description"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "string"
    t.decimal "average_rating"
    t.bigint "host_id", null: false
    t.decimal "price", default: "0.0", null: false
    t.string "image_url"
    t.index ["host_id"], name: "index_properties_on_host_id"
  end

  create_table "quidax_sub_accounts", id: false, force: :cascade do |t|
    t.string "email"
    t.string "id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["email"], name: "index_quidax_sub_accounts_on_email", unique: true
    t.index ["user_id"], name: "index_quidax_sub_accounts_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "guest_id", null: false
    t.integer "property_id", null: false
    t.datetime "checkin_date", null: false
    t.datetime "checkout_date", null: false
    t.integer "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.integer "rating"
    t.bigint "reviewable_id"
    t.string "reviewable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reviewer_id", null: false
    t.index ["reviewable_id", "reviewable_type"], name: "index_reviews_on_reviewable_id_and_reviewable_type"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "sessions", primary_key: "session_id", id: :string, force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "logout_time"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token", null: false
    t.bigint "user_id", null: false
    t.datetime "expires_at", null: false
    t.boolean "is_used", default: false
    t.string "purpose", default: "", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone_number"
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "avatar_url"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "properties", "users", column: "host_id"
  add_foreign_key "quidax_sub_accounts", "users"
  add_foreign_key "reservations", "properties"
  add_foreign_key "reservations", "users", column: "guest_id"
  add_foreign_key "reviews", "users", column: "reviewer_id"
  add_foreign_key "tokens", "users"
end
