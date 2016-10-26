$(function(){
    // 給 Issuelist 的 change 事件
    $("#queryPeople").on("focus input" ,function(){
        $Name = $(this).prop("value");
        $.get( "/PeopleName", { name: $Name }).done( 
            function( data ) {
                // 刪除前面的空白
                data = data.substr(4, data.length);
                // 刪除後面的換行
                data = data.substr(0, data.length - 1);
                data = data.split(",")
                $("#queryPeopleDiv").empty();
                
                if(data.length == 1 && data[0] == "\n")
                    return;
                document.getElementById("queryPeopleDiv").style.display = "";
                
                for($i = 0; $i < data.length; $i++)
                    $("#queryPeopleDiv").append("<div onclick=clickPeopleQuery(this)>" + data[$i] + "</div>");
            }
        );
    });
    $("#queryPeople").on("blur", function(){
        setTimeout(function(){
            document.getElementById("queryPeopleDiv").style.display = "none";
            $("#queryPeopleDiv").empty();
        },100);
    });
});

function clickPeopleQuery(result)
{
    document.getElementById("queryPeople").value = result.innerText;
    document.getElementById("queryPeopleDiv").style.display = "none";
    result.parentNode.innerHTML = "";
}