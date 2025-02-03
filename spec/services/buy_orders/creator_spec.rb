require 'rails_helper'

RSpec.describe "BuyOrders::Creator", type: :service do
  let(:user) { create(:user) }
  let(:business) { create(:business) }
  let(:params) { { quantity: 10, price: 100 } }

  describe "#initialize" do
    it "assigns current_user, business_id, and params" do
      creator = BuyOrders::Creator.new(user, business.id, params)
      aggregate_failures do
        expect(creator.instance_variable_get(:@user)).to eq(user)
        expect(creator.instance_variable_get(:@business)).to eq(business)
        expect(creator.instance_variable_get(:@quantity)).to eq(params[:quantity])
        expect(creator.instance_variable_get(:@price)).to eq(params[:price])
      end
    end
  end

  describe "#call" do
    it "creates a new buy order" do
      creator = BuyOrders::Creator.new(user, business.id, params)
      buy_order = creator.call
      aggregate_failures do
        expect(buy_order).to be_persisted
        expect(buy_order.business).to eq(business)
        expect(buy_order.buyer).to eq(user)
      end
    end
  end
end