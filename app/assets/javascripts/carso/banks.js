//= require carso/carso_credit

$(".credit_bp_txt").on("click","span.col", function(e){
    e.preventDefault();
    $(this).parent().find("div.col").toggleClass("on");
    $(this).parent().find("span.col").toggleClass("on");
});