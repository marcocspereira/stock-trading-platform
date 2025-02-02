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

class BuyOrder < ApplicationRecord
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id"
  belongs_to :business

  before_validation :set_pending_status, on: :create

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected] }

  scope :pending, -> { where(status: "pending") }
  scope :approved, -> { where(status: "approved") }
  scope :rejected, -> { where(status: "rejected") }

  VALID_ACTIONS = {
    "approved" => :accept,
    "rejected" => :reject
  }.freeze

  def pending?
    status == "pending"
  end

  def approve!
    return unless pending?

    update!(status: "approved")
  end

  def reject!
    return unless pending?

    update!(status: "rejected")
  end

  private

  def set_pending_status
    self.status = "pending" if self.status.blank?
  end
end
