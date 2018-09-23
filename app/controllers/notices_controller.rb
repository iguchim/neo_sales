class NoticesController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :show, :destory]
  before_action :set_notice, only: [:edit, :update]

  def index
  end

private

  def set_notice
    @notice = Notice.find(params[:id])
  end

end