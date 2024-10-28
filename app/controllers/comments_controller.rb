class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params.merge(user_id: session[:user_id]))

    if @comment.save
      redirect_to post_path(@post)
    else
      @post = Post.includes(:comments).find(params[:post_id])
      render "posts/show", status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def destroy
    @post = Post.find(params[:post_id])

    @comment = @post.comments.find(params[:id])
    if @comment.user_id == session[:user_id]
      @comment.destroy
    end
    redirect_to post_path(@post), status: :see_other
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
