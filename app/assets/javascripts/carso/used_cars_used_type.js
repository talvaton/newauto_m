//= require carso/used_cars_used

$("input[name='used_switch'][value='type']").attr("checked", true);

$('[data-action="select-content"]').find('[value="/sprobegom/'+url+'"]').attr('selected', true);
$('[data-action="select-content"]').change();

// Для IOS
nP = navigator.platform;
if (nP == "iPad" || nP == "iPhone" || nP == "iPod" || nP == "iPhone Simulator" || nP == "iPad Simulator"){
    var text = $('[data-action="select-content"]').find('[value="/sprobegom/'+url+'"]').text();
    $('[data-action="select-content"]').find('[value="/sprobegom/'+url+'"]').prop("selected", false).prop("selected", true);
    $('[data-action="select-content"]').siblings('.button').find('[data-role="selected-content"]').text('').text(text);
}