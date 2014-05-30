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

ActiveRecord::Schema.define(version: 20140528131847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "document_answers", force: true do |t|
    t.integer  "document_id"
    t.integer  "template_field_id"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_answers", ["document_id", "template_field_id"], name: "index_document_answers_on_document_id_and_template_field_id", unique: true, using: :btree

  create_table "documents", force: true do |t|
    t.integer  "template_id"
    t.string   "title"
    t.integer  "user_id"
    t.string   "session_uniq_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["session_uniq_token"], name: "index_documents_on_session_uniq_token", unique: true, using: :btree
  add_index "documents", ["template_id"], name: "index_documents_on_template_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "template_fields", force: true do |t|
    t.integer  "template_id"
    t.string   "name"
    t.integer  "step_number"
    t.integer  "order_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "template_fields", ["template_id", "step_number", "order_number"], name: "uniqueness", unique: true, using: :btree

  create_table "templates", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
