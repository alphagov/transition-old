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

    // see http://www.samaxes.com/2011/09/change-url-parameters-with-jquery/
    filterChange: function() {
      var queryParameters = {}, queryString = location.search.substring(1),
          paramCapturer = /([^&=]+)=([^&]*)/g, m;
 
      // Creates a map with the query string parameters
      while (m = paramCapturer.exec(queryString)) {
          queryParameters[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
      }
       
      // Add new parameters or update existing ones
      var filterNames = { '#filter_by_state': 'state', '#filter_by_content_type': 'content_type',
        '#filter_by_scrape_status': 'for_scrape' };
      for (var filterName in filterNames) {
        if ($(filterName).val()) {
          queryParameters[filterNames[filterName]] = $(filterName).val();
        } else {
          delete queryParameters[filterNames[filterName]]; 
        }  
      }
      location.search = $.param(queryParameters); // Causes page to reload
    },

    resetFilters: function() {
      location = location.pathname;
    },

    prePopulateFormWithPreviouslySavedValues: function() {
      var _this = this;
      var lastSavedUrl;

      $('#same_as_last').click(function() {
        _this.lastSavedUrl = $.parseJSON($('#last_saved_url').val());
        $('#url_form select').each(function() {
          $(this).select2().val(_this.lastSavedUrl[$(this).attr('id').slice(4)]);
          $(this).select2().trigger('change');
        });
        $('#url_form textarea#url_comments').text(_this.lastSavedUrl['comments']);
        $('#url_for_scraping_true, #url_for_scraping_false').prop('checked', false);
        var for_scraping = _this.lastSavedUrl['for_scraping'];
        if (for_scraping != null) {
          $('#url_for_scraping_' + for_scraping.toString()).attr('checked', 'checked');
        }
      });
    },

    urlGroupDialogSetup: function() {
      var _this = this;
      var $url_group_select;
      
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
        Urls.urlGroupCreationHandler(evt, data, _this.$url_group_select, this)
      });

      $(".cancel").click(function() {
        $(this).closest('.dialog').find('input[type=text]').val('');
        $(this).closest('.dialog').find('.errors').text('');
        $(this).closest('.dialog').dialog('close');
      });
    },

    urlGroupCreationHandler: function(evt, data, url_group_select, _this) {
      if (data['errors'].length == 0) {
        // add url group name to relevant dropdown and select it if dropdown is enabled
        url_group_select.append('<option value="' + data['model']['id'] + '">' + data['model']['name'] + '</option>');
        if (!url_group_select.attr('readonly')) {
          url_group_select.val(data['model']['id']);
          url_group_select.select2().val(data['model']['id']);
        }
        $(_this).closest('.dialog').dialog('close');
        $(_this).find('input[type=text]').val('');
      } else {
        $(_this).find('.errors').text(data['errors'].join());
      }
    },

    addCheckboxCountToButtons: function(checkboxSelector, buttonSelector) {
      var checkboxes = $(checkboxSelector), buttons = $(buttonSelector);

      buttons.each(function () {
        var button = $(this), label = button.text();

        checkboxes.change(function () {
          var count = checkboxes.filter(':checked').size();

          if (count == 1) {
            button.text(label);
          } else {
            button.text(label + ' (' + count + ')');
          }
        });
      });
    },

    setUrlPreview: function(checkboxSelector) {
      $(checkboxSelector).change(function () {
        if ($(this).is(':checked')) {
          $('.preview').attr('src', $(this).closest('tr').attr('data-url'));
        }
      });
    },

    ready: function() {
      $(document).ready(function() {
        $(".select2").select2({
          allowClear: true
        });

        $('#filter_by_content_type, #filter_by_state, #filter_by_scrape_status').change(function() {
          Urls.filterChange();
        });

        $('#reset').click(function() {
          Urls.resetFilters();
        });

        Urls.prePopulateFormWithPreviouslySavedValues();

        Urls.addCheckboxCountToButtons('.urls input:checkbox', ':button[name=destiny]');

        Urls.setUrlPreview('.urls input:checkbox');

        Urls.urlGroupDialogSetup();

        var content_type_dropdown = $('#url_content_type_id');

        /**
         * according to the content type selected:
         *   * Enable/disable user needs dropdown
         *   * Enable/disable scrape buttons
         */
        content_type_dropdown.change(function() {
            Urls.contentTypeChanged(this);
        });
        // only run contentTypeChanged if there is a content type dropdown
        if (content_type_dropdown.length > 0) {
          Urls.contentTypeChanged(content_type_dropdown.get(0));
        }
      });
    }
  };

  root.GOVUK.Urls = Urls;
}).call(this);