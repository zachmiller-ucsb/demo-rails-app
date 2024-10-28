class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    @post = Post.find_by(params[:post_id])
    if @post.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
    @comment = @post.comments.create(comment_params.merge(user_id: session[:user_id]))
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find_by(params[:post_id])
    if @post.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
    @comment = @post.comments.find_by(params[:id])
    if !@comment.nil?
      if @comment.user_id == session[:user_id]
        @comment.destroy
      end
    end
    redirect_to post_path(@post), status: :see_other
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
