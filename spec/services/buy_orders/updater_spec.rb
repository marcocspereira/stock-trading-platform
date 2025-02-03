require 'rails_helper'

RSpec.describe "BuyOrders::Updater", type: :service do
  let(:user) { create(:user) }

  describe "#build" do
    context "when the user is the business owner" do
      let(:business) { create(:business, owner: user) }
      let(:buy_order) { create(:buy_order, business: business, buyer: user) }

      it "returns a StatusUpdater" do
        expect(BuyOrders::UpdaterService.build(buy_order, user)).to be_a(BuyOrders::StatusUpdater)
      end
    end

    context "when the user is the buy order buyer" do
      let(:buy_order) { create(:buy_order, buyer: user) }
      let(:business) { buy_order.business }

      it "returns a ValueUpdater" do
        expect(BuyOrders::UpdaterService.build(buy_order, user)).to be_a(BuyOrders::ValueUpdater)
      end
    end

    context "when the user is neither the business owner nor the buy order buyer" do
      let(:buy_order) { create(:buy_order) }
      let(:user) { create(:user) }

      it "raises an error" do
        expect { BuyOrders::UpdaterService.build(buy_order, user) }.to raise_error(ForbiddenActionError)
      end
    end
  end
end
