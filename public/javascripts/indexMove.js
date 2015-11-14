
$(function()
{
	var first = false;
	var index = 0;					//0是開始
    var imagebox=$(".showbox").children('.imagebox')[0],//拿圖片的第一個
		imagenum=$(imagebox).children().size(),//拿圖片容器的數量
		imageboxWidth=$(imagebox).width(),//拿圖片容器的寬度
		imagewidth=imageboxWidth*imagenum;//拿圖片容器的總大小
        $(imagebox).css({'width' : imagewidth + "px"});
			setInterval(function()
			{
				if(first)
					$('.imagebox').append($('.imagebox img').first());
				$('.imagebox img').last().css({'width' :  imageboxWidth + "px"});
                $('.imagebox img').first().animate({'width':'0px'},1000);
				first = true;

                for(var i = 0 ; i < $(".iconbox span").size() ; i++)
                	$(".iconbox span").eq(i).removeClass("active");

                index = (index +1) % 4;
                $('.iconbox span').eq(index).attr("class","active");
			},3000);


	$(".iconbox span").click(function(){
		first = false;
		index = parseInt($(this).attr("rel"));

        for(var i = 0 ; i < $(".iconbox span").size() ; i++)
        {
          	$(".iconbox span").eq(i).removeClass("active");
			$('.imagebox img').eq(i).css({'width' :  imageboxWidth + "px"});
        }
        $('.iconbox span').eq(index).attr("class","active");

        for(var i = 0 ; i < $(".imagebox img").size() ; i++)
        {
        	if((index + 1) == $(".imagebox img").first().attr("alt"))
        		break;
			$('.imagebox').append($('.imagebox img').first());
        }
	});
});
