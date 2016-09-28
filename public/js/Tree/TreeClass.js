var NodeTree;
var radius = 200;        // 每一個之間，差 radius 的距離
$(function(){
    // 先拿 Json 檔，把所有的東西抓下來$.ajax({
    $.get( "/TreeJson", function(data) 
    {
        // 拿回來的東西轉一下
        data = data.split("&#39;").join("\"");
        
        // 將東西 pass 成 Json
        var JsonData = JSON.parse(data);
        NodeTree = TreeManager(JsonData);
    });
});

function TreeManager(JsonData)
{
    // 0 => 最深有幾個
    // 1 => 最寬有幾個
    // var TreeInfo = [1];
    
    // g 是最上層的，再往下一層要繞一個圓
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    $(g).attr("id", "TopLevel");
    $(g).attr("style", "transform: translate(" + $(document).width() / 2 + "px, " + $(document).height() / 2 + "px);");
    g.appendChild(TraceTree(JsonData.item, 1, 0, 360));
    $(".MenuBox svg").prepend(g);
    
    //console.log("TreeInfo " + TreeInfo[0] + " " + TreeInfo[1]);
};

// JsonNode 是資料
// TreeInfo 是樹的資料
// nowLevel 是現在是第幾個 level
// degree   幾度的
function TraceTree(JsonNode, nowLevel, MinDegree, MaxDegree)
{   
    // 判斷樹的 level
    //if(nowLevel > TreeInfo[1])
    //    TreeInfo = nowLevel;
    
    console.log(JsonNode.id + " " + JsonNode.name);
    var gTemp = makeSVG("circle", {cx: 0, cy: 0, r: 100, stroke: 'black', 'stroke-width': 2, fill: 'red'}, JsonNode.name, nowLevel, (MaxDegree - MinDegree) / 2 + MinDegree);
    
    // 去 Trace 他的小孩
    if(typeof JsonNode.parent != "undefined")
    {
        //if(JsonNode.parent)
        // 算出每一個間隔幾度
        var EachDegree = (MaxDegree - MinDegree) / JsonNode.parent.length;
        for(var i = 0; i < JsonNode.parent.length; i++)
            gTemp.appendChild(TraceTree(JsonNode.parent[i], nowLevel + 1, MinDegree + i * EachDegree, MinDegree + (i + 1) * EachDegree));
    }
    return gTemp;
};
