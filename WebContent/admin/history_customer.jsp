<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.math.BigDecimal" %>
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
    Customer cust = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(Customer.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_HIST) && StringUtils.isNotEmpty(id))
        cust = Customer.findById(Integer.parseInt(id));
    else
        cust = (Customer) request.getAttribute("OBJECT");
    ArrayList list = AppointmentHistory.findFullHistoryByCustomerId(cust.getId());

    HashMap employees = Employee.findAllMap();
    HashMap services = Service.findAllMap();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>History Customer</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
		<LINK href="../css/HairDresser.css" type=text/css rel=stylesheet>
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
		<table width="1040" <%--height="432" --%> border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                    <div class="padder">
                        <!-- main content begins here -->
                        <div class="heading">
                            <div class="floatLeft submitBTN"><input name="back" type="button" class="button_small" value="back" onclick="window.history.back();"></div> <div style="margin-left: 10px;" class="floatLeft"><h1>Customer history for <%=cust.getFname() + " " + cust.getLname() + ", Phone: " + cust.getPhone()%></h1>  </div> <div class="clear"></div>
                        </div>
                        <table class="data">
                        <tr>
                            <th class="date centerText" title="Date">Date</th>
                            <th class="name centerText" title="Employee">Employee</th>
                            <th class="service centerText" title="Service provided">Service</th>
                            <th class="product centerText" title="Product provided">Product</th>
                            <th class="money centerText" title="Price">Price</th>
                            <th class="time centerText" title="Starting time">Time</th>
                            <%--<th class="time" title="Ending time">End</th>--%>
                            <th class="comment centerText" title="Comment">Comment</th>
                            <th class="comment centerText" title="Cust Comment">Cust Comment</th>
                            <th class="date centerText" title="State">State</th>
                            <th class="date centerText" title="State">Action</th>

                        </tr>
                        <%for(int i=0; i<list.size(); i++){
                            AppointmentHistory appt = (AppointmentHistory)list.get(i);
                            String bg = "";
                            String state = "";
                            Ticket t = Ticket.findTicketById(appt.getTicket_id());
                            String ct = "0";
                            int st = 0;
                            int idt = 0;
                            if (t!=null)
                                ct = t.getCode_transaction();
                            ArrayList a = Reconciliation.findTransByCode(ct);
                            if(a != null && a.size() > 0){
                                Reconciliation r = (Reconciliation)a.get(0);
                                if(r != null){
                                    st = r.getStatus();
                                    idt = r.getId();
                                }
                            }
                            switch (appt.getState())
                            {
                                case 0: state = "Paid"; bg = "#c1c2c4"; break; //closed transaction
                                case 1: state = "Deleted"; bg = "#F390BC"; break; //deleted transaction
                                case 2: state = "Pending"; bg = "#9ccf78"; break; //pending (saved) transaction
                                case 3: break; //payout transaction
                                case 4: state = "Refunded"; bg = "#812990"; break; //refunded transaction
                                case 5: break; //payin transaction
                                case 6: state = "Canceled"; bg = "#f172ac"; break; //canceled transaction
                                case 7: state = "New App"; bg = "white"; break; //new appointment
                            }
                        %>

                        <TR STYLE="BACKGROUND-COLOR: <%=bg%>">
                            <TD class="s14" borderColor="#999999" nowrap>
                                <DIV align="center"><%=DateUtil.formatYmd(appt.getApp_dt())%></DIV>
                            </TD>
                            <TD class="s14" borderColor="#999999" width="200">
                                <DIV align="center"><%=appt.getEmployee()%></DIV>
                            </TD>
                            <TD class="s14" borderColor="#999999" width="150">
                                <DIV align="center"><%=appt.getService()%></DIV>
                            </TD>
                            <TD class="s14" borderColor="#999999" width="150">
                                <DIV align="center"><%=appt.getProduct()%></DIV>
                            </TD>
                            <TD class="s14" borderColor="#999999" width="100">
                                <DIV align="center"><%=appt.getPrice().setScale(2, BigDecimal.ROUND_HALF_DOWN)%></DIV>
                            </TD>

                            <TD class="s14" borderColor="#999999">
                                <DIV align="center"><%=DateUtil.formatTime(appt.getTime())%></DIV>
                            </TD>
                            <%--<TD class="s14" borderColor="#999999">--%>
                                <%--<DIV align="center"><%=DateUtil.formatTime(appt.getEt_time())%></DIV>--%>
                            <%--</TD>--%>
                            <TD class="s14" borderColor="#999999">
                                <DIV align="center"><%=appt.getComment()%></DIV>
                            </TD>
                            <TD class="s14" borderColor="#999999">
                                <DIV align="center"><%=appt.getCust_comment()%></DIV>
                            </TD>
                            <TD class="s14" borderColor="#999999">
                                <DIV align="center"><%=state%></DIV>
                            </TD>
                            <TD class="s14" borderColor="#999999">
                                <DIV align="center"><%if (appt.getTicket_id() != 0){%><a target="_blank" href="../checkout.jsp?dt=<%=appt.getApp_dt()%>&ct=<%=ct%>&idc=<%=id%>&idt=<%=idt%>&tp=2&st=<%=st%>"><img src="../img/mb_edit_button.png" alt="" border="0"/></a><%}%></DIV>
                            </TD>
                            </TR><%}%>
                        </table>
                    </div>
                </div>
				</td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
	</body>
</html>