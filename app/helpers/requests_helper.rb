module RequestsHelper

  def request_owner_id(item_id)

    RequestItem.find(item_id).request.user_id
  end

end
