class AdminMailer < ApplicationMailer
  default from: "stocksreplysample@gmail.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.account_approved.subject
  #
  def account_approved(user)
    @greeting = "Hi"
    @user = user
    mail to: user.email
  end

  def account_declined(user)
    @user = user
    mail(to: @user.email, subject: "Your account has been declined")
  end
end
