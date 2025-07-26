class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  belongs_to :client, optional: true

  has_many :transactions,  dependent: :destroy
  has_many :points_events, dependent: :destroy
  has_many :rewards,       dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
