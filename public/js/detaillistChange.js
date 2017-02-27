$(function(){
    $("#not_directClick").change(function(){
        if(!$(this).prop("checked"))
        {
            $("#reportTime").attr("type", "date");
            $("#reportTime").prop("value", "");
        }
        else
        {
            $("#reportTime").attr("type", "text");
            $("#reportTime").prop("value", "");
        }
    });
    $("#directClick").change(function(){
        if($(this).prop("checked"))
        {
            $("#reportTime").attr("type", "date");
            $("#reportTime").prop("value", "");
        }
        else
        {
            $("#reportTime").attr("type", "text");
            $("#reportTime").prop("value", "");
        }
    });
    $("#previewButton").click(function(){
        $(".previewDiv").removeAttr("style");
        
        var obj = $("#queryPeople_blank").text($("#queryPeople").prop("value") + "\n(" + $("#title_at_that_time").prop("value") + ")");
        obj.html(obj.html().replace(/\n/g,'<br/>'));
        
        
        $("#content_blank").text($("#content").prop("value"));
        //support_blank
        if($("#directClick").prop("checked") == true)
            $("#directClick_blank").text("直接意見");
        else
            $("#directClick_blank").text("間接意見");
        
        if($("#supportClick").prop("checked") == true)
            $("#support_blank").text("贊成");
        else
            $("#support_blank").text("反對");
        
        obj = $("#news_media_blank").text($("#queryMedia").prop("value") + "\n（" + $("#reportTime").prop("value") + "）");
        obj.html(obj.html().replace(/\n/g,'<br/>'));
        
        
        var today = new Date();
        $("#title_at_that_time_blank").text(today);
    });
    
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

    $(".submit").click(function(){
        removeButton = $(".glyphicon-remove")
        removeButton.click();
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

            $("#web_source").prop("required",false);
            $("#file_source").prop("required",true);
            $("#video_source").prop("required",false);

        }else if (str == "網頁連結"){
            $("#source_web").css("display", "");
            $("#source_file").css("display", "none");
            $("#source_video").css("display", "none");
            $("#web_source").prop("value", "");
            $("#file_source").prop("value", "");
            $("#video_source").prop("value", "");
            $("#backup_type").prop("value", "0");

            $("#web_source").prop("required",true);
            $("#file_source").prop("required",false);
            $("#video_source").prop("required",false);

        }else if(str == "錄音檔" ){
            $("#source_web").css("display", "none");
            $("#source_file").css("display", "");
            $("#source_video").css("display", "none");
            $("#web_source").prop("value", "");
            $("#file_source").prop("value", "");
            $("#video_source").prop("value", "");
            $("#backup_type").prop("value", "2");

            $("#web_source").prop("required",false);
            $("#file_source").prop("required",true);
            $("#video_source").prop("required",false);

        }else if(str == "影片連結(youtube,土豆網等...)"){
            $("#source_web").css("display", "none");
            $("#source_file").css("display", "none");
            $("#source_video").css("display", "");
            $("#web_source").prop("value", "");
            $("#file_source").prop("value", "");
            $("#video_source").prop("value", "");
            $("#backup_type").prop("value", "3");

            $("#web_source").prop("required",false);
            $("#file_source").prop("required",false);
            $("#video_source").prop("required",true);

        }

    }


});