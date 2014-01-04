<%@ page import="org.apache.commons.lang.StringUtils"    %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.math.BigDecimal" %>
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
    String tran_code = StringUtils.defaultString(request.getParameter("tran"), "");
    String action = StringUtils.defaultString(request.getParameter("action"), "");

    boolean bActionView = false;
    boolean bActionEdit = false;
    if(action.equals("view"))
        bActionView = true;
    else
        if(action.equals("edit"))
            bActionEdit = true;
    boolean bAction = bActionEdit || bActionView;    
    Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(dt);
    if (lMatcher.matches()) {
        dt = dt.trim().replace('-', '/').replaceAll("/0", "/");
    } else {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
        dt = sdf.format(Calendar.getInstance().getTime());
    }

    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id

    //ArrayList list_trans = Transaction.findTransByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    CashinoutBean rec = CashinoutBean.findTransByCodeOne(tran_code);    
    /*HashMap hm_emp = Employee.findAllMap();
    HashMap hm_cust = Customer.findAllMap();
    HashMap hm_svc = Service.findAllMap();
    HashMap hm_prod = Inventory.findAllMap();*/
%>
<%
    Date _d;
    String time;
    if(bActionView)
    {
        _d = rec.getCreated_dt();
        time = "0:00:00";
    }
    else
    {
        _d = new Date(request.getParameter("dt"));
        Date d = Calendar.getInstance().getTime();
        time = Integer.toString(d.getHours()+1) + ":" + (d.getMinutes() < 10 ? "0" : "") + Integer.toString(d.getMinutes());
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String date = sdf.format(_d);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Pay In/Out</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <LINK href="css/style.css" type=text/css rel=stylesheet>
    <LINK href="css/HairDresser.css" type=text/css rel=stylesheet>

    <script language="javascript" type="text/javascript" src="Js/includes/prototype.js"></script>

    <script type="text/javascript" src="script/checkout.js"></script>

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
<body onload="MM_preloadImages('images/ADMIN red.gif','images/home red.gif','images/checkout red.gif','images/schedule red.gif')">
<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr valign="top">
        <%
            String activePage = "Schedule";
            String rootPath = "";
        %>
        <%@ include file="top_page.jsp" %>
    </tr>
    <tr>
        <td height="47" background="images/ADMIN_03.gif" colspan="3">
            <%@ include file="menu_main.jsp" %>
        </td>
    </tr>
    <%--<%@ include file="menu.jsp"%>--%>
</table>
<table width="1040" <%--height="432" --%> border="0" cellpadding="0" cellspacing="0">
<tr>
<td>
<div id="container">
<img class="rightcorner" src="images/page_right.jpg" alt="">
<img class="leftcorner" src="images/page_left.jpg" alt="">
<div class="padder">
<!-- main content begins here -->
<div class="heading">
<%--    <%
        String oncl = "";
        if (rp.equals("shd")){
            oncl = "window.location.href='./schedule.do?dt="+dt+"';";
        }else if (rp.equals("chk")){
//                                    oncl = "window.location.href='./checkout_main.jsp?dt="+dt+"';";
            oncl = "window.history.back();";
        }
    %>--%>
    <div class="floatLeft submitBTN"><input name="back" type="button" class="button_small" value="back" onclick="window.history.back();" <%--onclick="window.location.href='./view_customer.jsp?id=<%=id%>&dt=<%=dt%>';"--%>></div> <div style="margin-left: 10px;" class="floatLeft"><h1>Pay In/Out </h1> </div><div style="margin-left: 10px;" class="floatLeft"><h1> <%=date + " " + time%>  </h1></div>
    <div style="float: left; margin-left:10px;">
        <%if(bAction){%>
        <h1># <%=rec.getCode_transaction()%>  </h1>
        <input type="hidden" name="transNumEdit" id="transNumEdit" value="<%=rec.getCode_transaction()%>">
        <input type="hidden" name="recID" id="recID" value="<%=rec.getId()%>">
        <%}else{%>
        <h1># <span style="font-size: 16px;" id="transNum"></span>   </h1>
        <%}%>

    </div>
    <div class="clear"></div>
</div>

    <div align="center">
    <div style="width:901px; height: 451px;">
    <br />
    <input type="hidden" name="CashioDate" id="CashioDate" value="<%=date + " " + time+":00"%>">
    <div style="text-align: center;margin-bottom: 10px;">
        <%if(!bAction){%>
            <hdr1>PayIn</hdr1>
            <input type="radio" name="payout" class="styled5" value="in" checked="checked"/>
            <hdr1>PayOut</hdr1>
            <input type="radio" name="payout" class="styled5" value="out" />

        <%}else{%>
        <%}if(bActionView){%>
            <hdr1>PayIn</hdr1>
            <input type="radio" <%if(rec.getStatus() == 5){%>checked="true"<%}%>name="payout" class="styled5" value="in" disabled="true"/>
            <hdr1>PayOut</hdr1>
            <input type="radio" <%if(rec.getStatus() == 3){%>checked="true"<%}%> name="payout" class="styled5" value="out" disabled="true"/>
        <%}else{%>
        <%}if(bActionEdit){%>
            <hdr1>PayIn</hdr1>
            <input type="radio" <%if(rec.getStatus() == 5){%>checked="true"<%}%>name="payout" class="styled5" value="in"/>
            <hdr1>PayOut</hdr1>
            <input type="radio" <%if(rec.getStatus() == 3){%>checked="true"<%}%> name="payout" class="styled5" value="out" />
        <%}%>
         <br/>
         <br/>
    </div>
    <div class="pio" style="float: left; width: 40%;text-align: right;">
            <%if(!bAction){%>
        Visa
        <input type="radio" class="styled4" value="visa" id="visa_radio" name="payment_method" onclick="setPIOvalue(this)"/>
        <input type="text" onchange="setPIOvalue(this);" onclick="checkedRadioBtn(this);" name="visa_value" id="visa_value" style="/*background: url(img/checkout_payout_15.png);*/ width: 102px; /*height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px*/">
        <br/>
            <%}else{%>
            <%}if(bActionView){%>
        Visa
        <input disabled="true" type="radio" class="styled4" value="visa" <%if(rec.getPayment().equals("visa")){%>checked="true" <%}%> name="payment_method"/>
        <input type="text" disabled="true" name="visa_value" value="<%if(rec.getPayment().equals("visa")){%><%=rec.getVisa().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="/*background: url(img/checkout_payout_15.png);*/ width: 102px; /*height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px*/">
        <br/>
            <%}else{%>
            <%}if(bActionEdit){%>
        Visa
        <input type="radio" class="styled4" value="visa" <%if(rec.getPayment().equals("visa")){%>checked="true" <%}%> id="visa_radio_edit" name="payment_method" onclick="setPIOvalueEdit(this)"/>
        <input type="text" value="<%if(rec.getPayment().equals("visa")){%><%=rec.getVisa().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" onchange="setPIOvalueEdit(this);" onclick="checkedRadioBtn(this);" name="visa_value" id="visa_value_edit" style="/*background: url(img/checkout_payout_15.png);*/ width: 102px; /*height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px*/">
        <br/>
            <%}%>

            <%if(!bAction){%>
        Mastercard
        <input type="radio" class="styled4" value="mastercard" id="mastercard_radio" name="payment_method" onclick="setPIOvalue(this)" />
        <input type="text" onchange="setPIOvalue(this);" onclick="checkedRadioBtn(this);" name="mastercard_value" id="mastercard_value" style="/*background: url(img/checkout_payout_20.png); */width: 102px; /*height: 30px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px*/">
        <br/>
            <%}else{%>
            <%}if(bActionView){%>
        Mastercard
        <input disabled="true" type="radio" class="styled4" <%if(rec.getPayment().equals("mastercard")){%>checked="true" <%}%> value="mastercard" name="payment_method" />
        <input type="text" name="mastercard_value" disabled="true" value="<%if(rec.getPayment().equals("mastercard")){%><%=rec.getMastercard().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="/*background: url(img/checkout_payout_20.png);*/ width: 102px; /*height: 30px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px*/">
        <br/>
        <%}else{%>
        <%}if(bActionEdit){%>
        Mastercard
        <input type="radio" class="styled4" <%if(rec.getPayment().equals("mastercard")){%>checked="true" <%}%> value="mastercard" id="mastercard_radio_edit" name="payment_method" onclick="setPIOvalueEdit(this)" />
        <input type="text" value="<%if(rec.getPayment().equals("mastercard")){%><%=rec.getMastercard().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>"  onchange="setPIOvalueEdit(this);" onclick="checkedRadioBtn(this);" name="mastercard_value" id="mastercard_value_edit" style="/*background: url(img/checkout_payout_20.png);*/ width: 102px; /*height: 30px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px*/">
        <br/>
        <%}%>

        <%if(!bAction){%>
        Amex
        <input type="radio" class="styled4" value="amex" id="amex_radio" name="payment_method" onclick="setPIOvalue(this)" />
        <input type="text" onchange="setPIOvalue(this);" onclick="checkedRadioBtn(this);" name="amex_value" id="amex_value" style="/*background: url(img/checkout_payout_25.png);*/ width: 102px; <%--height: 40px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 13px--%>">
        <br/>
        <%}else{%>
        <%}if(bActionView){%>
        Amex
        <input disabled="true" type="radio" class="styled4" value="amex" <%if(rec.getPayment().equals("amex")){%>checked="true"<%}%> name="payment_method"  />
        <input type="text" name="amex_value" disabled="true" value="<%if(rec.getPayment().equals("amex")){%><%=rec.getAmex().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="/*background: url(img/checkout_payout_25.png);*/ width: 102px;/* height: 40px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 13px*/">
        <br/>
        <%}else{%>
        <%}if(bActionEdit){%>
        Amex
        <input type="radio" class="styled4" value="amex" id="amex_radio_edit" <%if(rec.getPayment().equals("amex")){%>checked="true"<%}%> name="payment_method" onclick="setPIOvalueEdit(this)" />
        <input type="text" onchange="setPIOvalueEdit(this);" onclick="checkedRadioBtn(this);" name="amex_value" id="amex_value_edit" value="<%if(rec.getPayment().equals("amex")){%><%=rec.getAmex().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="/*background: url(img/checkout_payout_25.png);*/ width: 102px;/* height: 40px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 13px*/">
        <br/>
        <%}%>

        <%if(!bAction){%>
        Cash
        <input type="radio" class="styled4" value="cash" id="cash_radio" name="payment_method" onclick="setPIOvalue(this)" />
        <input type="text" onchange="setPIOvalue(this);" onclick="checkedRadioBtn(this);" name="cash_value" id="cash_value" style="/*background: url(img/checkout_payout_28.png);*/ width: 102px;/* height: 36px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 10px*/">
        <br/>
        <%}else{%>
        <%}if(bActionView){%>
        Cash
        <input disabled="true" type="radio" class="styled4" value="cash" <%if(rec.getPayment().equals("cash")){%>checked="true" <%}%> name="payment_method" />
        <input type="text" name="cash_value" disabled="true" value="<%if(rec.getPayment().equals("cash")){%><%=rec.getCashe().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>"  style="/*background: url(img/checkout_payout_28.png);*/ width: 102px; /*height: 36px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 10px*/">
        <br/>
        <%}else{%>
        <%}if(bActionEdit){%>
        Cash
        <input type="radio" class="styled4" value="cash" id="cash_radio_edit" <%if(rec.getPayment().equals("cash")){%>checked="true" <%}%> name="payment_method" onclick="setPIOvalueEdit(this)" />
        <input type="text" onchange="setPIOvalueEdit(this);" onclick="checkedRadioBtn(this);" value="<%if(rec.getPayment().equals("cash")){%><%=rec.getCashe().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" name="cash_value" id="cash_value_edit" style="/*background: url(img/checkout_payout_28.png);*/ width: 102px; /*height: 36px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 10px*/">
        <br/>
        <%}%>

        <%if(!bAction){%>
        Check
        <input type="radio" class="styled4" value="check" id="check_radio" name="payment_method" onclick="setPIOvalue(this)" />
        <input type="text" onchange="setPIOvalue(this);" onclick="checkedRadioBtn(this);" name="check_value" id="check_value" style="/*background: url(img/checkout_payout_32.png);*/ width: 102px; /*height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px*/">
        <br/>
        <%}else{%>
        <%}if(bActionView){%>
        Check
        <input disabled="true" type="radio" class="styled4" value="check" id="check_radio_edit" <%if(rec.getPayment().equals("check")){%>checked="true" <%}%> name="payment_method" />
        <input type="text" name="check_value" disabled="true" value="<%if(rec.getPayment().equals("check")){%><%=rec.getCheque().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="/*background: url(img/checkout_payout_32.png);*/ width: 102px; /*height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px*/">
        <br/>
        <%}else{%>
        <%}if(bActionEdit){%>
        Check
        <input type="radio" class="styled4" value="check" id="check_radio_edit" <%if(rec.getPayment().equals("check")){%>checked="true" <%}%> name="payment_method" onclick="setPIOvalueEdit(this)" />
        <input type="text" onchange="setPIOvalueEdit(this);" onclick="checkedRadioBtn(this);" value="<%if(rec.getPayment().equals("check")){%><%=rec.getCheque().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" name="check_value" id="check_value_edit" style="/*background: url(img/checkout_payout_32.png);*/ width: 102px; /*height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px*/">
        <br/>
        <%}%>

    </div>

    <div style="float: left; width: 40%;text-align: right;">
        <%if(!bAction){%>
        Vendor
            <input type="text" name="vendor" id="vendor" style="/*background: url(img/checkout_payout_17.png);*/ width: 271px; /*height: 37px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 12px*/">
        <br/>
        <%}else{%>
        <%}if(bActionView){%>
        Vendor
            <input type="text" name="vendor" disabled="true" value="<%=rec.getVendor()%>" style="/*background: url(img/checkout_payout_17.png);*/ width: 271px; /*height: 37px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 12px*/">
        <br/>
        <%}else{%>
        <%}if(bActionEdit){%>
        Vendor
            <input type="text" name="vendor" value="<%=rec.getVendor()%>"  id="vendor_edit" style="/*background: url(img/checkout_payout_17.png);*/ width: 271px; /*height: 37px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 12px*/">
        <br/>
        <%}%>

        <%if(!bAction){%>
             Description
        <textarea name="description" id="description" style=" margin-top: 5px; /*background: url('img/checkout_payout_22.png');*/
                                width: 272px;
                                height: 176px;
                                /*overflow: hidden;
                                font-size: 8pt;
                                text-align:left;
                                padding-top: 15px;
                                padding-right: 2px;
                                padding-left: 5px;
                                margin: 0px;
                                border: 0;
                                background-color: #000000;*/"></textarea>

        <br/>
        <%}else{%>
              Description
        <textarea id="description_edit" name="description" <%if(bActionView){%>disabled="true"<%}%> style=" margin-top: 5px; /*background: url('img/checkout_payout_22.png');*/
                                width: 272px;
                                height: 176px;
                                /*overflow: hidden;
                                font-size: 8pt;
                                text-align:left;
                                padding-top: 15px;
                                padding-right: 2px;
                                padding-left: 5px;
                                margin: 0px;
                                border: 0;
                                background-color: #000000;*/"><%=rec.getDescription()%></textarea>
        <br/>
        <%}%>

        <%if(!bAction){%>
        Total
        <input type="text" name="total_value" id="total_value" style="/*background: url(img/checkout_payout_39.png);*/ width: 275px; /*height: 43px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 15px*/">
        <input type="image" style="height: 30px; margin-top: 5px;border: 0px;background:white"  src="img/checkout_payout_40_2.png" onclick="savePIOvalue();"/>
        <%}else{%>
        <%}if(bActionView){%>
        Total
        <input type="text" name="total_value" disabled="true" value="<%=rec.getVisa().add(rec.getMastercard().add(rec.getAmex().add(rec.getCashe().add(rec.getCheque())))).setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"  style="/*background: url(img/checkout_payout_39.png);*/ width: 275px; /*height: 43px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 15px*/">
        <%--<input type="image" src="img/checkout_payout_40_2.png" onclick="Modalbox.hide();"/>--%>
        <%}else{%>
        <%}if(bActionEdit){%>
        Total
        <input type="text" name="total_value" id="total_value_edit" value="<%=rec.getVisa().add(rec.getMastercard().add(rec.getAmex().add(rec.getCashe().add(rec.getCheque())))).setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="/*background: url(img/checkout_payout_39.png);*/ width: 275px; /*height: 43px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 15px*/">
        <input type="image" style="height: 30px; margin-top: 5px;border: 0px;background:white" src="img/checkout_payout_40_2.png" onclick="editPIOvalue();"/>
        <%}%>
    </div>
    <div class="clear">
    </div>






    </div>
   </div>

    <script type="text/javascript">
//        Custom4.init();
//        Custom5.init();
        _transNum = createTransNum();
        document.getElementById("transNum").innerHTML = _transNum;
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

        var type = "";
        function setPIOvalue(el){
            var basename = "";
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
            var tt = document.getElementById(basename + "_value").value;
            document.getElementById("visa_value").value = 0.0;
            document.getElementById("mastercard_value").value = 0.0;
            document.getElementById("amex_value").value = 0.0;
            document.getElementById("cash_value").value = 0.0;
            document.getElementById("check_value").value = 0.0;
            if(type == "text"){
                document.getElementById(basename + "_radio").click();
                document.getElementById(basename + "_value").value = tt;
                document.getElementById("total_value").value = document.getElementById(basename + "_value").value;
            }
            else{
                document.getElementById(basename + "_value").focus();
                document.getElementById(basename + "_value").value = document.getElementById("total_value").value;
            }
            type = "";
        }


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
        new Ajax.Request('Cashio?rnd=' + Math.random() * 99999, { method: 'get',
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
//                Modalbox.hide();
                window.location.href="./checkout.do?dt=<%=dt%>";
            }.bind(this),
            onException: function(instance, exception){
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
                        window.location.href="./checkout.do?dt=<%=dt%>";
                    }.bind(this),
                    onException: function(instance, exception){
                        alert('Cashio Loading Error: ' + exception);
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
                //return;
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
        function checkedRadioBtn(el){
            basename = "";
            if(type != ""){
                type = "";
                //return;
            }
            if(el.id.match("_value_edit$")){
                basename = el.id.replace(/_value_edit$/g, "");
                type = "text";
            }
            document.getElementById("total_value_edit").value = document.getElementById(basename + "_value_edit").value;
            if(type == "text"){
                document.getElementById(basename + "_radio_edit").click();
                document.getElementById(basename + "_value_edit").focus();
            }
            type = "";
        }
    </script>

</div>
</div>
</td>
</tr>
<%@ include file="copyright.jsp" %>
</table>
</body>
</html>