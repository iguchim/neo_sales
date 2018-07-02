class DailyReport < ApplicationRecord
  REGISTRABLE_ATTRIBUTES = %i(user_id report_date)
  has_many :daily_report_details, dependent: :destroy
  belongs_to :user

  validates :user_id,  presence: true
  validates :report_date,  presence: true

  accepts_nested_attributes_for :daily_report_details, allow_destroy: true

end