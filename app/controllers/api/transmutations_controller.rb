class Api::TransmutationsController < ApplicationController

  def show
    @transmutation = Transmutation.find_by_name(params[:name])

    json_response(@transmutation)
  end

end
