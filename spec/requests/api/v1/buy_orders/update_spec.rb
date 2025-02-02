require 'rails_helper'

RSpec.describe "PUT /api/v1/buy_orders/:id", type: :request do
  let(:endpoint) { "/api/v1/buy_orders/#{buy_order.id}" }
  let(:buy_order) { create(:buy_order) }

  context "when the user is not authenticated" do
    let(:headers) { {} }

    before { put endpoint, headers: headers, params: {} }

    it_behaves_like "an unauthorized request"
  end

  context "when the user is authenticated" do
    before { put endpoint, headers: headers, params: params }

    context 'when the user is not the buyer or the owner of the business that the order is for' do
      let(:headers) { auth_headers(create(:user)) }
      let(:params) { { buy_order: { quantity: 10, price: 100 } } }

      it 'returns an error' do
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']).to eq("User not authorized to update this buy order")
      end
    end

    context 'when the user is the one who made the order' do
      let(:headers) { auth_headers(buy_order.buyer) }

      context 'when one of the params is negative' do
        let(:params) { { buy_order: { quantity: -1, price: -100 } } }

        it 'returns an error' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['error']).to eq("Invalid input(s), check: quantity, price")
          expect(buy_order.reload.quantity).not_to eq(params[:buy_order][:quantity])
          expect(buy_order.reload.price).not_to eq(params[:buy_order][:price])
        end
      end

      context 'when it wants to update the values of the order' do
        let(:params) { { buy_order: { quantity: 10, price: 100 } } }

        it 'updates the values of the order' do
          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(buy_order.reload.quantity).to eq(params[:buy_order][:quantity])
            expect(buy_order.reload.price).to eq(params[:buy_order][:price])
          end
        end
      end
    end

    context 'when the user is the owner of the business that the order is for' do
      let(:headers) { auth_headers(buy_order.business.owner) }

      context 'when it wants to approve a pending order' do
        let(:business) { create(:business, available_shares: 1000, total_shares: 1000) }
        let(:buy_order) { create(:buy_order, business: business, status: 'pending') }
        let(:params) { { buy_order: { status: 'approved' } } }
        let(:prev_available_shares) { business.available_shares }

        it 'updates the status of the order, the available shares of the business and creates a transaction' do
          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(buy_order.reload.status).to eq(params[:buy_order][:status])
            expect(json_response['status']).to eq(params[:buy_order][:status])
            expect(buy_order.business.reload.available_shares).to eq(prev_available_shares - buy_order.quantity)
            expect(Transaction.count).to eq(1)
          end
        end
      end

      context 'when it wants to reject a pending order' do
        let(:buy_order) { create(:buy_order, status: 'pending') }
        let(:params) { { buy_order: { status: 'rejected' } } }

        it 'updates the status of the order and does not update the available shares of the business neither creates a transaction' do
          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(buy_order.reload.status).to eq(params[:buy_order][:status])
            expect(json_response['status']).to eq(params[:buy_order][:status])
            expect(buy_order.business.reload.available_shares).to eq(buy_order.business.available_shares)
            expect(Transaction.count).to eq(0)
          end
        end
      end

      context 'when it wants to approve/reject a non-pending order' do
        let(:buy_order) { create(:buy_order, status: [ 'approved', 'rejected' ].sample) }
        let(:params) { { buy_order: { status: [ 'approved', 'rejected' ].sample } } }

        it 'returns an error' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['error']).to eq("Buy order must be pending")
        end
      end

      context 'when it wants to update the values of the order' do
        let(:params) { { buy_order: { quantity: 10, price: 100 } } }

        it 'is not allowed' do
          aggregate_failures do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json_response['error']).to eq("Invalid params/status for business owner")
          end
        end
      end
    end
  end
end
