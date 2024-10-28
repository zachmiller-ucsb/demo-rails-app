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
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if !@post.nil?
      @post.destroy
    end

    redirect_to root_path, status: :see_other
  end

  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
