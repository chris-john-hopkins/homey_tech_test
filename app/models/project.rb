class Project < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id", inverse_of: :projects
  has_rich_text :description

  validates :title, presence: true
  validates :description, presence: true
  validates :deadline, presence: true
end
