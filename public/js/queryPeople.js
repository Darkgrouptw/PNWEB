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
                if(document.getElementById("queryPeopleDiv") == null)
                    return;
                document.getElementById("queryPeopleDiv").style.display = "";
                
                for($i = 0; $i < data.length; $i++)
                    $("#queryPeopleDiv").append("<div onclick=clickPeopleQuery(this)>" + data[$i] + "</div>");
            }
        );
    });
    $("#queryPeople").on("blur", function(){
        setTimeout(function(){
            if(document.getElementById("queryPeopleDiv") == null)
                return;
            document.getElementById("queryPeopleDiv").style.display = "none";
            $("#queryPeopleDiv").empty();
        },100);
    });

    $(".peopleList").each(function(index){
        $(this).on("focus input",function(){
            input = this
            name = $(this).prop("value");
            
            datalist = $(this).next("datalist");
            console.log("test");
            $.get( "/PeopleName", { name: name }).done( 
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

function clickPeopleQuery(result)
{
    document.getElementById("queryPeople").value = result.innerText;
    document.getElementById("queryPeopleDiv").style.display = "none";
    result.parentNode.innerHTML = "";
}