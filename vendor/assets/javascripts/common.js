jQuery(document).ready(function(){

    // Animations on DOM
    $(function () {
        var isHomePage = $('.main_slider').length;

        // Init rellax lib
        var rellax = null;
        if ( $('.rellax').length ) {
            rellax = new Rellax('.rellax');
        }

        // Init AOS lib
        AOS.init({
            disable: 'mobile',
            useClassNames: true,
            disableMutationObserver: true,
        });

        // AOS Fix for AOS option - disableMutationObserver (current value: true)
        $(function () {
            var fixElement = $('.main_help_find__clients'),
                forClass = 'aos-animate';

            if ( !fixElement.hasClass(forClass) ) {
                $(window).scroll(function(){
                    var fixScrollValue = fixElement.offset().top - $(window).scrollTop() - $(window).height(),
                        getPositiveValue = - fixScrollValue;

                    if ( getPositiveValue >= 0 && getPositiveValue <= 100 ) {
                        fixElement.addClass(forClass);
                    }
                });
            }
        });

        // Init gsap lib for car animation [deprecated]
        if ( $('.car_slider__car').length ) {

            var xPercentValue = -500;

            if ( $(window).width() < 577 ) {
                xPercentValue = -400;
            }

            var gsapCarWheelsEl = $('.car_slider__car__wheel');
            var gsapCarObject = gsap.to('.car_slider__car', {
                xPercent: xPercentValue,
                ease: Power0.easeNone,
                scrollTrigger: {
                    trigger: '.car_slider',
                    start: 'top bottom',
                    end: '1000',
                    scrub: true
                },
                onUpdate: function () {
                    var getFloatProgressValue = this.scrollTrigger.progress * 100,
                        formatRoundedStringForAttr = Math.round( getFloatProgressValue * 20 );

                    gsapCarWheelsEl.attr('style', 'transform: rotate(-' + formatRoundedStringForAttr + 'deg)');
                },
            });
        }

        // Init parralax on main benefit section
        if ($(window).width() > 993) {
            var mainParallax = {};

            // Options
            mainParallax.topSpacing = 164;
            mainParallax.speedUpSpacing = 20;
            mainParallax.defaultPos = 130;
            mainParallax.transitionDurationCSS = '.45s';
            mainParallax.transitionDurationSpeedUpCSS = '.10s';
            mainParallax.transitionEasingCSS = 'ease-out';

            // Default
            mainParallax.windowHeight = $(window).height();
            mainParallax.mainElement = $('.main_benefit');
            mainParallax.mainElementHeight = $('.main_benefit').outerHeight();
            mainParallax.leftImageElement = $('.main_benefit_leftbg__image');
            mainParallax.rightImageElement = $('.main_benefit_rightbg__image');
            mainParallax.maxDownScrollHeight = mainParallax.windowHeight - mainParallax.topSpacing;
            mainParallax.transitionDurationCSS__default = mainParallax.transitionDurationCSS;

            mainParallax.leftImageElement.attr('style', '-webkit-transform: translate3d(0,' + mainParallax.defaultPos + 'px,0); transform: translate3d(0,' + mainParallax.defaultPos + 'px,0);');
            mainParallax.rightImageElement.attr('style', '-webkit-transform: translate3d(0,-' + mainParallax.defaultPos + 'px,0); transform: translate3d(0,-' + mainParallax.defaultPos + 'px,0);');

            if ( mainParallax.mainElement.length ) {
                $(window).scroll(function(){
                    mainParallax.windowHeight = $(window).height();

                    var elementGetPosition__top = mainParallax.mainElement.offset().top - $(window).scrollTop() - mainParallax.topSpacing,
                        elementGetPosition__bottom = mainParallax.mainElement.offset().top - $(window).scrollTop() - mainParallax.windowHeight,
                        elementGetPosition__topPositive = - elementGetPosition__top,
                        elementGetPosition__bottomPositive = - elementGetPosition__bottom;

                    if ( elementGetPosition__bottomPositive >= 0 && elementGetPosition__bottomPositive <= mainParallax.maxDownScrollHeight ) {
                        var downParallaxProgress = mainParallax.defaultPos - Math.round( elementGetPosition__bottomPositive / mainParallax.maxDownScrollHeight * mainParallax.defaultPos );

                        if ( downParallaxProgress <= mainParallax.speedUpSpacing ) {
                            mainParallax.transitionDurationCSS = mainParallax.transitionDurationSpeedUpCSS;
                        } else {
                            mainParallax.transitionDurationCSS = mainParallax.transitionDurationCSS__default;
                        }

                        mainParallax.leftImageElement.attr('style', '-webkit-transform: translate3d(0,' + downParallaxProgress + 'px,0); transform: translate3d(0,' + downParallaxProgress + 'px,0); -webkit-transition: all ' + mainParallax.transitionDurationCSS + ' ' + mainParallax.transitionEasingCSS + '; -o-transition: all ' + mainParallax.transitionDurationCSS + ' ' + mainParallax.transitionEasingCSS + '; transition: all ' + mainParallax.transitionDurationCSS + ' ' + mainParallax.transitionEasingCSS + ';');
                        mainParallax.rightImageElement.attr('style', '-webkit-transform: translate3d(0,' + - downParallaxProgress + 'px,0); transform: translate3d(0,' + - downParallaxProgress + 'px,0); -webkit-transition: all ' + mainParallax.transitionDurationCSS + ' ' + mainParallax.transitionEasingCSS + '; -o-transition: all ' + mainParallax.transitionDurationCSS + ' ' + mainParallax.transitionEasingCSS + '; transition: all ' + mainParallax.transitionDurationCSS + ' ' + mainParallax.transitionEasingCSS + ';');
                    }

                    if ( elementGetPosition__topPositive >= 0 && elementGetPosition__topPositive <= mainParallax.mainElementHeight) {
                        var stickyParallaxProgress = elementGetPosition__topPositive;

                        mainParallax.leftImageElement.attr('style', '-webkit-transform: translate3d(0,' + stickyParallaxProgress + 'px,0); transform: translate3d(0,' + stickyParallaxProgress + 'px,0); -webkit-transition: none; -o-transition: none; transition: none;');
                        mainParallax.rightImageElement.attr('style', '-webkit-transform: translate3d(0,' + stickyParallaxProgress + 'px,0); transform: translate3d(0,' + stickyParallaxProgress + 'px,0); -webkit-transition: none; -o-transition: none; transition: none;');
                    }
                });
            }
        }

        // Main gifts change animations
        $(function () {
            var mainGiftsAnimations = {};

            mainGiftsAnimations.classNames = {
                active: 'active',
                exited: 'exited-state',
                entered: 'entered-state'
            };

            mainGiftsAnimations.timeForChangeState = 500;

            var timerId = null;
            var disableTimer = false;

            mainGiftsAnimations.navItems = $('.main_gifts_tabs_nav__item');
            mainGiftsAnimations.tabItems = $('.main_gifts_tabs_content');

            mainGiftsAnimations.navItems.eq(0).addClass( mainGiftsAnimations.classNames.active );
            mainGiftsAnimations.tabItems.hide().eq(0).show().addClass( mainGiftsAnimations.classNames.active ).addClass( mainGiftsAnimations.classNames.entered );

            mainGiftsAnimations.navItems.click(function () {

                if ( $( this ).is(':hover') ) {
                    disableTimer = true;
                    clearTimeout(timerId);
                }

                var prevActiveTab = $('.main_gifts_tabs_content.active');

                if ( !prevActiveTab.hasClass( mainGiftsAnimations.classNames.exited ) ) {
                    var thisIndex = mainGiftsAnimations.navItems.index(this),
                        nextClickedTab = mainGiftsAnimations.tabItems.eq(thisIndex);

                    prevActiveTab.addClass( mainGiftsAnimations.classNames.exited );

                    setTimeout(function () {
                        prevActiveTab.hide();
                        prevActiveTab.removeClass( mainGiftsAnimations.classNames.exited );
                        prevActiveTab.removeClass( mainGiftsAnimations.classNames.entered );
                        nextClickedTab.show().addClass( mainGiftsAnimations.classNames.entered );

                        mainGiftsAnimations.tabItems.removeClass( mainGiftsAnimations.classNames.active );
                        nextClickedTab.addClass( mainGiftsAnimations.classNames.active );

                    }, mainGiftsAnimations.timeForChangeState);

                    mainGiftsAnimations.navItems.removeClass( mainGiftsAnimations.classNames.active );
                    $( this ).addClass( mainGiftsAnimations.classNames.active );
                }
            });

            timerId = setTimeout(function tick() {

                if ( $('.main_gifts_tabs_nav__item.active').index() === 3 ) {
                    $('.main_gifts_tabs_nav__item').first().trigger('click');
                } else {
                    $('.main_gifts_tabs_nav__item.active').next().trigger('click');
                }

                if (!disableTimer) {
                    timerId = setTimeout(tick, 3000 + 500);
                }

            }, 3000 + 500);

        });

        // Parallax down arrow (model page, credit page, trade-in page)
        $(function () {
            var parallaxDownArrow = {};

            parallaxDownArrow.element = $('.parallax_down_arrow');
            parallaxDownArrow.downAnimationStart = parallaxDownArrow.element.attr('data-pda-start');
            parallaxDownArrow.downAnimationDelay = parallaxDownArrow.element.attr('data-pda-delay');

            parallaxDownArrow.classNames = {
                entered: 'animated',
                exited: 'down-animated',
            };

            if ( parallaxDownArrow.downAnimationStart && parallaxDownArrow.downAnimationDelay ) {
                setTimeout(function () {
                    parallaxDownArrow.element.addClass(parallaxDownArrow.classNames.entered);
                }, parallaxDownArrow.downAnimationDelay);

                $(window).scroll(function(){
                    var windowScrollTop = $(window).scrollTop();
                    if ( windowScrollTop >= parallaxDownArrow.downAnimationStart ) {
                        parallaxDownArrow.element.addClass(parallaxDownArrow.classNames.exited);
                    } else {
                        parallaxDownArrow.element.removeClass(parallaxDownArrow.classNames.exited);
                    }
                });
            }
        });

        // Init gifts popup animation
        $(function () {
            var giftsPopupContent = $('.main_gifts_popup_content'),
                giftsPopupButton = $('.main_gifts_popup_action__btn');

            giftsPopupButton.click(function (e) {
                e.preventDefault();
                var getRandomGiftNumberClass = Math.floor(Math.random() * 4) + 1;

                giftsPopupContent.addClass('start');
                giftsPopupContent.addClass('gift_0' + getRandomGiftNumberClass);
            })
        });

        // Clone or animate header on home-page
        if ($(window).width() > 993) {
            $(function () {
                var headerElement = $('#header'),
                    body = $('body'),
                    posForAnimate = 600;

                if ( isHomePage ) {
                    headerElement.clone()
                        .appendTo('body')
                        .removeAttr('id')
                        .removeAttr('data-aos-delay')
                        .removeClass('aos-animate')
                        .addClass('cloned-header default-colors');



                    var clonedHeader = $('.cloned-header'),
                        scrollTopOnLoad = $(window).scrollTop();

                    clonedHeader.find('.header_top__callback').find('a').click(function () {
                        headerElement.find('.header_top__callback').find('a').trigger('click');
                    });

                    $(window).scroll(function(){
                        var scrollTop = $(window).scrollTop();

                        if ( scrollTop >= posForAnimate ) {
                            clonedHeader.addClass('aos-animate');
                        } else {
                            clonedHeader.removeClass('aos-animate');
                        }
                    });

                    if ( scrollTopOnLoad >= posForAnimate ) {
                        clonedHeader.addClass('aos-animate');
                    }
                } else {
                    body.addClass('default-fixed-header');
                    headerElement.addClass('default-colors');
                }
            });
        }

        // Init sticky sidebar
        var stickySidebar = null;
        if ( $('.js_sidebar_global').length && $(window).width() > 993 ) {
            stickySidebar = new StickySidebar('.js_sidebar_global', {
                topSpacing: 170,
                bottomSpacing: 20,
                containerSelector: '.js_sidebar_container',
                innerWrapperSelector: '.js_sidebar_inner'
            });
        }
    });

    // More marks on catalog page filter
    $(function () {
        var marksWrapper = $('.main_catalog_page').find('.main_catalog_page_marks').find('.row'),
            marksItems = $('.main_marks_item_col'),
            marksMoreBtn = $('<button class="btn main_marks_item_more_btn"><span>Еще ></span></button>'),
            maxMarksItems = 4;

        marksItems.each(function( index ) {
            if ( index > maxMarksItems ) {
                $( this ).hide();
            }
            if ( index === maxMarksItems + 1 ) {
                marksWrapper.append( marksMoreBtn );
                marksMoreBtn.click(function (e) {
                    e.preventDefault();
                    $( this ).remove();
                    marksItems.show();
                })
            }
        });
    });

    // Init main slider(swiper)
    var mainSlider = new Swiper('.main_slider', {
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
    });

    // Init main reviews slider
    var mainReviewsSlider = new Swiper('.main_reviews_slider', {
        slidesPerView: 2,
        spaceBetween: 20,
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        breakpoints: {
            320: {
                slidesPerView: 1,
                spaceBetween: 20
            },
            576: {
                slidesPerView: 2,
                spaceBetween: 30
            },
        }
    });

    // Equal reviews height
    $(function () {
        var reviewsPageContainer = $('.reviews_page'),
            reviewsItems = $('.reviews_page_item', this);

        reviewsPageContainer.each(function(){
            var highestBox = 0;

            reviewsItems.each(function(){
                if($(this).height() > highestBox) {
                    highestBox = $(this).height();
                }
            });

            reviewsItems.height(highestBox);
        });
    });

    // Default select2 init
    $('.select2').select2({width: '100%'});

    // Init ionRangeSlider
    $('.main_filter_price_range').ionRangeSlider({
        type: 'double',
        min: 100000,
        max: 10000000,
        postfix: ' р.'
    });

    // Colorpicker init
    $('.js_colorpicker_image').justweColorChanger({
        menuItemsClass: '.js_colorpicker_item',
        titleClass: '.js_colorpicker_current'
    });

    // Model page tabs
    $('.model_page_tabs_content').justweContentSwitcher({
        autoLinksWrapperClass: '.model_page_tabs_nav'
    });

    // Model page options
    $('.model_page_options_item').justweAccordion({
        slideAnimation: true
    });

    // Mobile menu
    $('.mobile-header__menubtn').justweToggleDrop({
        openingItemClass: '.mobile-menu',
        callbackOpen: function() {
            $('body').addClass('mobile-menu-opened');
        },
        callbackClose: function() {
            $('body').removeClass('mobile-menu-opened');
        }
    });

    // Mobile breakpoints
    if ( $(window).width() < 993 ) {
        $('.main_catalog_heading--first').prependTo( $('.main_catalog_page__content') );
        $('.model_page_count').after( $('.model_page_pricing__section') );
        $('.model_page_pricing__actions').after( $('.model_gallery') );
    }

    // Init fancybox
    window.modalsOptions = {
        autoFocus: false,
        defaultType: 'inline',
        transitionDuration: 366,
        animationEffect: 'zoom-in-out',
        touch: false,
        hash: false,
        baseClass: 'justwe-fancybox-default',
    };
    $('.callmodal').fancybox(window.modalsOptions);
});
