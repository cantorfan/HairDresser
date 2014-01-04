<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.CashDrawing" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="org.xu.swan.bean.Reconciliation" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Role" %>
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
    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.EMPTY);
    String id = StringUtils.defaultString(request.getParameter(CashDrawing.ID), ActionUtil.EMPTY);
    String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
    String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
    String date_stmt = "";
    if(!p_start_date.equals("") && !p_end_date.equals(""))
    {
        date_stmt = "(DATE(date) BETWEEN DATE('" + p_start_date + "') AND DATE('" + p_end_date + "')) ";
    }
    else
    {
        if(!p_start_date.equals("") && p_end_date.equals(""))
        {
            date_stmt = "(DATE(date) >= DATE('" + p_start_date + "')) ";
        }
        else
        {
            if(p_start_date.equals("") && !p_end_date.equals(""))
            {
                date_stmt = "(DATE(date) <= DATE('" + p_end_date + "')) ";
            }
        }
    }

    String filter = date_stmt;
    if(!filter.equals(""))
        filter = " and " + filter;
    ArrayList list = CashDrawing.findbyFilter(" where openClose=2 " + filter + " order by date desc LIMIT " + offset + "," + ActionUtil.PAGE_ITEMS);
    int count = CashDrawing.countByFilter(" where openClose=2 " + filter);
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

    function printReport(date){
        document.location.href='../report?query=closingdetails&varCurDate='+date;
    }
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_closingday.jsp" method="post" name="list_form" id="list_form">

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
                                        <h1>View day <a>(<%=count%> records)</a></h1>
                                   </td>
                                    <TD nowrap align="right">
                                        <table cellspacing="0" cellpadding="0"><tr>
                                        <td>Start&nbsp;date:</td>
                                        <td style="margin:0; padding: 0">
                                            <input readonly type="text" id="startdate" name="startdate" value="<%=p_start_date%>" style="width: 60px" />
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
                                        <td>End&nbsp;date:</td>
                                        <td style="margin:0; padding: 0">
                                        <input readonly type="text" id="enddate" name="enddate" value="<%=p_end_date%>" style="width: 60px;vertical-align: top;" />
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
                                </TR>
                            </table>
                        </div>
                        <table class="data">
                        <tr class="filter">
                            <th class="date" style="text-align:center;width:130px;" title="Date">Date</th>
                            <th class="card" style="text-align:center;" title="Card">Opening Cash</th>
                            <th class="cash" style="text-align:center;" title="Cash">Gross Sales</th>
                            <th class="cheque" style="text-align:center;" title="Cheque">Short or Over</th>
                            <th style="text-align:center;width:50px;" title="Action">Action</th>
                        </tr>
                        <%
                        for(int i=0; i<list.size(); i++)
                        {
                            CashDrawing cd_ = (CashDrawing)list.get(i);
                            String dt = cd_.getDate().toString();
                            CashDrawing cd_open = CashDrawing.findByDateStatus(Integer.parseInt(loc), DateUtil.parseSqlDate(dt) , 0);
                            BigDecimal startingDay = new BigDecimal(0);
                            startingDay = cd_open!=null?startingDay.add(new BigDecimal(cd_open.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(cd_open.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(cd_open.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(cd_open.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(cd_open.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(cd_open.getDollars())).add(new BigDecimal(cd_open.getSingles())).add(new BigDecimal(cd_open.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(cd_open.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(cd_open.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(cd_open.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(cd_open.getHundreds()).multiply(new BigDecimal(100))):BigDecimal.ZERO;
                            ArrayList list_trans = Reconciliation.findTransByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
                            BigDecimal total_total = new BigDecimal(0.0);
                            for (int j = 0; j < list_trans.size(); j++) {
                                Reconciliation tran = (Reconciliation) list_trans.get(j);
                                BigDecimal total = tran.getTotal();
                                if ((tran.getStatus() != 6) && (tran.getStatus() != 2)) {
                                    if ((tran.getStatus() != 3)&&(tran.getStatus() != 5)){
                                            total_total = total_total.add(total);
                                    }
                                }
                            }
                            BigDecimal card_over = new BigDecimal(0.0);
                            BigDecimal cheque_over = new BigDecimal(0.0);
                            BigDecimal cash_over = new BigDecimal(0.0);
                            BigDecimal gift_over = new BigDecimal(0.0);
                            BigDecimal card_short = new BigDecimal(0.0);
                            BigDecimal cheque_short = new BigDecimal(0.0);
                            BigDecimal cash_short = new BigDecimal(0.0);
                            BigDecimal gift_short = new BigDecimal(0.0);
                            String over_short = "0";
                            BigDecimal _over = new BigDecimal(0.0);
                            BigDecimal _over_short = new BigDecimal(0.0);
                            BigDecimal _short = new BigDecimal(0.0);

                            if (cd_.getOpenClose() != 0){
                                card_over = cd_.getCard_over();
                                cheque_over = cd_.getCheque_over();
                                cash_over = cd_.getCash_over();
                                gift_over = cd_.getGift_over();
                                card_short = cd_.getCard_short();
                                cheque_short = cd_.getCheque_short();
                                cash_short = cd_.getCash_short();
                                gift_short = cd_.getGift_short();
                                _over = card_over.add(cheque_over).add(cash_over).add(gift_over);
                                _short = card_short.add(cheque_short).add(cash_short).add(gift_short);
                                _over_short = _over.subtract(_short);
                                if (_over_short.compareTo(new BigDecimal(0)) == -1){
                                    over_short = _over_short.setScale(2,BigDecimal.ROUND_HALF_DOWN).toString();
                                } else if (_over_short.compareTo(new BigDecimal(0)) == 1){
                                    over_short = "+"+_over_short.setScale(2,BigDecimal.ROUND_HALF_DOWN);
                                }
                            }
                            boolean b = true;
                            if (b) {

                        %>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <TD>
                                <%=cd_.getDate()%>
                            </TD>
                            <TD>
                                <%=startingDay.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                                <%--<%=(new BigDecimal(cd_.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(cd_.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(cd_.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(cd_.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(cd_.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(cd_.getDollars())).add(new BigDecimal(cd_.getSingles())).add(new BigDecimal(cd_.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(cd_.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(cd_.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(cd_.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(cd_.getHundreds()).multiply(new BigDecimal(100)))%>--%>
                            </TD>
                            <TD>
                                <%=total_total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                                <%--<%=(cd_.getAmex()).add(cd_.getVisa()).add(cd_.getMastercard())%>--%>
                            </TD>
                            <TD>
                                <%=over_short%>
                            </TD>
                            <TD>
                                <a href="./view_closingday.jsp?dt=<%=cd_.getDate()%>"><IMG title="Edit" height="16" alt="View" src="../images/edit.png" width="16" longDesc="../images/edit.png"></a>
                                <a href="#"><IMG title="PDF Report" onclick="printReport('<%=cd_.getDate()%>');" height="16" alt="PDF Report" src="../images/imgIconPdf_16x16.gif" width="16" longDesc="../images/imgIconPdf_16x16.gif"></a>
                                <%--<%=cd_.getGift()%>--%>
                            </TD>
                        </TR><%}}%>
                        </table>
                        <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                        <div  class="pagelinks">
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
