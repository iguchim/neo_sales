module NoticeCategoriesHelper

  def notice_category_name(id)
      cat = NoticeCategory.find(id)
      if cat.nil?
        "---"
      else
        cat.name
      end
  end
  
end