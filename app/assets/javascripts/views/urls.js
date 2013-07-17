(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var Urls = {
    userNeedEnableDisable: function(content_type_dropdown) {
      var userNeedRequired = $(content_type_dropdown).find('option:selected').attr('data-user_need_required');
      var $needsDropdown = $('#url_user_need_id');

      if (userNeedRequired === 'true') {
        $needsDropdown.removeAttr('readonly', false);
        $needsDropdown.select2().removeAttr('readonly', false);
      } else {
        $needsDropdown.val(null);
        $needsDropdown.select2().val(null);
        $needsDropdown.select2().attr('readonly', 'readonly');
      }
    },

    contentTypeChanged: function(dropdown) {
      Urls.userNeedEnableDisable($(dropdown));
      var scrapable = dropdown.options[dropdown.selectedIndex].getAttribute('data-scrapable') == 'true';
      $('.column-3 .scrape').showEnableIf(scrapable);
    },

    ready: function() {
      $(document).ready(function() {
        $(".select2").select2({
          allowClear: true
        });

        var content_type_dropdown = $('#url_content_type_id');

        /**
         * according to the content type selected:
         *   * Enable/disable user needs dropdown
         *   * Enable/disable scrape buttons
         */
        content_type_dropdown.change(function() {
            Urls.contentTypeChanged(this);
        });
        Urls.contentTypeChanged(content_type_dropdown.get(0));
      });
    }
  };

  root.GOVUK.Urls = Urls;
}).call(this);