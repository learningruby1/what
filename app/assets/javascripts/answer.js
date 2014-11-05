$(function(){
  if($('[data-insert-place]').length > 0){
    InsertBlock.insert_html_block($('[data-insert-place]'));
  }
});

var InsertBlock = {
  insert_html_block: function(data_insert){
    data_insert.each(function(){
      var this_class = '.place_for_insert_' + $(this).data('insert-place');
      var div = $(this).detach();
      $(this_class).append(div);
      div = null;
    });
  }
}
