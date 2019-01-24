class ApplicationController < ActionController::API

  before_action :authenticate_request

  attr_reader :current_alchemist

  def json_response(object, status = :ok)
    render json: object, status: status
  end

  private

  def authenticate_request
    @current_alchemist = AuthorizeApiRequest.call(request.headers).result

    unless @current_alchemist.present?
      json_response({error: 'Not Authorized'}, :unauthorized)
    end
  end

end
