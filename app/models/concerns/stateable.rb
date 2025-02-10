module Stateable
  extend ActiveSupport::Concern
  def current_state
    state_machine.current_state
  end
  def transition_to!(new_state)
    state_machine.transition_to!(new_state)
  end
  def transition_to(new_state)
    state_machine.transition_to(new_state)
  end
end
