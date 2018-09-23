class ObjectiveDetailsController < ApplicationController

  def auth
    if !current_user.admin
      flash[:danger] = "管理者ではないので、承認出来ません。"
    else
      @objective_detail = ObjectiveDetail.find(params[:id])
       if @objective_detail.auth_id.nil? 
          @objective_detail.auth_id = current_user.id
          UserMailer.with(user_id: @objective_detail.objective.user_id, auth_id: @objective_detail.auth_id,
              url: objective_url(@objective_detail.objective_id)).notice_from_objective_detail_auth.deliver_now
          flash[:success] = "承認メールを送信しました。"
      else
        UserMailer.with(user_id: @objective_detail.objective.user_id, auth_id: @objective_detail.auth_id,
            url: objective_url(@objective_detail.objective_id)).decline_from_objective_detail_auth.deliver_now
          flash[:success] = "承認取消メールを送信しました。"
        @objective_detail.auth_id = nil
      end
      @objective_detail.save
      view_context.get_objective_score(@objective_detail.objective) # update objective.amount
    end
    redirect_to objective_path(@objective_detail.objective_id)
  end

  def req_to
    if !current_user.admin
      flash[:danger] = "管理者ではないので、要求出来ません。"
    else
      @objective_detail = ObjectiveDetail.find(params[:id])
      UserMailer.with(user_id: @objective_detail.objective.user_id, auth_id: current_user.id,
            url: objective_url(@objective_detail.objective_id)).request_to_objective_detail_user.deliver_now
      @objective_detail.state ="返答要求"
      flash[:success] = "返答要求メールを送信しました。"
      @objective_detail.save
    end
    redirect_to objective_path(@objective_detail.objective_id)
  end

  def rep_from
    @objective_detail = ObjectiveDetail.find(params[:id])
    UserMailer.with(user_id: @objective_detail.objective.user_id, 
          url: objective_url(@objective_detail.objective_id)).reply_from_objective_detail_user.deliver_now
    @objective_detail.state ="返答完了"
    flash[:success] = "返答完了メールを送信しました。"
    @objective_detail.save
    redirect_to objective_path(@objective_detail.objective_id)
  end

  def state
    @objective_detail = ObjectiveDetail.find(params[:id])
    if @objective_detail.auth_id.nil? && @objective_detail.objective.user_id == current_user.id
      if (@objective_detail.state == "下書" || @objective_detail.state.nil?)
        @objective_detail.state = "申請"
        UserMailer.with(user_id: @objective_detail.objective.user_id,
          url: objective_url(@objective_detail.objective_id)).notice_from_objective_detail_user.deliver_now
        flash[:success] = "申請メールを送信しました。"
      else
        @objective_detail.state = "下書"
        UserMailer.with(user_id: @objective_detail.objective.user_id,
          url: objective_url(@objective_detail.objective_id)).decline_from_objective_detail_user.deliver_now
        flash[:success] = "取消メールを送信しました。"
      end
      @objective_detail.save
    end
    redirect_to objective_path(@objective_detail.objective_id)
  end

end
