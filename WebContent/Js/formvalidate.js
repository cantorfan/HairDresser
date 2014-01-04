function formvalidate(form){
    try{
        var valid = true;
        for (var i = 0; i < form.elements.length; i++){
            var elem = form.elements[i];
            var v = elem.attributes["valid"];
            if (v != null){
                switch (v.value){
                    case "text":{
                        if (elem.value.replace(/ /g,"") == ""){
                            elem.style.border = "2px solid #FF0000";
                            valid = false;
                        }else elem.style.border = "";
                        break;
                    }
                    case "money":{
                        if ((elem.value.search(/^\d+$/) == -1) && (elem.value.search(/^\d+\.\d{1,2}$/) == -1)){
                            elem.style.border = "2px solid #FF0000";
                            valid = false;
                        }else elem.style.border = "";
                        break;
                    }
                    case "taxe":{
                        if ((elem.value.search(/^\d+$/) == -1) && (elem.value.search(/^\d+\.\d{1,2}$/) == -1)){
                            elem.style.border = "2px solid #FF0000";
                            valid = false;
                        }else elem.style.border = "";
                        break;
                    }
                    case "digits":{
                        if (elem.value.search(/^\d+$/) == -1){
                            elem.style.border = "2px solid #FF0000";
                            valid = false;
                        }else elem.style.border = "";
                        break;
                    }
                    case "select":{
                        if (elem.value.replace(/ /g,"") == ""){
                            elem.style.border = "2px solid #FF0000";
                            valid = false;
                        }else elem.style.border = "";
                        break;
                    }
//                    case "phone":{
//                        if (elem.value.search(/^\d+\(|\-\d+\)|\-\d+$/) == -1){
//                            elem.style.border = "2px solid #FF0000";
//                            valid = false;
//                        }else elem.style.border = "";
//                        break;
//                    }
                }
            }
        }
        if (!valid){
            document.getElementById("error_message").style.display = "block";
            return false;
        } else{
            return true;
        }
    }
    catch(ex) {
        alert(ex);
        return false;
    }
}