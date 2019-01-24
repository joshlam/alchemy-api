class AuthenticateAlchemist

  prepend SimpleCommand

  def initialize(email, password)
    @email    = email
    @password = password
  end

  def call
    JsonWebToken.encode(alchemist_id: alchemist.id) if alchemist.present?
  end

  private

  attr_reader :email,
              :password

  def alchemist
    alchemist = Alchemist.find_by_email(email)

    unless alchemist.present? && alchemist.authenticate(password)
      errors.add(:user_authentication, 'Invalid credentials')

      return nil
    end

    alchemist
  end

end
