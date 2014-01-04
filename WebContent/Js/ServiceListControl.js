function urlencode( str ) {
    // http://kevin.vanzonneveld.net
    // +   original by: Philip Peterson
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +      input by: AJ
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: Brett Zamir
    // %          note: info on what encoding functions to use from: http://xkr.us/articles/javascript/encode-compare/
    // *     example 1: urlencode('Kevin van Zonneveld!');
    // *     returns 1: 'Kevin+van+Zonneveld%21'
    // *     example 2: urlencode('http://kevin.vanzonneveld.net/');
    // *     returns 2: 'http%3A%2F%2Fkevin.vanzonneveld.net%2F'
    // *     example 3: urlencode('http://www.google.nl/search?q=php.js&ie=utf-8&oe=utf-8&aq=t&rls=com.ubuntu:en-US:unofficial&client=firefox-a');
    // *     returns 3: 'http%3A%2F%2Fwww.google.nl%2Fsearch%3Fq%3Dphp.js%26ie%3Dutf-8%26oe%3Dutf-8%26aq%3Dt%26rls%3Dcom.ubuntu%3Aen-US%3Aunofficial%26client%3Dfirefox-a'

    var histogram = {}, tmp_arr = [];
    var ret = str.toString();

    var replacer = function(search, replace, str) {
        var tmp_arr = [];
        tmp_arr = str.split(search);
        return tmp_arr.join(replace);
    };

    // The histogram is identical to the one in urldecode.
    histogram["'"]   = '%27';
    histogram['(']   = '%28';
    histogram[')']   = '%29';
    histogram['*']   = '%2A';
    histogram['~']   = '%7E';
    histogram['!']   = '%21';
    histogram['%20'] = '+';

    // Begin with encodeURIComponent, which most resembles PHP's encoding functions
    ret = encodeURIComponent(ret);

    for (search in histogram) {
        replace = histogram[search];
        ret = replacer(search, replace, ret) // Custom replace. No regexing
    }

    // Uppercase for full PHP compatibility
    return ret.replace(/(\%([a-z0-9]{2}))/g, function(full, m1, m2) {
        return "%"+m2.toUpperCase();
    });

    return ret;
}
var ServiceListControl = {};

ServiceListControl.drag = false;
ServiceListControl.clickedX = 0;
ServiceListControl.clickedY = 0;
	
ServiceListControl = function () {	
	this.initialDiv = null;
	this.services 	= null;
	
	this.init = function (id) {
		this.id = id;
		this.initialDiv = document.getElementById(this.id);
		
		this.drawServices();	
		this.addListeners();
        progress_update();
    };
	
	this.drawServices = function () {		
		this.initialDiv.innerHTML = "";
        var myArray;
        var index = -1;
        var count = 0;
        myArray = new Array();
        for(var j=0;j<this.services.length; j++){
            if (this.services[j].Category){
                count = 0;
                index += 1;
            }else{                   
                myArray[index] = ++count;
            }
        }
        index = -1;
        count = 0;
        var cat_x = 0;
        var cat_y = 0;
        var first = 0;
        var second = 0;
        var x;
        var y;
        //this.initialDiv.innerHTML += '<div class="services">';        
        for (var i=0; i < this.services.length; i++) {
            if (this.services[i].Category && this.services[i].Category != "BREAK"){
				this.initialDiv.innerHTML += '<div style="-moz-user-select: none;" class="services_header" id="category_id" unselectable="on">' +
                                             '<img src="image?t=' + urlencode(this.services[i].Category) + '&fs=14&c=FF6800" />' + 
                                             '</div>';
//                index+=1;
//                cat_x=0;
//                cat_y = first*20+2;
//                first+=1;
//                second = first;
//                count = 0;
//                this.initialDiv.innerHTML += '' +
//                    '<div title="" id="category" style="display: block; position:absolute; top:'+cat_y+"px;"+' left:'+cat_x+"px;"+' -moz-user-select: none; width: 200px; height: 20px; cursor: default; border:1px solid #000; overflow: hidden; margin-top: 2px; color: #000; text-align: left;" unselectable="on">' +
//				        '<div id="category_id" style="padding-left: 8px; font: bold 11px Arial; color: #ffffff; background-color: #788084">' +
//                            '' + this.services[i].Category + '' +
//                        '</div>' +
//                    '</div>';
            }else if(this.services[i].Name && this.services[i].Name != 'break'){
                var nc = this.services[i].Name.split("$", 2);
                var dollar = '$';
                if(!nc[1]){
                    nc[1] = '';
                    dollar = '';
                }
                var fs = 12;
                if (nc[1].length >3){
                    fs = 10;
                }
                this.initialDiv.innerHTML +=
                                            '<div style="-moz-user-select: none;" unselectable="on" title="'+
                                             this.services[i].ToolTip+'" class="services_unit" id="service_id_' +
                                             this.services[i].Id + '">' +
//                                            '<div style="-moz-user-select: none; position: absolute; z-index:1" unselectable="on" class="name">' +
//                                             '<img src="image?t=' + urlencode(nc[0]) + '&fs=12&c=FFFFFF&w=50" />' +
//                                             '</div><div style="-moz-user-select: none;" unselectable="on" class="cost"><sup>' +
//                                             '<img src="image?t=' + urlencode(dollar) + '&fs=10&c=FFFFFF" />' +
//                                             '</sup>' +
//                                             '<img src="image?t=' + urlencode(nc[1]) + '&fs=12&c=FFFFFF" /></div>' +

//                                             '<div style="-moz-user-select: none; background: url(\'image?t=' + urlencode(nc[0]) + '&fs=12&c=FFFFFF&w=50\') no-repeat 4px 4px;" unselectable="on" class="name" id="content_service_id_'+
//                                             this.services[i].Id + '"><span style="visibility: hidden">' +  nc[0] + '</span></div>' +
//                                           '<div style="-moz-user-select: none; " unselectable="on" class="cost">' +
//                                            '<div style="float:right; background: url(\'image?t=' + urlencode(nc[1]) + '&fs='+fs+'&c=FFFFFF\') no-repeat 0px 4px; width: 25px">' +
//                                            '<span style="visibility: hidden">' + nc[1]+ '</span></div>'+
//                                            '<div style="float:right; background: url(\'image?t=' + urlencode(dollar) + '&fs=10&c=FFFFFF\') no-repeat 4px 0px; width: 10px"><span style="visibility:hidden">' +
//                                             dollar + '</span></div>' +
//                                                '</div></div>'

                                             '<div style="-moz-user-select: none; background: url(\'image?t=' + urlencode(nc[0]) + '&fs=12&c=FFFFFF&w=50\') no-repeat 4px 4px;" unselectable="on" class="name" id="content_service_id_'+
                                             this.services[i].Id + '"><span style="visibility: hidden">' +  nc[0] + '</span></div>' +
                                           '<div id="content_service_id_'+ this.services[i].Id + '" style="-moz-user-select: none; " unselectable="on" class="cost">' +
                                            '<div id="content_service_id_'+ this.services[i].Id + '" style="float:right; background: url(\'image?t=' + urlencode(nc[1]) + '&fs='+fs+'&c=FFFFFF\') no-repeat 0px 4px; width: 25px">' +
                                            '<span style="visibility: hidden">' + nc[1]+ '</span></div>'+
                                            '<div id="content_service_id_'+ this.services[i].Id + '" style="float:right; background: url(\'image?t=' + urlencode(dollar) + '&fs=10&c=FFFFFF\') no-repeat 4px 0px; width: 10px"><span style="visibility:hidden">' +
                                             dollar + '</span></div>' +
                                                '</div></div>'

                                            ;
//                if (count>=myArray[index]/2){
//                    x = 102;
//                    y = second*20;
//                    second+=1;
//                }else{
//                    x=0;
//                    y=first*20;
//                    first+=1;
//                }
//                this.initialDiv.innerHTML += '' +
//                    '<div title="'+this.services[i].ToolTip+'" id="service_id_' + this.services[i].Id + '" style="display: block; position:absolute; top:'+y+"px;"+' left:'+x+"px;"+' -moz-user-select: none; width: 100px; height: 20px; overflow: hidden; cursor: move; border:1px solid #000; margin-top: 2px; color: #000; text-align: left;" unselectable="on">' +  //overflow: hidden;
//				        '<div id="content_service_id_' 	+ this.services[i].Id + '" style="padding-left: 8px; font: 11px Arial; color: #000; border-left: 5px solid blue; line-height: 20px; background-color: #c8d0d4">' +
//                            '' + this.services[i].Name + '' +
//                        '</div>' +
//                    '</div>';
//                count+=1;
            }
        }
        //this.initialDiv.innerHTML += '</div>';
	};
	
	this.addListeners = function () {
		for (var i=0; i < this.services.length; i++) {
			var service = document.getElementById ("service_id_" + this.services[i].Id + "");
            //var type = document.getElementById ("service_id_" + this.services[i].Type + "");
            try{
			    if (service.addEventListener) {
    				service.addEventListener	("mousedown", this.handleEventMouseDown	, false);
    				document.addEventListener	("mouseup"	, this.handleEventMouseUp	, false);
    				document.addEventListener	("mousemove", this.handleEventMouseMove	, false);
    			} else {
    				service.onmousedown 	= this.handleEventMouseDown;
    				document.onmouseup 		= this.handleEventMouseUp;
    				document.onmousemove 	= this.handleEventMouseMove;
    			}
            }catch(e){}
		}
	}
	
	this.handleEventMouseDown = function (event) {
		DayPilotCalendar.dragFromOutside=true;
		
		document.body.style.cursor	= 'move';
		ServiceListControl.drag 	= true	;
		var serviceEvent = new ServiceEvent (event ? event : window.event);		
	}
	
	this.handleEventMouseUp = function (event) {		
		ServiceListControl.drag 	= false		;
		document.body.style.cursor	='default'	;
		
		//document.getElementById('ServiceControlClone').innerHTML = "";
		document.getElementById('ServiceControlClone').style.display = "none";				
	}
	
	this.handleEventMouseMove = function (event) {		
		var clonedElement 	= document.getElementById('cloned')	;
		var compatibleEvent = event ? event : window.event		;
					
		if (clonedElement && ServiceListControl.drag) {		
			var schedulerPosition 		= findPosition (document.getElementById('mainCalendar_main'));

			if ( compatibleEvent.clientY > schedulerPosition[1] && compatibleEvent.clientX > schedulerPosition[0] ) {
				//document.getElementById('ServiceControlClone').innerHTML = "";
				clonedElement.style.display = "none";				
			}
			
			clonedElement.style.top 	= compatibleEvent.clientY + ServiceListControl.clickedY + "px";
			clonedElement.style.left 	= compatibleEvent.clientX + ServiceListControl.clickedX + "px";													
		}
	}
};

function findPosition(obj) {
	
	var curleft = curtop = 0;
	if (obj.offsetParent) 
	{	
	    do {	    
		    curleft += obj.offsetLeft ;
		    curtop 	+= obj.offsetTop ;		
	    } while (obj = obj.offsetParent);	 
    }
//    alert("curleft = " + curleft + "curtop = " + curtop);
	return [curleft, curtop];
}

var ServiceEvent = {};

ServiceEvent = function (e) {	
	this.clonedDiv 				= document.getElementById('ServiceControlClone');

	var originalElement 		= e.srcElement ? e.srcElement: (e.target ? e.target : e.currentTarget);
	var originalPosition		= findPosition(originalElement);
			
	var serviceId 				= originalElement.id.replace("service_id_", "").replace("content_", "");
    var serviceName 			= document.getElementById("content_service_id_" + serviceId).innerHTML;

    ServiceListControl.clickedX = originalPosition[0] - e.clientX;
	ServiceListControl.clickedY = originalPosition[1] - e.clientY;	
	
	var clonedStyle 			= "" 				 +						
			"display: block;"						 + 
			"position:absolute;"					 + 
			"-moz-user-select: none;"				 + 
			"width: 200px;"							 +	 
			"height: 20px;"							 + 
			"cursor: move;"							 + 
			"border:1px solid #000;"				 + 
			"overflow: hidden;"						 +
			"margin-top: 2px;"						 +	 
			"color: #000;"							 +
			"text-align: left;"						 +					
			"z-index:1;" 				 	 		 +			
			"top:"  + originalPosition[1] + "px;" 	 +
			"left:" + originalPosition[0] + "px;" ;
			
	this.clonedDiv.innerHTML 	 = "" + 
		"<div id='cloned' style='" + clonedStyle + "'>" +			
			"<div id=\"cloned_content_id_service_"+serviceId+"\"" +" style='padding-left: 8px; font: 11px Arial; color: #000; border-left: 5px; solid: blue; line-height: 20px; background-color: #fff;'>"+serviceName+"</div>" +
                                    /*			"<div id=\"cloned_content_id_service_"+serviceId+"\" type ="+serviceType+" style='padding-left: 8px; font: 11px Arial; color #000; border-left: 5px solid blue; line-height: 20px; background-color: #fff;'>"+serviceName+"</div>" +*/
        "</div>";
	this.clonedDiv.style.display = "block";
}
