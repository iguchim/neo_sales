class ReportItem < ApplicationRecord
  belongs_to :report, required: false

  validates :report_id,  presence: true
  validates :place,  presence: true
  validates :visit,  presence: true
  validates :personnel,  presence: true
  validates :information,  presence: true

  def self.search(item)
    if !item.blank?
      ReportItem.where(["place LIKE ? OR visit LIKE ? OR personnel LIKE ? OR information  LIKE ? OR notes LIKE ? OR comment LIKE ?", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%"]) 
    end
  end
end