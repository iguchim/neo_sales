class CreateDailyReport < ActiveRecord::Migration[5.1]
  def change
    create_table "daily_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.bigint "user_id"
      t.datetime "report_date"
      t.index ["user_id"], name: "index_daily_reports_on_user_id"
    end
  end
end
