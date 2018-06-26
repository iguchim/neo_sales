json.array! @events do |event|
  date_format = event.all_day_event? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'
  json.user_id event.user_id
  json.id event.id
  json.title event.title
  json.start event.start.strftime(date_format)
  json.end event.end.strftime(date_format)
  json.color User.find(event.user_id).color
  json.kind event.kind
  json.allDay event.all_day_event? ? true : false
  json.update_url event_path(event, method: :patch)
  json.edit_url edit_event_path(event)
  json.request_url request_path(event.id)
  json.show_url event_path(event)
  json.editable (event.user_id != current_user.id) || event.kind ? false : true
end
