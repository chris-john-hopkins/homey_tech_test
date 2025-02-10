class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :creator, class_name: "User", foreign_key: "user_id", inverse_of: :comments
  has_rich_text :body

  validate :body_must_have_content

  after_create_commit -> { broadcast_append_to commentable, target: "#{commentable.class.name.downcase}_comments" }

  private

  def body_must_have_content
    content = body.to_plain_text
    if content.blank? || content.strip.empty?
      errors.add(:body, "must contain some content")
    end
  end
end
