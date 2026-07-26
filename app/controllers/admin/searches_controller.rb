class Admin::SearchesController < Admin::BaseController
  
  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(@search, @word)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(10)

    elsif @range == "Post"
      @posts = Post.admin_looks(@search, @word)
                   .includes(:user)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(10)

    elsif @range == "Community"
      @communities = Community.looks(@search, @word)
                              .includes(:user)
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(10)
    end
  end
end