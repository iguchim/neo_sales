class CreateNoticeComment < ActiveRecord::Migration[5.1]
  def change
    create_table :notice_comments, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.datetime :comment_date
      t.text :comments
      t.references :notice
      t.references :user
    end
  end
end
