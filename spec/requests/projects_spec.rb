require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, creator: user) }

  before do
    sign_in user, scope: :user
  end

  describe "GET /index" do
    it "renders the index page successfully" do
      get projects_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Projects")
    end
  end

  describe "GET /show" do
    it "renders the show page successfully" do
      get project_path(project)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(project.title)
    end
  end
end
