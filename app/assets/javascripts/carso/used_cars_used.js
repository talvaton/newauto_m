var $filterPanel = $('[data-role="used-cars-filters"]'),
    $inputBlock = $filterPanel.find('[data-used-cars-filter]'),
    $inputRadio = $filterPanel.find('[type=radio]');

if ($filterPanel.length){
    $inputRadio.on('click', function(){
        $inputBlock.hide();
        var val = $(this).val();
        $filterPanel.find('[data-role='+val+']').show();

        // Для IOS
        nP = navigator.platform;
        if (nP == "iPad" || nP == "iPhone" || nP == "iPod" || nP == "iPhone Simulator" || nP == "iPad Simulator"){
            var val2 = $filterPanel.find('[data-role='+val+']').find('[data-action="select-content"]').find('option:selected').text();
            $filterPanel.find('[data-role='+val+']').find('[data-action="select-content"]').siblings('.button').find('[data-role="selected-content"]').text('').text(val2);
        }
    });
}
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
$("input[name='used_brand_year_switch'][value='brand']").attr("checked", true);



// открытие фильтра
$('[data-action="toggle-filter"]').on('click', function(){
    $('[data-role="used-main-filter"]').toggle();
});

// фильтр
var currentPage = 1,
    isPaginating = false,
    pagesAmount;

var sendFilter = function(e){
    currentPage = 1;
    // $("#filter_list table").show();
    // $("#filter_list tbody").html("").hide();
    $("#filter-results").html("");
    $("#filter_loader").show();
    $("#show-more-filter-results").hide();
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
        year_min : $("#filter_year_min").val(),
        year_max : $("#filter_year_max").val(),
        km_min : $("#filter_km_min").val(),
        km_max : $("#filter_km_max").val(),
        page:1
    };

    $.ajax({
        url: "/used/filter",
        type: 'post',
        data: data,
        beforeSend: function(xhr){xhr.setRequestHeader('Accept', '*/*;q=0.5, text/javascript, application/javascript, application/ecmascript, application/x-ecmascript');},
        error: function (e) {
            console.log(e);
        }
    }).then(function(){
        setTimeout(function(){
            $("#filter_loader").hide();
            if (currentPage < pagesAmount)  $("#show-more-filter-results").show();
            init_user_ajax_modal();
        }, 2000);
    });
}
$('#specials_filter_new_ticket').on('change', 'select, input', function(){
    sendFilter();
});
$('#specials_filter_new_ticket').on('keyup', 'select, input', function(e){
    if (e.charCode === 13 ) {
        e.preventDefault();
        $(e.target).change();
    }
});

$("[data-role=filter-countries-list]").on('click', 'li', function(e){
    e.preventDefault();
    $("[data-role=filter-countries-list] li").removeClass('car-main__color--choosed-blue');
    $(this).addClass('car-main__color--choosed-blue');
    $("#filter_country").val($(this).data('value')).change();
});

$("[data-action=filter-reset]").on('click', function(e){
    e.preventDefault();
    $(this).closest('form')[0].reset();

    if ($('[data-role=filter-countries-list]').length > 0)  $('[data-role=filter-countries-list] li:first-child').click();
    else {$($(this).closest('form').find('select')[0]).click();}
});

var uploadCars = function(){

    $("#show-more-filter-results").on('click', function(){
        $(this).hide();
        if (!isPaginating && currentPage < pagesAmount) {
            currentPage++;
            isPaginating = true;
            $("#filter_loader").show();
            $.ajax({
                url: "/used/filter",
                type: 'post',
                data: {
                    brand: $('#filter_brand').val(),
                    transmission: $("#filter_transmission").val(),
                    drive : $("#filter_drive").val(),
                    engine: $("#filter_engine").val(),
                    // type: $("#filter_type").val(),
                    country: $("#filter_country").val(),
                    volume_min : $("#filter_volume_min").val(),
                    volume_max : $("#filter_volume_max").val(),
                    power_min : $("#filter_power_min").val(),
                    power_max : $("#filter_power_max").val(),
                    price_min : $("#filter_price_min").val(),
                    price_max : $("#filter_price_max").val(),
                    year_min : $("#filter_year_min").val(),
                    year_max : $("#filter_year_max").val(),
                    km_min : $("#filter_km_min").val(),
                    km_max : $("#filter_km_max").val(),
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
                init_user_ajax_modal();
            });
        }
    });
};
uploadCars();
