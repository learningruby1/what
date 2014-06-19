$(function(){

  var date = $('.date');
  if (date.length > 0)
      date.datetimepicker({ pickTime: false });

  var time = $('.time');
  if (time.length > 0)
      time.datetimepicker({ pickDate: false });

  $('[class^="toggle_"]:has([type="checkbox"])').each(function(){

    if(!$('.' + $(this).prop('class') + ' :checkbox:first').is(':checked'))
        $('.' + $(this).prop('class') + ':not(:first)').hide();

    $(this).change(function(){
      $('.' + $(this).prop('class') + ':not(:first)').toggle();
    });
  });

  $('[class^="toggle_"]:has([type="radio"])').each(function(){

    if(!$('.' + $(this).prop('class') + ' :checkbox:first').is(':checked'))
        $('.' + $(this).prop('class') + ':not(:first)').hide();

    $(this).change(function(){
      var selected_value = $('.' + $(this).prop('class') + ' [type="radio"]:checked').val();
      var field_value;

      $('.' + $(this).prop('class') + ':not(:first)').hide().each(function(){

        field_value = $(this).data('toggle-option');
        if(selected_value.indexOf(field_value) != -1)
          $(this).show();
      });
    });
  });


  var counter = $('.counter');
  if(counter.length == 1)
    counter.hide();
});