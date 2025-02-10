class ProjectStateMachine
  include Statesman::Machine

  state :draft, initial: true
  state :in_progress
  state :completed

  transition from: :draft, to: [ :in_progress, :completed ]
  transition from: :in_progress, to: [ :draft, :completed ]
  transition from: :completed, to: [ :draft, :in_progress ]
end
