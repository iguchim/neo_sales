class CreateOder < ActiveRecord::Migration[5.1]
  def change
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
  end
end
