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

ActiveRecord::Schema.define(version: 20130907171150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "about"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_games", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "game_id"
  end

  create_table "events_groups", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "group_id"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "about"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["slug"], name: "index_games_on_slug", unique: true, using: :btree

  create_table "games_groups", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "game_id"
  end

  create_table "groupings", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.text     "info"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "event_id"
    t.integer  "invitee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "zip"
    t.decimal  "lat",        precision: 15, scale: 10
    t.decimal  "lng",        precision: 15, scale: 10
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["lat", "lng"], name: "index_locations_on_lat_and_lng", using: :btree

  create_table "playings", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", id: false, force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "info"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
