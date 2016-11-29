$(function(){
    var window = $( document );
    if(window.width() < 1600 || window.height() < 750)
        $(".WindowSizeWarning").removeAttr("style");
    
    /* 視窗太小的事件 */
    $(".WindowSizeWarning div button").on("click", function(){
       $(".WindowSizeWarning").attr("style", "display: none;");
    });
    
    $("#RemoveAddRoot").on("click", function(){
        $(".AddRoot").attr("style", "display: none;");
    });
    
    $("#addRoot").on("click", function(){
        $(".AddRoot").removeAttr("style");
    });
    
    $(".BoxSpace").on("click", function(){
        var item = $(".BoxSpace");
        for(var i = 0; i < item.length; i++)
        {
            var temp = item[i].children[0];
            $(temp).attr("style", "display: none;");
        }
        var temp = this.children[0];
        $(temp).removeAttr("style");
        $(".RightCanvas").attr("src", "/TreeCanvas?id=" + $(this).attr("tree_id"));
    });
    
    $("#addRootBtn").on("click", function(){
        var IssueName = $("#queryIssue").prop("value");
        var IsCorrect = false;
        $.get( "/tree_check", { name: IssueName }).done( 
            function( data ) {
                data = data.replace("    ", "");
                if(data == "false")
                {
                    alert("沒有這個議題！！");
                    return;
                }
                
                $(location).attr('href','/TreeAddRoot?name=' +  IssueName);
            }
        );
    });
    
    
    $("#TreeIndexSearch").on("click", function(){
        var SearchName = $("#queryIssue").prop("value");
        if(typeof SearchName != "undefined")
            if (SearchName == "")
                $(location).attr('href','/TreeIndex');
            else
                $(location).attr('href','/TreeIndex?search=' +  SearchName);
    });
});