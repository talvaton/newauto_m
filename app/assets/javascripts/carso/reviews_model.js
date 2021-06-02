$(document).ready(function() {
    $(".img-colors").each(function() {
        $("img", this).first().attr("src", $("img", this).attr("data-altsrc"));
        $("img", this).first().parents('.singlecar__car-img-link').addClass("showcar");
    });

    // var showColorOnHover = function(elem){
    //     var color_id = $(elem).data('color_index');
    //     ShowCarColor(color_id);
    // };
    // var showColorOnClick = function(elem){
    //     var color_link = $(elem).attr('href');
    //     window.location = color_link
    // };

    $(".color").each(function(ind, elem){
        $(elem).on('click',function(e) {
            e.preventDefault();
            var color_id = $(elem).data('color_index');
            ShowCarColor(color_id);
            $(elem).siblings().removeClass('color--choosed');
            $(elem).addClass('color--choosed');

        });
    });

    // if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
    //     var colorId = undefined;
    //     $(".color").each(function(ind, elem){
    //         var secondClick = false;
    //         $(elem).on('click',function(e) {
    //             e.preventDefault();
    //             var currentColorId = $(elem).data('color_index');
    //
    //             if (colorId !== currentColorId ) {
    //                 colorId = currentColorId;
    //                 secondClick = false;
    //             } else {
    //                 secondClick = true;
    //             }
    //
    //             if (!secondClick){
    //                 secondClick = true;
    //                 showColorOnHover(elem);
    //             } else {
    //                 showColorOnClick(elem);
    //             }
    //
    //         });
    //     });
    // } else {
    //     $(".color").hover(function() {
    //         showColorOnHover(this);
    //     });
    // }
});

function ShowCarColor(color_id){
    var car = $("[data-image-index=" + color_id + "]");
    car.attr("src",car.attr("data-altsrc"));
    $(car).on('load',function(){
        car.parents('.singlecar__car-img-link').siblings().removeClass("showcar");
        car.parents('.singlecar__car-img-link').addClass("showcar");
    });
}

var youtube = document.querySelectorAll( ".youtube" );
for (var i = 0; i < youtube.length; i++) {
    // var source = "https://img.youtube.com/vi/"+ youtube[i].dataset.embed +"/sddefault.jpg";
    //
    // var image = new Image();
    // image.src = source;
    // image.addEventListener( "load", function() {
    //     youtube[ i ].appendChild( image );
    // }( i ) );

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