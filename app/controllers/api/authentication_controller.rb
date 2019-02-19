class Api::AuthenticationController < ApplicationController

  skip_before_action :authenticate_request, only: :authenticate

  def authenticate
    command = AuthenticateAlchemist.call(
      params[:email].downcase.strip,
      params[:password]
    )

    if command.success?
      json_response(auth_token: command.result)
    else
      json_response(command.errors, :unauthorized)
    end
  end

end
