class InviteMailer < ActionMailer::Base

  def new_invite(invite)
    @invite = invite
    mail(from: @invite.sender_email, to: @invite.receiver_email, subject: @invite.subject)
  end 

end
