// расчет цены в таблице в зависимости от выбранных акций

var percent_prices = [];
$('[data-role="base_price"]').each(function() {
    percent_prices.push({
        base_price: parseInt($(this).text().replace(/\s+/g, ''), 10),
        max_discount: parseInt($(this).text().replace(/\s+/g, ''), 10)*0.4,
        discount: 0
    });
});

profitcheck.forEach(function(elem, ind){
    $('#' + elem.name).click(function() {

/*****checked********/
        if ($(this).prop('checked') === true ) {
            if (elem.name === 'trade_in_3y' || elem.name === 'credit' || elem.name === 'ten_perc'|| elem.name === 'spec') {
                $(this).parent().parent().addClass('on');
                $(this).parent().parent().parent().addClass('on');
            }
        } else {
            if (elem.name === 'trade_in_3y' || elem.name === 'credit' || elem.name === 'ten_perc'|| elem.name === 'spec') {
                $(this).parent().parent().removeClass('on');
                $(this).parent().parent().parent().removeClass('on');
            }
        }
/*************/


        if ($(this).prop('checked') === true ) {
            if (elem.name === 'gospr_first' || elem.name === 'gospr_family') {
                adjustpercentprice(-10);
                TEN_PERCENT = true;
            } else {
                adjustprice(0 - parseInt(elem.discount,10));
            }
        } else {
            if (elem.name === 'gospr_first' || elem.name === 'gospr_family') {
                adjustpercentprice(10);
                TEN_PERCENT = false;
            } else {
                adjustprice(parseInt(elem.discount, 10));
            }
        }
        if (elem.ids_to_uncheck.length) {
            var ids_to_uncheck = elem.ids_to_uncheck;
            for (var i=0; i<ids_to_uncheck.length; i++){
                if ($('#' + ids_to_uncheck[i]).prop('checked') === true ){
                    $('#' + ids_to_uncheck[i]).prop('checked', false);
                    if (ids_to_uncheck[i] === 'gospr_first' || ids_to_uncheck[i] === 'gospr_family') {
                        adjustpercentprice(10);
                    } else if (ids_to_uncheck[i] !== 'gospr_first' && ids_to_uncheck[i] !== 'gospr_family'){
                        for (var j in profitcheck){
                            if (profitcheck[j].name === ids_to_uncheck[i]){
                                adjustprice(parseInt(profitcheck[j].discount, 10));
                            }
                        }
                    }
                }

            }
        }

        var discount = 0;
        for (var el in profitcheck){
            if ($('#' + profitcheck[el].name).prop('checked') === true ) {
                if (profitcheck[el].name !== 'gospr_first' && profitcheck[el].name !== 'gospr_family') {
                    discount = discount + parseInt($('#' + profitcheck[el].name).val(),10);
                }
            }
        }
        CURRENT_DISCOUNT = discount;

        initAjaxModalCallback._custom = function(){
            var old_price = $('#car-credit-modal [data-role="old-price"]').text().replace(/\D+/g, '');
            var new_price = old_price - CURRENT_DISCOUNT;
            if (TEN_PERCENT) new_price = new_price - old_price*0.1;
            $('#car-credit-modal [data-role="new-price"]').text(numberWithSpaces(new_price) + '₽');
        };
    })
});


// корректировка цены в таблице в зависимости от компенсации
$("#compensation").on('change', function(){
   if ($(this).prop('checked') === true){
       CURRENT_DISCOUNT = CURRENT_DISCOUNT + 10000;
       adjustprice(-parseInt($(this).val(),10));
   } else {
       CURRENT_DISCOUNT = CURRENT_DISCOUNT - 10000;
       adjustprice(parseInt($(this).val(),10));
   }
    initAjaxModalCallback._custom = function(){
        var old_price = $('#car-credit-modal [data-role="old-price"]').text().replace(/\D+/g, '');
        var new_price = old_price - CURRENT_DISCOUNT;
        if (TEN_PERCENT) new_price = new_price - old_price*0.1;
        $('#car-credit-modal [data-role="new-price"]').text(numberWithSpaces(new_price) + '₽');
    };
});


$('[data-content=car-colors-list]').slick({
    lazyLoad: 'ondemand',
    /*slidesToShow: 9,*/
    //rows:2,
    /*slidesToScroll: 50,*/
    asNavFor: '.colors-list',
    arrows: false,
    dots: false,
    //centerMode: true,
    focusOnSelect: true,
    mobileFirst: false

});


$(document).ready(function() {
    $('.colors-list').slick({
        asNavFor: '[data-content=car-colors-list]',
        dots: false,
        arrows: true,
        //  infinite: false,
        //variableWidth: true,
        slidesToShow: 3,
        slidesToScroll: 1
    });
});
$(document).ready(function() {
     if ($(window).width() <= BREAKPOINTS.M) {
    $('.mrr_bl').clone().prependTo('.sbcf');
      }
});
