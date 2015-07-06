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

ActiveRecord::Schema.define(version: 20150706174808) do

  create_table "events", force: :cascade do |t|
    t.datetime "time",                                 null: false
    t.time     "ra",                                   null: false
    t.integer  "dec",       limit: 4,                  null: false
    t.string   "dir",       limit: 255,                null: false
    t.integer  "len",       limit: 4
    t.decimal  "mag",                   precision: 10
    t.integer  "vel",       limit: 4
    t.integer  "user_id",   limit: 4
    t.integer  "shower_id", limit: 4
  end

  add_index "events", ["shower_id"], name: "index_events_on_shower_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "login",         limit: 255
    t.string "password_hash", limit: 255
    t.string "role",          limit: 255
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
