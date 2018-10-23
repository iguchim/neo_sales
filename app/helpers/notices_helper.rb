
module NoticesHelper

  def no_notice_comments?(notice_id, user_id)
    current_user.id == user_id && !NoticeComment.find_by(notice_id: notice_id) ? true : false
  end

end