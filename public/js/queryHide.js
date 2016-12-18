$(function(){
    // 給 Issuelist 的 change 事件
    $(".hideIssueButton").on("click" ,function(){
        $me = $(this)
        $Name = $me.attr("issue_id");
        //$me.hide();
        
        if ($me.attr("value") == "顯示") {
        	$me.attr("value","隱藏")
        }else if($me.attr("value") == "隱藏"){
        	$me.attr("value","顯示")
        }
        //$Name = $me.prop("value");
        $.post( "../Issuelist/hide", { Name: $Name} );
    });
});