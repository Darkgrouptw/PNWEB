$(function(){
    // 給 Issuelist 的 change 事件
    $("#queryIssue2").on("focus input" ,function(){
        $Name = $(this).prop("value");
        $.get( "/IssueName", { name: $Name }).done( 
            function( data ) {
                // 刪除前面的空白
                data = data.substr(4, data.length);
                // 刪除後面的換行
                data = data.substr(0, data.length - 1);
                data = data.split(",")
                $("#queryIssueDiv2").empty();
                
                if(data.length == 1 && data[0] == "\n")
                    return;
                
                document.getElementById("queryIssueDiv2").style.display = "";
                for($i = 0; $i < data.length; $i++)
                    $("#queryIssueDiv2").append("<div onclick=clickQuery2(this)>" + data[$i] + "</div>");
            }
        );
    });
    $("#queryIssue2").on("blur", function(){
        setTimeout(function(){
            document.getElementById("queryIssueDiv2").style.display = "none";
            $("#queryIssueDiv2").empty();
        },500);
    });
});

function clickQuery2(result)
{
    document.getElementById("queryIssue2").value = result.innerText;
    document.getElementById("queryIssueDiv2").style.display = "none";
    result.parentNode.innerHTML = "";
}