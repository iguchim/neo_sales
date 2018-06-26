var date_range_picker;
date_range_picker = function() {
  $('.date-range-picker').each(function(){
    $(this).daterangepicker({
        locale: {
          //format: "YYYY/MM/DD",
          format: "MM-DD-YYYY HH:mm",
        },
        timePicker: true,
        timePickerIncrement: 5,
        alwaysShowCalendars: true,
        //startDate: '2018-01-01',
    }, function(start, end, label) {
      $('.start_hidden').val(start.format('YYYY-MM-DD HH:mm'));
      $('.end_hidden').val(end.format('YYYY-MM-DD HH:mm'));
    });
  })
};
$(document).on('turbolinks:load', date_range_picker);
