$(document).ready(function(){
    // 要將 ReportModal 裡面的 Tile 加上，編輯者，主要論述
    $(".ReportModal_Voted").each(function(){
            $(this).click(function(){
            $("#ReportForm").attr("action", "/Reportlist/new" );
            $("#detail_id").attr("value", detail_id);
        })
    })
})