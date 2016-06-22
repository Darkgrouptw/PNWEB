$(document).ready(function(){
    // 要將 ReportModal 裡面的 Tile 加上，編輯者，主要論述
    $("#ReportModal_Button").click(function(){
        //alert($(this).attr("detail_id"))
        const strTitle = "我要檢舉  —  ";
        const post_name = $(this).attr("post_name") + "在 ";
        const issue_name = $(this).attr("issue_name") + " 底下 po 的 ";
        const content = $(this).attr("content") + " ";
        const detail_id = $(this).attr("detail_id");

        $(".modal-title").text(strTitle + post_name + issue_name + content);
        $("#ReportForm").attr("action", "/issuelist/" + detail_id + "/Report");
    })

    // 給 CheckRule 的按鈕規則
    $("#CheckRule1").change(function(){
        if(!$(this).prop("checked"))
        {
            $("#CheckRule2").prop("checked", false);
            $("#CheckRule3").prop("checked", false);
            $("#CheckRule4").prop("checked", false);
            $("#CheckRule5").prop("checked", false);
        }
    })
    $("#CheckRule2").change(function(){
        if($(this).prop("checked"))
        {
            $("#CheckRule1").prop("checked", true);
        }
    })
    $("#CheckRule3").change(function(){
        if($(this).prop("checked"))
        {
            $("#CheckRule1").prop("checked", true);
        }
        else
        {
            $("#CheckRule4").prop("checked", false);
            $("#CheckRule5").prop("checked", false);
        }
    })
    $("#CheckRule4").change(function(){
        if($(this).prop("checked"))
        {
            $("#CheckRule1").prop("checked", true);
            $("#CheckRule3").prop("checked", true);
        }
    })
    $("#CheckRule5").change(function(){
        if($(this).prop("checked"))
        {
            $("#CheckRule1").prop("checked", true);
            $("#CheckRule3").prop("checked", true);
        }
    })
})