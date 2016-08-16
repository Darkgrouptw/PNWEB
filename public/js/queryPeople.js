$(function(){
    // 給 Issuelist 的 change 事件
    $("#trunkID").on("focus input" ,function(){
        $Name = $(this).prop("value");
        if($Name != "")
            $.get( "/PeopleName", { name: $Name }).done( 
                function( data ) {
                    // 刪除前面的空白
                    data = data.substr(4, data.length);
                    // 刪除後面的換行
                    data = data.substr(0, data.length - 1);
                    data = data.split(",")
                    $("#trunkIDDiv").empty();
                    
                    if(data.length == 1 && data[0] == "\n")
                        return;
                    
                    for($i = 0; $i < data.length; $i++)
                        $("#trunkIDDiv").append("<div onclick=clickQuery(this)>" + data[$i] + "</div>");
                }
            );
    });
    $("#trunkID").on("blur", function(){
        setTimeout(function(){
            $("#trunkIDDiv").empty();
        },100);
    });
});

function clickQuery(result)
{
    document.getElementById("trunkID").value = result.innerText;
    result.parentNode.innerHTML = "";
}