<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.xu.swan.bean.Transaction" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.Theday" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="java.util.Calendar" %>

<%
    User user_ses = (User) session.getAttribute("user");
    if (user_ses == null){
        response.sendRedirect("./error.jsp?ec=1");
        return;
    }
    if ((user_ses.getPermission() != Role.R_ADMIN) && (user_ses.getPermission() != Role.R_RECEP) && (user_ses.getPermission() != Role.R_SHD_CHK)){
        response.sendRedirect("./error.jsp?ec=2");
        return;
    }
    String dt = StringUtils.defaultString(request.getParameter("dt"), "");
    Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(dt);
    if (lMatcher.matches()) {
        dt = dt.trim().replace('-', '/').replaceAll("/0", "/");
    } else {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
        dt = sdf.format(Calendar.getInstance().getTime());
    }

    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id
    Theday theday = Theday.findByDate(Integer.parseInt(loc),DateUtil.parseSqlDate(dt));
%>

<jsp:include page="checkup.jsp">
     <jsp:param name="role" value='<%=Role.S_RECEP%>'/>
</jsp:include>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Start and end of the day</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<style type="text/css">
     <!-- .aa{background-color: #000000; border: 1px solid #999999; top: auto; bottom: auto; line-height: normal; height: 15px; /*display: compact;*/ }
	#b{ border: 1px solid #666666; }
	body { background-color: #000000; }
         .STYLE19 {
        color: #666666;
        font-size: 11px;
        /*font-family: Verdana, Arial, Helvetica, sans-serif;*/
    }
         .STYLE20 {
        color: white;
        font-size: 12px;
        font-family: Verdana, Arial, Helvetica, sans-serif;
    }
	--></style>
		<link href="./css/cashinout.css" rel="stylesheet" type="text/css">
			<style type="text/css">
    <!-- #Layer1 { position:absolute; visibility:visible; width:256px; height:273px; background-color:#000000; border:1px none #000000; z-index:1; left: 41px; top: 21px; }
	#Layer2 { position:absolute; visibility:visible; width:628px; height:525px; background-color:#000000; border:1px none #000000; z-index:1; left: 16px; top: 21px; }
	--></style>
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
<%
    BigDecimal totalcash = new BigDecimal(0);
    BigDecimal creditcard = new BigDecimal(0);
    BigDecimal cheque = new BigDecimal(0);
    BigDecimal giftcard = new BigDecimal(0);
    BigDecimal amex = new BigDecimal(0);
    BigDecimal mastercard = new BigDecimal(0);
    BigDecimal visa = new BigDecimal(0);
    //BigDecimal sum_gift = new BigDecimal(0);
    BigDecimal cashin = new BigDecimal(0);
    BigDecimal cashout = new BigDecimal(0);
    BigDecimal cash = new BigDecimal(0);
    BigDecimal sum_change = new BigDecimal(0);
    BigDecimal endoftheday = new BigDecimal(0);
    ArrayList list = Transaction.findTransByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    if (list != null) {
        for (int i = 0; i < list.size(); i++) {
            Transaction trans = (Transaction) list.get(i);
            BigDecimal price = trans.getPrice();
            BigDecimal tax = trans.getTax();
            BigDecimal disc = trans.getDiscount();
            BigDecimal total = new BigDecimal(0.0);
            total = total.add(price).add(tax);
            total = total.subtract(total.multiply(disc.divide(new BigDecimal(100))));
            String payment = trans.getPayment();
            String[] paymarr = payment.split(";");
            for (int j=0; j<paymarr.length; j++){
                String[] paym = paymarr[j].split("=");
                if (paym[0].toLowerCase().equalsIgnoreCase("amex"))
                    if (paym.length > 1){
                        amex = amex.add(new BigDecimal(paym[1]));
                    }else {
                        amex = amex.add(total);
                    }
                else if (paym[0].toLowerCase().equalsIgnoreCase("visa"))
                    if (paym.length > 1){
                    visa = visa.add(new BigDecimal(paym[1]));
                    }else {
                        visa = visa.add(total);
                    }
                else if (paym[0].toLowerCase().equalsIgnoreCase("mastercard"))
                    if (paym.length > 1){
                    mastercard = mastercard.add(new BigDecimal(paym[1]));
                    }else {
                        mastercard = mastercard.add(total);
                    }
                else if (paym[0].toLowerCase().equalsIgnoreCase("cheque"))
                    if (paym.length > 1){
                    cheque = cheque.add(new BigDecimal(paym[1]));
                    }else {
                        cheque = cheque.add(total);
                    }
                else if (paym[0].toLowerCase().equalsIgnoreCase("cash"))
                    if (paym.length > 1){
                    cash = cash.add(new BigDecimal(paym[1]));
                    }else {
                        cash = cash.add(total);
                    }
                else if (paym[0].toLowerCase().contains("giftcard"))
                    if (paym.length > 1){
                    giftcard = giftcard.add(new BigDecimal(paym[1]));
                    }else {
                        giftcard = giftcard.add(total);
                    }
                else if (paym[0].toLowerCase().equalsIgnoreCase("cashin"))
                    cashin = cashin.add(price);
                else if (paym[0].toLowerCase().equalsIgnoreCase("cashout"))
                    cashout = cashout.add(price);
            }
            sum_change = sum_change.add(trans.getChange_f());
        }
        creditcard = creditcard.add(amex).add(visa).add(mastercard);
        cash = cash.add(cashin).add(cashout);
        if (theday != null) {
            totalcash = totalcash.add(cash).add(theday.getBeginning());
        }
        endoftheday = endoftheday.add(totalcash).add(creditcard).add(cheque).add(cashin).add(cashout);
    }

    BigDecimal other = new BigDecimal(0);
    BigDecimal drawer = new BigDecimal(0);
    BigDecimal begin = new BigDecimal(0);
//    Theday theday = Theday.findByDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    if(theday!=null){
        begin = theday.getBeginning();
        drawer = theday.getCash_drawer();
    }
%>
            <%--<%--%>
        <%--BigDecimal cash = new BigDecimal(0.0);--%>
        <%--BigDecimal amex = new BigDecimal(0.0);--%>
        <%--BigDecimal mastercard = new BigDecimal(0.0);--%>
        <%--BigDecimal visa = new BigDecimal(0.0);--%>
        <%--BigDecimal card = new BigDecimal(0.0);--%>
        <%--BigDecimal check = new BigDecimal(0.0);--%>
        <%--BigDecimal totalcashin = new BigDecimal(0.0);--%>
        <%--BigDecimal totalcashout = new BigDecimal(0.0);--%>
        <%--BigDecimal gift = new BigDecimal(0.0);--%>
        <%--for (int i = 0; i < list_trans.size(); i++) {--%>
            <%--Transaction tran = (Transaction) list_trans.get(i);--%>
            <%--String emp = (String) hm_emp.get(String.valueOf(tran.getEmployee_id()));--%>
            <%--String cust = (String) hm_cust.get(String.valueOf(tran.getCustomer_id()));--%>
            <%--String svc = (String) hm_svc.get(String.valueOf(tran.getService_id()));--%>
            <%--String prod = (String) hm_prod.get(String.valueOf(tran.getProduct_id()));--%>
            <%--String price = String.valueOf(tran.getPrice());--%>
            <%--String tax = String.valueOf(tran.getTax());--%>
            <%--if ("amex".equalsIgnoreCase(tran.getPayment()) || "visa".equalsIgnoreCase(tran.getPayment()) || "mastercard".equalsIgnoreCase(tran.getPayment()))--%>
                <%--card = card.add(tran.getPrice());--%>
            <%--else if ("check".equalsIgnoreCase(tran.getPayment()))--%>
                <%--check = check.add(tran.getPrice());--%>
            <%--else if ("giftcard".equalsIgnoreCase(tran.getPayment()))--%>
                <%--gift = gift.add(tran.getPrice());--%>
            <%--else--%>
                <%--cash = cash.add(tran.getPrice());--%>
        <%--}%>--%>
	<body>
<table width="998" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <%--<tr valign="top">--%>
        <%--<%@ include file="top_page.jsp" %>--%>
    <%--</tr>--%>
    <tr>
        <td height="47" background="./images/ADMIN_03.gif" colspan="2">
            <table width="998" border="0" cellspacing="0" cellpadding="0" id="mev">
                <tr>
                    <td width="300"></td>
                    <td width="120" align="center" class="m"><a href="./index.jsp" onmouseout="MM_swapImgRestore()"
                                                                onmouseover="MM_swapImage('Image14','','./images/home red.gif',1)"><img
                            src="./images/home.gif" name="Image14" width="96" height="39" border="0" id="Image14"></a>
                    </td>
                    <%
                        User sess_user = (User) session.getAttribute("user");
                        if (sess_user != null && sess_user.getPermission() == Role.R_ADMIN) {
                    %>
                    <td width="120" align="center" class="m"><a href="admin/admin.jsp" onmouseout="MM_swapImgRestore()"
                                                                onmouseover="MM_swapImage('Image5','','images/ADMIN red.gif',1)"><img
                            alt="admin" src="images/ADMIN.gif" name="Image5" width="96" height="39" border="0"
                            id="Image5"></a></td>
                    <%}%>
                    <td width="120" align="center" class="m"><a href="./schedule.do" onmouseout="MM_swapImgRestore()"
                                                                onmouseover="MM_swapImage('Image15','','./images/schedule red.gif',1)"><img
                            src="./images/schedule.gif" name="Image15" width="96" height="39" border="0"
                            id="Image15"></a></td>
                    <td width="120" align="center" class="m"><a href="./checkout.do"><img
                            src="./images/checkout red 2.gif" width="96" height="39"></a></td>
                    <td width="120" align="center" class="m"><a href="#"></a></td>
                    <td width="158">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
    <table width="1000" border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td colspan="3">
        <form action="theday.do?action=<%if (theday == null) {%>add<%} else {%>edit<%}%>" method="post" name="theday" id="theday">
        <input type="hidden" name="dt" id="dt" value="<%=dt%>">
        <input type="hidden" name="loc" id="loc" value="<%=loc%>">
        <%if (theday != null) {%>
        <input type="hidden" name="id" id="id" value="<%=theday.getId()%>">
        <input type="hidden" name="beginning" id="beginning" value="<%=begin%>">
        <%}%>
         <%--<%request.setAttribute("dt",dt);%>--%>

        <table border="1" align="center" class="STYLE20">
            <tr>
                <td> Start cash morning: </td>
                <td>
                    <% if (theday == null) { %>
                    <input type="text" value="0" size="10" maxlength="10" name="beginning" id="beginning" />
                    <%} else {%>
                    <%=begin.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%}%>
                </td>
            </tr>
            <tr>
                <td> Amex: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=amex%>" name="amex" id="amex" />
                    <%=amex.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> Mastercard: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=mastercard%>" name="mastercard" id="mastercard" />
                    <%=mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> Visa: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=visa%>" name="visa" id="visa" />
                    <%=visa.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> Total credit card: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=creditcard%>" name="creditcard" id="creditcard" />
                    <%=creditcard.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> Total check of today: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=cheque%>" name="cheque" id="cheque" />
                    <%=cheque.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> GIFTCARD USED: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=giftcard%>" name="giftcard" id="giftcard" />
                    <%=giftcard.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> CASH IN: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=cashin%>" name="cashin" id="cashin" />
                    <%=cashin.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> CASH OUT: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=cashout%>" name="cashout" id="cashout" />
                    <%=cashout.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> TOTAL CASH WITHOUT START CASH: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=cash%>" name="cash" id="cash" />
                    <%=cash.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> TOTAL CASH WITH START OF DAY: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=totalcash%>" name="totalcash" id="totalcash" />
                    <%=totalcash.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> TOTAL END OF THE DAY: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="hidden" value="<%=endoftheday%>" name="endoftheday" id="endoftheday" />
                    <%=endoftheday.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> ADJUSTMENT: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="text" value="0" size="10" maxlength="10" name="adjustment" id="adjustment" />
                    <%} else {%>0<%}%>
                </td>
            </tr>
            <tr>
                <td> PUT IN ENVELOP: </td>
                <td>
                    <% if (theday != null) { %>
                    <input type="text" value="0" size="10" maxlength="10" name="pitinenv" id="pitinenv" />
                    <%} else {%>0<%}%>
                </td>
            </tr>
        </table>
        <table align="center">
            <tr>
            <td align="center" colspan="2">

            <input type="submit" value="<%if (theday == null) {%>Start the Day<%} else {%> End the Day<%}%>" name="submittedValue"/>

            <input type="button" value="Back" onclick="javascript: history.back();"/>
            </td>
            </tr>
        </table>
        </form>
    </td>
    </tr>
    <%@ include file="copyright.jsp" %> 
    </table>
    <script type="text/javascript" xml:space="preserve">
    <!--
        function auto_calc(){
            //left side
            var f_tcash = parseFloat(document.getElementById("total_cash").value);
            var f_tcard = parseFloat(document.getElementById("card").value);
            var f_other = parseFloat(document.getElementById("other").value);
            var f_change = parseFloat(document.getElementById("change1").value);
            var daily_ctrl = document.getElementById("daily");
            var v_daily = f_tcash + f_tcard + f_other - f_change;
            daily_ctrl.value = v_daily;

            var f_paidin = parseFloat(document.getElementById("payin").value);
            var f_paidout = parseFloat(document.getElementById("payout").value);

            //right side
            var f_revenue = parseFloat(document.getElementById("revenue").value);
            var f_begin = parseFloat(document.getElementById("beginning").value);
            var f_cin = parseFloat(document.getElementById("cashim").value);
            var subdraw_ctrl = document.getElementById("subdrawer");
            var v_sub = f_revenue + f_begin + f_cin;
            subdraw_ctrl.value = v_sub;

            //var f_subtotal = parseFloat(document.getElementById("subdrawer").value);
            var f_cout = parseFloat(document.getElementById("cashout").value);
            var tdraw_ctrl = document.getElementById("totaldrawer");
            var v_total = v_sub - f_change - f_cout//f_subtotal - f_change - f_cout
            tdraw_ctrl.valueOf = v_total;

            var f_actdraw = parseFloat(document.getElementById("catualdrawer").value);
            var over_ctrl = document.getElementById("drawerover");
            over_ctrl.value = (f_actdraw>v_total ? f_actdraw-v_total : 0);
            var short_ctrl = document.getElementById("drawershort")
            short_ctrl.value = (f_actdraw<v_total ? v_total-f_actdraw : 0);

            var drawer_ctl = document.getElementById("div_actdraw");
            var daily_ctl = document.getElementById("div_daily");
            var deposit_ctl = document.getElementById("div_deposit");
            var payin_ctl = document.getElementById("div_payin")
            var amount_ctl = document.getElementById("div_amount");
            drawer_ctl.innerHTML = "$" + f_actdraw + "<span class='style12Y'>-</span>";
            daily_ctl.innerHTML = "$" + f_begin + "<span class='style12Y'>=</span>";
            deposit_ctl.innerHTML = "$" + (f_actdraw - f_begin) + "<span class='style12Y'>+</span>";
            payin_ctl.innerHTML = "$" + f_paidin + "<span class='style12Y''>=</span>";
            amount_ctl.innerHTML = "$" + (f_actdraw - f_begin + f_paidin);
        }

        auto_calc();
    //-->
    </script>
    </body>
</html>
