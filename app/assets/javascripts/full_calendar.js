var initialize_calendar;
initialize_calendar = function() {
  $('#calendar').each(function(){
  var calendar = $(this);
  calendar.fullCalendar({
      header: {
        left: 'prev,next selectUserButton',
        center: 'title',
        right: 'today month agendaWeek agendaDay'
      },
      selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,
      events: 'events.json',

      customButtons: {
        selectUserButton: {
          text: 'メンバー選択',
          click: function() {
            $.getScript('seluser');
          }
        }
      },

      select: function(start, end) {
        //alert('select: select');
        $.getScript('events/new', function() {
          $('#event_date_range').val(moment(start).format("MM/DD/YYYY HH:mm") + ' - ' + moment(end).format("MM/DD/YYYY HH:mm"))
          date_range_picker();
          $('.start_hidden').val(moment(start).format('YYYY-MM-DD HH:mm'));
          $('.end_hidden').val(moment(end).format('YYYY-MM-DD HH:mm'));
        });
        
        calendar.fullCalendar('unselect');
      },

      eventDrop: function(event, delta, revertFunc) {
        event_data = { 
          event: {
            id: event.id,
            start: event.start.format(),
            end: event.end.format()
          }
        };
        var token = $('meta[name="csrf-token"]').attr('content');
        $.ajax({
          url: event.update_url,
          beforeSend: function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token', token)
          },
          data: event_data,
          type: 'PATCH'
        });
      },

      eventResize: function(event, delta, revertFunc) {
        event_data = { 
          event: {
            id: event.id,
            start: event.start.format(),
            end: event.end.format()
          }
        };
        var token = $('meta[name="csrf-token"]').attr('content');
        $.ajax({
          url: event.update_url,
          beforeSend:  function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token', token)
          },
          data: event_data,
          type: 'PATCH'
        });
      },

      eventClick: function(event, jsEvent, view) {
        if (event.kind){
          //$.getScript(event.show_url);
          location.href = event.request_url;

        } else if (event.editable){
          $.getScript(event.edit_url, function() {
            $('#event_date_range').val(moment(event.start).format("MM/DD/YYYY HH:mm") + ' - ' + moment(event.end).format("MM/DD/YYYY HH:mm"))
            date_range_picker();
            $('.start_hidden').val(moment(event.start).format('YYYY-MM-DD HH:mm'));
            $('.end_hidden').val(moment(event.end).format('YYYY-MM-DD HH:mm'));
          });
        } else {
          $.getScript(event.show_url);
        }
      }
    });
  })
};
// var clear_calendar;
// clear_calendar = function() {
//   $('#calendar').each(function(){
//     var calendar = $(this);
//     calendar.fullCalendar('destroy'); // In case delete doesn't work.
//     calendar.html('');
//   });
// };
$(document).on('turbolinks:load', initialize_calendar);
//$(document).on('turbolinks:before-cache', clear_calendar)
