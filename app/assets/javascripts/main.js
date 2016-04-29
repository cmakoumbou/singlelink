$(function(){
  $('#hidden-menu').hide();
  $('html').removeClass('no-scroll');

  $('#menu-toggle').on('click', function() {
    // $(this).html('hide menu'); 
    $(this).removeClass("fa fa-bars fa-lg").addClass("fa fa-times fa-lg");
    if ($(this).attr('data-click-state') == 0) {
      $('#hidden-menu').show();
      $('html').addClass('no-scroll');
      $(this).attr('data-click-state', 1); 
    } else if ($(this).attr('data-click-state') == 1) {
      // $(this).html('show menu')
      $(this).removeClass("fa fa-times fa-lg").addClass("fa fa-bars fa-lg");
      $('#hidden-menu').hide();
      $('html').removeClass('no-scroll');
      $(this).attr('data-click-state', 0);
    }
  });

  var mql = window.matchMedia("only screen and (max-width : 767px) and (orientation: landscape)");

  if(mql.matches) {  
    $('.responsive-image').css('max-width', '75%');
  } else {
    $('.responsive-image').css('max-width', '100%');
  }

  mql.addListener(function(m) {
    if(m.matches) {
      $('.responsive-image').css('max-width', '75%');
    }
    else {
      $('.responsive-image').css('max-width', '100%');
    }
  });
  
  // $('#hidden-menu').hide();

  // $('#menu-toggle').on('click', function() {
  //   // $(this).html('hide menu'); 
  //   $(this).removeClass("fa fa-bars fa-lg").addClass("fa fa-times fa-lg");
  //   if ($(this).attr('data-click-state') == 0) {
  //     $('#hidden-menu').show();
  //     // $position = $(document).scrollTop();
  //     // $('#menu-container').addClass('fix-it').css('top', -$position);
  //     $(this).attr('data-click-state', 1); 
  //   } else if ($(this).attr('data-click-state') == 1) {
  //     // $(this).html('show menu')
  //     $(this).removeClass("fa fa-times fa-lg").addClass("fa fa-bars fa-lg");
  //     $('#hidden-menu').hide();
  //     // $('#menu-container').removeClass('fix-it').css('top', 'auto');
  //     // $(document).scrollTop($position);
  //     $(this).attr('data-click-state', 0);
  //   }
  // });


  // $('#menuToggle').on('click', function() {
  //   $(this).html('hide menu'); 

  //   if ($(this).attr('data-click-state') == 0) { 

  //     $('#menuPanel').show();
  //     $position = $(document).scrollTop();
  //     $('#wrapper').addClass('fixIt').css('top', -$position);

  //     $(this).attr('data-click-state', 1); 

  //   } else if ($(this).attr('data-click-state') == 1) { 
  //     $(this).html('show menu');

  //     $('#menuPanel').hide();

  //     $('#wrapper').removeClass('fixIt').css('top', 'auto');
  //     $(document).scrollTop($position);

  //     $(this).attr('data-click-state', 0);

  //   }
  // });


  // var slideout = new Slideout({
  //   'panel': document.getElementById('panel'),
  //   'menu': document.getElementById('menu'),
  //   'padding': 256,
  //   'tolerance': 70
  // });

  // // Toggle button
  // $('.toggle-button').on('click', function() {
  //     slideout.toggle();
  // });
	// $('#sidebar_button').on('click', function(){
	// 	$('#sidebar_menu')
	// 		.sidebar('toggle')
	// 	;
	// });

 //  var slideout = new Slideout({
 //    'panel': document.getElementById('panel'),
 //    'menu': document.getElementById('menu'),
 //    'padding': 256,
 //    'tolerance': 70
 //  });
  
 //  document.querySelector('.toggle-button').addEventListener('click', function() {
 //    slideout.toggle();
 //  });

  // var mql = window.matchMedia("only screen and (max-width : 767px) and (orientation: portrait)");
  // var d = document.getElementById("custom_cards");

  // if (typeof d !== 'undefined') {
  //   if(mql.matches) {  
  //     d.classList.remove('four');
  //     d.classList.add("two");
  //   } else {
  //     d.classList.remove("two");  
  //     d.classList.add("four");
  //   }

  //   mql.addListener(function(m) {
  //     if(m.matches) {
  //       d.classList.remove("four");
  //       d.classList.add("two");
  //     }
  //     else {
  //       d.classList.remove("two");  
  //       d.classList.add("four");
  //     }
  //   });
  // }

	// $('.message .close').on('click', function() {
 //    $(this)
 //      .closest('.message')
 //      .transition('fade')
 //    ;
 //  });

 //  $(".colorpicker_name").spectrum({
 //    allowEmpty:true,
 //    preferredFormat: "hex",
 //    showInput: true
 //  });

 //  $(".colorpicker_bio").spectrum({
 //    allowEmpty:true,
 //    preferredFormat: "hex",
 //    showInput: true
 //  });

 //  $(".colorpicker_singlelink").spectrum({
 //    allowEmpty:true,
 //    preferredFormat: "hex",
 //    showInput: true
 //  });

 //  $(".colorpicker_topbg").spectrum({
 //    allowEmpty:true,
 //    preferredFormat: "hex",
 //    showInput: true
 //  });

 //  $(".colorpicker_botbg").spectrum({
 //    allowEmpty:true,
 //    preferredFormat: "hex",
 //    showInput: true
 //  });

 //  $(".colorpicker_text_demo").spectrum({
 //    allowEmpty:true,
 //    preferredFormat: "hex",
 //    showInput: true,
 //    color: "#000000",
 //    disabled: true
 //  });


 //  $(".colorpicker_background_demo").spectrum({
 //    allowEmpty:true,
 //    preferredFormat: "hex",
 //    showInput: true,
 //    color: "#e7ecef",
 //    disabled: true
 //  });

  $(".colorpicker_card_name").spectrum({
    allowEmpty:true,
    preferredFormat: "hex",
    showInput: true
  });

  $(".colorpicker_card_username").spectrum({
    allowEmpty:true,
    preferredFormat: "hex",
    showInput: true
  });

  $(".colorpicker_card_background").spectrum({
    allowEmpty:true,
    preferredFormat: "hex",
    showInput: true
  });

});