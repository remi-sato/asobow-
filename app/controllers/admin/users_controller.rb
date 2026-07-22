class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :withdraw, :reactive ]

  def index
    @users = User.includes(:posts, :dogs).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def withdraw
    @user.update(is_active: false)
    redirect_to admin_user_path(@user), notice: "利用を停止しました"
  end

  def reactive
    @user.update(is_active: true)
    redirect_to admin_user_path(@user), notice: "利用を再開しました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
