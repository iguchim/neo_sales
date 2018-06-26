var date_picker_noinit;
date_picker_noinit = function() {
  $('.date-picker-noinit').daterangepicker(
  {
    locale: {
      format: 'YYYY-MM-DD HH:mm'
    },
    timePicker: true,
    timePickerIncrement: 10,
    singleDatePicker: true,
    autoUpdateInput: false,
    showDropdowns: true
  }
  //function(start, end, label) {
  //     $('.atart_hidden').val(start.format('YYYY-MM-DD HH:mm'));
  //     $('.end_hidden').val(end.format('YYYY-MM-DD HH:mm'));
  //}
  );

  $('.date-picker-noinit').on('apply.daterangepicker', function(ev, picker) {
     $(this).val(picker.startDate.format('YYYY-MM-DD HH:mm'));
   });

  $('.date-picker-noinit').on('cancel.daterangepicker', function(ev, picker) {
     $(this).val('');
   });

};
$(document).on('turbolinks:load', date_picker_noinit);
