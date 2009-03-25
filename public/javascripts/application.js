// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
  $('a[class*=timeago]').timeago();
  
  $.each($('input.prompt'), function() {
     $(this).val($(this).attr('title')).addClass('prompted')
      .focus(function() {
        if($(this).val() == $(this).attr('title')) $(this).val('').toggleClass('prompted');
      })
      .blur(function() {
        if($(this).val() == '') $(this).val($(this).attr('title')).toggleClass('prompted');
      })
      
  });
  
  $('select.admin-menu').change(function() {
    if($(this).val().length > 0) {
      window.location.href = $(this).val();
    }
  });
  
});