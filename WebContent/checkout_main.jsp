<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.text.Format" %>
<%@ page import="java.math.MathContext" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.security.Timestamp" %>
<%@ page import="java.util.*" %>

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

    String p_emp = StringUtils.defaultString(request.getParameter("emp"), "allemployee");
    String p_cust = StringUtils.defaultString(request.getParameter("cust"), "allcustomer");
    String id_trans = StringUtils.defaultString(request.getParameter("id2"), "");
    String id_gift = StringUtils.defaultString(request.getParameter("idg"), "0");
    String act = StringUtils.defaultString(request.getParameter("act"), "0");
    String codeTicket = StringUtils.defaultString(request.getParameter("codet"), "0");
    ArrayList list_emp = Employee.findAllByLoc(Integer.parseInt(loc));
    ArrayList list_cust = Customer.findAll();
    String dt_str = dt;
    boolean find = false;

    ArrayList list_trans = null;
    if (codeTicket.equals("0")){
        list_trans = Reconciliation.findTransByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    } else {
        list_trans = Reconciliation.findTransByCode(codeTicket);
        if (list_trans.size() > 0){
            Reconciliation _t = (Reconciliation) list_trans.get(0);
            dt_str = _t.getCreated_dt().toString();
            find = true;
        }
    }
     boolean IsPending = false;
     for (int i = 0; i < list_trans.size(); i++){
         Reconciliation rc = (Reconciliation) list_trans.get(i);
         if (rc!=null && rc.getStatus()==2){
             IsPending = true;
         }
     }

    HashMap hm_emp = Employee.findAllMap();
    HashMap hm_cust = Customer.findAllMap();
    HashMap hm_svc = Service.findAllMap();
    HashMap hm_prod = Inventory.findAllMap();
    BigDecimal giftamount  = new BigDecimal(0);
    Date giftdate = Calendar.getInstance().getTime();
    Giftcard gc = Giftcard.findByCode(id_gift);
    if (gc != null){
        giftamount  = gc.getAmount();                   
        giftdate = gc.getCreated();
    }
    Location location = Location.findById(Integer.parseInt(loc));
    boolean isStartDayAvailable = true;
    boolean isEndDayAvailable = false;
    CashDrawing cd = CashDrawing.findByDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    BigDecimal startingDay = new BigDecimal(0);
    CashDrawing _cd = CashDrawing.findByDateStatus(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), 0);
    if (_cd != null)
        startingDay = startingDay.add(new BigDecimal(_cd.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(_cd.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(_cd.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(_cd.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(_cd.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(_cd.getDollars())).add(new BigDecimal(_cd.getSingles())).add(new BigDecimal(_cd.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(_cd.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(_cd.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(_cd.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(_cd.getHundreds()).multiply(new BigDecimal(100)));
    if(cd != null && cd.getOpenClose() != 2){
        isEndDayAvailable = true;
        isStartDayAvailable = false;
    }else if(cd != null && cd.getOpenClose() == 2){
        isEndDayAvailable = false;
        isStartDayAvailable = false;
    }

//    BigDecimal card_amnt = new BigDecimal(0.0);
    BigDecimal cheque_amnt = new BigDecimal(0.0);
    BigDecimal cash_amnt = new BigDecimal(0.0);
    BigDecimal gift_amnt = new BigDecimal(0.0);
//    BigDecimal amex_amnt = new BigDecimal(0.0);
//    BigDecimal visa_amnt = new BigDecimal(0.0);
//    BigDecimal mastercard_amnt = new BigDecimal(0.0);
    BigDecimal creditcard = new BigDecimal(0.0);
    int pennies_q = 0;
    int nickels_q = 0;
    int dimes_q = 0;
    int quarters_q = 0;
    int half_dollars_q = 0;
    int dollars_q = 0;
    int singles_q = 0;
    int fives_q = 0;
    int tens_q = 0;
    int twenties_q = 0;
    int fifties_q = 0;
    int hundreds_q = 0;
    int cd_id = 0;
    int _employeeID = 0;
    String CashDrawingDate = "";
    BigDecimal card_over = new BigDecimal(0.0);
    BigDecimal cheque_over = new BigDecimal(0.0);
    BigDecimal cash_over = new BigDecimal(0.0);
    BigDecimal gift_over = new BigDecimal(0.0);
    BigDecimal card_short = new BigDecimal(0.0);
    BigDecimal cheque_short = new BigDecimal(0.0);
    BigDecimal cash_short = new BigDecimal(0.0);
    BigDecimal gift_short = new BigDecimal(0.0);

    CashDrawing cd_ = CashDrawing.findByDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    if (cd_ != null && cd_.getOpenClose() != 0){
//        cash_amnt = cash_amnt.add(new BigDecimal(cd_.getPennies()).divide(new BigDecimal(100))).add(new BigDecimal(cd_.getNickels()).divide(new BigDecimal(20))).add(new BigDecimal(cd_.getDimes()).divide(new BigDecimal(10))).add(new BigDecimal(cd_.getQuarters()).divide(new BigDecimal(4))).add(new BigDecimal(cd_.getHalf_dollars()).divide(new BigDecimal(2))).add(new BigDecimal(cd_.getDollars())).add(new BigDecimal(cd_.getSingles())).add(new BigDecimal(cd_.getFives()).multiply(new BigDecimal(5))).add(new BigDecimal(cd_.getTens()).multiply(new BigDecimal(10))).add(new BigDecimal(cd_.getTwenties()).multiply(new BigDecimal(20))).add(new BigDecimal(cd_.getFifties()).multiply(new BigDecimal(50))).add(new BigDecimal(cd_.getHundreds()).multiply(new BigDecimal(100)));
//        card_amnt = card_amnt.add(cd_.getAmex()).add(cd_.getVisa()).add(cd_.getMastercard());
//        card_amnt = cd_.getCreditcard();
        cash_amnt = cd_.getCash();
        cheque_amnt = cd_.getCheque();
        gift_amnt = cd_.getGift();
        pennies_q = cd_.getPennies();
        nickels_q = cd_.getNickels();
        dimes_q = cd_.getDimes();
        quarters_q = cd_.getQuarters();
        half_dollars_q = cd_.getHalf_dollars();
        dollars_q = cd_.getDollars();
        singles_q = cd_.getSingles();
        fives_q = cd_.getFives();
        tens_q = cd_.getTens();
        twenties_q = cd_.getTwenties();
        fifties_q = cd_.getFifties();
        hundreds_q = cd_.getHundreds();
//        amex_amnt = cd_.getAmex();
//        visa_amnt = cd_.getVisa();
//        mastercard_amnt = cd_.getMastercard();
        creditcard = cd_.getCreditcard();
        CashDrawingDate = cd_.getDate().toString();
        cd_id = cd_.getId();
        _employeeID = cd_.getEmployeeID();
        card_over = cd_.getCard_over();
        cheque_over = cd_.getCheque_over();
        cash_over = cd_.getCash_over();
        gift_over = cd_.getGift_over();
        card_short = cd_.getCard_short();
        cheque_short = cd_.getCheque_short();
        cash_short = cd_.getCash_short();
        gift_short = cd_.getGift_short();

    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> <!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">-->
<html><!--<html xmlns="http://www.w3.org/1999/xhtml">-->
<head>
<%--<meta http-equiv="Content-Type" content="text/html; charset=utf-8">--%>
<META HTTP-EQUIV="cache-control" CONTENT="no-cache">
<META HTTP-EQUIV="expires" CONTENT="Fri, 01, Jan 1990 00:00:00 GMT">
    <title>checkout main</title>
    <LINK href="css/default.css" type=text/css rel=stylesheet>
    <LINK href="css/modalbox.css" type=text/css rel=stylesheet>
    <LINK href="css/hd.css" type=text/css rel=stylesheet>
    <link rel="stylesheet" type="text/css" media="all" href="./jscalendar/calendar-hd.css" title="hd" />
    <link rel="stylesheet" type="text/css" href="css/checkout.css" media="all"/>

    <style type="text/css">
        body{
            background-color: #000000;
            color: #FFFFFF;
            margin: 0;
            padding: 0;
        }
        table.rec_header td{
            background-color: #000000;
        }
        table.rec td{
            border-right: solid 1px #717173;
            border-bottom: solid 1px #b9bbbd;
            text-align: center;
            vertical-align: middle;
            background-color: #a7a9ac;
            font-size: 8pt;
            color: #000000;
            height: 16px;
        }
    </style>

    <link rel="stylesheet" type="text/css" href="./fonts/fonts-min.css"/>
    <link rel="stylesheet" type="text/css" href="./button/button.css"/>
    <link rel="stylesheet" type="text/css" href="./container/container.css"/>
    <script type="text/javascript" src="./utilities/utilities.js"></script>
    <script type="text/javascript" src="./button/button-min.js"></script>
    <script type="text/javascript" src="./container/container-min.js"></script>

    <%--<link rel="stylesheet" type="text/css" href="./fonts/fonts-min.css"/>--%>
    <%--<link rel="stylesheet" type="text/css" href="./button/button.css"/>--%>
    <%--<link rel="stylesheet" type="text/css" href="./container/container.css"/>--%>
    <%--<script type="text/javascript" src="./utilities/utilities.js"></script>--%>
    <%--<script type="text/javascript" src="./button/button-min.js"></script>--%>
    <%--<script type="text/javascript" src="./container/container-min.js"></script>--%>

    <script language="javascript" type="text/javascript" src="Js/includes/prototype.js"></script>
    <script language="javascript" type="text/javascript" src="Js/scriptaculous/scriptaculous.js?load=builder,effects"></script>
    <script language="javascript" type="text/javascript" src="Js/includes/modalbox.js"></script>
    <style type="text/css">@import "./css/modalbox.css";</style>

    <!--<script type="text/javascript" src="./ajax/yahoo-min.js"></script>
    <script type="text/javascript" src="./ajax/event-min.js"></script>
    <script type="text/javascript" src="./ajax/connection-min.js"></script>-->

    <script type="text/javascript" src="./jscalendar/calendar.js"></script>
    <script type="text/javascript" src="./jscalendar/lang/calendar-en.js"></script>
    <script type="text/javascript" src="./jscalendar/calendar-setup.js"></script>

    <script type="text/javascript" src="Js/selectworker.js"></script>
    <script type="text/javascript" src="script/checkout.js"></script>

    <style type="text/css">
    span.radio4 {
      width: 25px;
      height: 25px;
      padding: 0 5px 0 0;
      background: url(img/checkout_payout_radio1.png) no-repeat;
      display: block;
      clear: left;
      float: left;
    }
    span.radio5 {
      width: 31px;
      height: 31px;
      padding: 0 5px 0 0;
      background: url(img/checkout_payout_radio2.png) no-repeat;
      display: block;
      clear: left;
      float: left;
    }

        .clearTable TD{
            padding: 0;
            margin: 0;
        }
    .clearTable TR{
        padding: 0;
        margin: 0;
    }
    </style>
    <script type="text/javascript" src="Js/custom-form-elements4.js"></script>
    <script type="text/javascript" src="Js/custom-form-elements5.js"></script>
    <style>
    span.radio6 {
      width: 29px;
      height: 28px;
      padding: 0 5px 0 0;
      background: url(img/close_cash_radio.png) no-repeat;
      display: block;
      clear: left;
      float: left;
    }
    </style>
    <script src="Js/custom-form-elements6.js"></script>

<script>
var edit_REFUND = false;
    function getK(elPrefix){
        var k = 0;        
        if(elPrefix == 'pennies')
            k = 1/100;
        else if(elPrefix == 'nickels')
            k = 1/20;
        else if(elPrefix == 'dimes')
            k = 1/10;
        else if(elPrefix == 'quarters')
            k = 1/4;
        else if(elPrefix == 'half_dollars')
            k = 1/2;
        else if(elPrefix == 'dollars')
            k = 1;
        else if(elPrefix == 'singles')
            k = 1;
        else if(elPrefix == 'fives')
            k = 5;
        else if(elPrefix == 'tens')
            k = 10;
        else if(elPrefix == 'twenties')
            k = 20;
        else if(elPrefix == 'fifties')
            k = 50;
        else if(elPrefix == 'hundreds')
            k = 100;
        return k;
    }
    
    function calcQty(elPrefix){
        var qty = document.getElementById(elPrefix+"_qty");
        var amount = document.getElementById(elPrefix+"_amount");
        var k = getK(elPrefix);
        qty.value = amount.value / k;
        calcTotal();
    }
    function calcAmount(elPrefix){
        var qty = document.getElementById(elPrefix+"_qty");
        var amount = document.getElementById(elPrefix+"_amount");
        var k = getK(elPrefix);
        amount.value = qty.value * k;
        calcTotal();
    }
    
    function calcTotal(){
        var s = 0;
        s += parseFloat(document.getElementById("pennies"+"_amount").value);
        s += parseFloat(document.getElementById("nickels"+"_amount").value);
        s += parseFloat(document.getElementById("dimes"+"_amount").value);
        s += parseFloat(document.getElementById("quarters"+"_amount").value);
        s += parseFloat(document.getElementById("half_dollars"+"_amount").value);
        s += parseFloat(document.getElementById("dollars"+"_amount").value);
        s += parseFloat(document.getElementById("singles"+"_amount").value);
        s += parseFloat(document.getElementById("fives"+"_amount").value);
        s += parseFloat(document.getElementById("tens"+"_amount").value);
        s += parseFloat(document.getElementById("twenties"+"_amount").value);
        s += parseFloat(document.getElementById("fifties"+"_amount").value);
        s += parseFloat(document.getElementById("hundreds"+"_amount").value);
        document.getElementById("total").value = s;
        var t = s - (document.getElementById("opening_cash").value+0);
        document.getElementById("cash_amount").value = t;
//        var cash_total = document.getElementById("cash_total").value+0;
//        var r = cash_total - t;
        totalCalc("cash");
//        document.getElementById("cash_over").value = 0;
//        document.getElementById("cash_short").value = 0;
//        if(t > cash_total)
//            document.getElementById("cash_over").value = -r;
//        else
//            document.getElementById("cash_short").value = r;

    }

    function totalCalc(prefix){
        var type = 0;
        var amnt = 0;
        var rez = 0;
        if (prefix =="creditcard"){
            type =  document.getElementById("total_card").value-0;
//            var amex = document.getElementById("amex_amount").value-0;
//            var visa = document.getElementById("visa_amount").value-0;
//            var mastercard = document.getElementById("mastercard_amount").value-0;
//            amnt = amex + visa + mastercard;
            amnt = document.getElementById(prefix).value-0;
            rez = type - amnt;
            if (rez < 0) {
                document.getElementById(prefix + "_over").value = rez * -1;
                document.getElementById(prefix + "_short").value = "0";
            } else {
                document.getElementById(prefix + "_short").value = rez;
                document.getElementById(prefix + "_over").value = "0";
            }

        } else
            if (prefix =="cash"){
            type = document.getElementById("cash_amount").value-0;
//            var cashOpen = document.getElementById("opening_cash").value-0;
//            amnt = cashOpen;
            amnt = document.getElementById("total_cash").value-0;
            rez = amnt - type;
            if (rez < 0) {
                document.getElementById(prefix + "_over").value = rez * -1;
                document.getElementById(prefix + "_short").value = "0";
            } else {
                document.getElementById(prefix + "_short").value = rez;
                document.getElementById(prefix + "_over").value = "0";
            }
        } else {
            type = document.getElementById("total_" + prefix).value-0;
            amnt = document.getElementById(prefix + "_amount").value-0;
            rez = type - amnt;
            if (rez < 0) {
                document.getElementById(prefix + "_over").value = rez * -1;
                document.getElementById(prefix + "_short").value = "0";
            } else {
                document.getElementById(prefix + "_short").value = rez;
                document.getElementById(prefix + "_over").value = "0";
            }
        }
    }

    function deleteTransaction(log, pwd, id){
        var __log = log;
        var __pwd = pwd;
        var __id = id;        
        new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
                            parameters: {
                                action: "deleteTransaction",
                                log: __log,
                                pwd: __pwd,
                                id: __id
                            },
                            onSuccess: function(transport) {
                                var response = new String(transport.responseText);
                                if(response != ''){
                                     alert(response);
                                }
                                else
                                {
                                    Modalbox.hide();
                                    window.location.reload();
                                }
                            }.bind(this),
                            onException: function(instance, exception){
        					    Modalbox.hide();
                                alert('Error: ' + exception);
                            }
                        });
    }

    function saveCashDrawing(_openClose)
    {
        saveCashDrawing2(_openClose, true)
    }


    function saveCashDrawing2(_openClose, reload){
        /*emps = document.getElementById("empSelect");*/
        _loc = document.getElementById("loc").value;
        _id = document.getElementById("cashDrawing"+"_id").value;
//        _amex = document.getElementById("amex" + "_amount").value;
//        _visa = document.getElementById("visa" + "_amount").value;
//        _mastercard = document.getElementById("mastercard" + "_amount").value;
        _creditcard = document.getElementById("creditcard").value;
        _cheque = document.getElementById("check" + "_amount").value;
        _cash = document.getElementById("cash" + "_amount").value;
        _gift = document.getElementById("gift" + "_amount").value;
        _employeeID = -1;
       /* if(emps){
            opt = emps.getElementsByTagName("option");            
            _employeeID = opt[emps.selectedIndex].value; 
        }
        */
        _pennies = document.getElementById("pennies"+"_qty").value;
        _nickels = document.getElementById("nickels"+"_qty").value;
        _dimes = document.getElementById("dimes"+"_qty").value;
        _quarters = document.getElementById("quarters"+"_qty").value;
        _half_dollars = document.getElementById("half_dollars"+"_qty").value;
        _dollars = document.getElementById("dollars"+"_qty").value;
        _singles = document.getElementById("singles"+"_qty").value;
        _fives = document.getElementById("fives"+"_qty").value;
        _tens = document.getElementById("tens"+"_qty").value;
        _twenties = document.getElementById("twenties"+"_qty").value;
        _fifties = document.getElementById("fifties"+"_qty").value;
        _hundreds = document.getElementById("hundreds"+"_qty").value;
        _date = document.getElementById("CashDrawingDate").value;
        _card_over = document.getElementById("creditcard_over").value;
        _cheque_over = document.getElementById("check_over").value;
        _cash_over = document.getElementById("cash_over").value;
        _gift_over = document.getElementById("gift_over").value;
        _card_short = document.getElementById("creditcard_short").value;
        _cheque_short = document.getElementById("check_short").value;
        _cash_short = document.getElementById("cash_short").value;
        _gift_short = document.getElementById("gift_short").value;

        new Ajax.Request( 'CashDrawing?rnd=' + Math.random() * 99999, { method: 'get',
                            parameters: {
                                Action: "ADD",
                                loc: _loc,
                                id: _id,
                                date: _date,
                                employeeID: _employeeID,
                                pennies: _pennies,
                                nickels: _nickels,
                                dimes: _dimes,
                                quarters: _quarters,
                                half_dollars: _half_dollars,
                                dollars: _dollars,
                                singles: _singles,
                                fives: _fives,
                                tens: _tens,
                                twenties: _twenties,
                                fifties: _fifties,
                                hundreds: _hundreds,
                                openClose: _openClose,
//                                amex: _amex,
//                                visa: _visa,
//                                mastercard: _mastercard,
                                creditcard: _creditcard,
                                cheque: _cheque,
                                cash: _cash,
                                gift: _gift,
                                card_over: _card_over,
                                cheque_over: _cheque_over,
                                cash_over: _cash_over,
                                gift_over: _gift_over,
                                card_short: _card_short,
                                cheque_short: _cheque_short,
                                cash_short: _cash_short,
                                gift_short: _gift_short

                            },
        					onSuccess: function(transport) {
                                var req2 = new String(transport.responseText);
                                if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                                    var arr = req2.split(":");
//                                    alert(arr[2].toString());
                                    document.location.href = arr[1].toString();
                                } else {
                                    Modalbox.hide();
                                    if(reload)
                                        window.location.reload();
                                }
        					}.bind(this),
        					onException: function(instance, exception){
        					    Modalbox.hide();
        						alert('CashDrawing Loading Error: ' + exception);
        					}
        				});
    }

    function saveCashDrawing_(_openClose){
        var __loc = document.getElementById("loc").value;
        var __id = document.getElementById("cashDrawing_id_").value;
//        var __amex = document.getElementById("amex_amount_").value;
//        var __visa = document.getElementById("visa_amount_").value;
//        var __mastercard = document.getElementById("mastercard_amount_").value;
        var __creditcard = document.getElementById("creditcard_").value;
        var __cheque = document.getElementById("check_amount_").value;
        var __cash = document.getElementById("cash_amount_").value;
        var __gift = document.getElementById("gift_amount_").value;
        var __employeeID = document.getElementById("employeeID_").value;
        var __pennies = document.getElementById("pennies_qty_").value;
        var __nickels = document.getElementById("nickels_qty_").value;
        var __dimes = document.getElementById("dimes_qty_").value;
        var __quarters = document.getElementById("quarters_qty_").value;
        var __half_dollars = document.getElementById("half_dollars_qty_").value;
        var __dollars = document.getElementById("dollars_qty_").value;
        var __singles = document.getElementById("singles_qty_").value;
        var __fives = document.getElementById("fives_qty_").value;
        var __tens = document.getElementById("tens_qty_").value;
        var __twenties = document.getElementById("twenties_qty_").value;
        var __fifties = document.getElementById("fifties_qty_").value;
        var __hundreds = document.getElementById("hundreds_qty_").value;
        var __date = document.getElementById("CashDrawingDate_").value;
        var __card_over = document.getElementById("creditcard_over_").value;
        var __cheque_over = document.getElementById("check_over_").value;
        var __cash_over = document.getElementById("cash_over_").value;
        var __gift_over = document.getElementById("gift_over_").value;
        var __card_short = document.getElementById("creditcard_short_").value;
        var __cheque_short = document.getElementById("check_short_").value;
        var __cash_short = document.getElementById("cash_short_").value;
        var __gift_short = document.getElementById("gift_short_").value;     
        new Ajax.Request( 'CashDrawing?rnd=' + Math.random() * 99999, { method: 'get',
                            parameters: {
                                Action: "ADD",
                                loc: __loc,
                                id: __id,
                                date: __date,
                                employeeID: __employeeID,
                                pennies: __pennies,
                                nickels: __nickels,
                                dimes: __dimes,
                                quarters: __quarters,
                                half_dollars: __half_dollars,
                                dollars: __dollars,
                                singles: __singles,
                                fives: __fives,
                                tens: __tens,
                                twenties: __twenties,
                                fifties: __fifties,
                                hundreds: __hundreds,
                                openClose: _openClose,
//                                amex: __amex,
//                                visa: __visa,
//                                mastercard: __mastercard,
                                creditcard: __creditcard,
                                cheque: __cheque,
                                cash: __cash,
                                gift: __gift,
                                card_over: __card_over,
                                cheque_over: __cheque_over,
                                cash_over: __cash_over,
                                gift_over: __gift_over,
                                card_short: __card_short,
                                cheque_short: __cheque_short,
                                cash_short: __cash_short,
                                gift_short: __gift_short
                            },
        					onSuccess: function(transport) {
    							var response = new String(transport.responseText);
    							if(response != ''){
//    							     alert(response);
                                }
//                                Modalbox.hide();
                                window.location.reload();
        					}.bind(this),
        					onException: function(instance, exception){
//        					    Modalbox.hide();
        						alert('CashDrawing Loading Error: ' + exception);
        					}
        				});
    }

    var type = "";
    function setPIOvalue(el){
        basename = "";
        if(type != ""){
            type = "";
            return;
        }
        if(el.id.match("_value$")){
            basename = el.id.replace(/_value$/g, "");
            type = "text";    
        }
        if(el.id.match("_radio$")){
            basename = el.id.replace(/_radio$/g, "");
            type = "radio";
        }
        if (edit_REFUND){
            document.getElementById("visa_value").value = 0.0;
            document.getElementById("mastercard_value").value = 0.0;
            document.getElementById("amex_value").value = 0.0;
            document.getElementById("cash_value").value = 0.0;
            document.getElementById("check_value").value = 0.0;
            document.getElementById("giftcard_value").value = 0.0;
            document.getElementById(basename + "_value").value = document.getElementById("total_value").value;
        } else {
        document.getElementById("total_value").value = document.getElementById(basename + "_value").value;
        }
        if(type == "text")
            document.getElementById(basename + "_radio").click();
        else
            document.getElementById(basename + "_value").focus();
        type = "";
    }

         function setREFvalue(el){
//            alert("setREFvalue");
            var basename;
            var type;
            basename = "";
            if(type != ""){
                type = "";
                return;
            }
            if(el.id.match("_value$")){
                basename = el.id.replace(/_value$/g, "");
                type = "text";
            }
            if(el.id.match("_radio$")){
                basename = el.id.replace(/_radio$/g, "");
                type = "radio";
            }
            document.getElementById("visa_value").value = 0.0;
            document.getElementById("mastercard_value").value = 0.0;
            document.getElementById("amex_value").value = 0.0;
            document.getElementById("cash_value").value = 0.0;
            document.getElementById("check_value").value = 0.0;
            document.getElementById("giftcard_value").value = 0.0;
            document.getElementById(basename + "_value").value = document.getElementById("total_value").value;
            if(type == "text")
                document.getElementById(basename + "_radio").click();
            else
                document.getElementById(basename + "_value").focus();
            type = "";
        }

       function saveREFvalue(){
        _payment_method = "";
		inputs = document.getElementsByTagName("input");
		for(a = 0; a < inputs.length; a++) {
			if(inputs[a].name == 'payment_method' && inputs[a].type == 'radio' && inputs[a].checked) {
                _payment_method = inputs[a].value;
			}
		}
//        _vendor = document.getElementById("vendor").value;
//        _desc = document.getElementById("description").value;
        _total = document.getElementById("total_value").value;
        if(_payment_method != ""  && _total != ""){
    		<%--var xmlRequestAppointment;--%>
            <%--try {--%>
    		   <%--xmlRequestAppointment = new XMLHttpRequest();--%>
    		<%--}catch(e) {--%>
    		    <%--try {--%>
    		        <%--xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");--%>
    		    <%--} catch(e) {}--%>
    		<%--}--%>
    		var t = document.getElementById("reconciliation_id").value;
            <%--xmlRequestAppointment.open("POST", "./chkqry?action=updateRefundPayment&paym="+ _payment_method +"&reconID=" + t);--%>
            <%--xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");--%>
            <%--xmlRequestAppointment.send('');--%>
            <%--Modalbox.hide();--%>
            <%--window.location.reload();--%>
            <%--document.location = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();--%>


             new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
                                parameters: {
                                    action: "updateRefundPayment",
                                    paym: _payment_method,
                                    reconID: t
                                    },
                onSuccess: function(transport) {
                                    var response = new String(transport.responseText);
                                    if(response != ''){
//                                         alert(response);
                                    }
                                    Modalbox.hide();
                                    window.location.reload();
                                }.bind(this),
                                onException: function(instance, exception){
                                    Modalbox.hide();
                                    alert('Refund Loading Error: ' + exception);
                                }
                            });
        }else{
            alert("Please check fields");
        }
    }

    function setPIOvalueEdit(el){
        basename = "";
        if(type != ""){
            type = "";
            return;
        }
        if(el.id.match("_value_edit$")){
            basename = el.id.replace(/_value_edit$/g, "");
            type = "text";
        }
        if(el.id.match("_radio_edit$")){
            basename = el.id.replace(/_radio_edit$/g, "");
            type = "radio";
        }
        document.getElementById("total_value_edit").value = document.getElementById(basename + "_value_edit").value;
        if(type == "text")
            document.getElementById(basename + "_radio_edit").click();
        else
            document.getElementById(basename + "_value_edit").focus();
        type = "";
    }
    
    var _transNum = 0;

    function savePIOvalue(){
        _payment_method = "";
        _pay_direction = "";
		inputs = document.getElementsByTagName("input");
		for(a = 0; a < inputs.length; a++) {
			if(inputs[a].name == 'payment_method' && inputs[a].type == 'radio' && inputs[a].checked) {
                _payment_method = inputs[a].value;				
			}
            if(inputs[a].name == 'payout' && inputs[a].type == 'radio' && inputs[a].checked) {
                _pay_direction = inputs[a].value;
            }
		}
        
        _vendor = document.getElementById("vendor").value;
        _desc = document.getElementById("description").value;
        _total = document.getElementById("total_value").value;
        _date = document.getElementById("CashioDate").value;
        if(_payment_method != "" && _pay_direction != "" && _total != ""){
            new Ajax.Request( 'Cashio?rnd=' + Math.random() * 99999, { method: 'get',
                                parameters: {
                                    Action: "ADD",
                                    date: _date,
                                    payment_method: _payment_method,
                                    vendor: _vendor,
                                    description: _desc,
                                    total: _total,
                                    pay_direction: _pay_direction,
                                    transactionNumber: _transNum },
                onSuccess: function(transport) {
                                    var response = new String(transport.responseText);
                                    if(response != ''){
//                                         alert(response);
                                    }
                                    Modalbox.hide();
                                    window.location.reload();
                                }.bind(this),
                                onException: function(instance, exception){
                                    Modalbox.hide();
                                    alert('Cashio Loading Error: ' + exception);
                                }
                            });
        }else{
            alert("Please check fields");
        }
    }

    function editPIOvalue(){
        _payment_method = "";
        _pay_direction = "";
		inputs = document.getElementsByTagName("input");
		for(a = 0; a < inputs.length; a++) {
			if(inputs[a].name == 'payment_method' && inputs[a].type == 'radio' && inputs[a].checked) {
                _payment_method = inputs[a].value;
			}
            if(inputs[a].name == 'payout' && inputs[a].type == 'radio' && inputs[a].checked) {
                _pay_direction = inputs[a].value;
            }
		}

        _vendor = document.getElementById("vendor_edit").value;
        _desc = document.getElementById("description_edit").value;
        _total = document.getElementById("total_value_edit").value;
        _date = document.getElementById("CashioDate").value;
        _num_tran = document.getElementById("transNumEdit").value;
        _rec_id = document.getElementById("recID").value;
        if(_payment_method != "" && _pay_direction != "" && _total != ""){
            new Ajax.Request( 'Cashio?rnd=' + _num_tran, { method: 'get',
                                parameters: {
                                    Action: "EDIT",
                                    id: _rec_id,
                                    date: _date,
                                    payment_method: _payment_method,
                                    vendor: _vendor,
                                    description: _desc,
                                    total: _total,
                                    pay_direction: _pay_direction,
                                    transactionNumber: _num_tran },
                onSuccess: function(transport) {
                                    var response = new String(transport.responseText);
                                    if(response != ''){
//                                         alert(response);
                                    }
                                    Modalbox.hide();
                                    window.location.reload();
                                }.bind(this),
                                onException: function(instance, exception){
                                    Modalbox.hide();
                                    alert('Cashio Loading Error: ' + exception);
                                }
                            });
        }else{
            alert("Please check fields");
        }
    }

    function Click_Checkout_OpenDay(now_date)
    {
        var __now_date = now_date;
        new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
                            parameters: {
                                action: "checkOpenPrevDay",
                                date: __now_date
                            },
                            onSuccess: function(transport) {
                                var response = new String(transport.responseText);
                                if(response != ''){
                                     alert(response);
                                }
                                else
                                {
                                    Modalbox.show('./open_cash.jsp?dt='+now_date+'&rnd=' + Math.random() * 99999, {width: 1000});
                                }
                            }.bind(this),
                            onException: function(instance, exception){
                                alert('Error: ' + exception);
                            }
                        });
    }

    function mtRand(min, max)
    {
        var range = max - min + 1;
        var n = Math.floor(Math.random() * range) + min;
        return n;
    }

    function createTransNum()
    {
        var len=7;
        var tran = '';
        var rnd = 0;
        var c = '';
        for (i = 0; i < len; i++) {
            rnd = mtRand(0, 1);
            if (rnd == 0) {
                c = String.fromCharCode(mtRand(48, 57));
            }
            if (rnd == 1) {
                c = String.fromCharCode(mtRand(97, 122));
            }
            tran += c;
        }
        return tran;
    }

</script>
    

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
      var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
       if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
    }
        function showgiftcard() {
        var ctrl = document.getElementById("MB_windowGift");
        if (ctrl){
            if (ctrl.style.display == "none")
                ctrl.style.display = "block";
            else
                ctrl.style.display = "none";
        }
        ctrl = document.getElementById("MB_overlayGift");
        if (ctrl)
            if (ctrl.style.display == "none")
                ctrl.style.display = "block";
            else
                ctrl.style.display = "none";
        }
        function checkgiftcard(){
            var ctrl = document.getElementById("giftcardnumber").value;
            if (ctrl != 0){
            document.location = './checkout.do?idg='+ctrl;
            } else {
                alert("Please input a gift card number.");
            }
        }
        function findTicket(){
            var tck = document.getElementById("codeClientTicket").value;
            if (tck == ""){
                alert("Please enter client ticket number!");
            } else {
                document.location = "./checkout.do?dt=<%=dt%>&codet="+tck;
            }
        }
    //-->
    </script>
    <script type="text/javascript">
        function searchCustomer(){
            document.URL = location.href;//window.location.reload();
        }
        function searchEmployee(){
            document.URL = location.href;//window.location.reload();
        }
        function clearSearch(){
            document.getElementById("customer").value = "";
            //document.getElementById("employee").value = "";
            document.URL = location.href;//window.location.reload();
        }

    </script>
    </head>
	<body class="yui-skin-sam" topmargin="0" onload="MM_preloadImages('images/home red.gif','images/schedule red.gif','images/checkout.gif')">
    <input type="hidden" id="loc" name="loc" value="<%=loc%>"/>
	<div style="text-align:center">
    <div class="main" style = "width:1088px; text-align:left">
        <table width="100%">
        <tr valign="top">
            <%
                String activePage = "Checkout";
                String rootPath = "";
            %>
            <%@ include file="top_page.jsp" %>
        </tr>
		</table>
		<div style="height: 50px; overflow: hidden">
         <%@ include file="menu_main.jsp" %>
         <%--<div style = "text-align: right;">--%><%--<a style="color: white;" href = "./index.jsp"> Sign Out </a>--%><%--</div>--%>
         </div>
         <%--<div style = "text-align: right;">&nbsp;</div>--%>
        <div class="container">
         <div class="left">
                <%--<div id="InfoDiv" style="text-align:center">--%>
                    <%--<br  />--%>
                    <%--<%--%>
                        <%--String l;--%>
                        <%--if(location!=null){--%>
                            <%--l = location.getAddress();--%>
                            <%--String end = l.substring(l.lastIndexOf(" "));--%>
                            <%--String begin = l.substring(1, l.lastIndexOf(" "));--%>
                            <%--out.print("<img src='image?t=" + response.encodeURL(begin) + "&fs=11&c=FFFFFF' />");--%>
                            <%--out.print("<br /><b>");--%>
                            <%--out.print("<img src='image?t=" + response.encodeURL(end) + "&fs=12&c=FFFFFF' />");--%>
                            <%--out.print("</b>");--%>
                        <%--}--%>

                    <%--%><br  />--%>
                    <%--<br  />--%>
                <%--</div>--%>
				<div id="CalendarContainer">
                    <script type="text/javascript">
                    function dateChanged(calendar) {
                        //  In order to determine if a date was clicked you can use the dateClicked property of the calendar:
//                        if (calendar.dateClicked) {
                            // OK, a date was clicked, redirect to /yyyy/mm/dd/index.php
                            var y = calendar.date.getFullYear();
                            var m = calendar.date.getMonth(); // integer, 0..11
                            var d = calendar.date.getDate(); // integer, 1..31
                            // redirect...
                            window.location = "./checkout.do?dt=" + y + "/" + (1 + m) + "/" + d;
//                        }
                    };
                    Calendar.setup(
                        {
                            date : "<%=dt%>",
                            flat : "CalendarContainer", // ID of the parent element
                            flatCallback : dateChanged // our callback function
                        }
                    );
                    </script>
				</div>
                <div style="text-align:center;">
                    <br />
                    <img src="img/chkLegend.png" />
                </div>
                <br />
                <table  align=center width="139" height="30" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="3">
                            <img src="img/client_ticket_01.png" width="139" height="17" alt=""></td>
                    </tr>
                    <tr>
                        <td>
                            <img src="img/client_ticket_02.png" width="12" height="13" alt=""></td>
                        <td>
                            <!--img src="img/client_ticket_03.png" width="103" height="13" alt=""-->
                            <input id="codeClientTicket" type="text" style="border: 0; background: url(img/client_ticket_03.png); padding: 1px 0px 0px 5px;width: 103px; height: 20px;" />
                        </td>
                        <td>
                            <!--img src="img/client_ticket_04.png" width="24" height="13" alt=""-->
                            <input type="image" src="img/client_ticket_04.png" onclick="findTicket();"/>
                        </td>
                    </tr>
                </table>
                <br>
                 <table width="200" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="2"></td>
										<td align="left">
                                            <table width="180" border="0" cellspacing="0" cellpadding="0" class="left">
                                                <%--<tr>--%>
													<%--<td height="10">--%>
                                                        <%--<input type="button" class="transbutton" value="Gift Card" onclick="showgiftcard()" style="margin-left:10px;"/>--%>
													<%--</td>--%>
												<%--</tr>--%>
                                                <tr>
                                                    <td height="5"></td>
                                                </tr>
                                                    <%if (isEndDayAvailable) {%>
                                                    <tr><td>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td width="10"></td>
																<td class="c"></td>
																<td align="center">
                                                                    <!--a href="./theday.jsp?dt=<%=dt%>"-->
                                                                        <!--img border="0" src="img/recon_open_button.png" alt="">
                                                                        <input readonly type="text" style="vertical-align: bottom; 
                                                                            text-align:center; border:0; background: 
                                                                            url(img/recon_open_day_text.png) no-repeat; 
                                                                            width:143px; height: 32px; padding: 6px 5px 0px 5px;" 
                                                                            value="<%=startingDay.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                                                                            <br />
                                                                            <br /-->
                                                                 </td>
															</tr>
														</table>
                                                    </td></tr>
												<tr>
													<td><table width="100%" border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td width="10"></td>
																<td class="c"></td>
																<td align="center">
                                                                    <!--a href="./cashinout.jsp?dt=<%=dt%>">cash&nbsp;in/out</a-->
                                                                    <%--<a href="#" onclick="Modalbox.show('./cashinout.jsp?dt=<%=dt%>&rnd=' + Math.random() * 99999, {width: 1000});">--%>
                                                                    <a href="./cash_in_out.jsp?dt=<%=dt%>" >
                                                                    <img border="0" src="img/recon_pio_button.png" alt="" />
                                                                    </a>
                                                                </td>
															</tr>
														</table>
													</td>
												</tr>
												<tr>
													<td>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td width="10"></td>
																<td class="c"></td>
																<td align="center">
																<br>
                                                                <a href="./checkout.jsp?actio=add&dt=<%=dt%>">
                                                                    <img border="0" src="img/recon_add_trans_button.png" alt="">
                                                                </a></td>
															</tr>
														</table>
													</td>
												</tr>
                                                    <tr>
                                                        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="10"></td>
                                                                    <td class="c"></td>
                                                                    <td align="center">
                                                                        <!--a href="./theday.jsp?dt=<%=dt%>"-->
                                                                        <br>
                                                                        <a href="#" <%if (IsPending) {%> onclick = "alert('You cannot close Your day since there is still transaction pending.');" <%} else {%> onclick="Modalbox.show('./close_cash.jsp?dt=<%=dt%>&rnd=' + Math.random() * 99999, {width: 1000});"<%}%>>
                                                                            <img border="0" src="img/recon_close_button.png" alt="">
                                                                        </a></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <%} else if(isStartDayAvailable){%>
												<tr>
													<td>
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td width="10"></td>
																<td class="c"></td>
																<td align="center">
                                                                    <!--a href="./theday.jsp?dt=<%=dt%>"-->
                                                                    <a href="#" onclick="Click_Checkout_OpenDay('<%=dt_str%>');">
                                                                        <img border="0" src="img/recon_open_button.png" alt="">
                                                                    </a></td>
															</tr>
														</table>
													</td>
												</tr>
                                                    <%}%>
											</table>
										</td>
									</tr>
								</table>
			</div>

         <%--<div class="center">--%>
         <table>
         <tr>
             <td width="10px">

             </td>
         <td>
            <table width="801" height="789" border="0" cellspacing="0" cellpadding="3">
            <!--reconcilation header-->
            <tr>
                <td align=center width="33%" height="25"><%=dt_str%></td>
                <td align=center width="33%" height="25"><img src="img/rec_header.png" /></td>
                <td width="33%" height="25">&nbsp;</td>
            </tr>
            <!--end of reconcilation header-->

            <!--reconcilation table-->
            <tr>
            <td colspan="3" height="595" align=left valign=top>
                <table class="rec_header" cellpading=0 cellspacing='0' border=0>
                    <tr>
                        <td><img src="img/rec_table_trans.png" /></td>
                        <td><img src="img/rec_table_client.png" /></td>
                        <td><img src="img/rec_table_subtotal.png" /></td>
                        <td><img src="img/rec_table_tax.png" /></td>
                        <td><img src="img/rec_table_total.png" /></td>

                        <td><img src="img/rec_table_payment.png" /></td>
                        <td><img src="img/rec_table_action.png" /></td>
                    </tr>
                </table>
                <div style="width:800px; height: 480px; overflow-x: hidden; overflow-y:scroll">
                    <table class="rec" cellpading=0 cellspacing='0' border=0>
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
                            String bc = "#A7A9AC";

                            HashMap map = new HashMap();

                            for (int i = 0; i < list_trans.size(); i++)
                            {
                                Reconciliation tran = (Reconciliation) list_trans.get(i);
                                String trans_code = tran.getCode_transaction();
                                String cust = "";
                                Cashio cio = null;
                                if (tran.getStatus() == 3)
                                {
                                    cio = Cashio.findByReconciliationId(tran.getId());
                                    if (cio != null)
                                        cust = "PAYOUT " + cio.getVendor();
                                }
                                else
                                    if ((tran.getStatus() == 5))
                                    {
                                        cio = Cashio.findByReconciliationId(tran.getId());
                                        if (cio != null)
                                            cust = "PAYIN " + cio.getVendor();
                                    }
                                    else
                                    {
                                        cust =  (String) hm_cust.get(String.valueOf(tran.getId_customer()));
                                    }
                                BigDecimal s_total = BigDecimal.ZERO;
                                BigDecimal taxe =  BigDecimal.ZERO;
                                BigDecimal taxe_for_show =  BigDecimal.ZERO;
                                BigDecimal total = BigDecimal.ZERO;
                                BigDecimal cash = tran.getCashe();
                                BigDecimal change = tran.getChange();
                                BigDecimal amex = tran.getAmex();
                                BigDecimal visa = tran.getVisa();
                                BigDecimal mastercard = tran.getMastercard();
                                BigDecimal cheque = tran.getCheque();
                                BigDecimal giftcard = tran.getGiftcard();
                                String payment = tran.getPayment();

                                ArrayList list_ticket = Ticket.findTicketByLocCodeTrans(tran.getId_location(), tran.getCode_transaction());
                                if ((tran.getStatus() != 3) && (tran.getStatus() != 5) && (tran.getStatus() != 4))
                                {
                                    for (int m = 0; m < list_ticket.size(); m++)
                                    {
                                        Ticket tct = (Ticket)list_ticket.get(m);
                                        taxe_for_show = taxe = taxe.add(tct.getTaxe());
                                        s_total = s_total.add((tct.getPrice().multiply(new BigDecimal(tct.getQty()))).multiply(new BigDecimal(1).subtract((new BigDecimal(tct.getDiscount()).divide(new BigDecimal(100))))));
                                    }
                                }else {
                                    if (tran.getStatus() != 4)
                                        taxe_for_show = tran.getTaxe();
                                    taxe = tran.getTaxe();
                                    s_total = tran.getTotal();
                                }

                                if (tran.getStatus() == 4) {
                                    total = s_total;
                                }else{
                                    total = taxe.add(s_total);
                                }
                                if ((tran.getStatus() != 6) && (tran.getStatus() != 2))
                                {
                                    if ((tran.getStatus() != 4)||(!map.containsKey(tran.getCode_transaction())))
                                    {
                                        if (tran.getStatus() == 4)
                                            map.put(tran.getCode_transaction(), null);
                                        if (tran.getGiftcard().compareTo(new BigDecimal(0))==0){
                                        for (int j = 0; j < list_ticket.size(); j++)
                                        {
                                            Ticket ticket = (Ticket)list_ticket.get(j);
                                            if (tran.getStatus() == 4)
                                            {
                                                if (ticket.getService_id() != 0)
                                                {
                                                    if (ticket.getStatus() == 4)
                                                    {
                                                        sum_svc = sum_svc.subtract((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                                    }
                                                }
                                                else
                                                    if (ticket.getProduct_id() !=0)
                                                    {
                                                        if (ticket.getStatus() == 4)
                                                        {
                                                            sum_prod = sum_prod.subtract((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                                        }
                                                    }
                                            }
                                            else
                                            {
                                                if (ticket.getService_id() != 0)
                                                {
                                                    sum_svc = sum_svc.add((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                                }
                                                else
                                                    if (ticket.getProduct_id() !=0)
                                                    {
                                                        sum_prod = sum_prod.add((ticket.getPrice().multiply(new BigDecimal(ticket.getQty()))).multiply((new BigDecimal(1)).subtract((new BigDecimal(ticket.getDiscount())).divide(new BigDecimal(100)))));
                                                    }
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
                                    } else{
                                        total_cash = total_cash.add(cash).subtract(change);
                                        total_cheque = total_cheque.add(cheque);
                                        total_gift = total_gift.add(giftcard);
                                        total_card = total_card.add(amex).add(visa).add(mastercard);
                                        if (tran.getGiftcard().compareTo(new BigDecimal(0))==0) {
                                            total_tax = total_tax.add(taxe);
                                        }
                                    }
                                }

                            switch (tran.getStatus())
                            {
                                case 0: bc = "#c1c2c4"; break; //closed transaction
                                //case 1 deleted transaction
                                case 2: bc = "#9ccf78"; break; //pending (saved) transaction
                                case 3: bc = "#16c1f3"; payout = payout.add(total); break; //payout transaction
                                case 4: bc = "#812990"; refund = refund.add(total); break; //refunder transaction
                                case 5: bc = "#16c1f3"; payin = payin.add(total); break; //payin transaction
                                case 6: bc = "#f172ac"; break; //canceled transaction
                            }
                         %>
                         <tr>
                                <td style="width: 121px; background-color:<%=bc%>"><%=trans_code%></td>
                                <td style="width: 210px; background-color:<%=bc%>"><%=cust==null || cust.trim().equals("")?  "&nbsp;" : cust%></td>
                                <td style="width: 105px; background-color:<%=bc%>"><%=s_total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></td> <!--Total transaction price-->
                                <td style="width: 82px; background-color:<%=bc%>" ><%=taxe_for_show.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></td> <!--Total taxes of the transaction-->
                                <td style="width: 104px; background-color:<%=bc%>"><%=total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></td>
                                <td style="width: 59px; background-color:<%=bc%>"><%=payment.trim().equals("") ? "&nbsp;" : payment%></td>
                                <%--<td><%=null==null ? "&nbsp;" : cust%></td> <!--Status-->--%>
                                <td  style="width: 82px; background-color:<%=bc%>"><%--<img src="images/checkout9.gif" alt="add" onclick="location.href='./checkout.jsp?action=add&cust=<%=cust%>&dt=<%=dt%>'">--%>
                                   <%
                                       boolean ViewVisible = true;
                                       boolean EditVisible = true;
                                       boolean ViewVisiblePIO = false;
                                       boolean EditVisiblePIO = false;
                                       boolean EditVisibleREF = false;
                                       int status = -1;
                                       if(tran.getStatus() == 4){ // refund
                                           EditVisibleREF = true;
                                       }
                                       if(tran.getStatus() == 3 || tran.getStatus() == 5){ // pay io
                                           ViewVisible = EditVisible = false;
                                           ViewVisiblePIO = EditVisiblePIO = true;
                                       }
                                       if(tran.getStatus() == 4 || tran.getStatus() == 6){ // cancelled refund
                                           EditVisible = false;
                                       }
                                       status = tran.getStatus();
                                   %>
                                    <% if (ViewVisible) {%>
                                        <a href="./checkout.jsp?dt=<%=(find?dt_str:dt)%>&ct=<%=tran.getCode_transaction()%>&idc=<%=tran.getId_customer()%>&idt=<%=tran.getId()%>&tp=-1"><img src="img/rec_view_button.png" border="0"/></a>
                                    <%}%>
                                    <% if (EditVisible) {%>
                                        <a href="./checkout.jsp?dt=<%=(find?dt_str:dt)%>&ct=<%=tran.getCode_transaction()%>&idc=<%=tran.getId_customer()%>&idt=<%=tran.getId()%>&tp=2&st=<%=status%>"><img src="img/rec_edit_button.png" border="0"/></a>
                                    <%}%>
                                    <% if (ViewVisiblePIO) {%>
                                        <%--<a href="#" onclick="Modalbox.show('./cashinout.jsp?dt=<%=dt%>&action=view&tran=<%= tran.getCode_transaction()%>')">--%>
                                            <a href="./cash_in_out.jsp?dt=<%=dt%>&action=view&tran=<%= tran.getCode_transaction()%>" >
                                                <img src="img/rec_view_button.png" border="0"/></a>
                                    <%}%>
                                    <% if (EditVisiblePIO) {%>
                                        <%--<a href="#" onclick="Modalbox.show('./cashinout.jsp?dt=<%=dt%>&action=edit&tran=<%= tran.getCode_transaction()%>')">--%>
                                            <a href="./cash_in_out.jsp?dt=<%=dt%>&action=edit&tran=<%= tran.getCode_transaction()%>" >
                                                <img src="img/rec_edit_button.png" border="0"/></a>
                                    <%}%>
                                    <% if (EditVisibleREF) {%>
                                        <a href="#" onclick="Modalbox.show('./refund.jsp?dt=<%=dt%>&action=edit&idt=<%= tran.getId()%>&ct=<%= tran.getCode_transaction()%>')"><img src="img/rec_edit_button.png" border="0"/></a>
                                    <%}%>
                                    <% if (!EditVisible && !ViewVisible && !EditVisiblePIO && !ViewVisiblePIO) {%>
                                        &nbsp;
                                    <%}%>
                                        <a href="#" <% if (!isEndDayAvailable && !isStartDayAvailable) {%>onclick="alert('You cannot delete a transaction when the day is already closed.')" <%} else {%>onclick="Modalbox.show('./deletetran.jsp?dt=<%=dt%>&action=delete&tran=<%= tran.getId()%>')"<%}%>><img src="img/rec_delete_button.png" border="0"/></a>                 
                                </td>
                            </tr>
                            <%}%>
                        <%--<tr>--%>
                            <%--<td style="width: 121px;">1</td>--%>

                            <%--<td style="width: 210px;">2</td>--%>
                            <%--<td style="width: 105px;">3</td>--%>
                            <%--<td style="width: 82px;">4</td>--%>
                            <%--<td style="width: 104px;">5</td>--%>
                            <%--<td style="width: 59px;">6</td>--%>
                            <%--<td style="width: 52px;">--%>

                                <%--<a href="#"><img src="img/rec_delete_button.png" border="0"/></a>--%>
                                <%--<a href="#"><img src="img/rec_edit_button.png" border="0"/></a>--%>
                            <%--</td>--%>
                        <%--</tr>--%>


                    </table>
                </div>
                <div style="text-align:center; width: 100%">
                <img src="img/rec_hr1.png"/><br />
                </div>
                <br />
                <table id="Table_01" width="736" height="227" border="0" cellpadding="0" cellspacing="0" align=center>

                    <tr>
                        <td colspan="2">
                            <img src="img/reconcilation_final_01.png" width="91" height="16" alt=""></td>
                        <td colspan="3">
                            <img src="img/reconcilation_final_02.png" width="90" height="16" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_03.png" width="90" height="16" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_04.png" width="90" height="16" alt=""></td>

                        <td>
                            <img src="img/reconcilation_final_05.png" width="90" height="16" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_06.png" width="91" height="16" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_07.png" width="87" height="16" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_08.png" width="106" height="16" alt=""></td>
                        <td>

                            <img src="img/spacer.gif" width="1" height="16" alt=""></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <!--img src="img/reconcilation_final_09.png" width="91" height="36" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_09.png); width:91px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=sum_prod.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" />
                    </td>
                        <td colspan="3">
                            <!--img src="img/reconcilation_final_10.png" width="90" height="36" alt=""-->

                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_10.png); width:90px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=sum_svc.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_11.png" width="90" height="36" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_11.png); width:90px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=total_sub_total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_12.png" width="90" height="36" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_09.png); width:90px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=total_tax.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>

                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_13.png" width="90" height="36" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_13.png); width:90px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=payin.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_14.png" width="91" height="36" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_14.png); width:91px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=payout.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>

                        <td>
                            <!--img src="img/reconcilation_final_15.png" width="87" height="36" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_15.png); width:87px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=refund.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_16.png" width="106" height="36" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_16.png); width:106px; height: 36px; padding: 10px 5px 0px 5px;" value="<%=total_total.add(payin).subtract(payout).setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td>

                            <img src="img/spacer.gif" width="1" height="36" alt=""></td>
                    </tr>
                    <tr>
                        <td colspan="11">
                            <img src="img/reconcilation_final_17.png" width="735" height="13" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="1" height="13" alt=""></td>
                    </tr>
                    <tr>

                        <td rowspan="7">
                            <img src="img/reconcilation_final_18.png" width="18" height="161" alt=""></td>
                        <td colspan="2" rowspan="2">
                            <img src="img/reconcilation_final_19.png" width="101" height="31" alt=""></td>
                        <td rowspan="5" valign="bottom" align=right>
                            <!--img src="img/reconcilation_final_20.png" width="47" height="161" alt=""-->
                        </td>
                        <td colspan="2" rowspan="4">
                            <img src="img/reconcilation_final_21.png" width="105" height="60" alt=""></td>
                        <td>

                            <img src="img/reconcilation_final_22.png" width="90" height="20" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_23.png" width="90" height="20" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_24.png" width="91" height="20" alt=""></td>
                        <td>
                            <img src="img/reconcilation_final_25.png" width="87" height="20" alt=""></td>
                        <td rowspan="5">
                            <img src="img/reconcilation_final_26.png" width="106" height="94" alt=""></td>

                        <td>
                            <img src="img/spacer.gif" width="1" height="20" alt=""></td>
                    </tr>
                    <tr>
                        <td rowspan="2">
                            <!--img src="img/reconcilation_final_27.png" width="90" height="33" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_27.png); width:90px; height: 33px; padding: 8px 5px 0px 5px;" value="<%=total_card.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td rowspan="2">

                            <!--img src="img/reconcilation_final_28.png" width="90" height="33" alt=""-->
                            <input readonly type="text" id="cash_total" style="text-align:center; border:0; background: url(img/reconcilation_final_28.png); width:90px; height: 33px; padding: 8px 5px 0px 5px;" value="<%=total_cash.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td rowspan="2">
                            <!--img src="img/reconcilation_final_29.png" width="91" height="33" alt=""-->
                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_29.png); width:91px; height: 33px; padding: 8px 5px 0px 5px;" value="<%=total_cheque.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td rowspan="2">
                            <!--img src="img/reconcilation_final_30.png" width="87" height="33" alt=""-->

                            <input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_30.png); width:87px; height: 33px; padding: 8px 5px 0px 5px;" value="<%=total_gift.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                    </td>
                        <td>
                            <img src="img/spacer.gif" width="1" height="11" alt=""></td>
                    </tr>
                    <tr>
                        <td colspan="2" rowspan="2">
                            <!--img src="img/reconcilation_final_31.png" width="101" height="29" alt=""-->
                            <!--input type="image" src="img/reconcilation_final_31.png" /-->

                    </td>
                        <td>
                            <img src="img/spacer.gif" width="1" height="22" alt=""></td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <img src="img/reconcilation_final_32.png" width="358" height="7" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="1" height="7" alt=""></td>

                    </tr>
                    <tr>
                        <td colspan="2" height="1">
                            <!--img src="img/reconcilation_final_33.png" width="101" height="34" alt=""-->
                    </td>
                        <td colspan="2">
                            <!--img src="img/reconcilation_final_34.png" width="105" height="34" alt=""-->
                            <!--input type="image" src="img/reconcilation_final_34.png" /-->

                    </td>
                        <td>
                            <input type="hidden" id = "pennies_qty_" name = "pennies_qty_" value="<%=pennies_q%>"/>
                            <input type="hidden" id = "nickels_qty_" name = "nickels_qty_" value="<%=nickels_q%>"/>
                            <input type="hidden" id = "dimes_qty_" name = "dimes_qty_" value="<%=dimes_q%>"/>
                            <input type="hidden" id = "quarters_qty_" name = "quarters_qty_" value="<%=quarters_q%>"/>
                            <input type="hidden" id = "half_dollars_qty_" name = "half_dollars_qty_" value="<%=half_dollars_q%>"/>
                            <input type="hidden" id = "dollars_qty_" name = "dollars_qty_" value="<%=dollars_q%>"/>
                            <input type="hidden" id = "singles_qty_" name = "singles_qty_" value="<%=singles_q%>"/>
                            <input type="hidden" id = "fives_qty_" name = "fives_qty_" value="<%=fives_q%>"/>
                            <input type="hidden" id = "tens_qty_" name = "tens_qty_" value="<%=tens_q%>"/>
                            <input type="hidden" id = "twenties_qty_" name = "twenties_qty_" value="<%=twenties_q%>"/>
                            <input type="hidden" id = "fifties_qty_" name = "fifties_qty_" value="<%=fifties_q%>"/>
                            <input type="hidden" id = "hundreds_qty_" name = "hundreds_qty_" value="<%=hundreds_q%>"/>
                            <input type="hidden" id = "CashDrawingDate_" name = "CashDrawingDate_" value="<%=CashDrawingDate%>"/>
                            <%--<input type="hidden" id = "loc" name = "loc" value="<%=loc%>"/>--%>
                            <input type="hidden" id = "cashDrawing_id_" name = "cashDrawing_id_" value="<%=cd_id%>"/>
                            <%--<input type="hidden" id = "amex_amount_" name = "amex_amount_" value="<%=amex_amnt%>"/>--%>
                            <%--<input type="hidden" id = "visa_amount_" name = "visa_amount_" value="<%=visa_amnt%>"/>--%>
                            <%--<input type="hidden" id = "mastercard_amount_" name = "mastercard_amount_" value="<%=mastercard_amnt%>"/>--%>
                            <input type="hidden" id = "creditcard_" name = "creditcard_" value="<%=creditcard%>"/>
                            <input type="hidden" id = "check_amount_" name = "check_amount_" value="<%=cheque_amnt%>"/>
                            <input type="hidden" id = "cash_amount_" name = "cash_amount_" value="<%=cash_amnt%>"/>
                            <input type="hidden" id = "gift_amount_" name = "gift_amount_" value="<%=gift_amnt%>"/>
                            <input type="hidden" id = "employeeID_" name = "employeeID_" value="<%=_employeeID%>"/>
                            <input type="hidden" name="creditcard_over_" id="creditcard_over_" value="<%=card_over%>">
                            <input type="hidden" name="check_over_" id="check_over_" value="<%=cheque_over%>">
                            <input type="hidden" name="cash_over_" id="cash_over_" value="<%=cash_over%>">
                            <input type="hidden" name="gift_over_" id="gift_over_" value="<%=gift_over%>">
                            <input type="hidden" name="creditcard_short_" id="creditcard_short_" value="<%=card_short%>">
                            <input type="hidden" name="check_short_" id="check_short_" value="<%=cheque_short%>">
                            <input type="hidden" name="cash_short_" id="cash_short_" value="<%=cash_short%>">
                            <input type="hidden" name="gift_short_" id="gift_short_" value="<%=gift_short%>">


                            <!--img src="img/reconcilation_final_35.png" width="90" height="34" alt=""-->
                            <%--<input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_35.png); width:90px; height: 34px; padding: 8px 5px 0px 5px;" value="<%=creditcard.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>--%>
                            <div style="text-align:center; border:0; background: url(img/reconcilation_final_35.png); width:90px; height: 34px; " ><div style="color:black; padding: 11px 5px 0px 5px;"><%=creditcard.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></div></div>
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_36.png" width="90" height="34" alt=""-->
                            <%--<input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_36.png); width:90px; height: 34px; padding: 8px 5px 0px 5px;" value="<%=cash_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>--%>
                            <div style="text-align:center; border:0; background: url(img/reconcilation_final_36.png); width:90px; height: 34px; " ><div style="color:black; padding: 11px 5px 0px 5px;"><%=cash_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></div></div>
                    </td>

                        <td>
                            <!--img src="img/reconcilation_final_37.png" width="91" height="34" alt=""-->
                            <%--<input readonly type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_37.png); width:91px; height: 34px; padding: 8px 5px 0px 5px;" value="<%=cheque_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>--%>
                            <div style="text-align:center; border:0; background: url(img/reconcilation_final_37.png); width:91px; height: 34px; " ><div style="color:black; padding: 11px 5px 0px 5px;"><%=cheque_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></div></div>
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_38.png" width="87" height="34" alt=""-->
                            <%--<input readonly id="reconcilation_final_38.png" type="text" style="text-align:center; border:0; background: url(img/reconcilation_final_38.png); width:87px; height: 34px; padding: 8px 5px 0px 5px;" value="<%=gift_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" />--%>
                            <div style="text-align:center; border:0; background: url(img/reconcilation_final_38.png); width:87px; height: 34px; " ><div style="color:black; padding: 11px 5px 0px 5px;"><%=gift_amnt.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></div></div>
                    </td>
                        <td>

                            <img src="img/spacer.gif" width="1" height="34" alt=""></td>
                    </tr>
                    <tr>
                        <td colspan="3" rowspan="2" valign=center align=right>
                            <!--img src="img/reconcilation_final_39.png" width="101" height="67" alt=""-->
                            <input type="text" style="vertical-align: bottom; text-align:center; border:0; background: url(img/checkout_starting_day2.png) no-repeat; width:105px; height: 35px; margin-top: 3px;" />                            
                            <input readonly type="text" style="vertical-align: bottom; text-align:center; border:0; background: url(img/checkout_starting_day.png) no-repeat; width:105px; height: 35px; padding: 6px 5px 0px 5px;" value="<%=startingDay.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"/>
                        </td>
                        <td colspan="2">
                            <img src="img/reconcilation_final_40.png" width="105" height="35" alt=""></td>
                        <td>
                            <!--img src="img/reconcilation_final_41.png" width="90" height="35" alt=""-->

                            <input readonly type="text" value="<%=card_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_41.png); width:90px; height: 35px; padding: 9px 5px 0px 5px;" />
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_42.png" width="90" height="35" alt=""-->
                            <input readonly type="text" value="<%=cash_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_42.png); width:90px; height: 35px; padding: 9px 5px 0px 5px;" />
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_43.png" width="91" height="35" alt=""-->
                            <input readonly type="text" value="<%=cheque_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_43.png); width:91px; height: 35px; padding: 9px 5px 0px 5px;" />

                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_44.png" width="87" height="35" alt=""-->
                            <input readonly type="text" value="<%=gift_over.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_44.png); width:87px; height: 35px; padding: 9px 5px 0px 5px;" />
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_45.png" width="106" height="35" alt=""-->
                            <style>
                            span.radio7 {
                              width: 29px;
                              height: 29px;
                              padding: 0 5px 0 0;
                              background: url(img/ro_check.png) no-repeat;
                              display: block;
                              clear: left;
                              float: left;
                            }
                            </style>
                            <script src="Js/custom-form-elements7.js"></script>
                            <script>
                                function send_report(){
                                    if(document.getElementById("print_report").checked){
                                        document.location.href='./report?query=closingdetails&varCurDate=<%=dt_str%>'
                                    }else if(document.getElementById("email_report").checked)
                                    {
                                        new Ajax.Request( './report?rnd=' + Math.random() * 99999, { method: 'get',
                                            parameters: {
                                                query: "closingdetailsemail",
                                                varCurDate: '<%=dt_str%>'
                                            },
                                            onSuccess: function(transport) {
                                                var response = new String(transport.responseText);
                                                if(response != '')
                                                {
                                                    alert(response);
                                                }
                                            }.bind(this),
                                            onException: function(instance, exception){
                                                alert('Error send email: ' + exception);
                                            }
                                            });
                                    }
                                    Modalbox.hide();
                                }
                            </script>
                            <input type="image" src="img/reconcilation_final_45.png"  
                                onclick="
                                    Modalbox.show('./report_options.jsp?dt=<%=dt%>&rnd=' + Math.random() * 99999, {width: 600});
                                    
                                " />
                    </td>

                        <td>
                            <img src="img/spacer.gif" width="1" height="35" alt=""></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <img src="img/reconcilation_final_46.png" width="105" height="32" alt=""></td>
                        <td>
                            <!--img src="img/reconcilation_final_47.png" width="90" height="32" alt=""-->
                            <input readonly type="text" value="<%=card_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_47.png); width:90px; height: 32px; padding: 8px 5px 0px 5px;" />

                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_48.png" width="90" height="32" alt=""-->
                            <input readonly type="text" value="<%=cash_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_48.png); width:90px; height: 32px; padding: 8px 5px 0px 5px;" />
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_49.png" width="91" height="32" alt=""-->
                            <input readonly type="text" value="<%=cheque_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_49.png); width:91px; height: 32px; padding: 8px 5px 0px 5px;" />
                    </td>

                        <td>
                            <!--img src="img/reconcilation_final_50.png" width="87" height="32" alt=""-->
                            <input readonly type="text" value="<%=gift_short.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="text-align:center; border:0; background: url(img/reconcilation_final_50.png); width:87px; height: 32px; padding: 8px 5px 0px 5px;" />
                    </td>
                        <td>
                            <!--img src="img/reconcilation_final_51.png" width="106" height="32" alt=""-->
                            <% CashDrawing cd_temp = CashDrawing.findByDateStatus(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), 1);
                                if (cd_temp != null) { %>
                                    <input type="image" src="img/reconcilation_final_51.png" <%if (IsPending) {%> onclick = "alert('You cannot close Your day since there is still transaction pending.');" <%} else {%>onclick="if (confirm('Are you sure you want to close <%=dt_str%>?'))saveCashDrawing_(2);"<%}%>/>
                                <%}%>
                    </td>
                        <td>

                            <img src="img/spacer.gif" width="1" height="32" alt=""></td>
                    </tr>
                    <tr>
                        <td>
                            <img src="img/spacer.gif" width="18" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="73" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="28" height="1" alt=""></td>

                        <td>
                            <img src="img/spacer.gif" width="47" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="15" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="90" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="90" height="1" alt=""></td>
                        <td>

                            <img src="img/spacer.gif" width="90" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="91" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="87" height="1" alt=""></td>
                        <td>
                            <img src="img/spacer.gif" width="106" height="1" alt=""></td>
                        <td></td>
                    </tr>

                </table>
                
                <%--<table width="629" height="54" border="0" cellpadding="0" cellspacing="0">--%>

                    <%--<tr>--%>
                        <%--<td>&nbsp;</td>--%>
                        <%--<td><img src="img/rec_02.png" width="103" height="21" alt=""></td>--%>
                        <%--<td><img src="img/rec_03.png" width="104" height="21" alt=""></td>--%>
                        <%--<td><img src="img/rec_04.png" width="83" height="21" alt=""></td>--%>
                        <%--<td><img src="img/rec_05.png" width="106" height="21" alt=""></td>--%>
                    <%--</tr>--%>
                    <%--<tr>--%>
                        <%--<td><img src="img/rec_07.png" width="229" height="33" alt=""></td>--%>

                        <%--<td>--%>
                            <%--<input type="text" style="background-image: url(img/rec_08.png); width: 103px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=total_total%>">--%>
                        <%--</td>--%>
                        <%--<td>--%>
                            <%--<input type="text" style="background-image: url(img/rec_09.png); width: 104px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px">--%>
                        <%--</td>--%>
                        <%--<td>--%>
                            <%--<input type="text" style="background-image: url(img/rec_10.png); width: 83px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=total_tax%>">--%>
                        <%--</td>--%>

                        <%--<td>--%>
                            <%--<input type="text" style="background-image: url(img/rec_11.png); width: 106px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=total_sub_total%>">--%>
                        <%--</td>--%>
                    <%--</tr>--%>
                <%--</table>--%>

                <%--<img src="img/rec_hr2.png" /><br />--%>
                <%--<br />--%>
                <%--<table id="Table_01" width="760" height="115" border="0" cellpadding="0" cellspacing="0">--%>
                <%--<tr>--%>

                    <%--<td colspan="2">--%>
                        <%--<img src="img/rec2_01.png" width="125" height="20" alt=""></td>--%>
                    <%--<td colspan="2">--%>
                        <%--<img src="img/rec2_02.png" width="127" height="20" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/rec2_03.png" width="129" height="20" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/rec2_04.png" width="126" height="20" alt=""></td>--%>
                    <%--<td>--%>

                        <%--<img src="img/rec2_05.png" width="126" height="20" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/rec2_06.png" width="127" height="20" alt=""></td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<td colspan="2">--%>
                        <%--<input type="text" style="background-image: url(img/rec2_07.png); width: 125px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=sum_prod%>">--%>
                    <%--</td>--%>
                    <%--<td colspan="2">--%>

                        <%--<input type="text" style="background-image: url(img/rec2_08.png); width: 127px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=sum_svc%>">--%>
                    <%--</td>--%>
                    <%--<td>--%>
                        <%--<input type="text" style="background-image: url(img/rec2_09.png); width: 129px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=total_card%>">--%>
                    <%--</td>--%>
                    <%--<td>--%>
                        <%--<input type="text" style="background-image: url(img/rec2_10.png); width: 126px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=total_cash%>">--%>
                    <%--</td>--%>
                    <%--<td>--%>

                        <%--<input type="text" style="background-image: url(img/rec2_11.png); width: 126px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=total_cheque%>">--%>
                    <%--</td>--%>
                    <%--<td>--%>
                        <%--<input type="text" style="background-image: url(img/rec2_12.png); width: 127px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px" value="<%=total_gift%>">--%>
                    <%--</td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<td colspan="4">--%>
                        <%--<img src="img/rec2_13.png" width="252" height="25" alt=""></td>--%>

                    <%--<td rowspan="2">--%>
                        <%--<img src="img/rec2_14.png" width="129" height="26" alt=""></td>--%>
                    <%--<td colspan="3" rowspan="3">--%>
                        <%--<img src="img/rec2_15.png" width="379" height="61" alt=""></td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<td colspan="3">--%>
                        <%--<img src="img/rec2_16.png" width="187" height="1" alt=""></td>--%>
                    <%--<td rowspan="2">--%>

                        <%--<img src="img/rec2_17.png" width="65" height="36" alt=""></td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<td>--%>
                        <%--<img src="img/rec2_18.png" width="64" height="35" alt=""></td>--%>
                    <%--<td colspan="2">--%>
                        <%--<input type="text" style="background-image: url(img/rec2_19.png); width: 123px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px">--%>
                    <%--</td>--%>
                    <%--<td>--%>

                        <%--<input type="text" style="background-image: url(img/rec2_20.png); width: 129px; height: 33px; border: 0; padding-top: 8px; padding-left: 5px; padding-right: 6px">--%>
                    <%--</td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<td>--%>
                        <%--<img src="img/spacer.gif" width="64" height="1" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/spacer.gif" width="61" height="1" alt=""></td>--%>
                    <%--<td>--%>

                        <%--<img src="img/spacer.gif" width="62" height="1" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/spacer.gif" width="65" height="1" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/spacer.gif" width="129" height="1" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/spacer.gif" width="126" height="1" alt=""></td>--%>
                    <%--<td>--%>
                        <%--<img src="img/spacer.gif" width="126" height="1" alt=""></td>--%>

                    <%--<td>--%>
                        <%--<img src="img/spacer.gif" width="127" height="1" alt=""></td>--%>
                <%--</tr>--%>
                <%--</table>--%>


            </td>
            </tr>
            <!--end of reconcilation table-->
            <tr>
                <td colspan="3" height="169">
                </td>

            </tr>
            </table>

            <%--<table width="100%" border="0" cellspacing="0" cellpadding="0">--%>
                                    <%--<form action="./checkout.do?dt=<%=dt%>" method="post">--%>
                                    <%--<tr colspan = "3">--%>
                                    <%--<td height="7"></td>--%>
                                    <%--</tr>--%>
                                    <%--<tr>--%>
                                    <%--<td align = "left">--%>
                                    <%--Employee:--%>
                                    <%--<select name="emp" id="emp" class="STYLE18" onchange="submit();">--%>
                                        <%--<option value="allemployee">- Select all -</option>--%>
                                        <%--<%for(int i=0; i<list_emp.size(); i++){--%>
                                            <%--Employee emp = (Employee)list_emp.get(i);--%>
                                            <%--if (p_emp.equals(String.valueOf(emp.getId()))) {--%>
                                        <%--%>--%>
                                            <%--<option value="<%=emp.getId()%>" selected><%=emp.getFname() + " " + emp.getLname()%></option>--%>
                                        <%--<%} else {%>--%>
                                        <%--<option value="<%=emp.getId()%>"><%=emp.getFname() + " " + emp.getLname()%></option>--%>
                                        <%--<%}}%>--%>
                                    <%--</select>--%>
                                    <%--</td>--%>
                                    <%--<td align = "right" colspan="2">--%>
                                    <%--Customer:--%>
                                        <%--<input type="text" name="customer" id="customer"><a onclick="searchCustomer()"><img alt="search" src="./images/search.gif"></a>--%>
                                    <%--<button id="clear" name="clear" onclick="clearSearch()">Clear</button>--%>
                                        <%--<select name="cust" id="cust" class="STYLE18" onchange="submit();">--%>
                                            <%--<option value="allcustomer">- Select all -</option>--%>
                                            <%--<%for(int i=0; i<list_cust.size(); i++){--%>
                                                <%--Customer cust = (Customer)list_cust.get(i);--%>
                                                <%--if (p_cust.equals(String.valueOf(cust.getId()))) {--%>
                                            <%--%>--%>
                                            <%--<option value="<%=cust.getId()%>" selected><%=cust.getFname() + " " + cust.getLname()%></option>--%>
                                            <%--<%} else {%>--%>
                                            <%--<option value="<%=cust.getId()%>"><%=cust.getFname() + " " + cust.getLname()%></option>--%>
                                            <%--<%}}%>--%>
                                        <%--</select>--%>
                                    <%--</td>--%>
                                    <%--</form>--%>
                                    <%--</tr>--%>
									<%--<tr>--%>
										<%--<td colspan="3" align="left">--%>
                                            <%--<table width="700" border="1" align="left" cellpadding="0" cellspacing="0" id="f">--%>
												<%--<tr align="center" >--%>
													<%--<td width="60" height="24">Trans #</td>--%>
													<%--<td width="80" nowrap>Employee</td>--%>
													<%--<td width="90" nowrap>Customer</td>--%>
													<%--<td width="90" nowrap>Total transaction price</td>--%>
													<%--<td width="90" nowrap>Total taxes of the transaction</td>--%>
													<%--<td width="90" nowrap>Total item on this transaction</td>--%>
													<%--<td width="90" nowrap>Pt Method</td>--%>
													<%--<td width="90" nowrap>Status</td>--%>
													<%--<td width="90" nowrap>Action</td>--%>
													<%--<!--<td width="50">Type</td>-->--%>
													<%--<td width="80" nowrap>Serivce</td>--%>
													<%--<td width="85" nowrap>Prod Name</td>--%>
													<%--<td width="60" nowrap>Prod #</td>--%>
													<%--<td width="80">Pt Method</td>--%>
													<%--<td width="115" nowrap>Action</td>--%>
												<%--</tr>--%>

                                                <%--<%--%>
                                                    <%--BigDecimal cash = new BigDecimal(0.0);--%>
                                                    <%--BigDecimal card = new BigDecimal(0.0);--%>
                                                    <%--BigDecimal cheque = new BigDecimal(0.0);--%>
                                                    <%--BigDecimal gift = new BigDecimal(0.0);--%>
                                                    <%--BigDecimal sum_svc = new BigDecimal(0.0);--%>
                                                    <%--BigDecimal sum_prod = new BigDecimal(0.0);--%>
                                                    <%--for (int i = 0; i < list_trans.size(); i++) {--%>
                                                        <%--Transaction tran = (Transaction) list_trans.get(i);--%>
                                                        <%--if ((p_emp.equals("allemployee") | p_emp.equals(String.valueOf(tran.getEmployee_id()))) & (p_cust.equals("allcustomer") | p_cust.equals(String.valueOf(tran.getCustomer_id())))){--%>
                                                        <%--String empl = (String) hm_emp.get(String.valueOf(tran.getEmployee_id()));--%>
                                                        <%--String cust = (String) hm_cust.get(String.valueOf(tran.getCustomer_id()));--%>
                                                        <%--String svc = (String) hm_svc.get(String.valueOf(tran.getService_id()));--%>
                                                        <%--String prod = (String) hm_prod.get(String.valueOf(tran.getProduct_id()));--%>
                                                        <%--BigDecimal price = tran.getPrice();--%>
                                                        <%--BigDecimal tax = tran.getTax();--%>
                                                        <%--BigDecimal disc = tran.getDiscount();--%>
                                                        <%--BigDecimal total = new BigDecimal(0.0);--%>
                                                        <%--total = total.add(price).add(tax);--%>
                                                        <%--total = total.subtract(total.multiply(disc.divide(new BigDecimal(100))));--%>
                                                        <%--String payment = tran.getPayment();--%>
                                                        <%--String[] paymarr = payment.split(";");--%>
                                                        <%--for (int j=0; j<paymarr.length; j++){--%>
                                                            <%--String[] paym = paymarr[j].split("=");--%>
                                                            <%--if ((paym[0].toLowerCase().equalsIgnoreCase("amex")) | (paym[0].toLowerCase().equalsIgnoreCase("visa")) | (paym[0].toLowerCase().equalsIgnoreCase("mastercard")))--%>
                                                                <%--if (paym.length > 1){--%>
                                                                    <%--card = card.add(new BigDecimal(paym[1]));--%>
                                                                <%--}else {--%>
                                                                    <%--card = card.add(total);--%>
                                                                <%--}--%>
                                                            <%--else if (paym[0].toLowerCase().equalsIgnoreCase("cheque"))--%>
                                                                <%--if (paym.length > 1){--%>
                                                                <%--cheque = cheque.add(new BigDecimal(paym[1]));--%>
                                                                <%--}else {--%>
                                                                    <%--cheque = cheque.add(total);--%>
                                                                <%--}--%>
                                                            <%--else if (paym[0].toLowerCase().equalsIgnoreCase("cash"))--%>
                                                                <%--if (paym.length > 1){--%>
                                                                <%--cash = cash.add(new BigDecimal(paym[1]));--%>
                                                                <%--}else {--%>
                                                                    <%--cash = cash.add(total);--%>
                                                                <%--}--%>
                                                            <%--else if (paym[0].toLowerCase().contains("giftcard"))--%>
                                                                <%--if (paym.length > 1){--%>
                                                                <%--gift = gift.add(new BigDecimal(paym[1]));--%>
                                                                <%--}else {--%>
                                                                    <%--gift = gift.add(total);--%>
                                                                <%--}--%>
                                                            <%--else if (paym[0].toLowerCase().equalsIgnoreCase("cashin"))--%>
                                                                <%--cash = cash.add(price);--%>
                                                            <%--else if (paym[0].toLowerCase().equalsIgnoreCase("cashout"))--%>
                                                                <%--cash = cash.add(price);--%>
                                                        <%--}--%>
                                                        <%--if (svc != null){--%>
                                                            <%--sum_svc = sum_svc.add(total);--%>
                                                        <%--}else if (prod != null){--%>
                                                            <%--sum_prod = sum_prod.add(total);--%>
                                                        <%--}--%>

                                                <%--%>--%>
                                                <%--<tr>--%>
													<%--<td class="g"><%=tran.getCode()%></td>--%>
													<%--<td><%=empl==null ? "&nbsp;" : empl%></td>--%>
													<%--<td><%=cust==null ? "&nbsp;" : cust%></td>--%>
													<%--<td><%=price.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></td> <!--Total transaction price-->--%>
													<%--<td><%=tax.setScale(2,BigDecimal.ROUND_HALF_DOWN)%></td> <!--Total taxes of the transaction-->--%>
													<%--<!--<td>&nbsp;</td>-->--%>
													<%--<td><%=svc==null ? "&nbsp;" : svc%></td>--%>
													<%--<td><%=prod==null ? "&nbsp;" : prod%></td>--%>
													<%--<td><%=tran.getProd_qty() > 0 ? String.valueOf(tran.getProd_qty()) : "&nbsp;"%></td> <!--Total item on this transaction-->--%>
                                                    <%--<td><%=tran.getPayment()%></td>--%>
                                                    <%--<td><%=null==null ? "&nbsp;" : cust%></td> <!--Status-->--%>
													<%--<td align="center">--%><%--<img src="images/checkout9.gif" alt="add" onclick="location.href='./checkout.jsp?action=add&cust=<%=cust%>&dt=<%=dt%>'">--%>
                                                        <%--<%if (theday != null) {--%>
                                                        <%--if (theday.getAdjustment() == null | theday.getPutinenv() == null) {--%>
                                                        <%--if (!(tran.getPayment().equals("cashin") | tran.getPayment().equals("cashout"))) {--%>
                                                        <%--%>--%>
                                                        <%--<a href="./checkout.do?id2=<%=tran.getId()%>&dt=<%=dt%>">view</a>--%>
                                                        <%--<a href="./checkout.do?id2=<%=tran.getId()%>&dt=<%=dt%>&act=2">edit</a>--%>
                                                        <%--<a href="./checkout.jsp?action=edit&code=<%=tran.getCode()%>&dt=<%=dt%>">edit</a>  --%>
                                                        <%--<%}%>--%>
                                                        <%--<a href="./check-out.do?action=delete&id=<%=tran.getId()%>&dt=<%=dt%>">delete</a>--%>
                                                        <%--<a href="#" onclick="if(confirm('Do you really want to delete?')) location.href='./check-out.do?action=delete&id=<%=tran.getId()%>&dt=<%=dt%>'" >delete</a>--%>
                                                        <%--<img src="images/chkview.gif" alt="view" onclick="location.href='./checkout.do?id=<%=tran.getId()%>&dt=<%=dt%>'">--%>
                                                        <%--<img src="images/checkout10.gif" alt="edit" onclick="location.href='./checkout.jsp?action=edit&code=<%=tran.getCode()%>&dt=<%=dt%>'">--%>
                                                        <%--<img src="images/checkout11.gif" alt="delete" onclick="if(confirm('Do you really want to delete?')) location.href='./check-out.do?action=delete&id=<%=tran.getId()%>&dt=<%=dt%>'">--%>
                                                        <%--<%} else %>&nbsp;<% }%>--%>
													<%--</td>--%>
												<%--</tr>--%>
                                                <%--<%}}%>--%>

                                                <%--<tr>--%>
													<%--<td height="33" rowspan="2" colspan="2" class="STYLE3" align="center"><span class="STYLE5">Daily Total: </span></td>--%>
													<%--<td colspan="7">--%>
                                                            <%--<span class="STYLE4">Cash: $<%=cash.add(gift)%></span>--%>
															<%--<span class="STYLE6">Credit card: $<%=card%></span>--%>
															<%--<span class="STYLE7">Check: $<%=check%> </span>--%>
                                                        <%--<table width="100%">--%>
                                                            <%--<tr>--%>
                                                                <%--<td class="STYLE4">--%>
                                                                    <%--Total cash: $<%=cash.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>--%>
                                                                <%--</td>--%>
                                                                <%--<td class="STYLE6">--%>
                                                                    <%--Total credit: $<%=card.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>--%>
                                                                <%--</td>--%>
                                                                <%--<td class="STYLE7">--%>
                                                                    <%--Total checks: $<%=cheque.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>--%>
                                                                <%--</td>--%>
                                                                <%--<td>--%>
                                                                    <%--Total giftcard: $<%=gift.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>--%>
                                                                <%--</td>--%>
                                                            <%--</tr>--%>
                                                        <%--</table>--%>
                                                    <%--</td>--%>
												<%--</tr>--%>
                                                <%--<tr>--%>
                                                    <%--<td colspan="7">--%>
                                                        <%--<table width="100%">--%>

                                                            <%--<tr>--%>
                                                                <%--<td>--%>
                                                                    <%--Total daily sold service: $<%=sum_svc.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>--%>
                                                                <%--</td>--%>
                                                                <%--<td>--%>
                                                                    <%--Total daily sold product: $<%=sum_prod.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>--%>
                                                                <%--</td>--%>
                                                            <%--</tr>--%>
                                                        <%--</table>--%>
                                                    <%--</td>--%>
                                                <%--</tr>--%>
											<%--</table>--%>
										<%--</td>--%>
									<%--</tr>--%>
									<%--<tr align="center" valign="bottom">--%>
										<%--<td align="center">--%>
                                            <%--<div class="copyright">--%>
                                                <%--<table >--%>
                                                    <%--<tr ><td>@Copyright 2009, esalonsoft.com | <a href="http://esalonsoft.com/">disclaimer</a></td></tr>--%>
                                                    <%--<tr ><td>All Rights Reserved.</td></tr>--%>
                                                <%--</table>--%>
                                            <%--</div>--%>
                                        <%--</td>--%>
                                    <%--</tr>--%>
                                        <%--</form>--%>
								<%--</table>--%>
        </td>
        </tr>
        </table>
        <%--</div>--%>

         </div>

<script type="text/javascript">
    YAHOO.namespace("example.container");

    function init() {
        // Define various event handlers for Dialog
        var handleSubmit = function() {
            this.submit();
        };
        var handleCancel = function() {
            this.cancel();
        };
        var handleSuccess = function(o) {
            var rsArray = o.responseText.split("~~");
            if (document.getElementById("code").value == rsArray[0]) {
                document.getElementById("cdt").value = 'now';
                var msg = "Giftcard #" + rsArray[0] + " was saved.";
                document.getElementById("resp").innerHTML = msg + '<br/>' + "Amount is " + rsArray[1];
                alert(msg);
            }
        };
        var handleFailure = function(o) {
            alert("Submission failed: " + o.status);
        };

        // Instantiate the Dialog
        YAHOO.example.container.dialog1 = new YAHOO.widget.Dialog("dialog1",
        { width : "30em",
            fixedcenter : true,
            visible : false,
            constraintoviewport : true,
            buttons : [ { text:"Submit", handler:handleSubmit, isDefault:true },//
                { text:"Cancel", handler:handleCancel } ]
        });

        // Validate the entries in the form to require that both first and last name are entered
        YAHOO.example.container.dialog1.validate = function() {
            var data = this.getData();
            if (data.code == "" || data.amount == "") {
                alert("Serial number or amount cann't be empty.");
                return false;
            } else {
                return true;
            }
        };

        // Wire up the success and failure handlers
        YAHOO.example.container.dialog1.callback = { success: handleSuccess, failure: handleFailure };

        // Render the Dialog
        YAHOO.example.container.dialog1.render();

        YAHOO.util.Event.addListener("show", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        //YAHOO.util.Event.addListener("hide", "click", YAHOO.example.container.dialog1.hide, YAHOO.example.container.dialog1, true);
    }

    YAHOO.util.Event.onDOMReady(init);
</script>

<div id="dialog1">
    <div class="hd">Please enter the giftcard amount</div>
    <div class="bd">
        <form method="POST" action="chkqry?query=giftcard">
            <label for="code">Serial Number:</label><input type="text" id="code" name="code" readonly/>
            <!--<label for="cdt">Created Date:</label><input type="text" id="cdt" name="cdt" />--><input type="hidden"
                                                                                                         id="cdt"
                                                                                                         name="cdt"
                                                                                                         value=''/>
            <label for="amount">Amount:</label><input type="text" id="amount" name="amount"/>

            <label for="payment">Payment:</label>
            <select name="payment" id="payment">
                <option value="Cash">Cash</option>
                <option value="Amex">Amex</option>
                <option value="Visa">Visa</option>
                <option value="MasterCard">MasterCard</option>
                <option value="Check">Check</option>
            </select>

            <div class="clear"></div>
        </form>
    </div>
</div>
            <%

                if (!id_trans.equals("")) {
                    int num = Integer.parseInt(id_trans);
                    Transaction trn = Transaction.findById(num);
                    BigDecimal price = trn.getPrice().setScale(2);
                    BigDecimal tax = trn.getTax().setScale(2);
                    BigDecimal disc = trn.getDiscount().setScale(2);
                    BigDecimal qty = BigDecimal.valueOf(trn.getProd_qty()).setScale(2);
                    BigDecimal total = price.subtract(price.multiply(disc).divide(BigDecimal.valueOf(100))).multiply(qty).setScale(2);
                    BigDecimal totalprice = new BigDecimal(0);
                    totalprice = totalprice.add(price).add(tax);
                    totalprice = totalprice.subtract(totalprice.multiply(disc.divide(BigDecimal.valueOf(100)))).multiply(qty).setScale(2);
            %>
<div id="MB_window" style="overflow: visible; width: 700px; height: 229px; left: 354px;" >
    <div id="MB_frame" style="bottom: 0px;">
        <div id="MB_header"><div id="MB_caption"><%if (act.equals("2")) {%>Edit<%}else {%>View<%}%></div><a id="MB_close" <%--href="./checkout.do?dt=<%=dt%>"--%> onclick="location.href='./checkout.do?dt=<%=dt%>'" title="Close window" href="#"><span>x</span></a></div>
        <div id="MB_content" style="position: relative;">
<%--<style type="text/css"> @import url( "/css/default.css" );</style>--%>

        <table class="STYLE21" >
            <tbody><tr>
                <td>Price:</td>
                <td>
                    <%=price%>
                </td>
            </tr>
            <tr>
                <td>Taxes:</td>
                <td><%=tax%></td>
            </tr>
            <tr>
                <td>Discount:</td>
                <td><%=disc%></td>
            </tr>
            <tr>
                <td>Total:</td>
                <td><%=totalprice%></td>
            </tr>

        </tbody></table>

        <table width="100%" class="STYLE20" border="1">
            <thead>
                <tr>
                    <th>Trans#</th>
                    <th>Employee</th>
                    <th>Service or Product title</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Taxes</th>
                    <th>Total</th>
                </tr>
            </thead>
                <tbody>
                            <%
                                String empl = (String) hm_emp.get(String.valueOf(trn.getEmployee_id()));
//                                String cust = (String) hm_cust.get(String.valueOf(trn.getCustomer_id()));
                                String svc = (String) hm_svc.get(String.valueOf(trn.getService_id()));
                                String prod = (String) hm_prod.get(String.valueOf(trn.getProduct_id()));
//                                String price = String.valueOf(trn.getPrice());
//                                String tax = String.valueOf(trn.getTax());
                            %>
                             <tr>
                                <td><%=trn.getId()%></td>
                                <td><%=empl==null ? "&nbsp;" : empl%></td>
                                <%if (svc != null){%>
                                    <td><%=svc==null ? "&nbsp;" : svc%></td>
                                <%}else if (prod != null){%>
                                    <td><%=prod==null ? "&nbsp;" : prod%></td>
                                <%}%>
                                 <td><%=qty%></td>
                                 <td><%=price%></td>
                                 <td><%=tax%></td>
                                 <td><%=totalprice%></td>
                            </tr>
                            <%--<tr>--%>
                            <%--<td>f03d42026</td>--%>
                            <%--<td>--%>
                                    <%--angelique�--%>
                            <%--</td>--%>
                            <%--<td align="center">--%>
                                    <%--woman cut medium--%>
                            <%--</td>--%>
                            <%--<td>1</td>--%>
                            <%--<td>75.$</td>--%>
                            <%--<td>0.$</td>--%>
                            <%--<td>75.$</td>--%>
                        <%--</tr>--%>
               </tbody>
            <tfoot>
                <tr>
                    <td colspan="2" rowspan="2">
                        TOTAL
                    </td>
                    <td colspan="5">
                        <table width="100%">
                            <tbody><tr>
                                <td>
                                    Without taxes:
                                    <%=total%>
                                </td>
                                <td>
                                    Taxes only:
                                    <%=tax%>
                                </td>
                                <td>
                                    Total price with taxes:
                                    <%=totalprice%>
                                </td>
                            </tr>
                        </tbody></table>
                    </td>
                </tr>
            </tfoot>
        </table>
</div>
    </div>
</div>

    <div id="MB_overlay" opacity="0" style="opacity: 0.65;" onclick="location.href='./checkout.do?dt=<%=dt%>'"></div>
    
                <%}%>
    <% if (id_gift.equals("0")) { %>
    <div id="MB_windowGift" style="overflow: visible; width: 400px; height: 135px; left: 504px; display: none;" >
        <% } else { %>
    <div id="MB_windowGift" style="overflow: visible; width: 400px; height: 135px; left: 504px; display: block;" >
        <%}%>
    <div id="MB_frameGift" style="bottom: 0px;">
        <div id="MB_headerGift"><div id="MB_captionGift">GiftCard</div><a id="MB_closeGift" onclick="showgiftcard();" title="Close window" href="#"><span>x</span></a></div>
        <div id="MB_contentGift" style="position: relative;">
            <%
%>
        <table class="STYLE21">
            <tr>
                <td>
                    Card number:
                </td>
                <td>
                 <% if (!id_gift.equals("0")) { %>
                <input id="giftcardnumber" type="text" value="<%=id_gift%>"/>
                <%} else {%>
                <input id="giftcardnumber" type="text" value="0"/>
                <%}%>
                </td>
            </tr>
            <% if (gc != null) { %>
            <tr>
                <td>
                    Date:
                </td>
                <td>
                    <%=giftdate%>
                </td>
            </tr>
            <tr>
                <td>
                    Amount:
                </td>
                <td>
                    <%=giftamount%> $
                </td>
            </tr>
            <%} else if (!id_gift.equals("0")) {%>
            <tr>
                <td style="color:red;" colspan="2">
                    * Gift card with number <%=id_gift%> has not been found.
                </td>
            </tr>
            <%}%>
            <tr>
                <td align="right" colspan="2">
                    <input type="button" value="Check" class="transbutton" style="float:right;" onclick="checkgiftcard()"/>
                </td>
            </tr>
        </table>

</div>
    </div>
</div>
<% if (id_gift.equals("0")) { %>
    <div id="MB_overlayGift" style="opacity: 0.65; display: none;" onclick="showgiftcard();"></div>
<% } else { %>
    <div id="MB_overlayGift" style="opacity: 0.65; display: block;" onclick="showgiftcard();"></div>
<%}%>

</div></div></div>
</body>
</html>
