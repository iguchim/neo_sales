
class DailyReportsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :show]
  before_action :set_daily_report, only: [:edit, :update]

  def index
    @daily_search_params = {}

    if !params[:user_id].blank?
      @daily_search_params[:user_id] = params[:user_id].to_i
    else
      @daily_search_params[:user_id] = nil
    end

    if !params[:category_id].blank?
      @daily_search_params[:category_id] = params[:category_id].to_i
    else
      @daily_search_params[:category_id] = nil
    end 

    if !params[:action_id].blank?
      @daily_search_params[:action_id] = params[:action_id].to_i
    else
      @daily_search_params[:action_id] = nil
    end 

    if !params[:auth_state].blank?
      @daily_search_params[:auth_state] = params[:auth_state]
    else
      @daily_search_params[:auth_state] = nil
    end

    if !params[:search].blank?
      @daily_search_params[:search] = params[:search]
    else
      @daily_search_params[:search] = nil
    end

    if @daily_search_params[:user_id].nil? && @daily_search_params[:auth_state].nil? && 
      @daily_search_params[:search].nil? && @daily_search_params[:category_id].nil? &&
      @daily_search_params[:action_id].nil?
      @daily_reports = DailyReport.order("report_date DESC")
    else
      @daily_reports = search_results(@daily_search_params)
    end
  end

  

  def show
    @daily_report = DailyReport.find(params[:id])

    @daily_report_details = DailyReportDetail.joins(:daily_report)
                        .select('daily_report_details.*')
                        .where('daily_report_details.daily_report_id = ?', @daily_report.id)
  end

  def new
    # @request = Request.new
    @daily_report = DailyReport.new
  end

  def create
    @daily_report = DailyReport.new(daily_report_params)
    @daily_report.user_id = current_user.id
    @daily_report.state = "下書"
 
    if @daily_report.save
      flash[:success] = "日報を登録しました。"
      redirect_to daily_report_path(@daily_report)
    else
      flash[:danger] = "日報を登録出来ませんでした。"
      render :new
    end
  end

  def update
    if @daily_report.update_attributes(daily_report_params)
      flash[:success] = "日報を更新しました。"
      redirect_to daily_report_path(@daily_report)
    else
      flash[:danger] = "日報を更新出来ませんでした。"
      render :edit
    end
  end

  def edit
    #@daily_report = DailyReport.find(params[:id])
    if !@daily_report.auth_id.nil? && !current_user.admin
      flash[:danger] = "日報が確認された為編集出来ません。"
      redirect_to daily_report_path(@daily_report)
    end
  end

  def destory
    daily_report = DailyReport.find(params[:id])
    if daily_report.auth_id.nil? && daily_report.user_id == current_user.id
      daily_report.daily_report_details.each do |item|
        item.destroy
      end
      daily_report.destroy
      flash[:success] = "日報申請を削除しました。"
    else
      flash[:danger] = "日報申請が確認された為削除出来ません。"
    end
    redirect_to daily_report_url
  end

  def auth
    return unless current_user.admin
    @daily_report = DailyReport.find(params[:id])
   if @daily_report.auth_id.nil? 
      @daily_report.auth_id = current_user.id
      UserMailer.with(user_id: @daily_report.user_id, auth_id: @daily_report.auth_id,
          url: daily_report_url(@daily_report)).notice_from_daily_auth.deliver_now
        flash[:success] = "確認メールを送信しました。"
    else
      UserMailer.with(user_id: @daily_report.user_id, auth_id: @daily_report.auth_id,
          url: daily_report_url(@daily_report)).decline_from_daily_auth.deliver_now
        flash[:success] = "確認取消メールを送信しました。"
      @daily_report.auth_id = nil
    end
    @daily_report.save

    redirect_to daily_report_path(params[:id])
  end

  def state
    @daily_report = DailyReport.find(params[:id])
    if @daily_report.auth_id.nil? && @daily_report.user_id == current_user.id
      if @daily_report.state == "下書"
        @daily_report.state = "申請"
        UserMailer.with(user_id: @daily_report.user_id,
          url: daily_report_url(@daily_report)).notice_from_daily_user.deliver_now
        flash[:success] = "申請メールを送信しました。"
      else
        @daily_report.state = "下書"
        UserMailer.with(user_id: @daily_report.user_id,
          url: daily_report_url(@daily_report)).decline_from_daily_user.deliver_now
        flash[:success] = "取消メールを送信しました。"
      end
      @daily_report.save
    end
    redirect_to daily_report_path(params[:id])
  end

  private

  def search_results(items)

    reports = DailyReport.order("report_date DESC")

    
    reports = search_string(reports, items[:search])

    reports = search_auth(reports, items[:auth_state])

    if !items[:user_id].blank?
      reports = reports.where('user_id = ?', items[:user_id])
    end

    reports = search_category(reports, 'category_id = ?', items[:category_id])

    reports = search_category(reports, 'action_id = ?', items[:action_id])

  end

  def search_string(reports, item)

    if item.blank?
      return reports
    end

    res_ids = []

    reports.each do |report|
      details = report.daily_report_details.search(item)
      details.each do |elem|
        res_ids << elem.daily_report_id
      end
    end

    res_ids.uniq!

    reports.where('id IN (?)', res_ids)
  end

  def search_category(reports, category_str, category_id)

    if category_id.blank?
      return reports
    end

    res_ids = []

    reports.each do |report|
      details = report.daily_report_details.where(category_str, category_id)
      details.each do |elem|
        res_ids << elem.daily_report_id
      end
    end

    res_ids.uniq!

    reports.where('id IN (?)', res_ids)

  end

  def search_auth(reports, auth_state)

    if auth_state.blank?
      return reports
    end

    res_ids = []
    reports.each do |elem|
      if (elem.auth_id.nil? && auth_state == "未確認") || (!elem.auth_id.nil? && auth_state == "確認") 
        res_ids << elem.id
      end
    end

    DailyReport.where('id IN (?)', res_ids)

  end

  def set_daily_report
    @daily_report = DailyReport.find(params[:id])
  end

  def daily_report_params
    params.require(:daily_report)
          .permit(DailyReport::REGISTRABLE_ATTRIBUTES +
            [daily_report_details_attributes: DailyReportDetail::REGISTRABLE_ATTRIBUTES])
  end
  
end