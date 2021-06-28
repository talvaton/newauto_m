//= require threesixty.min
//require carso/configurator

color_page = false;


$(document).ready(function() {
    workWithCuttedList();
    makeTemporarySlider();
    makeTemporarySliderCompl();
    makeTemporarySliderCard();
   // scrollOnTouch($('.table--features:not(.table--compare)').closest('.table-wrapper'));

    $(".img-colors").each(function() {
        $("img", this).first().attr("src", $("img", this).attr("data-altsrc"));
        $("img", this).first().addClass("showcar");
    });

    // configurator
    $("#config").on('click',function() {
        // car_url = $(this).data('car_id');
        // modal = $(this).data('show-modal-ajax');
        if (!DISABLE_FANCYBOX) {
            DISABLE_FANCYBOX = true;
            $.ajax({
                url: "/" + car_brand + "/" + car_url + "/configurator",
                type: 'POST',
                // data: {
                //     // put data here
                //     modal: modal
                // },
                error: function (e) {
                    console.log(e);
                }
            });
        }
    });

    // модалки модели
    $("[data-show-model-ajax]").on('click',function(e) {
        e.preventDefault();
        e.stopPropagation();
        modal = $(this).data('show-model-ajax');
        if (!DISABLE_FANCYBOX) {
            DISABLE_FANCYBOX = true;
            $.ajax({
                url: "/" + car_brand + "/" + carid,
                type: 'POST',
                data: {
                    modal: modal,
                },
                error: function (e) {
                    console.log(e);
                }
            }).then(function(){
                initAjaxModalCallback._callback();
            });
        }
    });

    // slider
    // $('[data-role="car-slider-programms"]').slick({
    //     // arrows: false,
    //     autoplay: true,
    //     autoplaySpeed: 3000,
    //     infinite: false,
    // });

    $('[data-action="show-table-row-description"]').on('click', function(e){
        if ($('.table__cell--fixed-w').has(e.target).length === 0){
            toggleTableDescription($(this));
        }
    });

    $("[data-action=hide-table-row-description]").on('click', function(){
        $(this).closest('[data-role="table-row-description"]').hide();
    });


    // toggleCarVisibleModal();

    workWithColorsSlider();

    $('[data-role="show-table-column"]').on('change', function(){
        var index = parseInt($(this).attr("id").substring($(this).attr("id").indexOf("_")+1), 10) +1,
            dataValue = $(this).parent().parent().parent().attr('data-show-tab-additional');
        var $table = $(this).closest('section').find('.table-wrapper[data-content-tab='+dataValue+']').find('.table--features');

        $table.find('.table__col-title:nth-of-type('+ (index +1) +')').toggle();
        $table.find('.table__cell:nth-of-type('+ index + ')').toggle();
    });
    changeDescriptonDisplay();
});

var toggleTableDescription = function(el){
     var desc_element = $(el).next('[data-role="table-row-description"]');
     if ($('.compl-description-content',desc_element).children().length == 0){
         url_path = $(el).data('url')
         $.ajax({
             url: url_path,
             type: 'post',
             beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
             error: function (e) {
                 console.log(e);
             }
         });
     }
    $(el).next('[data-role="table-row-description"]').toggle();
};

function ShowCarColor(color_id){
    var car = $("[data-image-index=" + color_id + "]");
    car.attr("src",car.attr("data-altsrc"));
    $(car).on('load',function(){
        car.siblings().removeClass("showcar");
        car.addClass("showcar");
    });
}



/* работа с гармошкой - на странице 1 авто */
var workWithCuttedList = function(){

    var $list = $('.card-list--cutted');
    $list.each(function(index, elem){
        var $openBtn = $(elem).closest('section').find('[data-action="show-all-cars"]');
        var amount = $(elem).hasClass('card-list--cutted') ? ($($(elem).children()[0]).hasClass('card--narrow')) ? 5 : 4 : ($($(elem).children()[0]).hasClass('card--narrow')) ? 10 : 8;
        // var amount = $(elem).hasClass('card-list--cutted') ? ($($(elem).children()[0]).hasClass('card--narrow')) ? 5 : 4 : ($($(elem).children()[0]).hasClass('card--narrow')) ? 10 : 8;
        if ($(elem).children().length < amount) {
            $openBtn.addClass('hidden');
            $(elem).next('.text-link').removeClass('hidden');
            // if ($(elem).children().length < amount){
            //     $(elem).next('.text-link').addClass('text-link--btn-modified');
            //     var listWidth = $($(elem).children()[0]).outerWidth() * $(elem).children().length;
            //     if ($(window).width() >= BREAKPOINTS.LG){ $(elem).next('.text-link').css({'right':'auto', 'left': listWidth}); }
            // }
        } else {
            $openBtn.removeClass('hidden');
        }
    });
    var $openBtn = $('[data-action="show-all-cars"]');
    $openBtn.on('click', function(e){
        e.preventDefault();
        var self = $(this);
        var $list = self.closest('section').find('.card-list');
        var $link = $list.next('.text-link');
        // if ($list.hasClass('card-list--cutted') || $list.hasClass('card-list--cutted-visible')) $list.toggleClass('card-list--cutted card-list--cutted-visible');
        // else $list.toggleClass('card-list--cutted-filter card-list--cutted-filter-visible');

        if ($list.hasClass('card-list--cutted') || $list.hasClass('card-list--cutted-visible')) {
            $list.toggleClass('card-list--cutted card-list--cutted-visible');
            if ($list.hasClass('card-list--cutted-filter') || $list.hasClass('card-list--cutted-filter-visible')) {
                $list.toggleClass('card-list--cutted-filter card-list--cutted-filter-visible');
            }
        }

        if ($link.length) $link.toggleClass("hidden");
        if ($list.hasClass('card-list--cutted-visible') || $list.hasClass('card-list--cutted-filter-visible'))
        {
            $('svg',self).hide();
            $('span',self).text('Свернуть');
        }
        else{
            $('svg',self).show();
            $('span',self).text('Показать ещё');
        }
    });
    //changeCuttedListDisplay();
};

// слайдер Описания
var changeDescriptonDisplay = function(){
    var $list = $("[data-role=car-description]");
    // var slides = ($(window).width() <= BREAKPOINTS.SM) ? 1 : ($(window).width() <= BREAKPOINTS.L) ? 2 : 4;
    $list.each(function(index, elem){

        if ($(elem).hasClass('slick-slider')) $(elem).slick('unslick');

        if ($(elem).children().length > 1){
            $(elem).slick({
                lazyLoad: 'ondemand',
                slidesToShow: 1,
                slidesToScroll: 1,
                dots: false,
                infinite: false,
            })
        }




    });
};

var changeDescriptonDisplayDebounce = debounce(changeDescriptonDisplay, 50);


/* замена скролл на сладер в галерее */
var makeTemporarySlider = function(){
    var $photos = $('[data-role="photogallery"]');
    //if ($(window).width() <= BREAKPOINTS.L){
        if (!$photos.hasClass('slick-slider')){
            // $photos.scrollbar('destroy');
            $photos.slick({
                lazyLoad: 'ondemand',
                slidesToShow: 4,
                slidesToScroll: 1,
                dots: false,
                infinite:false,
                responsive: [
                    {
                        breakpoint: 600,
                        settings: {
                            slidesToShow: 1,
                            slidesToScroll: 1
                        }
                     }
                  ]
            });
        }

  /*  } else {
        if($photos.hasClass('slick-slider')) {
            $photos.slick('unslick');
            // $photos.scrollbar();
        }
    }*/
};

/* Сравнение копл*/
var makeTemporarySliderCompl = function(){
    var $photos = $('#equipment-bl');
    //if ($(window).width() <= BREAKPOINTS.L){
   // if (!$photos.hasClass('slick-slider')){
        // $photos.scrollbar('destroy');
        $photos.slick({
            lazyLoad: 'ondemand',
            slidesToShow: 3,
            slidesToScroll: 1,
            dots: false,
            infinite:false,
            variableWidth: true,
            responsive: [
                {
                    breakpoint: 1020,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1,
                        centerMode: false
                    }
                }
            ]
        });
   // }

    /*  } else {
          if($photos.hasClass('slick-slider')) {
              $photos.slick('unslick');
              // $photos.scrollbar();
          }
      }*/
};

var makeTemporarySliderCard = function(){
  /*  var $card_box = $('.card_box_slide');
    //if ($(window).width() <= BREAKPOINTS.L){
    if (!$card_box.hasClass('slick-slider')){
        // $photos.scrollbar('destroy');
        $card_box.slick({
            //lazyLoad: 'ondemand',
            slidesToShow: 4,
            slidesToScroll: 1,
            //rows: 4,
            dots: false,
            infinite:true
        });
    }*/

    /*  } else {
          if($photos.hasClass('slick-slider')) {
              $photos.slick('unslick');
              // $photos.scrollbar();
          }
      }*/
};





// расчет цены в таблице в зависимости от выбранных акций
var CURRENT_DISCOUNT = parseInt($('#discount').text().replace(/\s+/, ''),10),
    TEN_PERCENT = false;

function numberWithSpaces(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}

function countpercent(percent, price_index) {
    price_index = parseInt(price_index, 10);
    if (percent_prices[price_index]) {
        base_price = parseInt(percent_prices[price_index].base_price, 10);
        realprice = base_price * percent / 100;
        percent_prices[price_index].discount = Math.round(realprice);
    } else {
        realprice = 0;
    }

    return parseInt(realprice, 10);
}

var profitcheck = [
    {
        name: "spec",
        checked: true,
        discount: $('#spec').val(),
        ids_to_uncheck: false,
        ids_to_aggregate: ["util", "cash"]
    }, {
        name: "util",
        checked: false,
        discount: $('#util').val(),
        ids_to_uncheck: false,
        ids_to_aggregate: ["spec", "cash"]
    }, {
        name: "cash",
        checked: false,
        discount: $('#cash').val(),
        ids_to_uncheck: ["gospr_family", "gospr_first", "credit", "ten_perc"],
        ids_to_aggregate: false
    }, {
        name: "credit",
        checked: false,
        discount: $('#credit').val(),
        ids_to_uncheck: ["cash"/*, "ten_perc"*/],
        ids_to_aggregate: false
    }, {
        name: "trade_in_3y",
        checked: true,
        discount: $('#trade_in_3y').val(),
        ids_to_uncheck: false,
        ids_to_aggregate: false
    }, {
        name: "ten_perc",
        checked: false,
        discount: $('#ten_perc').val(),
        ids_to_uncheck: ["cash"/*, "credit"*/],
        ids_to_aggregate: false
    }, {
        name: "gospr_first",
        checked: false,
        discount: [],
        ids_to_uncheck: [/*"gospr_family", */"cash"],
        ids_to_aggregate: false
    }, {
        name: "gospr_family",
        checked: false,
        discount: [],
        ids_to_uncheck: [/*"gospr_first", */"cash"],
        ids_to_aggregate: false
    }];

var discount_sorted = [];
var price_index = 0;
function adjustprice(price) {

    price_index = 0;
    $('[data-role="discount_price"]').each(function() {
        str = $(this).data('real-price');
        realprice = parseInt(str);
        realprice = realprice + price;
        if (realprice > percent_prices[price_index].base_price*6/10) r_p = realprice;
        else r_p = percent_prices[price_index].base_price - parseInt(percent_prices[price_index].base_price*4/10,10);
        $(this).data('real-price', realprice);
        $(this).text(numberWithSpaces(r_p));
        price_index++;
    });
    price_index = 0;
    $('[data-role="discount_sale"]').each(function() {
        str = $(this).data('real-discount');
        realprice = parseInt(str, 10);
        realprice = realprice - price;
        if (realprice < percent_prices[price_index].max_discount) r_p = realprice;
        else r_p = parseInt(percent_prices[price_index].max_discount, 10);
        $(this).data('real-discount',realprice);
        $(this).text(numberWithSpaces(r_p));
        discount_sorted[price_index] = {
            'realsale' : realprice,
            'sale': r_p
        };
        price_index++;
    });
    discount_sorted.sort(function(a,b) {
        return Math.abs(b['sale']) - Math.abs(a['sale']);
    });
    var $form_price = $('#discount'),
        $total_discount = $('#discount-counted, #modal-discount');
    $form_price.data('real-discount', discount_sorted[0]['realsale']);
    $form_price.text(numberWithSpaces(discount_sorted[0]['sale']));
    $total_discount.data('real-discount', discount_sorted[0]['realsale']);
    $total_discount.text(numberWithSpaces(discount_sorted[0]['sale']));
}



function adjustpercentprice(percent) {
    price_index = 0;
    $('[data-role="discount_price"]').each(function() {
        str = $(this).data('real-price');
        realprice = parseInt(str,10);
        realprice = realprice + countpercent(percent, price_index);
        if (realprice > percent_prices[price_index].base_price*6/10) r_p = realprice;
        else r_p = percent_prices[price_index].base_price - parseInt(percent_prices[price_index].base_price*4/10,10);
        $(this).data('real-price', realprice);
        $(this).text(numberWithSpaces(r_p));
        price_index++;
    });
    price_index = 0;
    $('[data-role="discount_sale"]').each(function() {
        str = $(this).data('real-discount');
        realprice = parseInt(str, 10);
        realprice = realprice - percent_prices[price_index].discount;
        if (realprice < percent_prices[price_index].max_discount) r_p = realprice;
        else r_p = parseInt(percent_prices[price_index].max_discount, 10);
        $(this).data('real-discount', realprice);
        $(this).text(numberWithSpaces(r_p));
        discount_sorted[price_index] = {
            'realsale' : realprice,
            'sale': r_p
        };

        price_index++;
    });
    discount_sorted.sort(function(a,b) {
        return Math.abs(b['sale']) - Math.abs(a['sale']);
    });
    var $form_price = $('#discount'),
        $total_discount = $('#discount-counted');
    $form_price.data('real-discount', discount_sorted[0]['realsale']);
    $form_price.text(numberWithSpaces(discount_sorted[0]['sale']));
    $total_discount.data('real-discount', discount_sorted[0]['realsale']);
    $total_discount.text(numberWithSpaces(discount_sorted[0]['sale']));
}




var workWithColorsSlider = function(){

    // задаем высоту и ширину картинок
    // setColorsSliderSize();

    // загружаем первую и вторую картинку
  /*  $("[data-content=car-colors-list]").each(function() {
        var firstChild = $(this).find('.img-comp-img').first();
        if (firstChild.length) {
            //  firstChild.addClass('showcar img-comp-overlay hidden');
            var firstChildImg = firstChild.find('img');
            firstChildImg.attr("src", firstChildImg.attr("data-altsrc"));
        }
        var secondChild = $(this).find('.img-comp-img:nth-of-type(2)');
        if (secondChild.length) {
            secondChild.addClass('img-open');
            var secondChild = secondChild.find('img');
            secondChild.attr("src", secondChild.attr("data-altsrc"));
        }
    });*/



    // меняем картинки цветов по клику
    $("[data-action=show-color]").click(function(e) {
        e.preventDefault();

        var self = this,
            color_id = $(this).data('color_index'),
            $car = $("[data-image-index=" + color_id + "]");

        function changeColorImg() {
            if (!$(self).hasClass('color--choosed')) {

                if ($("[data-content=choose-left-color] .color--choosed").data('color_index') === color_id) {
                    var leftColor = $("[data-content=choose-left-color] .color--choosed"),
                        newLeftColorInd = color_id + 1;
                    if ((newLeftColorInd+1) > $("[data-content=choose-left-color] .color").length) newLeftColorInd = 0;
                    var  newLeftColor = $("[data-content=choose-left-color] [data-color_index="+ newLeftColorInd +"]");

                    leftColor.removeClass('color--choosed');
                    newLeftColor.addClass('color--choosed');

                    $('.img-comp-overlay').removeClass('showcar img-comp-overlay hidden');
                    $("[data-image-index=" + newLeftColorInd + "]").parents('.img-comp-img').addClass('img-comp-overlay hidden');
                }

                $("[data-content=choose-right-color] [data-action=show-color]").removeClass('color--choosed');
                $(self).addClass('color--choosed');
                $('.img-open').removeClass('img-open');
                $car.parents('.img-comp-img').addClass('img-open');

            }
        }

        if ($car.attr("src") !== $car.attr("data-altsrc")) {
            $car.attr("src",$car.attr("data-altsrc"));
            $($car).on('load',function(){
                changeColorImg();
            });
        } else {
            changeColorImg();
        }

    });


};

// слайдер сравнения картинок
var unify = function(e) {	return e.changedTouches ? e.changedTouches[0] : e };

var compareImages = function(img) {
    var clicked = 0,
        w = img.offsetWidth,
        slider = document.getElementById('sliderBtn');

    $(img).animate({'width': (w / 2) + "px"}, 1000, );
    $(slider).animate({'left': (w / 2) - (slider.offsetWidth / 2) + "px"}, 1000, function ()  {
        slider.addEventListener("mousedown", slideReady, false);
        slider.addEventListener("touchstart", slideReady, false);

        window.addEventListener("mouseup", slideFinish, false);
        window.addEventListener("touchstop", slideFinish, false);
    });

    function slideReady(e) {
        clicked = 1;
        window.addEventListener("mousemove", slideMove, false);
        window.addEventListener("touchmove", slideMove, false);
    }
    function slideFinish() {
        clicked = 0;
    }
    function slideMove(e) {
        //HACK: обнуляем ширину предыдущей overlay картинки
        var imgs = document.querySelectorAll('.img-comp-img:not(.img-comp-overlay)');
        for (i = 0; i < imgs.length; i++) {
            imgs[i].style.width = 'auto';
        };

        var pos;
        if (clicked == 0) return false;
        pos = unify(e).clientX - $(img).offset().left;

        if (pos < 0) pos = 0;
        if (pos > w) pos = w;

        slide(pos);
    }

    function slide(x) {
        img.style.width = x + "px";
        slider.style.left = img.offsetWidth - (slider.offsetWidth / 2) + "px";
    }
};


// отметить разные позиции в таблице Тех хар-к
$("#show-diff").on('change',function(){
    var $table = $("#car-features").find('.table--compare');
    if ($(this).prop('checked') === true ) {
        $table.find('tbody tr').each(function(ind, elem){
            var equal = true,
                tds = $(elem).find('td'),
                tdsArr = [].map.call(tds, function(el) {
                    return $(el).text();
                });
            tdsArr.reduce(function(prev, curr){
                if (prev.toLowerCase().replace(/\s/g, '') !== curr.toLowerCase().replace(/\s/g, '')) equal = false;
                return prev;
            });
            if (!equal) $(elem).addClass('matched');
        })
    } else {
        $table.find('.matched').removeClass('matched');
    }
});

// отметить сравнение позиции в таблице Тех хар-к
$("#show-fdiff").on('change',function(){
    var $table = $("#car-features").find('.ttf');
    if ($(this).prop('checked') === true ) {
        $table.find('tbody tr').each(function(ind, elem){
            var equal = true,
                tds = $(elem).find('td'),
                tdsArr = [].map.call(tds, function(el) {
                    return $(el).text();
                });
            tdsArr.reduce(function(prev, curr){
                if (prev.toLowerCase().replace(/\s/g, '') !== curr.toLowerCase().replace(/\s/g, '')) equal = false;
                return prev;
            });
            if (!equal) $(elem).addClass('matched');
        })
    } else {
        $table.find('.matched').removeClass('matched');
    }
});

// фильтр наличия авто
$('#new_car_filter_new_ticket').on('change', 'select', function(){

    $("#filter-results").html("");
    $("[data-action=show-all-cars]").hide();
    $("#filter_loader").show();

    var data = {
        compl : $("#filter_compl").val(),
        transmission: $("#filter_transmission").val(),
        volume : $("#filter_volume").val(),
        drive : $("#filter_drive").val(),
    };

    $.ajax({
        url: $('#new_car_filter_new_ticket').attr('action'),
        type: 'post',
        data: data,
        beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
        error: function (e) {
            console.log(e);
        }
    }).then(function(){
        $("#filter_loader").hide();
        $("#filter-results").show();

        var cardAmount = ($(window).width() < 600) ? 1 : ($(window).width() < 1024) ? 2 : 4;
        if ($("#filter-results .card").length > cardAmount) $("[data-action=show-all-cars]").show();

        init_new_ajax_modal();
    });
});




// Работа с кол-вом
// эти переменные записываем глобально и обращаемся к ним при фильтрации
var QUANTITY = ['2','3','4','5','6', '7',' > 7'],
    COLOR_GROUPS = COLOR_GROUPS,
    COLOR_GROUPS = COLOR_GROUPS;
//     COMPL_GROUPS = [[], [], []],
//     COLOR_GROUPS = [[], [], []];
// // группируем цвета по index в 3 группы по очереди #[[0,3,6], [1,4], [2,5]]
// var $cl = $('[data-role="filter-colors"] li');
// for ( var i=0; i< $cl.length; i++ ) {
//     if ( ( (i+1) % 3 ) === 0) {
//         COLOR_GROUPS[2].push($($cl[i]).data('color_index'));
//     } else if (( (i+1) % 2 ) === 0) {
//         COLOR_GROUPS[1].push($($cl[i]).data('color_index'));
//     } else {
//         COLOR_GROUPS[0].push($($cl[i]).data('color_index'));
//     }
// };
// console.log(COLOR_GROUPS);
//
// // группируем комплектации по id в 3 группы по очереди #[[234,238,235], [347,343,344], [356,378]]
// var $tr = $('#filter_list tbody tr');
//
// // составим массив и отсортируем по возрастанию
// var trsArr = [].map.call($tr, function(el) {
//     return $(el).data('eq_id');
// });
// function compareNumeric(a, b) {
//     if (a > b) return 1;
//     if (a < b) return -1;
// }
// trsArr.sort(compareNumeric);
//
// for ( var i=0; i< trsArr.length; i++ ) {
//     if ( ( (i+1) % 3 ) === 0) {
//         COMPL_GROUPS[2].push(trsArr[i]);
//     } else if (( (i+1) % 2 ) === 0) {
//         COMPL_GROUPS[1].push(trsArr[i]);
//     } else {
//         COMPL_GROUPS[0].push(trsArr[i]);
//     }
// };
// console.log(COMPL_GROUPS);

var $card = $('#filter_list .card');
var setQuantity = function($card){
    // ищем соответствие для цвета
    var color_ind = $('[data-role="filter-colors"] .color--choosed').data('color_index');
    if (COLOR_GROUPS) {
        COLOR_GROUPS.map(function(elem, i){
            if (elem.indexOf(color_ind) !== -1) return color_ind = i;
        });
    }


    // для каждой строки ищем соответствие
    var arr = [].map.call ($card, function (elem) {
        return elem;
    });

    arr.map(function (elem, ind) {

        var id = $(elem).data('eq_id');
        if (COMPL_GROUPS) {
            COMPL_GROUPS.map(function(elem, i){
                if (elem.indexOf(id) !== -1) return id = i;
            });
        }

        if (color_ind === 0) {
            if (id === 0) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[4]);
            } else if (id === 1) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[3]);
            } else if (id === 2) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else if (id === 3) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            } else {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            }
        } else if (color_ind === 1) {
            if (id === 0) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else if (id === 1) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[2]);
            } else if (id === 2) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[6]);
            } else if (id === 3) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[3]);
            } else {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            }
        } else if (color_ind === 2) {
            if (id === 0) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            } else if (id === 1) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else if (id === 2) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[3]);
            } else if (id === 3) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[5]);
            } else {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[4]);
            }
        } else if (color_ind === 3) {
            if (id === 0) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else if (id === 1) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            } else if (id === 2) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else if (id === 3) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            }
        } else {
            if (id === 0) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            } else if (id === 1) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else if (id === 2) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            } else if (id === 3) {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[0]);
            } else {
                $(elem).find('[data-role="quantity"]').text(QUANTITY[1]);
            }
        }

        if (ind === (arr.length -1) ) {
            setTimeout(function(){
                $("#filter_loader").hide();
                $("#filter_list .card-list").show();

            }, 2000);
        }
    });
};
// setQuantity($card);


// Работа с цветами и наличием
var COLOR_URL;
$('[data-action="choose-filter-color"]').on('click', function(e){
    e.preventDefault();
    $("#filter_loader").show();
    $("[data-action=show-all-cars]").hide();
    $("#filter_list .card-list").hide();

    $('[data-role="filter-colors"] .color--choosed').removeClass('color--choosed');
    $(this).addClass('color--choosed');
    COLOR_URL = $(this).data('image-url');
    $("#filter_list img").attr('src', COLOR_URL);
    var $card = $('#filter_list .card');
    setQuantity($card);

    setTimeout(function(){
        $("#filter_loader").hide();
        $("#filter_list tbody").show();

        var cardAmount = ($(window).width() < 600) ? 1 : ($(window).width() < 1024) ? 2 : 4;
        if ($("#filter-results .card").length > cardAmount) $("[data-action=show-all-cars]").show();
    }, 2000);
});


// Прокрутить к инфо о комплектации
var showMoreComplInfo = function(){
    if ($('#car-kit').length > 0) {
        $('[data-action="show-compl-info"]').on('click', function(e){
            e.preventDefault();
            var id = $(this).data('eq_id');
            var $info_tr = $(".creditcompl[data-eq_id="+id+"]").closest('[data-action=show-table-row-description]');
            var top = $info_tr.offset().top;

            $('html, body').animate({scrollTop: top}, 600, function(){
                $info_tr.next('[data-role="table-row-description"]').show();

            })
        })

    }
};
showMoreComplInfo();

var workWithCarSideNav = function(){
    // Расположение кнопки
    var changeCarSideFixedNavPosition = function(){
        var $sidenav = $('.car-nav');
        var windowTop = $(window).scrollTop(),
            headerOffset = $('.header').outerHeight();
        if (windowTop < headerOffset) {
            $sidenav.css('top',  headerOffset + 10);
        } else {
            $sidenav.css('top',  '10px');
        };

        $('.car-nav__btn').show();
    };
    changeCarSideFixedNavPosition();
    var changeCarSideFixedNavPositionDebounce = debounce(changeCarSideFixedNavPosition, 10);
    $(window).on('scroll', changeCarSideFixedNavPositionDebounce);

    // Открытие меню
    $('.car-nav__btn').on('click', function (e) {
        e.preventDefault();
        $(this).toggleClass('car-nav__btn--active');
        $('.car-nav__nav').toggleClass('car-nav__nav--visible');
        $('.wrapper').toggleClass('wrapper--covered');
        setTimeout(function(){
            $('.car-nav__item').toggleClass('car-nav__item--visible');
        }, 300)
    });

    // Клик на ссылку
    $('.car-nav__link').on('click', function(e){
        e.preventDefault();
        var id = $(this).attr('href');
        var blockOffset = $(id).offset().top;
        $('.car-nav__btn').click();
        $('html, body').animate({scrollTop: (blockOffset - 20)}, 300, function(){ });
    });
};
workWithCarSideNav();


var workWithKitGallery = function(){
    var $gallery = $('[data-role="kit-gallery"]');
    $gallery.each(function(ind, elem){
        var $info = $(elem).find('.card__gallery-icon'),
            $item = $(elem).find('[data-role="kit-gallery-item"]'),
            $img = $(elem).find('figure img'),
            $text = $(elem).find('figure figcaption');
        $item.on('mouseenter', function (e) {
            var src = $(this).data('src'),
                text = $(this).data('text');
            $img.attr('src', src);
            $text.text(text);
        });
        $info.on('mouseenter', function(e){
            $info.addClass('hidden');
            $text.addClass('card__gallery-figcaption--visible');
        })
        $text.on('mouseleave', function(e){
            $info.removeClass('hidden');
            $text.removeClass('card__gallery-figcaption--visible');
        })
    });


};
workWithKitGallery();

$('[data-action="toggle-description"]').on('click', function(e){
    e.preventDefault();
    var $desc = $(this).closest('section').find('.car-description'),
        $btn = $(this).closest('section').find('.button');
    $desc.toggleClass('car-description--sm');
    $btn.toggleClass('btn-link--open');
    if ($desc.hasClass('car-description--sm')) {
        $btn.text('Читать полностью')
    } else {
        $btn.text('Скрыть')
    }
});



// работа с табами описания
$('[data-show]').each(function(ind,elem){
    $(elem).on('click', function(){
        $('.singlecar__info-tablink--active').removeClass('singlecar__info-tablink--active');
        $(elem).addClass('singlecar__info-tablink--active');

        $('.singlecar__info-tab').hide();
        $('.singlecar__info-tabs [data-content=' + $(elem).data('show') + ']').show();
    })
});




// работа с табами таблиц
$('[data-show-tab]').each(function(ind,elem){
    $(elem).on('click', function(){
        $('.table-tab-title--active').removeClass('table-tab-title--active');
        $(elem).addClass('table-tab-title--active');

        $('.table-wrapper[data-content-tab]').hide();
        $('.table-wrapper[data-content-tab=' + $(elem).data('show-tab') + ']').show();

        $('[data-show-tab-additional]').hide();
        $('[data-show-tab-additional=' + $(elem).data('show-tab') + ']').show();
    })
});


/*$(document).ready(function() {
    if ($(window).width() <= BREAKPOINTS.M){
        var $card_box = $('.in_stock_block .is_main');
        if (!$card_box.hasClass('slick-slider')){
            // $photos.scrollbar('destroy');
            $card_box.slick({
                lazyLoad: 'ondemand',
                slidesToShow: 2,
                slidesToScroll: 1,
                variableWidth: true,
                dots: false,
                infinite:false
            });
        }
    }
});*/

//slick
/*$('.img_gg').slick({
    //  lazyLoad: 'progressive',
    slidesToShow: 2,
    slidesToScroll: 1,
    arrows: true,
    fade: true,
    dots: false,
    mobileFirst: false,
    asNavFor: '.colors-list',
});*/


