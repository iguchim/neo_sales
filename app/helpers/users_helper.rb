module UsersHelper
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80)
    # gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    # gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    # image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def user_name(id)
    user = User.find(id)
    if user.nil?
      "---"
    else
      user.name
    end
  end

  def sales_users
    sd_id = Department.find_by(name:"営業部")
    User.where("department_id=?", sd_id)
  end

  #module_function :sales_users

end
