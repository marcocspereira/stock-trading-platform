# == Schema Information
#
# Table name: buy_orders
#
#  id          :integer          not null, primary key
#  buyer_id    :integer          not null
#  business_id :integer          not null
#  quantity    :integer          not null
#  price       :decimal(10, 2)   not null
#  status      :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_buy_orders_on_business_id  (business_id)
#  index_buy_orders_on_buyer_id     (buyer_id)
#

require 'rails_helper'

RSpec.describe BuyOrder, type: :model do
  it 'has a valid factory' do
    expect(build(:buy_order)).to be_valid
  end

  it { should belong_to(:buyer) }
  it { should belong_to(:business) }

  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than(0) }
  it { should validate_inclusion_of(:status).in_array(%w[pending approved rejected]) }

  describe "#pending?" do
    let(:buy_order) { create(:buy_order, status: 'pending') }

    it "returns true if the buy order is pending" do
      expect(buy_order.pending?).to be_truthy
    end
  end

  describe "#approve!" do
    let(:buy_order) { create(:buy_order, status: 'pending') }

    it "updates the status to approved" do
      buy_order.approve!
      expect(buy_order.status).to eq('approved')
    end
  end

  describe "#reject!" do
    let(:buy_order) { create(:buy_order, status: 'pending') }

    it "updates the status to rejected" do
      buy_order.reject!
      expect(buy_order.status).to eq('rejected')
    end
  end
end
