class Business < ApplicationRecord
  has_many :buy_orders
  has_many :transactions
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :name, presence: true
  validates :total_shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :available_shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
