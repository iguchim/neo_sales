$(document).on('turbolinks:load',function(){
  $('.date-picker-date-cocoon').daterangepicker(
  {
    locale: {
      format: 'YYYY-MM-DD'
    },
    singleDatePicker: true,
    showDropdowns: true
  });
  $(document).on('cocoon:after-insert', function(event, insertedItem) {
    insertedItem.find('.date-picker-date-cocoon').daterangepicker(
    {
    locale: {
      format: 'YYYY-MM-DD'
    },
    singleDatePicker: true,
    showDropdowns: true
  });
  });
});
