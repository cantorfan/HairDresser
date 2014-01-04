var isIE = navigator.appName.indexOf("Microsoft") != -1;
var isIE5 = navigator.userAgent.indexOf('MSIE 5.0') > 0;
var isOpera = navigator.userAgent.indexOf("Opera") != -1;
var isSafari = navigator.userAgent.indexOf("AppleWebKit") != -1;

var lastMouseX;
var lastMouseY;
var curPopupWindow = null;
var closeOnParentUnloadWindow = null;
var helpWindow = null;
var win = null;

var beenFocused = false;
document.onmousedown = markFocused;
function markFocused() {
    beenFocused = true;
}

function copyInnerHTML(src, dest) {
    dest.innerHTML = src.innerHTML;
}

function setLastMousePosition(e) {
    if (navigator.appName.indexOf("Microsoft") != -1) e = window.event;
    lastMouseX = e.screenX;
    lastMouseY = e.screenY;
}

function openClickout(url) {
    window.open(url, "_blank", 'width=640,height=480,dependent=no,resizable=yes,toolbar=yes,status=yes,directories=yes,menubar=yes,scrollbars=1', false);
}

function openIntegration(url, props, positionType) {
    var newWindow = window.open(url, "_blank", props, false);
    if (positionType == 2){
        newWindow.moveTo(0, 0);
    } else if (positionType == 0){
        newWindow.moveTo(0, 0);
        newWindow.resizeTo(self.screen.width, self.screen.height);
    }
}

/**
 * Calls through to the openPopupFocus() with closeOnLoseFocus set to true.
 */
function openPopup(url, name, pWidth, pHeight, features, snapToLastMousePosition) {
    openPopupFocus (url, name, pWidth, pHeight, features, snapToLastMousePosition, true);
}

/**
 * Used for help popup links that need #'s escaped inline.
 */
function openPopupFocusEscapePounds(url, name, pWidth, pHeight, features, snapToLastMousePosition, closeOnLoseFocus) {
    openPopupFocus (url.replace("#","%23"), name, pWidth, pHeight, features, snapToLastMousePosition, closeOnLoseFocus);
}

/**
 * Handles popup windows.
 * If snapToLastMousePosition is true, then the popup will open up near the mouse click.
 * If closeOnLoseFocus is true, then it will close when the user clicks back into the browser window that opened it.
 */
function openPopupFocus(url, name, pWidth, pHeight, features, snapToLastMousePosition, closeOnLoseFocus, closeOnParentUnload) {
    closePopup();

    if (snapToLastMousePosition) {
        if (lastMouseX - pWidth < 0) {
            lastMouseX = pWidth;
        }
        if (lastMouseY + pHeight > screen.height) {
            lastMouseY -= (lastMouseY + pHeight + 50) - screen.height;
        }
        lastMouseX -= pWidth;
        lastMouseY += 10;
        features += ",screenX=" + lastMouseX + ",left=" + lastMouseX + ",screenY=" + lastMouseY + ",top=" + lastMouseY;
    }

    if (closeOnLoseFocus) {
        curPopupWindow = window.open(url, name, features, false);
        curPopupWindow.focus ();
    } else {
        // assign the open window to a dummy var so when closePopup() is called it won't be assigned to curPopupWindow
        win = window.open(url, name, features, false);
        win.focus ();
    }
    
    if (closeOnParentUnload) {
        closeOnParentUnloadWindow = win;
    }
}

function closePopup() {
    if (curPopupWindow != null) {

        if (!curPopupWindow.closed) {
            curPopupWindow.close();
        }
        curPopupWindow = null;
    }
}

/* Cross-platform handling of complex modal dialog boxes */
var modalWindow = null;
function ignoreModalEvents(e) {return false;}
function handleModalFocus() {
    if (modalWindow) {
        if (modalWindow.closed) {
            window.top.releaseEvents(Event.CLICK | Event.FOCUS);
            window.top.onclick="";
        } else {
            modalWindow.focus();
        }
    }
    return false;
}
// Invoke the result function
function invokeResultFunc() {
    var resultFunc;
    if (window.dialogArguments) {
        resultFunc = window.dialogArguments;
    } else {
        resultFunc = window.opener.resultFunc;
    }
    resultFunc();
}
function openPopupModal(url, name, pWidth, pHeight, features, resultFunc, fallbackFunc) {
    if (window.showModalDialog) {
        var result = window.showModalDialog(url,resultFunc==null?window:resultFunc,features);
    } else if (window.top.captureEvents) {
        window.top.captureEvents(Event.CLICK|Event.FOCUS);
        window.top.onclick=ignoreModalEvents;
        window.top.onfocus=handleModalFocus;
        modalWindow = window.open(url, name, features+",modal=yes");
        if (resultFunc) window.resultFunc = resultFunc;
    } else {
        if (fallbackFunc) return fallbackFunc();
        return openPopup(url,name,pWidth,pHeight,features,false);
    }
}
// Handle confirmations in a unified fashion
var clickedLink,warningText;
function confirmPopup(dialogUrl,w,h,features,destLink,warnText) {
    clickedLink = destLink.href ? destLink.href : destLink;
    warningText = warnText;
    var resultFunc = new Function("window.location = clickedLink");
    resultFunc.window = window;
    openPopupModal(dialogUrl,"_blank",w,h,features,
        resultFunc,
        new Function("return confirm(warningText)"));
    return false;
}

function openLookup(baseURL,width,modified,searchParam,originalWidthParam) {
    if (modified == '1') baseURL = baseURL + searchParam;
    baseURL = baseURL + "&" + originalWidthParam + "=";
    if (isIE) {
        baseURL = baseURL + document.body.offsetWidth;
    } else {
        baseURL = baseURL + window.innerWidth;
    }
    popWin2(baseURL);
    //openPopup(baseURL, "lookupDialog", 350, 300, "width="+width+",height=300,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=yes", true);
}

function pick(form,field,val,callOnchange) {
    document.getElementById(form)[field].value = val;
    if (callOnchange) {
        document.getElementById(form)[field].onchange();
    }
    closePopup();
    return false;
}

function pickSubmit(form,field,val) {
    document.getElementById(form)[field].value = val;
    document.getElementById(form).submit();
    closePopup();
    return false;
}

function pickcolor(form,field,val) {
    newval = parseInt(val, 16);
    document.getElementById(form)[field].value = newval;
    document.getElementById(field + "cell").style.backgroundColor = "#" + val;
    closePopup();
    return false;
}

function comboBoxPick (form, fieldName, comboBoxArrayName, index) {
    // get the field we are inserting the value into
    var field = document.getElementById(form)[fieldName];

    if (field != null) {
        // get to the javascript array for this combobox
        var comboBoxArray = eval (comboBoxArrayName);
        if (comboBoxArray != null) {

            if (index >= 0 && index < comboBoxArray.length) {
                // if we pass the bounds check, assign the value
                field.value = comboBoxArray[index];
            }
        }
    }
    closePopup ();
    return false;
}

function listProperties(obj) {
    var names = "";
    for (var i in obj) names += i + ", ";
    alert(names);
}

/**
relatedFieldName/Value are for copying in a value other than the selected name.
extraNameElementName identifies another element on the parent page to copy the name again (if the element is empty).
*/


function lookupPick( idName ,displayName,id ,display )
{
	var parentIdElement = document.getElementById(idName);
    var parentDisplayElement = document.getElementById(displayName);
	parentIdElement.value =id;
	parentDisplayElement.value =display;
	// closePopup();

    return false;
}
 

function setFocusOnLoad() {
    if (!beenFocused) { setFocus(); }
}

function setFocus() {
    var sidebarSearch;
    // search for a tabIndexed field to focus on
    for(var firstIndex=1; firstIndex < 5; firstIndex ++ ){
        var nextIndex = firstIndex;
        for (var frm = 0; frm < document.forms.length; frm++) {
            for (var fld = 0; fld < document.forms[frm].elements.length; fld++) {
                var elt = document.forms[frm].elements[fld];
                if ( elt.tabIndex != nextIndex) continue;
                if ((elt.type == "text" || elt.type == "textarea" || elt.type == "password") && !elt.disabled
                   && elt.name != "sbstr" &&  elt.name.indexOf("owner") != 0 && elt.name.indexOf("tsk1") != 0 && elt.name.indexOf("evt1") != 0) {
                    elt.focus();
                    if (elt.type == "text") {
                        elt.select();
                    }
                    return true;
                } else {
                    nextIndex++;
                    fld = 0;
                }
            }
        }
    }

    // failed to find a tabIndexed field, try to find the field based on it's natural position.
    for (var frm = 0; frm < document.forms.length; frm++) {
        for (var fld = 0; fld < document.forms[frm].elements.length; fld++) {
            var elt = document.forms[frm].elements[fld];
            // skip buttons, radio, or check-boxes
            // to skip "select" types, remove from if statement
            if ((elt.type == "text" || elt.type == "textarea" || elt.type == "password") && !elt.disabled) {
                if (elt.name == "sbstr" && document.forms[frm].name == "sbsearch") {
                    sidebarSearch = elt;
                } else if (elt.name.indexOf("owner") != 0) {
                    elt.focus();
                    // select text in text field or textarea
                    if (elt.type == "text") {
                        elt.select();
                    }
                    return true;
                }
            }
        }
    }

    return true;
}

function setNamedFocus(element_name) {
    for (var frm = 0; frm < document.forms.length; frm++) {
        for (var fld = 0; fld < document.forms[frm].elements.length; fld++) {
            var elt = document.forms[frm].elements[fld];
            if (elt.name == element_name) {
                elt.focus();
                if (elt.type == "text") {
                    elt.select();
                }
                return true;
            }
        }
    }
    return true;
}

// removes the leading and trailing spaces from a string,
// similar to the java.lang.String.trim() function
// added by lturetsky, taken from http://www.voy.com/1888/58.html
function trim(st) {
    var len = st.length
    var begin = 0, end = len - 1;
    while (st.charAt(begin) == " " && begin < len) {
        begin++;
    }
    while (st.charAt(end) == " " && begin < end) {
        end--;
    }
    return st.substring(begin, end+1);
}


function formatPhone (field) {
    field.value = trim(field.value);

    var ov = field.value;
    var v = "";
    var x = -1;

    // is this phone number 'escaped' by a leading plus?
    if (0 < ov.length && '+' != ov.charAt(0)) { // format it
        // count number of digits
        var n = 0;
        if ('1' == ov.charAt(0)) {  // skip it
            ov = ov.substring(1, ov.length);
        }

        for (i = 0; i < ov.length; i++) {
            var ch = ov.charAt(i);

            // build up formatted number
            if (ch >= '0' && ch <= '9') {
                if (n == 0) v += "(";
                else if (n == 3) v += ") ";
                else if (n == 6) v += "-";
                v += ch;
                n++;
            }
            // check for extension type section;
            // are spaces, dots, dashes and parentheses the only valid non-digits in a phone number?
            if (! (ch >= '0' && ch <= '9') && ch != ' ' && ch != '-' && ch != '.' && ch != '(' && ch != ')') {
                x = i;
                break;
            }
        }
        // add the extension
        if (x >= 0) v += " " + ov.substring(x, ov.length);

        // if we recognize the number, then format it
        if (n == 10 && v.length <= 40) field.value = v;
    }
    return true;
}

function clearcols () {
    for (var frm = 0; frm < document.forms.length; frm++) {
        for (var fld = 0; fld < document.forms[frm].elements.length; fld++) {
            var elt = document.forms[frm].elements[fld];
            if (elt.name == "c" || elt.name.substring(0,2) == "c_") {
                elt.checked = false;
            }
        }
    }
}

function setcols () {
    for (var frm = 0; frm < document.forms.length; frm++) {
        for (var fld = 0; fld < document.forms[frm].elements.length; fld++) {
            var elt = document.forms[frm].elements[fld];
            if (elt.name == "c" || elt.name.substring(0,2) == "c_") {
                elt.checked = true;
            }
        }
    }
}

function setUsername(uname, fname, lname, suffix) {
    if (uname.value.length == 0) {
        uname.value =
                    fname.value.substring(0,1).toLowerCase()
                    + lname.value.toLowerCase()
                    + "@"
                    + suffix.value;
    }
}
function setAlias(alias, fname, lname) {
    if (alias.value.length == 0) {
        alias.value = fname.value.substring(0,1).toLowerCase() +
                      lname.value.substring(0,4).toLowerCase();
    }
}

// POPUP WINDOW NUMBER 1
function popWin(url) {
   closePopup();
    curPopupWindow = window.open(url,"win","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=550,height=300",false);
}
/**
 * Do NOT remove this function!
 * This function is used from within our help docs.
 */
function popWin2(url) {
   win = window.open(url,"win","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=720,height=500",false);
}
function popWin3(url) {
   win = window.open(url,"win","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=550,height=300",false);
}
function popWin4(url) {
   win = window.open(url,"win","toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=550,height=400",false);
}



/**
 * Do NOT remove this function!
 * Our help docs tell our customers to use this call to open links up in a new browser window.
 */
function adminWin(url) {
   win = window.open(url,"win","toolbar=1,location=1,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=800,height=600",false);
}

// Changed name of window for printWin so that Printable views do not disappear
// Newname is popWin, Oldname(changed) was curPopupWindow
function printWin(url) {
  popWin = window.open(url,"win","dependent=no,toolbar=1,directories=0,location=0,status=1,menubar=1,scrollbars=1,resizable=1,width=705,height=400",false);
  popWin.focus();
}

/* DUELING */
function moveSelectElement3(sourceSelect, targetSelect, sourceLabel, targetLabel, keepTarget) {
    if (sourceSelect.selectedIndex > -1) {
        for (i=0; i < sourceSelect.length; ++i) {
            var selectedOption = sourceSelect.options[i];
            if (selectedOption.selected) {
                if (selectedOption.text != sourceLabel) {
                    var newOption = new Option(selectedOption.text, selectedOption.value);
                    if (targetSelect.options.length > 0 && targetSelect.options[0].text == targetLabel) {
                        targetSelect.options[0] = newOption;
                        targetSelect.selectedIndex = 0;
                    } else {
                        targetSelect.options[targetSelect.options.length] = newOption;
                        targetSelect.selectedIndex = targetSelect.options.length - 1;
                    }
                } else {
                    sourceSelect.selectedIndex = -1;
                }
            }
        }
        if(!keepTarget)
        {   removeSelectElement3(sourceSelect, sourceLabel);
        }
    }
}


function sortOrderNumeric(a, b) { return a - b; }
function sortOrderNumericReverse(a, b) { return b - a; }
function moveSelectElementIds(sourceSelect, targetSelect, ids, keepTarget, sourceLabel) {
    if (ids) {
        // Copy over the new ones
        for (i=0; i< ids.length ; i++) {
            var selectedOption = sourceSelect.options[ids[i]];
            var newOption = new Option(selectedOption.text, selectedOption.value);
            targetSelect.options[targetSelect.options.length] = newOption;
        }
        // Remove the old ones
        if (!keepTarget) {
            ids = ids.sort(sortOrderNumericReverse);  // sort to keep them in order
            for (i = 0; i < ids.length; i++) sourceSelect.options[ids[i]]=null;
        }
        if(!keepTarget)
        {
            if (sourceSelect.length == 0)
            {   var placeHolder = new Option(sourceLabel, sourceLabel);
                sourceSelect.options[0] = placeHolder;
            }
        }
    }
}

function moveOption (sourceSelect, targetSelect,
                     keepSourceLabel, unmovableSourceValues, unmovableAlertMessage,
                     keepTargetLabel) {

    var sourceOptions = sourceSelect.options;

    var canMove;
    var option;

    // find which ones are selected...
    var selectedIds = new Array ();
    var index = 0;
    if (sourceSelect.cannotBeEmpty) {
        var numSelected = 0;
        for (var i = 0; i < sourceSelect.length; i++) {
            if (sourceSelect.options[i].selected) numSelected++;
        }
        if (numSelected == sourceSelect.options.length) {
            if (sourceSelect.handleEmptyList) {
                sourceSelect.handleEmptyList();
            }
            return;
        }
    }
    for (var i = 0; i < sourceSelect.length; i++) {
        option = sourceOptions[i];
        if (option.selected) {
            canMove = (option.text != keepSourceLabel);
            if (canMove && unmovableSourceValues != null) {
                // make sure we don't move any options defined as unmovable
                for (var j = 0; j < unmovableSourceValues.length; j++) {
                    if (unmovableSourceValues[j] == option.value) {
                        canMove = false;
                        if (unmovableAlertMessage != null)
                            alert(unmovableAlertMessage);
                        break;
                    }
                }
            }

            // if this option can be moved we add it to our array of elements to move
            if (canMove) {
                selectedIds[index] = i;
                index++;
            } else {
                // if we can't move this option, then unselect it
                option.selected = false;
            }
        }
    }

    // move them over one by one
    var targetOptions = targetSelect.options;
    if (selectedIds.length > 0) {
        targetSelect.selectedIndex = -1;
        for (var i = 0; i < selectedIds.length; i++) {
            option = new Option (sourceOptions[selectedIds[i]].text, sourceOptions[selectedIds[i]].value);

            // replace the target value if its the last one
            if (targetOptions.length == 1 && targetOptions[0].text == keepTargetLabel) {
                targetOptions[0] = option;
                targetOptions[0].selected = true;
            } else {
                targetOptions[targetOptions.length] = option;
                targetOptions[targetOptions.length-1].selected = true;
            }
        }
    }

    // notify the Select Elements that their contents have changed
    if (targetSelect["onchange"]) {
        targetSelect.onchange();
    }
    if (sourceSelect["onchange"]) {
        sourceSelect.onchange();
    }

    // remove selected values from the source, starting with the last one selected
    for (var i = selectedIds.length - 1; i > -1; i--) {
        sourceSelect.remove(selectedIds[i]);
    }

    // Workaround here for a bug in IE:
    // If you have a select element with many values, and you've scrolled to
    // the bottom and move an option from the top-most element you can now see,
    // IE would not refresh the select element, leaving a hole in the list.
    // By forcing the select element disabled and back, it seems to refresh the
    // element properly.
    sourceSelect.disabled = true;
    sourceSelect.disabled = false;

    // make sure we don't get an empty list
    if (sourceOptions.length == 0) {
        sourceOptions[0] = new Option (keepSourceLabel, keepSourceLabel);
    }

    // if we moved anything, put the focus on the target list box
    if (selectedIds.length > 0) targetSelect.focus ();

    // invoke if the Slect Element has local function
    if (targetSelect["onLocalMoveOptions"])
        targetSelect.onLocalMoveOptions();
    if (sourceSelect["onLocalMoveOptions"])
        sourceSelect.onLocalMoveOptions();
}

function removeSelectElement3(sourceSelect, sourceLabel)
{   if (sourceSelect.selectedIndex > -1)
    {   for (i=sourceSelect.length-1; i > -1; i--)
        {   if (sourceSelect.options[i].selected) sourceSelect.options[i] = null;
        }
        if (sourceSelect.length == 0)
        {   var placeHolder = new Option(sourceLabel, sourceLabel);
            sourceSelect.options[0] = placeHolder;
        }
    }
}


function moveUp(sourceSelect, topSourceValue, unmovableAlertMessage) {
    if (sourceSelect.length > 1) {
        var options = sourceSelect.options;

        // find which ones are selected...
        var selectedIds = new Array ();
        var index = 0;
        if (topSourceValue != null) {
            if (options[0].value == topSourceValue && options[1].selected) {
                options[1].selected = false;
                if (unmovableAlertMessage != null) {
                    alert(unmovableAlertMessage);
                    return;
                }
            }
        }
        for (var i = 1; i < sourceSelect.length; i++) {
            if (options[i].selected) {
                selectedIds[index] = i;
                index++;
            }
        }

        // move each selected option up
        var selId;
        for (var i = 0; i < selectedIds.length; i++) {
            selId = selectedIds[i];
            privateMoveUp (options, selId);
            options[selId].selected = false;
            options[selId-1].selected = true;
        }

        sourceSelect.focus ();

        // invoke if the Slect Element has local function
        if (sourceSelect["onLocalMoveUp"])
            sourceSelect.onLocalMoveUp();
    }
}

function moveDown(sourceSelect, topSourceValue, unmovableAlertMessage) {
    if (sourceSelect.length > 1) {
        var options = sourceSelect.options;

        // find which ones are selected
        var selectedIds = new Array ();
        var index = 0;
        if (topSourceValue != null) {
            // make sure we don't move the top value down
            if (topSourceValue == options[0].value && options[0].selected) {
                options[0].selected = false;
                if (unmovableAlertMessage != null)
                    alert(unmovableAlertMessage);
            }
        }

        for (var i = sourceSelect.length-2; i >= 0; i--) {
            if (sourceSelect.options[i].selected) {
                // add any remaining selected elements to our array of elements to move
                selectedIds[index] = i;
                index++;
            }
        }

        // move each selected element down
        var selId;
        for (var i = 0; i < selectedIds.length; i++) {
            selId = selectedIds[i];
            privateMoveDown (options, selId);
            options[selId].selected = false;
            options[selId+1].selected = true;
        }

        sourceSelect.focus ();

        // invoke if the Slect Element has local function
        if (sourceSelect["onLocalMoveDown"])
            sourceSelect.onLocalMoveDown();
    }
}

function moveTop(sourceSelect) {

    if (sourceSelect.length > 1) {
        var options = sourceSelect.options;

        // find which ones are selected...
        var selectedIds = new Array ();
        var index = 0;

        for (var i = 0; i < sourceSelect.length; i++) {
            if (options[i].selected) {
                selectedIds[index] = i;
                index++;
            }
        }

        // Move each selected option up to the topmost available
        // position.  The first one in the selected list gets position 0,
        // second one gets position 1, and so on.
        var selId;
        for (var i = 0; i < selectedIds.length; i++) {
            selId = selectedIds[i];
            // delta is how many positions up to move the selected item
            // to get it into the target position, which is position "i"
            delta = selId-i;
            for (var j = 0 ; j < delta; j++) {         
                privateMoveUp (options, selId-j);
                options[selId-j].selected = false;
                options[(selId-j)-1].selected = true;
                }
        }
        
        sourceSelect.focus ();

        // invoke if the Slect Element has local function
        if (sourceSelect["onLocalMoveTop"])
            sourceSelect.onLocalMoveTop();
    }
}

function moveBottom(sourceSelect) {

    if (sourceSelect.length > 1) {
        var options = sourceSelect.options;

        // find which ones are selected...
        var selectedIds = new Array ();
        var index = 0;

        for (var i = 0; i < sourceSelect.length; i++) {
            if (options[i].selected) {
                selectedIds[index] = i;
                index++;
            }
        }

        // move each selected option down - starting from the end
        // of the selected items array, we'll move each item down to 
        // the next lowest position (i.e., last one in the array ends up at 
        // the very bottom, nth one in the array ends up (array length - n) from
        // the bottom
        // targetPos is position the element is moving to
        var targetPos = sourceSelect.length-1; 
        var selId;
        for (var i = selectedIds.length-1; i >= 0 ; i--) {
            selId = selectedIds[i];
            // delta is how much to move down from the current position to get to the target position
            var delta = targetPos-selId; 
            for (var j = 0 ; j < delta; j++) {
                privateMoveDown (options, selId+j);
                options[selId+j].selected = false;
                options[(selId+j)+1].selected = true;
                }
            targetPos--;
        }
        
        sourceSelect.focus ();

        // invoke if the Slect Element has local function
        if (sourceSelect["onLocalMoveBottom"])
            sourceSelect.onLocalMoveBottom();
    }
}


/*
 * Do not call this function directly.
 * As it does NO bounds checking.
 * Please use the moveUp or moveTop calls.
 */
function privateMoveUp (options, index) {
    var newOption = new Option (options[index-1].text, options[index-1].value);
    options[index-1].text = options[index].text;
    options[index-1].value = options[index].value;
    options[index].text = newOption.text;
    options[index].value = newOption.value;
}

/*
 * Do not call this function directly.
 * As it does NO bounds checking.
 * Please use the moveDown or moveBottom calls.
 */
function privateMoveDown (options, index) {
    var newOption = new Option (options[index+1].text, options[index+1].value);
    options[index+1].text = options[index].text;
    options[index+1].value = options[index].value;
    options[index].text = newOption.text;
    options[index].value = newOption.value;
}


/**
 * Used when submitting a dueling list boxes element.
 * Stores all the values into hidden form parameters so we can get them out
 */
function saveAllSelected (fromSelectArray, toArray, delim, escape, emptyLabel) {
    var i,j,escapedValue;
    // loop through all the select elements
    for (i = 0; i < fromSelectArray.length; i++) {
        toArray[i].value = ''; // clear out the value to start
        // now loop through all the values in the select element
        for (j = 0; j < fromSelectArray[i].length; j++) {
            // copy over the value as long as it is not the emptyLabel
            if (!(fromSelectArray[i].length == 1 && fromSelectArray[i].options[0].value == emptyLabel)) {
                var val = fromSelectArray[i].options[j].value.replace(new RegExp(escape+escape,"g"), escape+escape);
                toArray[i].value += val.replace(new RegExp(delim,"g"), escape+delim);
            }

            // add the delimiter (except after the last one)
            if (j + 1 < fromSelectArray[i].length) {
                toArray[i].value += delim;
            }
        }
    }
}

/** Function to deal with multiple dropdowns */
function ddChangeAllElements(object,elemIds) {
  var index = object.selectedIndex;
  if (index > 0) {
    for (var i = 0; i < elemIds.length; i++) {
      var elem = document.getElementById(elemIds[i]);
      if (elem) elem.selectedIndex = index - 1;
    }
  }
}
function ddElementChange(object,elemIds,overrideId) {
    var initial = document.getElementById(elemIds[0]).selectedIndex;
    for (var i = 1; i < elemIds.length; i++) {
        var elem = document.getElementById(elemIds[i]);
        if (elem.selectedIndex != initial) {
            initial = -1;
            break;
        }
    }
    document.getElementById(overrideId).selectedIndex = initial + 1;
}
        
function ddRadioClicked(control,elemIds,overrideId) {
    var isAll = control.value == 'all';
    document.getElementById(overrideId).disabled = !isAll;
    for (var i = 0; i < elemIds.length; i++) {
        var elem = document.getElementById(elemIds[i]);
        if (elem) elem.disabled = isAll;
        if (isAll) {
            var index = document.getElementById(overrideId).selectedIndex;
            if (index > 0) elem.selectedIndex = index - 1;
        }
    }
}

function openwizard(url, name, resizable) {
  var win = window.open('', name, 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable='+resizable+',width=675,height=550,screenx=50,screeny=10,left=50,top=10',false)
  if ((win.document.URL == '') || (win.document.URL == 'about:blank')) win.location = url;
  win.focus ();
}

function openwizard2(url, name, resizable) {
  var win = window.open(url, name, 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable='+resizable+',width=675,height=550,screenx=50,screeny=10,left=50,top=10',false)

}

function escapeUTF(src) {
    var ret = "";
    for (i = 0; i < src.length; i++) {
        var ch = src.charCodeAt(i);
        if (ch <= 0x7F) {
            ret += escape(src.charAt(i));
        } else if (ch <= 0x07FF) {
            ret += '%' + ((ch >> 6) | 0xC0).toString(16) + '%' + ((ch & 0x3F) | 0x80).toString(16);
        } else if (ch >= 0x0800) {
            ret += '%' + ((ch >> 12) | 0xE0).toString(16) +
                   '%' + (((ch >> 6) & 0x3F) | 0x80).toString(16) + '%' + ((ch & 0x3F) | 0x80).toString(16);
        }
    }
    return ret;
}

function openRefer(url) {
    window.open(url, 'referv2', 'resizable=no,toolbar=no,status=no,directories=no,scrollbars=yes,width=420,height=500', false);
}

function changeOpenerWindowLocation (url) {
    if ((window.top.opener == null) || window.top.opener.closed) {
        window.top.open (url);
    } else {
        window.top.opener.location.href = url;
        window.top.opener.focus ();
    }
}

function verifyChecked(form, element_name, errorMessage) {
    for (i = 0; i < form.elements.length; i++) {
        if ((form.elements[i].name == element_name) && form.elements[i].checked) {
            return true;
        }
    }

    // if we haven't returned yet, it's not checked
    alert(errorMessage);
    return false;
}

function verifyCheckedWarning(form, element_name, errorMessage) {
    var isChecked = false;
    for (i = 0; i < form.elements.length; i++) {
        if ((form.elements[i].name == element_name) && form.elements[i].checked) {
            isChecked = true;
        }
    }
    if (isChecked) {
        return window.confirm(errorMessage);
    }
    return true;
}

function submitFormActionURL (form, url) {
    form.action = url;
    form.submit();
}

function SelectChecked(form, element_name, value)
{
    var i = 0;
    for (i = 0; i < form.elements.length; i++) {
        if (form.elements[i].name == element_name) {
            form.elements[i].checked = value;
        }
    }
}

function SelectAllOrNoneByCheckbox(form, element_name, control)
{
    SelectChecked(form, element_name, control.checked);
}

function getLoginCookieValue()
{
    var c = document.cookie;
    var idx = c.indexOf('login=');
    if ( idx == -1) return "";
    idx += 'login='.length;
    var end = c.indexOf(';',idx);
    if ( end == -1) end = c.length;
    return c.substring(idx,end);
}

function loader()
{
     var username = getLoginCookieValue();
     if (username.length > 0) {
         document.login_noop.un_noop.value = username;
         document.login.un.value = username;
         document.login.pw.focus();
     } else {
         document.login_noop.un_noop.focus();
     }
     document.login.width.value=screen.width;
     document.login.height.value=screen.height;
}

    function loadMSP(id) {
        var sElem = document.getElementById(id + '_selected');
        var uElem = document.getElementById(id + '_unselected');
        resizeMSP(sElem, uElem);
    }
    
    function resizeMSP(sElem, uElem) {
        if (!sElem || !uElem) return;
        if (!sElem.style.width) {
            var selW = (sElem.scrollWidth > uElem.scrollWidth) ? sElem.scrollWidth : uElem.scrollWidth;
            selW = selW + 35;
            sElem.style.width = selW;
            uElem.style.width = selW;
        }
    }

    function handleMSPChange(sel) {
        var sElem = document.getElementById(sel.id + '_selected');
        var uElem = document.getElementById(sel.id + '_unselected');
        var sI = 0;
        var uI = 0;
        sElem.length = 0;
        uElem.length = 0;
        
        for (var i = 0; i < sel.options.length; i++) {
            if (sel.options[i].selected) {
                sElem.options[sI] = new Option(sel.options[i].text, i);
                sI++;
            } else {
                uElem.options[uI] = new Option(sel.options[i].text, i);
                uI++;
            }
        }
        
        resizeMSP(sElem, uElem);
    }

    function handleMSPSelect(selId) {
        var mainElem = document.getElementById(selId);
        var uElem = document.getElementById(selId + '_unselected');
        for (var i = 0; i < uElem.options.length; i++) {
            if (uElem.options[i].selected) {
                mainElem.options[parseInt(uElem.options[i].value)].selected = true;
            }
        }
        handleMSPChange(mainElem);
    }

    function handleMSPUnSelect(selId) {
        var mainElem = document.getElementById(selId);
        var sElem = document.getElementById(selId + '_selected');
        for (var i = 0; i < sElem.options.length; i++) {
            if (sElem.options[i].selected) {
                mainElem.options[parseInt(sElem.options[i].value)].selected = false;
            }
        }
        handleMSPChange(mainElem);
    }

    function handleSelectAllNoneCheckboxClick(chkbox, children) {
        for (var i = 0; i < children.length; i++) {
            var child = document.getElementById(children[i]);
            if (child) {
                child.checked = chkbox.checked;
            }
        }
    }

    function getObjX(obj){
        if(!obj.offsetParent) return 0;
        var x = getObjX(obj.offsetParent);
        return obj.offsetLeft + x;
    }

    function getObjY(obj){
        if(!obj.offsetParent) return 0;
        var y = getObjY(obj.offsetParent);
        return obj.offsetTop + y;
    }
    function getScrollX(){
        if (window.pageXOffset) return window.pageXOffset;
        if (document.body.scrollHeight) return document.body.scrollLeft;
    }
    function getScrollY(){
        if (window.pageYOffset) return window.pageYOffset;
        if (document.body.scrollWidth) return document.body.scrollTop;
    }
    function getMouseX(evt) {
        if (evt.pageX) return evt.pageX;
        obj = getSrcElement(evt);
        return getScrollX() + evt.x;
    }
    function getMouseY(evt) {
        if (evt.pageY) return evt.pageY;
        return getScrollY() + evt.y;
    }
    function getSrcElement(evt) {
        evt = getEvent(evt);
        if (evt.srcElement) return evt.srcElement;
        return evt.currentTarget;
    }
    function getEvent(evt) {
        if (isIE) return window.event;
        return evt;
    }
    function ltrim(s) {
        return s.replace( /^\s*/, "" );
    }

    function rtrim(s) {
        return s.replace( /\s*$/, "" );
    }

    function trim(s){
        return rtrim(ltrim(s));
    }

    function escapeHTML(v) {
        v = v.replace(/&/g, '\&amp;');
        v = v.replace(/</g, '&lt;');
        v = v.replace(/>/g, '&gt;');
        return v;
    }
    function unescapeHTML(v) {
        v = v.replace(/\&amp;/g, '&');
        v = v.replace(/&lt;/g, '<');
        v = v.replace(/&gt;/g, '>');
        return v;
    }

    function isValidEmail(email,list) {
        if (!email) return false;
        var components = email.split('@');
        if (components.length != 2) return false;
        if (components[1].indexOf('.') < 0) return false;
        if (list) {
            var items = list.split(',');
            for (var i = 0; i < items.length; i++) {
                var domain = items[i];
                if (components[1] == domain) return true;
                if ((components[1].indexOf(domain, components[1].length - domain.length) > 0) &&
                    (components[1].charAt(components[1].length - domain.length - 1) == '.')) return true;
            }
            return false;
        }
        return true;
    }

    function setCookie(name, value, expires, path) {
        document.cookie= name + '=' + escape(value) +
            ((expires) ? '; expires=' + expires.toGMTString() : '') +
            ((path) ? '; path=' + path : '; path=/');
    }

    function getCookie(name) {
        var dc = document.cookie;
        var prefix = name + '=';
        var begin = dc.indexOf('; ' + prefix);
        if (begin == -1) {
            begin = dc.indexOf(prefix);
            if (begin != 0) return null;
        } else {
            begin += 2;
        }
        var end = document.cookie.indexOf(';', begin);
        if (end == -1) {
            end = dc.length;
        }
        return unescape(dc.substring(begin + prefix.length, end));
    }

    function deleteCookie(name, path) {
        if (getCookie(name)) {
            document.cookie = name + '=' +
                ((path) ? '; path=' + path : '; path=/') +
                '; expires=Thu, 01-Jan-70 00:00:01 GMT';
        }
    }

    function addTwistCookie(cookieName, headerId, onOff) {
        var currentCookie = getCookie(cookieName);
        var cookieVal = headerId + ':' + (onOff ? '1' : '0') + ',' ;

        if (currentCookie) {
            var start = currentCookie.indexOf(headerId);
            while (start > -1) {
                var end = start + 18;
                var val = currentCookie.substring(start, end);
                currentCookie = currentCookie.substring(0, start) + currentCookie.substring(end, currentCookie.length);
                start = currentCookie.indexOf(headerId);
            }
            cookieVal = currentCookie + cookieVal;
        }
        setCookie(cookieName, cookieVal);
    }

    function handleTextAreaElementChange(textId, countId, tableId, myTextId, maxLength, remainingText, overText) {

        var textArea = document.getElementById(textId);
        var counter = document.getElementById(countId);
        var myTable = document.getElementById(tableId);
        var myText = document.getElementById(myTextId);

        if (!textArea || !counter || !myTable || !myText) return;

        var valueLength = textArea.value.length;
        if (valueLength > 0 && !(isIE || isIE5)) {
            var lines = textArea.value.match(/\n/g);
            if (lines) valueLength += lines.length;
        }
        var remaining = maxLength - valueLength;

        if (remaining < 0) {
            counter.style.backgroundColor = 'FF3333';
            counter.style.color = 'FFFFFF';
            counter.innerHTML = (-1 * remaining);
            myText.style.backgroundColor = 'FF3333';
            myText.style.color = 'FFFFFF';
            myText.innerHTML = overText;
            myTable.style.visibility = 'visible';
        } else if (remaining < 50) {
            counter.style.backgroundColor = 'FFFF66';
            counter.style.color = '000000';
            counter.innerHTML = remaining;
            myText.style.backgroundColor = 'FFFF66';
            myText.style.color = '000000';
            myText.innerHTML = remainingText;
            myTable.style.visibility = 'visible';
        } else {
            myTable.style.visibility = 'hidden';
        }
    }

/**
 *
 * Reports
 *
 */

// Used by filter lookup widgets to back fill the selected values
var filterLookupValueElem;

// Posts to load the filter lookup widget into a new window
function openFilterLookupWindow(formName, fieldSelectName, valueElemName) {
    filterLookupValueElem = valueElemName;
    var reportForm = document.getElementById(formName);
    reportForm.target = 'filter_lookup';
    var fieldSelect = document.getElementById(fieldSelectName);
    var field = fieldSelect.options[fieldSelect.selectedIndex];
    reportForm.lookup.value = field.value;
    reportForm.submit();
    reportForm.target = '';
    reportForm.lookup.value = '';
}

// popupRequest: 'validate', 'new', 'edit', 0+= edit formula index
function submitCalcAgg(popupRequest, iFormula) {
    var reportForm = document.report;
    if (!reportForm) reportForm = opener.document.report;
    reportForm.target = 'aggcalc_popup';
    reportForm.calcagg_request.value = popupRequest;
    reportForm.calcagg_index.value = iFormula;

    // Copy field values between wizard and popup
    if (popupRequest == 'new') {
        clearCalcAgg(reportForm, "_v");
    } else if (popupRequest == 'edit') {
        copyCalcaggParams(reportForm, iFormula, reportForm, "_v");
    } else if (popupRequest == 'done' || popupRequest == 'validate') {
        var popupForm = document.getElementById('calcagg_form');
        copyCalcaggParams(popupForm, "_v", reportForm, "_v");
    }

    reportForm.nav.value = 'agg';
    reportForm.submit();

    reportForm.calcagg_request.value = '';
    reportForm.target = '';
}

// Copies validated formula from popup to parent
function finishValidCalcAgg(iFormula) {
    var reportForm = opener.document.getElementById('report');
    var popupForm = document.getElementById('calcagg_form');

    reportForm.calcagg_index.value = iFormula;

    // Update display
    copyCalcaggParams(popupForm, "_v", reportForm, iFormula);
    reportForm['calcagg_active_v'].value = popupForm['calcagg_name_v'].value;

    reportForm.nav.value = 'agg';
    reportForm.submit();

    self.close();
}

var calcagg_params = ['calcagg_label', 'calcagg_name', 'calcagg_formula', 'calcagg_type', 'calcagg_desc', 'calcagg_scale'];

function clearCalcAgg(form, suffix) {
    for(var param in calcagg_params) {
        form[calcagg_params[param] + suffix].value = '';
    }
}

function deleteCalcAgg(iFormula) {
    var reportForm = document.getElementById('report');
    clearCalcAgg(reportForm, iFormula);
    reportForm.nav.value = 'agg';
    reportForm.submit();
}

function copyCalcaggParams(srcForm, srcSuffix, destForm, destSuffix) {
    for(var param in calcagg_params) {
        destForm[calcagg_params[param] + destSuffix].value = srcForm[calcagg_params[param] + srcSuffix].value;
    }
}

function getIframeContents(iFrame) {
    var document = iFrame.contentDocument || iFrame.contentWindow.document;
    return document.body.innerHTML;
}

function adjustIFrameSize(iFrame) {
    if (iFrame) {
        var bodyObj;
        var h = 0;
        var newHeight;
        if(iFrame.contentDocument) {
            newHeight = iFrame.contentDocument.body.offsetHeight;
        } else {
            if (document.frames && document.frames(iFrame.id)) {
                bodyObj = document.frames(iFrame.id).document.body;
            } else {
                bodyObj = iFrame.document.body
            }
            newHeight = (bodyObj.children.length <= 0) ? 0 : bodyObj.scrollHeight;
        }
        // Only resize if the difference is more than 15.
        var delta = iFrame.height - newHeight;
        if (delta < 0) delta = -delta;
        if (delta > 15) iFrame.height = newHeight;
    }
}

function showTextStateField(textFieldName, picklistFieldName) {
    textFieldName.style.display='';
    picklistFieldName.style.display='none';
}

function showPicklistStateField(stateList, textFieldName, picklistFieldName) {
    var stateValueList = stateList[0];
    var stateDisplayList = stateList[1];
    picklistFieldName.options.length=1
    for(i=0;i<stateValueList.length;i++) {
        picklistFieldName.options[i+1]= new Option(stateValueList[i],stateDisplayList[i]);
    }
    textFieldName.style.display='none';
    picklistFieldName.style.display='';
}

function showStateListForCountry(value, countryStateMap, textFieldName, picklistFieldName) {
    var stateList = countryStateMap[value];
    textFieldName.value='';
    if (stateList) {
        showPicklistStateField(stateList, textFieldName, picklistFieldName);
    } else {
        showTextStateField(textFieldName, picklistFieldName);
    }
}

// resize IMG to fit into the given height/width.
function scaleImage(imgObj, h, w) {
    // try to fit to the height first
    var x = imgObj.width * h / imgObj.height;
    var y = h;
    if (x > w) { // too wide. adjust to the max width
        x = w;
        y = imgObj.height * w / imgObj.width;
    }
    // scale only if the given image is bigger than the frame
    if (x < imgObj.width || y < imgObj.height) {
        imgObj.width = x;
        imgObj.height = y;
    }
}

function refreshParentWindow(isClose) {
	if(window.opener==null) return;
	
	window.opener.location.href = window.opener.location.href;
	if (window.opener.progressWindow)				
	{
		window.opener.progressWindow.close()
	}
	if(isClose)
	{ 
		window.close();window.opener=null;
	}
}


function CommonDelete(delTabID,delID,mess,ret )
{
var retURL=document.location.href;
var msg="Are you sure?";
if (typeof(mess)!="undefined")
{
  msg=mess;
}
if (typeof(ret)!="undefined")
{
  retURL=ret;
} 
if(confirm(msg))
document.location.href="deleteredirect.aspx?delID="+delID+"&delTabID="+delTabID+"&retURL="+retURL+"##";
}
