$(document).ready(function(){
    $("#ReadRule").change(function(){
        $("#submitToSendEmail").attr("disabled", !$("#ReadRule").prop("checked"));
    })
})