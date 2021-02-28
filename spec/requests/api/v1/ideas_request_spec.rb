require 'rails_helper'

RSpec.describe "Api::V1::Ideas", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/ideas/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/ideas/create"
      expect(response).to have_http_status(:success)
    end
  end

end
