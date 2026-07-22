class SearchesController < ApplicationController
  before_action :require_login

  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      @users = User.where(is_active: true).looks(@search, @word).page(params[:page]).per(10)
    elsif @range == "Post"
      @posts = Post.looks(@search, @word).page(params[:page]).per(9)
    elsif @range == "Tag"
      @tags = Tag.looks(@search, @word).page(params[:page]).per(20)
    elsif @range == "Community"
      @communities = Community.looks(@search, @word).page(params[:page]).per(12)
    end
  end
end
