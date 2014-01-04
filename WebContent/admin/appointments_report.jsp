<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.bean.Location" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Transaction" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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
    ArrayList list = Location.findAll();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
    String dt = sdf.format(Calendar.getInstance().getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Appointments Report</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
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
				<td height="47"  colspan="3">
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
                        <h1>Appointments Report</h1>
                    </div>
                    <div align = "center" class="data">
                    <form id="report" name="report" method="post" action="../report?query=app">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <TD nowrap align="right">
                                    <table cellspacing="0" cellpadding="0"><tr>
                                    <td>Start&nbsp;date:</td>
                                    <td style="margin:0; padding: 0">
                                        <input readonly type="text" id="startdate" value="<%=dt%>" name="startdate" style="width: 60px" />
                                    </td>
                                    <td style="margin:0; padding: 0"><input type="button" id="selStartDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                    </tr></table>
                                        <SCRIPT type="text/javascript">
                                                    Calendar.setup(
                                                    {
                                                    inputField  : "startdate",     // ID of the input field
                                                    button      : "selStartDate",  // ID of the button
                                                    showsTime	: false,
                                                    electric    : false
                                                    }
                                                    );
                                        </SCRIPT>
                                </TD>
                                <td>&nbsp;</td>
                                <TD nowrap align="right">
                                    <table cellspacing="0" cellpadding="0"><tr>
                                    <td>End&nbsp;date:</td>
                                    <td style="margin:0; padding: 0">
                                    <input readonly type="text" id="enddate" name="enddate" value="<%=dt%>" style="width: 60px;vertical-align: top;" />
                                    </td>
                                    <td style="margin:0; padding: 0"><input type="button" id="selEndDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                    </tr></table>
                                        <SCRIPT type="text/javascript">
                                                    Calendar.setup(
                                                    {
                                                    inputField  : "enddate",     // ID of the input field
                                                    button      : "selEndDate",  // ID of the button
                                                    showsTime	: false,
                                                    electric    : false
                                                    }
                                                    );
                                        </SCRIPT>
                                </TD>
                            </tr>
                            <tr>
                                <td  colspan="3" align="right" class="submit">
                                    <input class="button_small" type="submit" value="Generate" onclick="submit();">
                                </td>
                            </tr>
                        </table>
                    </form>
                    </div>
                </div>
            </div>
            </td>
			</tr>
            <%@ include file="../copyright.jsp" %>
        </table>
	</body>
</html>