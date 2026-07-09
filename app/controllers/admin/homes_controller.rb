class Admin::HomesController < ApplicationController
  layout "admin"
  before_action :require_admin_login

  def index
    @users_count = User.count
    @posts_count = Post.count
  end
end