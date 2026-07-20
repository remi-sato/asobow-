class CommunityUsersController < ApplicationController
  before_action :require_login

  def create
    community = Community.find(params[:community_id])
    community_user = current_user.community_users.new(community: community, status: :pending)
    if community_user.save
      notification = Notification.create!(
        visitor: current_user,
        visited: community.user,
        community: community,
        action: :join_request
      )
      NotificationsChannel.broadcast_to(
        community.user,
        {
          message: "#{current_user.name}さんから参加申請が届きました",
          notification_id: notification.id
        }
      )
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
    notification = Notification.create!(
        visitor: current_user,
        visited: community_user.user,
        community: community,
        action: :approved
      )
      NotificationsChannel.broadcast_to(
        community_user.user,
        {
          message: "#{community.name}への参加が承認されました",
          notification_id: notification.id
        }
      )
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
    notification = Notification.create!(
        visitor: current_user,
        visited: community_user.user,
        community: community,
        action: :rejected
      )

      NotificationsChannel.broadcast_to(
        community_user.user,
        {
          message: "#{community.name}への参加が拒否されました",
          notification_id: notification.id
        }
      )
    redirect_to requests_community_path(community), notice: "参加申請を拒否しました"
  end

end
