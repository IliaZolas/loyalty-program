module Api
  module V1
    class RewardsController < BaseController
      def index
        user = @current_client.users.find(params[:user_id])
        render json: user.rewards.order(issued_at: :desc)
      end
    end
  end
end
