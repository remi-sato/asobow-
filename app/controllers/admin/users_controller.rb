class Admin::UsersController < ApplicationController
  before_action :require_admin_login
  before_action :set_user, only: [:show, :withdraw]

  def index
    @users = User.order(created_at: :desc)
  end

  def show
  end

  def withdraw
    @user.update(is_active: false)
    redirect_to admin_user_path(@user), notice: "退会処理を行いました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end