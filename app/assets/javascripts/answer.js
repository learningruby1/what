//$(function(){
$( document ).ready(function() {
  date_init();
  day_of_week_init();
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
  //Toggler
  checkbox_radio_toggler();

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

      if(answer_id_question == undefined){
        answer_id_question = $(this).parent().parent().parent().parent().prev().prev().find('strong').next().val();
      }

      if(check_value(value, $(this))){
        $.ajax({
          type: "GET",
          data: form + "&value=" + value + "&answer_id_first=" + answer_id_question +"&answer_id_second=" + answer_id + "&document_id=" + $('#document_id').val() + "&review=" + $('#review').val(),
          url: "/documents/"+$('#document_id').val()+"/step/"+$('#step_id').val()+"/render_questions"
        });
      }
    });
  });

  //Fill fields for Mailing address auto if select option
  $('.radio_3:first').on('click', function(){
    var address = $('.container').eq(7).find('div:eq(1) input').val();
    var city = $('.container').eq(8).find('div:eq(1) input').val();
    var state = $('.container').eq(9).find('.col-md-2 select').val();
    var zip = $('.container').eq(10).find('div:eq(1) input').val();

    $('.container').eq(11).find('div:eq(2) input').prop('value', address);
    $('.container').eq(12).find('div:eq(1) input').prop('value', city);
    $('.container').eq(13).find('.col-md-2 select').prop('value', state);
    $('.container').eq(14).find('div:eq(1) input').prop('value', zip);
  });

  $('.container').eq(11).find('div:eq(1) input').on('keydown', function(){
    $('.radio_3:first').prop('checked', false)
  });
  $('.container').eq(12).find('div:eq(1) input').on('keydown', function(){
    $('.radio_3:first').prop('checked', false)
  });
  $('.container').eq(14).find('div:eq(1) input').on('keydown', function(){
    $('.radio_3:first').prop('checked', false)
  });
  $('.container').eq(13).find('.col-md-2 select').on('change', function(){
    $('.radio_3:first').prop('checked', false)
  });

  //Script for insert html blok to other place
  $('[data-insert-place]').each(function(){
    var this_class = '.place_for_insert_' + $(this).data('insert-place');
    var div = $(this).detach();
    $(this_class).append(div);
    div = null;
  });
});

function check_value(value, _this){
  if(value < 1 || value > 10){
    _this.after('<div id="error" style="width:240px; background:#FAACAC; padding: 3px; border-radius: 5px; color: red; margin-top: 3px;"><span>Only from 1 to 9</span>/<span class="spain">Sólo del 1 al 9</span></div>');
    setTimeout(function(){ $('#error').remove(); }, 5000);
    return false
  }
  return true
}

function date_init(){
  var date = $('.date');
  var date_without_day = $('.date_without_day');
  var only_year = $('.only_year')
  var only_year_born = $('.only_year_born')
  if (date.length > 0 || date_without_day.length > 0 || only_year.length > 0 || only_year_born.length > 0){

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
    var years_without_day = '';
    var only_years = '';
    var only_years_born = '';
    var start_year = 1900;
    var start_year_without_day = 2009;
    var start_only_year = 2013;

    for( i = 1; i <= 31; ++i )
      days += '<option>' + i + '</option>';

    for( i = new Date().getFullYear() + 1; i >= start_year; --i )
      years += '<option>' + i + '</option>';

    for( i = new Date().getFullYear(); i >= start_year_without_day; --i )
      years_without_day += '<option>' + i + '</option>';

    for( i = new Date().getFullYear(); i >= start_only_year; --i )
      only_years += '<option>' + i + '</option>';

    for( i = new Date().getFullYear() + 1; i >= new Date().getFullYear(); --i )
      only_years_born += '<option>' + i + '</option>';

    only_year_born.append('<div class="col-md-3 margin-left"><select class="month form-control">'+ '<option disabled="disabled" selected="selected" value="">Month / Mes</option>' + months + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="day form-control">'  + '<option disabled="disabled" selected="selected">Day / Día</option>' + days + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="year form-control">' + '<option disabled="disabled" selected="selected">Year / Año</option>' + only_years_born + '</select></div>');


    only_year.append('<div class="col-md-2 margin-left"><select class="year form-control">' + '<option disabled="disabled" selected="selected">Year / Año</option>' + only_years + '</select></div>');

    date_without_day.append('<div class="col-md-3 margin-left"><select class="month form-control">'+ '<option disabled="disabled" selected="selected" value="">Month / Mes</option>' + months + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="year form-control">' + '<option disabled="disabled" selected="selected">Year / Año</option>' + years_without_day + '</select></div>');

    date.append('<div class="col-md-3 margin-left"><select class="month form-control">'+ '<option disabled="disabled" selected="selected" value="">Month / Mes</option>' + months + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="day form-control">'  + '<option disabled="disabled" selected="selected">Day / Día</option>' + days + '</select></div>' +
                '<div class="col-md-2 margin-left"><select class="year form-control">' + '<option disabled="disabled" selected="selected">Year / Año</option>' + years + '</select></div>');

    $('.only_year_born select').each(function(){
      $(this).change(function(){

        var _this = $(this);
        only_year_born = _this.parent().parent().find('[type="hidden"]');
        only_year_born.val('');

        _this.parent().parent().find('.form-control').each(function(){
          if (only_year_born.val().length > 0)
            only_year_born.val(only_year_born.val() + '/');
          only_year_born.val(only_year_born.val() + $(this).val());
        });
      });
    });

    only_year_born.find('[type="hidden"]').each(function(){

      var _this = $(this);
      if(_this.val().length > 0){
        selects = _this.parent().find('.form-control');
        selects.first().val(_this.val().split('/')[0]);
        selects.first().parent().next().children().val(_this.val().split('/')[1]);
        selects.last().val(_this.val().split('/')[2]);
      }
    });

    $('.date select').each(function(){
      var str = '.' + $(this).prop('class');
      $this = str.replace(' ', '.');

      $(document).on('change', $this, function(){

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

    $('.date_without_day select').each(function(){
      $(this).change(function(){

        var _this = $(this);
        date_without_day = _this.parent().parent().find('[type="hidden"]');
        date_without_day.val('');

        _this.parent().parent().find('.form-control').each(function(){
          if (date_without_day.val().length > 0)
            date_without_day.val(date_without_day.val() + '/');
          date_without_day.val(date_without_day.val() + $(this).val());
        });
      });
    });

    date_without_day.find('[type="hidden"]').each(function(){

      var _this = $(this);
      if(_this.val().length > 0){
        selects = _this.parent().find('.form-control');
        selects.first().val(_this.val().split('/')[0]);
        selects.first().parent().next().children().val(_this.val().split('/')[1]);
      }
    });

    $('.only_year select').each(function(){
      $(this).change(function(){

        var _this = $(this);
        only_year = _this.parent().parent().find('[type="hidden"]');
        only_year.val('');

        _this.parent().parent().find('.form-control').each(function(){
          if (only_year.val().length > 0)
            only_year.val(only_year.val() + '/');
          only_year.val(only_year.val() + $(this).val());
        });
      });
    });

    only_year.find('[type="hidden"]').each(function(){

      var _this = $(this);
      if(_this.val().length > 0){
        selects = _this.parent().find('.form-control');
        selects.first().val(_this.val().split('/')[0]);
      }
    });
  }
}

function day_of_week_init(){
  var day_of_week = $('.day_of_week');
  if (day_of_week.length > 0){
    var days_of_week = '<option value="1">Monday / Lunes</option>' +
                 '<option value="2">Tuesday / Martes</option>' +
                 '<option value="3">Wednesday / Miércoles</option>' +
                 '<option value="4">Thursday / Jueves</option>' +
                 '<option value="5">Friday / Viernes</option>' +
                 '<option value="6">Saturday / Sábado</option>' +
                 '<option value="7">Sunday / Domingo</option>';

    day_of_week.append('<div class="col-md-3 margin-left"><select class="day_of_week form-control">' + '<option disabled="disabled" selected="selected">Day of week / Día de la semana</option>' + days_of_week + '</select></div>');

    $('.day_of_week select').each(function(){
      $(this).change(function(){
        var _this = $(this);
        day_of_week = _this.parent().parent().find('[type="hidden"]');
        day_of_week.val('');

        _this.parent().parent().find('.form-control').each(function(){
          if (day_of_week.val().length > 0)
            day_of_week.val(day_of_week.val() + '/');
          day_of_week.val(day_of_week.val() + $(this).val());
        });
      });
    });

    day_of_week.find('[type="hidden"]').each(function(){

      var _this = $(this);
      if(_this.val().length > 0){
        selects = _this.parent().find('.form-control');
        selects.first().val(_this.val().split('/')[0]);
      }
    });
  }
}

function checkbox_radio_toggler(){
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
      $('.' + $(this).prop('class') + ' [type="radio"]').change(function(){
        var selected_value = $(this).next().text();
        var parent_class = '.' + $(this).parent().parent().parent().parent().prop('class');
        if(selected_value == 'No')
          $(parent_class + ':not(:first) [type="radio"]:last').attr('checked', true);

        hide_checkboxes($(parent_class));

        if($(this).parent().parent().parent().parent().data('sub-toggle') == undefined){
          $(parent_class + ':not(:first)').hide().each(function(){
            hide_sub_toggles($(this), selected_value);
          });
        }
      });
    }
  });

  //Toggler logic for sub-toggle
  $('[data-sub-toggle]').each(function(){
    var this_class = '.' + $(this).prop('class');
    var result = parseInt($(this).prop('class').substr(7, $(this).prop('class').length - 7)) + 1;
    var this_class_next = '.toggle_' + result;
    var selected_value = $(this_class + ' [type="radio"]:checked:last').val();

    if(!$('.' + $(this).prop('class') + ' [type="checkbox"]').length > 0 ){
      $(this_class_next).hide().each(function(){
        if(selected_value != undefined)
          if(selected_value.indexOf($(this).data('toggle-option')) != -1)
            $(this).show();
      });
    }

    checkbox_button_event($(this));

    //Radio button event
    $(this_class + '[data-sub-toggle="'+ $(this).data('sub-toggle')+'"]').change(function(){
      var selected_value = $('.' + $(this).prop('class') + ' [type="radio"]:checked:last').val();
      if(!$('.' + $(this).prop('class') + ' [type="checkbox"]').length > 0 ){
        $(this_class_next).hide().each(function(){
          hide_sub_toggles($(this), selected_value);
        });
      }

      //Checkbox button event
      checkbox_button_event($(this));
    });
  });
}

function hide_sub_toggles(_this, selected_value){
  var result = parseInt(_this.prop('class').substr(7, _this.prop('class').length - 7)) + 1;
  var current_class = '.toggle_' + result;

  if(_this.data('sub-toggle') != undefined){
    if( _this.find('[type="radio"]:checked').length > 0 ){
      _this.find('[type="radio"]:checked').prop('checked',false);
    }
    $(current_class).hide().each(function(){
      hide_sub_toggles($(this));
    });
  }

  if(selected_value!= undefined && selected_value.indexOf(_this.data('toggle-option')) != -1)
    _this.show();
}

function checkbox_button_event(_this){
  if($('.' + _this.prop('class') + ' [type="checkbox"]').length > 0 ){
    var radio_result = parseInt(_this.prop('class').substr(7, _this.prop('class').length - 7)) - 1;
    var this_class = '.toggle_' + (parseInt(_this.data('sub-toggle')) + radio_result);

    if($('.' + _this.prop('class') + '[data-sub-toggle="'+ _this.data('sub-toggle')+'"]' + '[data-toggle-option="'+ _this.data('toggle-option')+'"]' + ' [type="checkbox"]').is(':checked'))
      $(this_class + '[data-toggle-option="'+ _this.data('toggle-option')+'"]').show();
    else
      $(this_class + '[data-toggle-option="'+ _this.data('toggle-option')+'"]').hide();
  }
}

function hide_checkboxes(_this){
  if($('.' + _this.prop('class') + ' [type="checkbox"]').length > 0 ){
    $('.' + _this.prop('class') + ' [type="checkbox"]:checked').prop('checked',false);
    $('.' + _this.prop('class') + '[data-sub-toggle]').each(function(){
      var radio_result = parseInt(_this.prop('class').substr(7, _this.prop('class').length - 7)) - 1;
      $('.toggle_' + (parseInt($(this).data('sub-toggle')) + radio_result)).hide();
    });
  }
}
