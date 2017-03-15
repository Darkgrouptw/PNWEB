$(document).ready(function(){
    if(document.getElementById("if_first_time_come_to_NPWEB")){
        if (!checkCookie()){
            document.getElementById("if_first_time_come_to_NPWEB").style.display = "";
        }else{
            document.getElementById("if_first_time_come_to_NPWEB").style.display = "none";
        }
    }
    $(".fak_glyphicon").click(function(){
        removeButton = $(".glyphicon-remove")
        removeButton.click();
    });
});

function setCookie(cname,cvalue) {
    document.cookie = cname + "=" + cvalue + ";";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

function checkCookie() {
    var val=getCookie("if_first_time_come_to_NPWEB");
    if (val == "yes") {
        return true;    
    } else {
       setCookie("if_first_time_come_to_NPWEB","yes")
       return false;
    }
    
}