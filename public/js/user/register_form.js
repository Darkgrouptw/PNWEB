// 註冊頁面
$(document).ready(function(){
    
    // 一個勾選，其他取消勾選
    var maleCheckbox = $("#male");
    var femaleCheckbox = $("#female");
    var otherCheckbox = $("#other");
    maleCheckbox.click(function(){
        if($(this).prop("checked"))
        {
            femaleCheckbox.prop("checked", false);
            otherCheckbox.prop("checked", false);
        }
    })
    femaleCheckbox.click(function(){
        if($(this).prop("checked"))
        {
            maleCheckbox.prop("checked", false);
            otherCheckbox.prop("checked", false);
        }
    })
    otherCheckbox.click(function(){
        if($(this).prop("checked"))
        {
            maleCheckbox.prop("checked", false);
            femaleCheckbox.prop("checked", false);
        }
    })
})