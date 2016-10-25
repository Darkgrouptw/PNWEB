var CircleScale = 0.8;
var Colur = ["#FFFFFF", "#88D365", "#F72758", "#6495ED", "#FFD905", "#F7F7F7", "#FCC2C2", "#2E3192", "#ECA400", "#FBF2C0", "#6FB722", "#FF9900", "#2364AA", "#3DA5D9", "#73BFB8", "#00B6CC", "#99CC33"]
$(function(){
    // 變數宣告
    $NodeNumber = 0;                        // 判斷總共有幾個 Node
    $clickID = "";                          // 判斷點擊的 Index
    $chooseIndex = "";                      // Chooose 的選項
    
    $boolIsCreate = false;                  // 是否正屬於創建 Node 的時候
    
    /*
    加東西的 Div 事件
    */
    $(".AddItemDiv .glyphicon-remove").on("click", function(){
        $chooseIndex = "";
        $$clickID = "";
        
        $(".blackAddItemDiv").animate({
            "background-color": 'rgba(0, 0, 0, 0)'
        }, 500, function(){
            $(this).hide();
        });
        $(".AddItemDiv").animate({
            bottom: "-=500px"
        }, 500, function(){
            $(this).hide();
        });
    });
    
    /*
    選單效果
    */
    // 取消右鍵選單，依照情形來顯示選單
    $(".MenuBox svg").on("contextmenu", function(event){
        // 避免真的選單跳出來
        event.preventDefault();
    });
    $(".MenuBox svg").on("click", function(){
        if (!$(event.target).parents(".custom-menu").length > 0 && event.button != 2)
        {
            $(".custom-menu").hide(100); 
            $clickID = "";    
        }
    });
    
    $("#ListAddNode").on("click", function(event){
        $chooseIndex = parseInt($(event.target).attr("index"));
        switch($(event.target).attr("index"))
        {
            case "0":
            case "1":
                $(this).hide(100);
                
                
                // 產生東西給你加議題
                $(".blackAddItemDiv").attr("style", "background-color: rgba(0, 0, 0, 0);");
                $(".AddItemDiv").attr("style", "buttom: -500px;");
                $(".blackAddItemDiv").animate({
                    "background-color": 'rgba(0, 0, 0, 0.8)'
                }, 500);
                $(".AddItemDiv").animate({
                    bottom: "+=500px"
                }, 500);
                break;
            case "2":
                MoveToParent();
                $(this).hide(100);
                break;
            case "3":
                MoveToChild();
                $(this).hide(100);
                break;
            case "4":
                DeleteNode();
                $(this).hide(100);
                break;
        }
    });
    $(".blackAddItemDiv").on("contextmenu", function(){
       return false; 
    });
    $(".AddItemDiv").on("contextmenu", function(){
       return false; 
    });
    $(".input-group-btn button").on("click", function(event){
        var NodeName = $("#queryIssue").prop("value");
        if(NodeName != "")
        {
            switch($chooseIndex)
            {
                case 0:
                    AddNodeToChild(NodeName);
                    break;
                    
                case 1:
                    AddNodeInSameLevel(NodeName);
                    break;
            }
            
            $(".blackAddItemDiv").animate({
                "background-color": 'rgba(0, 0, 0, 0)'
            }, 500, function(){
                $(this).hide();
            });
            $(".AddItemDiv").animate({
                bottom: "-=500px"
            }, 500, function(){
                $(this).hide();
            });
        }
    });
    $(".custom-menu li").on("contextmenu", function(event){
       event.preventDefault(); 
    });
});

/*
因為 SVG 並非 html(namespace不同)，所以無法直接 append 上去，只能用這個方法貼上去
*/
function makeCircleSVG(attrs, text, nowLevel, Degree, pos, parentID) 
{
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    var el = document.createElementNS('http://www.w3.org/2000/svg', "circle");
    var tarea = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    g.appendChild(el);
    g.appendChild(tarea);
    
    for (var k in attrs)
        el.setAttribute(k, attrs[k]);
    
    // 判斷他是否是現在要加進去的
    $(g).attr("id", "Node" + $NodeNumber);
    $(tarea).attr("class", "textArea");
    
    // 超過一定範圍，就不縮小了
    var scale = 1;
    if(nowLevel >= 7)
        scale = Math.pow(0.8, 7);
    else
        scale = Math.pow(0.8, nowLevel);
    
    var posX = pos[0] + radius * Math.cos(Degree / 180 * Math.PI) * scale;
    var posY = pos[1] + radius * Math.sin(Degree  / 180 * Math.PI) * scale;
    
    $(g).attr("parent", parentID);
    if($NodeNumber != 0)
    {
        $(g).attr("org_pos_X", posX);
        $(g).attr("org_pos_y", posY);
        $(g).attr("lerp_pos_x", posX);
        $(g).attr("lerp_pos_y", posY);
        $(g).attr("OrgScale", scale);
        $(g).attr("NowLevel", nowLevel);
        
        $(g).attr("style", "transform: translate(" + posX + "px, " + posY + "px) scale(" + scale + ");");
        pos[0] = posX;
        pos[1] = posY;
    }
    else
    {
        $(g).attr("org_pos_X", 0);
        $(g).attr("org_pos_y", 0);
        $(g).attr("lerp_pos_x", 0);
        $(g).attr("lerp_pos_y", 0);
        $(g).attr("OrgScale", 1);
        $(g).attr("NowLevel", nowLevel);
    }
    $NodeNumber++;
    
    $(g).on("contextmenu", function(event){
        // 避免真的選單跳出來
        event.preventDefault();
        
        $clickID = $(event.target.parentNode).attr("id");
        
        $("#ListAddNode").show(100).css({
            top: event.pageY + "px",
            left: event.pageX + "px"
        });
    });
    
    // 新增文字
    tarea.setAttribute("style", " font-size:24px;");
    tarea.textContent = text;
    return g;
};

// 只有在按下加點的時候，會產生一個 Node
function makeSimpleCircleSVG(attrs, text)
{
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    var el = document.createElementNS('http://www.w3.org/2000/svg', "circle");
    var tarea = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    g.appendChild(el);
    g.appendChild(tarea);
    
    for (var k in attrs)
        el.setAttribute(k, attrs[k]);

    $(g).attr("id", "NodeMove");
    $(tarea).attr("class", "textArea");
    
    // 新增文字
    tarea.setAttribute("style", " font-size:24px;");
    tarea.textContent = text;
    
    return g;
}

function makeLineSVG(attrs, fromID, toID) 
{
    var l = document.createElementNS('http://www.w3.org/2000/svg', "line");
    for (var k in attrs)
        l.setAttribute(k, attrs[k]);
    $(l).attr("id", "Line" + fromID + "To" + toID);
    return l;
}

function RandomColor()
{
    var index = Math.floor((Math.random() * 117) % Colur.length);
    return Colur[index];
}


/*
五種操作
*/
function AddNodeToChild(NodeName)
{
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        var n = clickNode.children()[1].textContent;
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length; i++)
                checkList.push(checkList[0].parent[i]);
        else
        {
            checkList[0]['parent'].push({"name":NodeName, "color": RandomColor(), "parent":[]});
            IsFind = true;
            break;
        }
        // 刪除第一個
        checkList.splice(0, 1);
    }
    
    if(IsFind)
    {
        $(".MenuBox svg").empty();
        $NodeNumber = 0;
        TreeManager(sJsonData);
    }
}
function AddNodeInSameLevel(NodeName)
{
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        var n = clickNode.children()[1].textContent;
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length; i++)
            {
                if(n != checkList[0].parent[i].name)
                    checkList.push(checkList[0].parent[i]);
                else
                {
                    checkList[0]['parent'].push({"name":NodeName, "color": RandomColor(), "parent":[]});
                    IsFind = true;
                    break;
                }
            }
        else
        {
            alert("Root 這層不能加同層的東西！！");
            break;
        }
        
        // 刪除第一個
        checkList.splice(0, 1);
    }
    
    if(IsFind)
    {
        $(".MenuBox svg").empty();
        $NodeNumber = 0;
        TreeManager(sJsonData);
    }
}
function MoveToParent()
{
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            IsFind = true;
            break;
        }
        
        var n = clickNode.children()[1].textContent;
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length && !IsFind; i++)
            {
                console.log(i + " " + checkList[0].parent.length + " " +  checkList[0].parent[i].name + " " + n);
                if(n == checkList[0].parent[i].name)
                {
                    alert("不能上移到跟 Root 同一層！！");
                    IsFind = true;
                    break;
                }
                else
                {
                    for(var j = 0; j < checkList[0].parent[i].parent.length; j++)
                        if(n == checkList[0].parent[i].parent[j].name)
                        {
                            //var name = checkList[0].parent[i].parent[j].name;
                            checkList[0]['parent'].push(checkList[0].parent[i].parent[j]);
                            checkList[0].parent[i]['parent'].splice(j, 1);
                            IsFind = true;
                            break;
                        }
                    checkList.push(checkList[0].parent[i]);
                }
            }
        else
        {
            alert("已經是最上層了！！");
            break;
        }
        
        // 刪除第一個
        checkList.splice(0, 1);
    }
    
    
    if(IsFind)
    {
        $(".MenuBox svg").empty();
        $NodeNumber = 0;
        TreeManager(sJsonData);
    }
}
function MoveToChild()
{
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        var n = clickNode.children()[1].textContent;
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length; i++)
            {
                if(n != checkList[0].parent[i].name)
                    checkList.push(checkList[0].parent[i]);
                else
                {
                    if(checkList[0].parent[i].parent.length == 0)
                        alert("已經在最下層囉！！");
                    else
                    {
                        var NodeNumber = checkList[0].parent[i].parent.length;
                        for(var j = 0; j < NodeNumber; j++)
                            checkList[0]['parent'].splice(i + j, 0, checkList[0].parent[i + j].parent[j]);
                        checkList[0].parent[i + NodeNumber]['parent'].splice(0, NodeNumber);
                    }
                    IsFind = true;
                    break;
                }
            }
        else
        {
            alert("不能移動 Root ！！");
            break;
        }
        
        // 刪除第一個
        checkList.splice(0, 1);
    }
    
    if(IsFind)
    {
        $(".MenuBox svg").empty();
        $NodeNumber = 0;
        TreeManager(sJsonData);
    }
}
function DeleteNode()
{
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        var n = clickNode.children()[1].textContent;
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length && !IsFind; i++)
            {
                if(n != checkList[0].parent[i].name)
                    checkList.push(checkList[0].parent[i]);
                else
                {
                    checkList[0]['parent'].splice(i, 1);
                    IsFind = true;
                    break;
                }
            }
        else
        {
            alert("不能刪除 Root ！！");
            break;
        }
        
        // 刪除第一個
        checkList.splice(0, 1);
    }
    
    if(IsFind)
    {
        $(".MenuBox svg").empty();
        $NodeNumber = 0;
        TreeManager(sJsonData);
    }
}