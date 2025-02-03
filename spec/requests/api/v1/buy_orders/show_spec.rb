require 'rails_helper'

RSpec.describe "GET /api/v1/buy_orders/:id", type: :request do
  let(:endpoint) { "/api/v1/buy_orders/#{buy_order.id}" }
  let(:user) { create(:user) }
  let(:business) { create(:business) }
  let(:buy_order) { create(:buy_order, business: business, buyer: user) }

  context "when the user is not authenticated" do
    let(:headers) { {} }

    before { delete endpoint, headers: headers, params: {} }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    let(:headers) { auth_headers(user) }

    before { get endpoint, headers: headers, params: {} }

    context 'when the business is not found' do
      let(:invalid_id) { 999999 }
      let(:endpoint) { "/api/v1/buy_orders/#{invalid_id}" }

      it 'returns a not found error' do
        aggregate_failures do
          expect(response).to have_http_status(:not_found)
          expect(json_response['error']).to eq("Couldn't find BuyOrder with 'id'=#{invalid_id}")
        end
      end
    end

    context 'when the user is not the buyer or the owner of the business that the order is for' do
      let(:headers) { auth_headers(create(:user)) }

      it 'returns a forbidden error' do
        aggregate_failures do
          expect(response).to have_http_status(:forbidden)
          expect(json_response['error']).to eq("Forbidden access")
        end
      end
    end

    context 'when the user is the buyer or the owner of the business that the order is for' do
      let(:headers) { auth_headers(user) }

      it 'returns the buy order' do
        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(json_response['id']).to eq(buy_order.id)
        end
      end
    end
  end
end
