$(function(){
    // 給 Issuelist 的 change 事件
    $("#queryMedia").on("focus input" ,function(){
        $Name = $(this).prop("value");
        $.get( "/MediaName", { name: $Name }).done( 
            function( data ) {
                // 刪除前面的空白
                data = data.substr(4, data.length);
                // 刪除後面的換行
                data = data.substr(0, data.length - 1);
                data = data.split(",")
                $("#queryMediaDiv").empty();
                
                if(data.length == 1 && data[0] == "\n")
                    return;
                document.getElementById("queryMediaDiv").style.display = "";
                
                for($i = 0; $i < data.length; $i++)
                    $("#queryMediaDiv").append("<div onclick=clickMediaQuery(this)>" + data[$i] + "</div>");
            }
        );
    });
    $("#queryMedia").on("blur", function(){
        setTimeout(function(){
            document.getElementById("queryMediaDiv").style.display = "none";
            $("#queryMediaDiv").empty();
        },100);
    });
});

function clickMediaQuery(result)
{
    document.getElementById("queryMedia").value = result.innerText;
    document.getElementById("queryMediaDiv").style.display = "none";
    result.parentNode.innerHTML = "";
}