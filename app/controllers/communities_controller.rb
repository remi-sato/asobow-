class CommunitiesController < ApplicationController
  before_action :require_login
  before_action :set_community, only: [:show, :edit, :update, :destroy, :requests]

  def index
    @communities = Community.order(created_at: :desc).page(params[:page]).per(12)
  end

  def show
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.owned_communities.new(community_params)

    if @community.save
      redirect_to community_path(@community), notice: "コミュニティを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to community_path(@community), notice: "コミュニティを更新しました"
    else
      render :edit, status: :unprocessable_entuty
    end
  end

  def destroy
    @community.destroy
    redirect_to communities_path, notice: "コミュニティを削除しました"
  end

  def requests
    unless @community.user == current_user
      redirect_to community_path(@community), alert: "参加申請を確認する権限がありません"
      return 
    end
    @community_users = @community.community_users.pending.includes(:user).order(created_at: :desc).page(params[:page]).per(9)
  end

  private
  def set_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:name, :introduction, :rules)
  end

end
