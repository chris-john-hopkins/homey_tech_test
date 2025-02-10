require "rails_helper"

RSpec.describe ProjectTransitions::Creator, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe "Validations" do
    it "is invalid without a project" do
      creator = described_class.new(project: nil, creator: user, to_state: "in_progress")
      expect(creator).not_to be_valid
      expect(creator.errors[:project]).to include("can't be blank")
    end

    it "is invalid without a creator" do
      creator = described_class.new(project: project, creator: nil, to_state: "in_progress")
      expect(creator).not_to be_valid
      expect(creator.errors[:creator]).to include("can't be blank")
    end

    it "is invalid without a to_state" do
      creator = described_class.new(project: project, creator: user, to_state: nil)
      expect(creator).not_to be_valid
      expect(creator.errors[:to_state]).to include("can't be blank")
    end
  end

  describe "#save" do
    context "when the transition is valid" do
      let(:creator) { described_class.new(project: project, creator: user, to_state: "in_progress") }

      it "transitions the project to the new state" do
        expect(project.state_machine).to receive(:transition_to!).with("in_progress")
        expect { creator.save }.to change { project.comments.count }.by(1)
      end

      it "creates an auto-generated comment" do
        allow(project.state_machine).to receive(:transition_to!).with("in_progress")
        expect { creator.save }.to change { project.comments.count }.by(1)
      end
    end

    context "when the transition is invalid" do
      let(:creator) { described_class.new(project: project, creator: user, to_state: "invalid_state") }

      it "does not create a comment" do
        expect { creator.save }.not_to change { project.comments.count }
      end

      it "adds an error to the model" do
        creator.save
        expect(creator.errors[:base]).to include("State transition failed: Cannot transition from 'draft' to 'invalid_state'")
      end
    end

    context "when comment creation fails" do
      let(:creator) { described_class.new(project: project, creator: user, to_state: "in_progress") }

      before do
        allow(project.comments).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(Comment.new), "Validation failed")
      end

      it "adds an error to the model" do
        creator.save
        expect(creator.errors[:base]).to include("Comment creation failed: ")
      end
    end
  end
end
