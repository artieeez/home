require "rails_helper"

RSpec.describe "Pages", type: :request do
  it "renders the home page" do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Artur Webber")
  end

  it "renders the about page" do
    get about_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("About")
  end
end
