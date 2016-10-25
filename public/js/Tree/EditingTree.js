var CircleScale = 0.8;
$(function(){
    // 變數宣告
    //$TreeArray = [];
    $NodeNumber = 0;                        // 判斷總共有幾個 Node
    $clickIndex = -1;                       // 判斷點擊的 Index
    
    $boolIsCreate = false;                  // 是否正屬於創建 Node 的時候
    $lastPosition = [];                     // 創建的最後一個 pos
        
    //$("#addNode").on("mousedown", function(event){
        /*var g = makeSimpleCircleSVG({cx: 0, cy: 0, r: circleRadius, stroke: 'black', 'stroke-width': 2, fill: 'red'}, $(".AddItemDiv input").prop("value"));
        
        $(g).attr("lerp_pos_x", event.pageX);
        $(g).attr("lerp_pos_y", event.pageY);
        $(g).attr("style", "transform: translate(" + event.pageX + "px, " + event.pageY + "px);");
        $(".MenuBox svg").prepend(g);*/
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
    
    /*
    加東西的 Div 事件
    */
    $(".AddItemDiv .glyphicon-remove").on("click", function(){
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
        $("#ListAddNode").show(100).css({
            top: event.pageY + "px",
            left: event.pageX + "px"
        });
        $lastPosition = [event.pageX, event.pageY];
    });
    // 按下按鍵，如果不在視窗裡面，要把選單消除
    $(".MenuBox svg").on("mousedown", function(event){
        // 如果按下的地方，不在選單裡面，就要關閉
        if (!$(event.target).parents(".custom-menu").length > 0 && event.button != 2)
            $(".custom-menu").hide(100);
    });
    $("#ListAddNode").on("click", function(event){
        switch($(event.target).attr("index"))
        {
            case "0":
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
    
    // 滑鼠點擊事件
    $(g).mousedown(function(event){
        $clickIndex = parseInt($(this).attr("id").replace("Node", ""));
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

// 在 click 的時候，設定 offset 的 function
/*function NodeClick()
{
    $offset[$clickIndex][0] = event.pageX - $lastPosition[$clickIndex][0];
    $offset[$clickIndex][1] = event.pageY - $lastPosition[$clickIndex][1];
};*/
// 滑鼠移動事件
function NodeMove(event)
{
    var target = $("#Node" + $clickIndex);
    $lastPosition[$clickIndex][0] = event.pageX - $offset[$clickIndex][0];
    $lastPosition[$clickIndex][1] = event.pageY - $offset[$clickIndex][1];
    
    target.attr("style", "transform: translate(" + (event.pageX - $offset[$clickIndex][0]) + "px, " + (event.pageY - $offset[$clickIndex][1]) + "px);");
};