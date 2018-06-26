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

ActiveRecord::Schema.define(version: 20180523022744) do

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.datetime "start"
    t.datetime "end"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "microposts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.datetime "start"
    t.datetime "end"
    t.string "state"
    t.string "place"
    t.string "visit"
    t.string "personnel"
    t.text "purpose"
    t.text "notes"
    t.bigint "auth_id"
    t.datetime "order_date"
    t.index ["auth_id"], name: "index_orders_on_auth_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "reference_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "refer_id"
    t.bigint "referred_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "report_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "report_id"
    t.string "place"
    t.string "visit"
    t.string "personnel"
    t.text "information"
    t.text "notes"
    t.text "comment"
    t.index ["report_id"], name: "index_report_items_on_report_id"
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "request_id"
    t.bigint "user_id"
    t.datetime "start"
    t.datetime "end"
    t.string "state"
    t.string "region"
    t.bigint "auth_id"
    t.datetime "rep_date"
    t.index ["auth_id"], name: "index_reports_on_auth_id"
    t.index ["request_id"], name: "index_reports_on_request_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "request_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "request_id"
    t.string "place"
    t.string "visit"
    t.string "personnel"
    t.text "purpose"
    t.text "notes"
    t.text "comment"
    t.index ["request_id"], name: "index_request_items_on_request_id"
  end

  create_table "requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.datetime "start"
    t.datetime "end"
    t.string "state"
    t.string "region"
    t.bigint "auth_id"
    t.datetime "req_date"
    t.bigint "order_id"
    t.index ["auth_id"], name: "index_requests_on_auth_id"
    t.index ["order_id"], name: "index_requests_on_order_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "name"
    t.string "color"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "events", "users"
  add_foreign_key "microposts", "users"
  add_foreign_key "report_items", "reports"
  add_foreign_key "reports", "requests"
  add_foreign_key "reports", "users"
  add_foreign_key "reports", "users", column: "auth_id"
  add_foreign_key "request_items", "requests"
  add_foreign_key "requests", "orders"
  add_foreign_key "requests", "users"
  add_foreign_key "requests", "users", column: "auth_id"
end
