(function() {
  "use strict"

  var Urls = {
    user_need_enable_disable: function(content_type_dropdown) {
      var user_need_required;
      user_need_required = $(content_type_dropdown).find('option:selected').attr('data-user_need_required');
      if (user_need_required && user_need_required == 'true') {
        $('#url_user_need_id').removeAttr('readonly', false);
        $('#url_user_need_id').select2().removeAttr('readonly', false);
      } else {
        $('#url_user_need_id').val(null);
        $('#url_user_need_id').select2().val(null);
        $('#url_user_need_id').select2().attr('readonly', 'readonly');
      }
    },

    content_type_changed: function(dropdown) {
      Urls.user_need_enable_disable($(dropdown));
      var scrapable = dropdown.options[dropdown.selectedIndex].getAttribute('data-scrapable') == 'true';
      $('.column-3 .scrape').showEnableIf(scrapable);
    },

    ready: function() {
      $(document).ready(function() {
        $('.urls').scrollTop(
            $('.urls li:nth-child(<%= [@site.urls.index(@url) - 3, 1].max %>)')
                .position().top - $('.urls').position().top
        );
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
            Urls.content_type_changed(this);
        });
        Urls.content_type_changed(content_type_dropdown.get(0));
      });
    }
  };

  GOVUK.Urls = Urls;
}).call(this);