$(function(){

  var date = $('.date');
  if (date.length > 0){

    var months = '<option value="1">January</option>' +
                 '<option value="2">February</option>' +
                 '<option value="3">March</option>' +
                 '<option value="4">April</option>' +
                 '<option value="5">May</option>' +
                 '<option value="6">June</option>' +
                 '<option value="7">July</option>' +
                 '<option value="8">August</option>' +
                 '<option value="9">September</option>' +
                 '<option value="10">October</option>' +
                 '<option value="11">November</option>' +
                 '<option value="12">December</option>';

    var days = '';
    var years = '';
    var start_year = 1900;

    for( i = 1; i <= 31; ++i )
      days += '<option>' + i + '</option>';

    for( i = new Date().getFullYear(); i >= start_year; --i )
      years += '<option>' + i + '</option>';

    date.append('<div class="col-md-2 margin-left"><select class="month form-control">' + months + '</select></div>' +
                '<div class="col-md-1 margin-left"><select class="day form-control">' + days + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="year form-control">' + years + '</select></div>');

    $('.date select').each(function(){
      $(this).change(function(){

        var _this = $(this);
        date = _this.parent().parent().find('[type="hidden"]');
        date.val('');

        _this.parent().parent().find('.form-control').each(function(){
          if (date.val().length > 0)
            date.val(date.val() + '/');
          date.val(date.val() + $(this).val());
        });
      });
    });

    date.find('[type="hidden"]').each(function(){

      var _this = $(this);
      if(_this.val().length > 0){
        selects = _this.parent().find('.form-control');
        selects.first().val(_this.val().split('/')[0]);
        selects.first().parent().next().children().val(_this.val().split('/')[1]);
        selects.last().val(_this.val().split('/')[2]);
      }
    });
  }

  var time = $('.time');
  if (time.length > 0){

    var hours = '';
    var minutes = '';
    var minutes_step = 10;

    for( i = 1; i <= 12; ++i )
      hours += '<option>' + i + '</option>'

    var min = '';
    for( i = 0; i < 60; i += minutes_step ){
      var min = i < 10 ? '0' + i : i;
      minutes += '<option>' + min + '</option>'
    }

    var am_pm = '<option value="AM">AM</option><option value="PM">PM</option>'

    time.append('<div class="col-md-1 margin-left"><select class="hour form-control">' + hours + '</select></div>' +
                '<div class="col-md-1 margin-left"><select class="minute form-control">' + minutes + '</select></div>' +
                '<div class="col-md-1 margin-left"><select class="am-pm form-control">' + am_pm + '</select></div>');

    $('.time select').each(function(){
      $(this).change(function(){

        var _this = $(this);
        date = _this.parent().parent().find('[type="hidden"]');
        date.val('');

        _this.parent().parent().find('.form-control').each(function(){

          if (date.val().length > 0)
            date.val(date.val() + ':');
          date.val(date.val() + $(this).val());
        });
      });
    });

    time.find('[type="hidden"]').each(function(){

      var _this = $(this);
      if(_this.val().length > 0){

        selects = _this.parent().find('.form-control');
        selects.first().val(_this.val().split(':')[0])
        selects.first().parent().next().children().val(_this.val().split(':')[1]);
        selects.last().val(_this.val().split(':')[2])
      }
    });
  }

  var dry = '';
  var current;
  $('[class^="toggle_"]').each(function(){

    var this_prop_class = '.' + $(this).prop('class');

    if($(this_prop_class    + ':first :checkbox').length > 0){
      if(!$(this_prop_class + ':first :checkbox').is(':checked'))
        $(this_prop_class   + ':not(:first)').hide();

      //Checkbox event
      $(this).change(function(){
        $('.' + $(this).prop('class') + ':not(:first)').toggle();
      });
    }

    if($(this_prop_class + ':first [type="radio"]').length > 0){

      var selected_value = $('.' + $(this).prop('class') + ' [type="radio"]:checked').val();
      $('.' + $(this).prop('class') + ':not(:first)').hide().each(function(){
        if(selected_value.indexOf($(this).data('toggle-option')) != -1)
          $(this).show();
      });

      //Radio button event
      $(this).change(function(){
        var selected_value = $('.' + $(this).prop('class') + ' [type="radio"]:checked').val();
        $('.' + $(this).prop('class') + ':not(:first)').hide().each(function(){
          if(selected_value.indexOf($(this).data('toggle-option')) != -1)
            $(this).show();
        });
      });
    }
  });

  var counter = $('.counter');
  if(counter.length == 1)
    counter.hide();
});