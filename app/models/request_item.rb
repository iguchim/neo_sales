class RequestItem < ApplicationRecord
  #belongs_to :request, inverse_of: :request_items, autosave: true
  #belongs_to :request, optional: true
  belongs_to :request, required: false # This is work-around for rails 5

  #validates :request_id,  presence: true
  validates :place,  presence: true
  validates :visit,  presence: true
  validates :purpose,  presence: true

  def self.search(item)
    if !item.blank?
      RequestItem.where(["place LIKE ? OR visit LIKE ? OR personnel LIKE ? OR purpose  LIKE ? OR notes LIKE ? OR comment LIKE ?", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%", "%#{item}%"]) 
    end
  end
end