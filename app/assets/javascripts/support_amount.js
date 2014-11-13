$(function(){
  if($('.amount_block').length > 0){
    $('.amount_block:last').parent().parent().parent().append("<div class='container'><div class='row new_roman col-md-9'><div class='who_pay_text'></div></div></div>");
    SupportAmount.who_pay($('.amount_block:last .income-math'), $('.amount_block:first .income-math'));
    $('.amount_block .income-math').keyup(function(){
      SupportAmount.who_pay($('.amount_block:last .income-math'), $('.amount_block:first .income-math'));
    });
  }
});

var SupportAmount = {
  joint_child_support_amount: function(_this){
    if(_this.val() == ''){
      return;
    }
    var month_income = parseInt(_this.val());
    var percentage = parseInt($('.children_percentage').val()) / 100;
    var result = Math.round(month_income * percentage * 100) / 100;
    _this.parent().find('.under_amount_text').prop('innerText', '$ ' + month_income + ' * ' + (percentage * 100) + '%  = ' + result);
    return result;
  },

  who_pay: function(dad_field, mom_field){
    var dad_result = SupportAmount.joint_child_support_amount(dad_field);
    var mom_result = SupportAmount.joint_child_support_amount(mom_field);
    if(dad_result == undefined || mom_result == undefined){
      return;
    }
    $.ajax({
      type: "GET",
      data: { dad_result: dad_result, mom_result: mom_result },
      url: "/documents/"+$('#document_id').val()+"/step/"+$('#step_id').val()+"/child_suport_prompt"
    });

  }
}