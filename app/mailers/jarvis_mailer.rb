class JarvisMailer < ActionMailer::Base
  default from:

  def jarvis_notification(vm_page)
    @vm_page = Post.find(rand(0..(Post.count)))
    emails = []
    mail(:to => emails, :subject => "VM Database Status Report: " + Date.today.to_s) do |format|
        format.text
    end
  end

end
