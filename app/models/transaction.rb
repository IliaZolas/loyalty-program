class Transaction < ApplicationRecord
  belongs_to :user
  
  has_one :points_event,
        class_name:  "PointsEvent",
        foreign_key: "transaction_id",
        dependent:   :destroy

  validates :amount_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :country_code, presence: true
  validates :occurred_at,  presence: true
end
