<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Calendar" %>
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
    String id = StringUtils.defaultString(request.getParameter(Giftcard.ID), ActionUtil.EMPTY);
    String code = StringUtils.defaultString(request.getParameter("code"), "");
    String p_date = StringUtils.defaultString(request.getParameter("date"), "");
    String amount = StringUtils.defaultString(request.getParameter("amount"), "");
    String startamount = StringUtils.defaultString(request.getParameter("startamount"), "");
//    String p_date_month = StringUtils.defaultString(request.getParameter("date_month"), "");
//    String p_date_day = StringUtils.defaultString(request.getParameter("date_day"), "");
//    String created = StringUtils.defaultString(request.getParameter("created"), "");
//    String payment = StringUtils.defaultString(request.getParameter("payment"), "");

//    String p_date = "";
//    String p_date2 = "";
//    if (!p_date_year.equals("") && !p_date_month.equals("") && !p_date_day.equals(""))
//    {
//        p_date = p_date_year+"-"+p_date_month+"-"+p_date_day+" 00:00:00";
//        p_date2 = p_date_year+"-"+p_date_month+"-"+p_date_day+" 23:59:59";
//    }
    HashMap customers = Customer.findAllMap();
    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
    ArrayList list ;
    int count = 0;
    if (code.equals("") && p_date.equals("") && amount.equals("") && startamount.equals(""))
    {
        list = Giftcard.findAll(offset,ActionUtil.PAGE_ITEMS);
        count = Giftcard.countAll();
    }
    else
    {
        String filter = "";
        boolean flag = false;
        if(!code.equals(""))
        {
            filter = filter + Giftcard.CODE + " LIKE '%" + code + "%' " ;
            flag = true;
        }
        if(!p_date.equals(""))
        {
            if(flag)
            {
                filter = filter + " and ";
            }
            filter = filter + "DATE(created)= DATE('" + p_date + "') " ;
            flag = true;
        }
        if(!amount.equals(""))
        {
            if(flag)
            {
                filter = filter + " and ";
            }
            filter = filter + Giftcard.AMOUNT + " = " + amount + " " ;
            flag = true;
        }
        if(!startamount.equals(""))
        {
            if(flag)
            {
                filter = filter + " and ";
            }
            filter = filter + Giftcard.STARTAMOUNT + " = " + startamount ;
        }
            list = Giftcard.findByFilter(filter + " LIMIT " + offset + "," + ActionUtil.PAGE_ITEMS);
            count = Giftcard.countByFilter(filter);
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>View Giftcard</title>
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
        var date = document.getElementById('date').value;
        var code = document.getElementById('code').value;
        var amount = document.getElementById('amount').value;
        var startamount = document.getElementById('startamount').value;
        window.location.href="../exporttoexcel?action=exporttoexcelgiftcard"+
                                "&date="+date+
                                "&code="+code+
                                "&amount="+amount+
                                "&startamount="+startamount;
    }
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_giftcard.jsp" method="post" name="list_form" id="list_form">

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
				<td style="vertical-align: top;">
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                    <div class="padder">
                        <!-- main content begins here -->
                        <div class="heading">
                            <h1>View Giftcard <a>(<%=count%> records)</a></h1>
                        </div>
                        <table class="data">
                        <tr class="data">
                            <th class="giftcard" style="text-align:center;" title="Customer">Customer</th>
                            <th class="giftcard_code" style="text-align:center;" title="Code">Code</th>
                            <th class="giftcard" style="text-align:center;" title="Created">Created</th>
                            <th class="giftcard" style="text-align:center;" title="Amount">Amount</th>
                            <th class="giftcard" style="text-align:center;" title="Amount Remaining">Amount Remaining</th>
                            <th style="width:80px;">
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
                            </th>
                        </tr>
                            <TR class="filter">
                                <TD class="giftcard">
                                    <input disabled type="text" id="customer" name="customer" value=""/>
                                </TD>
                                <TD class="phone">
                                    <input type="text" id="code" name="code" value="<%=code%>"/>
                                </TD>
                                <TD style="width: 160px;" align="center">
                                    <table cellspacing="0" cellpadding="0"><tr>
                                    <td style="margin:0; padding: 0">
                                        <input readonly style="vertical-align:top; width: 150px;" type="text" id="date" name="date" value="<%=p_date%>"/>
                                    </td>
                                    <td style="margin:0; padding: 0"><input type="button" id="selDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                    </tr></table>
                                    <SCRIPT type="text/javascript">
                                                Calendar.setup(
                                                {
                                                inputField  : "date",     // ID of the input field
                                                button      : "selDate",  // ID of the button
                                                showsTime	: false,
                                                electric    : false
                                                }
                                                );
                                    </SCRIPT>
                                </TD>
                                <TD class="giftcard">
                                    <input type="text" id="startamount" name="startamount" value="<%=startamount%>"/>
                                </TD>
                                <TD class="giftcard">
                                    <input type="text" id="amount" name="amount" value="<%=amount%>"/>
                                </TD>
                                <td class="submit">
                                    <input class="button_small" type="submit" value="Search" onclick="document.getElementById('<%=ActionUtil.PAGE%>').value='0'; document.list_form.submit();" />
                                </td>
                            </TR>
                        <%
                        BigDecimal remainAmntTotal = new BigDecimal(0);
                        for(int i=0; i<list.size(); i++){
                            Giftcard card = (Giftcard)list.get(i);
                            remainAmntTotal = remainAmntTotal.add(card.getAmount());
                            boolean b = true;
                            if (b) {

                        %>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <TD>
                                <%=(customers.get(String.valueOf(card.getId_customer()))!=null)?customers.get(String.valueOf(card.getId_customer())):""%>   
                            </TD>
                            <TD>
                                <%=card.getCode()%>
                            </TD>
                            <TD>
                                <%=card.getCreated()%>
                            </TD>
                            <TD>
                                <%="$ " + card.getStartamount().setScale(2, BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%="$ " + card.getAmount().setScale(2, BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD nowrap>
                                <a href="./list_trans_gift.jsp?&id=<%=card.getCode()%>"><IMG title="History" height="16" alt="history" src="../images/history.png" width="16" longDesc="../images/history.png"></a>
                            </TD>

                        </TR><%}}%>
                        <tr>
                            <TD> &nbsp; </TD><TD> &nbsp; </TD><TD> &nbsp; </TD><TD style = "background-color: #cccccc"> Amount Remaining total: <%="$ " + remainAmntTotal.setScale(2, BigDecimal.ROUND_HALF_DOWN)%></TD><TD> &nbsp; </TD>
                        </tr>
                        <%--<tr>--%>
                            <%--<TD> &nbsp; </TD><TD> &nbsp; </TD><TD> &nbsp; </TD><TD style="text-align:right;"> Commission total:  </TD><TD> &nbsp; </TD>--%>
                        <%--</tr>--%>
                        <%--<tr>--%>
                            <%--<TD> &nbsp; </TD><TD> &nbsp; </TD><TD> &nbsp; </TD><TD> &nbsp; </TD><TD> &nbsp; </TD>--%>
                        <%--</tr>--%>
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
