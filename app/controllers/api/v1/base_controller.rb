module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_client!

      private

      def authenticate_client!
        header = request.headers['Authorization']
        token  = header&.match(/^Bearer (.+)$/)&.captures&.first
        @current_client = Client.find_by(api_key: token)

        return if @current_client

        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end