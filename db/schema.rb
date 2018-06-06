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

ActiveRecord::Schema.define(version: 2018_05_31_115420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "email_addresses", force: :cascade do |t|
    t.string "email"
    t.bigint "from_email_id"
    t.bigint "to_email_id"
    t.bigint "cc_email_id"
    t.bigint "bcc_email_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bcc_email_id"], name: "index_email_addresses_on_bcc_email_id"
    t.index ["cc_email_id"], name: "index_email_addresses_on_cc_email_id"
    t.index ["from_email_id"], name: "index_email_addresses_on_from_email_id"
    t.index ["to_email_id"], name: "index_email_addresses_on_to_email_id"
  end

  create_table "emails", force: :cascade do |t|
    t.text "subject"
    t.text "body"
    t.string "aasm_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "send_attempts", force: :cascade do |t|
    t.bigint "email_id"
    t.integer "provider"
    t.integer "attempt"
    t.string "provider_id"
    t.string "provider_message"
    t.boolean "successful", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_send_attempts_on_email_id"
  end

end
