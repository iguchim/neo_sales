class CreateDailyReportDetail < ActiveRecord::Migration[5.1]
  def change
    create_table "daily_report_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8"  do |t|
      t.bigint "daily_report_id"
      t.string "customer"
      t.string "personnel"
      t.text    "contents"
      t.text    "notes"
      t.text    "comment"
      t.bigint "category_id"
      t.index ["daily_report_id"], name: "index_daily_report_details_on_daily_report_id"
      t.index ["category_id"], name: "index_daily_report_details_on_category_id"
    end
  end
end
