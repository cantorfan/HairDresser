<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.bean.Cashio" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
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
    Cashio cash = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(Cashio.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        cash = Cashio.findById(Integer.parseInt(id));
    else
        cash = (Cashio) request.getAttribute("OBJECT");
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
		<title>Add or edit cash transaction</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
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
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1><%=title%> cash transaction</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <!-- success/error message:
                            <div class="error"><p>Error message</p></div>
                            <div class="success"><p>Success message</p></div>
                            -->
                            <form id="cashio" name="cashio" method="post" action="./cashio.do?action=<%=action%>" onsubmit="javascript: return formvalidate(this);">
                                <logic:notPresent name="org.apache.struts.action.MESSAGE" scope="application">
                                    <font color="red"> ERROR: Application resources not loaded -- check servlet container logs for error messages. </font>
                                </logic:notPresent>
                                <% String prompt = (String) request.getAttribute("MESSAGE");  if (StringUtils.isNotEmpty(prompt)){%>
                                <p><font color="red" face=verdana size="-1"><bean:message key="<%=prompt%>"/></font></p><%}%>
                                <input name="id" type="hidden" value="<%=(cash!=null?String.valueOf(cash.getId()):"")%>">
                                <div class="validation"><%=resx.getREQMESSAGE()%></div>
                                <%--<div class="field">--%>
                                    <%--<label for="created_dt">Date (yyyy-dd-mm)</label>--%>
                                    <%--<input id="created_dt" name="created_dt" type="text" maxlength="30" value="<%=(cash != null) ? DateUtil.formatDate(cash.getCreated_dt()) : ""%>">--%>
                                <%--</div>--%>

                                <div class="field">
                                    <label for="created_dt">Date (yyyy-mm-dd) <%=resx.getVALIDATOR()%></label>
                                    <table cellspacing="0" cellpadding="0" style="float: left; clear:right"><tr>
                                    <td style="margin:0; padding: 0">
                                    <input readonly valid="text" type="text" id="created_dt" name="created_dt" style="width: 105px" value="<%=(cash != null) ? DateUtil.formatDate(cash.getCreated_dt()) : ""%>" />
                                    </td>
                                    <td style="margin:0; padding: 0"><input type="button" id="selDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                    </tr></table>
                                    <link rel="stylesheet" type="text/css" media="all" href="../jscalendar/calendar-hd-admin.css" title="hd" />
                                    <script type="text/javascript" src="../jscalendar/calendar.js"></script>
                                    <script type="text/javascript" src="../jscalendar/lang/calendar-en.js"></script>
                                    <script type="text/javascript" src="../jscalendar/calendar-setup.js"></script>
                                        <SCRIPT type="text/javascript">
                                                    Calendar.setup(
                                                    {
                                                    inputField  : "created_dt",     // ID of the input field
                                                    button      : "selDate",  // ID of the button
                                                    showsTime	: false,
                                                    electric    : false
                                                    }
                                                    );
                                        </SCRIPT>
                                </div>
                                <br /><br />
                                <div class="field">
                                    <label for="cin">In (0.00)</label>
                                    <input id="cin" name="cin" type="text" maxlength="30" value="<%=(cash!=null?cash.getCin().setScale(2,BigDecimal.ROUND_HALF_DOWN).toString():"0")%>">
                                </div>

                                <div class="field">
                                    <label for="cout">Out (0.00)</label>
                                    <input id="cout" name="cout" type="text" maxlength="30" value="<%=(cash!=null?cash.getCout().setScale(2,BigDecimal.ROUND_HALF_DOWN).toString():"0")%>">
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
                                                <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_cashio.jsp'">--%>
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
	</body>
</html>