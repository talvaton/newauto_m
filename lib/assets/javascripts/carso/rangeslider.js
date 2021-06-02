var creditdate = 84,
    creditfirst = 25;

function numberWithSpaces(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}

function isIE () {
    var myNav = navigator.userAgent.toLowerCase();
    return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
}
var rangePolyfill = (isIE () && isIE () <= 9) ? true : false;

$('input[data-role="persent-range"]').rangeslider({
    polyfill : rangePolyfill,
    onInit : function() {
        if (this.$element.data('role') === 'persent-range'){
            this.output = $( '<div class="rangeslider__output" />' ).appendTo( this.$range.find('.rangeslider__handle') ).html( this.$element.val() + "%");
        }
    },
    onSlide : function( position, value ) {
        if (this.$element.data('role') === 'persent-range'){
            creditfirst = this.$element.val();
            this.output.html( this.$element.val() + "%");
        }
        adjust_credit_prices();
    }
});


var $monthInput = $('[data-role="month-range"]');


$('#month-plus, #month-minus').on('click', function(){

    if ($(this).attr('id') === 'month-minus') {
        if (creditdate === 6) return;
        creditdate -= 6;
    }
    else {
        if (creditdate === 84) return;
        creditdate += 6;
    }

    $monthInput.val(creditdate + ' месяцев');
    $monthInput.text(creditdate + ' месяцев');
    $monthInput.change();
});

$monthInput.on('change', function(){
    adjust_credit_prices();
});


function countcredit(str){

    s = parseInt(str, 10);

    first = s * creditfirst / 100;
    c = s - first;

    //percent 0.099/12 = 0.00825 #9.9%
    //percent 0.065/12 = 0.005416667 #6.5%
    // percent = 0.005416667;
    //percent = 0.002916667;
    percent = 0.001583333;

    date = creditdate * -1;
    monthupper  = c * percent;
    monthlower =  1 - Math.pow((1 + percent),date);

    month = monthupper/monthlower;

    month = Math.round(month);
    month = month.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    return month;
}

function adjust_credit_prices()
{
    $('[data-price]').each(function(){
        price = $(this).data('price');
        $(this).html(countcredit(price))
    });
}