module DailyReportsHelper
  def no_details?(report_id, user_id)
    current_user.id == user_id && !DailyReportDetail.find_by(daily_report_id: report_id) ? true : false
  end
end