class PointsEarningService
    def initialize(transaction)
        @transaction = transaction
        @user        = transaction.user
    end

    def call
        amount_cents = @transaction.amount_cents
        base_points  = ((amount_cents / 10000.0).floor * 10).to_i
        points       = foreign_spend? ? base_points * 2 : base_points

        PointsEvent.create!(
            purchase: @transaction,
            user:        @user,
            points:      points
        )
    end

    private

    def foreign_spend?
        @transaction.country_code != @user.home_country_code
    end
end
