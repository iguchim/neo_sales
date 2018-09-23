class CreateObjectiveDetails < ActiveRecord::Migration[5.1]
  def change
    create_table "objective_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.references :objective, foreign_key: true
      t.datetime "exec_date"
      t.text "contents"
      t.decimal "amount"
      t.text "comment"
      t.string "auth"
      t.timestamps
    end
  end
end
