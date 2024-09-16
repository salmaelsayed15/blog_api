class CommentsController < ApplicationController
  before_action :authenticate_request  # Ensure user is authenticated via JWT
  before_action :set_post           # Find the post for the comments
  before_action :set_comment, only: [ :update, :destroy ]  # Find comment before editing or deleting
  before_action :authorize_comment_owner, only: [ :update, :destroy ] # Ensure user owns the comment

  # List all comments for a given post
  def index
    comments = @post.comments
    if comments.empty?
      render json: { message: "No comments found" }, status: :ok
    else
      render json: comments, status: :ok
    end
  end

  # Create a comment on a post
  def create
    comment = @post.comments.build(comment_params)
    comment.user = @current_user  # Set current user as the comment author
    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Update a comment (only if the user is the author)
  def update
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete a comment (only if the user is the author)
  def destroy
    @comment.destroy
    render json: { message: "Comment was deleted successfully" }, status: :ok
  end

  private

  # Strong parameters for comment creation and updating
  def comment_params
    params.require(:comment).permit(:body)
  end

  # Set the post for which comments are being created or managed
  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end

  # Set the comment for updating or deletion
  def set_comment
    @comment = @post.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comment not found" }, status: :not_found
  end

  # Ensure that only the owner of the comment can update or delete it
  def authorize_comment_owner
    if @comment.user_id != @current_user.id
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
