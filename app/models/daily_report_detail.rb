class DailyReportDetail < ApplicationRecord
  REGISTRABLE_ATTRIBUTES = %i(id daily_report_id customer personnel contents notes comment category_id _destroy)
  belongs_to :daily_report
  belongs_to :category

  validates :daily_report_id,  presence: true
  validates :customer,  presence: true
  validates :personnel,  presence: true
  validates :contents,  presence: true

  def self.search(item)
    if !item.blank?
      DailyReportDetail.where(["customer LIKE ? OR personnel LIKE ? OR contents  LIKE ? OR notes LIKE ? OR comment LIKE ?", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%"]) 
    end
  end

end