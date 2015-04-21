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

var __colors;

var DayPilotCalendar = {};

DayPilotCalendar.selectedCells = null;
DayPilotCalendar.topSelectedCell = null;
DayPilotCalendar.bottomSelectedCell = null;
DayPilotCalendar.selecting = false;
DayPilotCalendar.column = null;
DayPilotCalendar.firstSelected = null;
DayPilotCalendar.firstMousePos = null;
DayPilotCalendar.originalMouse = null;
DayPilotCalendar.originalHeight = null;
DayPilotCalendar.originalTop = null;
DayPilotCalendar.resizing = null;
DayPilotCalendar.globalHandlers = false;
DayPilotCalendar.moving = null;
DayPilotCalendar.originalLeft = null;
DayPilotCalendar.editing = false;
DayPilotCalendar.originalText = null;
DayPilotCalendar.scrollWidth = null;
DayPilotCalendar.debug = null;
DayPilotCalendar.cellHeight = 22;

DayPilotCalendar.dragFromOutside = false;
DayPilotCalendar.dragFromOutsideStart = null;
DayPilotCalendar.dragFromOutsideEnd = null;
DayPilotCalendar.dragFromOutsideColumn = null;
DayPilotCalendar.dragUnderEnd = false;
DayPilotCalendar._this = null;

function setWindowCenter(obj)
{
    if(document.body.parentNode.scrollTop){
        obj.style.left = (document.body.parentNode.clientWidth)/2 + document.body.parentNode.scrollLeft + "px";//"50%";
        obj.style.top = (document.body.parentNode.clientHeight)/2 + document.body.parentNode.scrollTop + "px";//"50%";
    }else{
        obj.style.left = (document.body.parentNode.clientWidth)/2 + document.body.scrollLeft + "px";//"50%";
        obj.style.top = (document.body.parentNode.clientHeight)/2 + document.body.scrollTop + "px";//"50%";
    }
    var x = obj.clientWidth/2;
    obj.style.marginLeft = "-"+x+"px";
    var y = obj.clientHeight/2;
    obj.style.marginTop = "-"+y+"px";
}

function drawTimeColumns(){
    var html = "";
    var _i = _from;
    if(Math.floor(_i) < _i) // 10 or 10.5 :)
        html += "<div class=time_row_first><img alt=\""+_i+"\" src=\"img/time_column/"+_i+".png\" /></div>";
    else
        html += "<div class=time_row_first><img alt=\""+Math.floor(_i)+"\" src=\"img/time_column/"+Math.floor(_i)+".png\" /></div>";
    for(i = _from + 0.5; i < _to; i += 0.5){  // for esalonsoft/vogue
        if(Math.floor(i) < i) // 10 or 10.5 :)
            html += "<div class=time_row><img alt=\""+(i)+"\" src=\"img/time_column/"+(i)+".png\" /></div>";
        else
            html += "<div class=time_row><img alt=\""+Math.floor(i)+"\" src=\"img/time_column/"+Math.floor(i)+".png\" /></div>";
    }
    document.getElementById("time_column_left").innerHTML = html;
    document.getElementById("time_column_right").innerHTML = html;
}

DayPilotCalendar.saveAppointment = function (start, end, column, event) {
	
    if (DayPilotCalendar.dragFromOutsideStart && DayPilotCalendar.dragFromOutsideEnd && DayPilotCalendar.dragFromOutsideColumn) {
    	var idEmployee = DayPilotCalendar.dragFromOutsideColumn;
    	
    	DayPilotCalendar.dragFromOutsideColumn = null;  //stop spare event 

    	var idCustomer = document.getElementById("cust_id").value;
        var idLocation = document.getElementById("locationId").value;
        var currentDate = new Date(document.getElementById("mainCalendar_datecurrent").value);
        var pageNum = document.getElementById("mainCalendar_pagenum").value;
        var comment = document.getElementById("comment").value.replace(/\"/g," ");
        var req =  document.getElementById('txtReq').checked;
//        alert(req);
        var start = new Date(DayPilotCalendar.dragFromOutsideStart)
        var end = new Date(DayPilotCalendar.dragFromOutsideEnd);
        var browser_name = document.getElementById("mainCalendar_browser").value;
        var newStartUTC = start.getUTCFullYear() + "/" + (start.getUTCMonth() + 1) + "/" + start.getUTCDate() + " " + start.getUTCHours() + ":" + start.getUTCMinutes();
        var newEndUTC = end.getUTCFullYear() + "/" + (end.getUTCMonth() + 1) + "/" + end.getUTCDate() + " " + end.getUTCHours() + ":" + end.getUTCMinutes();
        var newCurrentDate = currentDate.getUTCFullYear() + "/" + (currentDate.getUTCMonth() + 1) + "/" + currentDate.getUTCDate() + " " + currentDate.getUTCHours() + ":" + currentDate.getUTCMinutes();
        var underEND = "0";
        if (DayPilotCalendar.dragUnderEnd == true){
            underEND = "1";
        } else {
            underEND = "0";
        }

        if (document.getElementById('cloned') && document.getElementById('cloned').firstChild) {
            var idService = document.getElementById('cloned').firstChild.id.replace("cloned_content_id_service_", "");
            var serviceName = document.getElementById('cloned').firstChild.innerHTML.replace(/(<([^>]+)>)/ig,"").replace(/(^\s+)|(\s+$)/ig,"");
            if (serviceName.toLowerCase() != "break") {
                if (!idCustomer && idEmployee > 0) {
                	
                	document.getElementById("dr_start").value = DayPilotCalendar.dragFromOutsideStart;
                    document.getElementById("dr_end").value = DayPilotCalendar.dragFromOutsideEnd;
                    document.getElementById("dr_column").value = idEmployee;
                    document.getElementById("underEND").value = underEND;
                	//check permission
                	//status
                	jQuery.get("login", {"query": "permission", "employeeId": idEmployee, "timestamp" : new Date().getTime()}, 
            			function(data, textStatus, response)
                	{
                		var result = jQuery.parseJSON(response.responseText);
                		if(result.status==true){
                			//var MouseX = event.clientX + document.body.scrollLeft;
                            //var MouseY = event.clientY + document.body.scrollTop;
                            var obj = document.getElementById("win");
                            //obj.style.top = MouseY + 10 + "px";
                            //obj.style.left = MouseX + "px";
                            setWindowCenter(obj);
//                            alert("save");
                            obj.style.visibility = "visible";
                		}else{
                			var pop = new popup();
                			pop.tip({message: result.message, "visiable" : false, "type": "error", "showLocation" : "center"});
                		}
                	});
                	
                } else {
//                    alert(req);
                    var reshedule = document.getElementById("reshedule").value;
                    var id_booking = document.getElementById("id_booking").value;
                    var xmlRequestAppointment;

                    try {
                        xmlRequestAppointment = new XMLHttpRequest();
                    }
                    catch(e) {
                        try {
                            xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch(e) {
                        }
                    }

                    xmlRequestAppointment.onreadystatechange = function() {
                        if (xmlRequestAppointment.readyState == 4) {
		                  	var req2 = xmlRequestAppointment.responseText;
		                  	if(req2==null || req2==""){
								var pop = new popup();
								pop.tip({message:"not permission!","visiable" : false, "type": "warning", "showLocation" : "buttom"});
								
							}else{
								drawAroundEvents(xmlRequestAppointment.responseText);
			                  	//TODO: .x.m. send comfirm Email
			                  	//alert(xmlRequestAppointment.responseText);
			                  	//{"ServerId":"appoint_70272","BarStart":0,"EventStatus":0,
			                  	//"ToolTip":"Xm Xm","PartStart":"一月 29, 2015 14:15:00 +0000",
			                  	//"Box":true,"Left":300,"Tag":"","InnerHTML":"Xm Xm - Ombre",
			                  	//"Width":100,"ResizeEnabled":true,"Start":"一月 29, 2015 14:15:00 +0000",
			                  	//"RightClickEnabled":true,"Value":"3","Height":66,"End":"一月 29, 2015 15:00:00 +0000",
			                  	//"ClickEnabled":false,"BarColor":"#FF5B01","BarLength":66,"PartEnd":"一月 29, 2015 15:00:00 +0000",
			                  	//"DeleteEnabled":true,"Text":"Event #1","MoveEnabled":true,"ContextMenu":null,
			                  	//"idappt":70272,"ide":75,"idc":11287,"ids":73,"dt":"2015/1/29","BackgroundColor":"#FFF57A",
			                  	//"Top":374,"DayIndex":0}
			                  	if(xmlRequestAppointment.responseText){
			                  		console.log(xmlRequestAppointment.responseText);
			                  		
			                  		var data = "["+xmlRequestAppointment.responseText+"]"
				                  	
				                    var appointments = jQuery.parseJSON(data);
				                    sendcomfrimEmail(appointments[0].ServerId, idEmployee, idCustomer, true);
			                  	}
							}
                        }
                    };
                   
                    var datetime = dateformat(new Date(), "yyyy-MM-dd hh:mm:ss");  //DyveCalendar.dateformat;
                    var reqURL = "ScheduleManager?optype=NEW&start=" + newStartUTC + "&end=" + newEndUTC +"&datetime="+datetime+ "&idnewemployee=" + idEmployee + "&idcustomer=" + idCustomer + "&idservice=" + idService + "&idlocation=" + idLocation + "&dateutc=" + newCurrentDate + "&pageNum=" + pageNum + "&comment=" + comment+ "&req=" + req + "&browser=" + browser_name + "&underEND=" + underEND + "&reshedule=" + reshedule + "&idb=" + id_booking;
                    //alert(reqURL);
                    xmlRequestAppointment.open("POST", reqURL);
                    xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
                    xmlRequestAppointment.send('');
                }
            } else if (serviceName.toLowerCase() == "break") {
//                alert("break");
                MouseX = event.clientX + document.body.scrollLeft;
                MouseY = event.clientY + document.body.scrollTop;
                obj = document.getElementById("win1");
                setWindowCenter(obj);
//                obj.style.top = MouseY + 10 + "px";
//                obj.style.left = MouseX + "px";
//                var start_w = (start.getUTCHours() - 9) * 4 + start.getUTCMinutes() / 15;
//                var end_w = (end.getUTCHours() - 9) * 4 + end.getUTCMinutes() / 15;
                var start_w = (start.getUTCHours() - /*8*/ _from) * 4 + start.getUTCMinutes() / 15; // for esalonsoft/vogue
                var end_w = (end.getUTCHours() - /*8*/ _from) * 4 + end.getUTCMinutes() / 15;       // for esalonsoft/vogue
                //document.getElementById('w_from').value = start_w;
                //document.getElementById('w_to').value = end_w;
                select_setValue('w_from', start_w);
                select_setValue('w_to', end_w);
                obj.style.visibility = "visible";
                document.getElementById("emp_id").value = idEmployee;
            }
        }
    }
}

function edit_comments(type){
    obj = document.getElementById("win5");
    document.getElementById("type_comm").value = type;
    if (type == '1'){
        document.getElementById("editcomment").value = document.getElementById("comment").value;
    } else if (type == '2'){
        document.getElementById("editcomment").value = document.getElementById("custcomm").value;
    }
    setWindowCenter(obj);
    obj.style.visibility = "visible";
}

DayPilotCalendar.getCellsAbove = function($a)
{
    var $b = [];
    var c = DayPilotCalendar.getColumn($a);
    var tr = $a.parentNode;
    var $c = null;
    while (tr && $c !== DayPilotCalendar.firstSelected)
    {
        $c = tr.getElementsByTagName("td")[c];
        $b.push($c);
        tr = tr.previousSibling;
        while (tr && tr.tagName !== "TR")
        {
            tr = tr.previousSibling;
        }
    }
    ;
    return $b;
};

DayPilotCalendar.getCellsBelow = function($a)
{
    var $b = [];
    var c = DayPilotCalendar.getColumn($a);
    var tr = $a.parentNode;
    var $c = null;
    while (tr && $c !== DayPilotCalendar.firstSelected)
    {
        $c = tr.getElementsByTagName("td")[c];
        $b.push($c);
        tr = tr.nextSibling;
        while (tr && tr.tagName !== "TR") {
            tr = tr.nextSibling;
        }
    }
    ;
    return $b;
};

DayPilotCalendar.getColumn = function($a)
{
    var i = 0;
    while ($a.previousSibling) {
        $a = $a.previousSibling;
        if ($a.tagName === "TD") {
            i++;
        }
    }
    return i;
};

DayPilotCalendar.getShadowColumn = function($d) {
    if (!$d) {
        return null;
    }
    ;
    var $e = $d.parentNode;
    while ($e && $e.tagName !== "TD")
    {
        $e = $e.parentNode;
    }
    ;
    return $e;
};

DayPilotCalendar.gMouseMove = function(ev)
{
    if (typeof(DayPilotCalendar) === 'undefined')
    {
        return;
    }
    ;

    var $f = DayPilot.mc(ev);

    if (DayPilotCalendar.drag)
    {
        document.body.style.cursor = 'move';
        if (!DayPilotCalendar.gShadow)
        {
            DayPilotCalendar.gShadow = DayPilotCalendar.createGShadow();
        }
        ;
        var $g = DayPilotCalendar.gShadow;
        $g.style.left = $f.x + 'px';
        $g.style.top = $f.y + 'px';
        DayPilotCalendar.moving = null;
        DayPilotCalendar.removeShadow(null, DayPilotCalendar.movingShadow);
        DayPilotCalendar.movingShadow = null;
    }

};
DayPilotCalendar.gMouseUp = function(e)
{
	if(isMobile())
		return ;
    //silviu
    if (DayPilotCalendar.dragFromOutside == true)
    {
        DayPilotCalendar.saveAppointment(DayPilotCalendar.dragFromOutsideStart, DayPilotCalendar.dragFromOutsideEnd, DayPilotCalendar.dragFromOutsideColumn, e);

        DayPilotCalendar.dragFromOutside = false;
        DayPilotCalendar.dragFromOutsideStart = null;
        DayPilotCalendar.dragFromOutsideEnd = null;
        DayPilotCalendar.dragFromOutsideColumn = null;

        document.body.style.cursor = 'default';
        DayPilotCalendar.moving = null;
        DayPilotCalendar.removeShadow(null, DayPilotCalendar.movingShadow);
        DayPilotCalendar.movingShadow = null;
    }
    //end silviu
    if (DayPilotCalendar.resizing)
    {
        var $h = DayPilotCalendar.resizing.event;
        var $i = DayPilotCalendar.resizingShadow.clientHeight + 4;
        var top = DayPilotCalendar.resizingShadow.offsetTop;
        var $j = DayPilotCalendar.resizing.dpBorder;

//        DayPilotCalendar.resizing.style.height = DayPilotCalendar.resizingShadow.clientHeight+4+"px";
//        DayPilotCalendar.resizing.style.top = DayPilotCalendar.resizingShadow.style.top;

        DayPilotCalendar.removeShadow(DayPilotCalendar.resizing, DayPilotCalendar.resizingShadow);
        DayPilotCalendar.resizing.style.cursor = 'default';
        document.body.style.cursor = 'default';
        DayPilotCalendar.resizing = null;

        if ($h.root.overlap) {
            return;
        }
        ;
        $h.root.eventResize($h, $i, top, $j);
    }
    else if (DayPilotCalendar.moving)
    {
        try {
            var $k;
            if (DayPilotCalendar.moving.getAttribute)
            {
                $k = DayPilotCalendar.getShadowColumn(DayPilotCalendar.moving).getAttribute("dpColumn");
            }
            ;
            var $l = DayPilotCalendar.getShadowColumn(DayPilotCalendar.movingShadow).getAttribute("dpColumn");
            var $m = DayPilotCalendar.getShadowColumn(DayPilotCalendar.movingShadow).getAttribute("dpColumnDate");
            var top = DayPilotCalendar.movingShadow.offsetTop;
            DayPilotCalendar.removeShadow(DayPilotCalendar.moving, DayPilotCalendar.movingShadow);
            var $h;
            if (DayPilotCalendar.moving.event)
            {
                $h = DayPilotCalendar.moving.event;
            }
            ;
            DayPilotCalendar.moving = null;
            document.body.style.cursor = 'default';
            if (DayPilotCalendar.drag)
            {
                if (!$h.root.todo)
                {
                    $h.root.todo = {};
                }
                ;
                $h.root.todo.del = DayPilotCalendar.drag.element;
            }
            ;
            if ($h.root.overlap) {
                return;
            }
            ;
            $h.root.eventMove($h, $k, $l, $m, top);
        } catch(e) {
        }
    }
    ;
    if (DayPilotCalendar.drag)
    {
        alert('drag1');
        DayPilotCalendar.drag = null;
        document.body.style.cursor = null;
    }
    ;
    if (DayPilotCalendar.gShadow)
    {
        document.body.removeChild(DayPilotCalendar.gShadow);
        DayPilotCalendar.gShadow = null;
    }
    ;
    DayPilotCalendar.moveOffsetY = null;
};

DayPilotCalendar.dragStart = function(element, $n, id, $o)
{
    DayPilot.us(element);
    var $p = DayPilotCalendar.drag = {};
    $p.element = element;
    $p.duration = $n;
    $p.text = $o;
    $p.id = id;
    return false;
};

DayPilotCalendar.createShadow = function($d)
{
	if(isMobile())
		return;
	
    var $e = $d.parentNode;
    while ($e && $e.tagName !== "TD")
    {
        $e = $e.parentNode;
    }
    ;
    var $g = document.createElement('div');
    $g.setAttribute('unselectable', 'on');
    $g.style.position = 'absolute';
    $g.style.width = ($d.offsetWidth - 4) + 'px';
    $g.style.height = ($d.offsetHeight - 4) + 'px';
    $g.style.left = ($d.offsetLeft) + 'px';
    $g.style.top = ($d.offsetTop) + 'px';
    $g.style.border = '2px dotted #666666';
    $g.style.zIndex = 101;
    $e.firstChild.appendChild($g);
    return $g;
};

DayPilotCalendar.removeShadow = function($d, $g)
{
    if (!$g)
    {
        return;
    }
    ;
    if (!$g.parentNode) {
        return;
    }
    ;
    $g.parentNode.removeChild($g);
};

DayPilotCalendar.createGShadow = function()
{
    var $g = document.createElement('div');
    $g.setAttribute('unselectable', 'on');
    $g.style.position = 'absolute';
    $g.style.width = '100px';
    $g.style.height = '20px';
    $g.style.border = '2px dotted #666666';
    $g.style.zIndex = 101;
    document.body.appendChild($g);
    return $g;
};
DayPilotCalendar.moveShadow = function($q)
{
    try {
        var $g = DayPilotCalendar.movingShadow;
        $g.parentNode.removeChild($g);
        $q.firstChild.appendChild($g);
        $g.style.left = '-1px';
        $g.style.width = DayPilotCalendar.movingShadow.parentNode.offsetWidth - 4 + 'px';
    } catch(e) {
    }
};

DayPilotCalendar.updateView = function($r, $s) {
    var $r = eval("(" + $r + ")");
    var $t = eval($s);
    if ($r.Action == "None") {
        return;
    }
    ;
    var $u = document.createElement("input");
    $u.type = 'hidden';
    $u.name = $t.id + "_vsupdate";
    $u.id = $u.name;
    $u.value = $r.VsUpdate;
    $t.$("vsph").innerHTML = '';
    $t.$("vsph").appendChild($u);
    $t.minEnd = $r.MinEnd;
    $t.maxStart = $r.MaxStart;
    $t.allDayHeaderHeight = $r.AllDayHeaderHeight;
    $t.totalHeader = $r.TotalHeader;
    $t.scrollUpTop = $r.ScrollUpTop;
    $t.scrollDownTop = $r.ScrollDownTop;
    if ($r.Action == "Refresh") {
        $t.startDate = new Date($r.StartDate);
        $t.days = $r.Days;
        $t.colors = $r.Colors;
        $t.columns = $r.Columns;
        $t.headerLevels = $r.HeaderLevels;
        $t.prepareColumns();
        $t.drawHeader();
        $t.drawTable();
    }
    ;
    $t.events = $r.Events;
    $t.eventsAllDay = $r.EventsAllDay;
    $t.drawEvents();
    $t.drawEventsAllDay();
    if ($t.timeRangeSelectedHandling != "HoldForever") {
        $t.cleanSelection();
    }
    ;
    $t.updateScrollIndicators();
    if ($t.todo) {
        if ($t.todo.del) {
            var $v = $t.todo.del;
            $v.parentNode.removeChild($v);
            $t.todo.del = null;
        }
    }
    ;
    $t.afterRender($r.CallBackData);
};

DayPilotCalendar.getScrollWidth = function($t) {
    if (DayPilotCalendar.scrollWidth)return DayPilotCalendar.scrollWidth;
    var scroll = $t.$("scroll");
    DayPilotCalendar.scrollWidth = scroll.offsetWidth - scroll.clientWidth - 2;
    return DayPilotCalendar.scrollWidth;
};
DayPilotCalendar.Calendar = function(id)
{
    var $t = DayPilotCalendar._this = this;
    this.uniqueID = null;
    this.id = id;
    this.selectedEvents = [];

    this.cleanSelection = function()
    {
        //alert("Selected Cells:" + DayPilotCalendar.selectedCells.length);
        for (var j = 0; j < DayPilotCalendar.selectedCells.length; j++)
        {
            var $a = DayPilotCalendar.selectedCells[j];
            //alert($a);
            if ($a)
            {
                //alert($a.originalColor);
                $a.style.backgroundColor = $a.originalColor;
                $a.selected = false;
            }
        }
    };

    this.postBack = function($w)
    {
        var $x = [];
        for (var i = 1; i < arguments.length; i++)
        {
            $x.push(arguments[i]);
        }
        ;
        __doPostBack($t.uniqueID, $w + DayPilot.ea($x));
    };

    this.callBack = function($w)
    {
        var $x = [];
        for (var i = 1; i < arguments.length; i++)
        {
            $x.push(arguments[i]);
        }
        ;
        $x.push($t.startDate);
        $x.push($t.days);
        WebForm_DoCallback(this.uniqueID, $w + DayPilot.ea($x), DayPilotCalendar.updateView, this.clientName, this.callbackError, true);
    };

    this.$ = function($y) {
        return document.getElementById(id + "_" + $y);
    };

    this.isOverlapping = function($q)
    {
        var $g = DayPilotCalendar.movingShadow || DayPilotCalendar.resizingShadow;
        var $d = DayPilotCalendar.moving || DayPilotCalendar.resizing;
        if (!$g) {
            return false;
        }
        ;
        if (!$q)
        {
            $q = $d.data.DayIndex;
        }
        ;
        if ($d)
        {
            document.title = $q + ' ' + new Date();
        }
        else
        {
            document.title = 'null object ' + new Date();
        }
        ;
        var $z = parseInt($g.style.top);
        var $A = parseInt($g.style.height);
        var $B = $z + $A;
        for (var i = 0; i < this.events.length; i++)
        {
            var $C = this.events[i];
            if ($q != $C.DayIndex) {
                continue;
            }
            ;
            var pk = $d.event.value();
            if ($C.Value == pk)
            {
                continue;
            }
            ;
            var $D = $C.Top + $C.Height;
            if ($z >= $D || $B <= $C.Top) {
                continue;
            } else {
                return true;
            }
        }
        ;
        return false;
    };

    this.createShadow = function($n)
    {
        var $E = $t.$("main");
        var $F = $E.clientWidth / 8;    //$E.rows[0].cells.length;
        var i = Math.floor(($t.coords.x - 45) / $F);
        var $q = $E.rows[0].cells[i];
        $t.cellHeight = 22;
        var $i = $n * $t.cellsPerHour * $t.cellHeight / 3600;
        var $G = 1;
        var top = Math.floor((($t.coords.y - $G) + $t.cellHeight / 2) / $t.cellHeight) * $t.cellHeight + $G;
        var $g = document.createElement('div');
        $g.setAttribute('unselectable', 'on');
        $g.style.position = 'absolute';
        $g.style.width = ($q.offsetWidth - 4) + 'px';
        $g.style.height = ($i - 4) + 'px';
        $g.style.left = '0px';
        $g.style.top = top + 'px';
        $g.style.border = '2px dotted #666666';
        $g.style.zIndex = 101;
        $q.firstChild.appendChild($g);
        return $g;
    };

    this.eventClickPostBack = function(e) {
        this.postBack('CLK:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };
    this.eventClickCallBack = function(e) {
        this.callBack('CLK:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };
    this.eventClick = function() {
        if (typeof(DayPilotBubble) != 'undefined')
        {
            DayPilotBubble.hideActive();
        }
        ;
        if ($t.eventDoubleClickHandling == 'Disabled')
        {
            $t.eventClickSingle(this);
            return;
        }
        ;
        if (!$t.timeouts)
        {
            $t.timeouts = [];
        }
        ;
        var $H = function($I)
        {
            return function() {
                $t.eventClickSingle($I);
            }
        };
        $t.timeouts.push(window.setTimeout($H(this), 300));
    };
    this.eventClickSingle = function($J) {
        var e = $J.event;
        if (!e.clickingAllowed())
        {
            return;
        }
        ;
        switch ($t.eventClickHandling)
                {
            case 'PostBack':$t.eventClickPostBack(e);
                break;
            case 'CallBack':$t.eventClickCallBack(e);
                break;
            case 'JavaScript':$t.eventClickCustom(e);
                break;
            case 'Edit':if (!e.isAllDay()) {
                $t.divEdit($J);
            };
                break;
            case 'Select':if (!e.isAllDay()) {
                $t.eventSelect(e);
            };
                break;
            case 'Bubble':if ($t.bubble) {
                $t.bubble.showEvent($t.uniqueID, e.value());
            };
                break;
        }
    };
    this.eventDoubleClickPostBack = function(e) {
        this.postBack('CLK:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };
    this.eventDoubleClickCallBack = function(e) {
        this.callBack('CLK:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };
    this.eventDoubleClick = function() {
        //alert("eventDoubleClick");
        if (typeof(DayPilotBubble) != 'undefined')
        {
            DayPilotBubble.hideActive();
        }
        ;
        if ($t.timeouts)
        {
            for (var $K in $t.timeouts) {
                window.clearTimeout($t.timeouts[$K]);
            }
            ;
            $t.timeouts = null;
        }
        ;
        var e = this.event;
        /* if(!e.clickingAllowed())
         {
         alert("notallowed");
         return;
         };*/
        switch ($t.eventDoubleClickHandling)
                {
            case 'PostBack':$t.eventDoubleClickPostBack(e);
                break;
            case 'CallBack':$t.eventDoubleClickCallBack(e);
                break;
            case 'JavaScript':$t.eventDoubleClickCustom(e);
                break;
            case 'Edit':if (!e.isAllDay()) {
                $t.divEdit(this)
            };;
                break;
            case 'Select':if (!e.isAllDay()) {
                $t.eventSelect(e)
            };;
                break;
            case 'Bubble':if ($t.bubble) {
                $t.bubble.showEvent($t.uniqueID, e.value());
            };
                break;
        }
    };
    this.rightClickPostBack = function(e) {
        this.postBack('RCK:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };
    this.rightClickCallBack = function(e) {
        this.callBack('RCK:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };

    this.rightClick = function()
    {
        var e = this.event;
        if (!e.rightClickingAllowed()) {
            return false;
        }
        ;
        switch ($t.rightClickHandling)
                {
            case 'PostBack':$t.rightClickPostBack(e);
                break;
            case 'CallBack':$t.rightClickCallBack(e);
                break;
            case 'JavaScript':$t.rightClickCustom(e);
                break;
            case 'ContextMenu':
                if (this.data.ContextMenu)
                {
                    eval(this.data.ContextMenu + ".show(this.event)");
                }
                else
                {
                    if ($t.contextMenu) {
                        $t.contextMenu.show(this.event);
                    }
                };
                break;
            case 'Bubble':if ($t.bubble) {
                $t.bubble.showEvent($t.uniqueID, e.value());
            };
                break;
        }
        ;
        return false;
    };

    this.headerClickPostBack = function(c) {
        this.postBack('HEA:', c.value, c.name, c.date);
    };
    this.headerClickCallBack = function(c) {
        this.callBack('HEA:', c.value, c.name, c.date);
    };
    this.headerClick = function($d) {
        var $C = this.data;
        var c = new DayPilotCalendar.Column($C.Value, $C.Name, $C.Date);
        switch ($t.headerClickHandling) {
            case 'PostBack':$t.headerClickPostBack(c);
                break;
            case 'CallBack':$t.headerClickCallBack(c);
                break;
            case 'JavaScript':$t.headerClickCustom(c);
                break;
        }
    };
    this.headerMouseMove = function() {
        if (typeof(DayPilotBubble) != 'undefined' && $t.columnBubble) {
            if ($t.viewType == "Days") {
                var $L = new Date(this.data.Date);
                var end = DayPilot.Date.addDays($L, 1);
                $t.columnBubble.showTime($t.uniqueID, $L, end);
            } else {
                $t.columnBubble.showResource($t.uniqueID, this.data.Value);
            }
        }
    };
    this.headerMouseOut = function() {
        if (typeof(DayPilotBubble) != 'undefined' && $t.columnBubble) {
            $t.columnBubble.hideOnMouseOut();
        }
    };
    this.eventDeletePostBack = function(e) {
        this.postBack('DEL:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };
    this.eventDeleteCallBack = function(e) {
        this.callBack('DEL:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay());
    };

    this.eventDelete = function($d, event)
    {
        var e = $d.parentNode.parentNode.event;
        document.getElementById("event").value = e;
        document.getElementById("app_id").value = e.div.data.ServerId;
        MouseX = event.clientX + document.body.scrollLeft;
        MouseY = event.clientY + document.body.scrollTop;
        obj = document.getElementById("win2");
        obj.style.top = MouseY + 10 + "px";
        obj.style.left = MouseX + "px";
        obj.style.visibility = "visible";
        /*switch($t.eventDeleteHandling)
         {
         case 'PostBack'		: $t.eventDeletePostBack(e);
         break;
         case 'CallBack'		: $t.eventDeleteCallBack(e);
         break;
         case 'JavaScript'	: $t.eventDeleteCustom(e);
         break;
         }*/
    };
    function mtRand(min, max)
    {
        var range = max - min + 1;
        var n = Math.floor(Math.random() * range) + min;
        return n;
    }

    function mkTransNum()
    {
        var len=7;
        var tran = '';
        var rnd = 0;
        var c = '';
        for (i = 0; i < len; i++) {
            rnd = mtRand(0, 1);
            if (rnd == 0) {
                c = String.fromCharCode(mtRand(48, 57));
            }
            if (rnd == 1) {
                c = String.fromCharCode(mtRand(97, 122));
            }
            tran += c;
        }
        return tran;
    }

    this.eventTransaction = function($d, event)
    {
        var e = $d.parentNode.parentNode.event;
//        var xmlRequestService;
//           try {
//              xmlRequestService = new XMLHttpRequest();
//           }
//           catch(e) {
//               try {
//                   xmlRequestService = new ActiveXObject("Microsoft.XMLHTTP");
//               } catch(e) { }
//           }
//
//            xmlRequestService.onreadystatechange = function()
//            {
//                if (xmlRequestService.readyState ==4 )
//                {
//                    var response = new String(xmlRequestService.responseText);
//                    if(response != '###')
//                    {
//                         alert(response);
//                    }
//                    else
//                    {
//                        if(e.div.data.BackgroundColor == '#C1DEA6')
//                        { // if checked
//                            var ct = mkTransNum();
//                            window.location.href = 'checkout.jsp?dt=' + e.div.data.dt + '&ide=' + e.div.data.ide + '&idc=' + e.div.data.idc + '&ids=' + e.div.data.ids+'&idappt='+e.div.data.idappt+'&from=schedule&ct=' + ct;
//                        }else if(e.div.data.BackgroundColor == '#acadb1')
//                        { // if paid
//                            alert("It's a paid appointment");
//                        }else{
//                            alert('Please check in appointnent before check out.');
//                        }
//                    }
//                }
//            };
//
//            xmlRequestService.open("POST", "./schqry?query=openday&type=pay&date="+e.div.data.dt);
//            xmlRequestService.send('');

            var ct = mkTransNum();
            new Ajax.Request( './schqry?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                query: "openday",
                type: "pay",
                date: e.div.data.dt
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                    if(response != '###')
                    {
                         alert(response);
                    }
                    else
                    {
                        if(e.div.data.BackgroundColor == '#C1DEA6')
                        { // if checked

                        window.location.href = 'checkout.jsp?dt=' + e.div.data.dt + '&ide=' + e.div.data.ide + '&idc=' + e.div.data.idc + '&ids=' + e.div.data.ids+'&idappt='+e.div.data.idappt+'&from=schedule&ct=' + ct;
                        }else if(e.div.data.BackgroundColor == '#acadb1')
                        { // if paid
                            alert("It's a paid appointment");
                        }else{
                            alert('Please check in appointnent before check out.');
                        }
                    }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error openday type pay: ' + exception);
            }
            });

    }

        this.eventChangeStatus = function ($d)
        {
            var e = $d.parentNode.parentNode.event;
            if(e.div.data.BackgroundColor != '#C1DEA6' && e.div.data.BackgroundColor != '#acadb1')
            {
                $d.style.display = 'none';
            }

//           var xmlRequestService;
//           try {
//              xmlRequestService = new XMLHttpRequest();
//           }
//           catch(e) {
//               try {
//                   xmlRequestService = new ActiveXObject("Microsoft.XMLHTTP");
//               } catch(e) { }
//           }
//
//            xmlRequestService.onreadystatechange = function()
//            {
//                if (xmlRequestService.readyState ==4 )
//                {
//                    var response = new String(xmlRequestService.responseText);
//                    if(response != '###')
//                    {
//                         alert(response);
//                    }
//                    else
//                    {
//                        if(e.div.data.BackgroundColor != '#C1DEA6' && e.div.data.BackgroundColor != '#acadb1')
//                        { // NON CHECKED and non payed
//                            var ct = mkTransNum();
//                            switch ($t.eventChangeStatusHandling)
//                                    {
//                                case 'JavaScript'    : $t.eventChangeStatusCustom($d, e, ct);
//                                    break;
//                            }
//                        }
//                    }
//                }
//            };
//            xmlRequestService.open("POST", "./schqry?query=openday&type=check&date="+e.div.data.dt);
//            xmlRequestService.send('');
            var ct = mkTransNum();
            new Ajax.Request( './schqry?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                query: "openday",
                type: "check",
                date: e.div.data.dt
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                    if(response != '###')
                    {
                         alert(response);
                    }
                    else
                    {
                        if(e.div.data.BackgroundColor != '#C1DEA6' && e.div.data.BackgroundColor != '#acadb1')
                        { // NON CHECKED and non payed

                            switch ($t.eventChangeStatusHandling)
                                    {
                                case 'JavaScript'    : $t.eventChangeStatusCustom($d, e, ct);
                                    break;
                            }
                        }
                    }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error openday type check: ' + exception);
            }
            });
        }

    this.eventResizePostBack = function(e, $M, $N)
    {
        if (!$M)throw 'newStart is null';
        if (!$N)throw 'newEnd is null';
        this.postBack('RES:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay(), $M, $N);
    };

    this.eventResizeCallBack = function(e, $M, $N)
    {
        if (!$M)throw 'newStart is null';
        if (!$N)throw 'newEnd is null';

        this.callBack('RES:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay(), $M, $N);
    };

    this.eventResize = function(e, $A, $z, $j)
    {
        var $G = 1;
        var $M = new Date();
        var $N = new Date();
        var $L = e.start();
        var $O = 60 / $t.cellsPerHour;
        var $P = new Date();
        $P.setTime(Date.UTC($L.getUTCFullYear(), $L.getUTCMonth(), $L.getUTCDate()));
        $t.cellHeight = 22;
        if ($j === 'top')
        {
            var $Q = Math.floor(($z - $G) / $t.cellHeight);
            var $R = $Q * $O;
            var ts = $R * 60 * 1000;
//            var $S = $t.visibleStart * 3240 * 1000;
            var $S = $t.visibleStart * 60*60*1000;//2880 * 1000;  // for esalonsoft/vogue
            $M.setTime($P.getTime() + ts + $S);
            $N = e.end();
        }
        else if ($j === 'bottom')
        {
            var $Q = Math.floor(($z + $A - $G) / $t.cellHeight);
            var $R = $Q * $O;
            var ts = $R * 60 * 1000;
//            var $S = $t.visibleStart * 3240 * 1000;
            var $S = $t.visibleStart * 60*60*1000;//2880 * 1000;  // for esalonsoft/vogue
            $M = $L;
            $N.setTime($P.getTime() + ts + $S);
        }
        ;
        switch ($t.eventResizeHandling)
                {
            case 'PostBack':$t.eventResizePostBack(e, $M, $N);break;
            case 'CallBack':$t.eventResizeCallBack(e, $M, $N);break;
            case 'JavaScript':$t.eventResizeCustom(e, $M, $N);break;
        }
//        e.setStart($M);
//        e.setEnd($N);
    };

    this.eventMovePostBack = function(e, $M, $N, $k, $l) {
        if (!$M)throw 'newStart is null';
        if (!$N)throw 'newEnd is null';
        this.postBack('MOV:', e.value(), e.tag(), e.start(), e.end(), e.text(), $k, e.isAllDay(), $M, $N, $l);
    };
    this.eventMoveCallBack = function(e, $M, $N, $k, $l) {
        if (!$M)throw 'newStart is null';
        if (!$N)throw 'newEnd is null';
        this.callBack('MOV:', e.value(), e.tag(), e.start(), e.end(), e.text(), $k, e.isAllDay(), $M, $N, $l);
    };

    this.eventMove = function(e, $k, $l, $m, $z)
    {
        var $G = 0; // var $G = 1;
        $t.cellHeight = 22;
        var $Q = Math.floor(($z - $G) / $t.cellHeight);
        var $O = 60 / $t.cellsPerHour;
        // $T - cells from top
        var $T = $Q * $O * 60 * 1000;
        var $L = e.start();
        var end = e.end();
        var $P = new Date();
        $P.setTime(Date.UTC($L.getUTCFullYear(), $L.getUTCMonth(), $L.getUTCDate()));
        var $U = ($t.useEventBoxes != 'Never') ? $L.getTime() - ($P.getTime() + $L.getUTCHours() * 3600 * 1000 + Math.floor($L.getUTCMinutes() / $O) * $O * 60 * 1000) : 0;
        var length = end.getTime() - $L.getTime();
//        var $S = $t.visibleStart * 3240 * 1000;
        var $S = $t.visibleStart * 60 * 60 * 1000;//2880 * 1000;  // for esalonsoft/vogue
        // $V - gmt offset
        var $V = (Date._jsParse) ? Date._jsParse($m) : Date.parse($m);
        //alert(new Date($V));
        //alert(new Date($T));
        //alert(new Date($U));
        //alert(new Date($S));
        var $M = new Date();
        $M.setTime($V + $T + $U + $S);
        //alert($M);
        var $N = new Date();
        $N.setTime($M.getTime() + length);
        switch ($t.eventMoveHandling)
                {
            case 'PostBack':$t.eventMovePostBack(e, $M, $N, $k, $l);break;
            case 'CallBack':$t.eventMoveCallBack(e, $M, $N, $k, $l);break;
            case 'JavaScript':
                $t.eventMoveCustom(e, $M, $N, $k, $l, DayPilotCalendar.drag ? true : false);
                break;
        }
    };
    this.eventMenuClickPostBack = function(e, $W) {
        this.postBack('MNU:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay(), $W);
    };
    this.eventMenuClickCallBack = function(e, $W) {
        this.callBack('MNU:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay(), $W);
    };
    this.eventMenuClick = function($W, e, $X) {
        switch ($X) {case 'PostBack':$t.eventMenuClickPostBack(e, $W);break;case 'CallBack':$t.eventMenuClickCallBack(e, $W);break;}
    };
    this.timeRangeMenuClickPostBack = function(e, $W) {
        this.postBack('TRM:', e.start, e.end, e.resource, $W);
    };
    this.timeRangeMenuClickCallBack = function(e, $W) {
        this.callBack('TRM:', e.start, e.end, e.resource, $W);
    };
    this.timeRangeMenuClick = function($W, e, $X) {
        switch ($X) {case 'PostBack':$t.timeRangeMenuClickPostBack(e, $W);break;case 'CallBack':$t.timeRangeMenuClickCallBack(e, $W);break;}
    };
    this.timeRangeSelectedPostBack = function($L, end, $q) {
        this.postBack('FRE:', $L, end, $q);
    };
    this.timeRangeSelectedCallBack = function($L, end, $q) {
        this.callBack('FRE:', $L, end, $q);
    };
    this.timeRangeSelected = function($L, end, $q) {
        switch ($t.timeRangeSelectedHandling) {case 'PostBack':$t.timeRangeSelectedPostBack($L, end, $q);break;case 'CallBack':$t.timeRangeSelectedCallBack($L, end, $q);break;case 'JavaScript':$t.timeRangeSelectedCustom($L, end, $q);break;}
    };
    this.timeRangeDoubleClickPostBack = function($L, end, $q) {
        this.postBack('TRD:', $L, end, $q);
    };
    this.timeRangeDoubleClickCallBack = function($L, end, $q) {
        this.callBack('TRD:', $L, end, $q);
    };

    this.timeRangeDoubleClick = function($L, end, $q) {
        switch ($t.timeRangeDoubleClickHandling) {case 'PostBack':$t.timeRangeDoubleClickPostBack($L, end, $q);break;case 'CallBack':$t.timeRangeDoubleClickCallBack($L, end, $q);break;case 'JavaScript':$t.timeRangeDoubleClickCustom($L, end, $q);break;}
    };
    this.eventEditPostBack = function(e, $Y) {
        this.postBack('EDT:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay(), $Y);
    };
    this.eventEditCallBack = function(e, $Y) {
        this.callBack('EDT:', e.value(), e.tag(), e.start(), e.end(), e.text(), e.column(), e.isAllDay(), $Y);
    };
    this.eventEdit = function(e, $Y) {
        switch ($t.eventEditHandling) {case 'PostBack':$t.eventEditPostBack(e, $Y);break;case 'CallBack':$t.eventEditCallBack(e, $Y);break;case 'JavaScript':$t.eventEditCustom(e, $Y);break;}
    };
    this.eventSelectPostBack = function(e) {
        this.postBack('SEL:', '');
    };
    this.eventSelectCallBack = function(e) {
        this.callBack('SEL:', '');
    };
    this.eventSelectAction = function() {
        var e = this.selectedEvent();
        switch ($t.eventSelectHandling) {case 'PostBack':$t.eventSelectPostBack(e);break;case 'CallBack':__theFormPostData = "";__theFormPostCollection = [];WebForm_InitCallback();$t.eventSelectCallBack(e);break;case 'JavaScript':$t.eventSelectCustom(e);break;}
    };
    this.refreshCallBack = function($V, $Z, $C) {
        var $00;
        if (!$Z) {
            $Z = this.days;
        }
        ;
        if (!$V) {
            $00 = this.startDate;
        } else if ($V.getFullYear) {
            $00 = $V;
        } else {
            var $01 = parseInt($V);
            if (isNaN($01)) {
                throw "You must pass null, Date or number as the first parameter to Calendar.refreshCallBack().";
            } else {
                var $00 = new Date();
                $00.setTime(this.startDate.getTime() + $01 * 24 * 3600 * 1000);
            }
        }
        ;
        this.callBack('REF:', $00, $Z, $C);
    };
    this.mousedown = function(ev)
    {
        //silviu
        DayPilotCalendar.dragFromOutside = false;
        DayPilotCalendar.dragFromOutsideStart = null;
        DayPilotCalendar.dragFromOutsideEnd = null;
        DayPilotCalendar.dragFromOutsideColumn = null;

        //end silviu
        if (DayPilotCalendar.selecting)
        {
            return;
        }
        ;
        if (DayPilotCalendar.editing)
        {
            DayPilotCalendar.editing.blur();
            return;
        }
        ;
        if (DayPilotCalendar.selectedCells && $t.timeRangeDoubleClickHandling != 'Disabled')
        {
            for (var i = 0; i < DayPilotCalendar.selectedCells.length; i++)
            {
                if (this == DayPilotCalendar.selectedCells[i])
                {
                    return;
                }
            }
        }
        ;
        if (!$t.AllowSelecting)
        {
            return;
        }
        ;
        var $02 = (window.event) ? window.event.button : ev.which;
        if ($02 !== 1)
        {
            return;
        }
        ;
        DayPilotCalendar.firstMousePos = DayPilot.mc(ev || window.event);
        DayPilotCalendar.selecting = true;
        if (DayPilotCalendar.selectedCells)
        {
            $t.cleanSelection();
            DayPilotCalendar.selectedCells = [];
        }
        ;
        DayPilotCalendar.column = DayPilotCalendar.getColumn(this);
        DayPilotCalendar.selectedCells.push(this);
        DayPilotCalendar.firstSelected = this;
        DayPilotCalendar.topSelectedCell = this;
        DayPilotCalendar.bottomSelectedCell = this;
        $t.activateSelection();
    };
    this.activateSelection = function() {
        var $03 = this.getSelection();
        for (var j = 0; j < DayPilotCalendar.selectedCells.length; j++) {
            var $a = DayPilotCalendar.selectedCells[j];
            if ($a) {
                $a.style.backgroundColor = $t.selectedColor;
                $a.selected = true;
            }
        }
    };
    this.cellMouseOut = function(ev) {
        if (typeof(DayPilotBubble) != 'undefined' && $t.cellBubble) {
            $t.cellBubble.hideOnMouseOut();
        }
    };
    this.mousemove = function(ev)
    {
    	if(isMobile())
    		return ;
        if (typeof(DayPilotCalendar) === 'undefined')
        {
            return;
        }
        ;

        //silviu
        DayPilotCalendar.dragFromOutsideStart = null;
        DayPilotCalendar.dragFromOutsideEnd = null;
        DayPilotCalendar.dragFromOutsideColumn = null;
        window.status = '';
        if (typeof(DayPilotBubble) != 'undefined' && DayPilotCalendar.dragFromOutside == true)
        {
            var $q = DayPilotCalendar.getColumn(this);
            var $04 = $t.$('main');
            var $P = new Date($04.rows[0].cells[$q].getAttribute("dpColumnDate")).getTime();
            //$P.setTime(Date.UTC($P.getUTCFullYear(),$P.getUTCMonth(),$P.getUTCDate()));
            var $05 = $04.rows[0].cells[$q].getAttribute("dpColumn");
            var $L = new Date();
            //window.status=$P + ";" + this.start + ";" + this.end;
            $L.setTime($P + this.start);
            var end = new Date();
            
            end.setTime($P + this.end);
            
            // if ($t.colors[i][$q] != "#ACACAE"){}
            var dateTime = new Date($L);
            var dateEndTime = new Date(end);
//            var intTime = (dateTime.getUTCHours() - 9) * 4 + dateTime.getUTCMinutes() / 15;
//            var intEndTime = (dateEndTime.getUTCHours() - 9) * 4 + dateEndTime.getUTCMinutes() / 15;
            var intTime = (dateTime.getUTCHours() - /*8*/ _from) * 4 + dateTime.getUTCMinutes() / 15;           // for esalonsoft/vogue
            var intEndTime = (dateEndTime.getUTCHours() - /*8*/ _from) * 4 + dateEndTime.getUTCMinutes() / 15;  // for esalonsoft/vogue
            if ($t.colors[intTime][$q] != "#ACACAE") {
//                if ($t.colors[intTime + 1][$q] == "#ACACAE"){
//                    var min15 = new Date();
//                    min15.setHours(0,15,0,0);
//                    end.setTime($L.getTime() + min15.getTime());
//                }else{
//                    var min30 = new Date();
//                    min30.setHours(0,30,0,0);
//                    end.setTime($L.getTime() + min30.getTime());
//                }
                if ($t.colors[intTime + 1][$q] == "#ACACAE"){
//                    document.getElementById("underEND").value = "1";
                    DayPilotCalendar.dragUnderEnd = true;
                } else {
                    DayPilotCalendar.dragUnderEnd = false;
                }
                DayPilotCalendar.dragFromOutsideStart = $L;
                DayPilotCalendar.dragFromOutsideEnd = end;
                DayPilotCalendar.dragFromOutsideColumn = $05;
            }

            //window.status = this.start + ";" + DayPilotCalendar.dragFromOutsideColumn + ";" + DayPilotCalendar.dragFromOutsideStart + ";" +DayPilotCalendar.dragFromOutsideEnd;
        }
        ;
        //end silviu
        if (typeof(DayPilotBubble) != 'undefined' && $t.cellBubble)
        {
            var $q = DayPilotCalendar.getColumn(this);
            var $04 = $t.$('main');
            var $P = new Date($04.rows[0].cells[$q].getAttribute("dpColumnDate")).getTime();
            var $05 = $04.rows[0].cells[$q].getAttribute("dpColumn");
            var $L = new Date();
            $L.setTime($P + this.start);
            var end = new Date();
            end.setTime($P + this.end);
            $t.cellBubble.showCell($t.uniqueID, $05, $L, end);
        }
        ;
        if (!DayPilotCalendar.selecting)
        {
            return;
        }
        ;
        var $f = DayPilot.mc(ev || window.event);
        var $06 = DayPilotCalendar.getColumn(this);
        if ($06 !== DayPilotCalendar.column)
        {
            return;
        }
        ;
        $t.cleanSelection();
        if ($f.y < DayPilotCalendar.firstMousePos.y)
        {
            DayPilotCalendar.selectedCells = DayPilotCalendar.getCellsBelow(this);
            DayPilotCalendar.topSelectedCell = DayPilotCalendar.selectedCells[0];
            DayPilotCalendar.bottomSelectedCell = DayPilotCalendar.firstSelected;
        }
        else
        {
            DayPilotCalendar.selectedCells = DayPilotCalendar.getCellsAbove(this);
            DayPilotCalendar.topSelectedCell = DayPilotCalendar.firstSelected;
            DayPilotCalendar.bottomSelectedCell = DayPilotCalendar.selectedCells[0];
        }
        ;
        $t.activateSelection();
    };


    this.getSelection = function()
    {
        //alert("this.getSelection")
        var $q = DayPilotCalendar.getColumn(DayPilotCalendar.topSelectedCell);
        var $04 = DayPilot.$($t.id + '_main');
        var $P = new Date($04.rows[0].cells[$q].getAttribute("dpColumnDate")).getTime();
        var $07 = $04.rows[0].cells[$q].getAttribute("dpColumn");
        var $L = new Date();
        $L.setTime($P + DayPilotCalendar.topSelectedCell.start);
        var end = new Date();
        end.setTime($P + DayPilotCalendar.bottomSelectedCell.end);
        return new DayPilot.Selection($L, end, $07, $t);
    };


    this.mouseup = function(ev)
    {
        if (DayPilotCalendar.selecting && DayPilotCalendar.topSelectedCell !== null)
        {
            $t.divDeselectAll();
            DayPilotCalendar.selecting = false;
            var $08 = $t.getSelection();
            $t.timeRangeSelected($08.start, $08.end, $08.resource);
            if ($t.timeRangeSelectedHandling != "Hold" && $t.timeRangeSelectedHandling != "HoldForever")
            {
                $t.cleanSelection();
            }
        }
        else
        {
            //event mouse up
            /*
             var s= "";
             for (attr in ev) {
             s+= attr +":" + ev[attr] +"\n";
             }
             alert(DayPilotCalendar.dragFromOutsideStart);
             */
            DayPilotCalendar.selecting = false;
        }
    };


    this.scroll = function(ev)
    {
        /*
         if(!$t.initScrollPos)return;
         $t.scrollPos=$t.$('scroll').scrollTop;
         $t.scrollHeight=$t.$('scroll').clientHeight;
         $t.$('scrollpos').value=$t.scrollPos;
         $t.updateScrollIndicators();
         */
    };
    this.updateScrollIndicators = function() {
        var up = $t.$("up");
        var $09 = $t.$("down");
        if (up && $09) {
            if ($t.minEnd <= $t.scrollPos) {
                up.style.display = '';
            } else {
                up.style.display = 'none';
            }
            ;
            if ($t.maxStart >= $t.scrollPos + $t.scrollHeight) {
                $09.style.display = '';
            } else {
                $09.style.display = 'none';
            }
        }
    };
    this.createEdit = function($d) {
        var $e = $d.parentNode;
        while ($e && $e.tagName !== "TD") {
            $e = $e.parentNode;
        }
        ;
        var $0a = document.createElement('textarea');
        $0a.style.position = 'absolute';
        $0a.style.width = ($d.parentNode.offsetWidth - 2) + 'px';
        $0a.style.height = ($d.offsetHeight - 2) + 'px';
        $0a.style.fontFamily = DayPilot.gs($d, 'fontFamily') + DayPilot.gs($d, 'font-family');
        $0a.style.fontSize = DayPilot.gs($d, 'fontSize') + DayPilot.gs($d, 'font-size');
        $0a.style.left = '0px';
        $0a.style.top = $d.offsetTop + 'px';
        $0a.style.border = '1px solid black';
        $0a.style.padding = '0px';
        $0a.style.marginTop = '0px';
        $0a.style.backgroundColor = 'white';
        $0a.value = DayPilot.tr($d.event.text());
        $0a.event = $d.event;
        $e.firstChild.appendChild($0a);
        return $0a;
    };
    this.divDeselect = function($0b) {
        $0b.parentNode.removeChild($0b.top);
        $0b.parentNode.removeChild($0b.bottom);
    };
    this.divDeselectAll = function() {
        var a = $t.selectedEvents;
        while (a.length > 0) {
            var e = a.pop();
            $t.divDeselect(e);
        }
    };
    this.divSelectOne = function($0b) {
        var w = 5;
        $0b.b = 1;
        $t.selectedEvents.push($0b);
        var top = document.createElement("div");
        top.unselectable = 'on';
        top.style.position = 'absolute';
        top.style.left = $0b.offsetLeft + 'px';
        top.style.width = $0b.offsetWidth + 'px';
        top.style.top = ($0b.offsetTop - w) + 'px';
        top.style.height = w + 'px';
        top.style.backgroundColor = $t.eventSelectColor;
        top.style.zIndex = 100;
        $0b.parentNode.appendChild(top);
        $0b.top = top;
        var $0c = document.createElement("div");
        $0c.unselectable = 'on';
        $0c.style.position = 'absolute';
        $0c.style.left = $0b.offsetLeft + 'px';
        $0c.style.width = $0b.offsetWidth + 'px';
        $0c.style.top = ($0b.offsetTop + $0b.offsetHeight) + 'px';
        $0c.style.height = w + 'px';
        $0c.style.backgroundColor = $t.eventSelectColor;
        $0c.style.zIndex = 100;
        $0b.parentNode.appendChild($0c);
        $0b.bottom = $0c;
    };
    this.cleanEventSelection = function() {
        $t.divDeselectAll();
        var hs = DayPilot.$($t.id + "_select");
        hs.value = null;
    };
    this.eventSelect = function(e) {
        var a = $t.selectedEvents;
        var hs = DayPilot.$($t.id + "_select");
        var s = true;
        if (a.length > 0 && a[0] === e.div) {
            s = false;
        }
        ;
        $t.divDeselectAll();
        if (s) {
            if ($t.eventSelectHandling === "JavaScript") {
                $t.divSelectOne(e.div);
            }
            ;
            hs.value = e.div.event.value();
        } else {
            hs.value = null;
        }
        ;
        $t.eventSelectAction();
    };
    this.selectedEvent = function() {
        var a = $t.selectedEvents;
        if (a.length <= 0) {
            return null;
        }
        ;
        if (a.length === 1) {
            return a[0].event;
        }
        ;
        return null;
    };
    this.divEdit = function($d) {
        if (DayPilotCalendar.editing) {
            DayPilotCalendar.editing.blur();
            return;
        }
        ;
        var $0a = this.createEdit($d);
        DayPilotCalendar.editing = $0a;
        $0a.onblur = function() {
            var id = $d.event.value();
            var $0d = $d.event.tag();
            var $0e = $d.event.text();
            var $Y = $0a.value;
            DayPilotCalendar.editing = null;
            $0a.parentNode.removeChild($0a);
            if ($0e === $Y) {
                return;
            }
            ;
            $d.style.display = 'none';
            $t.eventEdit($d.event, $Y);
        };
        $0a.onkeypress = function(e) {
            var $0f = (window.event) ? event.keyCode : e.keyCode;
            if ($0f === 13) {
                this.onblur();
                return false;
            } else if ($0f === 27) {
                $0a.parentNode.removeChild($0a);
                DayPilotCalendar.editing = false;
            }
            ;
            return true;
        };
        $0a.select();
        $0a.focus();
    };

    this.prepareColumns = function() {
        this.activateColumnCollection(this.columns);
    };

    this.activateColumn = function($q)
    {
        $q.getChildren = function($0g, $0h) {
            var $0i = [];
            if ($0g <= 1) {
                $0i.push(this);
                return $0i;
            }
            ;
            if (this.Children == null || this.Children.length == 0) {
                if ($0h) {
                    $0i.push(this);
                }
                else {
                    $0i.push("empty");
                }
                ;
                return $0i;
            }
            ;
            for (var i = 0; i < this.Children.length; i++) {
                var $0j = this.Children[i];
                var $0k = $0j.getChildren($0g - 1, $0h);
                for (var j = 0; j < $0k.length; j++) {
                    $0i.push($0k[j]);
                }
            }
            ;
            return $0i;
        };
        $q.getChildrenCount = function($0g) {
            var $0l = 0;
            if (this.Children == null || this.Children.length <= 0 || $0g <= 1) {
                return 1;
            }
            ;
            for (var i = 0; i < this.Children.length; i++) {
                $0l += this.Children[i].getChildrenCount($0g - 1);
            }
            ;
            return $0l;
        };
        if ($q.Children) {
            this.activateColumnCollection($q.Children);
        }
    };

    this.activateColumnCollection = function(cc)
    {
        for (var i = 0; i < cc.length; i++)
        {
            this.activateColumn(cc[i]);
        }
        ;
        cc.getColumns = function($0g, $0h)
        {
            var $0i = [];
            for (var i = 0; i < this.length; i++)
            {
                var $0m = this[i].getChildren($0g, $0h);
                for (var j = 0; j < $0m.length; j++)
                {
                    $0i.push($0m[j]);
                }
            }
            ;
            return $0i;
        };
        cc.getColumnCount = function($0g)
        {
            var $0l = 0;
            for (var i = 0; i < this.length; i++)
            {
                $0l += this[i].getChildrenCount($0g);
            }
            ;
            return $0l;
        };
    };

    this.drawEventsAllDay = function()
    {
        if (!this.showAllDayEvents) {
            return;
        }
        ;
        var $0n = this.$("header");
        $0n.style.display = 'none';
        if (this.totalHeader)
        {
            var $0o = this.$("left");
            if ($0o)
            {
                $0o.style.height = this.totalHeader + "px";
            }
            ;
            var $0p = this.$("right");
            if ($0p)
            {
                $0p.style.height = this.totalHeader + "px";
            }
        }
        ;
        if (this.scrollUpTop && this.scrollDownTop)
        {
            var up = this.$("up");
            if (up)
            {
                up.style.top = this.scrollUpTop + "px";
            }
            ;
            var $09 = this.$("down");
            if ($09)
            {
                $09.style.top = this.scrollDownTop + "px";
            }
        }
        ;

        var l = $0n.rows[$t.headerLevels].cells.length;
        for (var i = 0; i < l; i++)
        {
            $0n.rows[$t.headerLevels].cells[i].firstChild.firstChild.innerHTML = '';
            $0n.rows[$t.headerLevels].cells[i].firstChild.style.height = this.allDayHeaderHeight + "px";
        }
        ;
        var l = this.eventsAllDay.length;
        for (var i = 0; i < l; i++)
        {
            var $C = this.eventsAllDay[i];
            var $I = document.createElement("div");
            $I.data = $C;
            $I.unselectable = 'on';
            $I.style.backgroundColor = this.eventBorderColor;
            $I.style.height = this.allDayEventHeight + 'px';
            $I.style.marginBottom = '2px';
            $I.style.position = 'relative';
            $I.style.textAlign = 'left';
            if ($C.ClickEnabled)
            {
                $I.onclick = this.eventClick;
            }
            ;
            $I.oncontextmenu = this.rightClick;
            if (this.bubble)
            {
                $I.onmouseout = function()
                {
                    $t.bubble.hideOnMouseOut();
                };
            }
            ;
            if (this.showToolTip)
            {
                $I.title = $C.ToolTip;
            }
            ;
            var $0q = [];
            $0q.push("<div unselectable='on' style='position:absolute;text-align:left;height:1px;font-size:1px;width:100%'><div unselectable='on' style='margin-top:2px;margin-left:4px;font-size:8pt;color:gray'>");
            $0q.push($C.LeftInnerHTML);
            $0q.push("</div></div>");
            $0q.push("<div unselectable='on' style='position:absolute;text-align:right;height:1px;font-size:1px;width:100%'><div unselectable='on' style='margin-top:2px;margin-right:4px;font-size:8pt;color:gray'>");
            $0q.push($C.RightInnerHTML);
            $0q.push("</div></div>");
            $0q.push("<div style='height:1px;line-height:1px;font-size:0px; width:1px;'><!-- --></div>");
            $0q.push("<div style='margin-top:0px;height:");
            $0q.push(this.allDayEventHeight - 2);
            $0q.push("px;background-color:");
            $0q.push($C.BackgroundColor);
            $0q.push(";border-left:1px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";border-right:1px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";overflow:hidden;text-align:left;font-size:");
            $0q.push(this.eventFontSize);
            $0q.push(";color:");
            $0q.push(this.eventFontColor);
            $0q.push(";font-family:");
            $0q.push(this.eventFontFamily);
            $0q.push("' unselectable='on'>");
            $0q.push("<div style='position:absolute;text-align:center;width:100%;overflow:hidden;height:");
            $0q.push(this.allDayEventHeight - 2);
            $0q.push("px;'>");
            $0q.push($C.InnerHTML);
            $0q.push("</div>");
            $0q.push("</div></div>");
            $I.innerHTML = $0q.join('');
            $0n.rows[$t.headerLevels].cells[$C.DayIndex].style.position = 'relative';
            $0n.rows[$t.headerLevels].cells[$C.DayIndex].firstChild.firstChild.appendChild($I);
            new DayPilotCalendar.Event($I, $t);
        }
        ;
        $0n.style.display = '';
    };

    this.drawEvents = function()
    {
        var $E = this.$('main');
        this.selectedEvents = [];
        var l = $E.rows[0].cells.length;
        for (var i = 0; i < l; i++)
        {
            $E.rows[0].cells[i].firstChild.innerHTML = '';
        }
        ;
        var l = this.events.length;
        for (var i = 0; i < l; i++)
        {
            var $C = this.events[i];
            var $I = document.createElement("div");
            $I.id = this.events[i].ServerId;
            $I.data = this.events[i];
            $I.unselectable = 'on';
            $I.style.MozUserSelect = 'none';
            $I.style.KhtmlUserSelect = 'none';
            $I.style.position = 'absolute';
            $I.style.fontFamily = this.eventFontFamily;
            $I.style.fontSize = this.eventFontSize;
            $I.style.color = this.eventFontColor;
            //$I.style.left = $C.Left + '%';
            $I.style.left = ($C.Left%100) + '%';
            $I.style.top = $C.Top + 'px';
            $I.style.width = $C.Width + '%';
            $I.style.height = Math.max($C.Height, 2) + 'px';
            $I.style.backgroundColor = "transparent";//this.eventBorderColor;
            $I.style.overflow = 'hidden';
            if ($C.ClickEnabled)
            {
                $I.onclick = this.eventClick;
            }
            ;
            if ($t.eventDoubleClickHandling != 'Disabled')
            {
                $I.ondblclick = this.eventDoubleClick;
            }
            ;
            $I.oncontextmenu = this.rightClick;
            if (this.bubble)
            {
                $I.onmouseout = function()
                {
                    $t.bubble.hideOnMouseOut();
                };
            }
            ;
            var $0q = [];

            $0q.push("<div unselectable='on' style='position:absolute; width:100%; height:100%;text-align:right;'>");

            if (this.eventDeleteHandling != 'Disabled' && $C.DeleteEnabled)
            {
                $0q.push("<img src='");
                $0q.push(this.deleteUrl);
                $0q.push("' width='12' height='13' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousemove=\"if(typeof(DayPilotBubble)!='undefined'&&");
                $0q.push(this.clientName);
                $0q.push(".bubble && ");
                $0q.push(this.clientName);
                $0q.push(".bubble.hideAfter > 0");
                $0q.push(") { DayPilotBubble.hideActive(); event.cancelBubble = true; };\" onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventDelete(this, event); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            }
            ;

            if (this.eventChangeStatusHandling != 'Disabled' && $I.data.BackgroundColor != '#C1DEA6' && $I.data.BackgroundColor != '#acadb1')
            {
                $0q.push("<br/><img src='img/check.png' width='12' height='13' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventChangeStatus(this); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            }
            ;

            if ($I.data.BackgroundColor != '#acadb1')
            {
                $0q.push("<br/><img src='Image/btn_trans.gif' width='10' height='10' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventTransaction(this, event); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            };

            $0q.push("</div>");
            $0q.push("<div style='height:0px;line-height:0px;font-size:0px; width:0px;'><!-- --></div>");
            $0q.push("<div");

            if (this.showToolTip)
            {
                $0q.push(" title='");
                $0q.push($C.ToolTip.replace("'", "&apos;"));
                $0q.push("'");
            }
            ;
            $0q.push(" class='");
            $0q.push(this.cssClass);
            $0q.push(" event'");
            $0q.push(" style='margin-top:0px;height:100%;");
//            $0q.push(Math.max($C.Height - 2, 0));
            $0q.push("background-color:"); //$0q.push("px;background-color:");
            $0q.push($C.BackgroundColor);
            $0q.push(";border-left:0px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";border-right:0px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";overflow:hidden;");
            if ($t.rtl)
            {
                $0q.push("direction:rtl;");
            }
            ;
            $0q.push("border: 0' unselectable='on'>");
            if (this.durationBarVisible)
            {
                $0q.push("<div style='position:absolute;left:0px;width:");
                $0q.push($t.durationBarWidth);
                $0q.push("px;height:100%;");
//                $0q.push($C.BarLength);
                if ($C.DurationBarImageUrl)
                {
                    $0q.push("background-image:url("); //$0q.push("px;background-image:url(");
                    $0q.push($C.DurationBarImageUrl);
                    $0q.push(");top:");
                }
                else if ($t.durationBarImageUrl)
                {
                    $0q.push("px;background-image:url(");
                    $0q.push($t.durationBarImageUrl);
                    $0q.push(");top:");
                }
                else
                {
                    $0q.push("px;top:");
                }
                ;
                $0q.push($C.BarStart + 1);
                $0q.push("px;background-color:");
                $0q.push($C.BarColor);
                $0q.push(";font-size:1px; border: 0' unselectable='on'></div><div style='position:absolute;left:");
                $0q.push($t.durationBarWidth);
                $0q.push("px;top:1px;width:0px;background-color:");
                $0q.push(this.eventBorderColor);
                $0q.push(";height:0; border: 0' unselectable='on'></div>");
            }
            ;
            if (this.durationBarVisible)
            {
                $0q.push("<div unselectable='on' style='padding-left:");
                $0q.push($t.durationBarWidth + 3);
                $0q.push("px;");
                $0q.push("'>");
            }
            else
            {
                $0q.push("<div unselectable='on' style='overflow:hidden;padding-left:5px;'>");
            }
            ;
            $0q.push($C.InnerHTML);
            $0q.push("</div></div>");
            $I.innerHTML = $0q.join('');
            if ($E.rows[0].cells[$C.DayIndex])
            {
                //var $0r = $E.rows[0].cells[$C.DayIndex].firstChild;
                //var row = $E.rows[0];
                //var cells = row.cells;
            	var $0r = this.getTdChild($E.rows[0].cells , $C.ide).firstChild;
                
                $0r.appendChild($I);
                var e = new DayPilotCalendar.Event($I, $t);
                if ($t.afterEventRender)
                {
                    $t.afterEventRender(e, $I);
                }
            }
        }
    };
    this.getTdChild = function(cells, dpcolumn){
    	for(var i=0; i<cells.length; i++){
    		var column = cells[i].getAttribute("dpColumn");
    		if(column/1==dpcolumn/1)
    			return cells[i];
    	}
    	return cells[0];
    };
    
    this.drawAroundEvents = function(eventCollectionResponse)
    {
        var $E = this.$('main');
        var AroundEvents = [];
        eval("AroundEvents = [" + eventCollectionResponse + "]");
        this.selectedEvents = [];
        var l = AroundEvents.length;
        for (var i = 0; i < l; i++)
        {
            var add = false;
            var $C = AroundEvents[i];
            var $I = document.getElementById($C.ServerId);
            if ($I == null) {
                $I = document.createElement("div");
                add = true;
            }
            $I.id = AroundEvents[i].ServerId;
            $I.data = AroundEvents[i];
            $I.unselectable = 'on';
            $I.style.MozUserSelect = 'none';
            $I.style.KhtmlUserSelect = 'none';
            $I.style.position = 'absolute';
            $I.style.fontFamily = this.eventFontFamily;
            $I.style.fontSize = this.eventFontSize;
            $I.style.color = this.eventFontColor;
            //$I.style.left = $C.Left + '%';
            $I.style.left = ($C.Left%100) + '%';
            $I.style.top = $C.Top + 'px';
            $I.style.width = $C.Width + '%';
            $I.style.height = Math.max($C.Height, 2) + 'px';
            $I.style.backgroundColor = "transparent";//this.eventBorderColor;
            $I.style.overflow = 'hidden';
            if ($C.ClickEnabled)
            {
                $I.onclick = this.eventClick;
            }
            ;
            if ($t.eventDoubleClickHandling != 'Disabled')
            {
                $I.ondblclick = this.eventDoubleClick;
            }
            ;
            $I.oncontextmenu = this.rightClick;
            if (this.bubble)
            {
                $I.onmouseout = function()
                {
                    $t.bubble.hideOnMouseOut();
                };
            }
            ;
            var $0q = [];

            $0q.push("<div unselectable='on' style='position:absolute; width:100%; height:100%;text-align:right;'>");

            if (this.eventDeleteHandling != 'Disabled' && $C.DeleteEnabled)
            {
                $0q.push("<img src='");
                $0q.push(this.deleteUrl);
                $0q.push("' width='12' height='13' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousemove=\"if(typeof(DayPilotBubble)!='undefined'&&");
                $0q.push(this.clientName);
                $0q.push(".bubble && ");
                $0q.push(this.clientName);
                $0q.push(".bubble.hideAfter > 0");
                $0q.push(") { DayPilotBubble.hideActive(); event.cancelBubble = true; };\" onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventDelete(this, event); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            }
            ;

            if (this.eventChangeStatusHandling != 'Disabled' && $I.data.BackgroundColor != '#C1DEA6' && $I.data.BackgroundColor != '#acadb1')
            {
                $0q.push("<br/><img src='img/check.png' width='12' height='13' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventChangeStatus(this); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            }
            ;

            if ($I.data.BackgroundColor != '#acadb1')
            {
                $0q.push("<br/><img src='Image/btn_trans.gif' width='10' height='10' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventTransaction(this, event); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            };

            $0q.push("</div>");
            $0q.push("<div style='height:0px;line-height:0px;font-size:0px; width:0px;'><!-- --></div>");
            $0q.push("<div");

            if (this.showToolTip)
            {
                $0q.push(" title='");
                $0q.push($C.ToolTip.replace("'", "&apos;"));
                $0q.push("'");
            }
            ;
            $0q.push(" class='");
            $0q.push(this.cssClass);
            $0q.push(" event'");
            $0q.push(" style='margin-top:0px;height:100%;");
//            $0q.push(Math.max($C.Height - 2, 0));
            $0q.push("background-color:"); //$0q.push("px;background-color:");
            $0q.push($C.BackgroundColor);
            $0q.push(";border-left:0px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";border-right:0px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";overflow:hidden;");
            if ($t.rtl)
            {
                $0q.push("direction:rtl;");
            }
            ;
            $0q.push("border: 0' unselectable='on'>");
            if (this.durationBarVisible)
            {
                $0q.push("<div style='position:absolute;left:0px;width:");
                $0q.push($t.durationBarWidth);
                $0q.push("px;height:100%;");
//                $0q.push($C.BarLength);
                if ($C.DurationBarImageUrl)
                {
                    $0q.push("background-image:url("); //$0q.push("px;background-image:url(");
                    $0q.push($C.DurationBarImageUrl);
                    $0q.push(");top:");
                }
                else if ($t.durationBarImageUrl)
                {
                    $0q.push("px;background-image:url(");
                    $0q.push($t.durationBarImageUrl);
                    $0q.push(");top:");
                }
                else
                {
                    $0q.push("px;top:");
                }
                ;
                $0q.push($C.BarStart + 1);
                $0q.push("px;background-color:");
                $0q.push($C.BarColor);
                $0q.push(";font-size:1px; border: 0' unselectable='on'></div><div style='position:absolute;left:");
                $0q.push($t.durationBarWidth);
                $0q.push("px;top:1px;width:0px;background-color:");
                $0q.push(this.eventBorderColor);
                $0q.push(";height:0; border: 0' unselectable='on'></div>");
            }
            ;
            if (this.durationBarVisible)
            {
                $0q.push("<div unselectable='on' style='padding-left:");
                $0q.push($t.durationBarWidth + 3);
                $0q.push("px;");
                $0q.push("'>");
            }
            else
            {
                $0q.push("<div unselectable='on' style='overflow:hidden;padding-left:5px;'>");
            }
            ;
            $0q.push($C.InnerHTML);
            $0q.push("</div></div>");
           
        	$I.innerHTML = $0q.join('');
            
            if (!add){
            	var old = document.getElementById($C.ServerId);
            	var parentElement = old.parentNode;
            	if(parentElement){
            		parentElement.removeChild(old);
            	}
            }
            
            if ($E.rows[0].cells[$C.DayIndex])
            {
                // var $0r = $E.rows[0].cells[$C.DayIndex].firstChild;
            	var $0r = this.getTdChild($E.rows[0].cells , $C.ide).firstChild;
                $0r.appendChild($I);
                var e = new DayPilotCalendar.Event($I, $t);
                if ($t.afterEventRender)
                {
                    $t.afterEventRender(e, $I);
                }
            }
            
        }
    };

    this.addNewEvents = function(eventCollectionResponse)
    {
        var addEvents = [];
        eval("addEvents = [" + eventCollectionResponse + "]");
        this.selectedEvents = [];

        var l = addEvents.length;
        for (var i = 0; i < l; i++)
        {
            var $C = addEvents[i];
            var $I = document.createElement("div");
            $I.id = addEvents[i].ServerId;
            $I.data = addEvents[i];
            $I.unselectable = 'on';
            $I.style.MozUserSelect = 'none';
            $I.style.KhtmlUserSelect = 'none';
            $I.style.position = 'absolute';
            $I.style.fontFamily = this.eventFontFamily;
            $I.style.fontSize = this.eventFontSize;
            $I.style.color = this.eventFontColor;
            $I.style.left = $C.Left + '%';
            $I.style.top = $C.Top + 'px';
            $I.style.width = $C.Width + '%';
            $I.style.height = Math.max($C.Height, 2) + 'px';
            $I.style.backgroundColor = "transparent";//this.eventBorderColor;
            $I.style.overflow = 'hidden';
            if ($C.ClickEnabled)
            {
                $I.onclick = this.eventClick;
            }
            ;
            if ($t.eventDoubleClickHandling != 'Disabled')
            {
                $I.ondblclick = this.eventDoubleClick;
            }
            ;
            $I.oncontextmenu = this.rightClick;
            if (this.bubble)
            {
                $I.onmouseout = function()
                {
                    $t.bubble.hideOnMouseOut();
                };
            }
            ;
            var $0q = [];

            $0q.push("<div unselectable='on' style='position:absolute; width:100%; height:100%;text-align:right;'>");

            if (this.eventDeleteHandling != 'Disabled' && $C.DeleteEnabled)
            {
                $0q.push("<img src='");
                $0q.push(this.deleteUrl);
                $0q.push("' width='12' height='13' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousemove=\"if(typeof(DayPilotBubble)!='undefined'&&");
                $0q.push(this.clientName);
                $0q.push(".bubble && ");
                $0q.push(this.clientName);
                $0q.push(".bubble.hideAfter > 0");
                $0q.push(") { DayPilotBubble.hideActive(); event.cancelBubble = true; };\" onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventDelete(this, event); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            }
            ;

            if (this.eventChangeStatusHandling != 'Disabled' && $I.data.BackgroundColor != '#C1DEA6' && $I.data.BackgroundColor != '#acadb1')
            {
                $0q.push("<br/><img src='img/check.png' width='12' height='13' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventChangeStatus(this); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            }
            ;

            if ($I.data.BackgroundColor != '#acadb1')
            {
                $0q.push("<br/><img src='Image/btn_trans.gif' width='10' height='10' style='margin-right:2px; margin-top: 2px; cursor:pointer;' onmousedown=\"this.parentNode.parentNode.style.cursor='default';\" onclick='");
                $0q.push(this.clientName);
                $0q.push(".eventTransaction(this, event); event.cancelBubble = true; if (event.stopPropagation) event.stopPropagation();' />");
            };

            $0q.push("</div>");
            $0q.push("<div style='height:0px;line-height:0px;font-size:0px; width:0px;'><!-- --></div>");
            $0q.push("<div");

            if (this.showToolTip)
            {
                $0q.push(" title='");
                $0q.push($C.ToolTip.replace("'", "&apos;"));
                $0q.push("'");
            }
            ;
            $0q.push(" class='");
            $0q.push(this.cssClass);
            $0q.push(" event'");
            $0q.push(" style='margin-top:0px;height:100%;");
//            $0q.push(Math.max($C.Height - 2, 0));
            $0q.push("background-color:"); //$0q.push("px;background-color:");
            $0q.push($C.BackgroundColor);
            $0q.push(";border-left:0px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";border-right:0px solid ");
            $0q.push(this.eventBorderColor);
            $0q.push(";overflow:hidden;");
            if ($t.rtl)
            {
                $0q.push("direction:rtl;");
            }
            ;
            $0q.push("border: 0' unselectable='on'>");
            if (this.durationBarVisible)
            {
                $0q.push("<div style='position:absolute;left:0px;width:");
                $0q.push($t.durationBarWidth);
                $0q.push("px;height:100%;");
//                $0q.push($C.BarLength);
                if ($C.DurationBarImageUrl)
                {
                    $0q.push("background-image:url("); //$0q.push("px;background-image:url(");
                    $0q.push($C.DurationBarImageUrl);
                    $0q.push(");top:");
                }
                else if ($t.durationBarImageUrl)
                {
                    $0q.push("px;background-image:url(");
                    $0q.push($t.durationBarImageUrl);
                    $0q.push(");top:");
                }
                else
                {
                    $0q.push("px;top:");
                }
                ;
                $0q.push($C.BarStart + 1);
                $0q.push("px;background-color:");
                $0q.push($C.BarColor);
                $0q.push(";font-size:1px; border: 0' unselectable='on'></div><div style='position:absolute;left:");
                $0q.push($t.durationBarWidth);
                $0q.push("px;top:1px;width:0px;background-color:");
                $0q.push(this.eventBorderColor);
                $0q.push(";height:0; border: 0' unselectable='on'></div>");
            }
            ;
            if (this.durationBarVisible)
            {
                $0q.push("<div unselectable='on' style='padding-left:");
                $0q.push($t.durationBarWidth + 3);
                $0q.push("px;");
                $0q.push("'>");
            }
            else
            {
                $0q.push("<div unselectable='on' style='overflow:hidden;padding-left:5px;'>");
            }
            ;
            $0q.push($C.InnerHTML);
            $0q.push("</div></div>");
            $I.innerHTML = $0q.join('');
            var mainCalendar_events = document.getElementById("mainCalendar_events");
            mainCalendar_events.firstChild.firstChild.innerHTML += $I;
//            document.getElementById($C.ServerId).innerHTML = $I;
//            if ($E.rows[0].cells[$C.DayIndex])
//            {
//                var $0r = $E.rows[0].cells[$C.DayIndex].firstChild;
//                $0r.appendChild($I);
//                var e = new DayPilotCalendar.Event($I, $t);
//                if ($t.afterEventRender)
//                {
//                    $t.afterEventRender(e, $I);
//                }
//            }
        }
    };

    this.drawTable = function()
    {
        var $04 = this.$('main');
        var $Q = $t.stepMs;
        var $L = $t.startMs;
        var end = $t.endMs;
        $t.cellHeight = 22;
        DayPilotCalendar.selectedCells = [];
        var $0s = [];
        var $0t = [];
        var $0u = $t.columns.getColumns($t.headerLevels, true);
        var $0v = !this.tableCreated || $0u.length != $04.rows[0].cells.length;
        while ($04 && $04.rows && $04.rows.length > 0 && $0v)
        {
            $04.deleteRow(0);
        }
        ;
        this.tableCreated = true;
        var r = ($0v) ? $04.insertRow(-1) : $04.rows[0];
        if ($0v)
        {
            r.style.backgroundColor = 'white';
            r.id = this.id + "_events";
        }
        ;
        var cl = $0u.length;
        for (var j = 0; j < cl; j++)
        {
            var c = ($0v) ? r.insertCell(-1) : r.cells[j];
            if ($0v)
            {
                c.style.height = '1px';
                if (!$t.rtl)
                {
                    c.style.textAlign = 'left';
                }
                ;
                var w = $0u[j].Width;
                c.style.width = w + (($t.widthUnit == 'Pixel' || w == 0) ? "px" : "%");
                var $I = document.createElement("div");
                $I.style.display = 'block';
                $I.style.marginRight = $t.columnMarginRight + "px";
                $I.style.position = 'relative';
                $I.style.height = '1px';
                $I.style.fontSize = '1px';
                $I.style.lineHeight = '1.2';
                $I.style.marginTop = '-1px';
                c.appendChild($I);
            }
            ;
            c.setAttribute("dpColumnDate", $0u[j].Date);
            c.setAttribute("dpColumn", $0u[j].Value);
        }
        ;
        for (var i = $L; i < end; i += $Q)
        {
            var $0w = (i - $L) / $Q;
            var r = ($0v) ? $04.insertRow(-1) : $04.rows[$0w + 1];
            if ($0v)
            {
                r.style.MozUserSelect = 'none';
                r.style.KhtmlUserSelect = 'none';
            }
            ;
            for (var j = 0; j < cl; j++)
            {
                var c = ($0v) ? r.insertCell(-1) : r.cells[j];
                if ($0v)
                {
                    c.style.verticalAlign = 'bottom';
                    c.start = i;
                    c.end = i + $Q;
                    c.root = this;
                    c.onmousedown = this.mousedown;
                    c.onmousemove = this.mousemove;
                    c.onmouseout = this.cellMouseOut;
                    c.onmouseup = function() {
                        return false;
                    };
                    c.onclick = function() {
                        return false;
                    };
                    c.oncontextmenu = function()
                    {
                        if (!this.selected && ($t.timeRangeSelectedHandling == 'Hold' || $t.timeRangeSelectedHandling == 'HoldForever'))
                        {
                            if (DayPilotCalendar.selectedCells)
                            {
                                $t.cleanSelection();
                                DayPilotCalendar.selectedCells = [];
                            }
                            ;
                            DayPilotCalendar.column = DayPilotCalendar.getColumn(this);
                            DayPilotCalendar.selectedCells.push(this);
                            DayPilotCalendar.firstSelected = this;
                            DayPilotCalendar.topSelectedCell = this;
                            DayPilotCalendar.bottomSelectedCell = this;
                            $t.activateSelection();
                        }
                        ;
                        if ($t.contextMenuSelection)
                        {
                            $t.contextMenuSelection.show($t.getSelection());
                        }
                        ;
                        return false;
                    };
                    c.style.fontSize = '1px';
                    $t.borderColor = '#B3B4B7';
                    if ((!$t.rtl && j !== cl - 1) || $t.rtl)
                    {
                        c.style.borderRight = '1px solid ' + $t.borderColor;
                    }
                    ;
                    c.style.height = $t.cellHeight + 'px';
                    c.unselectable = 'on';
                    var $I = document.createElement("div");
                    $I.unselectable = 'on';
                    $I.style.width = '100%';
                    $I.style.fontSize = '1px';
                    $I.style.height = '1px';
                    var $0x = ((i + $Q) % 3600000 > 0);

                    if ($0x)
                    {
                        if($t.colors[$0w][j] == '#ACACAE')
                        {
                            $t.customHourHalfBorderColor = '#4D4C4D';
                            $t.hourHalfBorderColor = '#A7A7A8';
                        }
                        else{
                            $t.customHourHalfBorderColor = '#4D4C4D';
                            $t.hourHalfBorderColor = '#adaeaf';
                        }
                        if ((i + $Q) % 1800000 == 0) {
                            if ($t.customHourHalfBorderColor != '')
                            {
                                $I.style.borderBottom = '2px solid ' + $t.customHourHalfBorderColor;
                            }
                            ;
                        } else {
                            if ($t.hourHalfBorderColor != '')
                            {
                                $I.style.borderBottom = '1px solid ' + $t.hourHalfBorderColor;
                            }
                            ;
                        }
                        $I.className = $t.cssClass + " hourhalfcellborder";
                    }
                    else
                    {
                        $t.hourBorderColor = '#4D4C4D';
                        if ($t.hourBorderColor != '')
                        {
                            $I.style.borderBottom = '2px solid ' + $t.hourBorderColor;
                        }
                        ;
                        $I.className = $t.cssClass + " hourcellborder";
                    }
                    ;
                    c.appendChild($I);
                }
                ;
                //alert('set original color ' + $t.colors[$0w][j] + ' ; ' + $0w + ' - ' + j);
                c.originalColor = $t.colors[$0w][j];//"#E2E3E4";
                c.className = $t.cssClass + " cellbackground";
                c.style.backgroundColor = c.originalColor;

                if (c.originalColor == '#ACACAE'){
                    c.style.backgroundImage="url(img/break_bg.png)";
                    c.ondblclick = function()
                    {
                        if(!isAdmin)
                            return;
                        var t = (this.start/1000/60/60 + this.end/1000/60/60) / 2;
                        var th = Math.floor(t);
                        var tm = Math.floor((t - th)*60);
                        var $08 = $t.getSelection();
                        var emp_id = $08.resource;
                        var date = new Date($08.start.toGMTString());
                        var dy = date.getFullYear();
                        var dm = date.getUTCMonth() + 1;
                        var dd = date.getUTCDate();
                        var dd2 = date.getUTCDay();
                        if(emp_id == 0)
                            return;
//                        alert(dy + "/" + dm + "/" + dd + " " + th + ":" + tm + " " + emp_id);
                        window.open("breakRedirect.do?date=" + urlencode(dy + "/" + dm + "/" + dd) +
                                    "&timeh=" + th +
                                    "&timem=" + tm +
                                    "&day=" + dd2 +
                                    "&emp_id=" + emp_id,"Window1", "");
//                        var $08 = $t.getSelection();
//                        $t.timeRangeDoubleClick($08.start, $08.end, $08.resource);

                    };

                }
                if (c.originalColor == '#ACACAE' && $t.comment[$0w][j] != 'null' && $t.comment[$0w][j] != null) {
                    c.title = $t.comment[$0w][j];
                    c.showToolTip = true;
                }
            }
        }
        ;
        $04.onmouseup = this.mouseup;
        $04.root = this;
        var scroll = $t.$("scroll");
        
        $04.onmousemove = function(ev)
        {
            DayPilotCalendar.activeCalendar = this;
            var $0y = $t.$("scroll");
            $t.coords = DayPilot.mo2($0y, ev);

            ev = ev || window.event;
            var $f = DayPilot.mc(ev);

            //silviu
            if (DayPilotCalendar.dragFromOutside == true)
            {
                if (!$t.coords)
                {
                    return;
                }
                ;
                var $0z = $t.cellHeight;
                var $G = 1;
                var $01 = DayPilotCalendar.moveOffsetY;
                if (!$01)
                {
                    $01 = $0z / 2;
                }
                ;
                var $0D = Math.floor((($t.coords.y - $01 - $G) + $0z / 2) / $0z) * $0z + $G;
                if ($0D < $G)
                {
                    $0D = $G;
                }
                ;
                var $E = $t.$("main");


                var $0C = $E.clientHeight;

                var $F = $E.clientWidth / 8;//$E.rows[0].cells.length;                //   !!! 8 = rows count in table
                var $q = Math.floor(($t.coords.x - 45) / $F);

                var i = ($0D - 1) / $t.cellHeight;

//                alert(i + " "+ $q);
//                alert(__colors[i][$q]);                                        //color of current selected cell!!!

                //try {
                    //if($0D>=$t.columns[$q].HFrom*20+1 && $0D<$t.columns[$q].HTo*20+1 && $0D+21<$t.columns[$q].HTo*20){
                    if ($t.colors[i][$q] != "#ACACAE" /*&& $t.colors[i + 1][$q] != "#ACACAE"*/) {
                        document.body.style.cursor = 'move';
                        DayPilotCalendar.moving = null;
                        DayPilotCalendar.removeShadow(null, DayPilotCalendar.movingShadow);
                        DayPilotCalendar.movingShadow = null;
                        if (!DayPilotCalendar.movingShadow)
                        {
                            DayPilotCalendar.movingShadow = DayPilotCalendar.createGShadow();
                        }
                        ;
                        DayPilotCalendar.movingShadow.style.top = $0D + 'px';
                        DayPilotCalendar.movingShadow.style.height = '16px';

                        if ($q < 8 && $q >= 0)//$E.rows[0].cells.length&&$q>=0)//
                        {
                            DayPilotCalendar.moveShadow($E.rows[0].cells[$q]);
                        }
                        ;
                        if (!$t.allowEventOverlap)
                        {
                            $t.overlap = $t.isOverlapping($q);
                            if ($t.overlap)
                            {
                                document.body.style.cursor = 'not-allowed';
                            }
                            else
                            {
                                document.body.style.cursor = 'move';
                            }
                        }
                    }
//                } catch(e) {
//                }
            }
            //end silviu

            if (DayPilotCalendar.resizing)
            {
                var $0z = DayPilotCalendar.resizing.event.root.cellHeight;
                var $G = 1;
                var $0A = ($f.y - DayPilotCalendar.originalMouse.y);
                var $E = $t.$("main");
                var $0C = $E.clientHeight;
                var $F = $E.clientWidth / 8;//$E.rows[0].cells.length;                //   !!! 8 = rows count in table
                var $q = Math.floor(($t.coords.x - 45) / $F);
                if (DayPilotCalendar.resizing.dpBorder === 'bottom')
                {
                    var $0B = Math.floor(((DayPilotCalendar.originalHeight + DayPilotCalendar.originalTop + $0A) + $0z / 2) / $0z) * $0z - DayPilotCalendar.originalTop + $G;
                    var i = (DayPilotCalendar.originalTop + $0B - 1) / $t.cellHeight;
                    if ($0B < $0z)$0B = $0z;
                    var $0C = DayPilot.$(DayPilotCalendar.resizing.event.root.id + "_main").clientHeight;
                    if (DayPilotCalendar.originalTop + $0B > $0C)
                        $0B = $0C - DayPilotCalendar.originalTop;
                    //if (DayPilotCalendar.originalTop+$0B<$t.columns[$q].HTo*20+1)
                    if ($t.colors[i - 1][$q] != "#ACACAE")
                        DayPilotCalendar.resizingShadow.style.height = ($0B - 4) + 'px';
                    //else DayPilotCalendar.resizingShadow.style.height=($t.columns[$q].HTo*20+1-DayPilotCalendar.originalTop)+'px';
                }
                else
                    if (DayPilotCalendar.resizing.dpBorder === 'top')
                    {
                        var $0D = Math.floor(((DayPilotCalendar.originalTop + $0A - $G) + $0z / 2) / $0z) * $0z + $G;
                        if ($0D < $G)
                        {
                            $0D = $G;
                        }
                        ;
                        var $0B = DayPilotCalendar.originalHeight - ($0D - DayPilotCalendar.originalTop);
                        var i = ($0D - 1) / $t.cellHeight;
                        //if ($0D>$t.columns[$q].HFrom*20+1){
                        if ($t.colors[i][$q] != "#ACACAE") {
                            if ($0B < $0z)
                            {
                                $0B = $0z;
                            }
                            else
                            {
                                DayPilotCalendar.resizingShadow.style.top = $0D + 'px';
                            }
                            ;
                            DayPilotCalendar.resizingShadow.style.height = ($0B - 4) + 'px';
                        }
                        /*else {
                         DayPilotCalendar.resizingShadow.style.top=($t.columns[$q].HFrom*20+1)+'px';
                         DayPilotCalendar.resizingShadow.style.height=(DayPilotCalendar.originalHeight-$t.columns[$q].HFrom*20+1)+'px';
                         }*/

                    }
                ;
                if (!$t.allowEventOverlap)
                {
                    $t.overlap = $t.isOverlapping();
                    if ($t.overlap)
                    {
                        document.body.style.cursor = 'not-allowed';
                    }
                    else
                    {
                        document.body.style.cursor = 'n-resize';
                    }
                }
            }
            else if (DayPilotCalendar.moving)
            {
                if (!$t.coords)
                {
                    return;
                }
                ;
                var $0z = $t.cellHeight;
                var $G = 1;
                var $01 = DayPilotCalendar.moveOffsetY;
                if (!$01)
                {
                    $01 = $0z / 2;
                }
                ;
                var $0D = Math.floor((($t.coords.y - $01 - $G) + $0z / 2) / $0z) * $0z + $G;
                if ($0D < $G)
                {
                    $0D = $G;
                }
                ;
                var $E = $t.$("main");
                var $0C = $E.clientHeight;
                var $F = $E.clientWidth / 8;//$E.rows[0].cells.length;//
                var $q = Math.floor(($t.coords.x - 45) / $F);
                var i = ($0D - 1) / $t.cellHeight;
                var j = ($0D + DayPilotCalendar.moving.clientHeight - 1) / $t.cellHeight;
                //alert(i+ "  "+ j);
                // if($0D>=$t.columns[$q].HFrom*20+1 && $0D<$t.columns[$q].HTo*20+1 && $0D+DayPilotCalendar.moving.clientHeight<=$t.columns[$q].HTo*20+1){
                if ($t.colors[i][$q] != "#ACACAE" /*&& $t.colors[j - 1][$q] != "#ACACAE"*/) {
                    if ($0D + DayPilotCalendar.moving.clientHeight > $0C)
                    {
                        $0D = $0C - DayPilotCalendar.moving.clientHeight;
                    }
                    ;
                    DayPilotCalendar.movingShadow.style.top = $0D + 'px';

                    if ($q < 8 && $q >= 0)//$E.rows[0].cells.length&&$q>=0)//
                    {
                        DayPilotCalendar.moveShadow($E.rows[0].cells[$q]);
                    }
                    ;
                    if (!$t.allowEventOverlap)
                    {
                        $t.overlap = $t.isOverlapping($q);
                        if ($t.overlap)
                        {
                            document.body.style.cursor = 'not-allowed';
                        }
                        else
                        {
                            document.body.style.cursor = 'move';
                        }
                    }
                }
            }
            ;
            if (DayPilotCalendar.drag)
            {
                if (DayPilotCalendar.gShadow)
                {
                    document.body.removeChild(DayPilotCalendar.gShadow);
                }
                ;
                DayPilotCalendar.gShadow = null;
                if (!DayPilotCalendar.movingShadow && $t.coords)
                {
                    DayPilotCalendar.movingShadow = $t.createShadow(DayPilotCalendar.drag.duration);
                    DayPilotCalendar.moving = {};
                    DayPilotCalendar.moving.event = new DayPilot.Event(DayPilotCalendar.drag.id, DayPilotCalendar.drag.duration, DayPilotCalendar.drag.text);
                    DayPilotCalendar.moving.event.root = $t;
                }
                ;
                ev.cancelBubble = true;
            }
        };
        var $0q = DayPilot.$(this.id + '_scroll').firstChild;
        var $0E = $0q;
        while ($0E.tagName !== "TABLE")
            $0E = $0E.nextSibling;
        $0E.style.display = '';
        $0E = $0q;
        while ($0E.tagName !== "DIV")
            $0E = $0E.nextSibling;
        $0E.style.display = 'none';
        
        //mobile
        var _this = this;
        if(isMobile()){
        	jQuery("#mainCalendar_main td").droppable({
        		drop: function( event, ui ) {
        			var currTdIndex = jQuery( this ).index();
        			var infoTd = jQuery("#mainCalendar_events td")[currTdIndex];
        			
            		var baseDateObj = infoTd.getAttribute("dpcolumndate");
            		var baseDate = new Date(baseDateObj);
        			
        			var start = new Date(baseDate.getTime()+this.start);
        			var end = new Date(baseDate.getTime()+this.end);
        			var column = infoTd.getAttribute("dpcolumn");
        			
        			var dateTime = new Date(start);
        			var dateEndTime = new Date(end); //_from init for ScheduleMain.jsp
        			var intTime = (dateTime.getUTCHours() - _from) * 4 + dateTime.getUTCMinutes() / 15;           // for esalonsoft/vogue
        			var intEndTime = (dateEndTime.getUTCHours() - _from) * 4 + dateEndTime.getUTCMinutes() / 15;  // for esalonsoft/vogue
        			if (DayPilotCalendar._this.colors[intTime][currTdIndex] != "#ACACAE") {
        				if (DayPilotCalendar._this.colors[intTime + 1][currTdIndex] == "#ACACAE"){
        					DayPilotCalendar.dragUnderEnd = true;
        				} else {
        					DayPilotCalendar.dragUnderEnd = false;
        				}
        			}
        			
        			DayPilotCalendar.dragFromOutsideStart = start;
        			DayPilotCalendar.dragFromOutsideEnd = end;
        			DayPilotCalendar.dragFromOutsideColumn = column;
        			DayPilotCalendar.dragFromOutside = false;
        			
        			DayPilotCalendar.saveAppointment(start, end, column, null);
                    jQuery("#ServiceControlClone").css("display", "none");
        		}
        	});
        }
    };

    this.drawHeaderRow = function($0g, $0v) {
        var r = ($0v) ? this.header.insertRow(-1) : this.header.rows[$0g - 1];
        var r_footer = ($0v) ? this.footer.insertRow(-1) : this.footer.rows[$0g - 1];
        var $0u = this.columns.getColumns($0g, false);
        var $0F = $0u.length;

        for (var i = 0; i < $0F; i++) {
            var $C = $0u[i];
            var $0G = $C.getChildren ? true : false;
            var $a = ($0v) ? r.insertCell(-1) : r.cells[i];
            var $a_footer = ($0v) ? r_footer.insertCell(-1) : r_footer.cells[i];
            $a.data = $C;
//            $a.className = 'schedule_header_names_control';
//            $a.innerHTML = '<img src="img/names_frame.png" class="frame" />' +
//                            '<img src="img/photo.png" class="photo" />' +
//                            '<div class="name">' + $C.InnerHTML.replace(/(<([^>]+)>)/ig,"") + '</div>'

            var w = $C.Width;

            if ($0g == $t.headerLevels) {
                if (w) {
                    $a.style.width = w + (($t.widthUnit == 'Pixel' || w == 0) ? "px" : "%");
                    $a_footer.style.width = w + (($t.widthUnit == 'Pixel' || w == 0) ? "px" : "%");
                }
                else {
                    $a.style.width = Math.floor(100 / $0u.length) + "%";
                    $a_footer.style.width = Math.floor(100 / $0u.length) + "%";
                }
            }
            else {
                var $0H = 1;
                if ($0G) {
                    $0H = $C.getChildrenCount($t.headerLevels - $0g + 1);
                }
                $a.colSpan = $0H;
                $a_footer.colSpan = $0H;
            }
            if ($0G) {
                $a.onclick = this.headerClick;
                $a.onmousemove = this.headerMouseMove;
                $a.onmouseout = this.headerMouseOut;
                $a_footer.onclick = this.headerClick;
                $a_footer.onmousemove = this.headerMouseMove;
                $a_footer.onmouseout = this.headerMouseOut;
                if ($C.ToolTip) {
                    $a.title = $C.ToolTip;
                    $a_footer.title = $C.ToolTip;
                }
            }
            $a.style.overflow = 'hidden';
            $a.style.lineHeight = '1.2';

            if ($0G) {
                $a.className = 'schedule_header_names_control';
                $a.unselectable = 'on';
                $a.style.MozUserSelect = 'none';
                $a_footer.style.height = '21px';
                if($C.InnerHTML.replace(/(<([^>]+)>)/ig,"").replace(/(^\s+)|(\s+$)/g, "") != ''){
                    $a.innerHTML = '<img src="img/names_frame.png" class="frame" />' +
                                    '<img src="admin/ShowPhoto.do?id=' + $C.Value + '" class="photo" />' +
//                                    '<div class="name">' + $C.InnerHTML.replace(/(<([^>]+)>)/ig,"") + '</div>';
                                    '<div class="name"><img src="image?t=' + urlencode($C.InnerHTML.replace(/(<([^>]+)>)/ig,"")) + '&fs=12&c=FFFFFF" /></div>';
//                    $a_footer.innerHTML = $C.InnerHTML.replace(/(<([^>]+)>)/ig,"");
                    $a_footer.innerHTML = '<img src="image?t=' + urlencode($C.InnerHTML.replace(/(<([^>]+)>)/ig,"")) + '&fs=12&c=FFFFFF" />';
                }else{
                    $a.innerHTML = '';
                    $a_footer.innerHTML = '';
                }

            }
        }
    }

    this.drawHeaderCommentRow = function($0g, $0v) {
        var r = ($0v) ? this.headerComment.insertRow(-1) : this.headerComment.rows[$0g - 1];
        var $0u = this.columns.getColumns($0g, false);
        var $0F = $0u.length;
        for (var i = 0; i < $0F; i++) {
            var $C = $0u[i];
            var $0G = $C.getChildren ? true : false;
            var $a = ($0v) ? r.insertCell(-1) : r.cells[i];
            $a.data = $C;
            var w = $C.Width;
            var q = 1;

            if ($0g == $t.headerLevels) {
                if (w) {
                    $a.style.width = w + (($t.widthUnit == 'Pixel' || w == 0) ? "px" : "%");
                }
                else {
                    $a.style.width = Math.floor(100 / $0u.length) + "%";
                    q = 10;
                }
                if(w>20)
                    q = 10;
            }
            else {
                var $0H = 1;
                if ($0G) {
                    $0H = $C.getChildrenCount($t.headerLevels - $0g + 1);
                }
                $a.colSpan = $0H;
                q = $0H;
            }
            $a.style.overflow = 'hidden';
            $a.style.lineHeight = '1.2';
            var $I = ($0v) ? document.createElement("div") : $a.firstChild;
            var $o = ($0v) ? document.createElement("div") : $I.firstChild;
            if ($0v) {
                $I.unselectable = 'on';
                $I.style.MozUserSelect = 'none';
                /*if ($C.EmpComment != null) {
                    $I.style.backgroundColor = $C.BackColor;
                    if ($t.rtl) {
                        if (i == $0F - 1) {
                            $I.style.borderLeft = "1px solid " + $C.BackColor;
                        }
                        else {
                            $I.style.borderLeft = "1px solid " + this.borderColor;
                        }
                    }
                    else {
                        if (i == $0F - 1) {
                            $I.style.borderRight = "1px solid " + $C.BackColor;
                        }
                        else {
                            $I.style.borderRight = "1px solid " + this.borderColor;
                        }
                    }
                } else {
                    $I.style.backgroundColor = this.borderColor;
                }  */
                //$I.className = $t.cssClass + ' header';
                $I.style.cursor = 'default';
                $I.style.position = 'relative';
                $I.style.height = '20px';
                $I.style.fontFamily = this.headerFontFamily;
                $I.style.fontSize = '7pt';//this.headerFontSize;
                $I.style.color = this.headerFontColor;
                if ($0g != 1) {
                    $I.style.borderTop = '1px solid ' + this.borderColor;
                }

                //$I.style.height = this.headerHeight + "px";
                var $o = document.createElement("div");
                $o.style.position = 'absolute';
                $o.style.left = '0px';
                $o.style.width = '100%';
                $o.style.height = '20px';
                $o.style.padding = "0";
                $I.style.textAlign = 'center';
                $o.unselectable = 'on';
                $I.appendChild($o);
                $a.appendChild($I);
            }
            var str = '';
            if(q == 1)
                str += '<img src="img/comments_box.png" width="100%" height="20" />'
            if ($0G && $C.EmpComment != null) {
                str += '<div style="position:relative; z-index: 3; top: -20px; padding: 2px">'+$C.EmpComment+'</div>';
            }
            $o.innerHTML = str;
            $o.empId = $C.EmpId;
            $o.ondblclick = function(){
                   window.location.href = "admin/edit_employee.jsp?action=edit&id=" + this.empId;
            }
        }
    }

    this.drawHeader = function()
    {
        if (!this.showHeader) {
            return;
        }
        ;
        var $0n = this.$("header");
        var footer = document.getElementById("mainCalendar_header_bottom");
        //var $0n1 = this.$("header_bottom");
        this.headerComment = this.$("header_bottom_comment");
        //this.headerComment.innerHTML = '';
        //$0n.innerHTML = '';
        //footer.innerHTML = '';

        var $0v = true;
        var $0u = this.columns.getColumns($t.headerLevels, true);
        var $0F = $0u.length;
        if (this.headerCreated && $0n && $0n.rows && $0n.rows.length > 0)
        {
            $0v = $0n.rows[$0n.rows.length - 1].cells.length != $0F;
        }
        while (this.headerCreated && $0n && $0n.rows && $0n.rows.length > 0 && $0v)
        {
            $0n.deleteRow(0);
            this.headerComment.deleteRow(0);
            footer.deleteRow(0);
        }

        this.headerCreated = true;
        this.header = $0n;
        this.footer = footer;

        for (var i = 0; i < $t.headerLevels; i++) {
            this.drawHeaderRow(i + 1, $0v);
            this.drawHeaderCommentRow(i + 1, $0v);
        }

        if (!this.showAllDayEvents) {
            return;
        }
        ;
        /*var r = ($0v) ? $0n.insertRow(-1) : $0n.rows[$t.headerLevels];
        for (var i = 0; i < $0F; i++)
        {
            var $C = $0u[i];
            var $a = ($0v) ? r.insertCell(-1) : r.cells[i];
            $a.data = $C;
            var w = $C.Width;
            $a.style.width = w + (($t.widthUnit == 'Pixel' || w == 0) ? "px" : "%");
            $a.style.overflow = 'hidden';
            $a.style.lineHeight = '1.2';
            var $I = ($0v) ? document.createElement("div") : $a.firstChild;
            if ($0v)
            {
                $I.unselectable = 'on';
                $I.style.MozUserSelect = 'none';
                $I.style.display = 'block';
                $I.style.textAlign = 'center';
                $I.style.backgroundColor = $C.BackColor;
                $I.style.cursor = 'default';
                $I.style.borderTop = '1px solid ' + this.borderColor;
                if ($t.rtl)
                {
                    if (i == $0F - 1)
                    {
                        $I.style.borderLeft = "1px solid " + $C.BackColor;
                    }
                    else
                    {
                        $I.style.borderLeft = "1px solid " + this.borderColor;
                    }
                }
                else
                {
                    if (i == $0F - 1)
                    {
                        $I.style.borderRight = "1px solid " + $C.BackColor;
                    }
                    else
                    {
                        $I.style.borderRight = "1px solid " + this.borderColor;
                    }
                }
                ;
                $I.style.overflow = 'hidden';
                var $o = document.createElement("div");
                $o.style.paddingLeft = "2px";                                                                                                     k
                $o.style.paddingRight = "2px";
                $o.style.paddingTop = "2px";
                $o.unselectable = 'on';
                $I.appendChild($o);
                $a.appendChild($I);
            }
            ;
            $I.style.height = this.allDayHeaderHeight + "px";
        }*/
        //$0n1.innerHTML = this.header.innerHTML;
    };
    this.enableScrolling = function() {
        var $0I = DayPilot.$(id + '_scroll');
        if (this.initScrollPos === null)return;
        $0I.root = this;
        $0I.onscroll = this.scroll;
        if ($0I.scrollTop === 0) {
            $0I.scrollTop = this.initScrollPos;
        } else {
            this.scroll();
        }
    };
    this.callbackError = function($r, $s) {
        alert("Error!\r\nResult: " + $r + "\r\nContext:" + $s);
    };
    this.spaceIt = function() {
        var tr = this.$("events");
        for (var i = 0; i < tr.cells.length; i++) {
            var $I = tr.cells[i].firstChild;
            while ($I.tagName !== "DIV") {
                $I = $I.nextSibling;
            }
            ;
            var $0J = document.createElement('div');
            $0J.style.position = 'absolute';
            $0J.style.width = $I.clientWidth + 'px';
            $0J.style.height = '1px';
            $I.appendChild($0J);
        }
    };
    this.fixScrollHeader = function() {
        var w = DayPilotCalendar.getScrollWidth(this);
        var d = this.$("right");
        if (d && w > 0) {
            d.style.width = (w - 1) + 'px';
        }
    };

    this.registerGlobalHandlers = function()
    {
        if (!DayPilotCalendar.globalHandlers)
        {
            DayPilotCalendar.globalHandlers = true;
            DayPilot.re(document, 'mousemove', DayPilotCalendar.gMouseMove);
            DayPilot.re(document, 'mouseup', DayPilotCalendar.gMouseUp);
        }
    };

    this.prepareEvents = function() {
        var $0K = this.events.length;
        var $0L = this.columns.length;
        for (var i = 0; i < $0L; i++) {
        }
    };

    this.Init = function()
    {
        if (this.columns.length > 7) {
            var divScroll = document.getElementById('dyveDivScroll');
            divScroll.style.width = 98 * this.columns.length + "px";
            divScroll.style.position = "absolute";
        }

        this.registerGlobalHandlers();
        this.prepareColumns();
        this.drawHeader();
        this.drawTable();
        this.fixScrollHeader();
        this.drawEvents();
        this.drawEventsAllDay();
        this.enableScrolling();

        //document.getElementById("progress_text").innerHTML ="Schedule load...";
        progress_update();
        /*
         var s="";
         for (attr in divScroll) {

         if (attr != "innerHTML")
         s+= attr + ":" + divScroll[attr] + "\n";
         }
         //alert(divScroll.clientWidth);
         */

    };
};
DayPilotCalendar.Cell = function($L, end, $q) {
    this.start = $L;
    this.end = end;
    this.column = function() {
    };
};
DayPilotCalendar.Column = function($0M, name, $V) {
    this.value = $0M;
    this.name = name;
    this.date = new Date($V);
};

DayPilotCalendar.Event = function($d, $t)
{
    $d.event = this;
    this.div = $d;
    this.root = $t;
    this.columnValue = DayPilotCalendar.getShadowColumn($d).getAttribute("dpColumn");
    this.value = function()
    {
        return $d.data.Value;
    };
    this.text = function()
    {
        return $d.data.Text;
    };
    this.start = function()
    {
        return new Date($d.data.Start);
    };
    this.end = function()
    {
        return new Date($d.data.End);
    };
    this.setStart = function($sdt)
    {
        $d.data.Start=$sdt;
    };
    this.setEnd = function($edt)
    {
        $d.data.End=$edt;
    };
    this.partStart = function()
    {
        return new Date($d.data.PartStart);
    };
    this.partEnd = function()
    {
        return new Date($d.data.PartEnd);
    };
    this.column = function()
    {
        return this.columnValue;
    };
    this.innerHTML = function()
    {
        var c = $d.getElementsByTagName("DIV");
        return c[c.length - 1].innerHTML;
    };
    this.tag = function($0N)
    {
        var t = $d.data.Tag;
        if (!$0N) {
            return t;
        }
        ;
        var $0O = $t.tagFields.split(",");
        var $0P = -1;
        for (var i = 0; i < $0O.length; i++)
        {
            if ($0N === $0O[i])$0P = i;
        }
        ;
        if ($0P == -1)
        {
            throw "Field name not found.";
        }
        ;
        var $0Q = t.split('&');
        return decodeURIComponent($0Q[$0P]);
    };
    this.movingAllowed = function()
    {
        return $d.data.MoveEnabled && $t.eventMoveHandling !== "Disabled"
    };
    this.resizingAllowed = function()
    {
        return $d.data.ResizeEnabled && $t.eventResizeHandling !== "Disabled"
    };
    this.clickingAllowed = function()
    {
        return $d.data.ClickEnabled && $t.eventClickHandling !== "Disabled"
    };
    this.rightClickingAllowed = function()
    {
        return $d.data.RightClickEnabled && $t.rightClickHandling !== "Disabled"
    };
    this.isSelected = function()
    {
        return $t.selectedEvent() === this
    };
    this.isAllDay = function()
    {
        return $d.data.AllDay;
    };
    if ($t.$("select").value === this.value())
    {
        $t.divSelectOne($d);
    }
    ;
    $d.onmousemove = function(ev)
    {
        var $0R = 5;
        var $0S = Math.max($t.durationBarWidth, 10);
        var w = 5;
        if (typeof(DayPilotCalendar) === 'undefined') {
            return;
        }
        ;
        var $01 = DayPilot.mo(this, ev);
        if (!$01) {
            return;
        }
        ;
        if (DayPilotCalendar.resizing || DayPilotCalendar.moving) {
            return;
        }
        ;
        var $0T = this.getAttribute("dpStart") === this.getAttribute("dpPartStart");
        var $0U = this.getAttribute("dpEnd") === this.getAttribute("dpPartEnd");
        if ($01.x <= $0S && $d.event.movingAllowed())
        {
            if ($0T) {
                this.style.cursor = 'move';
            }
            else {
                this.style.cursor = 'not-allowed';
            }
        }
        else if ($01.y <= $0R && $d.event.resizingAllowed())
        {
            if ($0T)
            {
                this.style.cursor = "n-resize";
                this.dpBorder = 'top';
            }
            else
            {
                this.style.cursor = 'not-allowed';
            }
        }
        else if (this.offsetHeight - $01.y <= $0R && $d.event.resizingAllowed())
            {
                if ($0U)
                {
                    this.style.cursor = "s-resize";
                    this.dpBorder = 'bottom';
                }
                else
                {
                    this.style.cursor = 'not-allowed';
                }
            }
            else if (!DayPilotCalendar.resizing && !DayPilotCalendar.moving)
                {
                    if ($d.event.clickingAllowed())
                        this.style.cursor = 'pointer';
                    else this.style.cursor = 'default';
                }
        ;
        if (typeof(DayPilotBubble) != 'undefined' && $t.bubble && $t.eventHoverHandling != 'Disabled')
        {
            if (this.style.cursor == 'default' || this.style.cursor == 'pointer')
            {
                $t.bubble.showEvent($t.uniqueID, this.event.value());
            }
            else
            {
                DayPilotBubble.hideActive();
            }
        }
    };
    $d.onmousedown = function(ev)
    {
        ev = ev || window.event;
        var $02 = ev.which || ev.button;
        if ((this.style.cursor === 'n-resize' || this.style.cursor === 's-resize') && $02 === 1)
        {
            DayPilotCalendar.resizing = this;
            DayPilotCalendar.originalMouse = DayPilot.mc(ev);
            DayPilotCalendar.originalHeight = this.offsetHeight;
            DayPilotCalendar.originalTop = this.offsetTop;
            DayPilotCalendar.resizingShadow = DayPilotCalendar.createShadow(this);
            this.onclickSave = this.onclick;
            this.onclick = null;
        }
        else if (this.style.cursor === 'move' && $02 === 1)
        {
            DayPilotCalendar.moving = this;
            DayPilotCalendar.originalMouse = DayPilot.mc(ev);
            DayPilotCalendar.originalTop = this.offsetTop;
            DayPilotCalendar.originalLeft = this.offsetLeft;
            var $01 = DayPilot.mo(null, ev);
            if ($01)
            {
                DayPilotCalendar.moveOffsetY = $01.y;
            }
            else
            {
                DayPilotCalendar.moveOffsetY = 0;
            }
            ;
            DayPilotCalendar.movingShadow = DayPilotCalendar.createShadow(this);
            DayPilotCalendar.movingShadow.style.width = DayPilotCalendar.movingShadow.parentNode.offsetWidth + 'px';
            DayPilotCalendar.movingShadow.style.left = DayPilotCalendar.originalLeft + 'px';//'0px';//
            document.body.style.cursor = 'move';
            this.onclickSave = this.onclick;
            this.onclick = null;
        }
        else
        {
            if (this.onclickSave)
            {
                this.onclick = this.onclickSave;
                this.onclickSave = null;
            }
        }
        ;
        return false;
    };
};

//"yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
//"yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
function dateformat(date, fmt) { //author: meizz 
  var o = {
      "M+": date.getMonth() + 1, //月份 
      "d+": date.getDate(), //日 
      "h+": date.getHours(), //小时 
      "m+": date.getMinutes(), //分 
      "s+": date.getSeconds(), //秒 
      "q+": Math.floor((date.getMonth() + 3) / 3), //季度 
      "S": date.getMilliseconds() //毫秒 
  };
  if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
  for (var k in o)
  if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
  return fmt;
}

/*
jQuery(function() {
	
	jQuery("#mainCalendar_main td").droppable({
		drop: function( event, ui ) {
			var td = jQuery( this );
			td.html("dsflsdaldsfljkds");
		}
	});
	
});
*/
