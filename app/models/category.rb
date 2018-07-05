class Category < ApplicationRecord
  #has_many :daily_report_detail
  validates :name,  presence: true
end
