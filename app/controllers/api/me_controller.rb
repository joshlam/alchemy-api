class Api::MeController < ApplicationController

  def show
    json_response(alchemist_json)
  end

  def transcend
    if current_alchemist.transcend!
      json_response(alchemist_json)
    else
      json_response(current_alchemist.errors.messages, :forbidden)
    end
  end

  private

  def alchemist_json
    {
      rank:          current_alchemist.rank,
      level:         current_alchemist.level,
      mana:          current_alchemist.mana,
      mind_unlock:   current_alchemist.mind_unlock,
      body_unlock:   current_alchemist.body_unlock,
      can_transcend: current_alchemist.can_transcend?,
      can_ascend:    current_alchemist.can_ascend?
    }
  end

end
