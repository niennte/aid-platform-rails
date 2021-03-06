# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_15_215559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name", limit: 100, null: false
    t.string "last_name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pic_file_name"
    t.string "pic_content_type"
    t.bigint "pic_file_size"
    t.datetime "pic_updated_at"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "fulfillments", force: :cascade do |t|
    t.bigint "response_id", null: false
    t.bigint "user_id", null: false
    t.text "message", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "request_id", null: false
    t.index ["request_id"], name: "index_fulfillments_on_request_id"
    t.index ["response_id"], name: "index_fulfillments_on_response_id"
    t.index ["user_id"], name: "index_fulfillments_on_user_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "message_dispatches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "message_id", null: false
    t.boolean "is_read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_dispatches_on_message_id"
    t.index ["user_id"], name: "index_message_dispatches_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subject", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", limit: 100, null: false
    t.text "description", null: false
    t.string "address", null: false
    t.float "lat"
    t.float "lng"
    t.integer "category", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_address"
    t.string "city"
    t.string "postal_code"
    t.string "country"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "user_id", null: false
    t.text "message", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["request_id"], name: "index_responses_on_request_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "accounts", "users", on_delete: :cascade
  add_foreign_key "fulfillments", "requests", on_delete: :cascade
  add_foreign_key "fulfillments", "responses", on_delete: :cascade
  add_foreign_key "fulfillments", "users", on_delete: :restrict
  add_foreign_key "message_dispatches", "messages"
  add_foreign_key "message_dispatches", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "requests", "users", on_delete: :cascade
  add_foreign_key "responses", "requests", on_delete: :restrict
  add_foreign_key "responses", "users", on_delete: :restrict
end
