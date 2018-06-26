class OrdersController < ApplicationController
  before_action :auth_user?, only: [:new, :create, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show]
  before_action :set_order, only: [:edit, :update]

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.auth_id = current_user.id
    if @order.save
      flash[:success] = "出張指示を登録し、営業にメールを送信しました。"
      UserMailer.with(user_id: @order.user_id, auth_id: @order.auth_id,
          url: order_url(@order)).order_from_auth.deliver_now
      #redirect_to :back  <--- not working
      redirect_to orders_url
    else
      flash[:danger] = "出張指示を登録出来ませんでした。"
      render :new
    end
  end

  def update
    if @order.update_attributes(order_params)
      flash[:success] = "出張指示を更新しました。"
      #redirect_to requests_path
      redirect_to order_path(@order)
    else
      flash[:danger] = "出張指示を更新出来ませんでした。"
      render :edit
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def destroy
    order = Order.find(params[:id])
    if Request.find_by(order_id: order.id)
      flash[:danger] = "指示は既に出張申請されているので、削除出来ません。"
    else
      order.destroy
      flash[:success] = "指示は削除され、営業にメールを送信しました。"
      UserMailer.with(user_id: order.user_id, auth_id: order.auth_id).order_delete.deliver_now
    end
    redirect_to orders_url
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
      params.require(:order).permit(
        :user_id, :start, :end, :state, :place, :visit,
        :personnel, :purpose, :notes, :auth_id, :order_date)
  end

end