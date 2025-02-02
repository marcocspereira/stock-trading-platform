class BuyOrderSerializer < ActiveModel::Serializer
  attributes :id, :buyer_id, :business_id, :quantity, :price, :status
end
