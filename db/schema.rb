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

ActiveRecord::Schema.define(version: 20161020134859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_details", force: :cascade do |t|
    t.boolean  "is_support"
    t.text     "content"
    t.string   "link"
    t.string   "backup_id"
    t.text     "backup_type"
    t.integer  "count"
    t.text     "like_list_id"
    t.integer  "post_id"
    t.integer  "people_id"
    t.string   "people_name"
    t.integer  "issue_id"
    t.string   "comment_id"
    t.string   "news_media"
    t.string   "report_at"
    t.string   "title_at_that_time"
    t.boolean  "is_direct"
    t.boolean  "is_report"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "data_issues", force: :cascade do |t|
    t.string   "title"
    t.text     "post"
    t.boolean  "is_candidate"
    t.string   "datadetail_id"
    t.string   "thumb_up"
    t.string   "tag"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "data_media", force: :cascade do |t|
    t.string   "name"
    t.text     "valid_name"
    t.string   "description"
    t.text     "datadetail_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "data_people", force: :cascade do |t|
    t.string   "name"
    t.text     "valid_name"
    t.string   "pic_link"
    t.string   "description"
    t.text     "datadetail_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "like_lists", force: :cascade do |t|
    t.integer  "detail_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notify_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.datetime "last_read"
    t.datetime "newest_detail"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "report_details", force: :cascade do |t|
    t.integer  "detail_id"
    t.boolean  "is_check"
    t.string   "cause"
    t.integer  "people_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.string   "token"
    t.string   "ip"
    t.string   "nickname"
    t.integer  "level"
    t.integer  "sex"
    t.string   "birth"
    t.string   "liveplace"
    t.datetime "last_login_in"
    t.string   "own"
    t.text     "datadetail_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "verify_lists", force: :cascade do |t|
    t.string   "email"
    t.string   "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
