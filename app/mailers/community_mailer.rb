class CommunityMailer < ApplicationMailer

  def event_notice(user, community, title, body)
    @user = user
    @community = community
    @title = title
    @body = body
    
    mail(
      to: @user.email_address,
      subject: "[#{@community.name}] #{@title}"
    )
  end
end
