require 'rails_helper'

RSpec.describe PointsEarningService, type: :service do
  let(:client) { Client.create!(name: 'TestClient') }
  let(:user) do
    User.create!(
      email: 'user@example.com',
      password: 'password123',
      client: client,
      home_country_code: 'US'
    )
  end
  let(:time) { Time.current }

  describe '#call' do
    context 'base points calculation' do
      it 'awards 0 points for spend under $100' do
        tx = Transaction.create!(user: user, amount_cents: 9_999, country_code: 'US', occurred_at: time)
        event = PointsEarningService.new(tx).call
        expect(event.points).to eq(0)
      end

      it 'awards 10 points for $100 spend' do
        tx = Transaction.create!(user: user, amount_cents: 10_000, country_code: 'US', occurred_at: time)
        event = PointsEarningService.new(tx).call
        expect(event.points).to eq(10)
      end

      it 'floors partial hundreds' do
        tx = Transaction.create!(user: user, amount_cents: 14_999, country_code: 'US', occurred_at: time)
        event = PointsEarningService.new(tx).call
        expect(event.points).to eq(10)
      end
    end

    context 'foreign spend logic' do
      it 'doubles points when spent outside home country' do
        tx = Transaction.create!(user: user, amount_cents: 10_000, country_code: 'CA', occurred_at: time)
        event = PointsEarningService.new(tx).call
        expect(event.points).to eq(20)
      end
    end
  end
end
