class ReportsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :show]
  before_action :set_report, only: [:edit, :update]


  def show # !!! passed request_id instead of report_id as params[:id] !!!

    request = Form::Request.find(params[:request_id])
    if request.auth_id.nil?
      flash[:danger] = "出張申請が承認されていません。"
      redirect_to request_path(request)
      return
    end

    # If no report has been made, duplicate request
    if params[:request_id]
      make_report(params[:request_id])
    end

    @report = (Form::Report.joins(:user)
                        .select('reports.*, users.name as name')
                        .where('reports.request_id = ?', params[:request_id])
                        .to_a)[0]
#binding.pry

    @report_items = Form::ReportItem.joins(:report)
                        .select('report_items.*')
                        .where('report_items.report_id = ?', @report.id)
  end

  def update
    if !@report.auth_id.nil? && !current_user.admin
      flash[:danger] = "出張報告が承認された為編集出来ません。"
      redirect_to report_path(@report, :request_id => @report.request_id)
    elsif @report.update_attributes(report_params)
      flash[:success] = "出張報告を更新しました。"
      #redirect_to requests_path
      redirect_to report_path(@report, :request_id => @report.request_id)
    else
      #flash[:danger] = "出張報告を更新出来ませんでした。"
      render :edit
    end
  end

  def edit
    @report = Form::Report.find(params[:id])
    if !@report.auth_id.nil? && !current_user.admin
      flash[:danger] = "出張報告が承認された為編集出来ません。"
      redirect_to report_path(@report, :request_id => @report.request_id)
    end
  end

  def destroy
    @report = Form::Report.find(params[:id])
    if @report.auth_id.nil? && @report.user_id == current_user.id 
      #Form::Report.find(params[:id]).destroy
      @report.destroy
      flash[:success] = "出張報告を削除しました。"
    else
      flash[:danger] = "出張報告が承認された為削除出来ません。"
    end
    redirect_to requests_url
  end

  def auth
    if !current_user.admin
      flash[:danger] = "管理者ではないので、承認出来ません。"
    else
      @report = Report.find(params[:id])
      user_id = Request.find(@report.request_id).user_id
      if @report.auth_id.nil? 
        @report.auth_id = current_user.id
        UserMailer.with(user_id: user_id, auth_id: @report.auth_id,
            url: request_report_url(@report.request_id, @report)).notice_from_auth.deliver_now
          flash[:success] = "承認メールを送信しました。"
      else
        UserMailer.with(user_id: user_id, auth_id: @report.auth_id,
            url: request_report_url(@report.request_id, @report)).decline_from_auth.deliver_now
          flash[:success] = "承認取消メールを送信しました。"
        @report.auth_id = nil
      end
      @report.save
    end

    #redirect_to report_path(params[:id])
    redirect_to report_path(@report, :request_id => @report.request_id)
  end

  def state
    @report = Report.find(params[:id])
    if @report.auth_id.nil? && @report.user_id == current_user.id
      if @report.state == "下書"
        @report.state = "申請"
        UserMailer.with(user_id: @report.user_id,
          url: request_report_url(@report.request_id, @report)).notice_from_user.deliver_now
        flash[:success] = "申請メールを送信しました。"
      else
        @report.state = "下書"
        UserMailer.with(user_id: @report.user_id,
          url: request_report_url(@report.request_id, @report)).decline_from_user.deliver_now
        flash[:success] = "取消メールを送信しました。"
      end
      @report.save
    end
    #redirect_to report_path(params[:id])
    redirect_to report_path(@report, :request_id => @report.request_id)
  end

  private

  def set_report
    @report = Form::Report.find(params[:id])
  end

  def report_params
    params.require(:form_report)
          .permit(Form::Report::REGISTRABLE_ATTRIBUTES +
            [report_items_attributes: Form::ReportItem::REGISTRABLE_ATTRIBUTES])
  end

  def make_report(request_id)
    if !Form::Report.find_by(request_id: request_id)
      request = Form::Request.find(request_id)
      report = Form::Report.new
      report.report_items = []
      report.request_id = request.id
      report.user_id = request.user_id
      report.start = request.start
      report.end = request.end
      report.region = request.region
      report.rep_date = Date.today
      report.state = "下書"
      report.save#(:validate => false)
#binding.pry
      make_report_items(report.id, request_id)
    end
  end

  def make_report_items(report_id, request_id)
    request_items = (Form::RequestItem.where(request_id: request_id).all).to_a
    #request_items = Form::RequestItem.select('*')
    #                                 .where('request_items.request_id = request_id')
#binding.pry
    request_items.each do |item|
#binding.pry
      rep_item = Form::ReportItem.new
      rep_item.report_id = report_id
      rep_item.place = item.place
      rep_item.visit = item.visit
      rep_item.personnel = item.personnel
      rep_item.information = '[報告要記入]'
      rep_item.save#(:validate => false)
    end 
  end

end