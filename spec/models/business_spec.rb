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

end
