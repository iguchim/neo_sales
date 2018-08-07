class DailyReportDetailsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :show, :destory]

  def index
    #@daily_report_details_list = params[:daily_report_details_list]
  end

end
