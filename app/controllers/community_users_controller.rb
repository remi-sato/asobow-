class CommunityUsersController < ApplicationController
  before_action :require_login

  def create
    community = Community.find(params[:community_id])
    community_user = current_user.community_users.new(community: community, status: :pending)
    if community_user.save
      community.create_notification_join_request!(current_user)
      redirect_to community_path(community), notice: "参加申請を送りました"
    else
      redirect_to community_path(community), alert: "参加申請に失敗しました"
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

end
