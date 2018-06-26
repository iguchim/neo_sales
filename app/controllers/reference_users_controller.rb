class ReferenceUsersController < ApplicationController
  before_action :set_reference_user, only: [:show, :edit, :update, :destroy]

  # GET /reference_users
  # GET /reference_users.json
  def index
    @reference_users = ReferenceUser.all
  end

  # GET /reference_users/1
  # GET /reference_users/1.json
  def show
  end

  # GET /reference_users/new
  def new
    @reference_user = ReferenceUser.new
  end

  # GET /reference_users/1/edit
  def edit
  end

  # POST /reference_users
  # POST /reference_users.json
  def create
    @reference_user = ReferenceUser.new(reference_user_params)

    respond_to do |format|
      if @reference_user.save
        format.html { redirect_to @reference_user, notice: 'Reference user was successfully created.' }
        format.json { render :show, status: :created, location: @reference_user }
      else
        format.html { render :new }
        format.json { render json: @reference_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reference_users/1
  # PATCH/PUT /reference_users/1.json
  def update
    respond_to do |format|
      if @reference_user.update(reference_user_params)
        format.html { redirect_to @reference_user, notice: 'Reference user was successfully updated.' }
        format.json { render :show, status: :ok, location: @reference_user }
      else
        format.html { render :edit }
        format.json { render json: @reference_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_users/1
  # DELETE /reference_users/1.json
  def destroy
    @reference_user.destroy
    respond_to do |format|
      format.html { redirect_to reference_users_url, notice: 'Reference user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reference_user
      @reference_user = ReferenceUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reference_user_params
      params.require(:reference_user).permit(:refer_id, :referred_id)
    end
end
