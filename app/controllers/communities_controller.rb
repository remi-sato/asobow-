class CommunitiesController < ApplicationController
  before_action :require_login
  before_action :set_community, only: [:show, :edit, :update, :destroy, :requests]
  before_action :ensure_owner, only: [:edit, :update, :destroy, :requests]

  def index
    @communities = Community.order(created_at: :desc).page(params[:page]).per(12)
  end

  def show
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.owned_communities.new(community_attributes)

    Community.transaction do
      @community.save!

      community_user = @community.community_users.create!(
        user: current_user,
        status: :approved
      )

      community_user.dogs =
        current_user.dogs.where(id: community_dog_ids)
    end

    redirect_to community_path(@community), notice: "コミュニティを作成しました"

  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    if @community.update(community_attributes)
      redirect_to community_path(@community), notice: "コミュニティを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @community.destroy
    redirect_to communities_path, notice: "コミュニティを削除しました"
  end

  def requests
    @community_users = @community.community_users.pending.includes(:user).order(created_at: :desc).page(params[:page]).per(9)
  end

  private
  
  def set_community
    @community = Community.find(params[:id])
  end

  def community_attributes
    params.require(:community).permit(:name, :introduction, :rules)
  end

  def community_dog_ids
    params.fetch(:community, {}).permit(dog_ids: [])[:dog_ids]
  end

  def ensure_owner
    unless @community.user == current_user
      redirect_to community_path(@community), alert: "権限がありません"
    end
  end

end
