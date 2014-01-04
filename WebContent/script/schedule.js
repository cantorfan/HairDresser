/*
WICK: Web Input Completion Kit
http://wick.sourceforge.net/
Copyright (c) 2004, Christopher T. Holland
All rights reserved.
 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the Christopher T. Holland, nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
*/
function freezeEvent(e) {
if (e.preventDefault) e.preventDefault();
e.returnValue = false;
e.cancelBubble = true;
if (e.stopPropagation) e.stopPropagation();
return false;
}//freezeEvent

function isWithinNode(e,i,c,t,obj) {
answer = false;
te = e;
while(te && !answer) {
	if	((te.id && (te.id == i)) || (te.className && (te.className == i+"Class"))
			|| (!t && c && te.className && (te.className == c))
			|| (!t && c && te.className && (te.className.indexOf(c) != -1))
			|| (t && te.tagName && (te.tagName.toLowerCase() == t))
			|| (obj && (te == obj))
		) {
		answer = te;
	} else {
		te = te.parentNode;
	}
}
return te;
}//isWithinNode

function getEvent(event) {
return (event ? event : window.event);
}//getEvent()

function getEventElement(e) {
return (e.srcElement ? e.srcElement: (e.target ? e.target : e.currentTarget));
}//getEventElement()

function findElementPosX(obj) {
	curleft = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent) {
			curleft += obj.offsetLeft;
			obj = obj.offsetParent;
		}
	}//if offsetParent exists
	else if (obj.x)
		curleft += obj.x
	return curleft;
}//findElementPosX

function findElementPosY(obj) {
	curtop = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent) {
			curtop += obj.offsetTop;
			obj = obj.offsetParent;
		}
	}//if offsetParent exists
	else if (obj.y)
		curtop += obj.y
	return curtop;
}//findElementPosY

/* end dhtml building blocks */

function handleKeyPress(event) {
e = getEvent(event);
eL = getEventElement(e);

upEl = isWithinNode(eL,null,"wickEnabled",null,null);
kc = e["keyCode"];

if (siw && ((kc == 13) || (kc == 9))) {
	siw.selectingSomething = true;
	if (siw.isSafari) siw.inputBox.blur();   //hack to "wake up" safari
	//siw.inputBox.focus();
	siw.inputBox.value = siw.inputBox.value.replace(/[ \r\n\t\f\s]+$/gi,' ');
	hideSmartInputFloater();
} else if (upEl && (kc != 38) && (kc != 40) && (kc != 37) && (kc != 39) && (kc != 13) && (kc != 27)) {
	if (!siw || (siw && !siw.selectingSomething)) {
	   if(upEl.id == 'txtCellPhone' || upEl.id == 'txtPhone' || upEl.id == 'txtPh' || upEl.id == 'txtCPh'){
            var val = upEl.value;
            val = val.substr(2, val.length).replace(/[^0-9\-]/gi,'');
            if(kc == 8 && val.length <= 3)
                val = val.substr(0, val.length - 1);                                    
            var val_new = '1-(' + val.substr(0,3) + ')' + val.substr(3, val.length);            
            upEl.value = val_new;	       
       }
		processSmartInput(upEl);
	}
} else if (siw && siw.inputBox) {
	//siw.inputBox.focus(); //kinda part of the hack.
}

}//handleKeyPress()


function handleKeyDown(event) {
e = getEvent(event);
eL = getEventElement(e);

if (siw && (kc = e["keyCode"])) {
	if (kc == 40) {
		siw.selectingSomething = true;
		freezeEvent(e);
		if (siw.isGecko) siw.inputBox.blur(); /* Gecko hack */
		selectNextSmartInputMatchItem();
	} else if (kc == 38) {
		siw.selectingSomething = true;
		freezeEvent(e);
		if (siw.isGecko) siw.inputBox.blur();
		selectPreviousSmartInputMatchItem();
	} else if ((kc == 13) || (kc == 9)) {
		siw.selectingSomething = true;
		activateCurrentSmartInputMatch();
		//freezeEvent(e);
	} else if (kc == 27)  {
		hideSmartInputFloater();
		freezeEvent(e);
	} else {
		siw.selectingSomething = false;
	}
}

}//handleKeyDown()

function handleFocus(event) {
	e = getEvent(event);
	eL = getEventElement(e);
	if (focEl = isWithinNode(eL,null,"wickEnabled",null,null)) {
	if (!siw || (siw && !siw.selectingSomething)) processSmartInput(focEl);
	}
}//handleFocus()

function handleBlur(event) {
	e = getEvent(event);
	eL = getEventElement(e);
	if (blurEl = isWithinNode(eL,null,"wickEnabled",null,null)) {
		if (siw && !siw.selectingSomething) hideSmartInputFloater();
	}
}//handleBlur()

function handleClick(event) {
	e2 = getEvent(event);
	eL2 = getEventElement(e2);
	if (siw && siw.selectingSomething) {
		selectFromMouseClick();
	}
	else{
		hideSmartInputFloater();
	}
}//handleClick()

function handleMouseOver(event) {
	e = getEvent(event);
	eL = getEventElement(e);
	if (siw && (mEl = isWithinNode(eL,null,"matchedSmartInputItem",null,null))) {	   
		//selectFromMouseOver(mEl);
		siw.selectingSomething = true;
		//alert('123');
	} else if (isWithinNode(eL,null,"siwCredit",null,null)) {
		siw.selectingSomething = true;
	}else if (siw) {
		siw.selectingSomething = false;
	}
}//handleMouseOver

function showSmartInputFloater() {
if (!siw.floater.style.display || (siw.floater.style.display=="none")) {
/*
	if (!siw.customFloater) {
		x = findElementPosX(siw.inputBox);
		y = findElementPosY(siw.inputBox) + siw.inputBox.offsetHeight;
		//hack: browser-specific adjustments.
		if (!siw.isGecko && !siw.isWinIE) x += 8;
		if (!siw.isGecko && !siw.isWinIE) y += 10;
		siw.floater.style.left = x;
		siw.floater.style.top = y;
	} else {
	//you may
	//do additional things for your custom floater
	//beyond setting display and visibility
	}
	*/
	siw.floater.style.display="block";
	siw.floater.style.visibility="visible";
}
}//showSmartInputFloater()

function hideSmartInputFloater() {
if (siw) {
siw.floater.style.display="none";
siw.floater.style.visibility="hidden";
//siw.matchCollection = new Array();
//siw = null;
}//siw exists
}//hideSmartInputFloater

function getSearchType(inputName)
{
	var searchType = '0';
	switch(inputName)
	{
		case "txtFirstName" : 
			searchType = 1;
			break;
		case "txtLastName" : 
			searchType = 2;
			break;
		case "txtPhone" : 
			searchType = 3;
			break;    
		case "txtCellPhone" : 
			searchType = 4;
			break;
		case "txtEmail" : 
			searchType = 5;
			break;
	}
	return searchType;
}

function processSmartInput(inputBox) 
{
    alert('123');
    if (!siw)
    {
        siw = new smartInputWindow();
    }
    siw.inputBox = inputBox;
    var search = getSearchType(siw.inputBox.getAttribute('name'));
    
    if(siw.inputBox.value.length > 2)
    {        
        alert(inputBox.getAttribute('name'));
        runMatchingLogic(siw.inputBox.value, search);
    }
	else
	{
		hideSmartInputFloater();
	}
}//processSmartInput()

function smartInputMatch(id, firstName, lastName, phone, cellPhone, email) {
	//this.value = firstName + ' ' + lastName + ' ' + phone;
	this.value = firstName + ' ' + lastName + ' ' + cellPhone;
	
	this.id = id;
	this.firstName = firstName;
	this.lastName = lastName;
	this.phone = phone;
	this.cellPhone = cellPhone;
	this.email = email;
	
	this.isSelected = false;
}//smartInputMatch

function smartInputMatchWind(id, firstName, lastName, phone, cellPhone, email) {
	this.value = firstName + ' ' + lastName + ' ' + phone;
//	this.value = firstName + ' ' + lastName + ' ' + cellPhone;

	this.id = id;
	this.firstName = firstName;
	this.lastName = lastName;
	this.phone = phone;
	this.cellPhone = cellPhone;
	this.email = email;

	this.isSelected = false;
}//smartInputMatch

function runMatchingLogic(userInput, searchOption) {
    try
	{
		var request = getXmlHttpObject();
		
		if(request == null)
		{
			alert('Your browser does not support AJAX!');
			return;
		}
		
		var strURL = 'customerData?search=' + userInput + '&type=' + searchOption;
				
		request.open("GET", strURL, true);
		request.onreadystatechange = function()
			{
				if (request.readyState == 4) 
				{
					if (request.status == 200)
					{
						fillMatchCollection(request.responseXML, searchOption);
					}
				}
			}
		request.send(null);
	}
	catch(error) { }
	
	
}//runMatchingLogic

function fillMatchCollection(xmlDoc, searchOption)
{
	try
	{
		siw.matchCollection = new Array();
		var items = xmlDoc.getElementsByTagName("customer");
        if (searchOption == 3){
            for (i = 0; i < items.length; i++)
            {
                siw.matchCollection[i] = new smartInputMatchWind(
                                                items[i].getAttribute("ID"),
                                                items[i].getAttribute("FirstName"),
                                                items[i].getAttribute("LastName"),
                                                items[i].getAttribute("Phone"),
                                                items[i].getAttribute("CellPhone"),
                                                items[i].getAttribute("Email"));
            }

        } else {
            for (i = 0; i < items.length; i++)
            {
                siw.matchCollection[i] = new smartInputMatch(
                                                items[i].getAttribute("ID"),
                                                items[i].getAttribute("FirstName"),
                                                items[i].getAttribute("LastName"),
                                                items[i].getAttribute("Phone"),
                                                items[i].getAttribute("CellPhone"),
                                                items[i].getAttribute("Email"));
            }
        }
	}
	catch(callbackError) { }
	if (siw.matchCollection && (siw.matchCollection.length > 0)) 
    {
        selectSmartInputMatchItem(0);
    }
    content = getSmartInputBoxContent();
    if (content) 
    {
        modifySmartInputBoxContent(content);
        showSmartInputFloater();
        var pos = findPos(siw.inputBox);
        var posX = 0;
        var posY = 0;
        var homeTBLpos = findPos(document.getElementById("homeTBL"));
        
        if(siw.isWinIE == true)
        {
        	posX = pos[0];
        	// correct position
        	posY = pos[1] - homeTBLpos[1];
        	document.getElementById("customerDiv").style.right = document.body.offsetWidth + "px";
        }
        
        if(siw.isMozilla == true)
        {
        	posX = pos[0];
        	// correct position
        	posY = pos[1] - homeTBLpos[1] + 397;
        }
        
        if((siw.isSafari == true) || (posX == 0 && posY == 0))
        {
        	posX = pos[0];
        	// correct position
        	posY = pos[1] - homeTBLpos[1] + 390;
        	
        }
        document.getElementById("customerDiv").style.position = "absolute";
	    document.getElementById("customerDiv").style.left = posX + "px";
		document.getElementById("customerDiv").style.top = posY + "px";
    } 
    else 
    {
        hideSmartInputFloater();
    }
}

function findPos(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) 
	{
	    do {
		    curleft += obj.offsetLeft;
		    curtop += obj.offsetTop;
	    } while (obj = obj.offsetParent);
    }
	return [curleft,curtop];
}

function getSmartInputBoxContent() {
a = null;
if (siw && siw.matchCollection && (siw.matchCollection.length > 0)) {
a = '';
for (i = 0;i < siw.matchCollection.length; i++) {
selectedString = siw.matchCollection[i].isSelected ? ' selectedSmartInputItem' : '';
a += '<p class="matchedSmartInputItem' + selectedString + '">' + siw.matchCollection[i].value + '</p>';
}//
}//siw exists
return a;
}//getSmartInputBoxContent

function modifySmartInputBoxContent(content) {
siw.floaterContent.innerHTML = '<div id="smartInputResults">' + content + '</div>';
siw.matchListDisplay = document.getElementById("smartInputResults");
}//modifySmartInputBoxContent()

function selectFromMouseOver(o) {
    currentIndex = getCurrentlySelectedSmartInputItem();
    if (currentIndex != null) deSelectSmartInputMatchItem(currentIndex);
    newIndex = getIndexFromElement(o);
    selectSmartInputMatchItem(newIndex);
    modifySmartInputBoxContent(getSmartInputBoxContent());
}//selectFromMouseOver

function selectFromMouseClick() {
activateCurrentSmartInputMatch();
//siw.inputBox.focus();
hideSmartInputFloater();
}//selectFromMouseClick

function getIndexFromElement(o) {
index = 0;
while(o = o.previousSibling) {
index++;
}//
return index;
}//getIndexFromElement

function getCurrentlySelectedSmartInputItem() {
answer = null;
for (i = 0; ((i < siw.matchCollection.length) && !answer) ; i++) {
	if (siw.matchCollection[i].isSelected)
		answer = i;
}//
return answer;
}//getCurrentlySelectedSmartInputItem

function selectSmartInputMatchItem(index) {
	siw.matchCollection[index].isSelected = true;
}//selectSmartInputMatchItem()

function deSelectSmartInputMatchItem(index) {
	siw.matchCollection[index].isSelected = false;
}//deSelectSmartInputMatchItem()

function selectNextSmartInputMatchItem() {
currentIndex = getCurrentlySelectedSmartInputItem();
if (currentIndex != null) {
	deSelectSmartInputMatchItem(currentIndex);
	if ((currentIndex + 1) < siw.matchCollection.length)
 		selectSmartInputMatchItem(currentIndex + 1);
	else
		selectSmartInputMatchItem(0);
} else {
	selectSmartInputMatchItem(0);
}
modifySmartInputBoxContent(getSmartInputBoxContent());
}//selectNextSmartInputMatchItem

function selectPreviousSmartInputMatchItem() {
currentIndex = getCurrentlySelectedSmartInputItem();
if (currentIndex != null) {
	deSelectSmartInputMatchItem(currentIndex);
	if ((currentIndex - 1) >= 0)
 		selectSmartInputMatchItem(currentIndex - 1);
	else
		selectSmartInputMatchItem(siw.matchCollection.length - 1);
} else {
	selectSmartInputMatchItem(siw.matchCollection.length - 1);
}
modifySmartInputBoxContent(getSmartInputBoxContent());
}//selectPreviousSmartInputMatchItem

function activateCurrentSmartInputMatch() {
	if ((selIndex = getCurrentlySelectedSmartInputItem()) != null) {
        addedValue = siw.matchCollection[selIndex].cleanValue;
		document.getElementById('txtFirstName').value = siw.matchCollection[selIndex].firstName;
		document.getElementById('txtLastName').value = siw.matchCollection[selIndex].lastName;
		document.getElementById('txtPhone').value = siw.matchCollection[selIndex].phone;
		document.getElementById('txtCellPhone').value = siw.matchCollection[selIndex].cellPhone;
		document.getElementById('txtEmail').value = siw.matchCollection[selIndex].email;
		document.getElementById('cust_id').value = siw.matchCollection[selIndex].id;
		
//		document.getElementById('txtFirstName').blur();
//		document.getElementById('txtLastName').blur();
//		document.getElementById('txtPhone').blur();
//		document.getElementById('txtCellPhone').blur();
//		document.getElementById('txtEmail').blur();
//		document.getElementById('cust_id').blur();
		
		hideSmartInputFloater();
	}
}//activateCurrentSmartInputMatch

function smartInputWindow () {
	this.customFloater = false;
	this.floater = document.getElementById("smartInputFloater");
	this.floaterContent = document.getElementById("smartInputFloaterContent");
	this.selectedSmartInputItem = null;
	this.isGecko = (navigator.userAgent.indexOf("Gecko/200") != -1);
	this.isSafari = (navigator.userAgent.indexOf("Safari") != -1);
	this.isWinIE = ((navigator.userAgent.indexOf("Win") != -1 ) && (navigator.userAgent.indexOf("MSIE") != -1 ));
	this.isMozilla = (navigator.userAgent.indexOf("Mozilla") != -1);
}//smartInputWindow Object

//function registerSmartInputListeners() {
//allinputs = document.getElementsByTagName("input");
//for (i=0; i < allinputs.length;i++) {
//	if ((c = allinputs[i].className) && (c == "wickEnabled")) {
//		allinputs[i].setAttribute("autocomplete","OFF");
//		//allinputs[i].onfocus = handleFocus;
//		allinputs[i].onblur = handleBlur;
//		allinputs[i].onkeydown = handleKeyDown;
//		allinputs[i].onkeyup = handleKeyPress;
//	}
//}//loop thru inputs
//}//registerSmartInputListeners

var siw = null;

if (document.addEventListener) {
	document.addEventListener("keydown", handleKeyDown, false);
	document.addEventListener("keyup", handleKeyPress, false);
	document.addEventListener("mouseup", handleClick, false);
	document.addEventListener("mouseover", handleMouseOver, false);
} else {
	document.onkeydown = handleKeyDown;
	document.onkeyup = handleKeyPress;
	document.onmouseup = handleClick;
	document.onmouseover = handleMouseOver;
}

//registerSmartInputListeners();

// clear customer data
function clearCustomerData() {
	document.getElementById('txtFirstName').value = '';
	document.getElementById('txtLastName').value = '';
	document.getElementById('txtPhone').value = '';
	document.getElementById('txtCellPhone').value = '';
	document.getElementById('txtEmail').value = '';
	document.getElementById('cust_id').value = '';
	siw.matchCollection = new Array();
}

// get the XMLHttpRequest object
function getXmlHttpObject()
{ 
	var objXMLHttp = null;
	if (window.XMLHttpRequest)
	{
		objXMLHttp = new XMLHttpRequest()
	}
	else
	{
		if (window.ActiveXObject)
        {
            objXMLHttp = new ActiveXObject("Microsoft.XMLHTTP")
        }
        else
        {
        	objXMLHttp = null;
        }
        
    }
    return objXMLHttp
}

// save customer data
function saveCustomer()
{
//    alert("shedule");
	try
	{
		var request = getXmlHttpObject();
		
		if(request == null)
		{
			alert('Your browser does not support AJAX!');
		}
        var firstName = document.getElementById('txtFirstName').value;
        var lastName =  document.getElementById('txtLastName').value.replace('\'', '\'\'');
        var phone = document.getElementById('txtPhone').value;
        var cellPhone = document.getElementById('txtCellPhone').value;
//        if (firstName.replace(/ /g,"") == ""){
//            alert("Please enter First Name");
//            return;
//        }
//        if (lastName.replace(/ /g,"") == ""){
//            alert("Please enter Last Name");
//            return;
//        }
//        if (phone.replace("1-(","").replace(")","") == "" && cellPhone.replace("1-(","").replace(")","") == ""){
//            alert("Please enter Phone or Cell Phone");
//            return;
//        }
        
		var strURL = 'customerData?firstName=' + firstName +
						'&lastName=' + lastName +
						'&phone=' + phone +
						'&cellPhone=' + cellPhone +
						'&email=' + document.getElementById('txtEmail').value +
						'&locationId=' + document.getElementById('locationId').value;
						
		
		request.open("GET", strURL, true);
		request.onreadystatechange = function()
			{
				if (request.readyState == 4) 
				{
					if (request.status == 200)
					{
						var xmlDoc = request.responseXML;
						var items = xmlDoc.getElementsByTagName("customer");
						if(items.length == 1)
						{
							if(items[0].getAttribute("ID") != '0')
							{
								document.getElementById('cust_id').value = items[0].getAttribute("ID");
							}
							else
							{
								alert('The customer could not be saved!');
								document.getElementById('cust_id').value = '';
							}
						}
						else
						{
							alert('The customer could not be saved!');
							document.getElementById('cust_id').value = '';
						}
						
					}
				}
			}
		request.send(null);
	}
	catch(error) { alert(error);}
}
