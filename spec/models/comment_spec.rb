require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe "Associations" do
    it { should belong_to(:commentable) }
    it { should belong_to(:creator).class_name("User").with_foreign_key("user_id") }
    it { should have_rich_text(:body) }
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      comment = Comment.new(commentable: project, creator: user, body: "Valid comment")
      expect(comment).to be_valid
    end

    it "is invalid without a body" do
      comment = Comment.new(commentable: project, creator: user, body: "")
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("must contain some content")
    end

    it "is invalid if the body is only spaces" do
      comment = Comment.new(commentable: project, creator: user, body: "   ")
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("must contain some content")
    end
  end
end
