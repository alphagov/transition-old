(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var Urls = {
    enableDisableDropdown: function(content_type_dropdown, dropdown_id, data_attribute) {
      var enable = $(content_type_dropdown).find('option:selected').attr(data_attribute);
      var $dropdown = $(dropdown_id);

      if (enable === 'true') {
        $dropdown.removeAttr('readonly');
        $dropdown.select2().removeAttr('readonly');
      } else {
        $dropdown.val(null);
        $dropdown.select2().val(null);
        $dropdown.select2().attr('readonly', 'readonly');
      }
    },

    guidanceEnableDisable: function(content_type_dropdown) {
      Urls.enableDisableDropdown(content_type_dropdown, '#url_guidance_id', 'data-mandatory_guidance');
    },

    seriesEnableDisable: function(content_type_dropdown) {
      Urls.enableDisableDropdown(content_type_dropdown, '#url_series_id', 'data-scrapable');
    },

    userNeedEnableDisable: function(content_type_dropdown) {
      Urls.enableDisableDropdown(content_type_dropdown, '#url_user_need_id', 'data-user_need_required');
    },

    scrapeRadioEnableDisable: function(dropdown) {
      var scrapable = dropdown.options[dropdown.selectedIndex].getAttribute('data-scrapable') == 'true';
      $('.column-3 .scrape').showEnableIf(scrapable);
    },

    contentTypeChanged: function(dropdown) {
      Urls.guidanceEnableDisable($(dropdown));
      Urls.seriesEnableDisable($(dropdown));
      Urls.userNeedEnableDisable($(dropdown));
      Urls.scrapeRadioEnableDisable(dropdown);
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