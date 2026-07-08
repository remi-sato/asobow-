class SearchesController < ApplicationController
  before_action :require_login

  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(@search, @word)
    else
      @posts = Post.looks(@search, @word)
    end
  end

end
