<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%
    User user_ses = (User) session.getAttribute("user");
    if (user_ses == null){
        response.sendRedirect("../error.jsp?ec=1");
        return;
    }
    if (user_ses.getPermission() != Role.R_ADMIN){
        response.sendRedirect("../error.jsp?ec=2");
        return;
    }
    ResourcesManager resx = new ResourcesManager();
    Employee emp = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(Employee.ID), ActionUtil.EMPTY);
    ArrayList list_service = Service.findAll();
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        emp = Employee.findById(Integer.parseInt(id));
    else
        emp = (Employee) request.getAttribute("OBJECT");
    String title = "";
    if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
        title = "Add";
    } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
        title = "Edit";
    }
    ArrayList listDay = null;
    if(emp != null)
        listDay = WorkingtimeEmp.findAllByEmployeeIdAndType(emp.getId(), 1);
    ArrayList list = User.findAll();
    ArrayList locations = Location.findAll();
    ArrayList wtime = (emp != null? WorkingtimeEmp.findAllByEmployeeId(emp.getId()) : null) ;
    java.util.List work_time = new ArrayList();
    for(double i = 0; i <= 24; i+=0.25){
        int h = (int)i;
        int m = (int)((i - h)*60);
        String s = (h < 10 ? "0" : "") + Integer.toString(h) + ":" +
                (m < 10 ? "0" : "") + Integer.toString(m) + ":00";
        work_time.add(s);
    }
//    java.util.List work_time = new ArrayList();
//        work_time.add("08:00:00");
//        work_time.add("08:15:00");
//        work_time.add("08:30:00");
//        work_time.add("08:45:00");
//        work_time.add("09:00:00");
//        work_time.add("09:15:00");
//        work_time.add("09:30:00");
//        work_time.add("09:45:00");
//        work_time.add("10:00:00");
//        work_time.add("10:15:00");
//        work_time.add("10:30:00");
//        work_time.add("10:45:00");
//        work_time.add("11:00:00");
//        work_time.add("11:15:00");
//        work_time.add("11:30:00");
//        work_time.add("11:45:00");
//        work_time.add("12:00:00");
//        work_time.add("12:15:00");
//        work_time.add("12:30:00");
//        work_time.add("12:45:00");
//        work_time.add("13:00:00");
//        work_time.add("13:15:00");
//        work_time.add("13:30:00");
//        work_time.add("13:45:00");
//        work_time.add("14:00:00");
//        work_time.add("14:15:00");
//        work_time.add("14:30:00");
//        work_time.add("14:45:00");
//        work_time.add("15:00:00");
//        work_time.add("15:15:00");
//        work_time.add("15:30:00");
//        work_time.add("15:45:00");
//        work_time.add("16:00:00");
//        work_time.add("16:15:00");
//        work_time.add("16:30:00");
//        work_time.add("16:45:00");
//        work_time.add("17:00:00");
//        work_time.add("17:15:00");
//        work_time.add("17:30:00");
//        work_time.add("17:45:00");
//        work_time.add("18:00:00");
//        work_time.add("18:15:00");
//        work_time.add("18:30:00");
//        work_time.add("18:45:00");
//        work_time.add("19:00:00");
//        work_time.add("19:15:00");
//        work_time.add("19:30:00");
//        work_time.add("19:45:00");
//        work_time.add("20:00:00");
//        work_time.add("20:15:00");
//        work_time.add("20:30:00");
//        work_time.add("20:45:00");
//        work_time.add("21:00:00");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=title%> Employee</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
        <script language="javascript" type="text/javascript" src="../Js/includes/prototype.js"></script>
        <script type="text/javascript" src="../ajax/yahoo-min.js"></script>
        <script type="text/javascript" src="../ajax/event-min.js"></script>
        <script type="text/javascript" src="../ajax/connection-min.js"></script>
        <script type="text/javascript" src="../Js/formvalidate.js"></script>
        <link rel="stylesheet" type="text/css" media="all" href="../jscalendar/calendar-hd-admin.css" title="hd" />
        <script type="text/javascript" src="../jscalendar/calendar.js"></script>
        <script type="text/javascript" src="../jscalendar/lang/calendar-en.js"></script>
        <script type="text/javascript" src="../jscalendar/calendar-setup.js"></script>
		<script type="text/JavaScript">
    <!--
    // navigation controller
    var Menu = { }

    Menu.Show = function(li)
    {
     li.className += " show";
    }

    Menu.Hide = function(li)
    {
     li.className = li.className.replace(" show", "");
    }
    function MM_swapImgRestore() { //v3.0
        var i,x,a = document.MM_sr;
        for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
    }

    function MM_preloadImages() { //v3.0
        var d = document;
        if (d.images) {
            if (!d.MM_p) d.MM_p = new Array();
            var i,j = d.MM_p.length,a = MM_preloadImages.arguments;
            for (i = 0; i < a.length; i++)
                if (a[i].indexOf("#") != 0) {
                    d.MM_p[j] = new Image;
                    d.MM_p[j++].src = a[i];
                }
        }
    }

    function MM_findObj(n, d) { //v4.01
        var p,i,x;
        if (!d) d = document;
        if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
            d = parent.frames[n.substring(p + 1)].document;
            n = n.substring(0, p);
        }
        if (!(x = d[n]) && d.all) x = d.all[n];
        for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
        if (!x && d.getElementById) x = d.getElementById(n);
        return x;
    }

    function MM_swapImage() { //v3.0
        var i,j = 0,x,a = MM_swapImage.arguments;
        document.MM_sr = new Array;
        for (i = 0; i < (a.length - 2); i += 3)
            if ((x = MM_findObj(a[i])) != null) {
                document.MM_sr[j++] = x;
                if (!x.oSrc) x.oSrc = x.src;
                x.src = a[i + 2];
            }
    }

    function DragDropOptions(from, to, index){
        var newopt = document.createElement("option");
        var txt = from.options[index].text.toString();
        var value = from.options[index].value.toString();
        newopt.appendChild(document.createTextNode(txt));
        newopt.setAttribute("value",value);
        to.appendChild(newopt);
        from.remove(index);
    }

    function DragDropAllOptions(from, to){
        var length = from.options.length;
        for (var i = 0; i<length; i++){
            DragDropOptions(from, to, 0);
        }
    }

    function DragService(serv) {
        var empserv = document.getElementById("employeeservice");
        var allserv = document.getElementById("allservice");
        switch (serv) {
        case "emp":
//            var empserv = document.getElementById("employeeservice");
//            var allserv = document.getElementById("allservice");
                if (empserv.selectedIndex != -1){
                    var idserv = empserv.value;
                    DragDropOptions(empserv, allserv, empserv.selectedIndex);
                    var xmlRequestAppointment;
                    try {
                        xmlRequestAppointment = new XMLHttpRequest();
                    } catch(e) {
                        try {
                            xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch(e) {
                        }
                    }
                    xmlRequestAppointment.open("POST", "./empserv.do?action=delete&employee_id=<%=id%>&service_id="+idserv);
                    xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
                    xmlRequestAppointment.send('');
                }
        break;
        case "serv":
                    if (allserv.selectedIndex != -1){
                        var idserv = allserv.value;
                        DragDropOptions(allserv, empserv, allserv.selectedIndex);
                        var xmlRequestAppointment;
                        try {
                            xmlRequestAppointment = new XMLHttpRequest();
                        } catch(e) {
                            try {
                                xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");
                            } catch(e) {
                            }
                        }
                        xmlRequestAppointment.open("POST", "./empserv.do?action=add&employee_id=<%=id%>&service_id="+idserv+"&price=-1&duration=-1&taxes=-1");
                        xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
                        xmlRequestAppointment.send('');
                    }
        break;
        case "allemp":
                DragDropAllOptions(empserv, allserv);
            var xmlRequestAppointment;
            try {
                xmlRequestAppointment = new XMLHttpRequest();
            } catch(e) {
                try {
                    xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e) {
                }
            }
            xmlRequestAppointment.open("POST", "./empserv.do?action=delete&employee_id=<%=id%>&actionall=2");
            xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
            xmlRequestAppointment.send('');
        break;
        case "allserv":
                DragDropAllOptions(allserv, empserv);
            var xmlRequestAppointment;
            try {
                xmlRequestAppointment = new XMLHttpRequest();
            } catch(e) {
                try {
                    xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e) {
                }
            }
            xmlRequestAppointment.open("POST", "./empserv.do?action=add&employee_id=<%=id%>&actionall=1");
            xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
            xmlRequestAppointment.send('');
        break;
        }
    }

    function checkOneDay()
    {
        if(document.getElementById('checkCustomWorkTime').checked)
            document.getElementById('manageCustomWorkTime').style.display = 'block';
        else
            document.getElementById('manageCustomWorkTime').style.display = 'none';
    }

    function clickAddDay()
    {
        var strId = <%=emp != null? emp.getId():0%>;
        if(strId == 0)
        {
            alert("You need to save an employee");
            return;
        }
        if (document.getElementById("date").value == ""){
            alert("Please select date.");
            return;
        }

        var strFromTime = document.getElementById('fromTime').value;
        var strToTime = document.getElementById('toTime').value;
        var strDate = document.getElementById('date').value;//document.getElementById('tbFromSelYear').value + "/" + document.getElementById('tbFromSelMonth').value + "/" + document.getElementById('tbFromSelDay').value;

            new Ajax.Request( '../empOneDay?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "CHECK",
                id: strId,
                fromTime: strFromTime,
                toTime: strToTime,
                Date: strDate
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                if(response != ''){
                    alert(response);
                }
                else{
                    new Ajax.Request( '../empOneDay?rnd=' + Math.random() * 99999, { method: 'get',
                    parameters: {
                        action: "ADD",
                        id: strId,
                        fromTime: strFromTime,
                        toTime: strToTime,
                        Date: strDate
                    },
                    onSuccess: function(transport) {
                        var response = new String(transport.responseText);
                        if(response != ''){
                            alert(response);
                        }
                        else
                            refreshList(strId);
                    }.bind(this),
                    onException: function(instance, exception){
                        alert('Error add reconcil: ' + exception);
                    }
                    });
                }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error add reconcil: ' + exception);
            }
            });

    }

    function getSelectedIndexes (oListbox)
    {
        var arrIndexes = new Array;
        for (var i=0; i < oListbox.options.length; i++)
        {
            if (oListbox.options[i].selected) arrIndexes.push(oListbox.options[i].value);
        }
        return arrIndexes;
    }

    function clickEditDay()
    {
        var strId = <%=emp != null? emp.getId():0%>;
        if(strId == 0)
        {
            alert("You need to save an employee");
            return;
        }
        var objListCustomWorkTime = document.getElementById('listCustomWorkTime');
        var arrIndex = getSelectedIndexes(objListCustomWorkTime);
        if(arrIndex.length != 1 )
        {
            alert("You can change only one element");
            return;
        }

        var strFromTime = document.getElementById('fromTime').value;
        var strToTime = document.getElementById('toTime').value;
        var strDate = document.getElementById('date').value;//document.getElementById('tbFromSelYear').value + "/" + document.getElementById('tbFromSelMonth').value + "/" + document.getElementById('tbFromSelDay').value;
        var strIdItem = arrIndex[0];

            new Ajax.Request( '../empOneDay?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "CHECK",
                id: strId,
                fromTime: strFromTime,
                toTime: strToTime,
                Date: strDate,
                idItem: strIdItem
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                if(response != ''){
                    alert(response);
                }
                else{
                        new Ajax.Request( '../empOneDay?rnd=' + Math.random() * 99999, { method: 'get',
                        parameters: {
                            action: "EDIT",
                            id: strId,
                            fromTime: strFromTime,
                            toTime: strToTime,
                            Date: strDate,
                            idItem: strIdItem
                        },
                        onSuccess: function(transport) {
                            var response = new String(transport.responseText);
                            if(response != ''){
                                alert(response);
                            }
                            else
                                refreshList(strId);
                        }.bind(this),
                        onException: function(instance, exception){
                            alert('Error add reconcil: ' + exception);
                        }
                    });
                }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error add reconcil: ' + exception);
            }
        });
    }

    function refreshList(idEmp)
    {
         new Ajax.Request( '../empOneDay?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "REF",
                id: idEmp
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
//                if(response != ''){
                var arr1 = response.split("%");
                var arr2 = "";
//                alert("arr1.length="+arr1.length);
                document.getElementById('listCustomWorkTime').length = 0;
                if (arr1.length > 0){
                    for (i=0; i<arr1.length; i++){
                        arr2 = arr1[i].split("+");
//                        alert("arr2.length="+arr2.length);
//                        alert("arr2[0]="+arr2[0]);
//                        alert("arr2[1]="+arr2[1]);
                        if (arr2.length > 1){
                            document.getElementById('listCustomWorkTime').options[i] = new Option(arr2[1],arr2[0]);
                        }
                    }
                }
//                    document.getElementById('listCustomWorkTime').innerHTML = response;
//                }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error add reconcil: ' + exception);
            }
        });
    }

    function delOneDay(idEmp,strIdItem,arrItem)
    {
        if(strIdItem >= arrItem.length)
        {
            refreshList(idEmp);
            return;
        }
         new Ajax.Request( '../empOneDay?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "DEL",
                id: idEmp,
                idItem: arrItem[strIdItem]
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                strIdItem = strIdItem + 1;
                delOneDay(idEmp,strIdItem,arrItem);
            }.bind(this),
            onException: function(instance, exception){
                alert('Error add reconcil: ' + exception);
            }
        });
    }

    function clickDelDay()
    {
        var strId = <%=emp != null? emp.getId():0%>;
        if(strId == 0)
        {
            alert("You need to save an employee");
            return;
        }

        var objListCustomWorkTime = document.getElementById('listCustomWorkTime');
        var arrIndex = getSelectedIndexes(objListCustomWorkTime);
        if(arrIndex.length == 0 )
        {
            alert("No selected items for delete");
            return;
        }
        delOneDay(strId,0,arrIndex);
    }
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
		<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
			<tr valign="top">
                <%
                    String activePage = "Admin";
                    String rootPath = "../";
                %>
                <%@ include file="../top_page.jsp" %>
			</tr>
			<tr>
				<td height="47" colspan="3">
                     <%@ include file="../menu_main.jsp" %>
				</td>
			</tr>
            <%@ include file="menu.jsp"%>
		</table>
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0">
			<tr>
                <td>
                <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1><%=title%> Empoyee</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <!-- success/error message:
                            <div class="error"><p>Error message</p></div>
                            <div class="success"><p>Success message</p></div>
                            -->
                            <%--<logic:notPresent name="org.apache.struts.action.MESSAGE" scope="application">--%>
                            <%--<font color="red"> ERROR: Application resources not loaded -- check servlet container logs for error messages. </font>--%>
                            <%--</logic:notPresent>--%>
                            <%--<% String prompt = (String) request.getAttribute("MESSAGE");  if (StringUtils.isNotEmpty(prompt)){%>--%>
                            <%--<p><font color="red" face=verdana size="-1"> <bean:message key="<%=prompt%>"/> </font></p><%}%>--%>
                            <form id="employee" name="employee" method="post" action="./employee.do?action=<%=action%>" enctype="multipart/form-data" onsubmit="return formvalidate(this);">
                            <input name="id" type="hidden" value="<%=(emp!=null?String.valueOf(emp.getId()):"")%>">
                            <div class="validation"><%=resx.getREQMESSAGE()%></div>
                            <div class="field">
                                <div style="float: left;">
                                    <label for="fname">First Name <%=resx.getVALIDATOR()%></label>
                                    <input valid="text" id="fname" name="fname" type="text" maxlength="30" value="<%=(emp!=null&& emp.getFname()!=null?emp.getFname():"")%>">
                                </div>
                                <div class="contacts">
                                    <label for="homephone">Homephone</label>
                                    <input id="homephone" name="homephone" type="text" maxlength="30" value="<%=(emp!=null&& emp.getHomephone()!=null?emp.getHomephone():"")%>">
                                </div>
                                <div class="contacts">
                                    <label>Hiredate</label>
                                    <table cellspacing="0" cellpadding="0" style="float: left">
                                        <tr>
                                            <%
                                                String hdt = "";
                                                if(emp != null && emp.getHiredate()!=null)
                                                {
                                                    hdt = StringUtils.defaultString(emp.getHiredate().toString(), "");
                                                    Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(hdt);
                                                    if (lMatcher.matches()) {
                                                        hdt = hdt.trim().replace('-', '/').replaceAll("/0", "/");
                                                    }
                                                }
                                                String tdt = "";
                                                if(emp != null && emp.getTermdate()!=null)
                                                {
                                                    tdt = StringUtils.defaultString(emp.getTermdate().toString(), "");
                                                    Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(tdt);
                                                    if (lMatcher.matches()) {
                                                        tdt = tdt.trim().replace('-', '/').replaceAll("/0", "/");
                                                    }
                                                }
                                            %>
                                            <td style="margin:0; padding: 0"><input readonly id="hiredate" name="hiredate" type="text" maxlength="30" value="<%=hdt%>"></td>
                                            <td style="margin:0; padding: 0"><input type="button" id="selhireDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                        </tr></table>
                                    <SCRIPT type="text/javascript">
                                        Calendar.setup(
                                                {
                                                    inputField  : "hiredate",     // ID of the input field
                                                    button      : "selhireDate",  // ID of the button
                                                    showsTime	: false,
                                                    electric    : false
                                                }
                                        );
                                    </SCRIPT>
                                </div>                                <div class="clear"></div>
                            </div>

                            <div class="field">
                                <div style="float: left;">
                                    <label for="lname">Last Name <%=resx.getVALIDATOR()%></label>
                                    <input valid="text" id="lname" name="lname" type="text" maxlength="30" value="<%=(emp!=null&& emp.getLname()!=null?emp.getLname():"")%>">
                                </div>
                               <%-- <div class="contacts">
                                    <label for="hiredate">Hiredate</label>
                                    <input id="hiredate" name="hiredate" type="text" maxlength="30" value="<%=(emp!=null&& emp.getHiredate()!=null?emp.getHiredate():"")%>">
                                </div>
                                <div class="contacts">
                                    <label for="termdate">Termdate</label>
                                    <input id="termdate" name="termdate" type="text" maxlength="30" value="<%=(emp!=null&& emp.getTermdate()!=null?emp.getTermdate():"")%>">
                                </div>--%>
                                <div class="contacts">
                                    <label for="cellphone">Cellphone</label>
                                    <input id="cellphone" name="cellphone" type="text" maxlength="30" value="<%=(emp!=null&& emp.getCellphone()!=null?emp.getCellphone():"")%>">
                                </div>

                                <div class="contacts">
                                    <label>Termdate</label>
                                    <table cellspacing="0" cellpadding="0" style="float: left">
                                        <tr>
                                            <td style="margin:0; padding: 0"><input readonly id="termdate" name="termdate" type="text" maxlength="30" value="<%=tdt%>"></td>
                                            <td style="margin:0; padding: 0"><input type="button" id="seltermDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                        </tr></table>
                                    <SCRIPT type="text/javascript">
                                        Calendar.setup(
                                                {
                                                    inputField  : "termdate",     // ID of the input field
                                                    button      : "seltermDate",  // ID of the button
                                                    showsTime	: false,
                                                    electric    : false
                                                }
                                        );
                                    </SCRIPT>
                                </div>

                                <div class="clear"></div>
                            </div>

                            <div class="field" align="left">
                                <div style="float: left;">
                                    <label for="address" >Address</label>
                                    <textarea id="address" name="address" class="address" style="text-align:left;" rows="5" cols="50"><%=(emp!=null&& emp.getAddress()!=null?emp.getAddress():"")%></textarea>
                                </div>
                                <div class="contacts">
                                    <label for="city">City</label>
                                    <input id="city" name="city" type="text" maxlength="30" value="<%=(emp!=null&& emp.getCity()!=null?emp.getCity():"")%>">
                                </div>
                                <div class="contacts">
                                    <label for="postcode">Postcode</label>
                                    <input id="postcode" name="postcode" type="text" maxlength="30" value="<%=(emp!=null&& emp.getPostcode()!=null?emp.getPostcode():"")%>">
                                </div>
                                <div class="clear"></div>
                            </div>

                            <div class="field">
                                <label for="email">Email</label>
                                <input id="email" name="email" type="text" maxlength="30" value="<%=(emp!=null&& emp.getEmail()!=null?emp.getEmail().toString():"")%>">
                            </div>

                            <div class="field">
                                <label>Sex</label>
                                <input type="radio" name="male_female" value="male" <%if(emp!=null && emp.getMale_female() == 1){%>checked="true" <%}%>>Male
                                <input type="radio" name="male_female" value="female" <%if(emp!=null && emp.getMale_female() == 2){%>checked="true" <%}%>>Female
                            </div>

                            <div class="field">
                                <label for="picture">Employee photo</label>
                                <input id="picture" name="picture" type="file">
                            </div>

                            <div class="field">
                                <label>Picture</label>
                                <IMG height="50"  <% String image; String alt;
                                if (emp!=null){
                                    image = "./ShowPhoto.do?id="+String.valueOf(emp.getId());
                                    alt = String.valueOf(emp.getFname()) + String.valueOf(emp.getLname());
                                }else {
                                        image = "../images/noimage.jpg";
                                        alt = "No Photo";
                                }
                                %>
                                src= "<%=image%>" alt="<%=alt%>">
                            </div>

                            <div class="field">
                                <label for="login_id">Login <%=resx.getVALIDATOR()%></label>
                                <select valid="select" id="login_id" name="login_id">
                                <%for(int i=0; i<list.size(); i++){
                                    User u = (User)list.get(i);%>
                                    <option value="<%=u.getId()%>" <%=(emp!=null && emp.getLogin_id()==u.getId()?"selected":"")%>><%=u.getUser()%></option>
                                <%}%>
                                </select>
                            </div>

                            <div class="field">
                                <label for="commission">Commission <b><span style="color:#000;">(%)</span></b> Service</label>
                                <input valid="taxe" id="commission" name="commission" type="text" maxlength="30" value="<%=(emp!=null&& emp.getCommission()!=null?emp.getCommission().setScale(2,BigDecimal.ROUND_HALF_DOWN).toString():"0")%>">
                            </div>

                            <div class="field">
                                <label for="salary">Commission <b><span style="color:#000;">(%)</span></b> Products</label>
                                <input valid="taxe" id="salary" name="salary" type="text" maxlength="30" value="<%=(emp!=null&& emp.getSalary()!=null?emp.getSalary().toString():"")%>">
                            </div>

                            <div class="field">
                                <label for="comment">Comment</label>
                                <input id="comment" name="comment" type="text" maxlength="30" value="<%=(emp!=null&& emp.getComment()!=null?emp.getComment().toString():"")%>">
                            </div>
                            <%--<div class="field">--%>
                                <%--<label>Schedule</label>--%>
                                <%--<SPAN style="margin-left:10px;">&nbsp;</SPAN>--%>
                                <%--&nbsp;Mon&nbsp;<input type="checkbox" name="schedule" id ="mon" class="ctrl" style="HEIGHT:10px;margin-right:30px;" value="sch_0" <%=(emp!=null && emp.getSafeSchedule()[0]=='1'?"checked":"")%>>--%>
                                <%--&nbsp;Tue&nbsp;<input type="checkbox" name="schedule" id ="tue" class="ctrl" style="HEIGHT:10px;margin-right:30px;" value="sch_1" <%=(emp!=null && emp.getSafeSchedule()[1]=='1'?"checked":"")%>>--%>
                                <%--&nbsp;Wnd&nbsp;<input type="checkbox" name="schedule" id ="wnd" class="ctrl" style="HEIGHT:10px;margin-right:35px;" value="sch_2" <%=(emp!=null && emp.getSafeSchedule()[2]=='1'?"checked":"")%>>--%>
                                <%--&nbsp;Thu&nbsp;<input type="checkbox" name="schedule" id ="thu" class="ctrl" style="HEIGHT:10px;margin-right:35px;" value="sch_3" <%=(emp!=null && emp.getSafeSchedule()[3]=='1'?"checked":"")%>>--%>
                                <%--&nbsp;Fri&nbsp;<input type="checkbox" name="schedule" id ="fri" class="ctrl" style="HEIGHT:10px;margin-right:35px;" value="sch_4" <%=(emp!=null && emp.getSafeSchedule()[4]=='1'?"checked":"")%>>--%>
                                <%--&nbsp;Sat&nbsp;<input type="checkbox" name="schedule" id ="sat" class="ctrl" style="HEIGHT:10px;margin-right:35px;" value="sch_5" <%=(emp!=null && emp.getSafeSchedule()[5]=='1'?"checked":"")%>>--%>
                                <%--&nbsp;Sun&nbsp;<input type="checkbox" name="schedule" id ="sun" class="ctrl" style="HEIGHT:10px;" value="sch_6" <%=(emp!=null && emp.getSafeSchedule()[6]=='1'?"checked":"")%>>--%>
                            <%--</div>--%>
                            <div>
                                <div class="field"><label>Schedule</label></div>
                                <table align="left">
                                    <tr>
                                        <td style="width:70px;">
                                            Mon&nbsp;<input type="checkbox" name="schedule" id ="mon" class="ctrl" style="HEIGHT:10px;/*margin-right:30px;*/" value="sch_0" <%=(emp!=null && emp.getSafeSchedule()[0]=='1'?"checked":"")%>>
                                        </td>
                                        <td style="width:70px;">
                                            Tue&nbsp;<input type="checkbox" name="schedule" id ="tue" class="ctrl" style="HEIGHT:10px;/*margin-right:30px;*/" value="sch_1" <%=(emp!=null && emp.getSafeSchedule()[1]=='1'?"checked":"")%>>
                                        </td>
                                        <td style="width:70px;">
                                            Wnd&nbsp;<input type="checkbox" name="schedule" id ="wnd" class="ctrl" style="HEIGHT:10px;/*margin-right:35px;*/" value="sch_2" <%=(emp!=null && emp.getSafeSchedule()[2]=='1'?"checked":"")%>>
                                        </td>
                                        <td style="width:70px;">
                                            Thu&nbsp;<input type="checkbox" name="schedule" id ="thu" class="ctrl" style="HEIGHT:10px;/*margin-right:35px;*/" value="sch_3" <%=(emp!=null && emp.getSafeSchedule()[3]=='1'?"checked":"")%>>
                                        </td>
                                        <td style="width:70px;">
                                            Fri&nbsp;<input type="checkbox" name="schedule" id ="fri" class="ctrl" style="HEIGHT:10px;/*margin-right:35px;*/" value="sch_4" <%=(emp!=null && emp.getSafeSchedule()[4]=='1'?"checked":"")%>>
                                        </td>
                                        <td style="width:70px;">
                                            Sat&nbsp;<input type="checkbox" name="schedule" id ="sat" class="ctrl" style="HEIGHT:10px;/*margin-right:35px;*/" value="sch_5" <%=(emp!=null && emp.getSafeSchedule()[5]=='1'?"checked":"")%>>
                                        </td>
                                        <td style="width:70px;">
                                            Sun&nbsp;<input type="checkbox" name="schedule" id ="sun" class="ctrl" style="HEIGHT:10px;" value="sch_6" <%=(emp!=null && emp.getSafeSchedule()[6]=='1'?"checked":"")%>>
                                        </td>
                                     </tr>
                                </table>
                                <br>
                                <br>
                            </div>

                            <div>
                                <div class="field"><label>Working from</label></div>
                                <table align="left">
                                    <tr>
                                        <td class="STYLE7">
                                            <select name="fmon" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(0) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==1 && ((wtemp.getH_from().getHours()/*-8*/)*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="ftue" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(1) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==2 && ((wtemp.getH_from().getHours()/*-8*/)*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="fwen" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(2) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==3 && ((wtemp.getH_from().getHours()/*-8*/)*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="fthu" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(3) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==4 && ((wtemp.getH_from().getHours()/*-8*/)*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="ffri" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(4) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==5 && ((wtemp.getH_from().getHours()/*-8*/)*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                           <select name="fsat" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(5) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==6 && ((wtemp.getH_from().getHours()/*-8*/)*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="fsun" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(6) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==7 && ((wtemp.getH_from().getHours()/*-8*/)*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                    </tr>
                                </table>
                               <br/>
                               <br/>
                            </div>

                            <div>

                                <div class="field"><label>Working to</label></div>
                                <table align="left">
                                    <tr>
                                        <td class="STYLE7">
                                            <select name="tmon" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(0) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==1 && ((wtemp.getH_to().getHours()/*-8*/)*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="ttue" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(1) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==2 && ((wtemp.getH_to().getHours()/*-8*/)*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="twen" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(2) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==3 && ((wtemp.getH_to().getHours()/*-8*/)*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="tthu" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(3) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==4 && ((wtemp.getH_to().getHours()/*-8*/)*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="tfri" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(4) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==5 && ((wtemp.getH_to().getHours()/*-8*/)*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                           <select name="tsat" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(5) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==6 && ((wtemp.getH_to().getHours()/*-8*/)*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                        <td class="STYLE7">
                                            <select name="tsun" class="ctrl" style="WIDTH:70px">
                                            <%for(int i=0; i<work_time.size(); i++){
                                                WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(6) : new WorkingtimeEmp());
                                                %>
                                                <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==7 && ((wtemp.getH_to().getHours()/*-8*/)*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                            <%}%>
                                            </select>
                                        </td>
                                     </tr>
                                </table>
                                <br/>
                                <br/>
                            </div>

                            <div>
                                <div class="field"><label>Comment</label></div>
                                <table align="left">
                                    <tr>
                                        <td class="STYLE7">
                                            <input type="text" name="cmon" class="ctrl" style="WIDTH:60px" value="<%= (wtime != null? ((WorkingtimeEmp)wtime.get(0)).getComment() == null ? "" : ((WorkingtimeEmp)wtime.get(0)).getComment() : "") %>">
                                        </td>
                                        <td class="STYLE7">
                                            <input type="text" name="ctue" class="ctrl" style="WIDTH:60px" value="<%= (wtime != null? ((WorkingtimeEmp)wtime.get(1)).getComment() == null ? "" : ((WorkingtimeEmp)wtime.get(1)).getComment() : "") %>">
                                        </td>
                                        <td class="STYLE7">
                                            <input type="text" name="cwen" class="ctrl" style="WIDTH:60px" value="<%= (wtime != null? ((WorkingtimeEmp)wtime.get(2)).getComment() == null ? "" : ((WorkingtimeEmp)wtime.get(2)).getComment() : "") %>">
                                        </td>
                                        <td class="STYLE7">
                                            <input type="text" name="cthu" class="ctrl" style="WIDTH:60px" value="<%= (wtime != null? ((WorkingtimeEmp)wtime.get(3)).getComment() == null ? "" : ((WorkingtimeEmp)wtime.get(3)).getComment() : "") %>">
                                        </td>
                                        <td class="STYLE7">
                                            <input type="text" name="cfri" class="ctrl" style="WIDTH:60px" value="<%= (wtime != null? ((WorkingtimeEmp)wtime.get(4)).getComment() == null ? "" : ((WorkingtimeEmp)wtime.get(4)).getComment() : "") %>">
                                        </td>
                                        <td class="STYLE7">
                                            <input type="text" name="csat" class="ctrl" style="WIDTH:60px" value="<%= (wtime != null? ((WorkingtimeEmp)wtime.get(5)).getComment() == null ? "" : ((WorkingtimeEmp)wtime.get(5)).getComment() : "") %>">
                                        </td>
                                        <td class="STYLE7">
                                            <input type="text" name="csun" class="ctrl" style="WIDTH:60px" value="<%= (wtime != null? ((WorkingtimeEmp)wtime.get(6)).getComment() == null ? "" : ((WorkingtimeEmp)wtime.get(6)).getComment() : "") %>">
                                        </td>
                                     </tr>
                                </table>
                                <br>
                                <br>
                                <br>
                            </div>
                            <div class="field">
                                <label for="description">Description </label>
                                <textarea class="description" id="description" name="description"  > <%=(emp!=null&& emp.getDescription()!=null?emp.getDescription():"")%> </textarea>
                            </div>

                            <div class="field">
                                <label for="checkCustomWorkTime">One day Schedule</label>
                                <input id="checkCustomWorkTime" name="checkCustomWorkTime" type="checkbox" <%=((emp!=null && emp.getOneday())?"checked":"")%> onClick="checkOneDay();">
                            </div>
                            <div id="manageCustomWorkTime" style="float: left; clear: right; width: 100%; display: none">
                                <label>&nbsp;</label>
                                <table id="" border="0" cellpadding="0" cellspacing="0" align="left">
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" align="left">
                                                <tr>
                                                    <td colspan="3"><!--font size="1">Year</font></td>
                                                    <td><font size="1">Month</font></td>
                                                    <td><font size="1">Day</font-->
                                                        Date
                                                    </td>
                                                    <td><font size="1">From</font></td>
                                                    <td><font size="1">To</font></td>
                                                </tr>
                                                <tr>
                                                     <td colspan=3>
                                                        <table cellspacing="0" cellpadding="0"><tr>
                                                        <td style="margin:0; padding: 0"><input type="text" id="date" name="date" style="width: 60px" /></td>
                                                        <td style="margin:0; padding: 0"><input type="button" id="selDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                                        </tr></table>

                                                        <SCRIPT type="text/javascript">
                                                        			Calendar.setup(
                                                        			{
                                                        			inputField  : "date",     // ID of the input field
                                                        			button      : "selDate",  // ID of the button
                                                        			showsTime	: false,
                                                        			electric    : false
                                                        			}
                                                        			);
                                                        </SCRIPT>
                                                    </td>
                                                    <td class="STYLE7" style="padding-left: 5px;">
                                                        <select id="fromTime" class="ctrl" style="WIDTH:70px">
                                                        <%for(int i=0; i<work_time.size(); i++){
                                                            WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(0) : new WorkingtimeEmp());
                                                            %>
                                                            <option value="<%=work_time.get(i)%>"><%=work_time.get(i)%></option>
                                                        <%}%>
                                                    </select>
                                                    <td class="STYLE7">
                                                        <select id="toTime" class="ctrl" style="WIDTH:70px">
                                                        <%for(int i=0; i<work_time.size(); i++){
                                                            WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(0) : new WorkingtimeEmp());
                                                            %>
                                                            <option value="<%=work_time.get(i)%>"><%=work_time.get(i)%></option>
                                                        <%}%>
                                                        </select>
                                                    </td>
                                                    <td class="submit" style="padding-left: 5px;"><input name="AddDay" type="button" class="button_small" value="Add" onClick="clickAddDay();"></td>
                                                    <td class="submit" style="padding-left: 5px;"><input name="EditDay" type="button" class="button_small" value="Edit" onClick="clickEditDay();"></td>
                                                    <td class="submit" style="padding-left: 5px;"><input name="DelDay" type="button" class="button_small" value="Delete" onClick="clickDelDay();"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" align="left" style="padding-top: 20px;">
                                                <tr>
                                                    <td>
                                                        View Days
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <select id="listCustomWorkTime" multiple class="ctrl" style="WIDTH:295px">
                                                        <%if(listDay!=null){for(int i=0; i<listDay.size(); i++){
                                                            WorkingtimeEmp wtemp = (WorkingtimeEmp)listDay.get(i);
                                                            %>
                                                            <option value="<%=wtemp.getId()%>"><%=wtemp.getWork_date()+" "+wtemp.getH_from()+"-"+wtemp.getH_to()%></option>
                                                        <%}}%>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr><td><br></td></tr>
                                </table>
                            </div>
                            <div id="error_message" name="error_message" class="error">
                                <%=resx.getREQERROR()%>
                            </div>
                            <div>
                                <table align="left" class="submit">
                                <br />
                                    <tr>
                                        <td>
                                            <input name="submit" type="submit" class="button_small" value="Save">
                                        </td>
                                        <td>
                                            <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_employee.jsp'">--%>
                                                <input name="back" type="button" class="button_small" value="back" onclick="window.history.back();">
                                        <td>
                                    </tr>
                                </table>
                            </div>

                </form>
                            <!-- main content ends here -->
                        </div>
                    </div>
                </td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
    <script type="text/javascript">
        <% if (action.equals("edit")){%>
            checkOneDay();
        <%}%>
    </script>
	</body>
</html>
