//= require rangeslider.min
//= require carso/rangeslider



brand = 0;
$('#credit_ticket_other_marka').on('change',function(){
    brand = $('#credit_ticket_other_marka').val();
    $.ajax({
        url: "/credit",
        type: 'post',
        data: {brand: brand},
        beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
        error: function (e) {
            console.log(e);
        }
    });
});

$('#credit_ticket_other_model').on('change',function(){
    model = $('#credit_ticket_other_model').val();
    $.ajax({
        url: "/credit",
        type: 'post',
        data: {model: model},
        beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
        error: function (e) {
            console.log(e);
        }
    });
});
$(document).ready(function() {
  if ($(window).width() <= BREAKPOINTS.LG) {
      $('#finance__item').slick({
          rows: 3,
          dots: false,
          arrows: true,
          infinite: false,
         // variableWidth: true,
          //lazyLoad: 'ondemand',
          //speed: 300,
          slidesToShow: 5,
          slidesToScroll: 5,
          responsive: [

              {
                  breakpoint: 1080,
                  settings: {
                      slidesToScroll: 4,
                      slidesToShow: 4
                  }
              },
              {
                  breakpoint: 860,
                  settings: {
                      rows: 3,
                      slidesToScroll: 3,
                      slidesToShow: 3
                  }
              },
              {
                  breakpoint: 660,
                  settings: {
                      rows: 3,
                      slidesToScroll: 3,
                      slidesToShow: 3
                  }
              },
              {
                  breakpoint: 480,
                  settings: {
                      variableWidth: true,
                      rows: 3,
                      slidesToScroll: 2,
                      slidesToShow: 2
                  }
              }
          ]
      });
  }
})

