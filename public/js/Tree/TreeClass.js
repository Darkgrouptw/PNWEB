var radius = 150;        // 每一個之間，差 radius 的距離
var NodeNumber = -1;
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
};

// JsonNode 是資料
// TreeInfo 是樹的資料
// nowLevel 是現在是第幾個 level
// degree   幾度的
function TraceTree(JsonNode, nowLevel, MinDegree, MaxDegree)
{   
    // 如果顏色是空的，就塞一個顏色給他
    if(typeof JsonNode.color == "undefined")
        JsonNode.color = "#6495ED";
    
    // 創建一個 svg 的 block
    var gTemp = makeSVG("circle", {cx: 0, cy: 0, r: 100, stroke: 'black', 'stroke-width': 2, fill: JsonNode.color}, JsonNode.name, nowLevel, (MaxDegree - MinDegree) / 2 + MinDegree);
    
    // 去 Trace 他的小孩
    if(typeof JsonNode.parent != "undefined")
    {
        var EachDegree = (MaxDegree - MinDegree) / JsonNode.parent.length;
        
        // 為了要讓畫出來的舜去逝顛倒的，所以使用 insertBefore，插在前面
        for(var i = 0; i < JsonNode.parent.length; i++)
            gTemp.insertBefore(TraceTree(JsonNode.parent[i], nowLevel + 1, MinDegree + i * EachDegree, MinDegree + (i + 1) * EachDegree), gTemp.firstChild);
    }
    // 加上滑鼠移過去的事件
    $(gTemp).on("mouseenter", function(event){NodeMouse($(event.target));});

    NodeNumber++;
    return gTemp;
};

// 黨滑鼠移過去之後，全部的 Node 要散開
function NodeMouse(target)
{
    var target = target.parent();
    /*for(var i = 1; i < NodeNumber; i++)
        if(i != targetID)
        {
            $("#Node" + i).animate({
                "min-height": -150
            },
            {
                duration: 2000,
                step: function(node){
                   $(this).attr("style", "transfrom: translate(0px, 10px, 0px)");
                }
            });
            //$("#Node" + i).animate({
            //    "left": "-50px"
            //}, 1500);
        }*/
    console.log(target.attr("style"));
    //console.log(NodeNumber);
}