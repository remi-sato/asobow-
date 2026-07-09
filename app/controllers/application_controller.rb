class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?
  helper_method :current_admin, :admin_logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def redirect_if_logged_in
    if logged_in?
      redirect_to root_path, notice: "既にログインしています"
    end
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください"
    end
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def admin_logged_in?
    current_admin.present?
  end

  def require_admin_login
    unless admin_logged_in?
      redirect_to admin_login_path, alert: "管理者としてログインしてください"
    end
  end

end
