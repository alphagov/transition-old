jQuery.fn.showEnableIf = function(show) {
  if(show) {
      $(this).show().find('input').removeAttr('readonly');
  } else {
      $(this).hide().find('input').attr('readonly', 'readonly');
  }

  return $(this);
}
