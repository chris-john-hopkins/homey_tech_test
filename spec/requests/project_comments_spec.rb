require "rails_helper"

RSpec.describe "ProjectComments", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, creator: user) }

  before do
    sign_in user, scope: :user
  end

  describe "POST /projects/:project_id/comments" do
    context "with valid parameters" do
      let(:valid_params) { { comment: { body: "This is a valid comment" } } }

      it "creates a new comment and returns a turbo stream response" do
        expect {
          post project_comments_path(project), params: valid_params, headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.to change(project.comments, :count).by(1)

        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("turbo-stream")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { comment: { body: "" } } }

      it "does not create a comment and returns a turbo stream response with errors" do
        expect {
          post project_comments_path(project), params: invalid_params, headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.not_to change(project.comments, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("comment_form")
      end
    end
  end
end
