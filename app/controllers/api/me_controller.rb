class Api::MeController < ApplicationController

  def show
    json_response(current_alchemist.present)
  end

  def transcend
    if current_alchemist.transcend!
      json_response(current_alchemist.present)
    else
      json_response(current_alchemist.errors.messages, :forbidden)
    end
  end

end
