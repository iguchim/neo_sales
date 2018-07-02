module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "ネオテック営業"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def is_member(user_id)
  	!(ReferenceUser.find_by(refer_id: current_user.id, referred_id: user_id).nil?)
  end

  def order_status(order_id)
    status = []
    request = Request.find_by(order_id: order_id)
    if request.nil?
      status[0] = "未"
    else
      report = Report.find_by(request_id: request.id)
      if report
        status[0] = "報告"
        status[1] = request.id
        status[2] = report.id
      else
        status[0] = "申請"
        status[1] = request.id
      end
    end
    status  
  end

  def from_daily_report_index?

    params = Rails.application.routes.recognize_path(request.referrer)
    if params[:controller] == "daily_reports" && params[:action] == "index"
      true
    else
      false
    end

  end

end
