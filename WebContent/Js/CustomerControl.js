var CustomerControl = {};


function checkCheckbox(id, value)
{
//    alert(id+" "+value);
    document.getElementById(id).checked = value;//!document.getElementById(id).checked;
    var cb_controller = document.getElementById(id+'_controller');
    if(!document.getElementById(id).checked)
        cb_controller.className='input_checkbox';
    else
        cb_controller.className='input_checkbox_checked';
}

function drawCheckbox(check_id, is_checked, custom_attr){
    // custom checkbox code
    var default_css_class = "input_checkbox";
    var default_input_value = "";
    if(is_checked){
        default_css_class = "input_checkbox_checked";
        default_input_value = " checked=\"checked\" ";
    }

    var output = '';
    output += '<div id="'+check_id+'_controller" class="'+default_css_class+'" onclick="javascript:document.getElementById(\''+check_id+'\').checked = !document.getElementById(\''+check_id+'\').checked; if(!document.getElementById(\''+check_id+'\').checked) this.className=\'input_checkbox\'; else this.className=\'input_checkbox_checked\';">';
    output += '<input '+ default_input_value+' style="display:none" onchange="alert(\'123\')" type="checkbox" name="'+check_id+'" id="'+check_id+'" '+custom_attr+'/>';
    output += '</div>';

    return output;
}


CustomerControl = function (id, idLocation) {
    this.id = id;
    this.idLocation = idLocation;

    var customerContainer = document.getElementById(this.id);


    this.Init = function () {
        customerContainer.innerHTML = "";
        customerContainer.innerHTML += '<input type="hidden" id="locationId" name="locationId" value="' + this.idLocation + '" />';
        customerContainer.innerHTML += '' +
                                       '<table>' +
                                       '<tr>' +
                                       '<td  id="homeTBL" name="homeTBL">' +
                                       '<table class="form">' +
                                        '<tr>' +
                                        '	<th valign="center"><img width="51" height="14" src="./img/form_first_name.png" /></th>' +
                                        '	<td>' +
                                        '		<input type="text"  id="txtFirstName" name="txtFirstName" class="input_text wickEnabled" autocomplete="OFF" />' +
                                        '	</td>' +
                                        '</tr>' +
                                        '<tr>' +
                                        '	<th><img width="51" height="14" src="./img/form_last_name.png" /></th>' +
                                        '	<td>' +
                                        '		<input type="text" id="txtLastName" name="txtLastName" class="input_text wickEnabled" autocomplete="OFF" />' +
                                        '	</td>' +
                                        '</tr>' +
                                        '<tr>' +
                                        '	<th style="letter-spacing: 6px;"><img width="51" height="14" src="./img/form_phone.png" /></th>' +
                                        '	<td>' +
                                        '		<input type="text" id="txtPhone" name="txtPhone" class="input_text wickEnabled" autocomplete="OFF"  value="1-()"/>' +
                                        '	</td>' +
                                        '</tr>' +
                                        '<tr>' +
                                        '	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_cell_phone.png" /></th>' +
                                        '	<td>' +
                                        '		<input type="text" id="txtCellPhone" name="txtCellPhone" class="input_text wickEnabled" autocomplete="OFF" value="1-()"/>' +
                                        '	</td>' +
                                        '</tr>' +
                                        '<tr>' +
                                        '	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_email.png" /></th>' +
                                        '	<td>' +
                                        '		<input type="text" id="txtEmail" name="txtEmail wickEnabled" class="input_text" autocomplete="OFF"/>' +
                                        '	</td>' +
                                        '</tr>' +
                                       '<tr>' +
                                       '    <th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_request.png" /></th>' +
                                       '    <td align=left>' +
                                       drawCheckbox('txtReq', false, 'autocomplete="OFF"') +
                                       '    </td>' +
                                       '</tr>' +

                                       '<tr  style="display:none;">' +
                                       '<td align="left" class="STYLE20"><img src="./img/form_employees.png" /></td>' +
                                       '<td align="left" class="STYLE18"><select id="txtEmployee" name="txtEmployee" class="styled wickEnabled" autocomplete="OFF"/></td>' +
                                       '</tr>' +
                                        '<tr>' +
                                        '	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_comment.png" /></th>' +
                                        '	<td>' +
                                        '		<textarea class="input_textarea" scroll=none  id="comment" name="comment" autocomplete="OFF" ondblclick="edit_comments(\'1\');"></textarea>' +
                                        '	</td>' +
                                        '</tr>' +
                                        '<tr>' +
                                        '	<th style="letter-spacing: 0px;"><img width="51" height="28" src="./img/form_customer_comment.png" /></th>' +
                                        '	<td>' +
                                        '		<textarea class="input_textarea" scroll=none id="custcomm" name="custcomm" autocomplete="OFF" ondblclick="edit_comments(\'2\');"></textarea>' +
                                        '	</td>' +
                                        '</tr>' +
                                        '<tr  style="display:none;">' +
                                        '	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_reminder.png" /></th>' +
                                        '	<td align=left>' +
                                       drawCheckbox('txtRem', false, 'autocomplete="OFF"') +
                                        '	</td>' +
                                        '</tr>' +
                                        '<tr  style="display:none;">' +
                                        '	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_days.png" /></th>' +
                                        '	<td>' +
                                        '		<input type="text" class="input_text" id="txtRemDays" name="txtRemDays" autocomplete="OFF"/>' +
                                        '	</td>' +
                                        '</tr>' +
                                       '<tr>' +
                                       '    <td colspan=2>' +
                                       '        <hr />' +
                                       '    </td>' +
                                       '</tr>' +
                                       '<tr>' +
                                       '    <td colspan=2 align=center>' +
                                       '    <input id="cust_id" name="cust_id" type="hidden" value="">' +
                                       '    <input id="app_id" name="app_id" type="hidden" value="">' +
                                       '        <input type="image" src="img/button_history.png" width="86" height="26" onclick="showHistory();"/>' +
                                       '        <input type="image" src="img/button_edit_cutomer.png" width="86" height="26" onclick="editCustomerModalBox();"/>' +
                                       '    </td>' +
                                       '</tr>' +
                                       '<tr>' +
                                       '    <td colspan=2>' +
                                       '        <input type="image" src="img/button_clear.png" width="55" height="26" onclick="clearCustomerData();"/>' +
                                       '        <input type="image" src="img/button_insert.png" width="55" height="26" onclick="saveCustomer();"/>' +
                                       '        <input type="image" src="img/button_update.png" width="55" height="26" onclick="updateCustomer();"/>' +
                                       '    </td>' +
                                       '</tr>' +
//                                       '<tr>' +
//                                       '    <td colspan=2 align=center>' +
//                                       '        <input type="image" src="img/button_edit_cutomer.png" width="86" height="26" onclick="document.location.href = \'./checkout.do?dt=<%=dt%>&rnd=\'"/>' +
//                                       '    </td>' +
//                                       '</tr>' +
                                       '</table>' +
                                       '<div id="customerDiv" style="position:absolute;z-index:5;">' +
                                       '<table id="smartInputFloater" class="floater" cellpadding="0" cellspacing="0">' +
                                       '<tr><td id="smartInputFloaterContent" nowrap="nowrap"></td></tr>' +
                                       '</table>' +
                                       '</div>' +
                                       '</td>' +
                                       '</tr>' +
                                       '</table>' +
                                       '';
        fillEmployees('txtEmployee');
        progress_update();
    }
}

function fillEmployees(selName) {
    var sel = document.getElementById(selName);
    //clear
    var nodes = sel.childNodes;
    var len = nodes.length;
    for (var i = len - 1; i >= 0; i--) {
        sel.removeChild(nodes[i]);
    }

    for (i = 0; i < employees.length; i++) {
        var elOpt = document.createElement('option');
        elOpt.value = employees[i][0];
        elOpt.text = employees[i][1];
        try {
            sel.add(elOpt, null); // standards compliant; doesn't work in IE
        }
        catch(ex) {
            sel.add(elOpt); // IE only
        }
    }
}

function freezeEvent(e)
{
    if (e.preventDefault) e.preventDefault();
    e.returnValue = false;
    e.cancelBubble = true;
    if (e.stopPropagation) e.stopPropagation();
    return false;
}

function isWithinNode(e, i, c, t, obj)
{
    answer = false;
    te = e;
    while (te && !answer) {
        if ((te.id && (te.id == i)) || (te.className && (te.className == i + "Class"))
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
}

function getEvent(event) {
    return (event ? event : window.event);
}

function getEventElement(e) {
    return (e.srcElement ? e.srcElement : (e.target ? e.target : e.currentTarget));
}

function findElementPosX(obj) {
    curleft = 0;
    if (obj.offsetParent) {
        while (obj.offsetParent) {
            curleft += obj.offsetLeft;
            obj = obj.offsetParent;
        }
    }
    else if (obj.x)
        curleft += obj.x
    return curleft;
}

function findElementPosY(obj) {
    curtop = 0;
    if (obj.offsetParent) {
        while (obj.offsetParent) {
            curtop += obj.offsetTop;
            obj = obj.offsetParent;
        }
    }
    else if (obj.y)
        curtop += obj.y
    return curtop;
}

function handleKeyPress(event) {
    e = getEvent(event);
    eL = getEventElement(e);

    upEl = isWithinNode(eL, null, "wickEnabled", null, null);

    kc = e["keyCode"];

    if (siw && ((kc == 13) || (kc == 9))) {
        siw.selectingSomething = true;
        if (siw.isSafari) siw.inputBox.blur();   //hack to "wake up" safari
        //siw.inputBox.focus();
        siw.inputBox.value = siw.inputBox.value.replace(/[ \r\n\t\f\s]+$/gi, ' ');
        hideSmartInputFloater();
    } else if (upEl && (kc != 38) && (kc != 40) && (kc != 37) && (kc != 39) && (kc != 13) && (kc != 27)) {
        if (!siw || (siw && !siw.selectingSomething)) {
            processSmartInput(upEl);
        }
    } else if (siw && siw.inputBox) {
        //siw.inputBox.focus(); //kinda part of the hack.
    }
}

function handleKeyDown(event)
{
    e = getEvent(event);
    eL = getEventElement(e);

    if (siw && (kc = e["keyCode"]))
    {
        if (kc == 40) {
            siw.selectingSomething = true;
            freezeEvent(e);
            if (siw.isGecko) siw.inputBox.blur();
            /* Gecko hack */
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
        } else if (kc == 27) {
            hideSmartInputFloater();
            freezeEvent(e);
        } else {
            siw.selectingSomething = false;
        }
    }
}

function handleFocus(event)
{
    e = getEvent(event);
    eL = getEventElement(e);
    if (focEl = isWithinNode(eL, null, "wickEnabled", null, null)) {
        if (!siw || (siw && !siw.selectingSomething)) {processSmartInput(focEl); }
    }
}

function handleBlur(event)
{
    e = getEvent(event);
    eL = getEventElement(e);
    if (blurEl = isWithinNode(eL, null, "wickEnabled", null, null)) {
        if (siw && !siw.selectingSomething) hideSmartInputFloater();
    }
}

function handleClick(event)
{
    e2 = getEvent(event);
    eL2 = getEventElement(e2);
    if (siw && siw.selectingSomething) {
        selectFromMouseClick();
    }
    else {
        hideSmartInputFloater();
    }
}

function handleMouseOver(event)
{
    e = getEvent(event);
    eL = getEventElement(e);
    if (siw && (mEl = isWithinNode(eL, null, "matchedSmartInputItem", null, null))) {
        siw.selectingSomething = true;
        selectFromMouseOver(mEl);
    } else if (isWithinNode(eL, null, "siwCredit", null, null)) {
        siw.selectingSomething = true;
    } else if (siw) {
        siw.selectingSomething = false;
    }
}

function showSmartInputFloater()
{
    if (!siw.floater.style.display || (siw.floater.style.display == "none")) {
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
        siw.floater.style.display = "block";
        siw.floater.style.visibility = "visible";
    }
}

function hideSmartInputFloater()
{
    if (siw) {
        siw.floater.style.display = "none";
        siw.floater.style.visibility = "hidden";
        //siw.matchCollection = new Array();
        //siw = null;
    }
}

function getSearchType(inputName)
{
    var searchType = '0';
    switch (inputName)
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
        /*case "txtReq" :
         searchType = 6;
         break;*/
        case "txtFN" :
            searchType = 7;
            break;
        case "txtLN" :
            searchType = 8;
            break;
        case "txtPh" :
            searchType = 9;
            break;
        case "txtCPh" :
            searchType = 10;
            break;
        case "txtEm" :
            searchType = 11;
            break;
        /*case "txtR" :
         searchType = 12;
         break;*/
    }
    return searchType;
}

function processSmartInput(inputBox)
{
    if (!siw)
    {
        siw = new smartInputWindow();
    }
    siw.inputBox = inputBox;
    var search = getSearchType(siw.inputBox.getAttribute('name'));

    var count = 3;
    if (search == 3 || search == 4 || search == 9 || search == 10){
        count = 4;
    }

    if (siw.inputBox.value.length >= count)
    {

        runMatchingLogic(siw.inputBox.value, search);
    }
    else
    {
        hideSmartInputFloater();
    }
}

function smartInputMatch(id, firstName, lastName, phone, cellPhone, email, rem, remdays, req, comment, empid)
{
    this.value = firstName + ' ' + lastName + ' ' + cellPhone;

    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.phone = phone;
    this.cellPhone = cellPhone;
    this.email = email;
    this.req = req;
    this.rem = rem;
    this.remdays = remdays;
//    this.app_id = app_id;
    this.comment = comment;
    this.empid = empid;

    this.isSelected = false;
}

function smartInputMatchWind(id, firstName, lastName, phone, cellPhone, email, rem, remdays, req, comment, empid)
{
    this.value = firstName + ' ' + lastName + ' ' + phone;

    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.phone = phone;
    this.cellPhone = cellPhone;
    this.email = email;
    this.req = req;
    this.rem = rem;
    this.remdays = remdays;
    this.comment = comment;
    this.empid = empid;

    this.isSelected = false;
}
var searchOpt = null;

function runMatchingLogic(userInput, searchOption)
{
    try
    {
        var request = getXmlHttpObject();

        if (request == null)
        {
            alert('Your browser does not support AJAX!');
            return;
        }
        var randomnumber = Math.floor(Math.random() * 11)
        var strURL = 'customerData?search=' + userInput + '&type=' + searchOption + "&rnd=" + randomnumber;
        //var strURL = 'customerData?search=' + userInput + '&type=' + searchOption;

        request.open("GET", strURL, true);
        request.onreadystatechange = function()
        {
            if (request.readyState == 4)
            {   var req2 = request.responseText;
                if (request.status == 200)
                {
                    if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                        var arr = req2.split(":");
//                    alert(arr[2].toString());
                        document.location.href = arr[1].toString();
                        return;
                    } else {
                    searchOpt = searchOption;
                    fillMatchCollection(request.responseXML, searchOption);   }
                }
            }
        }
        request.send(null);
    }
    catch(error) {
    }
}

function fillMatchCollection(xmlDoc, searchOption)
{
    try
    {
        siw.matchCollection = new Array();
        var items = xmlDoc.getElementsByTagName("customer");
        var app_comment = "";
        if (searchOption == 3){ //phone
            for (i = 0; i < items.length; i++) {
                siw.matchCollection[i] = new smartInputMatchWind(
                        items[i].getAttribute("ID"),
                        items[i].getAttribute("FirstName"),
                        items[i].getAttribute("LastName"),
                        items[i].getAttribute("Phone"),
                        items[i].getAttribute("CellPhone"),
                        items[i].getAttribute("Email"),
                        items[i].getAttribute("Rem"),
                        items[i].getAttribute("RemDays"),
                        items[i].getAttribute("Req"),
                        items[i].getAttribute("Comment"),
                        items[i].getAttribute("EmpId"));
            }
        }else { //cellphone and other
            for (i = 0; i < items.length; i++) {
                siw.matchCollection[i] = new smartInputMatch(
                        items[i].getAttribute("ID"),
                        items[i].getAttribute("FirstName"),
                        items[i].getAttribute("LastName"),
                        items[i].getAttribute("Phone"),
                        items[i].getAttribute("CellPhone"),
                        items[i].getAttribute("Email"),
                        items[i].getAttribute("Rem"),
                        items[i].getAttribute("RemDays"),
                        items[i].getAttribute("Req"),
                        items[i].getAttribute("Comment"),
                        items[i].getAttribute("EmpId"));
            }
        }
    }
    catch(callbackError) {
//        alert(callbackError);
        alert("error");
    }
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

        if (siw.isWinIE == true)
        {
            posX = pos[0];
            // correct position
            posY = pos[1] - homeTBLpos[1];
            document.getElementById("customerDiv").style.right = document.body.offsetWidth + "px";
        }

        if (siw.isMozilla == true)
        {
            posX = pos[0];
            // correct position
            posY = pos[1] - homeTBLpos[1] + 345;
        }

        if ((siw.isSafari == true) || (posX == 0 && posY == 0))
        {
            posX = pos[0];
            // correct position
            posY = pos[1] - homeTBLpos[1] + 340;

        }
        posX += 130;
        posY += 150;
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

function getSmartInputBoxContent()
{
    a = null;
    if (siw && siw.matchCollection && (siw.matchCollection.length > 0))
    {
        a = '';
        for (i = 0; i < siw.matchCollection.length; i++)
        {
            selectedString = siw.matchCollection[i].isSelected ? ' selectedSmartInputItem' : '';
            a += '<p class="matchedSmartInputItem' + selectedString + '">' + siw.matchCollection[i].value + '</p>';
        }
    }
    return a;
}

function modifySmartInputBoxContent(content)
{
    siw.floaterContent.innerHTML = '<div id="smartInputResults">' + content + '</div>';
    siw.matchListDisplay = document.getElementById("smartInputResults");
}

function selectFromMouseOver(o)
{
    currentIndex = getCurrentlySelectedSmartInputItem();
    if (currentIndex != null) deSelectSmartInputMatchItem(currentIndex);
    newIndex = getIndexFromElement(o);
    selectSmartInputMatchItem(newIndex);
    modifySmartInputBoxContent(getSmartInputBoxContent());
}

function selectFromMouseClick()
{
    activateCurrentSmartInputMatch();
    //siw.inputBox.focus();
    hideSmartInputFloater();
}

function getIndexFromElement(o)
{
    index = 0;
    while (o = o.previousSibling) {
        index++;
    }//
    return index;
}//getIndexFromElement

function getCurrentlySelectedSmartInputItem()
{
    answer = null;
    //alert(siw.matchCollection.length);
    // alert(siw.matchCollection.toString());
    for (i = 0; ((i < siw.matchCollection.length) && !answer); i++) {
        if (siw.matchCollection[i].isSelected)
            answer = i;
    }//
    return answer;
}

function selectSmartInputMatchItem(index) {
    siw.matchCollection[index].isSelected = true;
}

function deSelectSmartInputMatchItem(index) {
    siw.matchCollection[index].isSelected = false;
}

function selectNextSmartInputMatchItem()
{
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
        var ch = false;
        var ch1 = false;
        if (siw.matchCollection[selIndex].req.toString() == "true")
            ch = true;
        if (siw.matchCollection[selIndex].rem.toString() == "true")
            ch1 = true;
        if (searchOpt >= 1 && searchOpt <= 5) {
            document.getElementById('txtFirstName').value = siw.matchCollection[selIndex].firstName;
            document.getElementById('txtLastName').value = siw.matchCollection[selIndex].lastName;
            document.getElementById('txtPhone').value = siw.matchCollection[selIndex].phone;
            document.getElementById('txtCellPhone').value = siw.matchCollection[selIndex].cellPhone;
            document.getElementById('txtEmail').value = siw.matchCollection[selIndex].email;
            document.getElementById('txtEmployee').value = siw.matchCollection[selIndex].empid;
            //document.getElementById('txtReq').checked = ch;
            checkCheckbox('txtReq', ch);
            //document.getElementById('txtRem').checked = ch1;
            checkCheckbox('txtRem', ch1);
            document.getElementById('txtRemDays').value = siw.matchCollection[selIndex].remdays;
            document.getElementById('custcomm').value = siw.matchCollection[selIndex].comment;
            document.getElementById('cust_id').value = siw.matchCollection[selIndex].id;
        } else if (searchOpt > 5 && searchOpt <= 11) {
            document.getElementById('txtFN').value = siw.matchCollection[selIndex].firstName;
            document.getElementById('txtLN').value = siw.matchCollection[selIndex].lastName;
            document.getElementById('txtPh').value = siw.matchCollection[selIndex].phone;
            document.getElementById('txtCPh').value = siw.matchCollection[selIndex].cellPhone;
            document.getElementById('txtEm').value = siw.matchCollection[selIndex].email;
            document.getElementById('txtEmp').value = siw.matchCollection[selIndex].empid;
            //document.getElementById('txtR').checked = ch;
            checkCheckbox('txtR', ch);
            //document.getElementById('txtRm').checked = ch1;
            checkCheckbox('txtRm', ch1);
            document.getElementById('txtRmDays').value = siw.matchCollection[selIndex].remdays;
            document.getElementById('custcom').value = siw.matchCollection[selIndex].comment;
            document.getElementById('cust_id').value = siw.matchCollection[selIndex].id;
        }
        /*document.getElementById('comment').value = siw.matchCollection[selIndex].comment;
         document.getElementById('app_id').value = siw.matchCollection[selIndex].app_id;*/


        //		document.getElementById('txtFirstName').blur();
        //		document.getElementById('txtLastName').blur();
        //		document.getElementById('txtPhone').blur();
        //		document.getElementById('txtCellPhone').blur();
        //		document.getElementById('txtEmail').blur();
        //		document.getElementById('cust_id').blur();

        hideSmartInputFloater();
    }
}//activateCurrentSmartInputMatch

function smartInputWindow() {
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

if (isMobile()) {
	document.addEventListener("keydown", handleKeyDown, false);
    document.addEventListener("keyup", handleKeyPress, false);
    document.addEventListener("onclick",handleClick , false);
}
else if(document.addEventListener){
	document.addEventListener("keydown", handleKeyDown, false);
    document.addEventListener("keyup", handleKeyPress, false);
    document.addEventListener("mouseup", handleClick, false);
    document.addEventListener("mouseover", handleMouseOver, false);
}else {
    if (document.attachEvent) {
        document.attachEvent("onkeydown", handleKeyDown);
        document.attachEvent("onkeyup", handleKeyPress);
        document.attachEvent("onmouseup", handleClick);
        document.attachEvent("onmouseover", handleMouseOver);
    } else {
        document.onkeydown = handleKeyDown;
        document.onkeyup = handleKeyPress;
        document.onmouseup = handleClick;
        document.onmouseover = handleMouseOver;
    }
}

//registerSmartInputListeners();

// clear customer data
function clearCustomerData() {
    document.getElementById('txtFirstName').value = '';
    document.getElementById('txtLastName').value = '';
    document.getElementById('txtPhone').value = '1-()';
    document.getElementById('txtCellPhone').value = '1-()';
    document.getElementById('txtEmail').value = '';
    //document.getElementById('txtReq').checked = false;
    checkCheckbox('txtReq', false);
    //document.getElementById('txtRem').checked = false;
    checkCheckbox('txtRem', false);
    document.getElementById('txtRemDays').value = '';
    document.getElementById('cust_id').value = '';
    document.getElementById('comment').value = '';
    document.getElementById('custcomm').value = '';
    document.getElementById('app_id').value = '';
    document.getElementById('txtEmployee').value = '0';
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
function updateCustomer()
{
    try
    {
        var request = getXmlHttpObject();
        if (request == null)
        {
            alert('Your browser does not support AJAX!');
        }
        var idLocation = document.getElementById("locationId").value;
        var currentDate = new Date(document.getElementById("mainCalendar_datecurrent").value);
        var pageNum = document.getElementById("mainCalendar_pagenum").value;
        var newCurrentDate = currentDate.getUTCFullYear() + "/" + (currentDate.getUTCMonth() + 1) + "/" + currentDate.getUTCDate() + " " + currentDate.getUTCHours() + ":" + currentDate.getUTCMinutes();
        var randomnumber = Math.floor(Math.random() * 11);
        var strURL = 'customerData?UPDATE=update&firstName=' + document.getElementById('txtFirstName').value.replace(/\"/g,"") +
                     '&lastName=' + document.getElementById('txtLastName').value.replace(/\"/g,"") +
                     '&phone=' + document.getElementById('txtPhone').value +
                     '&cellPhone=' + document.getElementById('txtCellPhone').value +
                     '&email=' + document.getElementById('txtEmail').value +
                     '&req=' +  document.getElementById('txtReq').checked +
                     '&locationId=' + document.getElementById('locationId').value +
                     '&rem=' + document.getElementById('txtRem').checked +
                     '&remdays=' + document.getElementById('txtRemDays').value +
                     '&cust_id=' + document.getElementById('cust_id').value +
                     '&comment=' + document.getElementById('comment').value.replace(/\"/g," ") +
                     '&empid=' + document.getElementById('txtEmployee').value +
                     '&custcomm=' + document.getElementById('custcomm').value.replace(/\"/g," ") +
                     '&app_id=' + document.getElementById('app_id').value +
                     "&rnd=" + randomnumber +
                     "&idlocation=" + idLocation +
                     "&dateutc=" + newCurrentDate +
                     "&pageNum=" + pageNum;
        request.open("GET", strURL, true);
        request.onreadystatechange = function()
        {
            if (request.readyState == 4)
            {
                var req2 = request.responseText;
                if (request.status == 200)
                {
                    if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                        var arr = req2.split(":");
//                    alert(arr[2].toString());
                        document.location.href = arr[1].toString();
                    } else{
                    alert('Customer was updated successfully.');
                    drawAroundEvents(request.responseText);
                    //drawEvents(request.responseText);
                    siw.matchCollection = new Array();
                    }
                }

            }
        }
        request.send(null);
    }
    catch(error) {
        alert(error);
    }
}

// save customer data
function saveCustomer()
{
//    alert("Customer Control");
    try
    {
        var customerId = document.getElementById('cust_id');
        var exist = false;
        if (customerId.value != "") {
            alert('Customer already in the database!');
            exist = true;
        }

        if (!exist)
        {
            var request = getXmlHttpObject();

            if (request == null)
            {
                alert('Your browser does not support AJAX!');
            }
            var firstName = document.getElementById('txtFirstName').value.replace(/\"/g,"");
            var lastName =  document.getElementById('txtLastName').value.replace(/\"/g,"");
            var phone = document.getElementById('txtPhone').value;
            var cellPhone = document.getElementById('txtCellPhone').value;
//            if (firstName.replace(/ /g,"") == ""){
//                alert("Please enter First Name");
//                return;
//            }
//            if (lastName.replace(/ /g,"") == ""){
//                alert("Please enter Last Name");
//                return;
//            }
//            if (phone.replace("1-(","").replace(")","") == "" && cellPhone.replace("1-(","").replace(")","") == ""){
//                alert("Please enter Phone or Cell Phone");
//                return;
//            }

            var strURL = 'customerData?SAVE=save&firstName=' + firstName +
                         '&lastName=' + lastName +
                         '&phone=' + phone +
                         '&cellPhone=' + cellPhone +
                         '&email=' + document.getElementById('txtEmail').value +
                         '&req=false' +    //  document.getElementById('txtReq')
                         '&locationId=' + document.getElementById('locationId').value +
                         '&empid=' + document.getElementById('txtEmployee').value +
                         '&custcomm=' + document.getElementById('custcomm').value.replace(/\"/g," ") +
                         '&rem=' + document.getElementById('txtRem').checked +
                         '&remdays=' + document.getElementById('txtRemDays').value;

            request.open("GET", strURL, true);
            request.onreadystatechange = function()
            {
                if (request.readyState == 4)
                {
                    var req2 = request.responseText;
                    if (request.status == 200)
                    {
                        if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                            var arr = req2.split(":");
//                        alert(arr[2].toString());
                            document.location.href = arr[1].toString();
                        } else  {

                        var xmlDoc = request.responseXML;
                        var items = xmlDoc.getElementsByTagName("customer");
                        if (items.length == 1)
                        {
                            if (items[0].getAttribute("ID") != '0')
                            {
                                document.getElementById('cust_id').value = items[0].getAttribute("ID");
                                alert('Customer was saved successfully.');
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

                    }}
                }
            }
            //alert("cust = " + document.getElementById('cust_id').value);
            request.send(null);
        }
    }
    catch(error) {
        alert(error);
    }
}

//function fastAppointment() {
//    try {
//        var request = getXmlHttpObject();
//        if (request == null) {
//            alert('Your browser does not support AJAX!');
//        }
//        var strURL = 'customerData?FAST=fast&locationId=' + document.getElementById('locationId').value;
//        request.open("GET", strURL, true);
//        request.onreadystatechange = function() {
//            if (request.readyState == 4 && request.status == 200) {
//                var xmlDoc = request.responseXML;
//                var items = xmlDoc.getElementsByTagName("customer");
//                if (items.length == 1 && items[0].getAttribute("ID") != '0') {
//                    document.getElementById('cust_id').value = items[0].getAttribute("ID");
//                    document.getElementById('txtFirstName').value = items[0].getAttribute("FNAME");
//                }
//            }
//        }
//        request.send(null);
//    }
//    catch(error) {
//        alert(error);
//    }
//}

function showHistory() {
    var customerId = document.getElementById('cust_id');
    if (customerId.value == "") {
        alert("Please select customer firstly.");
        return;
    }
    var currentDate2 = new Date(document.getElementById("mainCalendar_datecurrent").value);
    var newCurrentDate2 = currentDate2.getUTCFullYear() + "/" + (currentDate2.getUTCMonth() + 1) + "/" + currentDate2.getUTCDate();
    window.location.href='./history_customer.jsp?id='+customerId.value+'&dt='+newCurrentDate2+'&rp=shd&action=hist';
//    var customerId = document.getElementById('cust_id');
//    if (customerId.value == "") {
//        alert("Please select customer firstly.");
//        return;
//    }
//    Modalbox.show('history.jsp?id=' + customerId.value + '&rnd=' + Math.random() * 99999, {width: 1000});
}

function editCustomerModalBox(){
    var customerId = document.getElementById('cust_id');
    if (customerId.value == "") {
        alert("Please select customer firstly.");
    return;
    }
    var currentDate = new Date(document.getElementById("mainCalendar_datecurrent").value);
    var newCurrentDate = currentDate.getUTCFullYear() + "/" + (currentDate.getUTCMonth() + 1) + "/" + currentDate.getUTCDate();
    window.location.href='./view_customer.jsp?id='+customerId.value+'&dt='+newCurrentDate;

//    Modalbox.show('./edit_customer_popup.jsp?id=' + customerId.value + '&rnd=' + Math.random() * 99999, {width: 900});
}

function saveCustomer_popup(id)
{
    try
    {
        var customerId = id;
        var exist = false;

        if (!exist)
        {
            var request = getXmlHttpObject();

            if (request == null)
            {
                alert('Your browser does not support AJAX!');
            }
            var firstName = document.getElementById('fname').value.replace(/\"/g,"");
            var lastName =  document.getElementById('lname').value.replace(/\"/g,"");
            var email = document.getElementById('email').value;
            var phone = document.getElementById('phone').value;
            var cellPhone = document.getElementById('cell_phone').value;
            var work_phone_ext = document.getElementById('work_phone_ext').value;
            var male = document.getElementsByName('male_female')[0].checked;
            var female = document.getElementsByName('male_female')[1].checked;
            var address = document.getElementById('address').value;
            var country = document.getElementById('country').value;
            var city = document.getElementById('city').value;
            var state = document.getElementById('state').value;
            var zip_code = document.getElementById('zip_code').value;
            var b_date = document.getElementById('b_date').value;
            var male_female = "";
//            alert(male);
//            alert(female);
            if (male) male_female = 'male';
            if (female) male_female = 'female';
            var strURL = 'customerData?UPDATE_POPUP=update_popup&firstName=' + firstName +
                '&lastName=' + lastName +
                '&phone=' + phone +
                '&cellPhone=' + cellPhone +
                '&email=' + email +
                '&locationId=' + '1' +
                '&empid=' + document.getElementById('txtEmployee').value +
                '&work_phone_ext=' + work_phone_ext +
                '&male_female=' + male_female +
                '&address=' + address +
                '&country=' + country +
                '&city=' + city +
                '&state=' + state +
                '&zip_code=' + zip_code +
                '&b_date=' + b_date+
                '&cust_id=' + customerId;

            request.open("GET", strURL, true);
            request.onreadystatechange = function()
            {
                if (request.readyState == 4)
                {
                    var req2 = request.responseText;
                    if (request.status == 200)
                    {
                        if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                            var arr = req2.split(":");
                            document.location.href = arr[1].toString();
                        } else  {

                            var xmlDoc = request.responseXML;
                            var items = xmlDoc.getElementsByTagName("customer");
                            if (items.length == 1)
                            {
                                if (items[0].getAttribute("ID") != '0') {
                                    document.getElementById('txtFirstName').value = items[0].getAttribute("FirstName");
                                    document.getElementById('txtLastName').value = items[0].getAttribute("LastName");
                                    document.getElementById('txtPhone').value = items[0].getAttribute("Phone");
                                    document.getElementById('txtCellPhone').value = items[0].getAttribute("CellPhone");
                                    document.getElementById('txtEmail').value = items[0].getAttribute("Email");
                                    alert('Customer was updated successfully.');
                                    Modalbox.hide();
                                }
                                else
                                {
                                    alert('The customer could not be updated!');
                                }
                            }
                            else
                            {
                                alert('The customer could not be updated!');
                            }

                        }}
                }
            }
            //alert("cust = " + document.getElementById('cust_id').value);
            request.send(null);
        }
    }
    catch(error) {
        alert(error);
    }
}