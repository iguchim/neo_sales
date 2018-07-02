module CategoriesHelper

  def category_name(id)
      cat = Category.find(id)
      if cat.nil?
        "---"
      else
        cat.name
      end
  end
  
end