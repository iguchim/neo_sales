var date_picker;
date_picker = function() {
  $('.date-picker').daterangepicker(
  {
    locale: {
      format: 'YYYY-MM-DD HH:mm'
    },
    timePicker: true,
    timePickerIncrement: 10,
    singleDatePicker: true,
    showDropdowns: true
  }
  );
};
$(document).on('turbolinks:load', date_picker);
