class Reward < ApplicationRecord
  belongs_to :user

  validates :reward_type, presence: true
  validates :issued_at,   presence: true

  enum reward_type: {
    free_coffee:   "free_coffee",
    movie_ticket:  "movie_ticket"
  }
end
