//= require carso/price_selector

$(document).ready(function() {
    initTopMainSlider();
    if ($('[data-role="topslider-list"] .main-top').outerHeight() === 0){
        // console.log('zero height');
        setTimeout(function(){
            // console.log('reinit');
            $('[data-role="topslider-list"]').slick('unslick');
            initTopMainSlider();
        }, 1500)

    }
    price_select();



});

$(window).on('resize', function(){
    initTopMainSliderDebounce();

});

/* инициализация top-slider slick-slider */
var initTopMainSlider = function(){
    var $topSlider = $('[data-role="topslider-list"]');
    if ($topSlider.hasClass('slick-slider')) $topSlider.slick('unslick');
    var newHeight = $topSlider.find('img').outerHeight();
    $topSlider.find('.main-top').height(newHeight);
    $topSlider.slick({
        arrows: false,
        dots: true,
        slidesToShow: 1,
        autoplay: true,
        autoplaySpeed: 6000,
        infinite: false,
    });
};
var initTopMainSliderDebounce = debounce(initTopMainSlider, 50);


// фильтр
var currentPage = 1,
    isPaginating = false,
    pagesAmount;

var sendFilter = function(e){
    currentPage = 1;

    $("#filter-results").hide();
    $("#filter-results tbody").html("");
    $("#show-more-filter-results").hide();
    $("#filter_loader").show();

    var data = {
        brand: $('#filter_brand').val(),
        transmission: $("#filter_transmission").val(),
        drive : $("#filter_drive").val(),
        engine: $("#filter_engine").val(),
        type: $("#filter_type").val(),
        country: $("#filter_country").val(),
        volume_min : $("#filter_volume_min").val(),
        volume_max : $("#filter_volume_max").val(),
        power_min : $("#filter_power_min").val(),
        power_max : $("#filter_power_max").val(),
        price_min : $("#filter_price_min").val(),
        price_max : $("#filter_price_max").val(),
        page:1
    };

    $.ajax({
        url: "/filter",
        type: 'post',
        data: data,
        beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
        error: function (e) {
            console.log(e);
        }
    }).then(function(){
        setTimeout(function(){
            $("#filter_loader").hide();
            $("#filter-results").show();
            if (currentPage < pagesAmount)  $("#show-more-filter-results").show();
        }, 2000);
    });
};

$('#brands_filter_new_ticket').on('change', 'select, input', function(){
    sendFilter();
});
$('#brands_filter_new_ticket').on('keypress', 'select, input', function(e){
    if (e.charCode === 13 ) {
        e.preventDefault();
        $(e.target).change();
    }
});


$("[data-role=filter-countries-list]").on('click', 'li', function(e){
    e.preventDefault();
    $("[data-role=filter-countries-list] li").removeClass('color--choosed');
    $(this).addClass('color--choosed');
    $("#filter_country").val($(this).data('value')).change();
});

$("[data-action=filter-reset]").on('click', function(e){
    e.preventDefault();
    console.log($(this).closest('form').length);
    $(this).closest('form')[0].reset();
    $('[data-role=filter-countries-list] li:first-child').click();
});

var uploadCars = function(){

    $("#show-more-filter-results").on('click', function(){
        $(this).hide();
    if (!isPaginating && currentPage < pagesAmount) {
        currentPage++;
        isPaginating = true;
        $("#filter_loader").show();
        $.ajax({
            url: "/filter",
            type: 'post',
            data: {
                brand: $('#filter_brand').val(),
                transmission: $("#filter_transmission").val(),
                drive : $("#filter_drive").val(),
                engine: $("#filter_engine").val(),
                type: $("#filter_type").val(),
                country: $("#filter_country").val(),
                volume_min : $("#filter_volume_min").val(),
                volume_max : $("#filter_volume_max").val(),
                power_min : $("#filter_power_min").val(),
                power_max : $("#filter_power_max").val(),
                price_min : $("#filter_price_min").val(),
                price_max : $("#filter_price_max").val(),
                page_type: 'main',
                page:currentPage
            },
            beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
            error: function (e) {
                console.log(e);
            }
        }).then(function(e){
            isPaginating = false;
            $("#filter_loader").hide();
            if (currentPage < pagesAmount)  $("#show-more-filter-results").show();
        });
      }
    });
};

uploadCars();







