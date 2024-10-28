class PostsController < ApplicationController
  def index
    @posts = Post.order(updated_at: :desc)
    if params[:author_name].present?
      @posts = @posts.by_author_name(params[:author_name])
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params.merge(user_id: session[:user_id]))

    if @post.save()
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user_id != session[:user_id]
      redirect_to @post
    end
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def update
    @post = Post.find(params[:id])

    if @post.user_id == session[:user_id]
      if @post.update(post_params)
        redirect_to @post
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @post
    end
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def destroy
    @post = Post.find(id: params[:id])
    if @post.user_id == session[:user_id]
      @post.destroy
    end
    redirect_to root_path, status: :see_other
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
