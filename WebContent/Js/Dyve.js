
var DayPilot={};
DayPilot.$=function(id)
{
    return document.getElementById(id);
};
DayPilot.mo=function(t,ev)
{
    ev=ev||window.event;
    if(ev.layerX) {
        var $a= {x:ev.layerX,y:ev.layerY};
        if(!t){return $a;};return $a;};
        if(ev.offsetX){return{x:ev.offsetX,y:ev.offsetY};};
        return null;
};

DayPilot.mo2=function($b,ev){ev=ev||window.event;if(ev.layerX){var $a={x:ev.layerX,y:ev.layerY,$c:ev.target};if(!$b){return $a;};var $d=ev.target;while($d&&$d.style.position!='absolute'&&$d.style.position!='relative'){$d=$d.parentNode;}while($d&&$d!=$b){$a.x+=$d.offsetLeft;$a.y+=$d.offsetTop;$d=$d.offsetParent;};if($d){return $a;};return null;};if(ev.offsetX){var $a={x:ev.offsetX+1,y:ev.offsetY+1};if(!$b){return $a;};var $d=ev.srcElement;while($d&&$d!=$b){if($d.tagName!='SPAN'){$a.x+=$d.offsetLeft;$a.y+=$d.offsetTop;};$d=$d.offsetParent;};if($d){return $a;};return null;};return null;};
DayPilot.abs=function(element){var r={x:element.offsetLeft,y:element.offsetTop};while(element.offsetParent){element=element.offsetParent;r.x+=element.offsetLeft;r.y+=element.offsetTop;};return r;};

DayPilot.mc=function(ev)
{
    if(ev.pageX||ev.pageY)
    {
        return{x:ev.pageX,y:ev.pageY};
    };
        return{x:ev.clientX+document.documentElement.scrollLeft,y:ev.clientY+document.documentElement.scrollTop};
    };

DayPilot.re=function(el,ev,$e)
{
    if(el.addEventListener)
    {
        el.addEventListener(ev,$e,false);
    }
    else if(el.attachEvent)
    {
        el.attachEvent("on"+ev,$e);
    }
};
DayPilot.tr=function($f){if(!$f)return '';return $f.replace(/^\s+|\s+$/g,"");};
DayPilot.ds=function(d){var $g=d.getUTCSeconds();if($g<10)$g="0"+$g;var $h=d.getUTCMinutes();if($h<10)$h="0"+$h;var $i=d.getUTCHours();if($i<10)$i="0"+$i;var $j=d.getUTCDate();if($j<10)$j="0"+$j;var $k=d.getUTCMonth()+1;if($k<10)$k="0"+$k;var $l=d.getUTCFullYear();return $l+"-"+$k+"-"+$j+'T'+$i+":"+$h+":"+$g;};
DayPilot.gs=function(el,$m){var x=el;if(x.currentStyle)var y=x.currentStyle[$m];else if(window.getComputedStyle)var y=document.defaultView.getComputedStyle(x,null).getPropertyValue($m);if(typeof(y)=='undefined')y='';return y;};
DayPilot.ea=function(a){var $n="";for(var i=0;i<a.length;i++){if(a[i]||typeof(a[i])=='number'){if(a[i].getFullYear){a[i]=DayPilot.ds(a[i]);};$n+=encodeURIComponent(a[i]);};if(i+1<a.length){$n+='&';}};return $n;};
DayPilot.ci=function($o){var i=$o.cellIndex;if(i&&i>0)return i;var tr=$o.parentNode;var $p=tr.cells.length;for(i=0;i<$p;i++){if(tr.cells[i]==$o)return i;};return null;};
DayPilot.json=function($q){};
DayPilot.us=function(element){if(element){element.unselectable='on';element.style.MozUserSelect='none';for(var i=0;i<element.childNodes.length;i++){if(element.childNodes[i].nodeType==1){DayPilot.us(element.childNodes[i]);}}}};
DayPilot.pu=function(d){var a=d.attributes,i,l,n;if(a){l=a.length;for(i=0;i<l;i+=1){n=a[i].name;if(typeof d[n]==='function'){d[n]=null;}}};a=d.childNodes;if(a){l=a.length;for(i=0;i<l;i+=1){DayPilot.pu(d.childNodes[i]);}}};
DayPilot.Selection=function($r,end,$s,$t){this.type='selection';this.start=$r;this.end=end;this.resource=$s;this.root=$t;};
DayPilot.Event=function(id,$u,$v){
    this.value=function(){return id};
    this.tag=function(){return null};
    this.start=function(){return new Date(0)};
    this.end=function(){return new Date($u*1000);};this.text=function(){return $v;};
    this.isAllDay=function(){return false;};};
DayPilot.EventData=function(e){this.value=function(){return id};this.tag=function(){return null};this.start=function(){return new Date(0)};
this.end=function(){return new Date($u*1000);};this.text=function(){return $v;};this.isAllDay=function(){return false;};};
DayPilot.request=function($w,$x,$y){var $z=DayPilot.createXmlHttp();if(!$z){return;};$z.open("POST",$w,true);$z.setRequestHeader('User-Agent','XMLHTTP/1.0');$z.setRequestHeader('Content-type','application/x-www-form-urlencoded');$z.onreadystatechange=function(){if($z.readyState!=4)return;if($z.status!=200&&$z.status!=304){return;};$x($z);};if($z.readyState==4)return;$z.send($y);};
DayPilot.createXmlHttp=function(){var $A;try{$A=new XMLHttpRequest();}catch(e){try{$A=new ActiveXObject("Microsoft.XMLHTTP");}catch(e){}};return $A;};

DayPilot.Date={};
DayPilot.Date.getStart=function($l,$k,$B){var $C=DayPilot.Date.firstDayOfMonth($l,$k);d=DayPilot.Date.firstDayOfWeek($C,$B);return d;};
DayPilot.Date.firstDayOfMonth=function($l,$k){var d=new Date();d.setUTCFullYear($l,$k-1,1);d.setUTCHours(0);d.setUTCMinutes(0);d.setUTCSeconds(0);d.setUTCMilliseconds(0);return d;};
DayPilot.Date.firstDayOfWeek=function(d,$B){var $j=d.getUTCDay();while($j!=$B){d=DayPilot.Date.addDays(d,-1);$j=d.getUTCDay();};return d;};
DayPilot.Date.lastDayOfMonth=function($l,$k){var d=DayPilot.Date.firstDayOfMonth($l,$k);var length=DayPilot.Date.daysInMonth($l,$k);d.setUTCDate(length);return d;};
DayPilot.Date.daysInMonth=function($l,$k){if($l.getUTCFullYear){$k=$l.getUTCMonth()+1;$l=$l.getUTCFullYear();};var m=[31,28,31,30,31,30,31,31,30,31,30,31];if($k!=2)return m[$k-1];if($l%4!=0)return m[1];if($l%100==0&&$l%400!=0)return m[1];return m[1]+1;};
DayPilot.Date.addDays=function($D,$E){var d=new Date();d.setTime($D.getTime()+$E*24*60*60*1000);return d;};
DayPilot.Date.addMonths=function($D,$F){if($F==0)return $D;var y=$D.getUTCFullYear();var m=$D.getUTCMonth()+1;if($F>0){while($F>=12){$F-=12;y++;};if($F>12-m){y++;m=$F-(12-m);}else{m+=$F;}}else{while($F<=-12){$F+=12;y--;};if(m<=$F){y--;m=12-($F+m);}else{m=m+$F;}};var d=DayPilot.Date.clone($D);d.setUTCFullYear(y);d.setUTCMonth(m-1);return d;};
DayPilot.Date.addMinutes=function($D,$G){var d=new Date();d.setTime($D.getTime()+$G*60*1000);return d;};
DayPilot.Date.addTime=function($D,$H){var d=new Date();d.setTime($D.getTime()+$H);return d;};
DayPilot.Date.daysDiff=function($I,$g){if($I.getTime()>$g.getTime()){return null;};var i=0;var $J=DayPilot.Date.getDate($I);var $K=DayPilot.Date.getDate($g);while($J<$K){$J=DayPilot.Date.addDays($J,1);i++;};return i;};
DayPilot.Date.today=function(){var $L=new Date();var d=new Date();d.setUTCFullYear($L.getFullYear());d.setUTCMonth($L.getMonth());d.setUTCDate($L.getDate());return d;};
DayPilot.Date.diff=function($I,$g){if(!($I&&$g&&$I.getTime&&$g.getTime)){return null;};return $I.getTime()-$g.getTime();};
DayPilot.Date.daysSpan=function($I,$g){var $M=DayPilot.Date.daysDiff($I,$g);if(DayPilot.Date.equals($g,DayPilot.Date.getDate($g))){$M--;};return $M;};
DayPilot.Date.dateFromTicks=function($N){var d=new Date();d.setTime($N);return d;};
DayPilot.Date.clone=function($O){var d=new Date();return DayPilot.Date.dateFromTicks($O.getTime());};
DayPilot.Date.getDate=function($O){var d=DayPilot.Date.clone($O);d.setUTCHours(0);d.setUTCMinutes(0);d.setUTCSeconds(0);d.setUTCMilliseconds(0);return d;};
DayPilot.Date.getTime=function($O){var $D=DayPilot.Date.getDate($O);return DayPilot.Date.diff($O,$D);};
DayPilot.Date.max=function($I,$g){if($I.getTime()>$g.getTime()){return $I;}else{return $g;}};
DayPilot.Date.min=function($I,$g){if($I.getTime()<$g.getTime()){return $I;}else{return $g;}};
DayPilot.Date.equals=function($I,$g){return $I.getTime()==$g.getTime();};
DayPilot.Date.hours=function($D,$P){var $h=$D.getUTCMinutes();if($h<10)$h="0"+$h;var $i=$D.getUTCHours();if($P){var am=$i<12;var $i=$i%12;if($i==0){$i=12;};var $Q=am?"AM":"PM";return $i+':'+$h+' '+$Q;}else{return $i+':'+$h;}};



