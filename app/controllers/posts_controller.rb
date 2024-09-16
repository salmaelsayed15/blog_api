class PostsController < ApplicationController
  before_action :authenticate_request # , only: [ :index, :show ]
  before_action :set_post, only: [:show, :update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  before_action :authorize_post_owner, only: [:update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  def index
    @posts = Post.all
    if @posts.empty?
      render json: { message: "No posts available." }, status: :ok
    else
      render json: @posts, status: :ok
    end
  end

  def show
    render json: @post
    #  @post = Post.find(params[:id])
  end

  def create
    post = @current_user.posts.build(post_params)
    if post.tags.blank?
      render json: { error: "Post must have at least one tag" }, status: :unprocessable_entity
    elsif post.save
      # Here we schedule the deletion of the post after 24 hours using Sidekiq
      # DeletePostJob.set(wait: 24.hours).perform_later(post.id)
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # # Update post tags
  # def update_tags
  #   if @post.user_id == @current_user.id
  #     @post.update(tags: tag_params[:tags])
  #     render json: { message: "Tags updated successfully" }, status: :ok
  #   else
  #     render json: { error: "Unauthorized" }, status: :unauthorized
  #   end
  # end

  def destroy
    if @post.destroy
      head :no_content
    else
      render json: { errors: "Failed to delete post" }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
    unless @post
      render json: { error: "Post not found" }, status: :not_found
    end
  end


  def post_params
    params.require(:post).permit(:title, :body, tags: []) # Ensure you have validation for tags in the model as well
  end                                                   #  add :[] right after tags if you need many tags, check with posts.rb model

  def authorize_post_owner
    unless @post.user_id == @current_user.id
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
