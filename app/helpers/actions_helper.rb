module ActionsHelper

  def action_name(id)
      act = Action.find(id)
      if act.nil?
        "---"
      else
        act.name
      end
  end
  
end