class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :price, :quantity, :created_at

  def created_at
    object.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
