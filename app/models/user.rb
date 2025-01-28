# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  role            :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_many :owned_businesses, class_name: 'Business', foreign_key: "owner_id"
  has_many :buy_orders
  has_many :transactions

  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :role, presence: true, inclusion: { in: %w[buyer owner] }

end
