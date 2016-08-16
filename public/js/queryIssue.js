$(function(){
    // 給 Issuelist 的 change 事件
    $("#queryIssue").on("focus input" ,function(){
        $Name = $(this).prop("value");
        $.get( "/IssueName", { name: $Name }).done( 
            function( data ) {
                // 刪除前面的空白
                data = data.substr(4, data.length);
                // 刪除後面的換行
                data = data.substr(0, data.length - 1);
                data = data.split(",")
                $("#queryIssueDiv").empty();
                
                if(data.length == 1 && data[0] == "\n")
                    return;
                
                document.getElementById("queryIssueDiv").style.display = "";
                for($i = 0; $i < data.length; $i++)
                    $("#queryIssueDiv").append("<div onclick=clickQuery(this)>" + data[$i] + "</div>");
            }
        );
    });
    /*$("#queryIssue").on("blur", function(){
        setTimeout(function(){
            document.getElementById("queryIssueDiv").style.display = "none";
            $("#queryIssueDiv").empty();
        },100);
    });*/
});

function clickQuery(result)
{
    document.getElementById("queryIssue").value = result.innerText;
    document.getElementById("queryIssueDiv").style.display = "none";
    result.parentNode.innerHTML = "";
}