//= require carso/used_cars_used

$('[data-action="select-content"]').find('[value="/brand/'+url+'"]').attr('selected', true);
$('[data-action="select-content"]').change();

// Для IOS
nP = navigator.platform;
if (nP == "iPad" || nP == "iPhone" || nP == "iPod" || nP == "iPhone Simulator" || nP == "iPad Simulator"){
    var text = $('[data-action="select-content"]').find('[value="/brand/'+url+'"]').text();
    $('[data-action="select-content"]').find('[value="/brand/'+url+'"]').prop("selected", false).prop("selected", true);
    $('[data-action="select-content"]').siblings('.button').find('[data-role="selected-content"]').text('').text(text);
}