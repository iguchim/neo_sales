class AddColumnDailyReportDetail < ActiveRecord::Migration[5.1]
  def change
    add_reference :daily_report_details, :action
  end
end
