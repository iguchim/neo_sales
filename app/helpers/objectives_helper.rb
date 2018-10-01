module ObjectivesHelper

  def no_objective_details?(objective_id, user_id)
    current_user.id == user_id && !ObjectiveDetail.find_by(objective_id: objective_id) ? true : false
  end

  def get_objective_state(obj)
    if obj.auth_id.nil?
      str = obj.state
    else
      if obj.goal_amount.nil? || obj.current_amount.nil?
        str = "---"
      elsif obj.reducing
        if (obj.current_amount <= obj.goal_amount) && (Date.parse(obj.due_date.to_s) > Date.today)
          str = "進行中"
        elsif (obj.current_amount <= obj.goal_amount) && (Date.parse(obj.due_date.to_s) <= Date.today)
          str = "達成"
        else
          str = "未達成"
        end
      else # increasing objective
        if (obj.goal_amount <= obj.current_amount) && (Date.parse(obj.due_date.to_s) >= Date.today)
          str = "達成"
        elsif Date.parse(obj.due_date.to_s) < Date.today
          str = "未達成"
        else
          str = "進行中"
        end
      end
    end
    if obj.state != str
      obj.state = str
      obj.save
    end
    str
  end

  def get_objective_detail_state(obj)
    if obj.auth_id
      str = "承認"
    else
      if obj.state.nil?
        str = "未承認"
      else
        str = obj.state
      end
    end
    str
  end

  def get_objective_rate(obj)
    if obj.goal_amount.nil? || obj.current_amount.nil?
      rate = 0
    elsif !obj.goal_amount.real? || !obj.current_amount.real?
      rate = 0
    elsif obj.reducing
      if obj.goal_amount == 0
        if  obj.current_amount > 0
          rate = 0
        else
          rate =1
        end
      else
        if obj.current_amount == 0
          rate = 1
        end
        rate = obj.goal_amount/obj.current_amount
        if rate > 1
          rate = 1
        end
      end
    else # increasing objective
      if obj.goal_amount == 0
        rate = 0
      else
        rate = obj.current_amount/obj.goal_amount
      end
    end
    rate
  end

  def objective_detail_not_appv_and_self?(obj)
    details = ObjectiveDetail.where('objective_id = ?', obj.id)
    return true if details.count == 0
    details.each do |detail|
      if detail.auth_id.nil? && (current_user.id == detail.objective.user_id)
        return true
      end
    end
    return false
  end

  def objective_detail?(obj)
    ObjectiveDetail.where('objective_id = ?', obj.id).count == 0 ? false : true
  end

  def objective_details_get_button_num(obj)
    details = ObjectiveDetail.where('objective_id = ?', obj.id)
    num = 0
    details.each do |detail|
      state = get_objective_detail_state(detail)
      # admin and not self
      if detail_obj_admin?(detail)

        if state == "申請" || state == "返答完了"
          num = 2
        elsif state == "承認"
          if num == 0
            num = 1
          end
        end

      elsif detail_obj_owner?(detail)
        if state != "承認"
          num = 1
        end
      end
#binding.pry
    end
    num
  end

  def objective_detail_get_button_num(detail)
    num = 0
    state = get_objective_detail_state(detail)
    # admin and not self
    if detail_obj_admin?(detail)

      if state == "申請" || state == "返答完了"
        num = 2
      elsif state == "承認"
        if num == 0
          num = 1
        end
      end

    elsif detail_obj_owner?(detail)
      if state != "承認"
        num = 1
      end
    end
    num
  end

  def get_objective_score(obj)
    details = ObjectiveDetail.where('objective_id = ?', obj.id)
    last_date = details.first.exec_date
    score = details.first.amount
    details.each do |detail|
      if detail.auth_id && detail.exec_date > last_date
        last_date = detail.exec_date
        score = detail.amount
      end
    end
    if obj.current_amount != score
      obj.current_amount = score
      obj.save
    end
    score
  end

  def obj_admin?(obj)
    current_user.admin && (obj.user_id != current_user.id) ? true : false
  end

  def detail_obj_admin?(obj)
    current_user.admin && (obj.objective.user_id != current_user.id) ? true : false
  end

  def obj_owner?(obj)
    current_user.id == obj.user_id ? true : false
  end

  def detail_obj_owner?(obj)
    current_user.id == obj.objective.user_id ? true : false
  end

  def obj_form_readonly?(obj)
    if obj.user_id.nil?
      readonly = false #state of new
    else # object created
      if !obj_owner?(obj)
        readonly = true
      elsif obj_admin?(obj) && obj.state == "下書"
        readonly = true
      elsif obj_admin?(obj)
        readonly = false
      elsif obj.auth_id
        readonly = true
      else
        readonly = false
      end
    end
  end


end