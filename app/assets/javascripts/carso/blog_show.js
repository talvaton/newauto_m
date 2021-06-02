/* замена скролл на сладер в галерее */
var makeTemporarySlider = function(){
    var $photos = $('[data-role="photogallery"]'),
        $kits = $('[data-role="car-kits-list"]');

    if ($(window).width() <= BREAKPOINTS.XS){
        if (!$photos.hasClass('slick-slider')){
            // $photos.scrollbar('destroy');
            $photos.slick({infinite: false,});
        }
        if (!$kits.hasClass('slick-slider')){
            $kits.slick({infinite: false,});
        }

    } else {
        if($photos.hasClass('slick-slider')) {
            $photos.slick('unslick');
            // $photos.scrollbar();
        }
        if($kits.hasClass('slick-slider')) $kits.slick('unslick');
    }
};

var youtube = document.querySelectorAll( ".youtube" );
for (var i = 0; i < youtube.length; i++) {
    youtube[i].addEventListener( "click", function() {
        var iframe = document.createElement( "iframe" );
        iframe.setAttribute("class","media-block__video");
        iframe.setAttribute( "frameborder", "0" );
        iframe.setAttribute( "allowfullscreen", "" );
        iframe.setAttribute( "src", "https://www.youtube.com/embed/"+ this.dataset.embed +"?rel=0&showinfo=0&autoplay=1" );

        this.innerHTML = "";
        this.appendChild( iframe );
    } );
}


$(function(){
    scrollOnTouch($('.table--features:not(.table--compare)').closest('.table-wrapper'));
    makeTemporarySlider();
});

$(window).on('resize', function(){
    makeTemporarySlider();
});