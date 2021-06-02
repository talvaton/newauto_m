function initConfigurator(){
    // переключение панелей
    var $showTabBtn = $('[data-show-tabpanel]'),
        $tabPanel = $('[data-role]');
    $showTabBtn.on('click', function(){
        var showTabBtnData = $(this).data('show-tabpanel');
        // переключение кнопок меню
        $('.modal-configurator__nav-item--active').removeClass('modal-configurator__nav-item--active');
        $('[data-show-tabpanel='+showTabBtnData+']').addClass('modal-configurator__nav-item--active');

        // переключение панелей
        $('.modal-configurator__tabpanel--active').removeClass('modal-configurator__tabpanel--active');
        $('[data-role='+showTabBtnData+']').addClass('modal-configurator__tabpanel--active');

        disableFormBtn();
        $('#newcar_config_new_ticket').enableClientSideValidations();
    });

    $('[name="ticket[other][config_complect]"]').on('change', function(){addComplectInfo($(this))});
    addComplectInfo($('[name="ticket[other][config_complect]"]'));


    $('[name="ticket[other][color]"]').on('change', function(){addColorInfo($(this))});
    addColorInfo($('[name="ticket[other][color]"]'));
}

    // добавление инфо в итоговую панель
    var addComplectInfo = function(input){
        input.each(function(index, elem){
            if ($(elem).prop('checked') === true){

                $("#car-complect").text($(this).val());
                var compl_string = $(this).val();

                $.ajax({
                    url: "/catalog/" + car_brand + "/" + car_url + "/configurator",
                    type: 'POST',
                    data: { carid:carid,compl:compl_string,param:'compl'},
                    error: function (e) {
                        console.log(e);
                    }
                });
            }
        })
    };

    var addEngineInfo = function(input){
        input.each(function(index, elem){
            if ($(elem).prop('checked') === true) {
                var engine = $(elem).siblings('label').find('[data-role="car-engine"]').text();
                var price = $(elem).siblings('label').find('[data-role="car-price"]').text();

                $("#car-engine").text(engine);
                $("#car-price").text(price);

                var compl_string = $("#car-complect").text();

                var spec_id = $(elem).attr('data-id');

                $.ajax({
                    url: "/catalog/" + car_brand + "/" + car_url + "/configurator",
                    type: 'POST',
                    data: { carid:carid,compl:compl_string,param:'tech',spec:spec_id},
                    error: function (e) {
                        console.log(e);
                    }
                });
            }
        })
    };

    var addColorInfo = function(input){
        input.each(function(index, elem){
            if ($(elem).prop('checked') === true) {
                $('.modal-configurator__img').attr('src',$(elem).attr('data-altsrc'));
                $('.configurator-common__img').attr('src',$(elem).attr('data-altsrc'));
            }
        })
    };

    // addComplectInfo($('[name="kompl"]'));
    // addEngineInfo($('[name="engine"]'));
    // addColorInfo($('[name="color"]'));