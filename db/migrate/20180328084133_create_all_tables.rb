class CreateAllTables < ActiveRecord::Migration[5.1]
  def change
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
      t.index ["email"], name: "index_users_on_email", unique: true
    end
  end
end
