class ObjectiveDetail < ApplicationRecord
  REGISTRABLE_ATTRIBUTES = %i(id objective_id exec_date contents amount comment auth_id _destroy)
  belongs_to :objective, required: false
  #belongs_to :category

  #validates :objective_id,  presence: true
  validates :exec_date,  presence: true
  validates :contents,  presence: true
  validates :amount,  presence: true
  validates :amount, numericality: true
end
