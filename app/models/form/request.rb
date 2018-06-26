class Form::Request < Request
  REGISTRABLE_ATTRIBUTES = %i(user_id start end state auth_id region req_date order_id)
  has_many :request_items, class_name: 'Form::RequestItem'

  #after_initialize { request_items.build unless self.persisted? || request_items.present? }


end