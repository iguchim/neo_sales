class CreateNotices < ActiveRecord::Migration[5.1]
  def change
    create_table :notices do |t|
      t.text :contents
      t.string :link
      t.datetime :crate_date

      t.timestamps
    end
  end
end
