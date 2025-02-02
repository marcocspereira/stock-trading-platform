require 'rails_helper'

RSpec.describe "DELETE /api/v1/buy_orders/:id", type: :request do
  let(:endpoint) { "/api/v1/buy_orders/#{buy_order.id}" }
  let(:user) { create(:user) }
  let(:business) { create(:business) }

  context "when the user is not authenticated" do
    let(:headers) { {} }
    let(:buy_order) { create(:buy_order, business: business, buyer: user) }

    before { delete endpoint, headers: headers, params: {} }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    let(:headers) { auth_headers(user) }

    before { delete endpoint, headers: headers, params: {} }

    context 'when the buy order is pending' do
      let(:buy_order) { create(:buy_order, business: business, buyer: user, status: 'pending') }

      it 'deletes the buy order' do
        aggregate_failures do
          expect(response).to have_http_status(:no_content)
          expect(BuyOrder.count).to eq(0)
        end
      end
    end

    context 'when the buy order is not pending' do
      let(:buy_order) { create(:buy_order, business: business, buyer: user, status: 'approved') }

      it 'does not delete the buy order' do
        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(BuyOrder.count).to eq(1)
        end
      end
    end
  end
end
