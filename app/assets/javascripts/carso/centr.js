//= require jquery3

//= require rails-ujs

//= require slick.min
//= require jquery.fancybox.min
//= require rails.validations

//= require jquery.lazyload

//= require inputmask.min
//= require inputmask.extensions.min
//= require jquery.inputmask.min

//= require svgxuse.min.js

//= require sourcebuster.min

// ПУскаем sourcebuster
sbjs.init();

function debounce(fn, interval) {
    var timer;
    return function debounced() {
        clearTimeout(timer);
        var args = arguments;
        var that = this;
        timer = setTimeout(function callOriginalFn() {
            fn.apply(that, args);
        }, interval);
    };
}


function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}
// ставит куки
function setCookie(name,value,days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days*24*60*60*1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "")  + expires + "; path=/";
}


/* горизонтальный скролл мышью */
var scrollOnTouch = function($elem){
    var pageX, pageY, elTop, elLeft, dragging;
    $elem.mousedown(function(e) {
        e.preventDefault();
        dragging = true,
            pageX = e.pageX,
            pageY = e.pageY,
            elTop = $(this).scrollTop(),
            elLeft = $(this).scrollLeft();
    });
    $("body").mousemove(function(e) {
        if (dragging) {
            var pageXNew = e.pageX,
                pageYNew = e.pageY;
            $elem.scrollTop(elTop - pageYNew + pageY);
            $elem.scrollLeft(elLeft - pageXNew + pageX);
        }
    });
    $("body").mouseup(function() {
        dragging = false
    });
};

$(document).ready(function() {
    toggleBrandsMenuPanel();
    toggleBrandsMenuPanelHome();
    toggleBrandsMenuPanelMob();
    toggleNavPanel();
    init_labels('.input, .select');
    init_phone_mask();
    goToTop();
    init_user_ajax_modal();
    init_new_ajax_modal();
    $("img").lazyload();
    disableFormBtn();
    openTempModal();
    changeCuttedListDisplay();
    changeColumnsDisplay();
   // initCookieModal();
    initFixModal();
    if( !/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
        //initCookieModal();
    };
});

$(window).on('scroll', function(){
    toggleToTopBtnDebounce();
});

WINDOW_WIDTH = $(window).width();
$(window).on('resize', function(){
    if ($(this).width() !== WINDOW_WIDTH) {
        changeCuttedListDisplayDebounce();
        WINDOW_WIDTH = $(this).width();
    };
    changeColumnsDisplayDebounce();
});

var BREAKPOINTS = {
    XS: 480,
    SM: 600,
    M: 768,
    L: 1024,
    LG: 1280,
};

var DISABLE_FANCYBOX = false;

/* работа с brands меню */
var toggleBrandsMenuPanel = function(){
    var menuBtn = $('[data-action="top-menu"]'),
        menuPanel = $('[data-role="top-menu-open"]'),
        menuHideBtn = $('[data-action="close-btn"]'),
        top_top_mob = $('[data-action="top_top_mob"] span');

    menuBtn.on('click', function(){
        menuPanel.toggleClass('open');
        $('body').toggleClass('hid');
    });

    menuHideBtn.on('click', function(){
        menuPanel.removeClass('open');
        $('body').removeClass('hid');
    });

    top_top_mob.on('click', function(){
        menuPanel.removeClass('open');
        $('body').removeClass('hid');
    });

    // menuBtn.on('mouseenter', function(){
    //  menuPanel.addClass('menu--visible');
    // });
    // menuPanel.on('mouseleave', function(e){
    //   $(this).removeClass('menu--visible');
    // });

    $(document).on('mouseup', function(e){
        if ($('header').has(e.target).length === 0 && menuPanel.hasClass('menu--visible')){
            menuBtn.click();
        }
    });
};
/* работа с brands меню */
var toggleBrandsMenuPanelHome = function(){
    var menuBtn = $('[data-action="top-menu-home"]'),
        menuPanel = $('[data-role="top-menu-home-open"]'),
        menuHideBtn = $('[data-action="close-tbtn"]');

    menuBtn.on('click', function(){
        menuBtn.toggleClass('act-btn');
        menuPanel.toggleClass('opn');
        $('body').toggleClass('hid');
    });

   /* menuHideBtn.on('click', function(){
        menuPanel.toggleClass('opn');
        menuBtn.toggleClass('act-btn');
    });*/

};


/* работа с nav меню */
var toggleNavPanel = function(){
    var $navBtn = $('#nav-open'),
        $navBtnClose = $('#navmenu-close'),
        $navPanel = $('[data-role="nav"]');

    $navBtn.on('click', function(){
        $navPanel.addClass('nav-aside--visible');
    });
    $navBtnClose.on('click', function(){
        $navPanel.removeClass('nav-aside--visible');
    });
};

/* работа с brands_mobile меню */
var toggleBrandsMenuPanelMob = function(){
    var menuBtn = $('.menu__brands_mobile button'),
        menuPanel = $('.menu-list_mobile'),
        menumob = $('.menu__brands_mobile');

    menuBtn.on('click', function(){
        menuPanel.toggleClass('menu-mobile--visible');
        menumob.toggleClass('menu__brands_mobile--visible');
    });

    $('#navmenu-close').on('click', function(){
        menuPanel.removeClass('menu-mobile--visible');
        menumob.removeClass('menu__brands_mobile--visible');
    });
};



/* инициализация фэнсибоксов */

$("[data-show-modal]").on('click', function(e){
    e.preventDefault();
    var direction = $(this).data('show-modal'),
        src = '#' + direction,
        self = $(this);

    $.fancybox.open({
        src: src,
        touch: false,
        animationDuration: 500,
        afterShow: function(){
            $('form').enableClientSideValidations();
        }
    });
});

$("[data-show-common-modal]").on('click', function(e){
    e.preventDefault();
    var self = $(this);
    var direction = $(this).data('show-common-modal');
    if (!DISABLE_FANCYBOX) {
        DISABLE_FANCYBOX = true;
        $.ajax({
            url: self.attr('href'),
            type: 'POST',
            data: {
                common_modal_type: direction,
            },
            error: function (e) {
                console.log(e);
            }
        });
    }
});

function init_user_ajax_modal(){
    $("[data-show-used-ajax]").on('click', function(e){
        car_id = $(this).data('car_id');
        modal = $(this).data('show-used-ajax');
        if (!DISABLE_FANCYBOX) {
            DISABLE_FANCYBOX = true;
            $.ajax({
                url: "/used_cars/show_modal/" + car_id,
                type: 'POST',
                data: {
                    // put data here
                    modal: modal
                },
                error: function (e) {
                    console.log(e);
                }
            });
        }
    });
}

var InitAjaxModalCallback = function(){
    this._default = function(){
        // console.log('default callback');
    }
    this._custom = null;
    this._callback = function(){
        if (this._custom) this._custom();
        else this._default();
    }
}
var initAjaxModalCallback = new InitAjaxModalCallback;


function init_new_ajax_modal(){
    $("[data-show-new-ajax]").on('click', function(e){
        e.preventDefault();
        e.stopPropagation();
        var eq_id = $(this).data('eq_id'),
        // car_id = $(this).data('car_id');
        modal = $(this).data('show-new-ajax'),
        carId = carid ? carid : $(this).data('car-id');
        if (!DISABLE_FANCYBOX) {
            DISABLE_FANCYBOX = true;
            $.ajax({
                url: "/" + car_brand + "/" + carId,
                type: 'POST',
                data: {
                    // put data here
                    modal: modal,
                    eq_id: eq_id,
                },
                error: function (e) {
                    console.log(e);
                }
            }).then(function(){
                initAjaxModalCallback._callback();
            });
        }
    });
}


/* работа с label в инпутах */
function init_labels(item){
    $(item).on('focusout', function(){
        var val = $(this).val();
        if (val) {
            if ($(this).data('role') !== 'phone'){
                $(this).addClass('input--hascontent');
            }
            else if ($(this).data('role') === 'phone' && val.match(/(\+\d\s\(\d{3}\)\s\d{3}\-\d{2}\-\d{2})/gi)){
                $(this).addClass('input--hascontent');
            }
        }
        else{
            $(this).removeClass('input--hascontent');
        }
});
}

/* ининициализация маски телефона */
function init_phone_mask(){
    // console.log('MASK OF SANITY');
    $('input[data-role="phone"]').inputmask({
        mask: "+7 (999) 999-99-99",
        showMaskOnHover: false,
        clearIncomplete: true
    });
}

var disableFormBtn = function(){
    $('form').on('submit', function(){
        $(this).find('button:submit').prop("disabled", true);
        // yaCounter16677307.reachGoal("form_send_test");
    });
};


//TODO: исправить костыль, переделать валидацию
$('form').on('keyup', function(e){
    if (e.keyCode === 13){
        e.preventDefault();
        $(this).find('button:submit').click();
        $(this).find('.form__error').slideUp();
    }
});

/* Валидация форм */
window.ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
    callback();
    if (element.data('valid') !== false) {
        element.addClass('input--error');
        // $(element).parent().addClass('field_with_errors');

        // if (element.siblings('.form__error').length)
        // {
        //     element.siblings('.form__error').slideDown();
        // }
        // else
        // {
        //     element.parents('.form__component').append('<p class="form__error">' + message + '</p>');
        // }
        if (!element.siblings('.form__error').length){
            element.parents('.form_input').append('<div class="form__error">' + message + '</div>');
        }
    }
};

window.ClientSideValidations.callbacks.form.fail = function(form, eventData){
    error_fields = $('.form__error',form);
    error_fields.slideDown();
    error_fields.siblings('input').addClass('input--error');

    $(form).find('button:submit').prop("disabled", false);
};

$('.input, .select').on('focus', function(){
    $(this).removeClass('input--error');
    $(this).siblings('.form__error').slideUp();
});

ClientSideValidations.callbacks.form.after = function(form, eventData){
    // $("[data-show-modal]").fancybox.close();
    // $('.modal')
    // $(".modal__close-btn").on('click', function(e) {
    // });
};


function reset_form(form){
    $('.input--hascontent',form).removeClass('input--hascontent');
    form.trigger("reset");
    form.resetClientSideValidations();

    // $('.form__component input ',form).val('');
};

/* работа с боковой фиксированной навигацией - анкорные ссылки */
var workWithSideFixedNav = function(){
    var $link = $('.sidenav__link');
    function onScroll(){
        var scroll_top = $(document).scrollTop();
        $link.each(function(){
            var id = $(this).attr('href');
            var blockOffset = $(id).offset().top;
            if (id !== "#wrapper") {
                if (blockOffset-41 <= scroll_top && blockOffset-41 + $(id).outerHeight() > scroll_top) {
                    $('.sidenav__link--active').removeClass('sidenav__link--active');
                    $(this).addClass('sidenav__link--active');
                } else {
                    $(this).removeClass("sidenav__link--active");
                }
            }
        });
    }

    var navOnScrollDebounce = debounce(onScroll, 50);

    $(document).on("scroll", navOnScrollDebounce);

    $link.on('click', function(e){
        e.preventDefault();
        var id = $(this).attr('href');
        var blockOffset = $(id).offset().top;
        $('html, body').animate({scrollTop: (blockOffset - 40)}, 600, function(){
            $(document).on("scroll", navOnScrollDebounce);
        });

        $('.sidenav__link--active').removeClass('sidenav__link--active');
        if (id !== "#wrapper") $(this).addClass('sidenav__link--active');
    });
};


/* кнопка Наверх */
var toggleToTopBtn = function(){
    var $btn = $('[data-action="go-to-top"]'),
        windowH = $(window).height(),
        windowTop = $(window).scrollTop(),
        footerOffsetTop = $('.footer').offset().top;
    if ($btn.length) {
        if (windowTop > windowH) $btn.addClass('btn-totop--visible');
        else $btn.removeClass('btn-totop--visible');

        if (windowTop + windowH > footerOffsetTop){
            $btn.addClass('btn-totop--abs');
            $btn[0].style.setProperty('--btn-bottom', (footerOffsetTop - 50));
        }
        else $btn.removeClass('btn-totop--abs');
    }

};
var toggleToTopBtnDebounce = debounce(toggleToTopBtn, 10);

var goToTop = function(){
    var $btn = $('[data-action="go-to-top"]');
    $btn.on('click', function(){
        $('html, body').animate({scrollTop: 0}, 600)
    });
};


$(".sale_bn").on('click', function(e){
    e.preventDefault();
    e.stopPropagation();
    $.ajax({
        url: '/common_modal',
        type: 'POST',
        data: {
            common_modal_type: 'modal_cookie_message',
        },
        error: function (e) {
            console.log(e);
        }
    })
});

$(".action_bn").on('click', function(){
    $.ajax({
        url: '/common_modal',
        type: 'POST',
        data: {
            common_modal_type: 'modal_action',
        },
        error: function (e) {
            console.log(e);
        }
    })
});

$(".grlp").on('click', function(){
    $.ajax({
        url: '/common_modal',
        type: 'POST',
        data: {
            common_modal_type: 'modal_special',
        },
        error: function (e) {
            console.log(e);
        }
    })
});
$(".sc_action").on('click', function(){
    $.ajax({
        url: '/common_modal',
        type: 'POST',
        data: {
            common_modal_type: 'modal_sc_action',
        },
        error: function (e) {
            console.log(e);
        }
    })
});
$(".str_mcredit").on('click', function(e){
    e.preventDefault();
    e.stopPropagation();
    $.ajax({
        url: '/common_modal',
        type: 'POST',
        data: {
            common_modal_type: 'modal_str_credit',
        },
        error: function (e) {
            console.log(e);
        }
    })
});

var initCookieModal = function(){
    // COOKIE TIME

    if(getCookie('popup-shown-time') === null){

        if (!localStorage['start_time']) {
            var start_time = new Date();
            localStorage['start_time'] = start_time.getTime();
        }
            setTimeout(function tick() {

                var now = new Date();
                now = now.getTime();
                // console.log(now - localStorage['start_time']);
                if ((now - localStorage['start_time']) > 30000 && $('.fancybox-active').length === 0) {
                    $.ajax({
                        url: '/common_modal',
                        type: 'POST',
                        data: {
                            common_modal_type: 'modal_cookie_message',
                        },
                        error: function (e) {
                            console.log(e);
                        }
                    }).then(function () {
                        setCookie('popup-shown-time', '1', 1);
                        localStorage.removeItem('start_time');
                    });
                    return;
                }

                setTimeout(tick, 1000);

            }, 1000);

    }
};

function initFixModal(){
    $("[data-show-popup-ajax]").on('click', function(e){
        e.preventDefault();
        e.stopPropagation();
        modal = $(this).data('show-popup-ajax');
        if (!DISABLE_FANCYBOX) {
            DISABLE_FANCYBOX = true;
            $.ajax({
                url: '/common_modal',
                type: 'POST',
                data: {
                    common_modal_type: 'modal_fix_popup',
                },
                error: function (e) {
                    console.log(e);
                }
            }).then(function(){
                initAjaxModalCallback._callback();
            });
        }
    });
}



// обнуляем отсчет времени для появления всплывашки при отправке аякса на другие формы
var resetStartCookieModalTime = function(){
    if (localStorage['start_time']) {
        var start_time = new Date();
        localStorage['start_time'] = start_time.getTime();
    }
};

$('[data-show-modal], [data-show-common-modal], [data-show-model-ajax], [data-show-used-ajax], [data-show-new-ajax]').on('click', function(){
    resetStartCookieModalTime();
});


var openTempModal = function () {
    $('[data-action=open-ny-dialog]').on('click', function(){
        $('[data-role=ny-dialog]').fadeIn(200);
        $('.wrapper').addClass('wrapper--fixed');
        $('.modal-ny form').enableClientSideValidations();
    });

    $('[data-action=close-ny-dialog]').on('click', function() {
        $('.wrapper').removeClass('wrapper--fixed');
        $('[data-role=ny-dialog]').fadeOut(200);
    });
}




var changeCuttedListDisplay = function(){
    var $list = $('.card-list--cutted', '[data-role="slide-list"]');
    var slides;
    $list.each(function(index, elem){
        // if ($(elem).data('role') === "car-kits-list") slides = ($(window).width() <= BREAKPOINTS.XS) ? 2 : ($(window).width() <= 900) ? 2 : 3;
        // else slides = ($(window).width() <= BREAKPOINTS.SM)  ? 1 : ($(window).width() <= 900) ? 2 : 3;

        slides = ($(window).width() <= BREAKPOINTS.SM) ? 1 : ($(window).width() <= 900) ? 2 : 3;

        if ($(window).width() <= BREAKPOINTS.L){
            if ($(elem).hasClass('card-list--cutted') && !$(elem).hasClass('card-list--cutted-visible')) $(elem).addClass('card-list--cutted-visible');
            // if ($(elem).hasClass('card-list--cutted-doubleline') && !$(elem).hasClass('card-list--cutted-doubleline-visible')) $(elem).addClass('card-list--cutted-doubleline-visible');

            if ($(elem).hasClass('slick-slider')) $(elem).slick('unslick');
            if ($(elem).children().length > slides){
                $(elem).slick({
                    lazyLoad: 'ondemand',
                    slidesToShow: slides,
                    slidesToScroll: slides,
                    dots: false,
                    infinite: false,
                    prevArrow: "<button type='button' class='slick-prev'><svg width='11' height='18'><use xlink:href='/assets/carso/icons.svg#svg-arrow-short'></use></svg></button>",
                    nextArrow: "<button type='button' class='slick-next'><svg width='11' height='18'><use xlink:href='/assets/carso/icons.svg#svg-arrow-short'></use></svg></button>",

                })
            }
            $(elem).next('[data-action="show-all-cars"]').addClass('hidden');
        } else {
            if ($(elem).hasClass('slick-slider')) $(elem).slick('unslick');
            $(elem).removeClass('card-list--cutted-visible card-list--cutted-doubleline-visible');

        }
    });
};
//
var changeCuttedListDisplayDebounce = debounce(function(){
    changeCuttedListDisplay();
    if($(window).width() <= BREAKPOINTS.L){
        $('.card-list--cutted, .card-list--cutted-doubleline').find("[data-show-modal]").on('click', function(e){
            e.preventDefault();
            var direction = $(this).data('show-modal'),
                src = "#"+direction,
                self = $(this);

            if (direction === "used-car-photos"){
                self.find('[data-fancybox^="used-car-photos"]').fancybox({
                    buttons: [
                        'close',
                    ],
                    transitionEffect: 'slide',
                    loop: true
                });
                self.find('[data-fancybox^="used-car-photos"]')[0].click();
                return;
            }
            $.fancybox.open({
                src: src,
                touch: false,
                animationDuration: 500,
                beforeShow: function(){

                    if (direction === 'used-car-details-modal'){
                        workWithUsedCarDetails(direction,self);
                    }
                    if (direction === 'used-car-buy-modal'){
                        workWithUsedCarDetails(direction,self);
                    }
                },
            });
        });
    }
}, 50);




// слайдер для гарантий
var changeColumnsDisplay = function(){
    var $list = $('[data-role=columns]');
    var slides;

    $list.each(function(index, elem){
        if ($(elem).data('content') === 'about') slides = ($(window).width() <= BREAKPOINTS.L) ? 1 : 3;
        //if ($(elem).data('content') === 'news') slides = ($(window).width() <= BREAKPOINTS.LG) ? 1 : 3;
        else slides = ($(window).width() <= BREAKPOINTS.SM) ? 1 : ($(window).width() <= BREAKPOINTS.L) ? 2 : 4;

        if ($(elem).data('content') === 'news') {

            if ($(elem).hasClass('slick-slider')) $(elem).slick('unslick');

            if ($(elem).children().length > slides){
                $(elem).slick({
                    lazyLoad: 'ondemand',
                    slidesToShow: slides,
                    slidesToScroll: slides,
                    dots: false,
                    infinite: false,
                })
            }
        } else {
            if ($(window).width() <= BREAKPOINTS.L){

                if ($(elem).hasClass('slick-slider')) $(elem).slick('unslick');

                if ($(elem).children().length > slides){
                    $(elem).slick({
                        lazyLoad: 'ondemand',
                        slidesToShow: slides,
                        slidesToScroll: slides,
                        dots: false,
                        infinite: false,
                    })
                }

            } else {
                if ($(elem).hasClass('slick-slider')) $(elem).slick('unslick');
            }
        }
    });
};

var changeColumnsDisplayDebounce = debounce(changeColumnsDisplay, 50);

//СЛАЙДЕР С БАНКАМИ

$(document).ready(function() {
    $('.banks__main').slick({
        rows: 3,
        dots: false,
        arrows: true,
        infinite: false,
        variableWidth: true,
        lazyLoad: 'ondemand',
        //speed: 300,
        slidesToShow: 6,
        slidesToScroll: 1,
        responsive: [

            {
                breakpoint: 800,
                settings: {
                    rows: 3,
                    slidesToScroll: 5,
                    slidesToShow: 5
                }
            },
            {
                breakpoint: 650,
                settings: {
                    rows: 3,
                    slidesToScroll: 3,
                    slidesToShow: 3
                }
            },
            {
                breakpoint: 380,
                settings: {
                    rows: 4,
                    slidesToScroll: 2,
                    slidesToShow: 2
                }
            }
        ]
    });
});

//Показать все бренды
$(document).ready(function() {
    var showAllBrands_btn = document.getElementById('showall__brands');
    if (showAllBrands_btn) {
        var showAllBrands = function () {
            showAllBrands_btn.onclick = function () {
                this.style.display = 'none';
                let elements = document.querySelectorAll('.menu-list--simple > li');
                for (let elem of elements) {
                    elem.style.display = 'block';
                }
            };
        };
        showAllBrands();
    };
});

//Слайдер с карточками на мобильном
var sliderCardsmob_medium = function (){
    $('.card-list:not(.card-list--noslider)').slick({
        rows: 1,
        dots: false,
        arrows: true,
        infinite: false,
        slidesToShow: 2,
        slidesToScroll: 2
    });
    $('.offers').slick({
        rows: 2,
        dots: false,
        arrows: true,
        infinite: false,
        slidesToShow: 2,
        slidesToScroll: 2
    });
};
var sliderCardsmob_small = function (){
    $('.card-list:not(.card-list--noslider)').slick({
        rows: 1,
        dots: false,
        arrows: true,
        infinite: false,
        slidesToShow: 1,
        slidesToScroll: 1
    });
    $('.offers').slick({
        rows: 3,
        dots: false,
        arrows: true,
        infinite: false,
        slidesToShow: 1,
        slidesToScroll: 1
    });
};
var cards_arr = document.querySelectorAll('.card-list > div');

//
$(document).ready(function() {
    if (window.innerWidth <= 1024) {
        var carModels = document.querySelector('#car-models');
        var carArchive = document.querySelector('#car-archive');
        if(carModels) {
            carModels.classList.remove('card-list');
        }
        if(carArchive) {
            carArchive.classList.remove('card-list');
        }
    };
});

$(document).ready(function() {
    if( window.innerWidth <= 480 ){
        if (cards_arr.length > 1) {
            sliderCardsmob_small();
        }
    } else if ( window.innerWidth > 480 && window.innerWidth <= 1024) {
        if (cards_arr.length > 2) {
            sliderCardsmob_medium();
        }
    }
});

//Показать все модели
var hideButton = function(){
    let elem_arr = document.querySelectorAll('.brandnames__block');
    for (let j = 0; j < elem_arr.length; j++){
        let elements = elem_arr[j].querySelectorAll('li');
        if (elements.length <= 7) {
            var hiddenBtn = elem_arr[j].querySelector('.showall__models');
            hiddenBtn.className +=" hidden_btn"

        }
    }
};

hideButton();

var showAllModels = function(x){
    var elems = x.find('li');
    for (let elem of elems) {
        elem.style.display = 'block';
    }
};

var hideModels = function(){
    let elem_arr = document.querySelectorAll('.brandnames__block');
    for (let j = 0; j < elem_arr.length; j++){
        let elements = elem_arr[j].querySelectorAll('li');
        for (let i = 0; i < elements.length; i++) {
            if (i > 6){
                elements[i].style.display = 'none';
                document.querySelectorAll('.showall__models').forEach(function(k){
                    k.style.display = 'block';
                })
            }
        }
    }
};

$('.showall__models').click(function(){
    hideModels();
    this.style.display = 'none';
    var arr_models = $(this).parent().siblings('.brandnames__list');
    showAllModels(arr_models);
});

//Показать все характеристики комплектации
var lastEquipment = document.querySelector('.equipment__block');

if (lastEquipment){
    var lastEquipment_list = document.querySelector('.equipment__block ul:last-of-type');
    var lastEquipment_title = document.querySelector('.equipment__block p:last-of-type');
    var lastEquipment_li = document.querySelectorAll('.equipment__block ul:last-of-type li');
    var lastEquipment_height = document.querySelector('.equipment__block ul:last-of-type').offsetHeight;

    if (lastEquipment_li.length > 3 && lastEquipment_height > 500) {
        lastEquipment_list.classList.add('addAfter', 'hiddenli');
    }

    document.querySelector('.equipment__block ul.addAfter').onclick = function(){
        this.classList.toggle('hiddenli');
        lastEquipment_title.scrollIntoView({/*behavior: 'smooth'*/});
    };
};


/* замена текста в кнопке */
$('[data-action="select-content"]').on('change', function(){
    var $btn = $(this).siblings('.button'),
        value = $(this).val(),
        text = $(this).find('option:selected').text();
    if ($(this).attr('id') === 'used_transmission_select') {
        text = $(this).find('option:selected').data('text');
    }
    $btn.attr("href",value);
    $btn.find('[data-role="selected-content"]').text(text);
});
$('[data-action="select-content"]').change();

//Показ/скрытие фильтра
$('.show__filter__content').click(function(){
    $(this).css('display', 'none');
    $('.filter__content form').css('display', 'block');
    $('.hide__filter__content').css('display', 'block');
});
$('.hide__filter__content').click(function(){
    $(this).css('display', 'none');
    $('.filter__content form').css('display', 'none');
    $('.show__filter__content').css('display', 'block');
});

//Показ/скрытие характеристик
$('.show__featurelist').click(function(){
    $('.show__featurelist').css('display', 'none');
    $('ul.card__featurelist').css('display', 'block');
    $('.hide__featurelist').css('display', 'block');
});
$('.hide__featurelist').click(function(){
    $('.hide__featurelist').css('display', 'none');
    $('ul.card__featurelist').css('display', 'none');
    $('.show__featurelist').css('display', 'block');
});

//СКРИПТ ДЛЯ СТРАНИЦЫ ТАКСИ
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

// window.jivo_onIntroduction = function(){
//     c_data = jivo_api.getContactInfo();
//     send_to_crm(c_data);
// };
//
//
//
// function send_to_crm(data){
//     $.ajax({
//         url: "/tickets/create",
//         type: 'post',
//         data: {ticket:{form_name:'Заявка из чата',name: data.client_name, phone: data.phone},hide_popup:true},
//         beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
//         error: function (e) {
//             console.log(e);
//         }
//     });
// }

var newPhone = $('a.header__phone-link span').text();

const changePhone = () => {
    setTimeout(function () {
        let newPhone2 = $('a.header__phone-link span').text(),
            btnPhone = $('#btnPhone'),
            re1 = new RegExp(/[-()/\\]/g);

        newPhone2 = newPhone2.replace(re1, '').replace(/\s+/g, '');
        btnPhone.attr('href', 'tel:' + newPhone2);
    }, 2000);
};

$('.header__top-map-link').on('click', changePhone);
$('.header__middle-address').on('click', changePhone);


$('a.social-link').html(newPhone);


$(document).ready(function() {
    var $card_box = $('.card_box_slide');
    if (!$card_box.hasClass('slick-slider')){
        // $photos.scrollbar('destroy');
        $card_box.slick({
            lazyLoad: 'ondemand',
            slidesToShow: 3,
            slidesToScroll: 1,
            variableWidth: false,
            dots: false,
            infinite:false,
            responsive: [
                {
                    breakpoint: 460,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1,
                        variableWidth: false,
                        centerMode: true
                    }
                }
            ]
        });
    }
});
$(document).ready(function() {
    if ($(window).width() <= BREAKPOINTS.LG){
    var $card_box = $('.bng-main');
    if (!$card_box.hasClass('slick-slider')){
        // $photos.scrollbar('destroy');
        $card_box.slick({
            lazyLoad: 'ondemand',
            slidesToShow: 4,
            slidesToScroll: 1,
            variableWidth: true,
            dots: false,
            infinite:false,
            responsive: [
                {
                    breakpoint: 1000,
                    settings: {
                        slidesToShow: 2,
                        slidesToScroll: 1
                    }
                },
                {
                    breakpoint: 380,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1
                       // centerMode: true
                    }
                }
            ]
        });
    }
    }
});

$(document).ready(function() {
    if ($(window).width() <= BREAKPOINTS.LG){
        var $card_box = $('.block_h_url');
        if (!$card_box.hasClass('slick-slider')){
            // $photos.scrollbar('destroy');
            $card_box.slick({
                lazyLoad: 'ondemand',
                slidesToShow: 4,
                slidesToScroll: 1,
                variableWidth: true,
                dots: false,
                infinite:false,
                responsive: [
                    {
                        breakpoint: 1000,
                        settings: {
                            slidesToShow: 2,
                            slidesToScroll: 1
                        }
                    },
                    {
                        breakpoint: 380,
                        settings: {
                            slidesToShow: 1,
                            slidesToScroll: 1
                            // centerMode: true
                        }
                    }
                ]
            });
        }
    }
});


/****time from mobile fix buttin*****/

$(document).ready(function() {
    if ($(window).width() <= BREAKPOINTS.SM){
        let day = new Date();
        let hour = day.getHours();
        if (hour >= 8 && hour < 19) {

      } else {
            $('.toolbar_m .cell_f').addClass('tb_none');
            $('.toolbar_m .mbrb').addClass('tb_block');
        }
   }
});

$(document).ready(function() {
    if ($(window).width() <= BREAKPOINTS.LG) {
        $('#news-block').slick({
            dots: false,
            arrows: true,
            infinite: false,
            //variableWidth: true,
            slidesToShow: 2,
            slidesToScroll: 1,
            responsive: [
                {
                    breakpoint: 380,
                    settings: {
                        slidesToScroll: 1,
                        slidesToShow: 2
                    }
                }
            ]
        });
    }
});
$(document).ready(function() {
   // if ($(window).width() <= BREAKPOINTS.LG) {
        $('#articles-block').slick({
            dots: false,
            arrows: true,
            infinite: false,
            //variableWidth: true,
            slidesToShow: 1,
            slidesToScroll: 1,
            responsive: [
                {
                    breakpoint: 380,
                    settings: {
                        slidesToScroll: 1,
                        slidesToShow: 1
                    }
                }
            ]
        });
  //  }
});

$(document).ready(function() {
    $('#do_pr').slick({
        dots: false,
        arrows: true,
        infinite: false,
        //variableWidth: true,
        slidesToShow: 9,
        slidesToScroll: 3,
        responsive: [
            {
                breakpoint: 600,
                settings: {
                    slidesToScroll: 1,
                    slidesToShow: 4
                }
            },
            {
                breakpoint: 420,
                settings: {
                    slidesToScroll: 1,
                    slidesToShow: 3
                }
            },
            {
                breakpoint: 340,
                settings: {
                    slidesToScroll: 2,
                    slidesToShow: 2
                }
            }
        ]
    });
});



/****************/
$('[data-role=page-navigation-link]').on('click', function(e){
    e.preventDefault();
    $(document).off("scroll");
    var hash = $(this).attr("href");
    var target = $(hash);
    $("html, body").animate({
        scrollTop: target.offset().top
    }, 500, function(){});
});
/**********список городов**************/
$('.r_selected').on('click', function(){
    $('.reg_s_block').toggleClass('opn');
});
$('.r_close-btn').on('click', function(){
    $('.reg_s_block').toggleClass('opn');
});


//////////////////////

$(".tradein_btt").on("click",".tradein_tt", function(e){
    e.preventDefault();
    $(this).parent().find(".credit_bp_txt").toggleClass("on");
    $(this).parent().find(".tradein_tt").toggleClass("on");
});


$(".hsb_r").on("click", ".m_read_more", function() {

  //  var tabs = $(".btn_group_info button"),
      var cont = $(".hs_b");

  //  tabs.removeClass("tab-active");
   // cont.removeClass("sh");

   // $(this).parent().parent().addClass("sh");
    $(this).addClass("sh");
    //$(this).find(".rt_info_text").toggleClass("open_popup");
   // cont.eq($(this).index()).addClass("sh1");
    $(this).closest(".hs_b").addClass("sh");
    return false;
});

/*
$(document).ready(function() {
    $('.frm_bangr').slick({
        dots: false,
        arrows: true,
        infinite: false,
            rows: 2,
        variableWidth: true,
        slidesToShow: 2,
        slidesToScroll: 1,
    });
});*/

$(document).ready(function() {
        $('.index_bn').slick({
            dots: false,
            arrows: false,
            infinite: false,
            //variableWidth: true,
            slidesToShow: 1,
            slidesToScroll: 1,
        });
});

/*************************************************/


$(".htab__box").on("click", ".htab__box-nav .htab__b_n-m", function() {

    var tabs = $(".htab__box-nav .htab__b_n-m"),
        cont = $(".htab__box_txt .htab__box_txt_b .hbla_h");

    tabs.removeClass("hact");
    cont.removeClass("hblock-active");

    $(this).addClass("hact");
    cont.eq($(this).index()).addClass("hblock-active");

    return false;
});

$(document).ready(function() {
    $('.bnr').slick({
        dots: false,
        arrows: true,
        infinite: false,
        //variableWidth: true,
        slidesToShow: 1,
        slidesToScroll: 1,
    });
});