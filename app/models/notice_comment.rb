class NoticeComment < ApplicationRecord
  #REGISTRABLE_ATTRIBUTES = %i(id comment_date comments notice_id user_id)
  REGISTRABLE_ATTRIBUTES = %i(comment_date comments notice_id user_id)
  belongs_to :notice
  belongs_to :user

  validates :comment_date,  presence: true
  validates :comments,  presence: true
  validates :notice_id,  presence: true
  validates :user_id,  presence: true

end
