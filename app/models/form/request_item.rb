class Form::RequestItem < RequestItem
  REGISTRABLE_ATTRIBUTES = %i(id request_id place visit personnel purpose notes comment _destroy)
end