// 半徑設定
var radius = 200;       // 每一個之間，差 radius 的距離
var max_radius = 250;   // 滑鼠移過去的時候，最大的半徑
var circleRadius = 120; // 球的半徑

var NodeNumber = -1;

// 時間設定
var MoveTimer = null;   // 移動的 Timer
var CountTime = 0;      // 計算Timer N 次
var EachCount = 10;     // EachCount 是每個多少時間 要執行 Timer
var MaxMoveCount = 500; // 最大要算幾次 =>  EachCount * MaxMoveCount 是執行的時間
var MaxMoveDis = 100;   // 最大的移動的距離
var TargetID = -1;      // 滑鼠移動時，目標的 ID
var lerpRate = 0.1;

$(function(){
    // 先拿 Json 檔，把所有的東西抓下來$.ajax({
    $.get( "/TreeJson", function(data) 
    {
        // 拿回來的東西轉一下
        data = data.split("&#39;").join("\"");
        
        // 將東西 pass 成 Json
        var JsonData = JSON.parse(data);
        TreeManager(JsonData);
    });
});
function TreeManager(JsonData)
{   
    // 增加 TopLevel，移動頁面的時候，可以只改變這一層
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    $(g).attr("id", "TopLevel");
    $(g).attr("style", "transform: translate(" + $(document).width() / 2 + "px, " + $(document).height() / 2 + "px);");
    $(".MenuBox svg").append(g);
    
    // 增加所有的 Node & Line
    TraceTree(JsonData.item, 0, 0, 0, 0, 360, -1);
    GenerateLine();
};

// JsonNode     是資料
// posX, posY   前面的 Position，要從這個 Position 開始向外長
// nowLevel     是現在是第幾個 level，超過 7 層就不要 Scale
// degree       幾度的
function TraceTree(JsonNode, posX, posY, nowLevel, MinDegree, MaxDegree, parentID)
{   
    // 如果顏色是空的，就塞一個顏色給他
    if(typeof JsonNode.color == "undefined")
        JsonNode.color = "#6495ED";
    
    // 創建一個 svg 的 block
    var pos = [posX, posY];
    var g = makeCircleSVG({cx: 0, cy: 0, r: circleRadius, stroke: 'black', 'stroke-width': 2, fill: JsonNode.color}, JsonNode.name, nowLevel, (MaxDegree - MinDegree) / 2 + MinDegree, pos, parentID);
    if($NodeNumber == 1)
        $("#TopLevel").append(g);
    else
        $(g).insertBefore($("#Node" + ($NodeNumber - 2)));
    
    // 去 Trace 他的小孩
    if(typeof JsonNode.parent != "undefined")
    {
        var EachDegree = (MaxDegree - MinDegree) / JsonNode.parent.length;
        for(var i = 0; i < JsonNode.parent.length; i++)
            TraceTree(JsonNode.parent[i], pos[0], pos[1], nowLevel + 1, MinDegree + i * EachDegree, MinDegree + (i + 1) * EachDegree, $(g).attr("id"));
    }
    
    // 加上滑鼠移過去的事件
    $(g).on("mouseenter", function(event){ NodeMouseEnter( $(event.target)); });
    $(g).on("mouseleave", function(event){ NodeMouseOut( $(event.target)); });
};

function GenerateLine()
{
    for(var i = $NodeNumber - 1; i >= 1; i--)
    {
        var NowNode = $("#Node" + i);
        var NowPos = [NowNode.attr("lerp_pos_x"), NowNode.attr("lerp_pos_y")];
        var ParentNode = $("#" + NowNode.attr("parent"));
        var ParentPos = [ParentNode.attr("lerp_pos_x"), ParentNode.attr("lerp_pos_y")];
        var line = makeLineSVG({x1: NowPos[0], y1: NowPos[1], x2: ParentPos[0], y2: ParentPos[1], stroke: 'black', 'stroke-width': 3}, NowNode.attr("id"), ParentNode.attr("id"));
        $(line).insertBefore($("#TopLevel").children().eq(0));
    }
}

// 當滑鼠移過去之後，全部的 Node 要散開
function NodeMouseEnter(target)
{
    var target = target.parent();
    // 只保留數字的部分
    TargetID = parseInt(target.attr("id").replace("Node", ""));
    
    if(MoveTimer != null)
        clearInterval(MoveTimer);
    
    // 清除 Timer status 
    CountTime = 0;
    MoveTimer = setInterval(moveToPos, EachCount);
}
function NodeMouseOut(target)
{   
    var target = target.parent();
    // 只保留數字的部分
    TargetID = parseInt(target.attr("id").replace("Node", ""));
    
    if(MoveTimer != null)
        clearInterval(MoveTimer);
    
    // 清除 Timer status 
    CountTime = 0;
    MoveTimer = setInterval(moveToOrgPos, EachCount);
}

// 將附近的點移到相對的位置
function moveToPos()
{
    if(CountTime > MaxMoveCount)
    {
        clearInterval(MoveTimer);
        MoveTimer = null;
    }
    else
    {
        for(var i = 0; i < $NodeNumber; i++)
        {
            if(i != TargetID)
            {
                var node = $("#Node" + i);
                
                // 拿取點的資訊
                var SourceNode = $("#Node" + i);                                                // 要移動的點
                var SourcePos = [parseInt(SourceNode.attr("org_pos_x")), parseInt(SourceNode.attr("org_pos_y"))];
                var TargetNode = $("#Node" + TargetID);                                         // 滑鼠目前移動到的點
                var TargetPos = [parseInt(TargetNode.attr("org_pos_x")), parseInt(TargetNode.attr("org_pos_y"))];
                var LerpPos = [parseInt(SourceNode.attr("lerp_pos_x")), parseInt(SourceNode.attr("lerp_pos_y"))];
                
                var FinalPos = CountMovePos(SourcePos, CountAngleByID(SourcePos, TargetPos), LerpPos);
                node.attr("style", "transform: translate(" + FinalPos[0] + "px, " + FinalPos[1] + "px) scale(" + node.attr("OrgScale") + ");");
                node.attr("lerp_pos_x", FinalPos[0]);
                node.attr("lerp_pos_y", FinalPos[1]);
            }
            else
            {
                // 要返回原點
                var node = $("#Node" + i);                                                // 要移動的點
                var SourcePos = [parseInt(node.attr("org_pos_x")), parseInt(node.attr("org_pos_y"))];
                var LerpPos = [parseInt(node.attr("lerp_pos_x")), parseInt(node.attr("lerp_pos_y"))];

                var FinalPos = [lerpFunction(LerpPos[0], SourcePos[0], lerpRate), lerpFunction(LerpPos[1], SourcePos[1], lerpRate)];

                node.attr("style", "transform: translate(" + FinalPos[0] + "px, " + FinalPos[1] + "px) scale(" + node.attr("OrgScale") + ");");
                node.attr("lerp_pos_x", FinalPos[0]);
                node.attr("lerp_pos_y", FinalPos[1]);
            }
        }
        CountTime += EachCount;
    }
    modifyLinePos();
}

// 將所有的點移至原本的位置
function moveToOrgPos()
{
    if(CountTime > MaxMoveCount)
    {
        clearInterval(MoveTimer);
        MoveTimer = null;
    }
    else
    {
        for(var i = 0; i < $NodeNumber; i++)
        {
            // 拿取點的資訊
            var node = $("#Node" + i);                                                // 要移動的點
            var SourcePos = [parseInt(node.attr("org_pos_x")), parseInt(node.attr("org_pos_y"))];
            var LerpPos = [parseInt(node.attr("lerp_pos_x")), parseInt(node.attr("lerp_pos_y"))];
           
            var FinalPos = [lerpFunction(LerpPos[0], SourcePos[0], lerpRate), lerpFunction(LerpPos[1], SourcePos[1], lerpRate)];
            
            node.attr("style", "transform: translate(" + FinalPos[0] + "px, " + FinalPos[1] + "px) scale(" + node.attr("OrgScale") + ");");
            node.attr("lerp_pos_x", FinalPos[0]);
            node.attr("lerp_pos_y", FinalPos[1]);
        }
        CountTime += EachCount;
    }
    modifyLinePos();
}

function modifyLinePos()
{
    for(var i = $NodeNumber - 1; i >= 1; i--)
    {
        var NowNode = $("#Node" + i);
        var NowPos = [NowNode.attr("lerp_pos_x"), NowNode.attr("lerp_pos_y")];
        var ParentNode = $("#" + NowNode.attr("parent"));
        var ParentPos = [ParentNode.attr("lerp_pos_x"), ParentNode.attr("lerp_pos_y")];
        
        var Line = $("#LineNode" + i + "To" + NowNode.attr("parent"));
        $(Line).attr("x1", NowPos[0]);
        $(Line).attr("y1", NowPos[1]);
        $(Line).attr("x2", ParentPos[0]);
        $(Line).attr("y2", ParentPos[1]);
    }
}

// 計算應該要為儀多少角度
function CountAngleByID(SourcePos, TargetPos)
{
    // 從 3 點中開始事 0 度到 360 度
    var rx = SourcePos[0] - TargetPos[0];
    var ry = SourcePos[1] - TargetPos[1];
    return Math.atan2(ry, rx) * 180 / Math.PI;
}

// 從 Pos 經過 angle 算最大能移動的距離，然後 lerp 到那個點
function CountMovePos(Pos, angle, LerpPos)
{
    var FinalX = MaxMoveDis * Math.cos(angle / 180 * Math.PI) + Pos[0];
    var FinalY = MaxMoveDis * Math.sin(angle / 180 * Math.PI) + Pos[1];
    return [lerpFunction(LerpPos[0], FinalX, lerpRate), lerpFunction(LerpPos[1], FinalY, lerpRate)];
}

// Lerp Function
function lerpFunction(Start, End, time)
{
    // time => 0 ~ 1
    return (1 - time) * Start + time * End;
}