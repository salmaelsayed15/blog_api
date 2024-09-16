class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy # When a user is deleted, all associated posts are also deleted
  has_many :comments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  # validates :password, presence: true, length: { minimum: 6 }
end
