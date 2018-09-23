class CreateObjectives < ActiveRecord::Migration[5.1]
  def change
    create_table "objectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.references :user, foreign_key: true
      t.string "auth"
      t.datetime "set_date"
      t.string "overview"
      t.text "details"
      t.datetime "due_date"
      t.text "goal"
      t.decimal "goal_amount"
      t.decimal "current_amount"
      t.string "unit"
      t.string "obj_state"
      t.text "comment"
      t.integer "points"
      t.timestamps
    end
  end
end
