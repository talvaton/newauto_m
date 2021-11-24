//= require sourcebuster.min

sbjs.init();

window.onload = function() {
    // Parse the URL
    function getParameterByName(name) {
        var name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)");
        var results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }
    // Give the URL parameters variable names
    var source = getParameterByName('utm_source');
//    var medium = getParameterByName('utm_medium');
//    var campaign = getParameterByName('utm_campaign');

    // Put the variable names into the hidden fields in the form.
    //document.getElementById("select2-credit_ticket_other_marka-container").value = source;
   // document.getElementById("property_utm_medium").value = medium;
   // document.getElementById("property_utm_campaign").value = campaign;

    //U Can use it with Expertsender Forms

    var $option = $("<span class='select2-selection__rendered' id='select2-credit_ticket_other_marka-container' role='textbox' aria-readonly='true' title=''></span>").val('1').text(source);
    //var $optionm = $("<span class='select2-selection__rendered' id='select2-credit_ticket_other_model-container' role='textbox' aria-readonly='true' title='Picanto'>Picanto</span>").val('1').text("Picanto");
    $('#select2-credit_ticket_other_marka-container').html($option).trigger('change');
  //  $('#select2-credit_ticket_other_model-container').html($optionm).trigger('change').parent().parent().parent().removeClass("select2-container--disabled").addClass("select2-container--below");
}