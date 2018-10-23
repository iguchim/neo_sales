class NoticeCommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destory]
  before_action :set_notice_comment, only: [:edit, :update]

  def new
    @notice_comment = NoticeComment.new
  end

  def create
    @notice_comment = NoticeComment.new(notice_comment_params)
    @notice_comment.user_id = current_user.id
    @notice_comment.notice_id = params[:notice_id]
 
    if @notice_comment.save
      flash[:success] = "コメントを登録しました。"
      redirect_to notice_path(params[:notice_id])

      if @notice_comment.notice.notice_scope == "管理者"
        UserMailer.with(user_id: @notice_comment.user_id, notice_comments: @notice_comment.comments,
              url: notice_url(@notice_comment.notice_id)).comment_to_admin.deliver_now
      elsif @notice_comment.notice.notice_scope == "全員"
        UserMailer.with(user_id: @notice_comment.user_id, notice_comments: @notice_comment.comments,
              url: notice_url(@notice_comment.notice_id)).comment_to_all.deliver_now
      end
    else
      flash[:danger] = "コメントを登録出来ませんでした。"
      render :new
    end
  end

  def update
    if (@notice_comment.notice.notice_scope) == "管理者" && (!current_user.admin)
      flash[:danger] = "アクセス出来ません。"
      redirect_to notices_url
    else
      if @notice_comment.update_attributes(notice_comment_params)
      flash[:success] = "情報を更新しました。"
      redirect_to notice_path(@notice_comment.notice_id)
      else
        flash[:danger] = "情報を更新出来ませんでした。"
        render :edit
      end
    end
  end

  def edit
    if (@notice_comment.notice.notice_scope) == "管理者" && (!current_user.admin)
      flash[:danger] = "アクセス出来ません。"
      redirect_to notices_url
    end
  end

  def destroy
    comment = NoticeComment.find(params[:id])
    if comment.nil?
      flash[:danger] = "コメントを削除出来ません。"
    else
      comment.destroy
      flash[:success] = "コメントを削除しました。"
    end
    redirect_to notice_path(comment.notice_id)
  end

  private

  def notice_comment_params
    params.require(:notice_comment)
          .permit(NoticeComment::REGISTRABLE_ATTRIBUTES)
  end

  def set_notice_comment
    @notice_comment = NoticeComment.find(params[:id])
  end

end