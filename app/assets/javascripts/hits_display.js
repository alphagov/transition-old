(function($) {
  $(function() {
    $('#hits a[data-toggle="tab"]').on('show', function (e) {
      var to_show = $(e.target).data('statusCode');
      if (to_show === 'all') {
        $('#hits table tr[data-status-code]').show();
      } else {
        $('#hits table tr[data-status-code]').each(function(idx, row) {
          var code = $(row).data('statusCode');
          if (code === to_show) {
            $(row).show();
          } else {
            $(row).hide();
          }
        });
      }
    });
  })
})(jQuery);