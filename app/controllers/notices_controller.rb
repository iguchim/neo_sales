class NoticesController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :show, :destory]
  before_action :set_notice, only: [:show, :edit, :update]

  def index
    if current_user.admin
      @notices = Notice.all
    else
      @notices = Notice.where('notice_scope <> "管理者"')
    end
  end

  def show
    if (@notice.notice_scope) == "管理者" && (!current_user.admin)
      flash[:danger] = "アクセス出来ません。"
      redirect_to notices_url
    else
      @notice_comments = NoticeComment.joins(:notice)
                          .select('notice_comments.*')
                          .where('notice_comments.notice_id = ?', @notice.id)
    end
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)
    @notice.user_id = current_user.id
 
    if @notice.save
      flash[:success] = "情報を登録しました。"

      if @notice.notice_scope == "管理者"
        UserMailer.with(user_id: @notice.user_id, notice_contents: @notice.contents,
              url: notice_url(@notice)).info_to_admin.deliver_now
      elsif @notice.notice_scope == "全員"
        UserMailer.with(user_id: @notice.user_id, notice_contents: @notice.contents,
              url: notice_url(@notice)).info_to_all.deliver_now
      end
        
      redirect_to notice_path(@notice)
    else
      flash[:danger] = "情報を登録出来ませんでした。"
      render :new
    end
  end

  def update
    if (@notice.notice_scope) == "管理者" && (!current_user.admin)
      flash[:danger] = "アクセス出来ません。"
      redirect_to notices_url
    else
      if @notice.update_attributes(notice_params)
      flash[:success] = "情報を更新しました。"
      redirect_to notice_path(@notice)
      else
        flash[:danger] = "情報を更新出来ませんでした。"
        render :edit
      end
    end
  end

  def edit
    if (@notice.notice_scope) == "管理者" && (!current_user.admin)
      flash[:danger] = "アクセス出来ません。"
      redirect_to notices_url
    end
  end

  def destroy
    notice = Notice.find(params[:id])
    if NoticeComment.find_by(notice_id: notice.id) || (notice.user_id != current_user.id)
      flash[:danger] = "情報を削除出来ません。"
    else
      notice.destroy
      flash[:success] = "情報を削除しました。"
    end
    redirect_to notices_url
  end

private

  def notice_params
    params.require(:notice)
          .permit(Notice::REGISTRABLE_ATTRIBUTES)
  end

  def set_notice
    @notice = Notice.find(params[:id])
  end

end