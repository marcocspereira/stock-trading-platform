require 'rails_helper'

RSpec.describe "POST /api/v1/businesses/:business_id/buy_orders", type: :request do
  let(:endpoint) { "/api/v1/businesses/#{business.id}/buy_orders" }
  let(:user) { create(:user) }
  let(:business) { create(:business) }
  let(:buy_order) { create(:buy_order, business: business, buyer: user) }
  let(:params) { { buy_order: { quantity: 10, price: 100 } } }

  before { post endpoint, headers: headers, params: params }

  context "when the user is not authenticated" do
    let(:headers) { {} }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    let(:headers) { auth_headers(user) }

    context 'when parameters are missing' do
      let(:params) { {} }

      it 'returns a 422 unprocessable entity error' do
        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['error']).to eq("Invalid parameters")
        end
      end
    end

    context 'when user is the owner of the business' do
      let(:headers) { auth_headers(business.owner) }

      it 'returns a 422 unprocessable entity error' do
        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['error']).to eq("You are not the owner of this business")
        end
      end
    end

    context 'when the business is not available' do
      let(:headers) { auth_headers(user) }
      let(:business) { create(:business, available_shares: 0) }
      it 'returns a 422 unprocessable entity error' do
        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['error']).to eq("Business is not available")
        end
      end
    end

    context 'when the quantity is invalid' do
      let(:headers) { auth_headers(user) }
      let(:params) { { buy_order: { quantity: -1, price: 100 } } }

      it 'returns a 422 unprocessable entity error' do
        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['error']).to eq("Invalid quantity")
        end
      end
    end

    context 'when the parameters are valid' do
      let(:headers) { auth_headers(user) }
      let(:params) { { buy_order: { quantity: 10, price: 100 } } }

      it 'returns a 201 created status' do
        aggregate_failures do
          expect(response).to have_http_status(:created)
          expect(json_response['id']).to be_present
          expect(json_response['quantity']).to eq(params[:buy_order][:quantity])
          expect(json_response['price'].to_d).to eq(params[:buy_order][:price].to_d)
          expect(json_response['status']).to eq("pending")
          expect(json_response['business_id']).to eq(business.id)
          expect(json_response['buyer_id']).to eq(user.id)
        end
      end
    end
  end
end
