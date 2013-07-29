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
        $needsDropdown.removeAttr('readonly');
        $needsDropdown.select2().removeAttr('readonly');
      } else {
        $needsDropdown.val(null);
        $needsDropdown.select2().val(null);
        $needsDropdown.select2().attr('readonly', 'readonly');
      }
    },

    scrapeRadioEnableDisable: function(dropdown) {
      var scrapable = dropdown.options[dropdown.selectedIndex].getAttribute('data-scrapable') == 'true';
      $('.column-3 .scrape').showEnableIf(scrapable);
    },

    contentTypeChanged: function(dropdown) {
      Urls.userNeedEnableDisable($(dropdown));
      Urls.scrapeRadioEnableDisable(dropdown);
    },

    ready: function() {
      $(document).ready(function() {
        var _this = this;
        var $url_group_select;

        $(".select2").select2({
          allowClear: true
        });

        $(".dialog").dialog({ 
          autoOpen: false,
          width: 350,
          modal: true
        });
        
        $("#add_guidance").click(function() {
          _this.$url_group_select = $('#url_guidance_id');
          $("#dialog_guidance").dialog("open");
        });
        $("#add_series").click(function() {
          _this.$url_group_select = $('#url_series_id');
          $("#dialog_series").dialog("open");
        });

        $('.dialog form').bind('ajax:success', function(evt, data) {
          if (data['errors'].length == 0) {
            // add url group name to relevant dropdown and select it
            _this.$url_group_select.append('<option value="' + data['model']['id'] + '">' + data['model']['name'] + '</option>');
            _this.$url_group_select.val(data['model']['id']);
            _this.$url_group_select.select2().val(data['model']['id']);
            $(this).closest('.dialog').dialog('close');
            $(this).find('input[type=text]').val('');
          } else {
            $(this).find('.errors').text(data['errors'].join());
          }
        });
        $(".cancel").click(function() {
          $(this).closest('.dialog').find('.errors').text('');
          $(this).closest('.dialog').dialog('close');
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