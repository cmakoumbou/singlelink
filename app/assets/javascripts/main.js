$(function(){
	$('#menu_button').on('click', function(){
		$('#menu_sidebar')
			.sidebar('toggle')
		;
	});
	$('.message .close').on('click', function() {
    $(this)
      .closest('.message')
      .transition('fade')
    ;
  });
});