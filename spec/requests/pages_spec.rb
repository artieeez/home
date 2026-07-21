require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "renders the home page" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Artur Webber")
      expect(response.body).to include(about_path)
    end
  end

  describe "GET /about" do
    it "renders the about page" do
      get about_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("About")
      expect(response.body).to include(root_path)
    end
  end
end
