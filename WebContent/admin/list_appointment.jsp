<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.math.BigDecimal" %>
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
    String id = StringUtils.defaultString(request.getParameter(Appointment.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        Appointment.deleteAppointment(Integer.parseInt(id));
    }

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
    String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");
    String p_category = StringUtils.defaultString(request.getParameter("category"), "allcategories");
    String p_service = StringUtils.defaultString(request.getParameter("service"), "allservices");
    String p_employee = StringUtils.defaultString(request.getParameter("employee"), "allemployees");

    int pg_num = 0;
    int offset = 0;
    if (StringUtils.isNumeric(pg)) {
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }

    String date_stmt = "";
    boolean bFlag = false;
    if(!p_start_date.equals("") && !p_end_date.equals(""))
    {
        date_stmt = "(DATE(appt_date) BETWEEN DATE('" + p_start_date + "') AND DATE('" + p_end_date + "')) ";
        bFlag = true;
    }
    else
    {
        if(!p_start_date.equals("") && p_end_date.equals(""))
        {
            date_stmt = "(DATE(appt_date) >= DATE('" + p_start_date + "')) ";
            bFlag = true;
        }
        else
        {
            if(p_start_date.equals("") && !p_end_date.equals(""))
            {
                date_stmt = "(DATE(appt_date) <= DATE('" + p_end_date + "')) ";
                bFlag = true;
            }
        }
    }
    String emp_stmt = "";
    if(!p_employee.equals("allemployees"))
    {
        emp_stmt = (bFlag?" AND ":"") + (Appointment.EMP + " = '" + p_employee + "' ");
        bFlag = true;
    }

    String serv_stmt = "";
    if(!p_service.equals("allservices"))
    {
        serv_stmt = (bFlag?" AND ":"") + (Appointment.SVC + " = '" + p_service + "' ");
        bFlag = true;
    }

    String cat_stmt = "";
    if(!p_category.equals("allcategories"))
    {
        cat_stmt = (bFlag?" AND ":"") + (Appointment.CATE + " = '" +  p_category + "' ");
    }

    String filter =
            date_stmt +
            emp_stmt +
            serv_stmt +
            cat_stmt;
    if(!filter.equals(""))
        filter = " where " + filter;
    ArrayList list = Appointment.findByFilter(filter+ " order by " + Appointment.APPDT + " desc LIMIT " + offset + "," + ActionUtil.PAGE_ITEMS );
    int count = Appointment.countByFilter(filter);

    HashMap customers = Customer.findAllMap();
    HashMap employees = Employee.findAllMap();
    HashMap services = Service.findAllMap();
    HashMap locations = Location.findAllMap();
    HashMap categories = Category.findAllMap();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage Appointments</title>
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

    function ExportToExel()
    {
        var startdate = document.getElementById('startdate').value;
        var enddate = document.getElementById('enddate').value;
        var category = document.getElementById('category').value;
        var service = document.getElementById('service').value;
        var employee = document.getElementById('employee').value;
        window.location.href="../exporttoexcel?action=exporttoexcelappointment"+
                                "&startdate="+startdate+
                                "&enddate="+enddate+
                                 "&category="+category+
                                 "&service="+service+
                                 "&employee="+employee;
    }

    function Print_Report(p_start_date,p_end_date,p_category,p_service,p_employee,count)
    {
        document.location.href='../report?query=appointment_print&startdate='+p_start_date+'&enddate='+p_end_date+'&category='+p_category+'&service='+p_service+'&employee='+p_employee+'&report_count='+count;
    }
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_appointment.jsp" method="post" name="list_form" id="list_form">
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
				<td colspan="2">
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                    <div class="padder">
                        <!-- main content begins here -->
                    <div class="heading" style="height: 70px;">
                        <table width="1000" border="0" cellpadding="0" cellspacing="0">
                           <TR class="top_filter">
                               <td style="width: 30%;">
                                    <h1>Manage Appointments <a>(<%=count%> records)</a></h1>
                                </td>
                                <td>
                                <table border="0" cellpadding="0" cellspacing="0">
                                     <tr>
                                        <td align="Center">
                                            Start date
                                        </td>
                                        <td align="Center">
                                            End date
                                        </td>
                                        <td align="Center">
                                            Employee
                                        </td>
                                        <td align="Center">
                                            Service
                                        </td>
                                        <td align="Center">
                                            Category Name
                                        </td>
                                        <td></td>
                                    </tr>
                                    <TR>
                                       <TD class="category" align="center">
                                            <table cellspacing="0" cellpadding="0"><tr>
                                            <td style="margin:0; padding: 0"><input  readonly type="text" id="startdate" name="startdate" value="<%=p_start_date%>" style="width: 60px" /></td>
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
                                        <TD class="category" align="center">
                                            <table cellspacing="0" cellpadding="0"><tr>
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
                                        <TD class="halfname">
                                                <select id="employee" name="employee" style="width: 100%">
                                                    <option value="allemployees">- All -</option>
                                                    <%
                                                        Object[] c;
                                                        c = employees.keySet().toArray();
                                                        for(int i = 0; i < c.length; i++){
                                                            String s = (String)employees.get(c[i]);
                                                            String sel = "";
                                                            if (p_employee.equals((String)c[i])) {
                                                                sel = " selected";
                                                            }
                                                        %>
                                                        <option value="<%=(String)c[i]%>" <%=sel%>><%=s%></option>
                                                    <%}%>
                                               </select>
                                        </TD>
                                        <TD class="service">
                                            <select id="service" name="service" style="width: 100%">
                                                <option value="allservices">- All -</option>
                                                <%
                                                    c = services.keySet().toArray();
                                                    for(int i = 0; i < c.length; i++){
                                                        String s = (String)services.get(c[i]);
                                                        String sel = "";
                                                        if (p_service.equals((String)c[i])) {
                                                            sel = " selected";
                                                        }
                                                    %>
                                                    <option value="<%=(String)c[i]%>" <%=sel%>><%=s%></option>
                                                <%}%>
                                           </select>
                                        </TD>
                                        <TD class="service">
                                                <select id="category" name="category" style="width: 100%">
                                                    <option value="allcategories">- All -</option>
                                                    <%
                                                        c = categories.keySet().toArray();
                                                        for(int i = 0; i < c.length; i++){
                                                            String s = (String)categories.get(c[i]);
                                                            String sel = "";
                                                            if (p_category.equals((String)c[i])) {
                                                                sel = " selected";
                                                            }
                                                        %>
                                                        <option value="<%=(String)c[i]%>" <%=sel%>><%=s%></option>
                                                    <%}%>
                                               </select>
                                        </TD>
                                        <td class="submit">
                                            <input class="button_small" type="submit" value="Search" onclick="document.getElementById('page').value='0'; document.list_form.submit()"/>
                                        </td>
                                    </TR>
                                </table>
                                </td>
                                </tr>
                                </table>
                        </div>
                        <table class="data">
                        <tr>
                            <th class="halfname" style="text-align:center;" title="Customer">Customer</th>
                            <th class="halfname" style="text-align:center;" title="Employee">Employee</th>
                            <th class="service" style="text-align:center;" title="Service">Service</th>
                            <th class="money" style="text-align:center;" title="Price">Price</th>
                            <th class="category" style="text-align:center;" title="Category Name">Category Name</th>
                            <th style="width:100px;">
                                <table  border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                        <td>
                                            <table  border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <a href="#"><IMG onclick="ExportToExel();" height="32" alt="Export to Excel" title="Export to Excel" src="../img/exporttoexcel.png" width="32" longDesc="../img/exporttoexcel.png"></a>
                                                    </td>
                                                    <td style="padding-top: 12px;">
                                                        Export
                                                    </td>
                                                </tr>
                                            </table>
                                            </td>
                                            <td>
                                            <table border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <a href="#"><IMG onclick="Print_Report('<%=p_start_date%>','<%=p_end_date%>','<%=p_category%>','<%=p_service%>','<%=p_employee%>','<%=count%>');" height="32" alt="Print" title="Print" src="../img/exporttoexcel.png" width="32" longDesc="../img/exporttoexcel.png"></a>
                                                    </td>
                                                    <td style="padding-top: 12px;">
                                                       Print
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </th>
                        </tr>
                        <%for(int i=0; i<list.size(); i++){
                            Appointment appt = (Appointment)list.get(i);
                            Ticket tic = Ticket.findTicketPriceById(appt.getTicket_id());%>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <TD>
                                <%=customers.get(String.valueOf(appt.getCustomer_id()))!=null?customers.get(String.valueOf(appt.getCustomer_id())):""%>
                            </TD>
                            <TD>
                                <%=employees.get(String.valueOf(appt.getEmployee_id()))!=null?employees.get(String.valueOf(appt.getEmployee_id())):""%>
                            </TD>
                            <TD>
                                <%=services.get(String.valueOf(appt.getService_id()))!=null?services.get(String.valueOf(appt.getService_id())):""%>
                            </TD>
                            <TD>
                                <%=tic!=null?tic.getPrice().setScale(2,BigDecimal.ROUND_HALF_DOWN):new BigDecimal(0).setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=categories.get(String.valueOf(appt.getCategory_id()))!=null?categories.get(String.valueOf(appt.getCategory_id())):""%>
                            </TD>
                            <TD>
                                <IMG  title="Edit" onclick="window.location.href='./edit_appointment.jsp?action=edit&id=<%=appt.getId()%>'" height="16" alt="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png">
                                <IMG title="Delete" height="16" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png" onclick="if (confirm('Are you sure to delete?')) window.location.href='./list_appointment.jsp?action=delete&id=<%=appt.getId()%>&<%=ActionUtil.PAGE%>=<%=pg_num%>'">
                            </TD>
                        </TR><%}%>
                        </table>
                        <input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />
                        <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                        <div class="pagelinks">
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