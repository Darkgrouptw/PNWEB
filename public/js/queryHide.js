$(function(){
    // 給 Issuelist 的 change 事件
    $(".hideIssueButton").on("click" ,function(){
        $me = $(this)
        $Name = $me.attr("issue_id");
        $me.hide();
        //$Name = $me.prop("value");
        $.post( "../Issuelist/hide", { Name: $Name} );
    });
});