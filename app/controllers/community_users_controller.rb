class CommunityUsersController < ApplicationController
  before_action :require_login

  def new
    @community = Community.find(params[:community_id])
    @community_user = CommunityUser.new
  end

  def create
    community = Community.find(params[:community_id])
    community_user = current_user.community_users.new(community: community, status: :pending)
  
    dog_ids = community_user_params[:dog_ids]
    community_user.dogs = current_user.dogs.where(id: dog_ids)

    if community_user.save
      community.create_notification_join_request!(current_user)
      redirect_to community_path(community), notice: "参加申請を送りました"
    else
      @community = community
      @community_user = community_user
      flash.now[:alert] = "参加申請に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    community_user = current_user.community_users.find(params[:id])
    community = community_user.community
    community_user.destroy
    redirect_to community_path(community), notice: "参加申請を取り消しました"
  end

   def approve
    community_user = CommunityUser.find(params[:id])
    community = community_user.community
    unless community.user == current_user
      redirect_to community_path(community), alert: "この操作を行う権限がありません"
      return
    end
    community_user.approved!
    community_user.create_notification_approved!(current_user)
    redirect_to requests_community_path(community), notice: "参加申請を承認しました"
  end

  def reject
    community_user = CommunityUser.find(params[:id])
    community = community_user.community
    unless community.user == current_user
      redirect_to community_path(community), alert: "この操作を行う権限がありません"
      return
    end
    community_user.rejected!
    community_user.create_notification_rejected!(current_user)
    redirect_to requests_community_path(community), notice: "参加申請を拒否しました"
  end

  private

  def community_user_params
    params.fetch(:community_user, {}).permit(dog_ids: [])
  end

end
