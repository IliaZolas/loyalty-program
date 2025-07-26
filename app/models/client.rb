class Client < ApplicationRecord
    has_secure_token :api_key
    has_many :users, dependent: :nullify
end
