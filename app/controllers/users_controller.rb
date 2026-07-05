class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
    @dogs = current_user.dogs
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "ユーザー登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
    @dogs = @user.dogs
  end

  def edit
    redirect_to mypage_pass unless @user == current_user
  end

  def update
    if @user == current_user && @user.update(user_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      @user.update(is_active: false)
      reset_session
      redirect_to new_user_path, notice: "退会しました"
    else
      redirect_to mypage_path, alert: "退会できません"
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email_address, :password, :password_confirmation, :introduction
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

end
