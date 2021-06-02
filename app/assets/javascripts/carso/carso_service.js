$(".tab__box").on("click", ".tab__box-nav .tab__b_n-m", function() {

    var tabs = $(".tab__box-nav .tab__b_n-m"),
        cont = $(".tab__box_txt .tab__box_txt_b span");

    tabs.removeClass("act");
    cont.removeClass("block-active");

    $(this).addClass("act");
    cont.eq($(this).index()).addClass("block-active");

    return false;
});

$(document).ready(function() {
    if ($(window).width() <= 500){
        var $card_box = $('.glpr');
        if (!$card_box.hasClass('slick-slider')){
            // $photos.scrollbar('destroy');
            $card_box.slick({
                lazyLoad: 'ondemand',
                slidesToShow: 1,
                slidesToScroll: 1,
                variableWidth: false,
                dots: false,
                infinite:false
            });
        }
    }
});