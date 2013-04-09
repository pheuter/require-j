define(function(require) {
  var template = require('j!templates/template');
  var layoutCopy = require('j!templates/layout_copy');

  $(document).ready(function() {
    $('body').append('<h1>Testing include</h1>');
    $('body').append(layoutCopy({
      heading: 'Layout'
    }));

    $('body').append('<h1>Testing extends</h1>');
    $('body').append(template());
  });
});
