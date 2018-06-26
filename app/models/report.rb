class Report < ApplicationRecord
  has_many :report_items, dependent: :destroy
  belongs_to :user
  belongs_to :request

  validates :user_id,  presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates :region, presence: true

  validate :start_end

  accepts_nested_attributes_for :report_items, allow_destroy: true

  def self.search(item)
    if !item.blank?
      Report.where('region LIKE ?', "%#{item}%")
    end
  end

  def start_end
    if self.start > self.end
      errors.add(:period, "で終了日が開始日より前です")
    end
  end

end