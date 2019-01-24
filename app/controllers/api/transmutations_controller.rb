class Api::TransmutationsController < ApplicationController

  def show
    @transmutation = Transmutation.find_by_name(params[:name])

    json_response(@transmutation)
  end

  def mind
    @transmutations = Transmutation.mind

    json_response(statuses_for(@transmutations))
  end

  def body
    @transmutations = Transmutation.body

    json_response(statuses_for(@transmutations))
  end

  private

  def statuses_for(transmutations)
    transmutations.each_with_object({}) do |transmutation, statuses|
      statuses[transmutation.name] = current_alchemist.status_for(transmutation)
    end
  end

end
