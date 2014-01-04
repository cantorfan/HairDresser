<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.xu.swan.bean.*" %>
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
    String id = StringUtils.defaultString(request.getParameter(Employee.ID), ActionUtil.EMPTY);
    String p_fname = StringUtils.defaultString(request.getParameter("fname"), "");
    String p_lname = StringUtils.defaultString(request.getParameter("lname"), "");
    String p_email = StringUtils.defaultString(request.getParameter("email"), "");
    String p_login = StringUtils.defaultString(request.getParameter("login"), "alllogin");
    String p_shedule = StringUtils.defaultString(request.getParameter("shedule"), "allshedule");
    String p_commission = StringUtils.defaultString(request.getParameter("commission"), "");
    String p_socialsec = StringUtils.defaultString(request.getParameter("socialsec"), "");
    String p_salary = StringUtils.defaultString(request.getParameter("salary"), "");
    String p_loc = StringUtils.defaultString(request.getParameter("location"), "alllocation");
    String p_search = StringUtils.defaultString(request.getParameter("search"), "");
    String p_shedule2 = "";
    if (!p_shedule.equals("allshedule"))
    {
        int shedule = Integer.parseInt(p_shedule);
        for (int i = 1; i<=7; i++)
        {
            if (i == shedule){
                p_shedule2 = p_shedule2 + 1;
            }
            else p_shedule2 = p_shedule2 + "_";
        }
    }
//    out.print(p_shedule2);
    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        Employee.deleteEmployee(Integer.parseInt(id));
    }


    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if (StringUtils.isNumeric(pg)) {
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
    ArrayList list ;
    String login_stmt = p_login.equals("alllogin") ? "" : " login_id='" + p_login +"' AND ";
    String schedule_stmt = p_shedule.equals("allshedule") ? "" : " schedule LIKE '" + p_shedule2+ "' AND ";
    String email_stmt = p_email.equals("") ? "" : "email LIKE '%" + p_email + "%' AND ";
    String filter =
                    login_stmt +
                    schedule_stmt +
                    email_stmt +
                    "fname LIKE '%" + p_fname + "%' AND " +
                    "lname LIKE '%" + p_lname + "%' " ;
    list = Employee.findByFilter(filter + "LIMIT " + offset + ", " + ActionUtil.PAGE_ITEMS);
    int count = Employee.countByFilter(filter);

//    if (p_fname.equals("") && p_lname.equals("") && p_email.equals("") && p_login.equals("alllogin") && p_shedule.equals("allshedule") && p_commission.equals("") && p_socialsec.equals("") && p_salary.equals("") && p_loc.equals("alllocation")) {
//       list = Employee.findAll(offset, ActionUtil.PAGE_ITEMS);
//    }else list = Employee.findAll();
//    if (p_search.equals("")){
//        list = Employee.findAll(offset, ActionUtil.PAGE_ITEMS);
//    }
//    else list = Employee.findAll();
    ArrayList list_loc = Location.findAll();
    ArrayList list_user = User.findAll();

    HashMap users = User.findAllMap();
    HashMap locations = Location.findAllMap();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage Employees</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
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

    function ExportToExel()
    {
        var fname = document.getElementById('fname').value;
        var lname = document.getElementById('lname').value;
        var email = document.getElementById('email').value;
        var login = document.getElementById('login').value;
        var schedule = document.getElementById('shedule').value;
        window.location.href="../exporttoexcel?action=exporttoexcelemployees&fname="+fname+
                                "&lname="+lname+
                                 "&email="+email+
                                 "&login="+login+
                                 "&schedule="+schedule;
    }
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_employee.jsp" method="post" name="list_form" id="list_form">
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
                            <h1>Manage Employees <a>(<%=list.size()%> records)</a></h1>
                        </div>
                        <table class="data">
                        <tr>
                            <th class="name-employee" title="Employee's first name">First Name</th>
                            <th class="name-employee" title="Employee's last name">Last Name</th>
                            <th class="login" title="Login name">Login</th>
                            <th class="shedule" title="Schedule">Schedule</th>
                            <th class="email-employee" title="Email address">Email</th>
                            <th style="width:100px; text-align:center;">
                                <a href="#"><IMG onclick="ExportToExel();" height="32" alt="Export to Excel" title="Export to Excel" src="../img/exporttoexcel.png" width="32" longDesc="../img/exporttoexcel.png"></a> Export
                            </th>
                        </tr>
                            <TR class="filter">
                                <TD class="name-employee">
                                        <input type="text" id="fname" name="fname" value="<%=p_fname%>"/>
                                </TD>
                                <TD class="name-employee">
                                        <input type="text" id="lname" name="lname" value="<%=p_lname%>"/>
                                </TD>
                                <TD class="login">
                                    <select name="login" id="login">
                                    <option value="alllogin">- All -</option>
                                    <%for(int i=0; i<list_user.size(); i++){
                                        User user = (User)list_user.get(i);
                                        if (p_login.equals(String.valueOf(user.getId()))) {
                                    %>
                                        <option value="<%=user.getId()%>" selected><%=user.getUser()%></option>
                                    <%} else {%>
                                    <option value="<%=user.getId()%>"><%=user.getUser()%></option>
                                    <%}}%>
                                </select>
                                </TD>
                                <TD class="shedule">
                                    <select name="shedule" id="shedule">
                                    <option value="allshedule">- All -</option>
                                    <option value="1" <%if (p_shedule.equals("1")) {%> selected <%}%>>Mon</option>
                                    <option value="2" <%if (p_shedule.equals("2")) {%> selected <%}%>>Tue</option>
                                    <option value="3" <%if (p_shedule.equals("3")) {%> selected <%}%>>Wnd</option>
                                    <option value="4" <%if (p_shedule.equals("4")) {%> selected <%}%>>Thu</option>
                                    <option value="5" <%if (p_shedule.equals("5")) {%> selected <%}%>>Fri</option>
                                    <option value="6" <%if (p_shedule.equals("6")) {%> selected <%}%>>Sat</option>
                                    <option value="7" <%if (p_shedule.equals("7")) {%> selected <%}%>>Sun</option>
                                </select>
                                </TD>
                                <TD class="email-employee">
                                        <input type="text" id="email" name="email" value="<%=p_email%>"/>
                                </TD>
                                <td class="submit" align="center">
                                    <input class="button_small" type="submit" value="Search" />
                                </td>
                            </TR>
                        <%for(int i=0; i<list.size(); i++){
                            Employee emp = (Employee)list.get(i);
                            boolean b = true;
                            char[] arrCh = emp.getSchedule().toCharArray();
                            String strSh = "";
                            //MTWTFSS
                            if(arrCh.length == 7)
                            {
                                if(arrCh[0] == '1')
                                    strSh = strSh + "M";
                                if(arrCh[1] == '1')
                                    strSh = strSh + "T";
                                if(arrCh[2] == '1')
                                    strSh = strSh + "W";
                                if(arrCh[3] == '1')
                                    strSh = strSh + "T";
                                if(arrCh[4] == '1')
                                    strSh = strSh + "F";
                                if(arrCh[5] == '1')
                                    strSh = strSh + "S";
                                if(arrCh[6] == '1')
                                    strSh = strSh + "S";
                            }
                            if (b) {
                        %>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <TD>
                                <%=emp.getFname()%>
                            </TD>
                            <TD>
                                <%=emp.getLname()%>
                            </TD>
                            <TD>
                                <%=users.get(String.valueOf(emp.getLogin_id()))%>
                            </TD>
                            <TD nowrap>
                                <%=strSh%>
                            </TD>                            <TD>
                                <%=emp.getEmail()!=null?emp.getEmail():"&nbsp;"%>
                            </TD>
                            <TD nowrap>
                                <a href="./edit_emptime.jsp?employee_id=<%=emp.getId()%>"> <IMG height="16" alt="Add Employee Breaktime" title="Add Employee Breaktime" src="../images/break_add.png" width="16" longDesc="../images/break_add.png" ></a>
                                <a href="./time_employee.jsp?action=time&id=<%=emp.getId()%>"> <IMG height="16" alt="Manage Employee Breaktime" title="Manage Employee Breaktime" src="../images/break.png" width="16" longDesc="../images/break.png"></a>
                                <a href="./edit_empserv.jsp?employee_id=<%=emp.getId()%>"> <IMG height="16" alt="Edit Employee Specific Service" title="Edit Employee Specific Service" src="../images/services.png" width="16" longDesc="../images/services.png" ></a>
                                <a href="./edit_employee.jsp?action=edit&id=<%=emp.getId()%>"> <IMG height="16" alt="Edit" title="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png" ></a>
                                <a href="#" onclick="if (confirm('Are you sure to delete?')) window.location.href='./list_employee.jsp?action=delete&id=<%=emp.getId()%>&<%=ActionUtil.PAGE%>=<%=pg_num%>'"> <IMG height="16" alt="Delete" title="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png" ></a>
                            </TD>
                        </TR><%}}%>
                        </table>
                        <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                        <div class="pagelinks">
                            <%--<span class="disabled">« Previous</span> <!-- disabled 'previous' link -->--%>
                            <%--<span>1</span>  <!-- current page -->--%>
                            <%--<a href="#">2</a> <!-- nth page -->--%>
                            <input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />
                            <a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num - 1%>';document.list_form.submit()">« Previous</a>  <!-- active 'next' link -->
                            <a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num + 1%>';document.list_form.submit()">Next »</a>  <!-- active 'next' link -->
                        </div>
                        <%--<table>--%>
                        <%--<tr><td>--%>
                            <%--<a href="./list_appointment.jsp?<%=ActionUtil.PAGE%>=<%=pg_num + 1%>">Next &gt;&gt;</a>--%>
                                <%--<input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />--%>
                                <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num - 1%>';document.list_form.submit()">&lt;&lt; Prev</a>--%>
                                <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num + 1%>';document.list_form.submit()">Next &gt;&gt;</a>--%>
                        <%--</td></tr>--%>
                        <%--</table>--%>
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