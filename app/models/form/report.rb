class Form::Report < Report
  REGISTRABLE_ATTRIBUTES = %i(request_id user_id start end state auth_id region rep_date)
  has_many :report_items, class_name: 'Form::ReportItem'

  #after_initialize { report_items.build unless self.persisted? || report_items.present? }

end