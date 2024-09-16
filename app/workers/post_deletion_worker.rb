# app/workers/post_deletion_worker.rb
class PostDeletionWorker
  include Sidekiq::Worker

  def perform(post_id)
    post = Post.find_by(id: post_id)
    post.destroy if post
  end
end
