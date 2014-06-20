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

ActiveRecord::Schema.define(version: 20140620071023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "document_answers", force: true do |t|
    t.integer "document_id"
    t.integer "template_field_id"
    t.string  "answer"
    t.integer "toggler_offset",    default: 0
  end

  create_table "documents", force: true do |t|
    t.integer  "template_id"
    t.integer  "user_id"
    t.string   "session_uniq_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",              default: "Untitled document"
  end

  add_index "documents", ["template_id"], name: "index_documents_on_template_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "template_fields", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "field_type",       default: "string"
    t.boolean  "mandatory",        default: true
    t.integer  "template_step_id"
    t.text     "name"
    t.boolean  "in_line",          default: false
    t.integer  "toggle_id"
    t.boolean  "in_loop",          default: false
    t.string   "toggle_option"
    t.string   "looper_option"
    t.boolean  "dont_repeat",      default: false
  end

  add_index "template_fields", ["template_step_id"], name: "index_template_fields_on_template_step_id", using: :btree

  create_table "template_steps", force: true do |t|
    t.integer "template_id"
    t.integer "step_number"
    t.string  "title"
    t.text    "description"
    t.integer "render_if_field_id"
    t.string  "render_if_field_value"
    t.integer "amount_field_id"
  end

  add_index "template_steps", ["template_id", "step_number"], name: "index_template_steps_on_template_id_and_step_number", unique: true, using: :btree

  create_table "templates", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
