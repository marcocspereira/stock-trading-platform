RSpec.shared_examples "an unauthorized request" do
  it "returns an unauthorized response" do
    aggregate_failures do
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("Access denied")
    end
  end
end
