$(function(){

    // 給 Issuelist 的 change 事件
    $(window).ready(function()
    {
        scrollWin(getScroll());
        window.onscroll = function(){
            setScroll();
        }
    });
});
function scrollWin(y) {
    setTimeout(function(){
        window.scrollTo(window.scrollX,Number(y));
    },6);
    
}
function setScroll(){
    setTimeout(function () {
            localStorage.setItem("scrollY",window.scrollY);
        },6);

}
function getScroll(){
    return localStorage.getItem("scrollY");
}