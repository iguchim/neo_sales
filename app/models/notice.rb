class Notice < ApplicationRecord
  REGISTRABLE_ATTRIBUTES = %i(notice_date contents notes start_date end_date notice_category_id user_id notice_scope all_day)
  has_many :notice_comments, dependent: :destroy
  belongs_to :user

  validates :notice_date, presence: true
  validates :contents, presence: true
  validates :notice_category_id,  presence: true
  validates :user_id, presence: true
  validates :notice_scope, presence: true
  validates :all_day, inclusion: {in: [true, false]}
  validate :date_verify
  before_save :clear_date

  #accepts_nested_attributes_for :notice_comments, allow_destroy: true

  def date_verify
    if end_date && start_date.nil?
      errors.add(:end_date, "cannot only specify end date")
    elsif all_day && start_date.nil?
      errors.add(:all_day, "cannot specify without date")
    elsif (start_date && end_date) && (start_date > end_date)
      errors.add(:start_date, "cannot larger than end date")
    end
  end

  def clear_date
    ok = true
    if all_day
      if start_date
        temp = DateTime.new(start_date.year, start_date.month, start_date.day, 0, 0, 0, start_date.zone)
        self.start_date = temp
        #self.start_date.change(hour: 0, min: 0, sec: 0)
      else
        ok = false
      end
      if end_date
        temp = DateTime.new(end_date.year, end_date.month, end_date.day, 0, 0, 0, end_date.zone)
        self.end_date = temp
      end
    end
    #binding.pry
    ok
  end

end
