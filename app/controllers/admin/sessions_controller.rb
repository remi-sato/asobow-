class Admin::SessionsController < ApplicationController

  def new
  end

  def create
    admin = Admin.find_by(email_address: params[:email_address])
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_root_path, notice: "管理者としてログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_login_path, notice: "ログアウトしました"
  end

end