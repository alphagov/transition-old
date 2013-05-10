(function($) {
  $(function() {
    var $download_link_elem = $('#hits a.download-link');
    $('#hits a[data-toggle="tab"]').on('show', function (e) {
      var $tab = $(e.target)
      var to_show = $tab.data('statusCode');
      if (to_show === 'all') {
        $('#hits table tr[data-status-code]').show();
      } else {
        $('#hits table tr[data-status-code]').each(function(idx, row) {
          var $row = $(row);
          var code = $row.data('statusCode');
          if (code === to_show) {
            $row.show();
          } else {
            $row.hide();
          }
        });
      }
      var download_link_href = $tab.data('downloadLink');
      if ((download_link_href !== undefined) && ($download_link_elem !== undefined)) {
        $download_link_elem.attr('href', download_link_href);
      }
    });
  })
})(jQuery);