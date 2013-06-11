(function () {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var pages = {
    data: [],

    loadData: function(){
      pages.$table.find('tbody tr').each(function(i, el){
        var $el = $(el);
        pages.data.push({
          id: el.id,
          percent: parseFloat($el.data('percent').replace(/[^0-9\.]/g, ''), 10),
          type: $el.data('type'),
          url: $el.data('url')
        });
      });
    },
    filterDataOnType: function(type){
      var out = [], i, _i;
      if(type === ''){
        return pages.data;
      }
      for(i=0,_i=pages.data.length; i<_i; i++){
        if(pages.data[i].type === type){
          out.push(pages.data[i]);
        }
      }
      return out;
    },
    showType: function(type){
      var pagesToShow = pages.filterDataOnType(type),
          items = [], i, _i,
          maxPercent = pagesToShow[0] && pagesToShow[0].percent,
          left = 0;

      if(pagesToShow.length > 180){
        pagesToShow = pagesToShow.slice(0,180);
      }

      for(i=0,_i=pagesToShow.length; i<_i; i++){
        items.push('<li class="'+pagesToShow[i].type+'"><a href="#'+pagesToShow[i].id+'" style="left:'+left+'px; height: '+(100*pagesToShow[i].percent / maxPercent)+'%" title="'+pagesToShow[i].url+'">'+pagesToShow[i].id+'</a></li>');
        left = left + 5;
      }

      pages.$graph.find('ul').html(items.join(''));
      pages.$graph.find('h2 .max').text(maxPercent + '%')
      pages.$table.removeClass('show-error show-gone show-redirect show-ok');
      pages.$table.addClass('show-'+type);
      pages.$nav.find('.active').removeClass('active');
      pages.$nav.find('.'+ (type === '' ? 'all' : type)).addClass('active');
    },
    navClick: function(e){
      e.preventDefault();
      var type = $(e.target).attr('href').replace('#', '');
      pages.showType(type);
    },
    barMouseOver: function(e){
      var $el = $(e.target);
      pages.currentMouseOver = $el.attr('href');
      pages.$tooltip.html(pages.wbr($el.attr('title'),33));
      if(!pages.$tooltip.is(':visible')){
        pages.$tooltip.fadeIn(100);
      }
    },
    barMouseOut: function(e){
      var $el = $(e.target);
      if(pages.currentMouseOver === $el.attr('href')){
        pages.currentMouseOver = false;
        pages.$tooltip.hide();
      }
    },
    wbr: function(str, num) {
      return str.replace(RegExp("(.{" + num + "})(.)", "g"), function(all,text,char){
        return text + "<wbr>" + char;
      });
    },
    init: function(){
      pages.$el = $('.js-pages');
      if(pages.$el.length){
        pages.$graph = $('.js-pages-graph');
        pages.$table = $('.js-pages-table');
        pages.$nav = $('.js-pages-navigation');
        pages.$tooltip = pages.$graph.find('.tooltip');

        pages.loadData();

        pages.$nav.on('click', 'a', pages.navClick);
        pages.$graph.on('mouseover', 'a', pages.barMouseOver);
        pages.$graph.on('mouseout', 'a', pages.barMouseOut);
      }
    }
  };
  root.GOVUK.pages = pages;
}).call(this);

GOVUK.pages.init();
