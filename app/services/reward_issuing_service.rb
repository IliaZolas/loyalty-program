class RewardIssuingService
    def initialize(user, transaction)
        @user        = user
        @transaction = transaction
    end

    def call
        issued = []
        issued << issue_monthly_coffee   if monthly_points_threshold_met?
        issued << issue_birthday_coffee  if birthday_month?
        issued << issue_new_user_movie   if new_user_spend_condition?
        issued.compact
    end 

    private

    def monthly_points_threshold_met?
        month_start = @transaction.occurred_at.beginning_of_month
        month_end   = @transaction.occurred_at.end_of_month

        current_points = @user.points_events
                            .where(created_at: month_start..@transaction.occurred_at)
                            .sum(:points)

        current_points >= 100
    end

    def issue_monthly_coffee
        return if already_issued?(:free_coffee, scope: :monthly)

        create_reward(:free_coffee, "100 Points Coffee")
    end

    def birthday_month?
        @user.birthday&.month == @transaction.occurred_at.month
    end

    def issue_birthday_coffee
        return if already_issued?(:free_coffee, scope: :birthday_month)

        create_reward(:free_coffee, "Birthday Coffee")
    end

    def new_user_spend_condition?
        first_tx_date = @user.transactions.order(:occurred_at).first.occurred_at
        within_60d    = first_tx_date >= 60.days.ago
        total_spent   = @user.transactions
                            .where(occurred_at: first_tx_date..@transaction.occurred_at)
                            .sum(:amount_cents)

        within_60d && total_spent > 1_000_00  # cents
    end

    def issue_new_user_movie
        return if already_issued?(:movie_ticket, scope: :new_user)

        create_reward(:movie_ticket, "$1000 spent within 60 days of first transaction")
    end

    # Helpers

    def already_issued?(type, scope:)
        case scope
        when :monthly
        # same month
        @user.rewards
            .where(reward_type: type)
            .where(issued_at: @transaction.occurred_at.beginning_of_month..@transaction.occurred_at.end_of_month)
            .exists?
        when :birthday_month
        # same month & year
        @user.rewards
            .where(reward_type: type)
            .where("EXTRACT(MONTH FROM issued_at) = ? AND EXTRACT(YEAR FROM issued_at) = ?",
                    @transaction.occurred_at.month,
                    @transaction.occurred_at.year)
            .exists?
        when :new_user
        @user.rewards.where(reward_type: type).exists?
        else
        false
        end
    end

    def create_reward(type, reason)
        @user.rewards.create!(
            reward_type: type, 
            issued_at: Time.current,
            reason: reason
        )
    end
end
