$(document).ready(function() {
    initConfigurator();
    if(typeof p_brand != 'undefined'){
        preselect_brand(p_brand)
    }
    else
    {
        preselect_brand('renault')
    }
});

function preselect_brand(brand){
    $('.config-brandsblock [data-brand="'+ brand +'"]').trigger('click');
}

function preselect_model(model){
    $('#modelblock_select').val(model);
}

function initConfigurator(){
    // переключение панелей
    var $showTabBtn = $('[data-show-tabpanel]'),
        $tabPanel = $('[data-role]');

    $showTabBtn.on('click', function(){
      /*  if (window.innerWidth <= 680) {
            $('html, body').animate({scrollTop: 180}, 'slow');
        }*/
        var showTabBtnData = $(this).data('show-tabpanel');

        // переключение кнопок меню
       // $('li.config-titles__tab--active').removeClass('config-titles__tab--active');
        $('li[data-show-tabpanel='+showTabBtnData+']').addClass('config-titles__tab--active');

        // переключение панелей
        $('.config-tabs__tab-active').removeClass('config-tabs__tab-active');
        $('[data-role='+showTabBtnData+']').addClass('config-tabs__tab-active');

        disableFormBtn();
        $('#newcar_config_new_ticket').enableClientSideValidations();
    });
}

// Слайдер с брендами
$(document).ready(function() {
    if( window.innerWidth <= 480 ){
        $('.config-brandsblock').slick({
            rows: 1,
            dots: false,
            arrows: true,
            infinite: false,
            slidesToShow: 1,
            slidesToScroll: 1
        });
    } else if ( window.innerWidth > 480 && window.innerWidth <= 1024) {
        $('.config-brandsblock').slick({
            rows: 4,
            dots: false,
            arrows: true,
            infinite: false,
            slidesToShow: 2,
            slidesToScroll: 2
        });
    }
});

// Слайдеры в мобильной версии
var next_button1 = $('.config-button[data-show-tabpanel="config-complect"].config-button_mob-next'),
    next_button2 = $('.config-button[data-show-tabpanel="config-engine"].config-button_mob-next'),
    next_button3 = $('.config-button[data-show-tabpanel="config-present"].config-button_mob-next'),
    MobileSlider = function(block){
        $(block).not('.slick-initialized').slick({
            rows: 2,
            dots: false,
            arrows: true,
            infinite: false,
            slidesToShow: 1,
            slidesToScroll: 1
        });
    },
    ResetSlider = function(slider){
        if ($(slider).hasClass('slick-slider')) {
            $(slider).slick('unslick').removeClass('slick-initialized slick-slider');
        };
    };
if (window.innerWidth <= 680) {
    next_button1.click(function () {
        MobileSlider('.config-complectblock');
    });
    next_button2.click(function () {
        MobileSlider('.config-engineblock');
    });
    next_button3.click(function () {
        MobileSlider('.config-presentblock');
    });
};

// скрытие/показ формы
/*var carConfigForm = $('.config-car__inner .form__bottom_block'),
    carConfigTab = $('.config-titles__tab'),
    carConfigBtn = $('.config-button');

carConfigTab.click(function(){
    if (($(this).attr('data-show-tabpanel') === 'config-present')) {
        carConfigForm.removeClass('display__none');
    } else {
        carConfigForm.addClass('display__none');
    }
});

carConfigBtn.click(function(){
    if (($(this).attr('data-show-tabpanel') === 'config-present')) {
        carConfigForm.removeClass('display__none');
    } else {
        carConfigForm.addClass('display__none');
    }
});*/

// МАРКА
$('.config-brandsblock div.container').on('click', function(){
    $('.config-brandsblock div.container').removeClass('checked_input');
    $(this).addClass('checked_input');
    $(this).find('input').prop('checked', true);


    let value = $(this).find('input').val();

    changeBrand(value);
});

// МАРКА - МОБ
// при изменении select
$('.config-brandsblock_mob select').on('change', function () {
    let value = $(this).val();
    // var text = $(this).find('option:selected').text();

    //Сброс слайдера комлектации на моб при изменении бренда
    ResetSlider('.config-complectblock');

    changeBrand(value);
});

function changeBrand(value){

    $.ajax({
        url: "/konfigurator",
        type: 'POST',
        data: {
            type: 'brand',
            brand: value
        },
        error: function (e) {
            console.log(e);
        }
    });
}

// МОДЕЛЬ
$('.config-modelblock select').on('change', function(){
    var value = $(this).val();
    changeModel(value);

    //Сброс слайдера комлектации на моб при изменении модели
    ResetSlider('.config-complectblock');
});

function changeModel(value){
    $.ajax({
        url: "/konfigurator",
        type: 'POST',
        data: {
            type: 'model',
            model: value
        },
        error: function (e) {
            console.log(e);
        }
    });
    $('#ticket_other_model').val(value);
    changeStep(1);
}

// Комплектация
function changeCompl(){
    $('.config-complectblock div.container').on('click', function(){
        clearComplSelection();
        $(this).addClass('checked_input');

        $('.config-car .config-car__inner .car__volume b').text("");
        $('.config-car .config-car__inner .car__power b').text("");
        $('.config-car .config-car__inner .car__transm b').text("");

        value = $('input',this).val();
        model = $('#modelblock_select').val();

        var $text_compl = $('.config-car .config-car__title_right');
        $text_compl.text(value);


        //Сброс слайдера конфигурации на моб при изменении комлектации
        ResetSlider('.config-engineblock');

        $.ajax({
            url: "/konfigurator",
            type: 'POST',
            data: {
                type: 'complectation',
                mod: value,
                model: model
            },
            error: function (e) {
                console.log(e);
            }
        });
        changeStep(2);
    }
  );
}

function clearComplSelection(){
    $('.config-complectblock div.container').removeClass('checked_input');
}

// ТТХ
function changeSpecification(){
    $('.config-engineblock div.container').on('click', function(){
        clearSpecSelection();
        $(this).addClass('checked_input');

        value = $('input',this).val();
        model = $('#modelblock_select').val();
        price = $('.card__price',this).text();

        var text_volume = $(this).find('.card__title .volume').text(),
            text_power = $(this).find('.card__title .power').text(),
            text_transm = $(this).find('.card__title .transm').text(),
            $car_volume = $('.config-car .config-car__inner .car__volume b'),
            $car_power = $('.config-car .config-car__inner .car__power b'),
            $car_transm = $('.config-car .config-car__inner .car__transm b');

        $('.config-car_price b').html(price);
        $car_volume.text(text_volume);
        $car_power.text(text_power);
        $car_transm.text(text_transm);

        $('#ticket_other_complect').val($('input',this).val());

        // card__price

        changeStep(3);
    });
}

function clearSpecSelection(){
    $('.config-engineblock  div.container').removeClass('checked_input');
}

// Цвет
function changeColor(){
    $('.modal__color div.container').on('click', function(){
        $('.modal__color div.container').removeClass('checked_input');
        $(this).addClass('checked_input');
        $(this).find('input').prop('checked', true);

        value = $('input',this).val();
        imgsrc = $('.modal__color-img',this).attr('src');

        $('.config-car_img').attr("src",imgsrc);

        var $text_color = $('.config-car .config-car_color span b');
        $text_color.text(value);

        $('#ticket_other_color').val(value);
        changeStep(4);
    });
}

// Подарок
$('.config-presentblock div.container').on('click', function(){
   /* if (window.innerWidth <= 680) {
        $('html, body').animate({scrollTop: 1000}, 'slow');
    }*/
    $('.config-car__inner .form__bottom_block').removeClass('display__none');
    $('.config-tabs .config__formtitle').removeClass('display__none');

    $('.config-presentblock div.container').removeClass('checked_input');
    $(this).addClass('checked_input');

    var text_present = $(this).find('.card__title').text(),
        $car_present = $('.config-car .config-car_exterier .car__present b');

    $car_present.text(text_present);
    $('#ticket_other_gift').val(text_present);
    changeStep(5);
});

//СКРЫТИЕ/ПОКАЗ ФОРМЫ НА МОБИЛЬНОМ ПРИ ШАГЕ НАЗАД
$('.config-button_mob_back[data-show-tabpanel="config-colors"]').on('click', function(){
    if ($('.form__bottom_block').hasClass('display__none') == false) {
        $('.config__formtitle').css('visibility', 'hidden');
        $('.form__bottom_block').css('visibility', 'hidden');
    }
});
$('.config-button_mob-next[data-show-tabpanel="config-present"]').on('click', function(){
    if ($('.form__bottom_block').hasClass('display__none') == false) {
        $('.config__formtitle').css('visibility', 'visible');
        $('.form__bottom_block').css('visibility', 'visible');
    }
});



let c_complect = $('.config-titles__tab[data-show-tabpanel="config-complect"]'),
     c_complect_r = $('.config-tabs__tab[data-role="config-complect"]'),
    c_engine = $('.config-titles__tab[data-show-tabpanel="config-engine"]'),
     c_engine_r = $('.config-tabs__tab[data-role="config-engine"]'),
    c_colors = $('.config-titles__tab[data-show-tabpanel="config-colors"]'),
     c_colors_r = $('.config-tabs__tab[data-role="config-colors"]'),
    c_present = $('.config-titles__tab[data-show-tabpanel="config-present"]'),
    c_present_r = $('.config-tabs__tab[data-role="config-present"]'),
    c_frm = $('.config-titles__tab[data-show-tabpanel="config-frm"]'),
    c_frm_r = $('.config-tabs__tab[data-role="config-frm"]'),
    btn_complect = $('button[data-show-tabpanel="config-complect"]'),
    btn_engine = $('button[data-show-tabpanel="config-engine"]'),
    btn_colors = $('button[data-show-tabpanel="config-colors"]'),
    btn_present = $('button[data-show-tabpanel="config-present"]'),
    btn_frm = $('button[data-show-tabpanel="config-frm"]');

function changeStep(step){
    switch(step){
        case 1:
            $('.config-complectblock div.container').removeClass('checked_input');

            //button enable effect
           /* setTimeout(function() {
                btn_complect.addClass('config-button__hover');
            }, 1500);*/
            setTimeout(function() {
                btn_complect.removeClass("config-button__hover");
                btn_complect.prop("disabled", false).prop('selectedIndex', 0);
            }, 2500);

            //disable buttons
            btn_engine.prop("disabled", true);
            btn_colors.prop("disabled", true);
            btn_present.prop("disabled", true);
            btn_frm.prop("disabled", true);

            //disable tabs
            c_complect.removeClass("disabled");
            c_engine.addClass("disabled");
            c_colors.addClass("disabled");
            c_present.addClass("disabled");
            c_frm.addClass("disabled");


            break;
        case 2:
            btn_complect.prop("disabled", true);
            btn_colors.prop("disabled", true);
            btn_present.prop("disabled", true);
            btn_frm.prop("disabled", true);

            btn_engine.prop("disabled", false).prop('selectedIndex', 0);
            //button enable effect
            btn_engine.addClass('config-button__hover');
           /* setTimeout(function() {
                btn_engine.removeClass("config-button__hover");
            }, 1000);*/

            //disable buttons
            btn_colors.prop("disabled", true);

            //disable tabs
            c_engine.removeClass("disabled").addClass("config-titles__tab--active");
            c_colors.addClass("disabled");
            c_present.addClass("disabled");
            c_frm.addClass("disabled");

            //active tabs
            c_complect_r.removeClass("config-tabs__tab-active");
            c_engine_r.addClass("config-tabs__tab-active");


            break;
        case 3:
            btn_complect.prop("disabled", true);
            btn_engine.prop("disabled", true);
            btn_present.prop("disabled", true);
            btn_frm.prop("disabled", true);

            btn_colors.prop("disabled", false).prop('selectedIndex', 0);

            //button enable effect
            btn_colors.addClass('config-button__hover');
          /*  setTimeout(function() {
                btn_colors.removeClass("config-button__hover");
            }, 1000);*/

            //disable tabs
            c_colors.removeClass("disabled").addClass("config-titles__tab--active");
            c_present.addClass("disabled");
            c_frm.addClass("disabled");

            //active tabs
            c_engine_r.removeClass("config-tabs__tab-active");
            c_colors_r.addClass("config-tabs__tab-active");

            break;
        case 4:
            btn_complect.prop("disabled", true);
            btn_engine.prop("disabled", true);
            btn_colors.prop("disabled", true);

            btn_present.prop("disabled", false).prop('selectedIndex', 0);

            //button enable effect
            btn_present.addClass('config-button__hover');
           /* setTimeout(function() {
                btn_present.removeClass("config-button__hover");
            }, 1000);*/

            c_present.removeClass("disabled").addClass("config-titles__tab--active");

            //active tabs
            c_colors_r.removeClass("config-tabs__tab-active");
            c_present_r.addClass("config-tabs__tab-active");

            break;
        case 5:
            btn_complect.prop("disabled", true);
            btn_engine.prop("disabled", true);
            btn_colors.prop("disabled", true);
            btn_present.prop("disabled", true);

            btn_frm.prop("disabled", false).prop('selectedIndex', 0);

            //button enable effect
            btn_frm.addClass('config-button__hover');
            /* setTimeout(function() {
                 btn_present.removeClass("config-button__hover");
             }, 1000);*/

            c_frm.removeClass("disabled");


            //active tabs
            c_present_r.removeClass("config-tabs__tab-active");
            c_frm_r.addClass("config-tabs__tab-active");

            break;
        default:
            c_complect.addClass("disabled");
            c_engine.addClass("disabled");
            c_colors.addClass("disabled");
            c_present.addClass("disabled");
            c_frm.addClass("disabled");
            break;
    }
}