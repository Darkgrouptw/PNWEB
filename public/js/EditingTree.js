$(function(){
    $NodeNumber = 0;
    $lastPosition = [];
    $offset = [];
    $("#addNode").click(function(){
        $(".MenuBox svg").append(makeSVG("circle", {cx: 0, cy: 0, r: 100, stroke: 'black', 'stroke-width': 2, fill: 'red'}, $(".AddItemDiv input").prop("value")));
    });
});

/*
因為 SVG 並非 html(namespace不同)，所以無法直接 append 上去，只能用這個方法貼上去
*/
function makeSVG(tag, attrs, text) 
{
    var g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    var el = document.createElementNS('http://www.w3.org/2000/svg', tag);
    var tarea = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    g.appendChild(el);
    g.appendChild(tarea);
    
    for (var k in attrs)
        el.setAttribute(k, attrs[k]);
    $(g).attr("id", "Node" + $NodeNumber++);
    $(g).attr("style", "transform: translate3d(" + $(document).width() / 2 + "px, " + $(document).height() / 2 + "px, 0px);");
    
    $lastPosition.push([$(document).width() / 2, $(document).height() / 2]);
    $offset.push([0, 0]);
    
    // 滑鼠點擊事件
    $(g).mousedown(function(event){
        NodeClick($(this));
    });
    
    // 滑鼠移動事件
    $(g).mousemove(function(event){
        NodeMove($(this), event);
    });
    
    // 滑鼠放開事件
    $(g).mouseup(function(event){
        //console.log("Mouse Up" + event.pageX + " " + event.pageY);
        NodeOut($(this));
    });
    
    //滑鼠超過事件
    $(g).mouseout(function(event){
        //console.log("Mouse Out" + event.pageX + " " + event.pageY + " " + $offset);
        NodeMove($(this), event);
        //$out = true;
    });
    
    
    // 新增文字的事件
    tarea.setAttribute("style", " font-size:24px;");
    tarea.textContent = text;
    console.log(text);
    return g;
};


function NodeClick(target)
{
    var id = parseInt(target.attr("id").replace("Node", ""));
    $offset[id][0] = event.pageX - $lastPosition[id][0];
    $offset[id][1] = event.pageY - $lastPosition[id][1];
    //console.log("ID = " + id + " Mouse Down" + event.pageX + " " + event.pageY + " " + $offset[id]);
    target.attr("IsClick", true);
};
function NodeMove(target, event)
{
    if(target.attr("IsClick"))
    {
        var id = parseInt(target.attr("id").replace("Node", ""));
        $lastPosition[id][0] = event.pageX - $offset[id][0];
        $lastPosition[id][1] = event.pageY - $offset[id][1];
        
        target.attr("style", "transform:translate3d(" + (event.pageX - $offset[id][0]) + "px, " + (event.pageY - $offset[id][1]) + "px, 0px);");
    }
};
function NodeOut(target)
{
    target.removeAttr("IsClick");
};