<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

    Employee emp = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(Employee.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_TIME) && StringUtils.isNotEmpty(id))
        emp = Employee.findById(Integer.parseInt(id));
    else
        emp = (Employee) request.getAttribute("OBJECT");

    String p_employee = StringUtils.defaultString(request.getParameter("employee"), "allemployees");
//    String p_date = StringUtils.defaultString(request.getParameter("date"), "");
    String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
    String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");
    String id_employee = "";
    id_employee = p_employee.equals("allemployees")? "0" :  p_employee;
    
    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        NotWorkingtimeEmp.deleteWTEmp(Integer.parseInt(id));
        response.sendRedirect("./list_employee.jsp");
        return;
    }

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }

    HashMap employees = Employee.findAllMap();
    String date_stmt = "";
    boolean bFlag = false;
    if(!p_start_date.equals("") && !p_end_date.equals(""))
    {
        date_stmt = "(DATE(w_date) BETWEEN DATE('" + p_start_date + "') AND DATE('" + p_end_date + "')) ";
        bFlag = true;
    }
    else
    {
        if(!p_start_date.equals("") && p_end_date.equals(""))
        {
            date_stmt = "(DATE(w_date) >= DATE('" + p_start_date + "')) ";
            bFlag = true;
        }
        else
        {
            if(p_start_date.equals("") && !p_end_date.equals(""))
            {
                date_stmt = "(DATE(w_date) <= DATE('" + p_end_date + "')) ";
                bFlag = true;
            }
        }
    }
    String filter = date_stmt;
    if(emp != null)
    {
        if(bFlag)
            filter = " and ";
        filter = filter + "employee_id = " + emp.getId();
    }
    if(!filter.equals(""))
        filter = " where " + filter;
    String limit = " LIMIT " + offset + "," + ActionUtil.PAGE_ITEMS;
    ArrayList list = NotWorkingtimeEmp.findByFilterLimit(filter, limit);
    int count = NotWorkingtimeEmp.countByFilter(filter);

//    ArrayList list;
//    if(!p_date.equals(""))
//    {
//        java.util.Date currentDate = null;
//        currentDate = (new SimpleDateFormat("yyyy/MM/dd")).parse(p_date);
//        list = NotWorkingtimeEmp.findAllByEmployeeIdAndDate(emp.getId(),DateUtil.toSqlDate(currentDate));
//    }
//    else
//        list = NotWorkingtimeEmp.findAllByEmployeeId(emp.getId());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Breaks time of Employee</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
        <link rel="stylesheet" type="text/css" media="all" href="../jscalendar/calendar-hd-admin.css" title="hd" />
        <script type="text/javascript" src="../jscalendar/calendar.js"></script>
        <script type="text/javascript" src="../jscalendar/lang/calendar-en.js"></script>
        <script type="text/javascript" src="../jscalendar/calendar-setup.js"></script>
		<script type="text/JavaScript">
    <!--
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
    <form action="./time_employee.jsp?action=time&id=<%=id%>" method="post" name="list_form" id="list_form">
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
                        <div class="heading">
                            <table width="1000" border="0" cellpadding="0" cellspacing="0">
                           <TR class="top_filter">
                               <td style="width: 70%;">
                                    <h1>Breaks time of Employee</h1>
                               </td>
                                <TD nowrap align="right">
                                    <table cellspacing="0" cellpadding="0"><tr>
                                    <td>
                                        Start&nbsp;date:
                                    </td>
                                    <td style="margin:0; padding: 0">
                                    <input readonly type="text" id="startdate" name="startdate" value="<%=p_start_date%>" style="width: 60px; vertical-align:top;" />
                                    </td>
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
                                <TD nowrap align="right">
                                    <table cellspacing="0" cellpadding="0"><tr>
                                    <td>
                                        End&nbsp;date:
                                    </td>
                                    <td style="margin:0; padding: 0">
                                    <input readonly type="text" id="enddate" name="enddate" value="<%=p_end_date%>" style="width: 60px; vertical-align:top;" />
                                    </td>
                                    <td style="margin:0; padding: 0"><input type="button" id="selDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
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

                        </div>
                        <table class="data">
                        <tr>
                            <th class="date" style="text-align:center;" title="Date of break">Date</th>
                            <th class="time" style="text-align:center;" title="Time started">From</th>
                            <th class="time" style="text-align:center;" title="Time ended">Until</th>
                            <th class="comment-break" title="Comments">Comment</th>
                            <th style="width:50px;" />
                        </tr>
                        <%for(int i=0; i<list.size(); i++){
                            NotWorkingtimeEmp wtemp = (NotWorkingtimeEmp)list.get(i);%>
                        <TR>
                            <TD>
                                <DIV align="center"><%=DateUtil.formatYmd(wtemp.getW_date())%></DIV>
                            </TD>
                            <TD>
                                <DIV align="center"><%=wtemp.getH_from()%></DIV>
                            </TD>
                            <TD>
                                <DIV align="center"><%=wtemp.getH_to()%></DIV>
                            </TD>
                            <TD>
                                <DIV align="left"><%=wtemp.getComment()%></DIV>
                            </TD>
                            <TD>
                                <a href="./edit_emptime.jsp?action=edit&id=<%=wtemp.getId()%>&employee_id=<%=id%>"> <IMG height="16" title="Edit" alt="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png" > </a>
                                <a href="./time_employee.jsp?action=delete&id=<%=wtemp.getId()%>" onclick="confirm('Are you sure to delete?')"><IMG height="16" title="Delete" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png"></a>
                            </TD>

                        </TR><%}%>
                        </table>
                        <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                        <div class="pagelinks">
                            <input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />
                            <a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num - 1%>';document.list_form.submit()">« Previous</a>  <!-- active 'next' link -->
                            <a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num + 1%>';document.list_form.submit()">Next »</a>  <!-- active 'next' link -->
                        </div>
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
