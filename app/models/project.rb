class Project < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: ProjectTransition,
    initial_state: :draft
  ]
  include Stateable

  belongs_to :creator, class_name: "User", foreign_key: "user_id", inverse_of: :projects
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :project_transitions, inverse_of: :project, autosave: false, dependent: :destroy
  has_rich_text :description

  validates :title, presence: true
  validates :description, presence: true
  validates :deadline, presence: true

  def state_machine
    @state_machine ||= ProjectStateMachine.new(self, transition_class: ProjectTransition)
  end
end
