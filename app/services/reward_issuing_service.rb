class RewardIssuingService
    def initialize(user, transaction)
        @user        = user
        @transaction = transaction
    end

    def call
        issued = []
        issued += issue_monthly_coffee   
        issued << issue_birthday_coffee  if birthday_month?
        issued << issue_new_user_movie   if new_user_spend_condition?
        issued.flatten.compact
    end 

    private

    def monthly_points_threshold_met?
        month_range = @transaction.occurred_at.beginning_of_month..@transaction.occurred_at.end_of_month

        current_points = @user.points_events
                            .joins(:purchase)  
                            .where(transactions: { occurred_at: month_range })
                            .sum(:points)

        current_points >= 100
    end

    def issue_monthly_coffee
        month_range = @transaction.occurred_at.beginning_of_month..@transaction.occurred_at.end_of_month

        total_pts = @user.points_events
                        .joins(:purchase)
                        .where(transactions: { occurred_at: month_range })
                        .sum(:points)

        coffees_should = (total_pts / 100).floor

        coffees_issued = @user.rewards
                                .where(reward_type: :free_coffee, issued_at: month_range)
                                .count

        new_coffees = []
        ((coffees_should - coffees_issued).clamp(0, Float::INFINITY)).times do
            new_coffees << create_reward(:free_coffee, "100 Points Coffee")
        end
        
        new_coffees
    end

    def birthday_month?
        @user.birthday&.month == @transaction.occurred_at.month
    end

    def issue_birthday_coffee
        return if already_issued?(:birthday_coffee, scope: :birthday_month)

        create_reward(:birthday_coffee, "Birthday Coffee")
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
