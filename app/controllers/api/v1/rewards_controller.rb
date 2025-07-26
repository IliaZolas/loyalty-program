module Api
  module V1
    class RewardsController < BaseController
      def index
        # temporary stub
        render json: { message: "Rewards#index hit!", user_id: params[:user_id] }
      end
    end
  end
end
