require 'rails_helper'

RSpec.describe "BuyOrders::Destroyer", type: :service do
  let(:user) { create(:user) }
  let(:business) { create(:business) }
  let(:buy_order) { create(:buy_order, business: business, buyer: user) }
  describe "#initialize" do
    it "assigns buy_order_id and current_user" do
      destroyer = BuyOrders::Destroyer.new(buy_order.id, user)
      aggregate_failures do
        expect(destroyer.instance_variable_get(:@buy_order)).to eq(buy_order)
        expect(destroyer.instance_variable_get(:@current_user)).to eq(user) 
      end
    end
  end

  describe "#call" do
    it "destroys the buy order" do
      destroyer = BuyOrders::Destroyer.new(buy_order.id, user)
      destroyer.call
      expect(BuyOrder.exists?(buy_order.id)).to be_falsey
    end
  end
end
