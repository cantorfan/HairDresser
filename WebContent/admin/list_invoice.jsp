<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.*" %>
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
    String p_date = StringUtils.defaultString(request.getParameter("startdate"), "");
    String p_employee = StringUtils.defaultString(request.getParameter("employee"), "allemployees");
    String p_interval = StringUtils.defaultString(request.getParameter("interval"), "1");
    String id_employee = "";
    id_employee = p_employee.equals("allemployees")? "0" :  p_employee;

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
    ArrayList list = new ArrayList();
    int count = 0;
    if(!p_date.equals("") && !id_employee.equals(""))
    {
        list = InvoiceReport.findToEmployAndDate(p_date, Integer.parseInt(id_employee), Integer.parseInt(p_interval), offset, ActionUtil.PAGE_ITEMS);
        count = list.size();
    }

    HashMap employees = Employee.findAllMap();
    double Sub_total = 0.0;
    double Salex_tax = 0.0;
    for(int i=0; i<list.size(); i++)
    {
        InvoiceReport invRep = (InvoiceReport)list.get(i);
        Sub_total += invRep.getTotalPrice().doubleValue();
        Salex_tax += invRep.getTaxe().doubleValue();
    }
    double Net_total = Salex_tax + Sub_total;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Gross sales</title>
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
    <form action="./list_invoice.jsp" method="post" name="list_form" id="list_form">
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
                    <div class="heading" style="height: 70px;">
                        <table width="1000" border="0" cellpadding="0" cellspacing="0">
                           <TR class="top_filter">
                               <td>
                                    <h1>Gross sales <a>(<%=count%> records)</a></h1>
                                </td>
                                <td>
                                   <table border="0" cellpadding="0" cellspacing="0" align="right">
                                     <tr>
                                        <td align="Center">
                                            Date
                                        </td>
                                        <td align="Center">
                                            Interval
                                        </td>
                                        <td align="Center">
                                            Employee
                                        </td>
                                        <td></td>
                                    </tr>
                                        <TR>
                                            <TD class="category" align="center">
                                                <table cellspacing="0" cellpadding="0"><tr>
                                                <td style="margin:0; padding: 0"><input readonly type="text" id="startdate" name="startdate" value="<%=p_date%>" style="width: 60px" /></td>
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
                                            <td>
                                                <select id="interval" name="interval" style="width: 100%">
                                                    <option value="1" <%if(p_interval.equals("1")){%>selected<%}%>>1 day</option>
                                                    <option value="3" <%if(p_interval.equals("3")){%>selected<%}%>>3 days</option>
                                                    <option value="7" <%if(p_interval.equals("7")){%>selected<%}%>>1 week</option>
                                                    <option value="30" <%if(p_interval.equals("30")){%>selected<%}%>>1 month</option>
                                               </select>
                                            </td>
                                            <td>
                                                <select id="employee" name="employee" style="width: 100%">
                                                    <option value="allemployees">- All -</option>
                                                    <%
                                                        Object[] c = employees.keySet().toArray();
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
                                            </td>
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
                        <th class="name" style="text-align:center;" title="Employee">Employee</th>
                        <th class="vendor" style="text-align:center;" title="Code transaction">Code transaction</th>
                        <th class="vendor" style="text-align:center;" title="Service/Product">Service/Product</th>
                        <th class="money" style="text-align:center;" title="Quantity">Quantity</th>
                        <th class="money" style="text-align:center;" title="Discount">Discount</th>
                        <th class="money" style="text-align:center;" title="Taxe">Tax</th>
                        <th class="category" style="text-align:center;" title="Price">Total</th>
                    </tr>
                    <%for(int i=0; i<list.size(); i++){
                        InvoiceReport invRep = (InvoiceReport)list.get(i);%>
                    <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                        <TD>
                            <%=invRep.getFlNameEmp()%>
                        </TD>
                        <TD>
                            <%=invRep.getCode_transaction()%>
                        </TD>
                        <TD>
                            <%=invRep.getName()%>
                        </TD>
                        <TD>
                            <%=invRep.getQty()%>
                        </TD>
                        <TD>
                            <%=invRep.getDiscount()%>
                        </TD>
                        <TD>
                            <%=invRep.getTaxe()%>
                        </TD>
                        <TD>
                            <%=invRep.getTotalPrice()%>
                        </TD>
                    </TR><%}%>
                     <tr>
                        <td colspan="7" align="right">
                             <table align="right">
                                <tr >
                                    <td>
                                        Sub total
                                    </td>
                                    <td>
                                       <%= Sub_total%>
                                    </td>
                                </tr>
                                 <tr>
                                    <td>
                                        Salex tax
                                    </td>
                                    <td>
                                        <%= Salex_tax%>
                                    </td>
                                </tr>
                                <tr >
                                    <td>
                                        Net total
                                    </td>
                                    <td>
                                        <%= Net_total%>
                                    </td>
                                </tr>
                             </table>
                        </td>
                    </tr>
                    </table>
                     <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                     <table>
                     <tr><td><a href="./list_invoice.jsp?<%=ActionUtil.PAGE%>=<%=pg_num + 1%>">Next &gt;&gt;</a></td></tr>
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