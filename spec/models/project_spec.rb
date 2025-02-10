require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "associations" do
    it { should belong_to(:creator).class_name("User").with_foreign_key("user_id") }
    it { should have_rich_text(:description) }
  end

  describe "validations" do
    let(:user) { create(:user) }
    let(:subject) { build(:project, creator: user) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:deadline) }

    it "is valid with a creator" do
      expect(subject).to be_valid
    end

    it "is invalid without a creator" do
      project = build(:project, creator: nil)
      expect(project).not_to be_valid
      expect(project.errors[:creator]).to include("must exist")
    end
  end
end
