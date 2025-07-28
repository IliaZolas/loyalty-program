class TransactionsController < ApplicationController
    before_action :authenticate_user!

    def create
        tx = current_user.transactions.create!(
        amount_cents: transaction_params[:amount_cents].to_i,
        country_code: transaction_params[:country_code],
        occurred_at:  transaction_params[:occurred_at].presence || Time.current
        )

        points_event  = PointsEarningService.new(tx).call
        new_rewards   = RewardIssuingService.new(current_user, tx).call

        flash[:points_awarded] = points_event.points
        flash[:total_points]   = current_user.points_events.sum(:points)
        flash[:new_rewards]    = new_rewards.map { |r| { 
            type: r.reward_type, 
            issued_at: r.issued_at.iso8601, 
            reason: r.try(:reason) 
            } }

        redirect_to authenticated_root_path
    end

    private

    def transaction_params
        params.require(:transaction).permit(:amount_cents, :country_code, :occurred_at)
    end
end
