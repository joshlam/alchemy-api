class AlphaTestMailer < ApplicationMailer
  default from: 'alchemytheapp@gmail.com'

  def send_launch_email(alchemist, sent, passwords)
    return if sent.include?(alchemist.username)

    @alchemist = alchemist
    @password  = passwords.find { |alchemist|
      alchemist[:username] == @alchemist.username
    }[:password]

    mail(
      to:      @alchemist.username,
      subject: 'Welcome to the Alchemy Alpha test!'
    )
  end
end
