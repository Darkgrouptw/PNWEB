$(function(){
    // 給 Issuelist 的 change 事件
    $(".BoxShare").on("click" ,function(){
        $me = $(this)
        $title = $me.attr("title");
        $description = $me.attr("description");
        //$me.hide();
        $('meta[property="og\:title"]').remove();
        $('head').append( '<meta property="og\:title" content='+$title+'>' );
        $('meta[property="og\:description"]').remove();
        $('head').append( '<meta property="og\:description" content='+$description+'>' );
        $('meta[property="og\:url"]').remove();
        $('head').append( '<meta property="og\:url" content='+document.URL+'>' );
        //if ($me.attr("value") == "顯示") {
        //	$me.attr("value","隱藏")
        //}else if($me.attr("value") == "隱藏"){
        //	$me.attr("value","顯示")
        //}
        //$Name = $me.prop("value");
        //$.post( "../Issuelist/hide", { Name: $Name} );
    });
});