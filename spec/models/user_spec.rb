# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a password' do
    expect(build(:user, password_digest: nil)).to be_invalid
  end

  it { should have_many(:owned_businesses).class_name('Business').with_foreign_key('owner_id') }
  it { should have_many(:buy_orders) }
  it { should have_many(:transactions) }
end
