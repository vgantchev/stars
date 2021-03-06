# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160325085953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interesting_objects", force: :cascade do |t|
    t.string   "name",                   null: false
    t.text     "description"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.decimal  "average_rating"
    t.decimal  "average_value_estimate"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "interesting_objects", ["user_id"], name: "index_interesting_objects_on_user_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "interesting_object_id"
    t.integer  "score"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "ratings", ["interesting_object_id"], name: "index_ratings_on_interesting_object_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "value_estimates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "interesting_object_id"
    t.decimal  "value",                 default: 0.0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "value_estimates", ["interesting_object_id"], name: "index_value_estimates_on_interesting_object_id", using: :btree
  add_index "value_estimates", ["user_id"], name: "index_value_estimates_on_user_id", using: :btree

  add_foreign_key "interesting_objects", "users"
  add_foreign_key "ratings", "interesting_objects"
  add_foreign_key "ratings", "users"
  add_foreign_key "value_estimates", "interesting_objects"
  add_foreign_key "value_estimates", "users"
end
