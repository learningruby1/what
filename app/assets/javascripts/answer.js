//$(function(){
$( document ).ready(function() {
  time_select();
  // For date_select
  $("[name*='answer(1i)']:not([type='hidden'])").wrap("<div class='col-md-2 margin-left'></div>")
  $("[name*='answer(3i)']:not([type='hidden'])").wrap("<div class='col-md-2 margin-left'></div>")
  $("[name*='answer(2i)']:not([type='hidden'])").wrap("<div class='col-md-3 margin-left'></div>")


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
          type: "POST",
          data: form + "&value=" + value + "&answer_id_first=" + answer_id_question +"&answer_id_second=" + answer_id + "&document_id=" + $('#document_id').val(),
          url: "/documents/"+$('#document_id').val()+"/step/"+$('#step_id').val()+"/render_questions"
        });
      }
    });
  });

  // For Add/Delete button
  $('.loop-button').each(function(){
    $(this).click(function(){
      $.ajax({
        type: "POST",
        data: $('#answer_form').serialize() + "&answer_id=" + $(this).attr('answer') + "&document_id=" + $('#document_id').val(),
        url: "/documents/" + $('#document_id').val() + ($(this).attr('name') == 'Delete' ? "/delete_fields_block" : "/add_fields_block")
      });
    });
  });


  //Fill fields for Mailing address auto if select option
  $('.radio_3:first').on('click', function(){
    var address = $('[data-toggle-option]').eq(5).find('.container div:eq(1) input').val();
    var city = $('[data-toggle-option]').eq(6).find('.container div:eq(1) input').val();
    var state = $('[data-toggle-option]').eq(7).find('.container .col-md-2 select').val();
    var zip = $('[data-toggle-option]').eq(8).find('.container div:eq(1) input').val();

    $('[data-toggle-option]').eq(9).find('.container div:eq(2) div input').prop('value', address);
    $('[data-toggle-option]').eq(10).find('.container div:eq(1) input').prop('value', city);
    $('[data-toggle-option]').eq(11).find('.container .col-md-2 select').prop('value', state);
    $('[data-toggle-option]').eq(12).find('.container div:eq(1) input').prop('value', zip);
  });

  $('[data-toggle-option]').eq(9).find('.container div:eq(2) div input').on('keydown', function(){
    $('.radio_3:first').prop('checked', false)
  });
  $('[data-toggle-option]').eq(10).find('.container div:eq(1) input').on('keydown', function(){
    $('.radio_3:first').prop('checked', false)
  });
  $('[data-toggle-option]').eq(12).find('.container div:eq(1) input').on('keydown', function(){
    $('.radio_3:first').prop('checked', false)
  });
  $('[data-toggle-option]').eq(11).find('.container .col-md-2 select').on('change', function(){
    $('.radio_3:first').prop('checked', false)
  });

  //Script for insert html blok to other place
  $('[data-insert-place]').each(function(){
    var this_class = '.place_for_insert_' + $(this).data('insert-place');
    var div = $(this).detach();
    $(this_class).append(div);
    div = null;
  });

  //For amount-income field
  var mom_result = joint_child_support_amount($('.amount_block:first').find('.income-math'))
  var dad_result = joint_child_support_amount($('.amount_block:last').find('.income-math'))
  $('.amount_block:last').parent().parent().parent().append("<div class='container'><div class='row new_roman col-md-9'><div class='who_pay_text'></div></div></div>")
  who_pay(dad_result, mom_result);
  $('.amount_block:first').find('.income-math').keyup(function(){
    mom_result = joint_child_support_amount($(this));
    who_pay(dad_result, mom_result);
  });
  $('.amount_block:last').find('.income-math').keyup(function(){
    dad_result = joint_child_support_amount($(this))
    who_pay(dad_result, mom_result);
  });

});

function time_select(){
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

        _this.parent().parent().find('.form-control').each(function(i){
          switch(i) {
            case 1:
              date.val(date.val() + ':');
              break;
            case 2:
              date.val(date.val() + ' ');
              break;
          }
          date.val(date.val() + $(this).val());
        });
      });
    });

    time.find('[type="hidden"]').each(function(){
      var _this = $(this);
      if(_this.val().length > 0){

        selects = _this.parent().find('.form-control');
        selects.first().val(_this.val().split(/ |:/) [0])
        selects.first().parent().next().children().val(_this.val().split(/ |:/) [1]);
        selects.last().val(_this.val().split(/ |:/) [2])
      }
    });
  }
}

function joint_child_support_amount(_this){
  if(_this.val() == ''){
    return;
  }
  var month_income = parseInt(_this.val());
  var percentage = parseInt($('.children_percentage').val()) / 100;
  var result = Math.round(month_income * percentage * 100) / 100
  _this.parent().find('.under_amount_text').prop('innerText', '$ ' + month_income + ' * ' + (percentage * 100) + '%  = ' + result);
  return result
}

function who_pay(dad_result, mom_result){
  if(dad_result == undefined || mom_result == undefined){
    return;
  }
  if(dad_result > mom_result){
    $('.who_pay_text').prop('innerHTML', '<span><b>Dad $' + dad_result + ' – ' + 'Mom $' + mom_result + ' = $' + (Math.round((dad_result - mom_result)* 100) / 100) + '. Dad has to pay ' + (Math.round((dad_result - mom_result)* 100) / 100) + '$ per month for child support to mom. /</span> <span class="spain">Papá $' + dad_result + ' – ' + 'Mamá $' + mom_result + ' = $' + (Math.round((dad_result - mom_result)* 100) / 100) + ' es la responsabilidad de manutención de menor que  Papá  tendrá que pagar  a la mamá por mes.</span>')
  }
   else{
    $('.who_pay_text').prop('innerHTML', '<span><b>Mom $' + mom_result + ' – ' + 'Dad $' + dad_result + ' = $' + (Math.round((mom_result - dad_result)* 100) / 100) + '. Mom has to pay ' + (Math.round((mom_result - dad_result)* 100) / 100) + '$ per month for child support to dad. /</span> <span class="spain">Papá $' + dad_result + ' – ' + 'Papá $' + mom_result + ' = $' + (Math.round((mom_result - dad_result)* 100) / 100) + ' es la responsabilidad de manutención de menor que  Mamá  tendrá que pagar  a la papá por mes.</span>')
  }
}

function check_value(value, _this){
  if(value < 1 || value > 9){
    _this.after('<div id="error" style="width:240px; background:#FAACAC; padding: 3px; border-radius: 5px; color: red; margin-top: 3px;"><span>Only from 1 to 9</span>/<span class="spain">Sólo del 1 al 9</span></div>');
    setTimeout(function(){ $('#error').remove(); }, 5000);
    return false
  }
  return true
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
      $('.' + $(this).prop('class') + ' [type="radio"]').unbind('change').change(function(){
        var selected_value = $(this).next().text();
        var parent_class = '.' + $(this).closest('[class^="toggle_"]').prop('class');
        if(selected_value == 'No' && $(this).closest('[class^="toggle_"]').data('sub-toggle') == undefined){
          $(parent_class + ':not(:first) [type="radio"]:last').attr('checked', true);
        }

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
    var result = parseInt($(this).attr('data-sub-toggle'));
    var this_class_next = '.toggle_' + result;
    var selected_value = $(this_class + ' [type="radio"]:checked:last').val();
    var selected_class = 'toggle_' + $(this_class + ' [type="radio"]:checked:last').closest('[class^="toggle_"]').data('sub-toggle');

    if(!$('.' + $(this).prop('class') + ' [type="checkbox"]').length > 0 ){
      $(this_class_next).hide().each(function(){
        if(selected_value != undefined && selected_class != undefined)
          if(selected_value.indexOf($(this).data('toggle-option')) != -1 && selected_class == $(this).prop('class'))
            $(this).show();
      });
    }

    checkbox_button_event($(this));

    //Radio button event
    $(this_class + '[data-sub-toggle="'+ $(this).data('sub-toggle')+'"]').change(function(){
      var selected_value = $('.' + $(this).prop('class') + ' [type="radio"]:checked:last').val();
      if(!$('.' + $(this).prop('class') + ' [type="checkbox"]').length > 0 ){
        if(result == $(this).data('sub-toggle')){
          $(this_class_next).hide().each(function(){
            hide_sub_toggles($(this), selected_value);
          });
        }
      }

      //Checkbox button event
      checkbox_button_event($(this));
    });
  });
}

function hide_sub_toggles(_this, selected_value){
  var current_class = '.toggle_' + parseInt($(this).attr('data-sub-toggle'));

  if(_this.data('sub-toggle') != undefined){
    if( _this.find('[type="radio"]:checked').length > 0 ){
      var toggler = _this.find('[type="radio"]:checked').prop('checked', false).closest('div[data-sub-toggle]').attr('data-sub-toggle');
      $('.toggle_' + toggler).hide();
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
    var this_class = '.toggle_' + (parseInt(_this.data('sub-toggle')));

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
      $('.toggle_' + (parseInt($(this).data('sub-toggle')))).hide();
    });
  }
}
