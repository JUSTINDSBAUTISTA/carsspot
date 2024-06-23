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

ActiveRecord::Schema[7.1].define(version: 2024_06_22_042642) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "driving_license"
    t.string "id_proof"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_bookings_on_car_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "car_name"
    t.string "features"
    t.string "transmission"
    t.string "fuel_type"
    t.string "car_make"
    t.string "image"
    t.integer "price_per_day"
    t.integer "rating"
    t.integer "number_of_seat"
    t.string "status"
    t.boolean "approved", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cars_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.string "shared_with"
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_favorites_on_car_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "recipient_id"
    t.bigint "actor_id"
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.string "location"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "driving_license"
    t.string "id_proof"
    t.index ["car_id"], name: "index_rentals_on_car_id"
    t.index ["user_id"], name: "index_rentals_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_reviews_on_car_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "name"
    t.date "birthday"
    t.string "phone_number"
    t.string "address"
    t.string "zip_code"
    t.string "town"
    t.string "country"
    t.text "about_me"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "cars"
  add_foreign_key "bookings", "users"
  add_foreign_key "cars", "users"
  add_foreign_key "favorites", "cars"
  add_foreign_key "favorites", "users"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "rentals", "cars"
  add_foreign_key "rentals", "users"
  add_foreign_key "reviews", "cars"
  add_foreign_key "reviews", "users"
end
