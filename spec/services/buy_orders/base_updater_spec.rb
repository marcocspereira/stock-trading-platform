require 'rails_helper'

RSpec.describe "BuyOrders::BaseUpdater", type: :service do
  let(:owner) { create(:user) }
  let(:buyer) { create(:user) }
  let(:business) { create(:business, owner: owner) }
  let(:buy_order) { create(:buy_order, business: business, buyer: buyer, status: 'pending') }
  let(:updater) { BuyOrders::BaseUpdater.new(buy_order, user) }

  describe "#initialize" do
    let(:user) { owner }

    it "assigns buy_order and user" do
      aggregate_failures do
        expect(updater.buy_order).to eq(buy_order)
        expect(updater.instance_variable_get(:@user)).to eq(user)
      end
    end

    it "initializes errors as an empty array" do
      expect(updater.errors).to eq([])
    end
  end

  describe "#call" do
    let(:user) { owner }

    it "raises NotImplementedError" do
      expect { updater.call({}) }.to raise_error(NotImplementedError, /must implement #call/)
    end
  end

  describe "#validate_pending!" do
    let(:user) { owner }

    context "when buy order is pending" do
      it "does not raise an error" do
        expect { updater.send(:validate_pending!) }.not_to raise_error
      end
    end

    context "when buy order is not pending" do
      before { buy_order.update(status: 'approved') }

      it "raises InvalidBuyOrderError" do
        expect { updater.send(:validate_pending!) }.to raise_error(InvalidBuyOrderError, "Buy order must be pending")
      end
    end
  end

  describe "#validate_owner!" do
    context "when user is the owner" do
      let(:user) { owner }

      it "does not raise an error" do
        expect { updater.send(:validate_owner!) }.not_to raise_error
      end
    end

    context "when user is not the owner" do
      let(:user) { buyer }

      it "raises ForbiddenActionError" do
        expect { updater.send(:validate_owner!) }.to raise_error(ForbiddenActionError, "Only the owner can update status")
      end
    end
  end

  describe "#validate_buyer!" do
    context "when user is the buyer" do
      let(:user) { buyer }

      it "does not raise an error" do
        expect { updater.send(:validate_buyer!) }.not_to raise_error
      end
    end

    context "when user is not the buyer" do
      let(:user) { owner }

      it "raises ForbiddenActionError" do
        expect { updater.send(:validate_buyer!) }.to raise_error(ForbiddenActionError, "Only the buyer can update values")
      end
    end
  end
end
