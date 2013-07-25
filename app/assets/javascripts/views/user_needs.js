(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var UserNeeds = {
    userNeedChanged: function(dropdown) {
      var selected_need = $(dropdown).find('option:selected');
      if (dropdown.value) {
        $('#as_a').text(selected_need.attr('data-as-a'));
        $('#i_want_to').text(selected_need.attr('data-i-want-to'));
        $('#so_that').text(selected_need.attr('data-so-that'));
        $('.edit_link').attr('href', '/user_needs/' + dropdown.value + '/edit');
      } else {
        $('#as_a, #i_want_to, #so_that').text('');
      }
      $('.edit_link').toggle(dropdown.value.length > 0);
    },

    ready: function() {
      $(document).ready(function() {
        $(".select2").select2({
          allowClear: true
        });

        $('#user_need_id').change(function() {
            UserNeeds.userNeedChanged(this);
        });
      });
    }
  };

  root.GOVUK.UserNeeds = UserNeeds;
}).call(this);