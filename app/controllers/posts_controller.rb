class PostsController < ApplicationController
  before_action :require_login, only: [ :new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
   @posts = Post.order(created_at: :desc).page(params[:page]).per(9)
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(create_post_params.except(:tag_names))
    if @post.save
      save_tags(@post, create_post_params[:tag_names])
      redirect_to post_path(@post), notice: "投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(update_post_params.except(:tag_names))
      save_tags(@post, update_post_params[:tag_names])
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private
   
  def create_post_params
    params.require(:post).permit(
      :title, :body, :place_name, :address, :rating, :latitude, :longitude, :tag_names, :category, :parking, :fee, images: []
    )
  end

  def update_post_params
    params.require(:post).permit(
      :title, :body, :place_name, :address, :latitude, :longitude, :tag_names, :category, :parking, :fee,  images: []
    )
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path, alert: "権限がありません"
    end
  end

  def save_tags(post, tag_names)
    normalized_tag_names = tag_names.to_s.tr("＃　", "# ")
    
    names = normalized_tag_names .scan(/#([^\s#]+)/) .flatten .map(&:strip) .reject(&:blank?) .uniq

    tags = names.map do |name|
      Tag.find_or_create_by!(name: name)
    end

    post.tags = tags
  end
end
