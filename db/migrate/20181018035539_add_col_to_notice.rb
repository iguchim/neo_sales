class AddColToNotice < ActiveRecord::Migration[5.1]
  def change
    add_column :notices, :all_day, :boolean
  end
end
