class Order < ApplicationRecord
  #has_one :request

  validates :purpose, presence: true
  validates :order_date, presence: true
  validates :user_id, presence: true
  validates :auth_id, presence: true

end