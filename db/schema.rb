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

ActiveRecord::Schema.define(version: 20160622121530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_details", force: :cascade do |t|
    t.boolean  "is_support"
    t.text     "content"
    t.string   "link"
    t.integer  "count"
    t.text     "like_dislike_list_id"
    t.integer  "post_id"
    t.integer  "people_id"
    t.integer  "issue_id"
    t.string   "comment_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "backup_id"
    t.string   "news_media"
    t.string   "reported_at"
    t.string   "title_at_that_time"
    t.boolean  "is_direct"
    t.boolean  "is_report"
  end

  create_table "data_issues", force: :cascade do |t|
    t.string   "title"
    t.text     "post"
    t.boolean  "is_candidate"
    t.integer  "trunk_id"
    t.integer  "popularity"
    t.string   "datadetail_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "data_people", force: :cascade do |t|
    t.string   "name"
    t.string   "pic_link"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "like_dislike_lists", force: :cascade do |t|
    t.integer  "detail_id"
    t.boolean  "is_like"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "migrations", force: :cascade do |t|
    t.string   "add_is_report_to_data_datadetails"
    t.boolean  "is_report"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "report_details", force: :cascade do |t|
    t.integer  "detail_id"
    t.boolean  "is_check"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.boolean  "high_power"
    t.string   "nickname"
    t.string   "own"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
