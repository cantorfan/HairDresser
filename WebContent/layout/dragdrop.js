var isIE = navigator.appName.indexOf("Microsoft") != -1;
var isIE5 = navigator.userAgent.indexOf('MSIE 5.0') > 0;
var isIE55 = navigator.userAgent.indexOf('MSIE 5.5') > 0;

function log(s) {
}
function newLog(s) {
}

var isSelfService = '0';
var isCaseClose = '0';
var maxNumColumns = 2;

function getEvent(evt) {
    if (isIE) return window.event;
    return evt;
}
function getSrcElement(evt) {
    if (isIE) return evt.srcElement;
    return evt.currentTarget;
}

function handleMouseDown(evt) {
    if (isIE5) return;
    clearTextSelection();
    evt = getEvent(evt);
    obj = getSrcElement(evt);
    if (!evt.shiftKey && !evt.ctrlKey && !isSelected(obj)) {
        clearSelected();
        setSelected(obj);
        if (!currentSelectedObj) return;
    }
    mousedDown = true;
}
currentSelectedObj = null;
selectedBucket = new Array();
mousedDown = false;
currentOffsetX = -1;
currentOffsetY = -1;
function clearSelected() {
    for (var i = 0; i < selectedBucket.length; i++) {
        if (!selectedBucket[i].used) {
            selectedBucket[i].style.backgroundColor = selectedBucket[i].originalBGColor;
        }
    }
    selectedBucket = new Array();
    currentSelectedObj = null;
}
function removeSelected(obj) {
    for (var i = 0; i < selectedBucket.length; i++) {
        if (selectedBucket[i].id == obj.id) {
            selectedBucket.splice(i, 1);
            obj.style.backgroundColor = obj.originalBGColor;
            defaultCursor(obj);
        }
    }
    if (currentSelectedObj == obj) {
        currentSelectedObj = null;
        if (selectedBucket.length > 0) {
            currentSelectedObj = selectedBucket[selectedBucket.length - 1];
        }
    }
}
function setSelected(obj) {
    if (isSelected(obj)) {
        removeSelected(obj);
        return;
    }

    currentSelectedObj = obj;
    obj.originalBGColor = obj.style.backgroundColor;
    obj.style.backgroundColor = '#6699CC';
    moveCursor(obj);
    if (isIE5) {
        selectedBucket = selectedBucket.concat(currentSelectedObj);
    } else {
        selectedBucket.push(currentSelectedObj);
    }
}
function multiSelect(obj) {
    if (!currentSelectedObj) return;
    var tableId = getTableId(obj);

    if (getTableId(currentSelectedObj) != tableId) {
        removeSelected(currentSelectedObj);
        setSelected(obj);
        return;
    }


    var prevSelectedObj = currentSelectedObj;
    var rowNum1 = getRowNum(currentSelectedObj);
    var rowNum2 = getRowNum(obj);
    var colNum1 = getColNum(currentSelectedObj);
    var colNum2 = getColNum(obj);
    var startRow = Math.min(rowNum1, rowNum2);
    var endRow = Math.max(rowNum1, rowNum2);
    var startCol = Math.min(colNum1, colNum2);
    var endCol = Math.max(colNum1, colNum2);
    if (startRow == endRow && startCol == endCol) return;
    clearSelected();
    for (var i = startRow; i <= endRow; i++) {
        for (var j = startCol; j <= endCol; j++) {
            var cellId = constructId(tableId, i, j);
            var cell = document.getElementById(cellId);

            if (!cell.used && cell.innerHTML != '') {
                setSelected(cell);
            }
        }
    }
    currentSelectedObj = prevSelectedObj;
}

function isSelected(obj) {
    for (var i = 0; i < selectedBucket.length; i++) {
        if (selectedBucket[i].id == obj.id) return true;
    }
    return false;
}

function handleMouseClick(evt) {
    clearTextSelection();
    evt = getEvent(evt);
    if (isIE5) {
        if (!currentSelectedObj || evt.ctrlKey) {
            obj = getSrcElement(evt);
            if (obj.used) return;
            if (obj.innerHTML == '') return;
            setSelected(obj);
            mousedDown = true;
        } else if (evt.shiftKey) {
            obj = getSrcElement(evt);
            if (obj.used) return;
            if (obj.innerHTML == '') return;
            multiSelect(obj);
        } else {
            handleMouseUp(evt);
        }
    } else {
        if (evt.ctrlKey) {
            setSelected(obj);
        } else if (evt.shiftKey) {
            multiSelect(obj);
        }
    }

}

function handleMouseUp(evt) {

    clearTextSelection();
    evt = getEvent(evt);
    if (!mousedDown && !evt.ctrlKey && !evt.shiftKey) {
        clearSelected();
        return;
    }
    evt = getEvent(evt);
    document.getElementById('dragDummy').style.visibility = 'hidden';
    if (currentSelectedObj) {
        if (currentHighlightedObj) {
            if (isSection(currentSelectedObj)) {
                swapSections(evt);
                handleDragOut(currentHighlightedObj);
                currentHighlightedObj = null;
                clearSelected();
            } else {

                if (!(isInAvailableSection(currentSelectedObj) && isInAvailableSection(currentHighlightedObj))) {
                    insertCell(evt);
                }
                handleDragOut(currentHighlightedObj);
                currentHighlightedObj = null;
                clearSelected();
            }
        }
        if (evt.ctrlKey) {
            mousedDown = false;
            return;
        }
    }
    mousedDown = false;
}


document.onmousemove = handleMouseMove;
if (!isIE5) document.onmouseup = handleMouseUp;


function handleMouseMove(evt) {
    evt = getEvent(evt);
    if (currentSelectedObj && mousedDown) {
        clearTextSelection();

        var obj = getSrcElement(evt);

        var scrollX = getScrollX();
        var scrollY = getScrollY();
        var dragDummy = document.getElementById('dragDummy');
        var dragDummyValue = document.getElementById('dragDummyValue');
        dragDummy.style.visibility = 'visible';
        dragDummyValue.innerHTML = selectedBucket.length > 1 ? 'MultiSelect' : isSection(currentSelectedObj) ? 'Section' : currentSelectedObj.fName;
        dragDummy.style.left = (getMouseX(evt) - currentOffsetX) + "px";
        dragDummy.style.top = (getMouseY(evt) - currentOffsetY) + "px";

        var currentX = getObjX(dragDummy) - scrollX;
        var theWidth = 500;
        if (document.documentElement && document.documentElement.clientWidth)
            theWidth = document.documentElement.clientWidth;
        else if (document.body)
            theWidth = document.body.clientWidth
        if (currentX > theWidth) {
            if (isIE) document.body.scrollLeft = document.body.scrollLeft + 10;
            //else window.scroll(10, 0);
        } else if (currentX < 0) {
            if (isIE) document.body.scrollLeft = document.body.scrollLeft - 10;
            //else window.scroll(-10, 0);
        }

        var currentY = getObjY(dragDummy) - scrollY;
        var theHeight = 500;
        if (document.documentElement && document.documentElement.clientHeight)
            theHeight = document.documentElement.clientHeight;
        else if (document.body)
            theHeight = document.body.clientHeight
        if (currentY > theHeight - 50) {
            //if (isIE) document.documentElement.scrollTop = document.body.scrollTop + 50;
            window.scrollBy(0, 50);
        } else if (currentY < 50) {
            // if (isIE) document.documentElement.scrollTop = document.body.scrollTop - 50;
            window.scrollBy(0, -50);
        }

    }
}
currentHighlightedObj = null;
function handleMouseOver(evt) {
    evt = getEvent(evt);
    obj = getSrcElement(evt);
    showProperties(evt);
    if (currentSelectedObj && mousedDown) {
        moveCursor(obj);
        if (isSection(currentSelectedObj)) {
            if (obj != currentHighlightedObj && isSection(obj)) {
                if (currentHighlightedObj) handleDragOut(currentHighlightedObj);
                currentHighlightedObj = obj;
                var separator = document.getElementById(getSeparatorId(obj.tableId));
                if (separator) {
                    separator.originalBGColor = separator.style.backgroundColor;
                    separator.style.backgroundColor = '#000000';
                }
            }
        } else {
            if (obj != currentHighlightedObj) {
                if (currentHighlightedObj) handleDragOut(currentHighlightedObj);
                currentHighlightedObj = obj;
                if (isInAvailableSection(obj)) {
                    if (!isInAvailableSection(currentSelectedObj)) {
                        var t = getTable(getTableId(obj));
                        t.style.backgroundColor = '#000000';
                    }
                } else {
                    log(obj.id);
                    var separator = document.getElementById(getSeparatorId(obj.id));
                    if (separator) {
                        separator.originalBGColor = separator.style.backgroundColor;
                        separator.style.backgroundColor = '#000000';
                    }
                }
            }
        }
    }
}
function handleDragOut(obj) {
    if (currentSelectedObj) {
        if (isInAvailableSection(obj)) {
            var t = getTable(getTableId(obj));
            t.style.backgroundColor = '#FFFFFF';
        } else {
            var separatorId = isSection(obj) ? obj.tableId : obj.id;
            separatorId = getSeparatorId(separatorId)
            var separator = document.getElementById(separatorId);
            if (separator) {
                separator.style.backgroundColor = separator.originalBGColor;
            }
        }
    }
}
function pointerCursor(obj) {
    if (!obj || !obj.style) return;
    if (obj.used) {
        if (isIE && !isIE5 && !isIE55) {
            obj.style.cursor = 'not-allowed';
        } else {
            obj.style.cursor = 'default';
        }
    } else if (isSelected(obj)) {
        moveCursor(obj);
    } else {
        if (!isIE5 && !isIE55) {
            obj.style.cursor = 'pointer';
        } else {
            obj.style.cursor = 'default';
        }
    }
}

function moveCursor(obj) {
    if (obj && obj.style && !isIE55 && !isIE5) {
        obj.style.cursor = 'move';
    }
}

function defaultCursor(obj) {
    if (obj && obj.style) {
        obj.style.cursor = 'default';
    }
}

function showProperties(evt) {
    obj = getSrcElement(evt);
    if (obj.innerHTML == '') return;

    if (obj.tableId == "table0") {
        defaultCursor(obj);
        return;
    }
    pointerCursor(obj);

    var propHeader;
    var propValues;
    if (isSection(obj)) {
        obj.onmouseout = handleMouseOut;
        var t = document.getElementById(getTableIdFromSectionId(obj.id));
        propHeader = obj.innerHTML;
        if (t) {
            propValues = new Array(
                    'To move this section, click here and drag it to the desired new location.',
                    'Columns:&nbsp;&nbsp;' + t.rows[0].cells.length,
                    'Order:&nbsp;&nbsp;' + (obj.sortOrder == 'h' ? 'Left-Right' : 'Top-Down')
                    );
        }
        if (obj.detailHeading == '1' && obj.editHeading == '1') {
            propValues = propValues.concat('Section Header:&nbsp;&nbsp;' + 'Displayed');
        } else if (obj.detailHeading == '1') {
            propValues = propValues.concat('Section Header:&nbsp;&nbsp;' + 'Detail page only');
        } else if (obj.editHeading == '1') {
            propValues = propValues.concat('Section Header:&nbsp;&nbsp;' + 'Edit page only');
        }
    } else {
        var isRQ = obj.rq && obj.rq == '1';
        var isRO = obj.ro && obj.ro == '1';
        var isNotCustom = obj.custom && obj.custom == '0';
        propHeader = obj.fName;
        propValues = new Array();

        if (obj.used) {
            //propValues = propValues.concat('&lt;span style=color:990000&gt;This field is already used in the page layout&lt;/span&gt;');
            //showMouseOver(evt, propHeader, propValues, 0);
            return;
        }

        if (obj.fDataLabel.indexOf("&") > 0) {
            var tempfDataLabel = obj.fDataLabel.split("&");
            propValues = propValues.concat('Name:&nbsp;&nbsp;' + tempfDataLabel[0]);
            propValues = propValues.concat('Revenue:&nbsp;&nbsp;' + tempfDataLabel[1]);
            propValues = propValues.concat('Status:&nbsp;&nbsp;' + tempfDataLabel[2]);
            propValues = propValues.concat('Tiers:&nbsp;&nbsp;' + tempfDataLabel[3]);
            propValues = propValues.concat('Throttle:&nbsp;&nbsp;' + tempfDataLabel[4]);
            propValues = propValues.concat('MaxDaily:&nbsp;&nbsp;' + tempfDataLabel[5]);
        } else if (obj.fDataLabel.indexOf("@") > 0) {
            var tempfDataLabel = obj.fDataLabel.split("@");
            propValues = propValues.concat('Name:&nbsp;&nbsp;' + tempfDataLabel[0]);
            propValues = propValues.concat('Revenue:&nbsp;&nbsp;' + tempfDataLabel[1]);
            propValues = propValues.concat('Status:&nbsp;&nbsp;' + tempfDataLabel[2]);

        }
    }
    showMouseOver(evt, propHeader, propValues, 1000);
}

function handleMouseOut(evt) {
    hideMouseOver(0);
}
function handleLinkMouseOver(evt) {
    evt = getEvent(evt);
    obj = getSrcElement(evt);
    pointerCursor(obj);
    doNothing(evt);
}

function clearTextSelection() {
    if (isIE) {
        document.selection.empty();
    } else {
        if (window.getSelection().removeAllRanges) {
            window.getSelection().removeAllRanges();
        }
    }
}




function setRelatedListColumns(field, customized) {
    if (field.columnsSet == '1') return;
    field.hasChildren = true;
    field.columns = new Array();
    for (var i = 2; i < arguments.length; i += 3) {
        var column = new Object();
        column.alias = arguments[i];
        column.label = arguments[i + 1];
        column.sorting = arguments[i + 2];
        field.columns.push(column);
    }
    field.defaultColumns = field.columns;
    field.columnsSet = '1';
}
function setLayoutIds(field, layouts) {
    field.layouts = layouts;
}
function setRelatedListDefaultColumns(field, customized) {
    if (field.defColumnsSet == '1') return;
    field.hasChildren = true;
    field.defaultColumns = new Array();
    for (var i = 2; i < arguments.length; i += 2) {
        var column = new Object();
        column.alias = arguments[i];
        column.label = arguments[i + 1];
        column.sorting = 0;
        field.defaultColumns.push(column);
    }
    if (!field.columns) field.columns = field.defaultColumns;
    field.defColumnsSet = '1';
}
var initUsedFields = new Array();
function setFieldAttributes(field, itemId, d, f, l, p, s, typeLabel, itemType, rq, ro, ad, arq, aro, anrq, anro, cust) {
    if (field.initialized == '1') return;
    field.itemId = itemId;
    field.dName = d;
    field.fName = f;
    if (l != '0') field.fLength = l;
    if (s != '0' && p != '0') {
        field.fPrecision = p;
        field.fScale = s;
    }
    field.fDataLabel = typeLabel;
    setCellRequiredNess(field, rq);
    setCellReadonlyNess(field, ro);

    field.custom = cust;
    field.ad = ad;
    if (ad == '1') {
        field.style.fontWeight = 'bold';
    }
    field.arq = arq;
    // always required
    field.aro = aro;
    // always readonly
    field.anrq = anrq;
    // always not required
    field.anro = anro;
    // always not readonly
    field.fieldType = itemType;


    field.onmousedown = handleMouseDown;
    field.onclick = handleMouseClick;

    if (initUsedFields[itemId]) {
        field.originalBGColor = '#CCCCAA';
        setCellToUsed(field);
        document.getElementById(initUsedFields[itemId]).originalId = field.id;
    } else {
        field.style.backgroundColor = '#CCCCAA';
        initUsedFields[itemId] = field.id;
    }
    field.initialized = '1';
    formatField(field);

}

function setCellRequiredNess(f, required) {
    f.rq = required ? '1' : '0';
}
function setCellReadonlyNess(f, readonly) {
    f.ro = readonly ? '1' : '0';
}
function setCellInlinedNess(f, inlined) {
    f.il = inlined ? '1' : '0';
}
function setCellCustomNess(f, custom) {
    f.custom = custom ? '1' : '0';
}

function setListSelectedColumns(selectedList, selectedColumns, sortAlias, sortAscending) {
    var columns = new Array();
    var options = selectedColumns.options;
    for (var i = 0; i < options.length; i++) {
        var column = new Object();
        column.label = options[i].text;
        column.alias = options[i].value;

        if (sortAlias == column.alias) {
            column.sorting = sortAscending ? 1 : -1;
        } else {
            column.sorting = 0;
        }
        columns.push(column);
    }
    // Compare the list to the default.
    var isSame = false;
    selectedList.columns = columns;
    if (selectedList.columns.length == selectedList.defaultColumns.length) {
        isSame = true;
        for (var i = 0; i < selectedList.columns.length; i++) {
            var left = selectedList.columns[i];
            var right = selectedList.defaultColumns[i];
            if (left.alias != right.alias || left.sorting != right.sorting) {
                isSame = false;
                break;
            }
        }
    }
    if (isSame) selectedList.columns = selectedList.defaultColumns;
    selectedList.hasChildren = true;
    formatField(selectedList);
}


function formatField(field) {
    var name = field.dName;
    if (!name) name = field.fName;
    if (!name) return;
    var innerHTML;
    if (field.ro == '1') {//images/readonly.gif
        innerHTML = '<img src="./layout/readonly.gif" alt="Read-Only" title="Read-Only" width=16 height=16 onclick="doNothing(event);" onmousedown="doNothing(event);" align="top" onfocus="doNothing(event);" onmouseover="doNothing(event);">';
    } else if (field.rq == '1') {//images/required.gif
        innerHTML = '<img src="./layout/required.gif" alt="Required" title="Required" width=16 height=16 onclick="doNothing(event);" onmousedown="doNothing(event);" align="top" onfocus="doNothing(event);" onmouseover="doNothing(event);">';
    } else if (field.il == '1') {//images/s.gif
        innerHTML = '<img src="./layout/s.gif" alt="" title="" width=16 height=16 onclick="doNothing(event);" onmousedown="doNothing(event);" align="top" onfocus="doNothing(event);" onmouseover="doNothing(event);">';
    } else {//images/s.gif
        innerHTML = '<img src="./layout/s.gif" alt="" title="" width=16 height=16 onclick="doNothing(event);" onmousedown="doNothing(event);" align="top" onfocus="doNothing(event);" onmouseover="doNothing(event);">';
    }

    field.innerHTML = innerHTML + '&nbsp;' + field.dName;

}

function setCellToEmpty(c) {
    c.itemId = '';
    c.innerHTML = '';
    c.originalId = '';
    c.onmousedown = '';
    c.onmouseout = '';
    c.onclick = '';
    if (isIE5) c.onclick = handleMouseClick;
    c.used = false;
    c.ro = '0';
    c.rq = '0';
    c.ad = '0';
    c.arq = '0';
    c.aro = '0';
    c.anrq = '0';
    c.anro = '0';
    c.fieldType = '';
    c.custom = '0';
}
function setCellToUsed(c) {
    c.style.backgroundColor = '#EEEEEE';
    c.style.color = '#B0B0B0';
    c.onmousedown = '';
    c.used = true;
}
function copyCell(to, from) {
    if (from.innerHTML == '') {
        setCellToEmpty(to);
        return;
    }
    to.innerHTML = from.innerHTML;
    to.originalId = from.originalId ? from.originalId : from.id;
    to.onmousedown = handleMouseDown;

    to.onmouseout = handleMouseOut;
    //onBlur breaks the ctrl+click functionality
    //to.onblur = handleMouseOut;
    //to.onfocus = handleMouseOver;
    to.onclick = handleMouseClick;

    to.onmouseover = handleMouseOver;
    to.used = false;
    to.dName = from.dName;
    to.fName = from.fName;
    to.fDataLabel = from.fDataLabel;
    to.itemId = from.itemId;
    to.fieldType = from.fieldType;
    if (from.fLength) to.fLength = from.fLength;
    if (from.fPrecision) to.fPrecision = from.fPrecision;
    if (from.fScale) to.fScale = from.fScale;
    if (from.ro) to.ro = from.ro;
    if (from.rq) to.rq = from.rq;
    if (from.ad) to.ad = from.ad;
    if (from.il) to.il = from.il;
    if (from.arq) to.arq = from.arq;
    if (from.aro) to.aro = from.aro;
    if (from.anrq) to.anrq = from.anrq;
    if (from.anro) to.anro = from.anro;
    to.custom = from.custom;
    to.columns = from.columns;
    to.defaultColumns = from.defaultColumns;
    to.hasChildren = from.hasChildren;
}
function insertCell(evt) {
    var tablesToReformat = new Array();
    if (isInAvailableSection(currentHighlightedObj)) {
        for (var i = 0; i < selectedBucket.length; i++) {
            var originalCell = document.getElementById(selectedBucket[i].originalId);

            if (selectedBucket[i].ad == '0') {
                copyCell(originalCell, selectedBucket[i]);
                originalCell.style.backgroundColor = '#CCCCAA';
                originalCell.style.color = '#000000';
                originalCell.innerHTML = originalCell.dName;
                setCellRequiredNess(originalCell, false);
                setCellReadonlyNess(originalCell, false);
                formatField(originalCell);

                // Refresh the available sections
                if ((i + 1) == selectedBucket.length) {
                    var divId = getDivIdFromTableId(getTableId(originalCell));
                    var availableDropDown = document.getElementById('availableDropDown');
                    if (availableDropDown) {
                        // Refresh the dropdown
                        function getDivPrefixFromDivId(dId) {
                            var lastSeparatorIndex = dId.lastIndexOf('_');
                            if (lastSeparatorIndex > -1) {
                                return dId.substring(0, lastSeparatorIndex);
                            }
                            return dId;
                        }
                        var divPrefix = getDivPrefixFromDivId(divId);
                        var options = availableDropDown.options;
                        for (var selIndex = 0; selIndex < options.length; selIndex++) {
                            if (getDivPrefixFromDivId(options[selIndex].value) == divPrefix) {
                                availableDropDown.selectedIndex = selIndex;
                            }
                        }
                    }
                    // refresh the section
                    if (document.getElementById(divId)) swapDivs(divId, divId);
                }
            }
            if (!isInAvailableSection(selectedBucket[i])) {
                var tableToReformatId = getTableId(selectedBucket[i]);
                tablesToReformat[tableToReformatId] = tableToReformatId;
            }
        }
        var numAlwaysDisplayedField = 0;
        for (var i = 0; i < selectedBucket.length; i++) {
            if (selectedBucket[i].ad && selectedBucket[i].ad == '1') {
                numAlwaysDisplayedField++;
                continue;
            }
            setCellToEmpty(selectedBucket[i]);
        }
        if (numAlwaysDisplayedField == 1) {
            alert('This field may not be removed from the page layout.');
        } else if (numAlwaysDisplayedField > 1) {
            alert('One or more of the selected fields were not removed because they must be included in the page layout.');
        }
    } else {
        var tableId = getTableId(currentHighlightedObj);
        var rowNum = getRowNum(currentHighlightedObj) - 1;
        var colNum = getColNum(currentHighlightedObj) - 1;
        var t = getTable(tableId);

        if (!t) return;
        var selectedData = new Array();

        var isGoingToStandardSection = isInStandardSection(currentHighlightedObj);
        var isGoingToListsSection = isInListsSection(currentHighlightedObj);
        var isGoingToLinksSection = isInLinksSection(currentHighlightedObj);
        var foundRestrictedStandardField = 0;
        var foundRestrictedListField = 0;
        var foundRestrictedLinkField = 0;
        for (var j = 0; j < selectedBucket.length; j++) {
            if (selectedBucket[j].fieldType == 'F' || selectedBucket[j].fieldType == 'C') {
                if (!isGoingToStandardSection) {
                    foundRestrictedStandardField++;
                    selectedBucket[j].style.backgroundColor = selectedBucket[j].originalBGColor;
                    continue;
                }
            } else if (selectedBucket[j].fieldType == 'K') {
                if (!isGoingToLinksSection) {
                    foundRestrictedLinkField++;
                    selectedBucket[j].style.backgroundColor = selectedBucket[j].originalBGColor;
                    continue;
                }
            } else {
                if (!isGoingToListsSection) {
                    foundRestrictedListField++;
                    selectedBucket[j].style.backgroundColor = selectedBucket[j].originalBGColor;
                    continue;
                }
            }

            var selData = new Object();
            copyCell(selData, selectedBucket[j]);
            selectedData = selectedData.concat(selData);
            if (!isInAvailableSection(selectedBucket[j])) {
                var tableToReformatId = getTableId(selectedBucket[j]);
                tablesToReformat[tableToReformatId] = tableToReformatId;
                setCellToEmpty(selectedBucket[j]);
            } else {
                setCellToUsed(selectedBucket[j]);
            }

        }

        for (var j = 0; j < selectedData.length; j++) {
            var previousCell = new Object();
            copyCell(previousCell, selectedData[j]);

            // Anywhere you insert a cell, start from there, and shift everything down.
            for (var i = rowNum * 2; i < t.rows.length; i++) {
                var row = t.rows[i];
                if (!row || i % 2 == 0) continue;
                var cell = row.cells[colNum];

                var tempCell = new Object();
                copyCell(tempCell, cell);
                copyCell(cell, previousCell);
                previousCell = tempCell;
            }
            rowNum++;
            addRow(tableId);
        }

        if (foundRestrictedListField > 0) {
            alert('Related lists must be placed in the related lists section.');
        }
        if (foundRestrictedLinkField > 0) {
            alert(
                    'Custom links must be placed in the "'
                            + getLinksSectionName('Custom Links')
                            + '" section.'
                    );
        }
        if (foundRestrictedStandardField > 0) {
            alert('Fields must be placed in the field sections.');
        }

    }
    for (var tId in tablesToReformat) {
        reformatTable(document.getElementById(tId));
    }
    if (!isInAvailableSection(currentHighlightedObj)) {
        reformatTable(document.getElementById(getTableId(currentHighlightedObj)));
    }
    selectedBucket = new Array();
}

function getLinksSectionName(defaultName) {
    for (var i = 0; i <= maxSection; i++) {
        var section = document.getElementById('sec_' + 'k' + i);
        if (section && section.masterLabel && section.masterLabel.replace(/\s/g, '').length != 0) {
            return escapeJS(section.masterLabel, true, false);
        }
    }
    return defaultName;
}




var maxSection = 0;
var maxSectionTable = 0;
function swapSections(evt) {
    if (currentSelectedObj == currentHighlightedObj) return;

    currentSelectedObj.style.backgroundColor = currentSelectedObj.originalBGColor;
    handleDragOut(currentSelectedObj);
    handleDragOut(currentHighlightedObj);


    var currentTableId = currentSelectedObj.tableId;
    var highlightedTableId = currentHighlightedObj.tableId;
    var currentTable = document.getElementById(currentTableId);
    var currentDetailHeading = currentSelectedObj.detailHeading;
    var currentEditHeading = currentSelectedObj.editHeading;
    var currentCanEditLabel = currentSelectedObj.canEditLabel;
    var currentMasterLabel = currentSelectedObj.masterLabel;
    var currentSortOrder = currentSelectedObj.sortOrder;
    var currentItemId = currentSelectedObj.itemId;

    var currentBody = currentTable.cloneNode(true);

    deleteSectionRow(currentTableId);
    insertSectionRow(highlightedTableId, currentTableId, currentBody);
    // need this here for NS
    document.getElementById(currentSelectedObj.id).tableId = currentTableId;

    initSectionTable(document.getElementById(currentSelectedObj.id), currentTableId, currentSortOrder, currentDetailHeading, currentEditHeading, currentCanEditLabel, currentMasterLabel, currentItemId);
    initSection(document.getElementById(getTableIdFromSectionId(currentSelectedObj.id)));

    if (!isIE) copyCells(currentTable.rows[1].cells[0].childNodes[0], currentBody.rows[1].cells[0].childNodes[0]);
    if (!isIE) reformatTable(document.getElementById(getTableIdFromSectionId(currentSelectedObj.id)));

    clearTextSelection();
}


function copyCells(fromT, toT) {
    cellBuffer = new Array();
    for (var i = 0; i < fromT.rows.length; i++) {
        if (i % 2 == 0) continue;
        var fromR = fromT.rows[i];
        var toR = toT.rows[i];
        for (var j = 0; j < fromR.cells.length; j++) {
            var fromC = fromR.cells[j];
            var toC = toR.cells[j];
            copyCell(toC, fromC);
        }
    }
}

function initSectionTable(sectionTable, tableId, sortOrder, detailHeading, editHeading, canEditLabel, masterLabel, itemId) {
    sectionTable.onmouseover = handleMouseOver;
    sectionTable.onmouseout = handleMouseOut;
    sectionTable.onmousedown = handleMouseDown;
    sectionTable.onclick = handleMouseClick;
    sectionTable.tableId = tableId;
    sectionTable.sortOrder = sortOrder;
    sectionTable.detailHeading = detailHeading;
    sectionTable.editHeading = editHeading;
    sectionTable.canEditLabel = canEditLabel;
    sectionTable.masterLabel = masterLabel;
    sectionTable.itemId = itemId;
}

function initSection(t) {
    for (var i = 0; i < t.rows.length; i++) {
        var row = t.rows[i];
        if (!row || i % 2 == 0) continue;
        for (var j = 0; j < row.cells.length; j++) {
            var cell = row.cells[j];
            if (cell.innerHTML != '') {
                cell.onmousedown = handleMouseDown;
                cell.onclick = handleMouseClick;
                cell.onmouseover = handleMouseOver;
                cell.onmouseout = handleMouseOut;
                cell.used = false;
            } else {
                cell.onmousedown = '';
                cell.onclick = handleMouseClick;
                cell.onmouseover = handleMouseOver;
                cell.onmouseout = handleMouseOut;
                cell.used = false;
            }
        }

    }
}
function deleteSection(sectionId) {
    var t = getTable(getTableIdFromSectionId(sectionId));
    if (t.rows.length > 2) {
        if (!window.confirm('Deleting this section will cause all its fields to be put back into Available Fields.' + '\n\n' + 'Are you sure?')) {
            return;
        }

    }
    var hasAlwaysDisplayedField = false;
    for (var i = 0; i < t.rows.length - 2 && !hasAlwaysDisplayedField; i++) {
        if (i % 2 == 0) continue;
        var row = t.rows[i];
        for (var j = 0; j < row.cells.length && !hasAlwaysDisplayedField; j++) {
            var cell = row.cells[j];
            if (cell.ad && cell.ad == '1') {
                hasAlwaysDisplayedField = true;
            }
        }
    }
    if (hasAlwaysDisplayedField) {
        alert('Cannot delete this section because at least one field cannot be removed from the page layout.');
        return;
    }

    var sectionHeader = document.getElementById(getSectionHeaderId(t.id));
    if (sectionHeader.canEditLabel == '0') {
        var okayToDelete = confirm(
                'This section is supplied by system. The section name is translated for international users.'
                        + '\n'
                        + 'If you delete this section, you cannot add it back.'
                        + '\n\n'
                        + 'Instead of deleting this section, we recommend that you remove all the fields from it.'
                        + '\n'
                        + 'This way, the section will not appear on the page, but you will still be able to use it in the future.'
                        + '\n\n'
                        + 'Are you sure?');
        if (!okayToDelete) return;
    }

    for (var i = 0; i < t.rows.length - 2; i++) {
        if (i % 2 == 0) continue;
        var row = t.rows[i];
        for (var j = 0; j < row.cells.length; j++) {
            var cell = row.cells[j];
            if (cell.originalId) {
                var originalCell = document.getElementById(cell.originalId);
                if (originalCell) {
                    copyCell(originalCell, cell);
                    originalCell.style.backgroundColor = originalCell.originalBGColor;
                    setCellRequiredNess(originalCell, false);
                    setCellReadonlyNess(originalCell, false);
                    formatField(originalCell);
                }
            }

        }

    }
    deleteSectionRow(document.getElementById(sectionId).tableId);
}
function deleteSectionRow(tableId) {
    var mainTable = document.getElementById('mainLayoutTable');
    var rpId = getSeparatorId(tableId);
    var rowNum = -1;
    for (var i = 0; rowNum < 0 && i < mainTable.rows.length; i++) {
        var row = mainTable.rows[i];
        for (var j = 0; j < row.cells.length; j++) {
            var cell = row.cells[j];
            if (cell.id == rpId) {
                rowNum = i;
            }
        }
    }
    mainTable.deleteRow(rowNum);
    mainTable.deleteRow(rowNum);
    mainTable.deleteRow(rowNum);
}

function insertSection(sectionText, c, sortOrder, detailHeading, editHeading) {
    if (sectionText == '') {
        alert('Must enter a section name!');
        return;
    }
    var numColumns = parseInt(c);
    maxSectionTable++;
    maxSection++;
    var sectionName = "s" + maxSection;
    var tableName = "table" + maxSectionTable;
    var newSection = '';
    newSection += '<table cellspacing=1 cellpadding=2 style="background-color:#000000" class="bAccount account" width="400" id="' + tableName + '">';
    newSection += '<tr class="secondaryPalette"><td class="sectionHeader headerRow">';
    newSection += '<table border="0" cellspacing="0" cellpadding="0" width="100%">';
    newSection += '<tr valign=bottom ><td class="sectionHeader headerRow" id="' + getSectionHeaderId(sectionName) + '"  align="left" width="99%">' + sectionText + '</td>';
    newSection += '<td align="right" nowrap class="sectionHeader headerRow" style="font-size: 80%">';
    newSection += '<a onmouseover="handleLinkMouseOver(event);" onmousedown="doNothing(event);" onclick="openSectionEdit(\'' + getSectionHeaderId(sectionName) + '\', event);">';
    newSection += 'Edit';
    newSection += '</a>';
    newSection += ' | ';
    newSection += '<a onmouseover="handleLinkMouseOver(event);" onmousedown="doNothing(event);" onclick="deleteSection(\'' + getSectionHeaderId(sectionName) + '\');">';
    newSection += 'Delete';
    newSection += ' </a>';
    newSection += ' </td></tr>';
    newSection += '</table></td>';
    newSection += '</tr>';
    newSection += '<tr style="background-color:#FFFFFF" height=15>';
    newSection += '<td>';
    newSection += '<table id="' + sectionName + '" width="100%" cellspacing=2 bgcolor="#FFFFFF">';
    newSection += '<tr height=2>';
    for (var i = 0; i < numColumns; i++) {
        newSection += '<td id="' + getSeparatorId(constructId(sectionName, 1, i + 1)) + '" width="200"></td>';
    }
    newSection += '</tr>';
    newSection += '<tr height="10">';
    for (var i = 0; i < numColumns; i++) {
        newSection += '<td id="' + constructId(sectionName, 1, i + 1) + '"></td>';
    }
    newSection += '</tr>';
    newSection += '</table>';
    newSection += '</td>';
    newSection += '</tr>';
    newSection += '</table>';

    insertSectionRow('table0', tableName, newSection);
    initSectionTable(document.getElementById(getSectionHeaderId(sectionName)), tableName, sortOrder, detailHeading, editHeading, '1', sectionText, '');
    initSection(document.getElementById(sectionName));
    // NN does not suppport focus on just any elements
    if (isIE) document.getElementById(sectionName).focus();
}

function insertSectionRow(tableId, newTableId, newSection) {
    var mainTable = document.getElementById('mainLayoutTable');
    var rpId = getSeparatorId(tableId);
    var rowNum = -1;
    for (var i = 0; rowNum < 0 && i < mainTable.rows.length; i++) {
        var row = mainTable.rows[i];
        for (var j = 0; j < row.cells.length; j++) {
            var cell = row.cells[j];
            if (cell.id == rpId) {
                rowNum = i;
            }
        }
    }
    if (rowNum < 0) {
        rowNum = mainTable.rows.length - 2;
    }
    var newRow = mainTable.insertRow(rowNum);
    var newCell = newRow.insertCell(0);
    newCell.height = 5;
    newCell.id = getSeparatorId(newTableId);

    newRow = mainTable.insertRow(rowNum + 1);
    newCell = newRow.insertCell(0);
    if (!newSection.nodeType) {
        newCell.innerHTML = newSection;
    } else {
        newCell.insertBefore(newSection, null);
    }
    newRow = mainTable.insertRow(rowNum + 2);
    newCell = newRow.insertCell(0);
    newCell.height = 10;
}

function openSectionEdit(sectionId, evt) {
    evt = getEvent(evt);
    setLastMousePosition(evt);
    var url = 'SectionEdit.aspx' + '?sectionId=' + sectionId;

    if (sectionId.length > 0 && !isIE) {

        var host = new String(window.location);
        host = host.substring(0, host.indexOf('/Layout.aspx'));
        url = host + '/SectionEdit.aspx' + '?sectionId=' + sectionId;
    }
    openPopup(url, 'sectionEdit', 450, 245, 'width=450,height=245,scrollbars=yes,toolbar=no,status=no,directories=no,menubar=no,resizable=yes', true);
}

function openFieldEdit(evt) {
    if (selectedBucket.length < 1) {
        alert('Please select at least one field from within the page layout sections.');
        return;
    }
    var hasAtLeastOneField = false;
    for (var i = 0; i < selectedBucket.length; i++) {
        f = selectedBucket[i];
        if (isInAvailableSection(f)) {
            alert('Functionality is for fields within the page layout sections only.');
            return;
        }
        if (isInStandardSection(f)) {
            hasAtLeastOneField = true;
        }
    }
    if (!hasAtLeastOneField) {
        alert('Functionality is only available for Fields.  Please select one or more Fields.');
        return;
    }
    evt = getEvent(evt);
    setLastMousePosition(evt);
    var h = (selectedBucket.length > 2) ? 400 : 200;
    openPopup('SectionFieldEdit.aspx', 'sectionEdit', 450, h, 'width=450,height=' + h + ',scrollbars=yes,toolbar=no,status=no,directories=no,menubar=no,resizable=yes', true);
}
function openRelatedListEdit(evt) {
    if (selectedBucket.length != 1) {
        alert('Please select one related list from related list section.');
        return;
    }
    f = selectedBucket[0];
    if (isInAvailableSection(f)) {
        alert('Functionality is for related lists within the page layout sections only.');
        return;
    }
    if (!isInListsSection(f)) {
        alert('Functionality is only available for Related Lists.  Please select one or more Related Lists.');
        return;
    }
    if (!f.custom || f.custom == '0') {
        alert('The selected related list cannot be edited.');
        return;
    }
    evt = getEvent(evt);
    setLastMousePosition(evt);
    var url = 'rellistedit.aspx';
    url += '?ListId=' + f.itemId;

    var h = 540;
    var w = 690;
    var features = 'width=' + w + ',height=' + h + ',scrollbars=yes,toolbar=no,status=no,directories=no,menubar=no,resizable=yes';
    if (window.showModalDialog) {
        h += 20;
        openPopup(url, 'sectionEdit', w, h, features, true);
    } else {
        openPopupModal(url, 'sectionEdit', w, h, features, window);
    }
}



function isSection(obj) {
    return obj.id.indexOf('sec_') > -1;
}
function getTableIdFromSectionId(sectionId) {
    return sectionId.substring(sectionId.indexOf('sec_') + 4, sectionId.length);
}
function getSectionIndex(tableId) {
    return tableId.substring(tableId.indexOf('table') + 5, tableId.length);
}
function getTable(tableName) {
    return document.getElementById(tableName);
}
function getTableBody(tableName) {
    return document.getElementById(tableName).tBodies[0];
}
function isInAvailableSection(obj) {
    return getTableId(obj).indexOf('a') > -1;
}
function isStandardSection(sectionHeaderId) {
    var sectionId = getTableIdFromSectionId(sectionHeaderId);
    return sectionId.indexOf('s') == 0;
}
function isInStandardSection(obj) {
    return getTableId(obj).indexOf('s') > -1;
}
function isInListsSection(obj) {
    return getTableId(obj).indexOf('l') > -1;
}
function isInLinksSection(obj) {
    return getTableId(obj).indexOf('k') > -1;
}
function getTableId(obj) {
    return obj.id.substring(0, obj.id.indexOf('r'));
}
function getDivIdFromTableId(tableId) {
    return 'div_' + tableId;
}
function getRowNum(obj) {
    return parseInt(obj.id.substring(obj.id.indexOf('r') + 1, obj.id.indexOf('c')));
}
function getColNum(obj) {
    return parseInt(obj.id.substring(obj.id.indexOf('c') + 1, obj.id.length));
}
function constructId(tableId, rowNum, colNum) {
    return tableId + 'r' + rowNum + 'c' + colNum;
}
function getSeparatorId(baseId) {
    return 'rp_' + baseId;
}
function getSectionHeaderId(baseId) {
    return 'sec_' + baseId;
}

function addRow(tableName) {
    var columns = getTable(tableName).rows[0].cells.length;
    addRowWithColumn(tableName, columns);
}

function addRowWithColumn(tableName, columns) {
    var tr;
    var td;
    var columnWidth = 400 / columns;
    var tableBody = getTableBody(tableName);
    var length = tableBody.rows.length;
    var rowNum = (length / 2) + 1;
    tr = tableBody.insertRow(tableBody.rows.length);
    tr.setAttribute("height", "2");

    for (var i = 0; i < columns; i++) {
        td = tr.insertCell(tr.cells.length);
        td.setAttribute("id", getSeparatorId(constructId(tableName, rowNum, i + 1)));
        td.setAttribute("width", columnWidth);
    }

    tr = tableBody.insertRow(tableBody.rows.length);
    tr.setAttribute("height", "10");

    for (var i = 0; i < columns; i++) {
        td = tr.insertCell(tr.cells.length);
        td.setAttribute("id", constructId(tableName, rowNum, i + 1));
        td.onmouseover = handleMouseOver;
        td.onclick = handleMouseClick;
    }

}
function delRow(tableName) {
    var tableBody = getTableBody(tableName);
    if (tableBody.childNodes.length > 0) {
        var lastRow = tableBody.childNodes[tableBody.childNodes.length - 1];
        getTableBody(tableName).removeChild(lastRow);
    }
}

// deprecated
function sectionHandleMouseOver(evt) {
    function getIECurrentTarget(evt, functionName) {
        var eventHandler = eval('evt.srcElement.on' + evt.type);
        if (eventHandler && eventHandler.toString().indexOf(functionName) > -1) {
            return evt.srcElement;
        }
        return null;
    }
    evt = getEvent(evt);
    obj = isIE ? getIECurrentTarget(evt, 'sectionHandleMouseOver') : getSrcElement(evt);
}
function reformatTable(t) {
    var isInListsSection = t.id && t.id.indexOf('l') > -1;
    for (var i = 0; i < t.rows.length; i++) {
        var row = t.rows[i];
        if (!row || i % 2 == 0) continue;
        for (var j = 0; j < row.cells.length; j++) {
            var cell = row.cells[j];
            if (cell.innerHTML != '' && i > 2) {
                var previousRow = t.rows[i - 2];
                var previousCell = previousRow.cells[j];
                var done = false;
                var k = 1;
                while (!done && previousCell.innerHTML == '') {
                    copyCell(previousCell, cell);
                    setCellToEmpty(cell);
                    cell = previousCell;
                    k++;
                    if (i > (2 * k)) {
                        previousCell = t.rows[i - (2 * k)].cells[j];
                    } else {
                        done = true;
                    }

                }
            }
        }

    }
    var foundOneEmptyRow = false;
    for (var i = 0; i < t.rows.length; i++) {
        var row = t.rows[i];
        if (!row || i % 2 == 0) continue;
        var allCellsEmpty = true;
        for (var j = 0; j < row.cells.length; j++) {
            var cell = row.cells[j];

            if (cell.innerHTML != '') {
                allCellsEmpty = false;
                cell.style.backgroundColor = '#CCCCCC';
                cell.style.color = '#000000';
                if (cell.ad == '1') {
                    cell.style.fontWeight = 'bold';
                } else {
                    cell.style.fontWeight = 'normal';
                }
                if (cell.arq == '1') {
                    cell.rq = true;
                }
                if (cell.aro == '1') {
                    cell.ro = true;
                }
                if (cell.anrq == '1') {
                    cell.rq = false;
                }
                if (cell.anro == '1') {
                    cell.ro = false;
                }
                formatField(cell);
            } else {
                setCellToEmpty(cell);
                cell.style.backgroundColor = '#FFFFFF';
                cell.style.cursor = 'default';
            }
            if (cell.fieldType == 'K' && isInListsSection) {
                setCellInlinedNess(cell, true);
                formatField(cell);
            }

        }
        if (allCellsEmpty) {
            if (foundOneEmptyRow) {
                t.deleteRow(i - 1);
                t.deleteRow(i - 1);
                i = i - 2;
            } else {
                foundOneEmptyRow = true;
                row.cells[0].firstemptyrow = '1';
            }
        }
    }
    if (!foundOneEmptyRow) addRow(t.id);
}
function toggleColumns(sectionId) {
    var t = document.getElementById(getTableIdFromSectionId(sectionId));
    if (t.rows[0].cells.length > 1) {
        makeSingleColumn(t);
    } else {
        makeDoubleColumn(t);
    }
    reformatTable(t);
}
function cloneTableCells(t, sortOrder) {
    var originalTable = t.cloneNode(true);
    if (originalTable.rows.length == 0) return new Array();

    var cells = new Array(originalTable.rows.length * originalTable.rows[0].cells.length);
    var currentCellIndex = 0;
    if (sortOrder && sortOrder == 'h') {
        for (var i = 0; i < originalTable.rows.length; i++) {
            var row = originalTable.rows[i];
            var oRow = t.rows[i];
            for (var j = 0; j < row.cells.length; j++) {
                var cell = row.cells[j];
                var oCell = oRow.cells[j];
                copyCell(cell, oCell);
                cells[currentCellIndex++] = cell;
            }

        }
    } else {
        for (var i = 0; i < originalTable.rows.length; i++) {
            var row = originalTable.rows[i];
            var oRow = t.rows[i];
            for (var j = 0; j < row.cells.length; j++) {
                currentCellIndex = (j * originalTable.rows.length) + i;
                var cell = row.cells[j];
                var oCell = oRow.cells[j];
                copyCell(cell, oCell);
                cells[currentCellIndex] = cell;
            }

        }
    }
    return cells;

}
function makeSingleColumn(t) {
    var cells = cloneTableCells(t, document.getElementById(getSectionHeaderId(t.id)).sortOrder);

    while (t.rows.length > 0) {
        t.deleteRow(0);
    }
    var row;
    var cell;
    var rowNum = 1;

    for (var i = 0; i < cells.length; i++) {
        if (cells[i].innerHTML == '') continue;
        row = t.insertRow(t.rows.length);
        row.height = 2;
        cell = row.insertCell(0);
        cell.id = getSeparatorId(constructId(t.id, rowNum, 1));

        row = t.insertRow(t.rows.length);
        row.height = 10;
        cell = row.insertCell(0);
        copyCell(cell, cells[i]);
        cell.style.backgroundColor = cells[i].style.backgroundColor;
        cell.id = constructId(t.id, rowNum, 1);

        rowNum++;
    }
    if (t.rows.length == 0) {
        addRowWithColumn(t.id, 1);
    } else {
        addRow(t.id);
    }
}
function makeDoubleColumn(t) {
    var cells = cloneTableCells(t, document.getElementById(getSectionHeaderId(t.id)).sortOrder);

    while (t.rows.length > 0) {
        t.deleteRow(0);
    }
    var row1;
    var row2;
    var cell;
    var rowNum = 1;

    var isFirstCell = true;
    for (var i = 0; i < cells.length; i++) {
        if (cells[i].innerHTML == '') continue;

        if (isFirstCell) {
            row1 = t.insertRow(t.rows.length);
            row1.height = 2;
            cell = row1.insertCell(0);
            cell.width = 200;
            cell.id = getSeparatorId(constructId(t.id, rowNum, 1));
            cell = row1.insertCell(1);
            cell.width = 200;
            cell.id = getSeparatorId(constructId(t.id, rowNum, 2));
        }

        if (isFirstCell) {
            row2 = t.insertRow(t.rows.length);
            row2.height = 10;
            cell = row2.insertCell(0);
            copyCell(cell, cells[i]);
            cell.style.backgroundColor = cells[i].style.backgroundColor;
            cell.id = constructId(t.id, rowNum, 1);
            cell = row2.insertCell(1);
            cell.id = constructId(t.id, rowNum, 2);
        } else {
            cell = row2.cells[1];
            copyCell(cell, cells[i]);
            cell.style.backgroundColor = cells[i].style.backgroundColor;
        }
        if (isFirstCell) {
            rowNum++;
        }
        isFirstCell = !isFirstCell;
    }
    if (!isFirstCell) {
        cell = t.rows[t.rows.length - 1].cells[1];
        cell.onmousedown = handleMouseDown;
        cell.onmouseout = handleMouseOut;
        cell.onclick = handleMouseClick;
        cell.onmouseover = handleMouseOver;
        cell.used = false;
    }
    if (t.rows.length == 0) {
        addRowWithColumn(t.id, 2);
    } else {
        addRow(t.id);
    }
}

var currentDisplayedDiv = null;
function swapDivs(div1, div2) {
    if (currentDisplayedDiv) {
        currentDisplayedDiv.style.display = 'none';
    }
    if (div1 != div2) {
        var d1 = document.getElementById(div1);
        d1.style.display = 'none';
    }
    var d2 = document.getElementById(div2);
    d2.style.display = 'block';
    d2.style.zIndex = 0;
    currentDisplayedDiv = d2;
}
function swapAvailableType(sel) {
    if (currentDisplayedDiv) {
        currentDisplayedDiv.style.display = 'none';
    }
    var divId = sel.options[sel.selectedIndex].value;
    var firstDiv = document.getElementById(divId);
    if (firstDiv) {
        firstDiv.style.display = 'block';
        currentDisplayedDiv = firstDiv;
    }

}

var availableSectionInitPosX;
var availableSectionInitPosY;
var availableSectionPosInited = false;
var cru;
var initLeftHeight;
var initRightHeight

function scrollAvailableSection() {
    var doTableHeightScrolling = isIE || true;
    if (!cru) cru = (!doTableHeightScrolling) ? document.getElementById('availableSectionWrapper') : document.getElementById('scrollBuffer');
    if (!cru) return;

    if (!availableSectionPosInited) {
        availableSectionInitPosX = getObjX(cru);
        availableSectionInitPosY = getObjY(cru);
        initLeftHeight = document.getElementById('layoutdndLeft').scrollHeight;
        initRightHeight = document.getElementById('availableSectionWrapper').scrollHeight;
        availableSectionPosInited = true;
        cru.style.zIndex = 0;
        return
    }
    //don't scroll it till it goes offscreen
    if (availableSectionInitPosY + 5 < getScrollY()) {
        if (doTableHeightScrolling) {
            // don't scroll if it is at the bottom
            var newHeight = getScrollY() - availableSectionInitPosY + 5;
            if (initRightHeight + newHeight < initLeftHeight) {
                cru.height = (getScrollY()) - availableSectionInitPosY + 5;
            }
        } else {
            cru.style.position = 'absolute';
            cru.style.left = availableSectionInitPosX + "px";
            cru.style.top = ((getScrollY()) + 5) + "px";
            cru.style.zIndex = 0;
        }
    } else if (cru.style.position == 'absolute' || !isIE) {
        if (doTableHeightScrolling) {
            cru.height = 0;
        } else {
            cru.style.left = 0;
            //0 + "px";
            cru.style.top = 0;
            //0 + "px";
            cru.style.zIndex = 0;
            cru.style.position = 'static';
        }
    }
}

function doNothing(evt) {
    evt = getEvent(evt);
    evt.cancelBubble = true;
}

window.onscroll = scrollAvailableSection;
document.onscroll = scrollAvailableSection;
document.body.onscroll = scrollAvailableSection;
document.documentElement.onscroll = scrollAvailableSection;

window.onresizeend = scrollAvailableSection;
document.body.onresizeend = scrollAvailableSection;
document.body.onresizeend = scrollAvailableSection;
document.documentElement.onresizeend = scrollAvailableSection;

if (!isIE) setInterval("doScroll()", 200);
var lastPageYOffset = 0;
function doScroll() {
    if (getScrollY() != lastPageYOffset) {
        scrollAvailableSection();
        lastPageYOffset = getScrollY();
    }
}

function handleCheckBoxDependencies(checkBoxElement) {
    var autoAssign = document.getElementById('autoAssign');
    var autoAssignOn = document.getElementById('autoAssignOn');
    var autoNotify = document.getElementById('autoNotify');
    var autoNotifyOn = document.getElementById('autoNotifyOn');
    if (autoAssign == checkBoxElement) {
        if (!autoAssign.checked) {
            autoAssignOn.checked = false;
        }
    } else if (autoAssignOn == checkBoxElement) {
        if (autoAssignOn.checked) {
            autoAssign.checked = true;
        }
    } else if (autoNotify == checkBoxElement) {
        if (!autoNotify.checked) {
            autoNotifyOn.checked = false;
        }
    } else if (autoNotifyOn == checkBoxElement) {
        if (autoNotifyOn.checked) {
            autoNotify.checked = true;
        }
    }
}


var openedWindow = null;

document.body.onbeforeunload = handleUnload;

function handleUnload() {
    if (openedWindow) {
        openedWindow.close();
    }
}

function previewDetail() {
    openedWindow = window.open(
            '/preview.aspx?layoutId=',
            'preview',
            'width=700,height=500,' +
            'location=no,dependent=no,resizable=yes,' +
            'toolbar=no,status=no,directories=no,menubar=no,' +
            'scrollbars=1',
            false);
}
function previewEdit() {
    openedWindow = window.open(
            '/preview.aspx?type=Account',
            'preview',
            'width=700,height=500,' +
            'location=no,dependent=no,resizable=yes,' +
            'toolbar=no,status=no,directories=no,menubar=no,' +
            'scrollbars=1',
            false);
}

function saveMe() {
    var nameElement = document.getElementById('name');
    if (nameElement) {
        var layoutName = nameElement.value;
        layoutName = layoutName.replace(/\s/g, '');
        if (layoutName.length == 0) {
            alert('Must enter a name');
            return;
        }
    }

    var xml = toXML();
    /*
    var missingControllers = {};
    for(var i in saveCheckRequiredControllers) {
        if(!(saveCheckRequiredControllers[i] in saveCheckControllers)) {
            missingControllers[saveCheckRequiredControllers[i]]=1;
        }
    }*/
    var fields = "";
    /*
    for( var i in missingControllers ) {
        fields += " '"+i+"'";
    }*/
    var save = (fields.length == 0) || confirm(formatMessage('The following field(s) are controlling other fields, but are not on this page layout: {0}. Continue Saving?', fields));
    if (save) {
        document.newDragOperationForm.xmlValue.value = xml;
        //alert(document.newDragOperationForm.xmlValue.value);
        //document.newDragOperationForm.submit();
        //alert(document.newDragOperationForm.action)
        document.newDragOperationForm.submit();
        //document.forms['newDragOperationForm'].submit();
    }

}
function sectionToXML(tableId) {
    var tId = getSectionIndex(tableId);
    var sectionId = 's' + tId;
    var sectionTableId = getSectionHeaderId(sectionId);
    var sectionTable = document.getElementById(sectionTableId);
    // A section can be a WIL section
    if (!sectionTable) {
        sectionId = 'k' + tId;
        sectionTableId = getSectionHeaderId(sectionId);
        sectionTable = document.getElementById(sectionTableId);
    }

    var sectionName = escapeXML(sectionTable.innerHTML);
    var sortOrder = sectionTable.sortOrder;
    var detailHeading = sectionTable.detailHeading;
    var editHeading = sectionTable.editHeading;
    var fieldsTable = document.getElementById(sectionId);
    var xml = '';
    if (fieldsTable) {
        xml += '<' + 'section ';
        xml += 'sectionId="' + sectionTable.itemId + '" ';
        xml += 'name="' + sectionName + '" ';
        xml += 'canEditLabel="' + sectionTable.canEditLabel + '" ';
        xml += 'masterLabel="' + escapeXML(sectionTable.masterLabel) + '" ';
        xml += 'sortOrder="' + sortOrder + '" ';
        xml += 'detailHeading="' + detailHeading + '" ';
        xml += 'editHeading="' + editHeading + '" ';
        xml += 'numColumns="' + fieldsTable.rows[0].cells.length + '" ';
        xml += '>\n';
        for (var j = 0; j < fieldsTable.rows.length; j++) {
            var row = fieldsTable.rows[j];
            for (var k = 0; k < row.cells.length; k++) {
                xml += fieldToXML(row.cells[k], k);
            }
        }
        xml += '</section>\n';
    }
    return xml;
}
function fieldToXML(field, x) {
    var xml = '';
    if (field.itemId && field.itemId != '') {

        xml += '\t<item ';
        xml += 'name="' + escapeXML(field.fName) + '" ';
        xml += 'itemId="' + field.itemId + '" ';
        xml += 'itemType="' + field.fieldType + '" ';
        if (field.layouts) xml += 'lIds="' + field.layouts + '" ';
        var fieldBehavior = null;
        if (field.fieldType == 'F' || field.fieldType == 'C') {
            fieldBehavior = field.ro == '1' ? 'readonly' : (field.rq == '1' ? 'required' : 'editable');
        } else if (field.fieldType == 'K') {
            fieldBehavior = field.il == '1' ? 'inline' : 'popup';
        }
        if (fieldBehavior) {
            xml += 'behavior="' + fieldBehavior + '" ';
        }
        xml += 'xPos="' + x + '" ';
        xml += '>';
        if (field.fieldType == 'R' || field.fieldType == 'L') {
            var columns = field.columns;
            if (field.hasChildren && columns && columns.length > 0) {
                // Only send over the columns if it has changed
                if (columns != field.defaultColumns) {
                    for (var i = 0; i < columns.length; i++) {
                        xml += columnToXML(columns[i]);
                    }
                }
            }
        }
        xml += '</item>\n';
    }
    return xml;
}

function columnToXML(column) {
    var xml = '';
    xml += '<column ';
    xml += 'columnName="' + escapeXML(column.alias) + '" ';
    xml += 'columnId="' + column.columnId + '" ';
    xml += 'columnSorting="' + column.sorting + '" ';
    xml += '>';
    xml += '</column>';
    return xml;
}
function relatedListToXML(relatedListTableId) {
    var xml = '';
    var relatedListTable = document.getElementById(relatedListTableId);
    if (relatedListTable) {
        var relatedListRows = relatedListTable.rows;
        xml += '<relatedLists ';
        xml += '>\n';
        for (var i = 0; i < relatedListRows.length; i++) {
            var row = relatedListRows[i];
            for (var j = 0; j < row.cells.length; j++) {
                xml += fieldToXML(row.cells[j], j);
            }
        }
        xml += '</relatedLists>\n';
    }
    return xml;
}
function toXML() {
    var mainTable = document.getElementById('mainLayoutTable');
    var mainRows = mainTable.rows;
    var xml = '<root ';

    var nameElement = document.getElementById('name');
    if (nameElement) {
        xml += 'name="' + escapeXML(nameElement.value) + '" ';
    }
    if (document.getElementById('autoAssign'))
        xml += 'autoAssign="' + (document.getElementById('autoAssign').checked ? '1' : '0') + '" ';
    if (document.getElementById('autoAssignOn'))
        xml += 'autoAssignOn="' + (document.getElementById('autoAssignOn').checked ? '1' : '0') + '" ';
    if (document.getElementById('autoNotify'))
        xml += 'autoNotify="' + (document.getElementById('autoNotify').checked ? '1' : '0') + '" ';
    if (document.getElementById('autoNotifyOn'))
        xml += 'autoNotifyOn="' + (document.getElementById('autoNotifyOn').checked ? '1' : '0') + '" ';
    xml += ' >\n';

    for (var i = 0; i < mainRows.length; i++) {
        var cell = mainRows[i].cells[0];
        var sectionTable = cell.childNodes[0];
        if (sectionTable && sectionTable.id) {
            xml += sectionToXML(sectionTable.id);
        }

    }
    xml += relatedListToXML('l1');

    xml += '</root>\n';

    return xml;
}

function escapeXML(v) {
    //return escapeJS(v, true, false);
    v = v.replace(/&/g, '&amp;');
    v = v.replace(/"/g, '&quot;');
    v = v.replace(/'/g, "\'");
    v = v.replace(/</g, '&lt;');
    v = v.replace(/>/g, '&gt;');

    return v;
}
function escapeJS(v, escapeHTML, escapeWhiteSpace) {
    v = v.replace(/'/g, "\'");

    if (escapeHTML) {
        v = v.replace(/&/g, '&amp;');
        v = v.replace(/</g, '&lt;');
        v = v.replace(/>/g, '&gt;');
    }

    if (escapeWhiteSpace) {
        v = v.replace(/\t/g, "&nbsp;&nbsp;");
        v = v.replace(/\n/g, "<br>");
    }
    return v;
}

function updateTierType(value, tierId) {
    var tier_type = value;
    var chain_id = ''
	//var tierId   = tierId
	//document.newDragOperationForm.action+="?tier_type="+value+"&chain_id="+chain_id+"&tierId="+tierId;
	//document.newDragOperationForm.submit();
    return tire_type;
}