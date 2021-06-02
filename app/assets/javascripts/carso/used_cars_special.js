// фильтр
var currentPage = 1,
    isPaginating = false,
    pagesAmount;

var sendFilter = function(e){
    currentPage = 1;
    $("#filter-results").html("");
    $("#filter_loader").show();
    $("#show-more-filter-results").hide();
    var data = {
        brand: $('#filter_brand').val(),
        transmission: $("#filter_transmission").val(),
        drive : $("#filter_drive").val(),
        engine: $("#filter_engine").val(),
        country: $("#filter_country").val(),
        volume_min : $("#filter_volume_min").val(),
        volume_max : $("#filter_volume_max").val(),
        power_min : $("#filter_power_min").val(),
        power_max : $("#filter_power_max").val(),
        price_min : $("#filter_price_min").val(),
        price_max : $("#filter_price_max").val(),
        year_min : $("#filter_year_min").val(),
        year_max : $("#filter_year_max").val(),
        page:1
    };

    $.ajax({
        url: "/deals/filter",
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
                url: "/deals/filter",
                type: 'post',
                data: {
                    brand: $('#filter_brand').val(),
                    transmission: $("#filter_transmission").val(),
                    drive : $("#filter_drive").val(),
                    engine: $("#filter_engine").val(),
                    country: $("#filter_country").val(),
                    volume_min : $("#filter_volume_min").val(),
                    volume_max : $("#filter_volume_max").val(),
                    power_min : $("#filter_power_min").val(),
                    power_max : $("#filter_power_max").val(),
                    price_min : $("#filter_price_min").val(),
                    price_max : $("#filter_price_max").val(),
                    year_min : $("#filter_year_min").val(),
                    year_max : $("#filter_year_max").val(),
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