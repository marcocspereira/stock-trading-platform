require 'rails_helper'

RSpec.describe "GET /api/v1/businesses", type: :request do
  let(:endpoint) { "/api/v1/businesses" }
  let(:buyer) { create(:user) }
  let(:owner) { create(:user) }
  let!(:businesses_available) { create_list(:business, 3, available_shares: 100, owner: owner) }
  let!(:businesses_unavailable) { create_list(:business, 2, available_shares: 0, owner: owner) }

  subject(:request_call) { get endpoint, headers: headers }

  context "when the user is not authenticated" do
    let(:headers) { {} }

    before { request_call }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    let(:response_ids) { json_response.pluck('id') }

    before { request_call }

    context "when the user is a buyer" do
      let(:headers) { auth_headers(buyer) }

      it "returns the businesses available for the buyer" do
        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response_ids).to match_array(businesses_available.pluck(:id))
          expect(response_ids).not_to include(businesses_unavailable.pluck(:id))
        end
      end
    end

    context "when the user is an owner" do
      let(:headers) { auth_headers(owner) }

      it "does not return own businesses" do
        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response_ids).not_to include(businesses_available.pluck(:id))
          expect(response_ids).not_to include(businesses_unavailable.pluck(:id))
        end
      end
    end
  end
end
