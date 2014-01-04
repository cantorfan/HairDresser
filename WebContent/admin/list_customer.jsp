<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
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
    String id = StringUtils.defaultString(request.getParameter(Customer.ID), ActionUtil.EMPTY);
    String p_loc = StringUtils.defaultString(request.getParameter("location"), "alllocation");
    String p_req = StringUtils.defaultString(request.getParameter("req"), "allreq");
    String p_fname = StringUtils.defaultString(request.getParameter("fname"), "");
    String p_lname = StringUtils.defaultString(request.getParameter("lname"), "");
    String p_email = StringUtils.defaultString(request.getParameter("email"), "");
    String p_phone = StringUtils.defaultString(request.getParameter("phone"), "");
    String p_cellphone = StringUtils.defaultString(request.getParameter("cellphone"), "");
    String p_type = StringUtils.defaultString(request.getParameter("type"), "");
    String p_work_phone_ext = StringUtils.defaultString(request.getParameter("work_phone_ext"), "");
    String p_sex = StringUtils.defaultString(request.getParameter("sex"), "");
    String p_address = StringUtils.defaultString(request.getParameter("address"), "");
    String p_city = StringUtils.defaultString(request.getParameter("city"), "");
    String p_state = StringUtils.defaultString(request.getParameter("state"), "");
    String p_zip_code = StringUtils.defaultString(request.getParameter("zip_code"), "");

    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        Appointment.updateChangeStatusDelCust(Integer.parseInt(id));
        Customer.deleteCustomer(Integer.parseInt(id));
    }

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
    ArrayList list ;
    int count = 0;

    if (p_loc.equals("alllocation") && p_req.equals("allreq") && p_fname.equals("") && p_lname.equals("") && p_email.equals("") && p_phone.equals("") && p_cellphone.equals("") && p_work_phone_ext.equals(""))
    {
        list = Customer.findAll(offset,ActionUtil.PAGE_ITEMS);
        count = Customer.countAll();
    }
    else{
        String loc_stmt = p_loc.equals("alllocation") ? "" : (Customer.LOC + " = '" +  p_loc + "' AND ");
        String req_stmt = p_req.equals("allreq") ? "" : (Customer.REQ + "='" + (p_req.equals("chkreq") ? "1" : "0") + "' AND ");

        String filter =
                  loc_stmt +
                  req_stmt +
                  Customer.FNAME + " LIKE '%" + p_fname + "%' AND " +
                  Customer.LNAME + " LIKE '%" + p_lname + "%' AND " +
                  Customer.EMAIL + " LIKE '%" + p_email + "%' AND " +
                  Customer.PHONE + " LIKE '%" + p_phone + "%' AND " +
                  Customer.CELL + " LIKE '%" + p_cellphone + "%' AND " +
                  Customer.WORK_PHONE_EXT  + " LIKE '%" + p_work_phone_ext + "%'";
        list = Customer.findByFilter(filter + " LIMIT " + offset + "," + ActionUtil.PAGE_ITEMS);
        count = Customer.countByFilter(filter);
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage Customers</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
        <LINK href="../css/style.css" type=text/css rel=stylesheet>
        <script language="javascript" type="text/javascript" src="../Js/includes/prototype.js"></script>
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
        var phone = document.getElementById('phone').value;
        var cellphone = document.getElementById('cellphone').value;
        var work_phone_ext = document.getElementById('work_phone_ext').value;
        window.location.href="../exporttoexcel?action=exporttoexcelcustomer&fname="+fname+
                                "&lname="+lname+
                                 "&email="+email+
                                 "&phone="+phone+
                                 "&cellphone="+cellphone+
                                 "&work_phone_ext="+work_phone_ext;
    }

    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_customer.jsp" method="post" name="list_form" id="list_form">
    <%--<input  type="hidden" value="<%=p_loc%>" name="location" />--%>
    <%--<input  type="hidden" value="<%=p_req%>" name="req" />--%>
    <%--<input  type="hidden" value="<%=p_fname%>" name="fname" />--%>
    <%--<input  type="hidden" value="<%=p_lname%>" name="lname" />--%>
    <%--<input  type="hidden" value="<%=p_email%>" name="email" />--%>
    <%--<input  type="hidden" value="<%=p_phone%>" name="phone" />--%>
    <%--<input  type="hidden" value="<%=p_cellphone%>" name="cellphone" />--%>
    <%--<input  type="hidden" value="<%=p_type%>" name="type" />--%>

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
				<td width="100%">
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                    <div class="padder">
                        <!-- main content begins here -->
                        <div class="heading">
                            <h1>Manage Customers <a>(<%=count%> records)</a></h1>
                        </div>
                        <table class="data" width="100%">
                        <tr class="filter">
                            <th class="name-customer" title="Customer's first name">First Name</th>
                            <th class="name-customer" title="Customer's last name">Last Name</th>
                            <th class="email_cust" title="Email address">Email</th>
                            <th class="phone_cust" title="Phone number">Phone</th>
                            <th class="phone_cust" title="Cell phone number">Cell Phone</th>
                            <th class="phone_cust" title="Work phone ext">Work phone ext</th>
                            <th style="width:80px;text-align:center"">
                                <a href="#"><IMG onclick="ExportToExel();" height="32" alt="Export to Excel" title="Export to Excel" src="../img/exporttoexcel.png" width="32" longDesc="../img/exporttoexcel.png"></a> Export
                            </th>
                        </tr>
                            <TR class="filter">
                                <TD class="name-customer">
                                    <input type="text" id="fname" name="fname" value="<%=p_fname%>"/>
                                </TD>
                                <TD class="name-customer">
                                    <input type="text" id="lname" name="lname" value="<%=p_lname%>"/>
                                </TD>
                                <TD class="email_cust">
                                    <input type="text" id="email" name="email" value="<%=p_email%>"/>
                                </TD>
                                <TD class="phone_cust">
                                    <input type="text" id="phone" name="phone" value="<%=p_phone%>"/>
                                </TD>
                                <TD class="phone_cust">
                                    <input type="text" id="cellphone" name="cellphone" value="<%=p_cellphone%>"/>
                                </TD>

                                <TD class="phone_cust">
                                    <input type="text" id="work_phone_ext" name="work_phone_ext" value="<%=p_work_phone_ext%>"/>
                                </TD>
                                <td class="submit">
                                    <input class="button_small" type="submit" value="Search" onclick="document.getElementById('<%=ActionUtil.PAGE%>').value='0'; document.list_form.submit();" />
                                </td>
                            </TR>
                        <%
                        for(int i=0; i<list.size(); i++){
                            Customer cust = (Customer)list.get(i);
                            boolean b = true;
//                            if (!cust.getFname().toLowerCase().contains(p_fname.toLowerCase()) & !p_fname.equals("")) b = false;
//                            if (!cust.getLname().toLowerCase().contains(p_lname.toLowerCase()) & !p_lname.equals("")) b = false;
//                            if (!cust.getEmail().toLowerCase().contains(p_email.toLowerCase()) & !p_email.equals("")) b = false;
//                            if (!cust.getPhone().toLowerCase().contains(p_phone.toLowerCase()) & !p_phone.equals("")) b = false;
//                            if (!cust.getCell_phone().toLowerCase().contains(p_cellphone.toLowerCase()) & !p_cellphone.equals("")) b = false;
//                            if (!cust.getType().toLowerCase().contains(p_type.toLowerCase()) & !p_type.equals("")) b = false;
//                            if (!p_req.equals("allreq")){
//
//                                if(p_req.equals("chkreq"))
//                                    if (!cust.getReq().toString().equals("true")) b = false; else;
//                                else if (cust.getReq().toString().equals("true")) b = false;
//
//                            }
//                            if (!p_loc.equals("alllocation")){
//                                if (cust.getLocation_id() != Integer.parseInt(p_loc))
//                                    b = false;
//                            }
                            if (b) {

                        %>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <TD>
                                <%=cust.getFname()%>
                            </TD>
                            <TD>
                                <%=cust.getLname()%>
                            </TD>
                            <TD>
                                <%=cust.getEmail()%>
                            </TD>
                            <TD>
                                <%=cust.getPhone()%>
                            </TD>
                            <TD>
                                <%=cust.getCell_phone()%>
                            </TD>
                            <TD>
                                <%=cust.getWork_phone_ext()%>
                            </TD>
                            <TD nowrap>
                                <a href="./history_customer.jsp?action=hist&id=<%=cust.getId()%>"><IMG title="History" height="16" alt="history" src="../images/history.png" width="16" longDesc="../images/history.png"></a>
                                <a href="./edit_customer.jsp?action=edit&id=<%=cust.getId()%>"><IMG title="Edit" height="16" alt="edit" src="../images/edit.png" width="16" longDesc="../images/edit.png"></a>
                                <a href="#"><IMG title="Delete" onclick="if (confirm('Are you sure want to delete this?')) window.location.href = './list_customer.jsp?action=delete&id=<%=cust.getId()%>&<%=ActionUtil.PAGE%>=<%=pg_num%>'" height="16" alt="delete" src="../images/delete.png" width="16" longDesc="../images/delete.png"></a>
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
                                <%--<input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />--%>
                                <%--<a href="./list_customer.jsp?<%=ActionUtil.PAGE%>=<%=pg_num + 1%>">Next &gt;&gt;</a>--%>
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