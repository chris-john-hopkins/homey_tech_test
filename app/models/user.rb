class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, foreign_key: "user_id", inverse_of: :creator
  has_many :comments, foreign_key: "user_id", inverse_of: :creator
end
