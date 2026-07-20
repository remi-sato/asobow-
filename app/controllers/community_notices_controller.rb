class CommunityNoticesController < ApplicationController
  before_action :require_login
  before_action :set_community
  before_action :ensure_owner

  def new
  end

  def create
    @title = params[:title]
    @body = params[:body]

    if @title.blank? || @body.blank?
      flash.now[:alert] = "タイトルと本文を入力してください"
      render :new, status: :unprocessable_entity
      return
    end

    approved_members = @community.community_users.approved.includes(:user)

    approved_members.each do |community_user|
      CommunityMailer.event_notice(
        community_user.user,
        @community,
        @title,
        @body
      ).deliver_now

      @community.create_notification_event!(current_user, community_user)
    end
    
    render :show
  end

  def show
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def ensure_owner
    unless current_user == @community.user
      redirect_to community_path(@community), alert: "権限がありません"
    end
  end
end
