(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var Scrape = {
    initializeRichTextEditor: function() {
      var editor = new wysihtml5.Editor("scrape_result_body", { // id of textarea element
        toolbar:      "wysihtml5-toolbar",  // id of toolbar element
        parserRules:  wysihtml5ParserRules, // defined in parser rules set
        stylesheets: ["/css/editor.css"]
      });
    },
    
    initializeDatePicker: function() {
      var $datepickers = $(".datepicker");
      if ($datepickers.length > 0) {
        $datepickers.datepicker({
          dateFormat: "d-M-yy",
          showOtherMonths: true
        });
        return true;
      }
      return false;
    },

    ready: function() {
      $(document).ready(function() {
        Scrape.initializeRichTextEditor();
        Scrape.initializeDatePicker();
      });
    }
  };

  root.GOVUK.Scrape = Scrape;
}).call(this);