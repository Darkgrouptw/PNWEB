var CircleScale = 0.8;
var splitLineWordCount = 8;                     // 要分段字的字數
var Colur = ["#88D365", "#F72758", "#6495ED", "#FFD905", "#2E3192", "#ECA400", "#6FB722", "#FF9900", "#2364AA", "#3DA5D9", "#73BFB8", "#00B6CC", "#99CC33", "#210F04", "#69140E", "#F19143", "#C84C09", "#A44200"];
$(function(){
    // 變數宣告
    $NodeNumber = 0;                        // 判斷總共有幾個 Node
    $clickID = "";                          // 判斷點擊的 Index
    $chooseIndex = "";                      // Chooose 的選項
    
    /*
    切換顯示的樹形式
    */
    $("#switch").on("click",function(){
        if($("#new_type").css("display") == "block"){
            $("#new_type").css("display","none")
            $("#old_type").css("display","block")
        }else{
            $("#new_type").css("display","block")
            $("#old_type").css("display","none")
        }
        console.log($("#new_type").css("display"))
        console.log($("#old_type").css("display"))
    });
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
                //MoveToParent();
                MoveClockWise();
                $(this).hide(100);
                break;
            case "3":
                MoveCounterClockWise();
                $(this).hide(100);
                break;
            case "4":
                DeleteNode();
                $(this).hide(100);
                break;
        }
    });
    
    $("#ReminderSaving").on("click", function(){
       saveAllNode();
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
            // 要去 trace 說是否真的有，個東西
            $.get("/IssueID", { title: NodeName }).done(
                function(data)
                {
                    // 刪除前面的空白 & 後面的換行
                    data = data.substr(4, data.length);
                    data = data.substr(0, data.length - 1);
                    
                    if(data == "")
                    {
                        alert("沒有這個議題 !!");
                        return;
                    }
                    
                    // 要去 Trace 說目前的樹有沒有這個東西
                    if(IsAppearedBefore(NodeName))
                    {
                        alert("這個 Node 已經被加過囉！！");
                        return;
                    }
                    
                    // 代表 data 有東西，並繼續執行
                    switch($chooseIndex)
                    {
                        case 0:
                            AddNodeToChild(NodeName, data);
                            break;
                    
                        case 1:
                            AddNodeInSameLevel(NodeName, data);
                            break;
                    }
                    
                    // 動畫
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
            );
        }
    });
    $(".custom-menu li").on("contextmenu", function(event){
       event.preventDefault(); 
    });
});

/*
因為 SVG 並非 html(namespace不同)，所以無法直接 append 上去，只能用這個方法貼上去
*/
function makeCircleSVG(attrs, text, id, nowLevel, Degree, pos, parentID) 
{
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    var el = document.createElementNS('http://www.w3.org/2000/svg', "circle");
    var tarea = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    var tareaLink =  document.createElementNS('http://www.w3.org/2000/svg', 'a');
    
    tareaLink.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', "Issuelist/" + id);
    tareaLink.setAttribute("target", "_blank");
    
    tareaLink.appendChild(tarea);
    
    g.appendChild(el);
    g.appendChild(tareaLink);
    
    for (var k in attrs)
        el.setAttribute(k, attrs[k]);
    
    // 判斷他是否是現在要加進去的
    $(g).attr("id", "Node" + $NodeNumber);
    
    $(tarea).attr("class", "textArea");
    
    // 超過一定範圍，就不縮小了
    var scale = 1;
    if(nowLevel >= 4)
        scale = Math.pow(0.8, 4);
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
        
        var clickItem = $(event.target.parentNode);
        
        // 確保拿到的是 g 才能拿到 id，拿到其他的要做處理
        if(clickItem.prop("nodeName") == 'a')
            clickItem = clickItem.parent();
        else if(clickItem.prop("nodeName") == 'text')
            clickItem = clickItem.parent().parent();
        
        $clickID = clickItem.attr("id");
        
        $("#ListAddNode").show(100).css({
            top: event.pageY + "px",
            left: event.pageX + "px"
        });
    });
    
    // 新增文字
    tarea.setAttribute("fill", "white");
    tarea.setAttribute("style", "font-size:24px; transform: translate(-100px, -50px);");
    tarea.setAttribute("full-text", text);                                                       // 把文字加進去
    
    // 總共要幾條來顯示
    var SplitCount = Math.ceil(text.length / splitLineWordCount);
    for(var i = 0; i < SplitCount; i++)
    {
        // 這行有幾格
        var blankLength = (((i+1) * splitLineWordCount > text.length) ? text.length - i * splitLineWordCount : splitLineWordCount);
        
        // 這行的文字是什麼
        var lineText = text.substr(i * splitLineWordCount, blankLength);
        
        // 如果字沒有滿，要置中
        var xAppend = 0;
        if(blankLength < splitLineWordCount)
            xAppend = (splitLineWordCount - blankLength) * 15;
        
        // 產生 tSpan
        var tspan = makeTSpanSVG(xAppend + "px", '1.2em', lineText);
        
        
        // 把它加進 tarea 裡
        tarea.appendChild(tspan);
            
        if(i == 2)
        {
            // 判斷還有沒有殘留的字
            if(SplitCount > 3)
                tarea.appendChild(makeTSpanSVG('80px', '1.2em', '......'));
            break;
        }
    }
    
    return g;
};
function makeTSpanSVG(x, dy, text)
{
    var tspan = document.createElementNS('http://www.w3.org/2000/svg', 'tspan');
    tspan.setAttribute('x', x);
    tspan.setAttribute('dy', dy);
    tspan.textContent = text.substr(text);
    return tspan;
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
*********************
裡面所有的 parent 都是 child
名字取的不好抱歉
ＸＤ
*********************
*/
function AddNodeToChild(NodeName, nodeID)
{
    $(".ReminderSave").show();
    
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    
    // 要搜尋的名稱
    var Node = $(clickNode.children()[1]).children()[0];
    var n = $(Node).attr("full-text");
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length; i++)
                checkList.push(checkList[0].parent[i]);
        else
        {
            checkList[0]['parent'].push({'id': nodeID, 'name':NodeName, 'color': RandomColor(), 'parent':[]});
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
function AddNodeInSameLevel(NodeName, nodeID)
{
    $(".ReminderSave").show();
    
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    
    // 要搜尋的名稱
    var Node = $(clickNode.children()[1]).children()[0];
    var n = $(Node).attr("full-text");
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length; i++)
            {
                if(n != checkList[0].parent[i].name)
                    checkList.push(checkList[0].parent[i]);
                else
                {
                    checkList[0]['parent'].push({'name':NodeName, 'color': RandomColor(), 'parent':[]});
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
function MoveClockWise()
{
    $(".ReminderSave").show();
    
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    
    // 要搜尋的名稱
    var Node = $(clickNode.children()[1]).children()[0];
    var n = $(Node).attr("full-text");
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length; i++)
            {
                if(n != checkList[0].parent[i].name)
                    checkList.push(checkList[0].parent[i]);
                else
                {
                    // 拿出下一個的 index
                    if(i + 1 >= checkList[0].parent.length)
                        previousIndex = i + 1 - checkList[0].parent.length; 
                    else
                        previousIndex = i + 1;
                    
                    // 掉換位置
                    var tempN = checkList[0]['parent'][i];
                    
                    checkList[0]['parent'][i] = checkList[0]['parent'][previousIndex];
                    checkList[0]['parent'][previousIndex] = tempN;
                                                                
                    IsFind = true;
                    break;
                }
            }
        else
        {
            alert("Root 無法順時鐘移動喔！！");
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
function MoveCounterClockWise()
{
    $(".ReminderSave").show();
    
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    
    // 要搜尋的名稱
    var Node = $(clickNode.children()[1]).children()[0];
    var n = $(Node).attr("full-text");
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
        if(n != checkList[0].name)
            for(var i = 0; i < checkList[0].parent.length; i++)
            {
                if(n != checkList[0].parent[i].name)
                    checkList.push(checkList[0].parent[i]);
                else
                {
                    // 拿出上一個的 index
                    if(i - 1 < 0)
                        previousIndex = i + checkList[0].parent.length - 1; 
                    else
                        previousIndex = i - 1;
                    
                    // 掉換位置
                    var tempN = checkList[0]['parent'][i];
                    
                    checkList[0]['parent'][i] = checkList[0]['parent'][previousIndex];
                    checkList[0]['parent'][previousIndex] = tempN;
                                                                
                    IsFind = true;
                    break;
                }
            }
        else
        {
            alert("Root 無法順時鐘移動喔！！");
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
    $(".ReminderSave").show();
    
    var checkList = [sJsonData.item];
    var clickNode = $("#" + $clickID);
    var IsFind = false;
    
    var Node = clickNode.children()[1].children[0];
    var n = $(Node).attr("full-text");
    
    while(!IsFind)
    {
        if(checkList.length == 0)
        {
            console.log("Bug");
            break;
        }
        
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
function saveAllNode()
{
    $(".ReminderSave").hide();
    $.post("TreeSaveAllNode", {"id": getUrlParameter("id"), "TreeInfo": JSON.stringify(sJsonData)}).done(function(data){
        window.top.location.reload();
    });
}

function IsAppearedBefore(NodeName)
{
    for(var i = 0; i < $NodeNumber; i++)
    {
        var GetLink = $("#Node" + i).children()[1];
        var Node = $(GetLink).children()[0];
        var name = $(Node).attr("full-text");
        if(NodeName == name)
            return true
    }
    return false;
}
function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};