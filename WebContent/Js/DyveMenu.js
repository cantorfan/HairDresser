
var DayPilotMenu={};DayPilotMenu.mouse=null;DayPilotMenu.menu=null;DayPilotMenu.clickRegistered=false;DayPilotMenu.Menu=function(id){this.template=document.getElementById(id);this.border=null;
this.show=function(e){if(typeof(DayPilotBubble)!='undefined'){DayPilotBubble.hideActive();};DayPilotMenu.menuClean();
if(DayPilotMenu.mouse==null)return;var $a=document.createElement('div');
var $b=this.template.innerHTML;if(e.type=='selection'){$a.selection=e;}else{$a.event=e;if(e.value)
{$b=$b.replace(/\x7B0\x7D/gim,e.value());$b=$b.replace(/%7B0%7D/gim,e.value());}};
$a.innerHTML=$b;$a.style.border=this.border;
$a.style.fontSize=this.template.style.fontSize;$a.style.backgroundColor=this.template.style.backgroundColor;
$a.style.position='absolute';$a.style.top='0px';$a.style.left='0px';$a.onclick=function(e)
{window.setTimeout('DayPilotMenu.menuClean();',100);};
$a.onmousedown=function(e){if(!e)var e=window.event;e.cancelBubble=true;if(e.stopPropagation)e.stopPropagation();};
document.body.appendChild($a);$a.style.display='';var $c=$a.clientHeight;
var $d=$a.offsetWidth;$a.style.display='none';var $e=document.documentElement.clientHeight;
if(DayPilotMenu.mouse.clientY>$e-$c&&$e!=0){var $f=DayPilotMenu.mouse.clientY-($e-$c)+5;
$a.style.top=(DayPilotMenu.mouse.y-$f)+'px';}else{$a.style.top=DayPilotMenu.mouse.y+'px';};
var $g=document.documentElement.clientWidth;if(DayPilotMenu.mouse.clientX>$g-$d&&$g!=0)
{var $h=DayPilotMenu.mouse.clientX-($g-$d)+5;$a.style.left=(DayPilotMenu.mouse.x-$h)+'px';}
else{$a.style.left=DayPilotMenu.mouse.x+'px';};$a.style.display='';DayPilotMenu.menu=$a;};
DayPilot.re(document.body,'mousemove',DayPilotMenu.mouseMove);if(!DayPilotMenu.clickRegistered){DayPilot.re(document,'mousedown',DayPilotMenu.menuClean);DayPilotMenu.clickRegistered=true;};};DayPilotMenu.menuClean=function(ev){if(typeof(DayPilotMenu.menu)=='undefined')return;if(DayPilotMenu.menu){document.body.removeChild(DayPilotMenu.menu);DayPilotMenu.menu=null;}};DayPilotMenu.mouseMove=function(ev){if(typeof(DayPilotMenu)==='undefined')return;DayPilotMenu.mouse=DayPilotMenu.mousePosition(ev);};DayPilotMenu.mousePosition=function(e){var $i=0;var $j=0;if(!e)var e=window.event;if(e.pageX||e.pageY){$i=e.pageX;$j=e.pageY;}else if(e.clientX||e.clientY){$i=e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft;$j=e.clientY+document.body.scrollTop+document.documentElement.scrollTop;};var $k={};$k.x=$i;$k.y=$j;$k.clientY=e.clientY;$k.clientX=e.clientX;return $k;};


