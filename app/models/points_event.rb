class PointsEvent < ApplicationRecord
  belongs_to :user
  
  # rename the association to :purchase
  belongs_to :purchase,
             class_name:  "Transaction",
             foreign_key: "transaction_id",
             inverse_of:  :points_event

  validates :points,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
