require 'rails_helper'

RSpec.describe RewardIssuingService, type: :service do
    include ActiveSupport::Testing::TimeHelpers

    let(:client) { Client.create!(name: "TestClient") }
    let(:user) do
    User.create!(
        email:              "user@example.com",
        password:           "password123",
        client:             client,
        home_country_code:  "US",
        birthday:           Date.new(2000, 7, 1)
    )
    end
    let(:now) { Time.zone.parse("2025-07-15 12:00:00") }

    before do
    
    travel_to now
    end

    after do
    travel_back
    end

    describe '#call' do
    context 'monthly coffee' do
        it 'issues free coffee after 100 pts in the same month' do
    
        10.times do |i|
            tx = Transaction.create!(user: user, amount_cents: 10_000, country_code: 'US', occurred_at: now)
            PointsEarningService.new(tx).call
            
            new_rewards = RewardIssuingService.new(user, tx).call if i == 9
        end

        expect(user.rewards.where(reward_type: 'free_coffee').count).to eq(1)
        end
    end

    context 'birthday coffee' do
        it 'issues free coffee on a transaction in birthday month' do
        tx = Transaction.create!(user: user, amount_cents: 1_000, country_code: 'US', occurred_at: now)
        PointsEarningService.new(tx).call

        new_rewards = RewardIssuingService.new(user, tx).call
        expect(new_rewards.map(&:reward_type)).to include('birthday_coffee')
        end
    end

    context 'new user movie ticket' do
            it 'issues movie ticket after > $1000 within 60 days of first tx' do
            first_tx_time = now - 30.days
            user.update!(created_at: first_tx_time)

            Transaction.create!(user: user, amount_cents: 600_00, country_code: 'US', occurred_at: first_tx_time)
            PointsEarningService.new(user.transactions.last).call

            tx = Transaction.create!(user: user, amount_cents: 500_00, country_code: 'US', occurred_at: now)
            PointsEarningService.new(tx).call

            new_rewards = RewardIssuingService.new(user, tx).call
            expect(new_rewards.map(&:reward_type)).to include('movie_ticket')
            end
        end
    end
end
