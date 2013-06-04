(function($) {
  $(function() {
    var $download_link_elem = $('#hits a.download-link');
    $('#hits a[data-toggle="tab"]').on('show', function (e) {
      var $tab = $(e.target)
      var download_link_href = $tab.data('downloadLink');
      if ((download_link_href !== undefined) && ($download_link_elem !== undefined)) {
        $download_link_elem.attr('href', download_link_href);
      }
    });
  })
})(jQuery);
