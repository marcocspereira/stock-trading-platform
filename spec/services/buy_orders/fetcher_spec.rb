require 'rails_helper'

RSpec.describe "BuyOrders::Fetcher", type: :service do
  let(:business) { create(:business) }
  let(:buy_orders) { create_list(:buy_order, 3, business: business, buyer: user) }
  let(:params) { { business_id: business.id } }
  
  describe "#call" do
    context "when business_id is provided" do
      let(:user) { business.owner }
      it "returns all buy orders for the business owner" do
        expect(BuyOrders::Fetcher.call(params, user)).to eq(buy_orders)
      end
    end
    
    context "when business_id is not provided" do
      let(:user) { create(:user) }
      it "returns all buy orders for the user" do
        expect(BuyOrders::Fetcher.call(nil, user)).to eq(buy_orders)
      end
    end
    
  end
  
  
end