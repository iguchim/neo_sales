class Objective < ApplicationRecord
  REGISTRABLE_ATTRIBUTES = %i(user_id auth_id state set_date overview details due_date goal goal_amount current_amount unit obj_state comment points reducing)
  has_many :objective_details, dependent: :destroy
  belongs_to :user

  # paginates_per 5 not working

  validates :user_id,  presence: true
  validates :set_date,  presence: true
  validates :overview,  presence: true
  validates :details,  presence: true
  validates :due_date,  presence: true
  validates :goal,  presence: true
  validates :goal_amount, presence: true
  #validates :goal_amount, numericality: { greater_than: 0}
  validates :current_amount, numericality: true
  validates :unit,  presence: true

  accepts_nested_attributes_for :objective_details, allow_destroy: true

end
