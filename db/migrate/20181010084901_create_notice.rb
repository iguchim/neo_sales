class CreateNotice < ActiveRecord::Migration[5.1]
  def change
    create_table :notices, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.datetime :notice_date
      t.text :contents
      t.text :notices
      t.references :notice_category
      t.datetime :start_date
      t.datetime :end_date
      t.references :user
      t.string :notice_scope
    end
  end
end
