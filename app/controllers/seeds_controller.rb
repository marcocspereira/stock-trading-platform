# coverage: skip
class SeedsController < ApplicationController

  skip_before_action :authenticate_user, only: [:run]

  def run
    Rails.application.load_seed
    render json: { message: "Seed data has been successfully run." }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

end