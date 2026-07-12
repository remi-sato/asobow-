class SearchesController < ApplicationController
  before_action :require_login

  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(@search, @word)
    elsif @range == "Post"
      @posts = Post.looks(@search, @word)
    elsif @range == "Tag"
      @tags = Tag.looks(@search, @word)
    elsif @range == "Community"
      @communities = Community.looks(@search, @word)
    end
  end

end
