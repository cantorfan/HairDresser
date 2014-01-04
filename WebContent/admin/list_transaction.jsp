<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
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
    String id = StringUtils.defaultString(request.getParameter(CashDrawing.ID), ActionUtil.EMPTY);
    String p_date_year = StringUtils.defaultString(request.getParameter("date_year"), "");
    String p_date_month = StringUtils.defaultString(request.getParameter("date_month"), "");
    String p_date_day = StringUtils.defaultString(request.getParameter("date_day"), "");
    HashMap employees = Employee.findAllMap();
    HashMap customers = Customer.findAllMap();
    HashMap services = Service.findAllMap();
    HashMap products = Inventory.findAllMap();

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }

    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");
    String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
    String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");

    ArrayList list_trans = new ArrayList();
    String date_stmt = "";
    if(!p_start_date.equals("") && !p_end_date.equals(""))
    {
        date_stmt = "(DATE("+Reconciliation.CDT+") BETWEEN DATE('" + p_start_date + "') AND DATE('" + p_end_date + "')) ";
    }
    else
    {
        if(!p_start_date.equals("") && p_end_date.equals(""))
        {
            date_stmt = "(DATE("+Reconciliation.CDT+") >= DATE('" + p_start_date + "')) ";
        }
        else
        {
            if(p_start_date.equals("") && !p_end_date.equals(""))
            {
                date_stmt = "(DATE("+Reconciliation.CDT+") <= DATE('" + p_end_date + "')) ";
            }
        }
    }

    String filter = date_stmt;
    String order = " order by "+Reconciliation.CDT+" desc";
    String limit = " LIMIT " + offset + "," + ActionUtil.PAGE_ITEMS;
    if (!filter.equals(""))
        filter = " where " + filter;
    list_trans = Reconciliation.findByFilter(filter + order + limit);

    int count = 0;
    for (int m=0; m<list_trans.size(); m++){
        Reconciliation tran_tmp = (Reconciliation) list_trans.get(m);
        if ((tran_tmp.getStatus() == 3) || (tran_tmp.getStatus() == 5))
        {
            count ++;
        }
        else
        {
            ArrayList list_ticket = Ticket.findTicketByLocCodeTrans(tran_tmp.getId_location(), tran_tmp.getCode_transaction());
            count = count + list_ticket.size();
        }
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>View day</title>
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
        window.location.href="../exporttoexcel?action=exporttoexceltransaction"+
                                "&startdate="+startdate+
                                "&enddate="+enddate;
    }

    function Print_Report(p_start_date,p_end_date)
    {
        document.location.href='../report?query=transaction_print&startdate='+p_start_date+'&enddate='+p_end_date;
    }
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_transaction.jsp" method="post" name="list_form" id="list_form">

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
                        <div class="heading">
                            <table width="1000" height="32" border="0" cellpadding="0" cellspacing="0">
                           <TR class="top_filter">
                               <td style="width: 70%;">
                                    <h1>View Transaction <a>(<%=count%> records)</a></h1>
                               </td>
                                <TD nowrap align="right">
                                <table cellspacing="0" cellpadding="0"><tr>
                                <td>
                                    Start&nbsp;date:
                                </td>
                                <td style="margin:0; padding: 0">
                                    <input readonly type="text" id="startdate" name="startdate" value="<%=p_start_date%>" style="width: 60px; vertical-align:top;" />
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
                                <TD nowrap align="right">
                                <table cellspacing="0" cellpadding="0"><tr>
                                <td>
                                    End&nbsp;date:
                                </td>
                                <td style="margin:0; padding: 0">
                                    <input readonly type="text" id="enddate" name="enddate" value="<%=p_end_date%>" style="width: 60px; vertical-align:top;" />
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
                                <td class="submit">
                                    <input class="button_small" type="submit" value="Search" onclick="document.getElementById('<%=ActionUtil.PAGE%>').value='0'; document.list_form.submit();" />
                                </td>
                                <td class="submit">
                                    <input class="button_small" type="button" value="Excel" onclick="ExportToExel();" />
                                </td>
                                <td class="submit">
                                    <input class="button_small" type="button" value="Print" onclick="Print_Report('<%=p_start_date%>','<%=p_end_date%>');" />
                                </td>
                            </TR>
                            </table>
                        </div>
                        <table class="data">
                        <tr class="filter">
                            <th class="date" style="text-align:center;" title="Date">Date</th>
                            <th class="sku" style="text-align:center;" title="Trans #">Trans #</th>
                            <th class="name" style="text-align:center;" title="Customer">Customer</th>
                            <th class="name" style="text-align:center;" title="Employee">Employee</th>
                            <th class="service" style="text-align:center;" title="Service">Service</th>
                            <th class="service" style="text-align:center;" title="Product">Product</th>
                            <th class="quantity" style="text-align:center;" title="QTY">QTY</th>
                            <th class="quantity" style="text-align:center;" title="Discount">Discount</th>
                            <th class="money" style="text-align:center;" title="Price">Price</th>
                            <th class="sku" style="text-align:center;" title="Payment">Payment</th>
                        </tr>
                        <%
                        for(int i=0; i<list_trans.size(); i++){
                            Reconciliation tran = (Reconciliation) list_trans.get(i);
                            String bc = "";
                            String status = "";
                            String date = "";
                            date = tran.getCreated_dt().toString();
                            switch (tran.getStatus())
                            {
                                case 0: bc = "#c1c2c4"; break; //closed transaction
                                case 2: bc = "#9ccf78"; break; //pending (saved) transaction
                                case 3: bc = "#16c1f3"; status = "PAYOUT"; break; //payout transaction
                                case 4: bc = "#812990"; break; //refunder transaction
                                case 5: bc = "#16c1f3"; status = "PAYIN"; break; //payin transaction
                                case 6: bc = "#f172ac"; break; //canceled transaction
                            }



                        if ((tran.getStatus() == 3) || (tran.getStatus() == 5)){
                        Cashio cio = Cashio.findByReconciliationId(tran.getId());
                        %>
                        <TR >
                            <TD style="background-color:<%=bc%>">
                                <%=date%>
                            </TD>
                            <TD style="background-color:<%=bc%>">
                                <%=tran.getCode_transaction()%>
                            </TD>
                            <TD style="background-color:<%=bc%>">
                                <%=cio!=null?status+" "+cio.getVendor():status%>
                            </TD>
                            <TD style="background-color:<%=bc%>">

                            </TD>
                            <TD style="background-color:<%=bc%>">

                            </TD>
                            <TD style="background-color:<%=bc%>">

                            </TD>
                            <TD style="background-color:<%=bc%>">

                            </TD>
                            <TD style="background-color:<%=bc%>">

                            </TD>
                            <TD style="background-color:<%=bc%>">
                                <%=tran.getTotal().setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD style="background-color:<%=bc%>">
                                <%=tran.getPayment()%>
                            </TD>
                        </TR><%} else {
                            java.math.BigDecimal total, price, taxe;
                            int qty;
                            ArrayList list_ticket = org.xu.swan.bean.Ticket.findTicketByLocCodeTrans(tran.getId_location(), tran.getCode_transaction());
                            for (int j = 0; j < list_ticket.size(); j++) {
                                Ticket ticket = (Ticket)list_ticket.get(j);
                                price = ticket.getPrice();
                                qty = ticket.getQty();
                                taxe = ticket.getTaxe().multiply(new BigDecimal(qty));
                                total = price.multiply(new BigDecimal(qty)).multiply(new BigDecimal(1.0-ticket.getDiscount()/100.0f)).add(taxe);
                            %>
                            <TR >
                                <TD style="background-color:<%=bc%>">
                                    <%=date%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=ticket.getCode_transaction()%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=(customers.get(String.valueOf(tran.getId_customer()))!=null)?customers.get(String.valueOf(tran.getId_customer())):""%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=(employees.get(String.valueOf(ticket.getEmployee_id()))!=null)?employees.get(String.valueOf(ticket.getEmployee_id())):""%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=(services.get(String.valueOf(ticket.getService_id()))!=null)?services.get(String.valueOf(ticket.getService_id())):""%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=(products.get(String.valueOf(ticket.getProduct_id()))!=null)?products.get(String.valueOf(ticket.getProduct_id())):""%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=ticket.getQty()%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=ticket.getDiscount() + "%"%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                                </TD>
                                <TD style="background-color:<%=bc%>">
                                    <%=tran.getPayment()%>
                                </TD>
                            </TR>
                            <%}
                        }}%>
                        </table>
                        <%if(list_trans.size() >= ActionUtil.PAGE_ITEMS){%>
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