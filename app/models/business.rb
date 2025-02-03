class Business < ApplicationRecord
  has_many :buy_orders, dependent: :destroy
  has_many :transactions, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  validates :name, presence: true
  validates :total_shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :available_shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :available, -> { where("available_shares > 0") }

  def is_available?
    available_shares > 0
  end

  def pending_shares
    buy_orders.pending.sum(:quantity)
  end

  def remaining_shares
    available_shares - pending_shares
  end
end
