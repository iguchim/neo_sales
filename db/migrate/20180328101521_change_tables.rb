class ChangeTables < ActiveRecord::Migration[5.1]
  def change
      create_table "microposts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
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
    t.index ["auth_id"], name: "index_requests_on_auth_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end


  add_foreign_key "microposts", "users"
  add_foreign_key "report_items", "reports"
  add_foreign_key "reports", "requests"
  add_foreign_key "reports", "users"
  add_foreign_key "reports", "users", column: "auth_id"
  add_foreign_key "request_items", "requests"
  add_foreign_key "requests", "users"
  add_foreign_key "requests", "users", column: "auth_id"
  end
end
