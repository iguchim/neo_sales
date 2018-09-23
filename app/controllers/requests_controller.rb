class RequestsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :show]
  before_action :set_request, only: [:edit, :update]

  def index
    #@requests = Form::Request.joins(:user)
    #                    .select('requests.*, users.name as name')
    @search_params = {}

    if !params[:user_id].blank?
      @search_params[:user_id] = params[:user_id].to_i
    else
      @search_params[:user_id] = nil
    end

    if !params[:auth_state].blank?
      @search_params[:auth_state] = params[:auth_state]
    else
      @search_params[:auth_state] = nil
    end

    if !params[:search].blank?
      @search_params[:search] = params[:search]
    else
      @search_params[:search] = nil
    end

    if @search_params[:user_id].nil? && @search_params[:auth_state].nil? && @search_params[:search].nil?
      @requests = Form::Request.joins(:user)
                        .select('requests.*, users.name as name')
    else
      @requests = search_results(@search_params)
    end

  end

  def show
    @request = (Form::Request.joins(:user)
                        .select('requests.*, users.name as name')
                        .where('requests.id = ?', params[:id])
                        .to_a)[0]

    @request_items = Form::RequestItem.joins(:request)
                        .select('request_items.*')
                        .where('request_items.request_id = ?', @request.id)
#binding.pry
  end

  def new
    # @request = Request.new
    @request = Form::Request.new
    if params[:order_id]
      @request.order_id = params[:order_id]
    end
    #@request.request_items.build
  end

  def create
    # @request = current_user.requests.build(request_params)
    @request = Form::Request.new(request_params)
    @request.user_id = current_user.id
    @request.state = "下書"
 
    if @request.save
      flash[:success] = "出張申請を登録しました。"
      #redirect_to :back  <--- not working
      #redirect_to requests_url
      redirect_to request_path(@request)
    else
      #flash[:danger] = "出張申請を登録出来ませんでした。"
      render :new
    end

  end

  def update
    if @request.update_attributes(request_params)
      flash[:success] = "出張申請を更新しました。"
      #redirect_to requests_path
      redirect_to request_path(@request)
    else
      #flash[:danger] = "出張申請を更新出来ませんでした。"
      render :edit
    end
#inding.pry
  end

  def edit
    @request = Form::Request.find(params[:id])
    if !@request.auth_id.nil? && !current_user.admin
      flash[:danger] = "出張申請が承認された為編集出来ません。"
      redirect_to request_path(@request)
    end
  end

  def destroy
    request = Form::Request.find(params[:id])
    if request.auth_id.nil? && request.user_id == current_user.id
      request.request_items.each do |item|
        item.destroy
      end
      request.destroy
      flash[:success] = "出張申請を削除しました。"
    else
      flash[:danger] = "出張申請が承認された為削除出来ません。"
    end
    redirect_to requests_url
  end

  def auth
    if !current_user.admin
      flash[:danger] = "管理者ではないので、承認出来ません。"
    else
      @request = Request.find(params[:id])
      if @request.auth_id.nil? 
        @request.auth_id = current_user.id
        UserMailer.with(user_id: @request.user_id, auth_id: @request.auth_id,
            url: request_url(@request)).notice_from_auth.deliver_now
          flash[:success] = "承認メールを送信しました。"
      else
        UserMailer.with(user_id: @request.user_id, auth_id: @request.auth_id,
            url: request_url(@request)).decline_from_auth.deliver_now
          flash[:success] = "承認取消メールを送信しました。"
        @request.auth_id = nil
      end
      @request.save
    end

    redirect_to request_path(params[:id])
  end

  def state
    @request = Request.find(params[:id])
    if @request.auth_id.nil? && @request.user_id == current_user.id
      if @request.state == "下書"
        @request.state = "申請"
        UserMailer.with(user_id: @request.user_id,
          url: request_url(@request)).notice_from_user.deliver_now
        flash[:success] = "申請メールを送信しました。"
      else
        @request.state = "下書"
        UserMailer.with(user_id: @request.user_id,
          url: request_url(@request)).decline_from_user.deliver_now
        flash[:success] = "取消メールを送信しました。"
      end
      @request.save
    end
    redirect_to request_path(params[:id])
  end

  private

  def set_request
    @request = Form::Request.find(params[:id])
  end

  def request_params
    # params.require(:request).permit(:start, :end, :state, :region, :req_date)
    params.require(:form_request)
          .permit(Form::Request::REGISTRABLE_ATTRIBUTES +
            [request_items_attributes: Form::RequestItem::REGISTRABLE_ATTRIBUTES])
  end

  def search_results(items)

    if items[:search].blank?
      requests = Form::Request.joins(:user)
                       .select('requests.*, users.name as name')
    else
      requests = search_string(items[:search])
    end

    requests = search_auth(requests, items[:auth_state])


    if !items[:user_id].blank?
      requests = requests.where('user_id = ?', items[:user_id])
    else
      requests
    end

  end

  def search_string(item)

    res_ids = []
    requests = Request.search(item)
    requests.each do |elem|
      res_ids << elem.id
    end

    req_items = RequestItem.search(item)
    req_items.each do |elem|
      res_ids << elem.request_id
    end

    reports = Report.search(item)
    reports.each do |elem|
      res_ids << elem.request_id
    end

    rep_items = ReportItem.search(item)
    rep_items.each do |elem|
      res_ids << elem.report.request_id
    end

    res_ids.uniq!

    Form::Request.joins(:user)
                        .select('requests.*, users.name as name')
                        .where('requests.id IN (?)', res_ids)
  end

  def search_auth(requests, auth_state)

    if auth_state.blank?
      return requests
    end

    res_ids = []
    requests.each do |elem|
      if (elem.auth_id.nil? && auth_state == "未承認") || (!elem.auth_id.nil? && auth_state == "承認") 
        res_ids << elem.id
      elsif !elem.report.nil?
        if (elem.report.auth_id.nil? && auth_state == "未承認") || (!elem.report.auth_id.nil? && auth_state == "承認")
          res_ids << elem.id
        end
      end
    end

    Form::Request.joins(:user)
                        .select('requests.*, users.name as name')
                        .where('requests.id IN (?)', res_ids)

  end

end