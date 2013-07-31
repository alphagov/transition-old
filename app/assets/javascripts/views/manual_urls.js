(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var ManualUrls = {
    urlMappingHandler: function(evt, data, form) {
      if (data['errors'].length == 0) {
        $(form).prepend('<span class="alert">Saved</span>');
        $(form).closest('td').children(":first").text($(form).find('input[type=text]').val());
        ManualUrls.setFormReadOnly(form);
      } else {
        $(form).prepend('<span class="error">' + data['errors'].join() + '</span>');
      }
      $(form).children(":first").fadeOut(2000, function() { $(this).remove(); });
    },

    cancelMapping: function(cancel) {
      var form = $(cancel).closest('form');
      form.find('input[type=text]').val(form.closest('td').children(":first").text());
      ManualUrls.setFormReadOnly(form);
    },

    setFormEditable: function(form) {
      $(form).find('input[type=submit]').val('Save');
      $(form).find('input[type=text]').toggle(true).focus();
      $(form).find('.cancel').toggle(true);
    },

    setFormReadOnly: function(form) {
      $(form).find('input[type=submit]').val('Edit');
      $(form).find('input[type=text]').toggle(false);
      $(form).find('.cancel').toggle(false);
    },

    ready: function() {
      $(document).ready(function() {
        $('form').bind('ajax:success', function(evt, data) {
          ManualUrls.urlMappingHandler(evt, data, this);
        });

        $('form input[type=submit]').click(function(event) {
          if ($(this).val() == 'Edit') {
            event.preventDefault();
            ManualUrls.setFormEditable($(this).closest('form'));
          }
        });

        $('form .cancel').click(function(event) {
          event.preventDefault();
          ManualUrls.cancelMapping(this);
        });
      });
    }
  };

  root.GOVUK.ManualUrls = ManualUrls;
}).call(this);