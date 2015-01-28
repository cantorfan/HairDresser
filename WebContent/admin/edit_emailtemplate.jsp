<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
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
    EmailTemplate etp = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(EmailTemplate.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        etp = EmailTemplate.findById(Integer.parseInt(id));
//    else
//        etp = (EmailTemplate) request.getAttribute("OBJECT");
    String title = "";
    if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
        title = "Add";
    } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
        title = "Edit";
    }



%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=title%> Email Template</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
        <script type="text/javascript" src="../Js/includes/prototype.js"></script>
        <script type="text/javascript" src="../Js/formvalidate.js"></script>
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
    //-->
            function getExample(){
                var id = document.getElementById("type").value;
//                alert(id);
                var example = "Example:\n";
//                if (id == 0)
//                    example = "Hello, {customer}!\n" +
//                        "Thank you for registering at https://isalon2you-soft.com/online/\n" +
//                        "-------------------\n" +
//                        "Username: {login}\n" +
//                        "Password: {password}\n" +
//                        "-------------------\n" +
//                        "\n" +
//                        "Sincerely, Administration https://isalon2you-soft.com/online/";
//                if (id == 1)
//                    example = "Hello, {customer}!\n" +
//                        "\n" +
//                        "You have an appointment at https://isalon2you-soft.com/online/\n" +
//                        "-------------------\n" +
//                        "Operator: {operator}\n" +
//                        "Service: {service}\n" +
//                        "Date: {date}\n" +
//                        "Time: {time}\n" +
//                        "Shopping: {product}\n" +
//                        "-------------------\n" +
//                        "\n" +
//                        "Sincerely, Administration https://isalon2you-soft.com/online/";
//                if (id==2)
//                    example = "Hello, {customer}!\n" +
//                        "You booking has been accepted.\n" +
//                        "-------------------\n" +
//                        "Operator: {operator}\n" +
//                        "Service: {service}\n" +
//                        "Date: {date}\n" +
//                        "Time: {time}\n" +
//                        "Shopping: {product}\n" +
//                        "-------------------\n" +
//                        "\n" +
//                        "Sincerely, Administration https://isalon2you-soft.com/online/";
//                if (id==3)
//                    example = "Hello, {customer}!\n" +
//                        "We can not accept your booking.\n" +
//                        "Please make your booking again.\n" +
//                        "You old booking:\n" +
//                        "-------------------\n" +
//                        "Operator: {operator}\n" +
//                        "Service: {service}\n" +
//                        "Date: {date}\n" +
//                        "Time: {time}\n" +
//                        "Shopping: {product}\n" +
//                        "-------------------\n" +
//                        "\n" +
//                        "Sincerely, Administration https://isalon2you-soft.com/online/";
                switch (id) {
                    case "0": example +="Hi {customer},\n" +
                        " \n" +
                        "Welcome to {salonname}. We offer a wide variety of services and products to help you look your best and look forward to providing you with exceptional personal service. \n" +
                        " \n" +
                        "To schedule future appointments, just call us at {salonphone}. We are also pleased to offer our clients the convenience of booking appointments online as well. Just visit us at https://salonlink. \n" +
                        " \n" +
                        "{salonname}";
                        break;
                    case "1": example += "Hi {customer},\n"+
                        " \n"+
                        "Thank you for scheduling an appointment with {operator} at {salonname} for {date} at {time} at (Time) for {service}. \n"+
                        " \n"+
                        "{salonname} is located at {salonaddress}. \n"+
                        " \n"+
                        "You will receive an email from {salonname} very soon confirming your appointment.\n"+
                        " \n"+
                        "{salonname}";
                        break;
                    case "2": example += "Hi {customer},\n"+
                        " \n"+
                        "We are confirming your appointment with {operator} for {date} at {time} for {service}. \n"+
                        " \n"+
                        "Thank you for choosing {salonname}. We look forward to seeing you on {day}. \n"+
                        " \n"+
                        "P.S. If you should need to cancel or reschedule your appointment, please give us a call at {salonphone}.";
                        break;
                    case "3": example += "Hi {customer},\n"+
                        " \n"+
                        "We are contacting you to let you know that we will need to reschedule the appointment you booked online with {operator} for {date} at {time} for {service}. Please give us a call at {salonphone} to reschedule your appointment.\n"+
                        " \n"+
                        "We apologize for the inconvenience and will do our best to find another time that fits into your schedule.\n"+
                        " \n"+
                        "{salonname}";
                        break;
                    case "4": example += "Hi {customer},\n"+
                        " \n"+
                        "We received your request to send you a reminder of your login and password for your online appointment scheduling account. Your login is:{login} and your password is:{password}.\n"+
                        " \n"+
                        "Thank you for using our service!";
                        break;
                    case "5": example += "Hello {customer},\n" +
                        "\n" +
                        "Please note that your appointment have been cancelled with {operator} at {salonaddress} for {date} at {time} for {service}.\n" +
                        "To schedule future appointments, just call us at {salonphone}.\n" +
                        "\n" +
                        "{salonname}";
                        break;
                    case "100": example += "Dear {customerName}, \n\nThis is a reminder of the appointment at {appointmentTime}, Please enjoy time!";
                    	break;
                    case "101": example += "Dear {customerName}, The Appointment at: {dataTime} has been canceled!";
                		break;
                    case "102": example += "Dear {customerName} \n------------------------\nThank you for using iSalon: \nservice:{service}\nproduct:{product}\ngiftcard:{giftcard}\n--------------------------\nat: {dateTime}";
            			break;
                }
                document.getElementById("example").value=example;
            }

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
				<td height="47"  colspan="3">
                     <%@ include file="../menu_main.jsp" %>
				</td>
			</tr>
            <%@ include file="menu.jsp"%>
		</table>
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1><%=title%> Email Template</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                          <form id="template" name="template" method="post" action="../template?action=<%=action%>" onsubmit="javascript: return formvalidate(this);">
                               <input name="id" type="hidden" value="<%=(etp!=null?String.valueOf(etp.getId()):"")%>">


                             <%--<div class="validation"><%=resx.getREQMESSAGE()%></div>--%>
                            <div class="field">
                                <label for="type">Type Template</label>
                                <select id="type" name="type" style="width:200px;" onchange="javascript: getExample();">
                                    <option value="0" <%=(etp!=null && etp.getType()==0?"selected":"")%>>New Customer added Email</option>
                                    <option value="1" <%=(etp!=null && etp.getType()==1?"selected":"")%>>Online Booking Confirmation Email</option>
                                    <option value="2" <%=(etp!=null && etp.getType()==2?"selected":"")%>>Appointment Confirmation Email</option>
                                    <option value="3" <%=(etp!=null && etp.getType()==3?"selected":"")%>>Reschedule Confirmation Email</option>
                                    <option value="4" <%=(etp!=null && etp.getType()==4?"selected":"")%>>Forgot Username and Password Email</option>
                                    <option value="5" <%=(etp!=null && etp.getType()==5?"selected":"")%>>Delete Booking</option>
                                    <option value="100" <%=(etp!=null && etp.getType()==100?"selected":"")%>>Appointment Reminder Email</option>
                                    <option value="101" <%=(etp!=null && etp.getType()==101?"selected":"")%>>Appointment Canceled Notification</option>
                                    <option value="102" <%=(etp!=null && etp.getType()==102?"selected":"")%>>Check Out Notification</option>
                                </select>
                                <%--<input style = "color:black" disabled id="description" name="description" type="text" value="">--%>
                            </div>

                             <div class="field">
                                <label for="description">Description</label>
                                <input style="width:390px;" id="description" name="description" type="text" value="<%=(etp!=null?etp.getDescription():"")%>">
                            </div>
                            <div class="field" align="left">
                                <label for="text" >Template</label>
                                <textarea id="text" name="text" class="text" style="text-align:left;" rows="5" cols="50"><%=(etp!=null?etp.getText():"")%></textarea>

                                <textarea id="example" name="example" cols="50" readonly="" rows="5" style="text-align: left;color:gray;" class="text" ></textarea>
                            </div>
                                <div id="error_message" name="error_message" class="error">
                                    <%=resx.getREQERROR()%>
                                </div>
                                <div>
                                    <table align="left" class="submit">
                                    <br/>
                                        <tr>
                                            <td>
                                                <input name="submit" type="submit" class="button_small" value="Save">
                                            </td>
                                            <td>
                                                <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_emailtemplate.jsp'">--%>
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
        var sel = document.getElementById("type");
        getExample();
    </script>
	</body>
</html>