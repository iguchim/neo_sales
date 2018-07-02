class AddColToDailyReport < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_reports, :state, :string
    add_reference :daily_reports, :auth, foreign_key: { to_table: :users}
  end
end
