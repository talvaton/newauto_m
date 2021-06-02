/*
if ($('#map').length) ymaps.ready(init);

var myMap,
    myPlacemark;

function init(){
    myMap = new ymaps.Map("map", {
        center: [55.706867, 37.586785],
        zoom: 16
    });
    myPlacemark = new ymaps.Placemark(myMap.getCenter(), {
        hintContent: 'Автосалон Авиньен',
        balloonContent: 'г. Москва, ул. Вавилова, 13А метро: Ленинский проспект, МЦК Площадь Гагарина',

    }, {
        // iconLayout: 'default#image',
        preset: 'islands#redAutoIcon',
        // iconImageHref: '/static/img/logo-marker-6.svg',
        // Размеры метки.
        // iconImageSize: [46, 70],
        // Смещение левого верхнего угла иконки относительно её "ножки" (точки привязки).
        // iconImageOffset: [-23, -35],
    });

    myMap.geoObjects.add(myPlacemark);
}
*/