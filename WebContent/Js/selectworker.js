function select_setValue(selectID, value){
    var select = document.getElementById(selectID);
    var options = select.getElementsByTagName("option");
    for(i = 0; i < options.length; i++){
        if(options[i].value == value){
            options[i].selected = true;
            if(select.className.match(".*styled.*"))
            {
                var span = document.getElementById("select" + select.name);
                if(span && span.childNodes[0])
                {
                    try{
                        span.childNodes[0].nodeValue = options[i].childNodes[0].nodeValue;
                    }catch(e) {
                    }
                }
            }
            break;
        }
    }
}
