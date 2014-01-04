<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.security.Timestamp" %>
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
    String dt = StringUtils.defaultString(request.getParameter("dt"), "");
    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");
    ArrayList list_trans = Reconciliation.findTransByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    HashMap hm_cust = Customer.findAllMap();

    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }





%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
        <style type="text/css" media="print">
        <!--
        .no_print {
          display: none;
        }
        -->
        </style>
        
		<title>View day</title>
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
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <%--<form action="./list_closingday.jsp" method="post" name="list_form" id="list_form">--%>
    <div class="no_print">
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
    </div>
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>

                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                    <div class="padder">
                        <!-- main content begins here -->
                        <div class="heading">
                            <h1>View day <a>(<%=dt%>)</a></h1>
                        </div>
                        <table class="data">
                        <tr class="filter">
                            <th class="date" title="Date">Date</th>
                            <th class="taxes" title="Product sales">Product sales</th>
                            <th class="taxes" title="Service sales">Service sales</th>
                            <th class="taxes" title="Gross sales">Gross sales</th>
                            <th class="taxes" title="Taxes">Taxes</th>
                            <th class="taxes" title="Net sales">Net sales</th>
                            <th class="taxes" title="Pay in">Pay in</th>
                            <th class="taxes" title="Pay out">Pay out</th>
                            <th class="taxes" title="Refund">Refund</th>
                            <th class="taxes" title="Visa total">Visa total</th>
                            <th class="taxes" title="Amex total">Amex total</th>
                            <th class="taxes" title="Mastercard total">Mastercard total</th>
                            <th class="taxes" title="Credit card total">Credit card total</th>
                            <th class="taxes" title="Check total">Check total</th>
                            <th class="location" title="Cash total">Cash total</th>
                            <th class="taxes" title="Giftcard total">Giftcard total</th>
                            <th class="taxes" title="Opening cash">Opening cash</th>
                            <th class="taxes" title="Over and short">Over and short</th>
                        </tr>
                           <%
                            BigDecimal total_total = new BigDecimal(0.0);
                            BigDecimal total_sub_total = new BigDecimal(0.0);
                            BigDecimal total_cash = new BigDecimal(0.0);
                            BigDecimal total_card = new BigDecimal(0.0);
                            BigDecimal total_cheque = new BigDecimal(0.0);
                            BigDecimal total_gift = new BigDecimal(0.0);
                            BigDecimal sum_svc = new BigDecimal(0.0);
                            BigDecimal sum_prod = new BigDecimal(0.0);
                            BigDecimal total_tax = new BigDecimal(0.0);
                            BigDecimal payin = new BigDecimal(0.0);
                            BigDecimal payout = new BigDecimal(0.0);
                            BigDecimal refund = new BigDecimal(0.0);
                               BigDecimal total_amex = new BigDecimal(0.0);
                               BigDecimal total_visa = new BigDecimal(0.0);
                               BigDecimal total_mastercard = new BigDecimal(0.0);

                            String bc = "#A7A9AC";

                            HashMap map = new HashMap();

                            for (int i = 0; i < list_trans.size(); i++) {
                                Reconciliation tran = (Reconciliation) list_trans.get(i);
                                String trans_code = tran.getCode_transaction();
                                String cust = "";
                                Cashio cio = null;
                                if (tran.getStatus() == 3) {
                                    cio = Cashio.findByReconciliationId(tran.getId());
                                    cust = "PAYOUT " + cio.getVendor();
                                } else if ((tran.getStatus() == 5)) {
                                    cio = Cashio.findByReconciliationId(tran.getId());
                                    cust = "PAYIN " + cio.getVendor();
                                }
                                else {
                                    cust =  (String) hm_cust.get(String.valueOf(tran.getId_customer()));
                                }
                                BigDecimal s_total = tran.getSub_total();
                                BigDecimal taxe = tran.getTaxe();
                                BigDecimal total = tran.getTotal();
                                BigDecimal cash = tran.getCashe();
                                BigDecimal change = tran.getChange();
                                BigDecimal amex = tran.getAmex();
                                BigDecimal visa = tran.getVisa();
                                BigDecimal mastercard = tran.getMastercard();
                                BigDecimal cheque = tran.getCheque();
                                BigDecimal giftcard = tran.getGiftcard();
                                String payment = tran.getPayment();

                                if ((tran.getStatus() != 6) && (tran.getStatus() != 2))
                                {
                                    ArrayList list_ticket = Ticket.findTicketByLocCodeTrans(tran.getId_location(), tran.getCode_transaction());
                                    if ((tran.getStatus() != 4)||(!map.containsKey(tran.getCode_transaction()))){
                                    if (tran.getStatus() == 4) map.put(tran.getCode_transaction(), null);
                                    for (int j = 0; j < list_ticket.size(); j++)
                                    {
                                        Ticket ticket = (Ticket)list_ticket.get(j);
                                        if (tran.getStatus() == 4){
                                                if (ticket.getService_id() != 0){
                                                    if (ticket.getStatus() == 4){
                                                        sum_svc = sum_svc.subtract((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                                    }
//                                                                    else {
//                                                                        sum_svc = sum_svc.add((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
//                                                                    }
                                                } else if (ticket.getProduct_id() !=0){
                                                    if (ticket.getStatus() == 4){
                                                        sum_prod = sum_prod.subtract((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                                    }
//                                                                    else {
//                                                                        sum_prod = sum_prod.add((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
//                                                                    }
                                                }

                                        } else {
                                            if (ticket.getService_id() != 0){
                                                    sum_svc = sum_svc.add((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                            } else if (ticket.getProduct_id() !=0){
                                                    sum_prod = sum_prod.add((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                            }
                                        }
                                    }
                                    }

                                    if ((tran.getStatus() != 3)&&(tran.getStatus() != 5)){
                                        if (tran.getStatus() == 4){
                                            total_total = total_total.subtract(total);
                                            total_sub_total = total_sub_total.subtract(s_total);
                                        } else{
                                            total_total = total_total.add(total);
                                            total_sub_total = total_sub_total.add(s_total);
                                        }
                                    }
                                    if ((tran.getStatus() == 3) || (tran.getStatus() == 4)) {
                                        total_cash = total_cash.subtract(cash);
                                        total_cheque = total_cheque.subtract(cheque);
                                        total_gift = total_gift.subtract(giftcard);
                                        total_card = total_card.subtract(amex).subtract(visa).subtract(mastercard);
                                        total_tax = total_tax.subtract(taxe);
                                        total_amex = total_amex.subtract(amex);
                                        total_mastercard = total_mastercard.subtract(mastercard);
                                        total_visa = total_visa.subtract(visa);
                                    } else{
                                        total_cash = total_cash.add(cash).subtract(change);
                                        total_cheque = total_cheque.add(cheque);
                                        total_gift = total_gift.add(giftcard);
                                        total_card = total_card.add(amex).add(visa).add(mastercard);
                                        total_tax = total_tax.add(taxe);
                                        total_amex = total_amex.add(amex);
                                        total_mastercard = total_mastercard.add(mastercard);
                                        total_visa = total_visa.add(visa);
                                    }
                                }

                                switch (tran.getStatus()){
                                    case 0: bc = "#c1c2c4"; break; //closed transaction
                                    case 2: bc = "#9ccf78"; break; //pending (saved) transaction
                                    case 3: bc = "#16c1f3"; payout = payout.add(total); break; //payout transaction
                                    case 4: bc = "#812990"; refund = refund.add(total); break; //refunder transaction
                                    case 5: bc = "#16c1f3"; payin = payin.add(total); break; //payin transaction
                                    case 6: bc = "#f172ac"; break; //canceled transaction
                                }

                            }
                        if (!dt.equals("")){
                            CashDrawing cd_ = CashDrawing.findByDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
                            CashDrawing cd_open = CashDrawing.findByDateStatus(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), 0);
                            BigDecimal startingDay = new BigDecimal(0);
                            startingDay = startingDay.add(new BigDecimal(cd_open.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(cd_open.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(cd_open.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(cd_open.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(cd_open.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(cd_open.getDollars())).add(new BigDecimal(cd_open.getSingles())).add(new BigDecimal(cd_open.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(cd_open.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(cd_open.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(cd_open.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(cd_open.getHundreds()).multiply(new BigDecimal(100)));
                            String _dt = cd_.getDate().toString();
//                            BigDecimal total_cheque = new BigDecimal(0.0);
//                            BigDecimal total_cash = new BigDecimal(0.0);
//                            BigDecimal total_gift = new BigDecimal(0.0);
                            BigDecimal total_amex_ = new BigDecimal(0.0);
                            BigDecimal total_visa_ = new BigDecimal(0.0);
                            BigDecimal total_mastercard_ = new BigDecimal(0.0);
                            BigDecimal total_cheque_ = new BigDecimal(0.0);
                            BigDecimal total_gift_ = new BigDecimal(0.0);
                            BigDecimal total_cash_ = new BigDecimal(0.0);
                            BigDecimal total_card_ = new BigDecimal(0.0);
//                            BigDecimal total_card = new BigDecimal(0.0);
                            int pennies = 0;
                            int nickels = 0;
                            int dimes = 0;
                            int quarters = 0;
                            int half_dollars = 0;
                            int dollars = 0;
                            int singles = 0;
                            int fives = 0;
                            int tens = 0;
                            int twenties = 0;
                            int fifties = 0;
                            int hundreds = 0;
                            BigDecimal pennies_amnt = new BigDecimal(0.0);
                            BigDecimal nickels_amnt = new BigDecimal(0.0);
                            BigDecimal dimes_amnt = new BigDecimal(0.0);
                            BigDecimal quarters_amnt = new BigDecimal(0.0);
                            BigDecimal half_dollars_amnt = new BigDecimal(0.0);
                            BigDecimal dollars_amnt = new BigDecimal(0.0);
                            BigDecimal singles_amnt = new BigDecimal(0.0);
                            BigDecimal fives_amnt = new BigDecimal(0.0);
                            BigDecimal tens_amnt = new BigDecimal(0.0);
                            BigDecimal twenties_amnt = new BigDecimal(0.0);
                            BigDecimal fifties_amnt = new BigDecimal(0.0);
                            BigDecimal hundreds_amnt = new BigDecimal(0.0);
                            BigDecimal total_amnt = new BigDecimal(0.0);
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

                            if (cd_ != null && cd_.getOpenClose() != 0){
                                pennies_amnt = new BigDecimal(cd_.getPennies()).divide(new BigDecimal(100));
                                nickels_amnt = new BigDecimal(cd_.getNickels()).divide(new BigDecimal(20));
                                dimes_amnt = new BigDecimal(cd_.getDimes()).divide(new BigDecimal(10));
                                quarters_amnt = new BigDecimal(cd_.getQuarters()).divide(new BigDecimal(4));
                                half_dollars_amnt = new BigDecimal(cd_.getHalf_dollars()).divide(new BigDecimal(2));
                                dollars_amnt = new BigDecimal(cd_.getDollars());
                                singles_amnt = new BigDecimal(cd_.getSingles());
                                fives_amnt = new BigDecimal(cd_.getFives()).multiply(new BigDecimal(5));
                                tens_amnt = new BigDecimal(cd_.getTens()).multiply(new BigDecimal(10));
                                twenties_amnt = new BigDecimal(cd_.getTwenties()).multiply(new BigDecimal(20));
                                fifties_amnt = new BigDecimal(cd_.getFifties()).multiply(new BigDecimal(50));
                                hundreds_amnt = new BigDecimal(cd_.getHundreds()).multiply(new BigDecimal(100));
                                total_amnt = total_amnt.add(new BigDecimal(cd_.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(cd_.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(cd_.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(cd_.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(cd_.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(cd_.getDollars())).add(new BigDecimal(cd_.getSingles())).add(new BigDecimal(cd_.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(cd_.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(cd_.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(cd_.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(cd_.getHundreds()).multiply(new BigDecimal(100)));
                                pennies = cd_.getPennies();
                                nickels = cd_.getNickels();
                                dimes = cd_.getDimes();
                                quarters = cd_.getQuarters();
                                half_dollars = cd_.getHalf_dollars();
                                dollars = cd_.getDollars();
                                singles = cd_.getSingles();
                                fives = cd_.getFives();
                                tens = cd_.getTens();
                                twenties = cd_.getTwenties();
                                fifties = cd_.getFifties();
                                hundreds = cd_.getHundreds();
//                                cd_id = cd.getId();
                                total_amex_ = cd_.getAmex();
                                total_visa_ = cd_.getVisa();
                                total_mastercard_ = cd_.getMastercard();
                                total_card_ = total_amex_.add(total_visa_).add(total_mastercard_);
                                total_cheque_ = cd_.getCheque();
                                total_cash_ = cd_.getCash();
                                total_gift_ = cd_.getGift();
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
                        <TR>
                            <TD>
                                <%=cd_.getDate()%>
                            </TD>
                            <TD>
                                <%=sum_prod.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=sum_svc.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=total_total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=total_tax.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=total_sub_total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=payin.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=payout.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=refund.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=((cd_!=null && cd_.getOpenClose() != 0)?total_visa_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_visa.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>
                            </TD>
                            <TD>
                                <%=((cd_!=null && cd_.getOpenClose() != 0)?total_amex_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_amex.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>
                            </TD>
                            <TD>
                                <%=((cd_!=null && cd_.getOpenClose() != 0)?total_mastercard_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>
                            </TD>
                            <TD>
                                <%=total_card.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=((cd_!=null && cd_.getOpenClose() != 0)?total_cheque_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_cheque.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>
                            </TD>
                            <TD>
                                <%=((cd_!=null && cd_.getOpenClose() != 0)?total_cash_.setScale(2,BigDecimal.ROUND_HALF_DOWN):new BigDecimal(0))%> <br>
                                pennies: <%=pennies%> <br>
                                nickels: <%=nickels%> <br>
                                dimes: <%=dimes%> <br>
                                quarters: <%=quarters%> <br>
                                1/2 dollar: <%=half_dollars%> <br>
                                dollars: <%=dollars%> <br>
                                singles: <%=singles%> <br>
                                fives: <%=fives%> <br>
                                tens: <%=tens%> <br>
                                twenties: <%=twenties%> <br>
                                fifties: <%=fifties%> <br>
                                hundreds: <%=hundreds%> <br>
                            </TD>
                            <TD>
                                <%=((cd_!=null && cd_.getOpenClose() != 0)?total_gift_.setScale(2,BigDecimal.ROUND_HALF_DOWN):total_gift.setScale(2,BigDecimal.ROUND_HALF_DOWN))%>
                            </TD>
                            <TD>
                                <%=startingDay.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                            </TD>
                            <TD>
                                <%=over_short%>
                            </TD>
                        </TR><%}}%>
                        <tr class="no_print">
                            <td colspan="18" align="right">
                                <a href="#" onclick="window.print();"><IMG alt="Print" src="../images/print.png" longDesc="../images/print.png"></a>
                            </td>
                        </tr>
                        </table>
                        <%--<%if(list.size() >= ActionUtil.PAGE_ITEMS){%>--%>
                        <%--<div class="pagelinks">--%>
                            <%--<input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />--%>
                            <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num - 1%>';document.list_form.submit()">« Previous</a>  <!-- active 'next' link -->--%>
                            <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num + 1%>';document.list_form.submit()">Next »</a>  <!-- active 'next' link -->--%>
                        <%--</div>--%>
                        <%--<%}%>--%>
                    </div>
                </div>
				</td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
    <%--</form>--%>
	</body>
</html>
