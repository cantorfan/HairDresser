<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.Cashio" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Transaction" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.EMPTY);
    String id = StringUtils.defaultString(request.getParameter(Cashio.ID), ActionUtil.EMPTY);
    String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
    String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");

//    if(p_start_date.equals("") && p_end_date.equals(""))
//    {
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
//        p_start_date = sdf.format(new Date());
//        p_end_date = p_start_date;
//    }

    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        Cashio.deleteCashio(Integer.parseInt(id));
    }

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }

    ArrayList list;
    int count = 0;

    if(!p_start_date.equals("") && !p_end_date.equals(""))
    {
        list = Cashio.findByDate(p_start_date, p_end_date, offset,ActionUtil.PAGE_ITEMS);
        count = list.size();
    }
    else
    {
        list = Cashio.findAll(offset,ActionUtil.PAGE_ITEMS);
        count = Cashio.countAll();
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage Cash In/Out</title>
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
    <form action="./list_cashio.jsp" method="post" name="list_form" id="list_form">
		<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
			<tr valign="top">
                <%
                    String activePage = "Admin";
                    String rootPath = "../";
                %>
                <%@ include file="../top_page.jsp" %>
			</tr>
			<tr>
				<td height="47" background="../images/ADMIN_03.gif" colspan="3">
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
                   <div class="heading" style="height: 50px;">
                        <table width="1000" border="0" cellpadding="0" cellspacing="0">
                           <TR class="top_filter">
                               <td>
                                    <h1>Manage Cash In/Out <a>(<%=count%> records)</a></h1>
                                </td>
                                <td>
                                   <table border="0" cellpadding="0" cellspacing="0" align="right">
                                        <TR>
                                            <TD class="category" align="center" nowrap>
                                                <table cellspacing="0" cellpadding="0"><tr>
                                                    <td>
                                                        Start date:
                                                    </td>
                                                <td style="margin:0; padding: 0"><input readonly type="text" id="startdate" name="startdate" value="<%=p_start_date%>" style="width: 60px" /></td>
                                                    <td style="margin:0; padding: 0"><input type="button" id="selDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                                </tr></table>
                                                    <SCRIPT type="text/javascript">
                                                                Calendar.setup(
                                                                {
                                                                inputField  : "startdate",     // ID of the input field
                                                                button      : "selDate",  // ID of the button
                                                                showsTime	: false,
                                                                electric    : false
                                                                }
                                                                );
                                                    </SCRIPT>
                                            </TD>
                                            <TD class="category" align="center" nowrap>
                                                <table cellspacing="0" cellpadding="0"><tr>
                                                    <td>End date: </td>
                                                <td style="margin:0; padding: 0"><input readonly type="text" id="enddate" name="enddate" value="<%=p_end_date%>" style="width: 60px" /></td>
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
                                            <td class="submit">
                                                <input class="button_small" type="submit" value="Search" onclick="document.getElementById('<%=ActionUtil.PAGE%>').value='0'; document.list_form.submit();" />
                                            </td>
                                        </TR>
                                    </table>
                                    </td>
                                    </tr>
                                </table>
                    </div>
                    <table class="data">
                    <tr>
                        <th class="date" style="width:33%; text-align:center;" title="Date">Date</th>
                        <th class="money" style="width:33%; text-align:center;" title="Amount in">In</th>
                        <th class="money" style="width:33%; text-align:center;" title="Amoutn out">Out</th>
                        <th style="width:50px;"/>
                    </tr>
                    <%for(int i=0; i<list.size(); i++){
                        Cashio cash = (Cashio)list.get(i);%>
                    <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                        <TD>
                            <%=(cash.getCreated_dt() != null) ? DateUtil.formatDate(cash.getCreated_dt()) : ""%>
                        </TD>
                        <TD>
                            <%=cash.getCin()%>
                        </TD>
                        <TD>
                            <%=cash.getCout()%>
                        </TD>
                        <TD>
                            <%--<a href="./edit_cashio.jsp?action=add"><IMG height="16" alt="Add" src="../images/add.png" width="16" longDesc="../images/add.png"></a>--%>
                            <a href="./edit_cashio.jsp?action=edit&id=<%=cash.getId()%>"><IMG title="Edit" height="16" alt="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png"></a>
                            <a href="./list_cashio.jsp?action=delete&id=<%=cash.getId()%>&<%=ActionUtil.PAGE%>=<%=pg_num%>" onclick="confirm('Are you sure to delete?')"><IMG title="Delete" height="16" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png"></a>
                        </TD>
                    </TR><%}%>
                    </table>
                    <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                    <table>
                    <tr><td><a href="./list_cashio.jsp?<%=ActionUtil.PAGE%>=<%=pg_num + 1%>">Next &gt;&gt;</a></td></tr>
                    </table>
                    <%}%>
                </div>
            </div>
            </td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
        </form>
	</body>
</html>