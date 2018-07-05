var date_picker_date;
date_picker_date = function() {
  $('.date-picker-date').daterangepicker(
  {
    locale: {
      format: 'YYYY-MM-DD'
    },
    singleDatePicker: true,
    showDropdowns: true
  }
  );
};
$(document).on('turbolinks:load', date_picker_date);
