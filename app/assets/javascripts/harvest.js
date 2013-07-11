(function () {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var harvest = {
    init: function(){
      var $select = $('.group-select'),
          $urlList = $('.url-list'),
          $contentType = $('.content-type');


      $select.click(function(){
        $('.group-select .options').toggle();
      });
      $urlList.change(function(e){
        $('iframe').attr('src', $urlList.val());
      });
      $contentType.change(function(e){
        if($contentType.find(':selected').data('scrape')){
          $('.no-scrape').hide();
          $('.scrape').show();
        } else {
          $('.no-scrape').show();
          $('.scrape').hide();
        }
      });
    }
  };
  root.GOVUK.harvest = harvest;
}).call(this);

GOVUK.harvest.init();
