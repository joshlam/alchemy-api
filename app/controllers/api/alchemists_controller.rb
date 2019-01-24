class Api::AlchemistsController < ApplicationController

  skip_before_action :authenticate_request, only: :create

  def create
    @alchemist = Alchemist.create!(alchemist_params)

    json_response(@alchemist, :created)
  end

  private

  def alchemist_params
    @alchemist_params ||=
      params.require(:alchemist).permit(:name, :email, :password)
  end

end
