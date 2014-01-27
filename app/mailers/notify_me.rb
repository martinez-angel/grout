class NotifyMe < ActionMailer::Base
  default from:

  def notify_me(post_request)
    @post_request = post_request

  emails = []
    mail(:to => emails, :subject => "Facebook is being a dick again..." + Date.today.to_s) do |format|
      format.text
    end
  end


end
