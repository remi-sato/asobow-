class Admin::HomesController < Admin::BaseController
  def index
    @users_count = User.count
    @posts_count = Post.count
    @communities_count = Community.count
  end
end
