require 'rails_helper'

RSpec.describe "GET /api/v1/businesses/:business_id/transactions", type: :request do
  let(:endpoint) { "/api/v1/businesses/#{business.id}/transactions" }
  let(:business) { create(:business) }
  let!(:transactions) { create_list(:transaction, 3, business: business) }
  let(:buyer) { create(:user) }
  let(:headers) { auth_headers(buyer) }

  subject(:request_call) { get endpoint, headers: headers }

  context "when the user is not authenticated" do
    let(:headers) { {} }

    before { request_call }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    before { request_call }

    it "returns the transactions for the business" do
      expect(response).to have_http_status(:ok)
      expect(json_response.pluck('id')).to match_array(transactions.pluck(:id))
      expect(json_response.map(&:keys)).to all(match_array(%w[id quantity price created_at]))
    end
  end
end
