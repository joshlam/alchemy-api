class AuthorizeApiRequest

  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    alchemist
  end

  private

  attr_reader :headers

  def alchemist
    if decoded_auth_token.present?
      @alchemist ||= Alchemist.find(decoded_auth_token[:alchemist_id])
    end

    unless @alchemist.present?
      errors.add(:token, 'Invalid token')

      return nil
    end

    @alchemist
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    unless headers['Authorization'].present?
      errors.add(:token, 'Missing token')

      return nil
    end

    headers['Authorization'].split(' ').last
  end

end
