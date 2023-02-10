class ContactMailer < ApplicationMailer

  def send_mail(mail_title,mail_content,group_users)
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    @user_to = params[:user_to]
    mail bcc: @user_to.email, subject: "お知らせです"
  end

end
