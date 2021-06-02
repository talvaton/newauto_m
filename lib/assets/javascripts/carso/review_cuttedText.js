var toggleReviewComment = function(){
    $('[data-content="review-full"]').each(function(index, elem){
        // var cuttedText = $(this).text().substring(0, 150);
        var $cuttedBlock = $(elem).next('[data-content="review-cutted"]');
        // $cuttedBlock.text(cuttedText+ "...");
        $(elem).closest(".card").find('[data-action="show-review-full"]').on('click', function(){
            $(this).hide();
            $cuttedBlock.hide();
            $(elem).slideDown(150);
        });
    });
}
toggleReviewComment();