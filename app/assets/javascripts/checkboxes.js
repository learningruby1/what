var Checkboxes = {

  checkbox_button_event: function(_this){
    if($('.' + _this.prop('class') + ' [type="checkbox"]').length > 0 ){
      var this_class = '.toggle_' + (parseInt(_this.data('sub-toggle')));

      if($('.' + _this.prop('class') + '[data-sub-toggle="'+ _this.data('sub-toggle')+'"]' + '[data-toggle-option="'+ _this.data('toggle-option')+'"]' + ' [type="checkbox"]').is(':checked'))
        $(this_class + '[data-toggle-option="'+ _this.data('toggle-option')+'"]').show();
      else
        $(this_class + '[data-toggle-option="'+ _this.data('toggle-option')+'"]').hide();
    }
  },

  hide_checkboxes: function(_this){
    if($('.' + _this.prop('class') + ' [type="checkbox"]').length > 0 ){
      $('.' + _this.prop('class') + ' [type="checkbox"]:checked').prop('checked',false);
      $('.' + _this.prop('class') + '[data-sub-toggle]').each(function(){
        $('.toggle_' + (parseInt($(this).data('sub-toggle')))).hide();
      });
    }
  }

}