/* select change */
function price_select(){
    $("#do_price_select").change(function() {
        var do_price_link = $("#do_price_select").val();
        var do_price_text = $("#do_price_select option:selected").text();
        $("#do_price_submit").attr("href", do_price_link);
        $("#do_price_submit").text("Найти авто за "+do_price_text);
    });
}