class Admin::CommunitiesController < Admin::BaseController
  before_action :set_community, only: [ :show, :destroy ]

  def index
    @communities = Community.includes(:user, :community_users).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def destroy
    @community.destroy
    redirect_to admin_communities_path, notice: "コミュニティを削除しました"
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end
end
