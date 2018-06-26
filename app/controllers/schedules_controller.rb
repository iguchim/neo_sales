class SchedulesController < ApplicationController
	before_action :logged_in_user, only: [:index]
  
  def index
  	make_refuser
  	#binding.pry
  end

  private

  def make_refuser

  	if params[:user_ids].nil?
  		return
  	end

  	#clear users for current user
  	id = current_user.id
  	ReferenceUser.all.each do |ref|
  		if ref.refer_id == id
  			ref.destroy
  		end
  	end
  
  	users = params[:user_ids]
  	users = users.reject(&:blank?)
  	users.each do |user_id|
  		ref = ReferenceUser.new
  		ref.refer_id = id
  		ref.referred_id = user_id
  		ref.save
  	end
  end

end
