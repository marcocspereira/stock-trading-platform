require 'rails_helper'

RSpec.describe Business, type: :model do
  it 'has a valid factory' do
    expect(build(:business)).to be_valid
  end

  it { should belong_to(:owner) }
  it { should have_many(:buy_orders) }
  it { should have_many(:transactions) }

  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:total_shares).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:available_shares).only_integer.is_greater_than_or_equal_to(0) }

  describe "#is_available?" do
    let(:business) { create(:business, available_shares: 100) }

    it "returns true if the business has available shares" do
      expect(business.is_available?).to be_truthy
    end
  end

  describe "#pending_shares" do
    let(:business) { create(:business, available_shares: 100) }
    let!(:buy_order) { create(:buy_order, business: business, quantity: 50) }

    it "returns the number of pending shares" do
      expect(business.pending_shares).to eq(50)
    end
  end

  describe "#remaining_shares" do
    let(:business) { create(:business, available_shares: 100) }
    let!(:buy_order) { create(:buy_order, business: business, quantity: 50) }

    it "returns the number of remaining shares" do
      expect(business.remaining_shares).to eq(50)
    end
  end
end
