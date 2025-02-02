
class Api::V1::BusinessesController < ApplicationController
  # GET /api/v1/businesses
  def index
    render json: Business.includes(:owner).available, each_serializer: BusinessSerializer
  end
end
