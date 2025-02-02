class Api::V1::TransactionsController < ApplicationController
  # GET /api/v1/businesses/:business_id/transactions
  # Index all transactions for a business, for all users
  def index
    transactions = Business.includes(:transactions).find(params[:business_id]).transactions
    render json: transactions, each_serializer: TransactionSerializer
  end
end
