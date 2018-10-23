// this cannot function without timepicker
var date_picker_date_noinit;
date_picker_date_noinit = function() {
  $('.date-picker-date-noinit').daterangepicker(
  {
    locale: {
      format: 'YYYY-MM-DD'
    },
    timePicker: true,
    timePickerIncrement: 10,
    autoUpdateInput: false,
    singleDatePicker: true,
    showDropdowns: true
  }
  );
  $('.date-picker-date-noinit').on('apply.daterangepicker', function(ev, picker) {
     $(this).val(picker.startDate.format('YYYY-MM-DD'));
   });

  $('.date-picker-date-noinit').on('cancel.daterangepicker', function(ev, picker) {
     $(this).val('');
   });

};
$(document).on('turbolinks:load', date_picker_date_noinit);
