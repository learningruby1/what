$(function(){

  var date = $('.date');
  if (date.length > 0){

    var months = '<option value="1">January / Enero</option>' +
                 '<option value="2">February / Febrero</option>' +
                 '<option value="3">March / Marzo</option>' +
                 '<option value="4">April / Abril</option>' +
                 '<option value="5">May / Mayo</option>' +
                 '<option value="6">June / Junio</option>' +
                 '<option value="7">July / Julio</option>' +
                 '<option value="8">August / Agosto</option>' +
                 '<option value="9">September / Septiembre</option>' +
                 '<option value="10">October / Octubre</option>' +
                 '<option value="11">November / Noviembre</option>' +
                 '<option value="12">December / Diciembre</option>';

    var days = '';
    var years = '';
    var start_year = 1900;

    for( i = 1; i <= 31; ++i )
      days += '<option>' + i + '</option>';

    for( i = new Date().getFullYear(); i >= start_year; --i )
      years += '<option>' + i + '</option>';

    date.append('<div class="col-md-3 margin-left"><select class="month form-control">'+ '<option disabled="disabled" selected="selected" value="">Month / Mes</option>' + months + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="day form-control">'  + '<option disabled="disabled" selected="selected">Day / Día</option>' + days + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="year form-control">' + '<option disabled="disabled" selected="selected">Year / Año</option>' + years + '</select></div>');

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

  //Toggler logic
  $('[class^="toggle_"]').each(function(){
    var this_prop_class = '.' + $(this).prop('class');

    if($(this_prop_class    + ':first :checkbox').length > 0){
      if(!$(this_prop_class + ':first :checkbox').is(':checked'))
        $(this_prop_class   + ':not(:first)').hide();

      //Checkbox event
      $(document).change( '.' + $(this).prop('class') + ':first:has(:checkbox)', function(){
        if(!$(this_prop_class + ':first :checkbox').is(':checked'))
          $(this_prop_class   + ':not(:first)').hide();
        else
          $(this_prop_class   + ':not(:first)').show();
      });
    }

    if($(this_prop_class + ':first [type="radio"]').length > 0){
      var selected_value = $('.' + $(this).prop('class') + ' [type="radio"]:checked').val();
      $('.' + $(this).prop('class') + ':not(:first)').hide().each(function(){
        if(selected_value != undefined)
          if(selected_value.indexOf($(this).data('toggle-option')) != -1)
            $(this).show();
      });

      //Radio button event
      $('.' + $(this).prop('class') + ':first:has([type="radio"])').change(function(){
        var selected_value = $('.' + $(this).prop('class') + ' [type="radio"]:checked').val();
        if(selected_value.indexOf('No') != -1)
          $('.' + $(this).prop('class') + ':not(:first) [type="radio"]:last').attr('checked', true);

        $('.' + $(this).prop('class') + ':not(:first)').hide().each(function(){
          if(selected_value.indexOf($(this).data('toggle-option')) != -1){
            $(this).show();
          }
        });
      });
    }
  });

  var counters = $('.counter');
  if(counters.length == 1){

    counters.hide();
  }else{

    counters.each(function(){

      var first_depend_field = $(this).next().find('[type="text"]');

      if( first_depend_field.length > 0){
          first_depend_field.change(function(){

          first_depend_field.closest('div[data-toggle-option]').prev().find('.first_dependant_field').text($(this).val());
        });

        var second_depend_field = first_depend_field.closest('div[data-toggle-option]').next().next().next().next().find('[type="text"]')
        if( second_depend_field.length > 0)
            second_depend_field.change(function(){

            second_depend_field.closest('div[data-toggle-option]').prev().prev().prev().prev().prev().find('.second_dependant_field').text($(this).val());
        });
      }

    });
  }

  //For sub_amount click
  $('[class^="sub_amount_"]').each(function(){
    var $this = '.' + $(this).prop('class');

    $(document).on('click', $this + ' div:last-child a', function(event){
      event.preventDefault();

      var form = $('#answer_form').serialize();
      var answer_id = $(this).prev().val();
      var value = $(this).parent().prev().find('p input').val();
      var answer_id_question = $(this).parent().parent().parent().parent().prev().prev().find('div label input:last-child').val();

      $.ajax({
        type: "GET",
        data: form + "&value=" + value + "&step=" + $('#step_id').val() + "&answer_id_first=" + answer_id_question +"&answer_id_second=" + answer_id + "&document_id=" + $('#document_id').val(),
        url: "/documents/"+$('#document_id').val()+"/step/"+$('#step_id').val()+"/render_questions"
      });
    })
  });