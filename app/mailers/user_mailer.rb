class UserMailer < ApplicationMailer
  default from: 'neo@iguchi.biz'

  def notice_from_user

    @user = User.find(params[:user_id])
    #auth_mail = User.find_by(admin: true).email
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    #mail(to: auth_mail, subject:'承認要求です。')
    mail(to: emails, subject:'承認要求です。')

    
  end

  def notice_from_daily_user

    @user = User.find(params[:user_id])
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    mail(to: emails, subject:'確認要求です。')
 
  end

  def decline_from_user

    @user = User.find(params[:user_id])
    #auth_mail = User.find_by(admin: true).email
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    #mail(to: auth_mail, subject:'承認要求の取消です。')
    mail(to: emails, subject:'承認要求の取消です。')
    
  end

  def decline_from_daily_user

    @user = User.find(params[:user_id])
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    mail(to: emails, subject:'確認要求の取消です。')

  end

  #-----------------------------------

  def notice_from_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'承認されました。')
    
  end

  def notice_from_daily_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'確認されました。')
    
  end

  def decline_from_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'取消れました。')
    
  end

  def decline_from_daily_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'取消れました。')
    
  end

  def order_from_auth
    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject: '出張指示です。')
  end

  def order_delete
    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    mail(to: user_mail, subject: '出張指示が取消されました。')
  end

  #-------------------------------------------------------
  def request_to_daily_user
    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject: 'コメントへの返答要求です。')
  end

  def reply_from_daily_user
    @user = User.find(params[:user_id])
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end

    @url = params[:url]
    mail(to: emails, subject: 'コメントへの返答です。')
  end

  #=== Objective >>> =====================================
  def notice_from_objective_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'承認されました。')
    
  end

  def decline_from_objective_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'取消れました。')
    
  end

  def request_to_objective_user
    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject: 'コメントへの返答要求です。')
  end

  def reply_from_objective_user
    @user = User.find(params[:user_id])
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end

    @url = params[:url]
    mail(to: emails, subject: 'コメントへの返答です。')
  end

  def notice_from_objective_user

    @user = User.find(params[:user_id])
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    mail(to: emails, subject:'承認要求です。')
 
  end

  def decline_from_objective_user

    @user = User.find(params[:user_id])
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    mail(to: emails, subject:'承認要求の取消です。')

  end
  #===================================== <<< Objective ===

  #=== Objective Detail >>> ==============================
  def notice_from_objective_detail_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'承認されました。')
    
  end

  def decline_from_objective_detail_auth

    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject:'取消れました。')
    
  end

  def request_to_objective_detail_user
    @auth = User.find(params[:auth_id])
    user_mail = User.find(params[:user_id]).email
    @url = params[:url]
    mail(to: user_mail, subject: 'コメントへの返答要求です。')
  end

  def reply_from_objective_detail_user
    @user = User.find(params[:user_id])
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end

    @url = params[:url]
    mail(to: emails, subject: 'コメントへの返答です。')
  end

  def notice_from_objective_detail_user

    @user = User.find(params[:user_id])
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    mail(to: emails, subject:'承認要求です。')
 
  end

  def decline_from_objective_detail_user

    @user = User.find(params[:user_id])
    @url = params[:url]
    auths = User.where(admin: true)
    emails = []
    auths.each do |auth|
      emails << auth.email
    end
    mail(to: emails, subject:'承認要求の取消です。')

  end
  #============================== <<< Objective Detail ===
  #=== Notice >>> =====================================
  def info_to_admin
    @user = User.find(params[:user_id])
    admins = User.where(admin: true)
    emails = []
    admins.each do |admin|
      emails << admin.email
    end

    @contents = params[:notice_contents]

    @url = params[:url]
    mail(to: emails, subject: '管理者向け情報です。')
  end

  def info_to_all
    @user = User.find(params[:user_id])
    all_users = User.all
    emails = []
    all_users.each do |user|
      emails << user.email
    end

    @contents = params[:notice_contents]

    @url = params[:url]
    mail(to: emails, subject: '情報です。')
  end
  #===================================== <<< Notice ===
   #=== Notice Comment >>> ============================
  def comment_to_admin
    @user = User.find(params[:user_id])
    admins = User.where(admin: true)
    emails = []
    admins.each do |admin|
      emails << admin.email
    end

    @comments = params[:notice_comments]

    @url = params[:url]
    mail(to: emails, subject: '管理者向け情報へのコメントです。')
  end

  def comment_to_all
    @user = User.find(params[:user_id])
    all_users = User.all
    emails = []
    all_users.each do |user|
      emails << user.email
    end

    @comments = params[:notice_comments]

    @url = params[:url]
    mail(to: emails, subject: '情報へのコメントです。')
  end
  #=============================== <<< Notice Comment ===
  #-------------------------------------------------------
  def account_activation(user)
    @user = user
    mail to: user.email # => mail object
      # =>    app/views/user_mailer/account_activation.text.erb
      # =>    app/views/user_mailer/account_activation.html.erb    
      # https://hogehoge.com/account_activations/:id/edit
      # :id <= @user.activation_token
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
    # => [text|html].erb
  end
end
