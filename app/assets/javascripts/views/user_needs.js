(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var UserNeeds = {
    ready: function() {
      $(document).ready(function() {
        $(".select2").select2({
          allowClear: true
        });
      });
    }
  };

  root.GOVUK.UserNeeds = UserNeeds;
}).call(this);