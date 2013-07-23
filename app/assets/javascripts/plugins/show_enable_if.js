jQuery.fn.showEnableIf = function(show) {
  if(show) {
      $(this).show().find('input').removeAttr('disabled');
  } else {
      $(this).hide().find('input').attr('disabled', 'disabled');
  }

  return $(this);
}
