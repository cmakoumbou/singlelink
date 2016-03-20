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
  $(".colorpicker_text").spectrum({
    allowEmpty:true,
    preferredFormat: "hex",
    showInput: true
  });

  $(".colorpicker_background").spectrum({
    allowEmpty:true,
    preferredFormat: "hex",
    showInput: true
  });

  $(".colorpicker_text_demo").spectrum({
    allowEmpty:true,
    preferredFormat: "hex",
    showInput: true,
    color: "#000000",
    disabled: true
  });


  $(".colorpicker_background_demo").spectrum({
    allowEmpty:true,
    preferredFormat: "hex",
    showInput: true,
    color: "#e7ecef",
    disabled: true
  });
});