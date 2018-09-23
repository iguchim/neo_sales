class ObjectivesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :index, :show, :destory]
  before_action :set_objective, only: [:edit, :update]

  def index
    @objectives = Objective.all
  end

  def show
    @objective = Objective.find(params[:id])

    @objective_details = ObjectiveDetail.joins(:objective)
                        .select('objective_details.*')
                        .where('objective_details.objective_id = ?', @objective.id)
  end

  def new
    @objective = Objective.new
  end

  def create
    @objective = Objective.new(objective_params)
    @objective.user_id = current_user.id
    @objective.state = "下書"
 
    if @objective.save
      flash[:success] = "個人目標を登録しました。"
      redirect_to objective_path(@objective)
    else
      flash[:danger] = "個人目標を登録出来ませんでした。"
      render :new
    end
  end

  def update
    if !view_context.obj_admin?(@objective) && @objective.auth_id && params["objective"]["objective_details_attributes"].nil?
      flash[:danger] = "個人目標が承認された為更新出来ませんでした。"
      redirect_to objective_path(@objective)
    else
      if @objective.update_attributes(objective_params)
      flash[:success] = "個人目標を更新しました。"
      redirect_to objective_path(@objective)
      else
        flash[:danger] = "個人目標を更新出来ませんでした。"
        render :edit
      end
    end
  end

  def edit
    if false #!@objective.auth_id.nil? && !current_user.admin
      flash[:danger] = "個人目標が承認された為編集出来ません。"
      redirect_to objective_path(@objective)
    end
  end

  def destroy
    objective = Objective.find(params[:id])
    if objective.auth_id.nil? && objective.user_id == current_user.id 
      objective.destroy
    flash[:success] = "個人目標を削除しました。"
    else
      flash[:danger] = "個人目標が承認された為削除出来ません。"
    end
    redirect_to objectives_url
  end

  def auth
    if !current_user.admin
      flash[:danger] = "管理者ではないので、承認出来ません。"
    else
      @objective = Objective.find(params[:id])
      if @objective.state == "下書"
        flash[:danger] = "下書中なので承認出来ません。"
      else
        if @objective.auth_id.nil? 
          @objective.auth_id = current_user.id
          UserMailer.with(user_id: @objective.user_id, auth_id: @objective.auth_id,
              url: objective_url(@objective)).notice_from_objective_auth.deliver_now
            flash[:success] = "承認メールを送信しました。"
            @objective.state = "承認"
        else
          UserMailer.with(user_id: @objective.user_id, auth_id: @objective.auth_id,
              url: objective_url(@objective)).decline_from_objective_auth.deliver_now
            flash[:success] = "承認取消メールを送信しました。"
          @objective.auth_id = nil
          @objective.state = "未承認"
        end
        @objective.save
      end
    end

    redirect_to objective_path(params[:id])
  end

  def req_to
    if !current_user.admin
      flash[:danger] = "管理者ではないので要求出来ません。"
    else
      @objective = Objective.find(params[:id])
      UserMailer.with(user_id: @objective.user_id, auth_id: current_user.id,
            url: objective_url(@objective)).request_to_objective_user.deliver_now
      flash[:success] = "返答要求メールを送信しました。"
      @objective.state = "返答要求"
      @objective.save
    end
    redirect_to objective_path(params[:id])
  end

  def rep_from
    @objective = Objective.find(params[:id])
    UserMailer.with(user_id: @objective.user_id, 
          url: objective_url(@objective)).reply_from_objective_user.deliver_now
    flash[:success] = "返答完了メールを送信しました。"
    redirect_to objective_path(params[:id])
    @objective.state = "返答完了"
    @objective.save
  end

  def state
    @objective = Objective.find(params[:id])
    if @objective.auth_id
      flash[:danger] = "承認されたので状態を変更出来ません。"
    else
      if @objective.auth_id.nil? && @objective.user_id == current_user.id
        if @objective.state == "下書" || @objective.state == "未承認"
          @objective.state = "申請"
          UserMailer.with(user_id: @objective.user_id,
            url: objective_url(@objective)).notice_from_objective_user.deliver_now
          flash[:success] = "申請メールを送信しました。"
        else
          @objective.state = "下書"
          UserMailer.with(user_id: @objective.user_id,
            url: objective_url(@objective)).decline_from_objective_user.deliver_now
          flash[:success] = "取消メールを送信しました。"
        end
        @objective.save
      end
    end
    redirect_to objective_path(params[:id])
  end

  private

  def set_objective
    @objective = Objective.find(params[:id])
  end

  def objective_params
    params.require(:objective)
          .permit(Objective::REGISTRABLE_ATTRIBUTES +
            [objective_details_attributes: ObjectiveDetail::REGISTRABLE_ATTRIBUTES])
  end

end