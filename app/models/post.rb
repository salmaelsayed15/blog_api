class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy # if the post got deleted, all its commented will get deleted

  # Serialize tags as an array but store it as a string in the database
  # serialize :tags, Array          # if you want to have multiple tags enable these lines

  validates :tags, presence: true, length: { minimum: 1, message: "must have at least one tag" }
  validates :title, :body, presence: true

  # Ensure tags default to an empty array if none are provided
  # before_save :ensure_tags_array

  # Schedule deletion after creating a post
  after_create :schedule_deletion

  # private
  # def ensure_tags_array
  #   self.tags ||= []
  # end

  def schedule_deletion
    PostDeletionWorker.perform_at(24.hours.from_now, id)
  end
end
