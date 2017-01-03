// Resize 測試
$(window).resize(function() {
    //console.log("Resize");
});
$(function(){
    
    var window = $( document );
    if(window.width() < 1600 || window.height() < 750)
        $(".WindowSizeWarning").removeAttr("style");
    
    if(getChromeVersion() < 55)
        alert("建議使用 Chrome 版本 55 以上");
    
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
        var SearchName = $("#queryIssue2").prop("value");
        
        var orderParams = getUrlParameter("OrderBy");
        if(orderParams != "undefined")
           orderParams = "/TreeIndex?OrderBy=" + orderParams;
        else
            orderParams = "/TreeIndex";
        
        if(typeof SearchName != "undefined")
            if (SearchName == "")
                $(location).attr('href', orderParams);
            else
                $(location).attr('href', orderParams + '&search=' + SearchName);
    });
    
    // 在東西沒有儲存的時候關閉視窗，會跳出警告說，沒有儲存
    /*$(".RightCanvas").bind("beforeunload", function() { 
        //return 'Are you sure you want to leave?';
        if($(".RightCanvas")[0].contentWindow.$IsChangeTree)
            return "東西尚未儲存";
    })*/
});

/*
拿 Chrome 的版本
*/
function getChromeVersion () {     
    var raw = navigator.userAgent.match(/Chrom(e|ium)\/([0-9]+)\./);

    return raw ? parseInt(raw[2], 10) : false;
}

/*
拿目前所在的連結，有沒有哪一個參數
*/
function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};