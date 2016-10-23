$(function(){
    // 變數宣告
    //$TreeArray = [];
    $NodeNumber = 0;                        // 判斷總共有幾個 Node
    $clickIndex = -1;                       // 判斷點擊的 Index
    
    $lastPosition = [];
    $offset = [];
    
    //$("#addNode").click(function(){
    //    $(".MenuBox svg").prepend(makeSVG("circle", {cx: 0, cy: 0, r: 100, stroke: 'black', 'stroke-width': 2, fill: 'red'}, $(".AddItemDiv input").prop("value")));
    //});
    
    
    // 滑鼠按下去的時候，假設有點到東西，就可以對整個做移動的功能
    //$(".MenuBox svg").mousemove(function(event){
    //    if($clickIndex != -1)
    //        NodeMove(event);
    //    console.log($clickIndex & $NowFocus); 
    //});
    // 滑鼠放掉的時候，要把 clickIndex 還原成 -1
    //$(".MenuBox svg").mouseup(function(){
    //    $clickIndex = -1;
    //});
    
    // 取消右鍵選單
    //$(".MenuBox").on("contextmenu", function(){
    //    return false;
    //});
});

/*
因為 SVG 並非 html(namespace不同)，所以無法直接 append 上去，只能用這個方法貼上去
*/
function makeSVG(tag, attrs, text, nowLevel, Degree) 
{
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    var el = document.createElementNS('http://www.w3.org/2000/svg', tag);
    var tarea = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    g.appendChild(el);
    g.appendChild(tarea);
    
    for (var k in attrs)
        el.setAttribute(k, attrs[k]);
    $(g).attr("id", "Node" + $NodeNumber++);
    
    // 超過一定範圍，就不縮小了
    var posX = radius * Math.cos(Degree / 180 * Math.PI);
    var posY = radius * Math.sin(Degree  / 180 * Math.PI);
    if(nowLevel >= 7)
        $(g).attr("style", "transform: translate(" + posX + "px, " + posY + "px);");
    else if(nowLevel != 1)
    {
        $(g).attr("style", "transform: translate(" + posX + "px, " + posY + "px) scale(0.8);");
        $(g).attr("OrgScale", "0.8");
    }
    
    $(g).attr("org_pos_X", posX);
    $(g).attr("org_pos_y", posX);
    
    $lastPosition.push([$(document).width() / 2, $(document).height() / 2]);
    $offset.push([0, 0]);
    
    // 滑鼠點擊事件
    $(g).mousedown(function(event){
        $clickIndex = parseInt($(this).attr("id").replace("Node", ""));
        
        // 要跑去裡面設定 offset 多少
        NodeClick();
    });
    
    // 新增文字
    tarea.setAttribute("style", " font-size:24px;");
    tarea.textContent = text;
    console.log(text);
    return g;
};

// 在 click 的時候，設定 offset 的 function
function NodeClick()
{
    $offset[$clickIndex][0] = event.pageX - $lastPosition[$clickIndex][0];
    $offset[$clickIndex][1] = event.pageY - $lastPosition[$clickIndex][1];
};
// 滑鼠移動事件
function NodeMove(event)
{
    var target = $("#Node" + $clickIndex);
    $lastPosition[$clickIndex][0] = event.pageX - $offset[$clickIndex][0];
    $lastPosition[$clickIndex][1] = event.pageY - $offset[$clickIndex][1];
    
    target.attr("style", "transform: translate(" + (event.pageX - $offset[$clickIndex][0]) + "px, " + (event.pageY - $offset[$clickIndex][1]) + "px);");
};