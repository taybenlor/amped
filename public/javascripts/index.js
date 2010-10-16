document.observe('dom:loaded', function() {
  document.observe('click', function(event) {
    element = event.element();
    parent  = element.up('.product');
    if(parent) {
      id = parent.readAttribute('product-id');
      new Ajax.Updater('main_content', '/products/' + id + '/related', {method: 'get'});
    }
  });
});
