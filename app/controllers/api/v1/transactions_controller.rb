module Api
  module V1
    class TransactionsController < BaseController
      def create
        user = @current_client.users.find(params[:user_id])
        render json: { message: "Transactions#create hit!", user_id: params[:user_id] }
      end
    end
  end
end
    