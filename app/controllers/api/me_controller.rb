class Api::MeController < ApplicationController

  def show
    json_response(current_alchemist)
  end

end
