
class DailyReportsController < ApplicationController

  include ActionsHelper
  include CategoriesHelper
  include UsersHelper

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :show, :destory]
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

    if !params[:disp_state].blank?
      @daily_search_params[:disp_state] = params[:disp_state]
    else
      @daily_search_params[:disp_state] = nil
    end

    if @daily_search_params[:user_id].nil? && @daily_search_params[:auth_state].nil? && 
      @daily_search_params[:search].nil? && @daily_search_params[:category_id].nil? &&
      @daily_search_params[:action_id].nil?
      @daily_reports = DailyReport.order("report_date DESC")
    else
      @daily_reports = search_results(@daily_search_params)
    end

    @daily_reports = Kaminari.paginate_array(@daily_reports).page(params[:page])

    if @daily_search_params[:disp_state] == "詳細" && !params[:no_details]
      @daily_report_details_list = make_details_list(@daily_reports)
      render "daily_report_details/index"
      #redirect_to daily_report_details_path(daily_report_details_list: @daily_report_details_list.to_a)
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

  def destroy
    daily_report = DailyReport.find(params[:id])

    # if daily_report.auth_id.nil? && daily_report.user_id == current_user.id
    #   daily_report.daily_report_details.each do |item|
    #     item.destroy
    #   end
    #   daily_report.destroy
    #   flash[:success] = "日報申請を削除しました。"
    # else
    #   flash[:danger] = "日報申請が確認された為削除出来ません。"
    # end

    daily_report.destroy

    redirect_to daily_reports_url
  end

  def auth
    if !current_user.admin
      flash[:danger] = "管理者ではないので、承認出来ません。"
    else
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
    end

    redirect_to daily_report_path(params[:id])
  end

  def req_to
    if !current_user.admin
      flash[:danger] = "管理者ではないので、要求出来ません。"
    else
      @daily_report = DailyReport.find(params[:id])
      UserMailer.with(user_id: @daily_report.user_id, auth_id: current_user.id,
            url: daily_report_url(@daily_report)).request_to_daily_user.deliver_now
      flash[:success] = "返答要求メールを送信しました。"
    end
    redirect_to daily_report_path(params[:id])
  end

  def rep_from
    @daily_report = DailyReport.find(params[:id])
    UserMailer.with(user_id: @daily_report.user_id, 
          url: daily_report_url(@daily_report)).reply_from_daily_user.deliver_now
    flash[:success] = "返答完了メールを送信しました。"
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

  def chart

    @line_chart_params = {}
    l_u_id = nil
    l_cat_id = nil
    l_act_id = nil
    l_start = nil
    l_end = nil
    l_freq = nil

    if !params[:line_user_id].blank?
      l_u_id = params[:line_user_id].to_i
      @line_chart_params[:line_user_id] = l_u_id
    else
      @line_chart_params[:line_user_id] = nil
    end 

    if !params[:line_category_id].blank?
      l_cat_id = params[:line_category_id].to_i
      @line_chart_params[:line_category_id] = l_cat_id
    else
      @line_chart_params[:line_category_id] = nil
    end 

    if !params[:line_action_id].blank?
      l_act_id = params[:line_action_id].to_i
      @line_chart_params[:line_action_id] = l_act_id
    else
      @line_chart_params[:line_action_id] = nil
    end 

    if !params[:line_start].blank?
      l_start = params[:line_start]
      @line_chart_params[:line_start] = l_start
    else
      @line_chart_params[:line_start] = nil
    end 

    if !params[:line_end].blank?
      l_end = params[:line_end]
      @line_chart_params[:line_end] = l_end
    else
      @line_chart_params[:line_end] = nil
    end

    if !params[:line_freq].blank?
      l_freq = params[:line_freq]
      @line_chart_params[:line_freq] = l_freq
    else
      @line_chart_params[:line_freq] = nil
    end 

    @line_data = get_line_data(l_u_id, l_cat_id, l_act_id, l_start, l_end, l_freq)

    #@line_data = 
    # [{:name=>"伊藤", :data=>[["2018-7-1", 2], ["2018-7-8", 1], ["2018-7-15", 5]]},
    #  {:name=>"山本", :data=>[["2018-7-1", 2], ["2018-7-8", 3], ["2018-7-15", 4]]},
    #  {:name=>"塩原", :data=>[["2018-7-1", 5], ["2018-7-8", 5], ["2018-7-15", 0]]}]

    #--------------------------------------

    @chart_params = {}
    cat_id = nil
    act_id = nil
    if !params[:category_id].blank?
      cat_id = params[:category_id].to_i
      @chart_params[:category_id] = cat_id
    else
      @chart_params[:category_id] = nil
    end 

    if !params[:action_id].blank?
      act_id = params[:action_id].to_i
      @chart_params[:action_id] = act_id
    else
      @chart_params[:action_id] = nil
    end 

    @col_data = get_col_data(cat_id, act_id)

    @action_data = get_action_data
    @contents_data = get_contents_data

  end

  private


  def make_details_list(daily_reports)

    ids = []
    daily_reports.each do |report|
      ids << report.id
    end

    deatail_str = ""
    if @daily_search_params[:action_id] && @daily_search_params[:category_id]
      deatail_str = "daily_report_details.action_id = #{@daily_search_params[:action_id]} AND daily_report_details.category_id = #{@daily_search_params[:category_id]} AND "
    elsif @daily_search_params[:action_id]
      deatail_str = "daily_report_details.action_id = #{@daily_search_params[:action_id]} AND "
    elsif @daily_search_params[:category_id]
      deatail_str = "daily_report_details.category_id = #{@daily_search_params[:category_id]} AND "
    end


    sel_deatails = DailyReportDetail.joins(:daily_report)
                        .select('daily_report_details.*, daily_reports.*')
                        .where(deatail_str + "daily_report_details.daily_report_id in (?)", ids)
                        .order("report_date DESC")

    if @daily_search_params[:search].nil?
      sel_deatails
    else
      sel_deatails = sel_deatails.search(@daily_search_params[:search])
    end

  end

  def get_line_data(u_id, cat_id, act_id, s_str, e_str, f_str)

    sql_str_arr = []
    cnt = 0
    if !u_id.nil?
      sql_str_arr[cnt] = "user_id = #{u_id}"
      cnt += 1
    end
    if !cat_id.nil?
      sql_str_arr[cnt] = "category_id = #{cat_id}"
      cnt += 1
    end
    if !act_id.nil?
      sql_str_arr[cnt] = "action_id = #{act_id}"
      cnt += 1
    end

    sql_str = nil
    sql_str_arr.each do |sql|
      if sql_str.nil?
        sql_str = sql
      else
        sql_str = sql_str + " AND " + sql
      end
    end

    period_str = "report_date BETWEEN " + "'" + "#{s_str}" + "'" + " AND " + "'" + "#{e_str}" + "'"
    if sql_str.nil?
      sql_str = period_str
    else
      sql_str = sql_str + " AND " + period_str
    end

    raw_data = DailyReportDetail.joins(:daily_report)
                        .where(sql_str)

    if f_str == "月"
      line_data = raw_data.group(:user_id).group_by_month(:report_date, week_start: :mon).count
    else
      line_data = raw_data.group(:user_id).group_by_week(:report_date, week_start: :mon).count
    end

    line_data.each do |key, value|
      key[0] = user_name(key[0])
    end

    line_data

  end

  def get_col_data(cat_id, act_id)

    if cat_id.nil? && act_id.nil?
      where_str = nil
      group_ids = [:user_id]
    elsif !cat_id.nil? && act_id.nil?
      where_str = "category_id = #{cat_id}"
      group_ids = [:user_id, :action_id]
    elsif cat_id.nil? && !act_id.nil?
      where_str = "action_id = #{act_id}"
      group_ids = [:user_id, :category_id]
    else
      where_str = "action_id = #{act_id} AND category_id = #{cat_id}"
      group_ids = [:user_id]
    end

    raw_data = DailyReportDetail.joins(:daily_report)
                        .where(where_str)
                        .group(group_ids)
                        .order('count_all')
                        .count

    make_col_data(raw_data, group_ids)

  end

  def make_col_data(raw_data, group_ids)
    if group_ids.count == 1
      make_single_col_data(raw_data)
    else
      make_multi_col_data(raw_data, group_ids[1])
    end
  end

  def make_single_col_data(raw_data)  
    col_data = {}
    #User.all.each do |user|
    #s_users = sales_users
    sales_users.each do |user|
      if user.admin
        next
      end
      val = raw_data[user.id]
      if val.nil?
        val = 0
      end
      col_data[user.name] = val    
    end
    col_data
  end

  def make_multi_col_data(raw_data, group_id)
    col_data =[]
    i = 0
    if group_id == :action_id
      items = Action.all
    else
      items = Category.all
    end

    items.each do |item|
      col_data << {}
      col_data[i][:name] = item.name
      col_data[i][:data] = []
      #User.all.each do |user|
      sales_users.each do |user|
        if user.admin
          next
        end
        d = []
        d << user.name
        if raw_data[[user.id, item.id]].nil?
          d << 0
        else
          d << raw_data[[user.id, item.id]]
        end
        col_data[i][:data] << d
      end
      i += 1
    end
    col_data
  end

  def get_action_data
    action_data = {}
    #User.all.each do |user|
    sales_users.each do |user|
      if user.admin
        next
      end
      user_data = get_user_action_data(user.id)
      action_data[user.name] = user_data
    end
    action_data
  end

  def get_user_action_data(user_id)
    act_data = DailyReportDetail.joins(:daily_report)
                        .where('daily_reports.user_id = ?', user_id)
                        .group(:action_id)
                        .order('count_all')
                        .count
    make_action_data(act_data)                       
  end

  def make_action_data(actions)
    action_data = {}
    Action.all.each do |act|
      val = actions[act.id]
      if val.nil?
        val = 0
      end
      name = action_name_str(act.id)
      action_data[name] = val
    end
    action_data
  end


  def get_contents_data
    contents_data = {}
    #User.all.each do |user|
    sales_users.each do |user|
      if user.admin
        next
      end
      user_data = get_user_contents_data(user.id)
      contents_data[user.name] = user_data
    end
    contents_data
  end

  def get_user_contents_data(user_id)
    cont_data = DailyReportDetail.joins(:daily_report)
                        .where('daily_reports.user_id = ?', user_id)
                        .group(:category_id)
                        .order('count_all')
                        .count
    make_content_data(cont_data)
  end

  def make_content_data(contents)
    contents_data = {}
    Category.all.each do |cont|
      val = contents[cont.id]
      if val.nil?
        val = 0
      end
      name = category_name(cont.id)
      contents_data[name] = val
    end
    contents_data

  end


  def search_results(items)

    reports = DailyReport.order("report_date DESC")

    
    reports = search_string(reports, items[:search])

    reports = search_auth(reports, items[:auth_state])

    if !items[:user_id].blank?
      reports = reports.where('user_id = ?', items[:user_id])
    end

    if items[:category_id].nil? && items[:action_id].nil?
      return reports
    elsif !items[:category_id].nil? && !items[:action_id].nil?
      search_str = "category_id = #{items[:category_id]} AND action_id = #{items[:action_id]}"
    elsif !items[:category_id].nil?
      search_str = "category_id = #{items[:category_id]}"
    else
      search_str = "action_id = #{items[:action_id]}"
    end



    #reports = search_category(reports, 'category_id = ?', items[:category_id])
    reports = search_category(reports, search_str)

    #reports = search_category(reports, 'action_id = ?', items[:action_id])
    #reports = search_category(reports, "action_id = #{items[:action_id]}", items[:action_id])

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

  def search_category(reports, search_str)

    res_ids = []

    reports.each do |report|
      #details = report.daily_report_details.where(category_str, category_id)
      details = report.daily_report_details.where(search_str)
      details.each do |elem|
        res_ids << elem.daily_report_id
      end
    end

    res_ids.uniq!

    reports.where('id IN (?)', res_ids)
#binding.pry
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

    reports.where('id IN (?)', res_ids)

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