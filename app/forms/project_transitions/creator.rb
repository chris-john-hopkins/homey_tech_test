module ProjectTransitions
  class Creator
    include ActiveModel::Model
    attr_accessor :project, :creator, :to_state

    validates :project, presence: true
    validates :creator, presence: true
    validates :to_state, presence: true

    def save
      return false unless valid?

      begin
        ActiveRecord::Base.transaction do
          project.transition_to!(to_state)
          project.comments.create!(
            body: project_comment_body,
            creator:,
            auto_generated: true
          )
        end

        true
      rescue ActiveRecord::RecordInvalid => e
        errors.add(:base, "Comment creation failed: #{e.record.errors.full_messages.join(', ')}")
        false
      rescue Statesman::TransitionFailedError => e
        errors.add(:base, "State transition failed: #{e.message}")
        false
      end
    end

    private

    def project_comment_body
      I18n.t("project_comments.project_transition_created_automated_body", status: to_state.gsub("_", " "))
    end
  end
end
