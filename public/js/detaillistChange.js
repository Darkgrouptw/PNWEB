$(function(){
    $("#directClick").change(function(){
        if($(this).prop("checked"))
        {
            $("#reportTime").attr("type", "text");
            $("#reportTime").prop("value", "");
        }
        else
        {
            $("#reportTime").attr("type", "date");
            $("#reportTime").prop("value", "");
        }
    });
    
    $("#previewButton").click(function(){
        $(".previewDiv").removeAttr("style");
        
        var obj = $("#queryPeople_blank").text($("#queryPeople").prop("value") + "\n(" + $("#title_at_that_time").prop("value") + ")");
        obj.html(obj.html().replace(/\n/g,'<br/>'));
        
        
        $("#content_blank").text($("#content").prop("value"));
        
        if($("#directClick").prop("value"))
            $("#directClick_blank").text("是");
        else
            $("#directClick_blank").text("否");
        
        
        obj = $("#news_media_blank").text($("#news_media").prop("value") + "\n（" + $("#reportTime").prop("value") + "）");
        obj.html(obj.html().replace(/\n/g,'<br/>'));
        
        
        var today = new Date();
        $("#title_at_that_time_blank").text(today);
    })
    
    $(".previewDiv div span").click(function(){
        $(".previewDiv").css("display", "none");
    })
});