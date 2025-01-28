# == Schema Information
#
# Table name: buy_orders
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
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
#  index_buy_orders_on_user_id      (user_id)
#

class BuyOrder < ApplicationRecord
  belongs_to :user
  belongs_to :business

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected] }
end
