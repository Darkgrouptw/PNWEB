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

ActiveRecord::Schema.define(version: 20160125091153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_contents", force: :cascade do |t|
    t.boolean  "is_support"
    t.text     "text"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_issues", force: :cascade do |t|
    t.text     "content"
    t.integer  "count"
    t.integer  "parent_id"
    t.string   "sub_id"
    t.integer  "agree"
    t.integer  "disagree"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_people", force: :cascade do |t|
    t.string   "name"
    t.string   "pic_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_pointers", force: :cascade do |t|
    t.integer  "issue_id"
    t.string   "person_id"
    t.string   "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "pic_link"
  end

end
