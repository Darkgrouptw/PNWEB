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
    }) 
});