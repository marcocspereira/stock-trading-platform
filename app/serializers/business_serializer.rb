class BusinessSerializer < ActiveModel::Serializer
  attributes :id, :name, :total_shares, :available_shares

  belongs_to :owner
end
