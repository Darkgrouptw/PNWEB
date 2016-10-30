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
        /*$.get( "/IssueName", { name: IssueName }).done( 
            function( data ) {
                // 刪除前面的空白
                data = data.substr(4, data.length);
                // 刪除後面的換行
                data = data.substr(0, data.length - 1);
                data = data.split(",")
                $("#queryIssueDiv").empty();
                
                if(data.length == 1 && data[0] == "\n")
                {
                    alert("無此議題！！");
                    return;
                }
                
            }
        );*/
    });
});