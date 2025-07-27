module Api
    module V1
        class TransactionsController < BaseController
            def create
                user = @current_client.users.find(params[:user_id])
                tx   = user.transactions.create!(transaction_params)

                points_event = PointsEarningService.new(tx).call

                # issue rewards (may be 0..3 new rewards)
                new_rewards = ::RewardIssuingService.new(user, tx).call

                render json: {
                        points_awarded: points_event.points,
                        total_points: user.points_events.sum(:points),
                        dollars_spent: user.transactions.sum(:amount_cents) / 100.0,
                        rewards: new_rewards.map { |r| { 
                            type: r.reward_type, 
                            reason: r.reason,
                            issued_at: r.issued_at 
                            } }
                        },
                        status: :created
            end

            private

            def transaction_params
                params.require(:transaction).permit(
                    :amount_cents,
                    :country_code,
                    :occurred_at
                )
            end
        end
    end
end
    