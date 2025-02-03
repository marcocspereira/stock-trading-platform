require 'rails_helper'

# Index all buy orders, available for all users
RSpec.describe "GET /api/v1/buy_orders", type: :request do
  let(:endpoint) { "/api/v1/buy_orders" }
  let(:user) { create(:user) }
  let!(:buy_orders) do
    create_list(:buy_order, 3, buyer: user) # her/his buy orders
    create_list(:buy_order, 3) # other buy orders
  end

  context "when the user is not authenticated" do
    let(:headers) { {} }

    before { get endpoint, headers: headers, params: {} }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    let(:headers) { auth_headers(user) }

    before { get endpoint, headers: headers, params: {} }

    it "returns all her/his buy orders" do
      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(3)
        json_response.each do |buy_order|
          expect(buy_order['buyer_id']).to eq(user.id)
        end
      end
    end
  end
end

# Index all buy orders for a business, only available for owners
RSpec.describe "GET /api/v1/businesses/:business_id/buy_orders", type: :request do
  let(:endpoint) { "/api/v1/businesses/#{business.id}/buy_orders" }
  let(:user) { create(:user) }
  let!(:business) { create(:business, owner: user) }
  let!(:buy_orders) do
    create_list(:buy_order, 3, business: business) # buy orders for h
    create_list(:buy_order, 3) # other buy orders
  end

  context "when the user is not authenticated" do
    let(:headers) { {} }

    before { get endpoint, headers: headers, params: {} }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    let(:headers) { auth_headers(user) }

    before { get endpoint, headers: headers, params: {} }

    it "returns all buy orders for her/his business" do
      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(3)
        json_response.each do |buy_order|
          expect(buy_order['business_id']).to eq(business.id)
        end
      end
    end

    context 'when the business is not found' do
      let(:invalid_id) { 999999 }
      let(:endpoint) { "/api/v1/businesses/#{invalid_id}/buy_orders" }

      it 'returns a not found error' do
        aggregate_failures do
          expect(response).to have_http_status(:not_found)
          expect(json_response['error']).to eq("Couldn't find Business with 'id'=#{invalid_id}")
        end
      end
    end
  end
end
