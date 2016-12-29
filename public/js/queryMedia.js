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
                if(document.getElementById("queryMediaDiv") == null)
                    return;
                document.getElementById("queryMediaDiv").style.display = "";
                
                for($i = 0; $i < data.length; $i++)
                    $("#queryMediaDiv").append("<div onclick=clickMediaQuery(this)>" + data[$i] + "</div>");
            }
        );
    });
    $("#queryMedia").on("blur", function(){
        setTimeout(function(){
            if(document.getElementById("queryMediaDiv") == null)
                    return;
            document.getElementById("queryMediaDiv").style.display = "none";
            $("#queryMediaDiv").empty();
        },100);
    });

    $(".mediaList").each(function(index){
        $(this).on("focus input",function(){
            input = this
            name = $(this).prop("value");
            
            datalist = $(this).next("datalist");

            $.get( "/MediaName", { name: name }).done( 
                function( data ) {
                    // 刪除前面的空白
                    data = data.substr(4, data.length);
                    // 刪除後面的換行
                    data = data.substr(0, data.length - 1);
                    data = data.split(",")
                    $(datalist).empty();
                    if(data.length == 1 && data[0] == "\n")
                        return;
                    for($i = 0; $i < data.length; $i++)
                        $(datalist).append("<option value=" + data[$i] + ">");
                    
                }
            );
        });
    });
});

function clickMediaQuery(result)
{
    document.getElementById("queryMedia").value = result.innerText;
    document.getElementById("queryMediaDiv").style.display = "none";
    result.parentNode.innerHTML = "";
}