class ProjectTransition < ApplicationRecord
  belongs_to :project, inverse_of: :project_transitions
end
