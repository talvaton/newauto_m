
var  set_player_height = function(){
    var ratio = 1.7777777777777777; // ratio for 640*360 video
    var player_width = $('#youtube-player').width();
    var player_height = player_width / ratio;

    $('#youtube-player').height(player_height);
    $('#youtube-videos').height(player_height);
};

// кнопка Читать полностью
var toggleReviewComment = function(){
    $('[data-content="review-full"]').each(function(index, elem){
        var $cuttedBlock = $(elem).next('[data-content="review-cutted"]')
        $(elem).closest(".card").find('[data-action="show-review-full"]').on('click', function(){
            $(this).hide();
            $cuttedBlock.hide();
            $(elem).slideDown(150);
        });
    });
};

$(function(){
    // Build the url
    var id = 'PLHpvdAouOo_YkCytWO1ltQ_1cbfnv-YGF',
        key = 'AIzaSyDiiZ0_xe1DFFsDmV8s_4MPxdvNbLpMCfo',
        max_results = 50,
        next_page = "",
        url ="https://www.googleapis.com/youtube/v3/playlistItems?playlistId="+id+"&orderby=reversedPosition&pageToken="+next_page+"&maxResults="+max_results+"&key="+key+"&part=snippet,status,contentDetails";

    //Connect to youtube via json
    $.getJSON(url,function(data){

        // console.log(data.items);
        $.map(data.items, function(item){

            var snippet = item.snippet,
                title = snippet.title,
                status = item.status.privacyStatus,
                video_id  = "",
                thumb_url = "",
                video_url = "";

            if(status !== "public") {
                return;
            }

            if(snippet.thumbnails !== undefined){
                video_id  = snippet.resourceId.videoId;
                thumb_url = snippet.thumbnails.medium.url;
                video_url = "https://www.youtube.com/embed/"+video_id;
            }else{
                return;
            }

            var $block  = '<li class="media-block__video-item" data-action="show-video" data-src="https://www.youtube.com/embed/'+video_id+'?rel=0">';
            $block += '<div class="media-block__img-wrapper"><img class="media-block__img" src="'+thumb_url+'" alt="'+title+'" /></div>';
            $block += '<div class="media-block__info">';
            $block += '<span class="media-block__name">'+title+'</span>';
            $block += '</div>';
            $block += '</li>';

            $("#youtube-videos").append($block);
        });
    }).always(function(){

        set_player_height();


        // $("#youtube-videos").closest('.scrollbar-inner').scrollbar();

        var videoLink = $('[data-action="show-video"]'),
            videoBlock = $('[data-role="video"]');


        videoLink.on('click', function(e){
            e.preventDefault();
            var videoSrc = $(this).data('src');
            videoBlock.attr('src', videoSrc);
            $('.media-block__video-item--active').removeClass('media-block__video-item--active');
            $(this).addClass('media-block__video-item--active');
        });
        $('.media-block__video-item:first-child').addClass('media-block__video-item--active').click();
    });


    // кнопка Читать полностью
    toggleReviewComment();



    $(window).on('resize', function(){
        set_player_height();
    });
});