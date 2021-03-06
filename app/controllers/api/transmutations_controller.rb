class Api::TransmutationsController < ApplicationController

  def show
    json_response({
      name:         transmutation.name,
      mana:         transmutation.mana_for(current_alchemist),
      instructions: transmutation.instructions_for(current_alchemist),
      explanation:  transmutation.explanation,
      tips:         transmutation.tips,
      more:         transmutation.more,
      references:   transmutation.references
    })
  end

  def unlock
    if current_alchemist.unlock!(transmutation)
      json_response(transmutation)
    else
      json_response(current_alchemist.errors.messages, :forbidden)
    end
  end

  def transmute
    if current_alchemist.transmute!(transmutation)
      json_response(current_alchemist.present)
    else
      json_response(current_alchemist.errors.messages, :forbidden)
    end
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

  def transmutation
    @transmutation ||= Transmutation.find_by_name(params[:name])
  end

  def statuses_for(transmutations)
    transmutations.each_with_object({}) do |transmutation, statuses|
      statuses[transmutation.name] = current_alchemist.status_for(transmutation)
    end
  end

end
