(function($) {
  $(function() {
    $('.status-filtering .status-filter a[data-toggle="tab"]').on('show', function (e) {
      var $tab = $(e.target)
      var to_show = $tab.data('statusCode');
      if (to_show === 'all') {
        $('.status-filtered *[data-status-code]').show();
      } else {
        $('.status-filtered *[data-status-code]').each(function(idx, row) {
          var $row = $(row);
          var code = $row.data('statusCode');
          if (code === to_show) {
            $row.show();
          } else {
            $row.hide();
          }
        });
      }
    });
  })
})(jQuery);