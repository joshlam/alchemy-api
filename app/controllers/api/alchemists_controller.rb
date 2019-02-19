class Api::AlchemistsController < ApplicationController

  skip_before_action :authenticate_request, only: :create

  def create
    @alchemist = Alchemist.create!({
      username: alchemist_params[:username].downcase.strip,
      password: alchemist_params[:password]
    })

    json_response(@alchemist, :created)
  end

  private

  def alchemist_params
    @alchemist_params ||=
      params.require(:alchemist).permit(:username, :password)
  end

end
