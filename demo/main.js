define(function(require) {
  var template = require('j!templates/template');
  var layoutCopy = require('j!templates/layout_copy');
  // var runtime = require('runtime');

  $(document).ready(function() {
    var context = {
      heading: 'Layout'
    };

    $('body').append('<h1>Testing include</h1>');
    $('body').append(layoutCopy(context));

    $('body').append('<h1>Testing extends</h1>');
    $('body').append(template(context));
  });
});
