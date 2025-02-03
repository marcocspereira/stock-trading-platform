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

class User < ApplicationRecord
  has_secure_password

  has_many :owned_businesses, class_name: "Business", foreign_key: "owner_id", dependent: :destroy  
  has_many :buy_orders, class_name: "BuyOrder", foreign_key: "buyer_id", dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
