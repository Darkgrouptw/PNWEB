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

    $( "#upload_type" ).change(function() {
        var str = "";
        $( "select option:selected" ).each(function() {
            str += $( this ).text();
         });
        changeLoad(str);
    });

    function changeLoad(str){
        if(str == "上傳圖檔"){
            $("#source_web").css("display", "none");
            $("#source_file").css("display", "");
            $("#source_video").css("display", "none");
            $("#web_source").prop("value", "");
            $("#file_source").prop("value", "");
            $("#video_source").prop("value", "");
            $("#backup_type").prop("value", "1");
        }else if (str == "網頁連結"){
            $("#source_web").css("display", "");
            $("#source_file").css("display", "none");
            $("#source_video").css("display", "none");
            $("#web_source").prop("value", "");
            $("#file_source").prop("value", "");
            $("#video_source").prop("value", "");
            $("#backup_type").prop("value", "0");
        }else if(str == "錄音檔" ){
            $("#source_web").css("display", "none");
            $("#source_file").css("display", "");
            $("#source_video").css("display", "none");
            $("#web_source").prop("value", "");
            $("#file_source").prop("value", "");
            $("#video_source").prop("value", "");
            $("#backup_type").prop("value", "2");
        }else if(str == "影片連結(youtube,土豆網等...)"){
            $("#source_web").css("display", "none");
            $("#source_file").css("display", "none");
            $("#source_video").css("display", "");
            $("#web_source").prop("value", "");
            $("#file_source").prop("value", "");
            $("#video_source").prop("value", "");
            $("#backup_type").prop("value", "3");
        }

    }


});