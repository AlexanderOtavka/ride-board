# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_10_140210) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.bigint "created_by_id", null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_messages_on_created_by_id"
    t.index ["ride_id"], name: "index_messages_on_ride_id"
  end

  create_table "ride_notification_subscriptions", force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "app", default: 0, null: false
    t.index ["ride_id", "user_id"], name: "index_ride_notification_subscriptions_on_ride_id_and_user_id", unique: true
    t.index ["ride_id"], name: "index_ride_notification_subscriptions_on_ride_id"
    t.index ["user_id"], name: "index_ride_notification_subscriptions_on_user_id"
  end

  create_table "rides", force: :cascade do |t|
    t.bigint "start_location_id", null: false
    t.datetime "start_datetime", null: false
    t.bigint "end_location_id", null: false
    t.datetime "end_datetime"
    t.bigint "driver_id"
    t.bigint "created_by_id", null: false
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "seats"
    t.index ["created_by_id"], name: "index_rides_on_created_by_id"
    t.index ["driver_id"], name: "index_rides_on_driver_id"
    t.index ["end_location_id"], name: "index_rides_on_end_location_id"
    t.index ["start_location_id"], name: "index_rides_on_start_location_id"
  end

  create_table "seat_assignments", force: :cascade do |t|
    t.bigint "ride_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ride_id", "user_id"], name: "index_seat_assignments_on_ride_id_and_user_id", unique: true
    t.index ["ride_id"], name: "index_seat_assignments_on_ride_id"
    t.index ["user_id"], name: "index_seat_assignments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin"
    t.boolean "notify_sms"
    t.boolean "notify_email"
    t.string "phone_number"
    t.string "name", default: "", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "messages", "rides"
  add_foreign_key "messages", "users", column: "created_by_id"
  add_foreign_key "ride_notification_subscriptions", "rides"
  add_foreign_key "ride_notification_subscriptions", "users"
  add_foreign_key "rides", "locations", column: "end_location_id"
  add_foreign_key "rides", "locations", column: "start_location_id"
  add_foreign_key "rides", "users", column: "created_by_id"
  add_foreign_key "rides", "users", column: "driver_id"
  add_foreign_key "seat_assignments", "rides"
  add_foreign_key "seat_assignments", "users"
end
