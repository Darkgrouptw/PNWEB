$(function(){
    var window = $( document );
    if(window.width() < 1600 || window.height() < 750)
        $(".WindowSizeWarning").removeAttr("style");
    
    /* 視窗太小的事件 */
    $(".WindowSizeWarning div button").on("click", function(){
       $(".WindowSizeWarning").attr("style", "display: none;");
    });
});