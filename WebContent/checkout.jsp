<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.apache.log4j.Logger" %>

<%
    Logger logger=Logger.getLogger(getClass());
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
//    String tran_code = StringUtils.defaultString(request.getParameter("code"), "");//TODO transacton_code

    String p_appt = StringUtils.defaultString(request.getParameter("appt"), "0");
    String p_svc = StringUtils.defaultString(request.getParameter("svc"), "0");
    String p_cust = StringUtils.defaultString(request.getParameter("cust"), "0");
    String p_emp = StringUtils.defaultString(request.getParameter("emp"), "0");
    String id_empl = StringUtils.defaultString(request.getParameter("ide"), "");
    String id_cust = StringUtils.defaultString(request.getParameter("idc"), "");
    String id_serv = StringUtils.defaultString(request.getParameter("ids"), "0");
    String id_prod = StringUtils.defaultString(request.getParameter("idp"), "0");
    String id_appt = StringUtils.defaultString(request.getParameter("idappt"), "0");
    String code_trans = StringUtils.defaultString(request.getParameter("ct"), "0");
//    String qty = StringUtils.defaultString(request.getParameter("qty"), "0");
    String disc = StringUtils.defaultString(request.getParameter("disc"), "0");
//    String price_ = StringUtils.defaultString(request.getParameter("price"), "0");
//    String amex_ = StringUtils.defaultString(request.getParameter("amex"), "0");
//    String visa_ = StringUtils.defaultString(request.getParameter("visa"), "0");
//    String mastercard_ = StringUtils.defaultString(request.getParameter("mastercard"), "0");
//    String chk_ = StringUtils.defaultString(request.getParameter("chk"), "0");
//    String cash_ = StringUtils.defaultString(request.getParameter("cash"), "0");
//    String gc_ = StringUtils.defaultString(request.getParameter("gc"), "0");
//    String chng_ = StringUtils.defaultString(request.getParameter("chng"), "0");
    String status = StringUtils.defaultString(request.getParameter("st"), "0");
    String tp = StringUtils.defaultString(request.getParameter("tp"), "0");
    String rel = StringUtils.defaultString(request.getParameter("rel"), "");
    String idt = StringUtils.defaultString(request.getParameter("idt"), "0");
    if(idt.equals("0") && !code_trans.equals("0")){
        ArrayList a = Reconciliation.findTransByCode(code_trans);
        if(a != null && a.size() != 0){
            idt = Integer.toString(((Reconciliation)a.get(0)).getId());
        }

    }
    if (id_empl.equals("")){
        ArrayList temp_ticket = Ticket.findTicketByLocCodeTrans(Integer.parseInt(loc), code_trans);
        if (temp_ticket != null && temp_ticket.size()>0){
            Ticket tt = (Ticket) temp_ticket.get(temp_ticket.size()-1);
            id_empl = String.valueOf(tt.getEmployee_id());
        }
    }
    String new_gc = StringUtils.defaultString(request.getParameter("new_gc"), "0");
    String new_am = StringUtils.defaultString(request.getParameter("new_am"), "0");
    String ex_gc = StringUtils.defaultString(request.getParameter("ex_gc"), "0");
    String ex_am = StringUtils.defaultString(request.getParameter("ex_am"), "0");


    if(request.getParameter("from") != null && request.getParameter("from").equals("schedule")){
        if(!id_serv.equals("0") && !id_serv.equals("") && !id_empl.equals("") && !code_trans.equals("") && !id_appt.equals("0") ) {
            CashDrawing cd = CashDrawing.findByDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
            if(cd == null){
                response.sendRedirect("./checkout_main.jsp");
                return;
            }
            User u = ActionUtil.getUser(request);
            EmpServ es = EmpServ.findByEmployeeIdAndServiceID(Integer.parseInt(id_empl), Integer.parseInt(id_serv));
            Service serv = Service.findById(Integer.parseInt(id_serv));
            BigDecimal price = new BigDecimal(0);
            BigDecimal taxe = new BigDecimal(0);
            if (es != null){
                price = es.getPrice();

                taxe = price.multiply(es.getTaxes()).divide(new BigDecimal(100));
            } else if (serv != null){
                price = serv.getPrice();
                taxe = price.multiply(serv.getTaxes()).divide(new BigDecimal(100));
            }else {
                price = new BigDecimal(0);
                taxe = new BigDecimal(0);
            }

            Appointment appt = Appointment.findById(Integer.parseInt(id_appt));
            if(appt != null && appt.getTicket_id() > 0)
            {
                Ticket tic = Ticket.findTicketById(appt.getTicket_id());
                if (tic != null) {
                    ArrayList a = Reconciliation.findTransByCode(tic.getCode_transaction());
                    if(a != null && a.size() != 0){
                        idt = Integer.toString(((Reconciliation)a.get(0)).getId());
                        Reconciliation r = (Reconciliation)a.get(0);
                        /*Reconciliation.updateTransaction(
                                0,
                                r.getId(), 1, r.getCode_transaction(), r.getId_customer(), r.getSub_total(), r.getTaxe(),
                                r.getTotal(), r.getPayment(), 0, r.getCreated_dt(), r.getAmex(), r.getVisa(),
                                r.getMastercard(), r.getCheque(), r.getCashe(), r.getGiftcard(), r.getChange()
                        );*/
                    }
                    response.sendRedirect("./checkout.jsp?dt=" + dt + "&ct=" + tic.getCode_transaction() + "&idc=" + id_cust+ "&tp=3&idt=" + idt);
                }
            }
//            else
//            {
//                Ticket tic = Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), 0, Integer.parseInt(id_serv), 1, 0, price, taxe, Integer.parseInt(status),"-1");
//                Appointment.updateAddTicketID(Integer.parseInt(id_appt), tic.getId());
//                response.sendRedirect("./checkout.jsp?dt=" + dt + "&ct=" + tic.getCode_transaction() + "&idc=" + id_cust+ "&tp=3&idt=" + idt);
//            }

            return;
        }
    }

//    ArrayList list_tran = Transaction.findByCustDate(Integer.parseInt(p_cust), DateUtil.parseSqlDate(dt));//Transaction.findByCode(tran_code);
    ArrayList list_emp = Employee.findAllByLoc(Integer.parseInt(loc));

    HashMap hm_emp = Employee.findAllMapWithDeleted();
    HashMap hm_svc = Service.findAllMap();
    HashMap hm_prod = Inventory.findAllMap();
    HashMap hm_cust = Customer.findAllMap();
    ArrayList list_cust = Customer.findAll();

    if (!id_empl.equals("") && (!id_serv.equals("0") || !id_prod.equals("0") || (!new_gc.equals("0") && !new_am.equals("0")) || (!ex_gc.equals("0") && !ex_am.equals("0")))) {
        if (user_ses.getPermission() != Role.R_SHD_CHK){
        User u = ActionUtil.getUser(request);
        int qty = 1;
        BigDecimal price = new BigDecimal(0);
        BigDecimal taxe = new BigDecimal(0);
        String ida = StringUtils.defaultString(request.getParameter("ida"), "0");
        Ticket t = null;
        // insert product
        if (!id_prod.equals("") && !id_prod.equals("0")) {
            Inventory prod = Inventory.findById(Integer.parseInt(id_prod));
            if(prod != null){
    //            qty = prod.getQty();
                price = prod.getSale_price();
                taxe = price.multiply(prod.getTaxes()).divide(new BigDecimal(100));
//                logger.info("Start insertTicket on App. (insert product) User="+user_ses.getFname()+""+user_ses.getLname());
//                t = Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), Integer.parseInt(id_prod), 0, qty, Integer.parseInt(disc), price, taxe, Integer.parseInt(status),"-1");
//                logger.info("End insertTicket on App.  (insert product) User="+user_ses.getFname()+""+user_ses.getLname());
//                if ((!ida.equals("0")) && (!ida.equals("")))  Appointment.updateAddTicketID(Integer.parseInt(ida), t.getId());
            if ((!ida.equals("0")) && (!ida.equals(""))){ 
                Appointment a = Appointment.findById(Integer.parseInt(ida));
                if (a!=null){
                    if (a.getTicket_id()>0){
                        Ticket tt = Ticket.findTicketById(a.getTicket_id());
                        if (tt != null || !code_trans.equals("0")){
                            ArrayList r = Reconciliation.findByFilter("where code_transaction='"+tt.getCode_transaction()+"'");
                            for (int q1 = 0; q1<r.size(); q1++){
                                Reconciliation rr = (Reconciliation)r.get(q1);
                                Reconciliation.deleteTransaction((u!=null?u.getId():0),rr.getId());
                            }
                        t = Ticket.updateTicketCodeTrans(a.getTicket_id(),code_trans);
                        }
//                        Appointment.updateAddTicketID(Integer.parseInt(ida), t.getId());
//                        Appointment.updateAppointmentByIdState(Integer.parseInt(ida),1);
                    } else {
                        t = Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), Integer.parseInt(id_prod), 0, qty, Integer.parseInt(disc), price, taxe, Integer.parseInt(status),"-1");
                        if (t != null){
                            Appointment.updateAddTicketID(Integer.parseInt(ida), t.getId());
                            Appointment.updateAppointmentByIdState(Integer.parseInt(ida),1);
                        }
                    }
                }
            }else {
                t = Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), Integer.parseInt(id_prod), 0, qty, Integer.parseInt(disc), price, taxe, Integer.parseInt(status),"-1");
//                if (t != null){
//                    Appointment.updateAddTicketID(Integer.parseInt(ida), t.getId());
//                    Appointment.updateAppointmentByIdState(Integer.parseInt(ida),1);
//                }
            }
            }
        }

        // insert service
        if(!id_serv.equals("0") && !id_serv.equals("")) {
            EmpServ es = EmpServ.findByEmployeeIdAndServiceID(Integer.parseInt(id_empl), Integer.parseInt(id_serv));
            Service serv = Service.findById(Integer.parseInt(id_serv));
            if (es != null){
                price = es.getPrice();
                taxe = price.multiply(es.getTaxes()).divide(new BigDecimal(100));
            } else if (serv != null){
                price = serv.getPrice();
                taxe = price.multiply(serv.getTaxes()).divide(new BigDecimal(100));
            } else {
                price = new BigDecimal(0);
                taxe = new BigDecimal(0);
            }
            if ((!ida.equals("0")) && (!ida.equals(""))){
                Appointment a = Appointment.findById(Integer.parseInt(ida));
                if (a!=null){
                    if (a.getTicket_id()>0){
                        Ticket tt = Ticket.findTicketById(a.getTicket_id());
                        if (tt != null || !code_trans.equals("0")){
                            ArrayList r = Reconciliation.findByFilter("where code_transaction='"+tt.getCode_transaction()+"'");
                            for (int q1 = 0; q1<r.size(); q1++){
                                Reconciliation rr = (Reconciliation)r.get(q1);
                                Reconciliation.deleteTransaction((u!=null?u.getId():0),rr.getId());
                            }
                        t = Ticket.updateTicketCodeTrans(a.getTicket_id(),code_trans);
                        }
//                        Appointment.updateAddTicketID(Integer.parseInt(ida), t.getId());
//                        Appointment.updateAppointmentByIdState(Integer.parseInt(ida),1);
                    } else {
                        t = Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), 0, Integer.parseInt(id_serv), qty, Integer.parseInt(disc), price, taxe, Integer.parseInt(status),"-1");
                        if (t != null){
                            Appointment.updateAddTicketID(Integer.parseInt(ida), t.getId());
                            Appointment.updateAppointmentByIdState(Integer.parseInt(ida),1);
                        }
                    }
                }
            }else {
                t = Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), 0, Integer.parseInt(id_serv), qty, Integer.parseInt(disc), price, taxe, Integer.parseInt(status),"-1");
//                if (t != null){
//                    Appointment.updateAddTicketID(Integer.parseInt(ida), t.getId());
//                    Appointment.updateAppointmentByIdState(Integer.parseInt(ida),1);
//                }
            }

        }

        // insert new gift card
        if (!new_gc.equals("-1")){
            BigDecimal amnt = new BigDecimal(new_am);
//            logger.info("Start insertTicket (insert new gift card) User="+user_ses.getFname()+""+user_ses.getLname());
            Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), 0, 0, qty, Integer.parseInt(disc), amnt, taxe, 0, new_gc);
//            logger.info("End insertTicket (insert new gift card) User="+user_ses.getFname()+""+user_ses.getLname());
        }

        // insert existing giftcard
        if (ex_am != null && ex_am.trim().length() > 0 && !ex_gc.equals("-1")){
            BigDecimal amnt = new BigDecimal(ex_am);
            //BigDecimal amnt = new BigDecimal(0);
//            logger.info("Start insertTicket (insert existing giftcard) User="+user_ses.getFname()+""+user_ses.getLname());
            Ticket.insertTicket((u!=null?u.getId():0), Integer.parseInt(loc), code_trans, Integer.parseInt(id_empl), 0, 0, qty, Integer.parseInt(disc), amnt, taxe, 1, ex_gc);
//            logger.info("End insertTicket (insert existing giftcard) User="+user_ses.getFname()+""+user_ses.getLname());
        }
    }
        response.sendRedirect("./checkout.jsp?dt=" + dt + "&ct=" + code_trans + "&idc=" + id_cust+ "&tp=" + tp+ "&idt=" + idt + "&rel=true");
        return;
    }

    boolean isStartDayAvailable = true;
    boolean isEndDayAvailable = false;
    CashDrawing cd = CashDrawing.findByDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));
    boolean refFlag = false;
    if(cd != null && cd.getOpenClose() == 2){
        tp = "-1";
        refFlag = true;
    }

    CashDrawing _cd = CashDrawing.findByDate(Integer.parseInt(loc), new java.sql.Date(new java.util.Date().getTime()));
    boolean isDayOpen = false;
    if(_cd != null && _cd.getOpenClose() != 2){
        isDayOpen = true;
    }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <LINK href="css/default.css" type=text/css rel=stylesheet>
    <LINK hrcheckout_le_final_38ef="css/modalbox.css" type=text/css rel=stylesheet>
    <LINK href="css/hd.css" type=text/css rel=stylesheet>
    <title>checkout</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <script type="text/javascript">
        var isDayOpen = <%=isDayOpen? 1 : 0%>;
    </script>
    <style type="text/css">
        span.select2 {
          position: absolute;
          width: 178px;
          height: 19px;
          line-height: 15px;
          padding: 0 24px 0 8px;
          color: #000000;
          font: 12px/21px arial,sans-serif;
          background: url(img/checkout_le_final_02.png) no-repeat;
          overflow: hidden;
        }
        span.select3 {
              position: absolute;
              width: 177px;
              height: 19px;
              line-height: 15px;
              padding: 0 24px 0 8px;
              color: #000000;
              font: 12px/21px arial,sans-serif;
              background: url(img/checkout_le_03.png) no-repeat;
              overflow: hidden;
            }
            span.checkbox3 {
              width: 20px;
              height: 20px;
              padding: 0 5px 0 0;
              background: url(img/checkout_ti_radio.png) no-repeat;
              display: block;
              clear: left;
              float: left;
            }
    </style>
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

    <link rel="stylesheet" type="text/css" href="./fonts/fonts-min.css"/>
    <link rel="stylesheet" type="text/css" href="./button/button.css"/>
    <link rel="stylesheet" type="text/css" href="./container/container.css"/>
    
    <script type="text/javascript" src="./plugins/jQuery v1.7.2.js"></script>
    <link rel='stylesheet' type='text/css' href='./plugins/popup/popup.css' />
    <script type="text/javascript" src="./plugins/popup/popup.js"></script>
    <script language="javascript" type="text/javascript" src="./Js/sendEmail.js"></script>
    
    <script type="text/javascript" src="./utilities/utilities.js"></script>
    <script type="text/javascript" src="./button/button-min.js"></script>
    <script type="text/javascript" src="./container/container-min.js"></script>

    <script type="text/javascript" src="Js/custom-form-elements2.js"></script>
    <script type="text/javascript" src="Js/custom-form-elements3.js"></script>

    <script type="text/javascript" src="Js/selectworker.js"></script>

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


        function saveCust(edit) {
            try {
                var request = getXmlHttpObject();
                if (request == null) {
                    alert('Your browser does not support AJAX!');
                }
                var firstName = document.getElementById('txtFirstName').value;
                var lastName =  document.getElementById('txtLastName').value.replace('\'', '\'\'');
                var phone = document.getElementById('txtPhone').value;
                var cellPhone = document.getElementById('txtCellPhone').value;
//                if (firstName.replace(/ /g,"") == ""){
//                    alert("Please enter First Name");
//                    return;
//                }
//                if (lastName.replace(/ /g,"") == ""){
//                    alert("Please enter Last Name");
//                    return;
//                }
//                if (phone.replace("1-(","").replace(")","") == "" && cellPhone.replace("1-(","").replace(")","") == ""){
//                    alert("Please enter Phone or Cell Phone");
//                    return;
//                }

                cust_select = document.getElementById("cust");
                opt = cust_select.getElementsByTagName("option");
                var _cust_id = opt[cust_select.selectedIndex].value;
                var currentDate = new Date("<%=dt%>");
                var newCurrentDate = currentDate.getUTCFullYear() + "/" + (currentDate.getUTCMonth() + 1) + "/" + currentDate.getUTCDate() + " " + currentDate.getUTCHours() + ":" + currentDate.getUTCMinutes();
                var strURL = null;
                if (document.getElementById('txtFirstName').value != "") {
                    if (edit) {
                        var randomnumber = Math.floor(Math.random() * 11);
                        strURL = 'customerData?UPDATE=update&firstName=' + firstName +
                                 '&lastName=' + lastName +
                                 '&phone=' + phone +
                                 '&cellPhone=' + cellPhone +
                                 '&email=' + document.getElementById('txtEmail').value +
                                 '&req=false' +
                                 '&locationId=<%=loc%>'+
                                 '&rem=0' +
                                 '&remdays=0' +
                                 '&cust_id=' + _cust_id +
                                 '&comment=' +
                                 '&custcomm=' +
                                 '&empid=0' +
                                 '&app_id=-1' +
                                 "&rnd=" + randomnumber +
                                 "&idlocation=<%=loc%>" +
                                 "&dateutc=" + newCurrentDate +
                                 "&pageNum=0";
                        //alert(strURL);
                    } else {
                        strURL = 'customerData?SAVE=save&firstName=' + document.getElementById('txtFirstName').value +
                                 '&lastName=' + document.getElementById('txtLastName').value.replace('\'', '\'\'') +
                                 '&phone=' + document.getElementById('txtPhone').value +
                                 '&cellPhone=' + document.getElementById('txtCellPhone').value +
                                 '&email=' + document.getElementById('txtEmail').value +
                                 '&req=false' +
                                 '&locationId=<%=loc%>' +
                                 '&empid=0' +
                                 '&custcomm=0' +
                                 '&rem=0' +
                                 '&remdays=0';
                    }
                    request.open("GET", strURL, true);
                    request.onreadystatechange = function() {
                        if (request.readyState == 4) {
                            if (request.status == 200) {
                                var _cust_id = 0
                                var xmlDoc = request.responseXML;

                                var items = xmlDoc.getElementsByTagName("customer");
                                if (items.length == 1)
                                {
                                    if (items[0].getAttribute("ID") != '0')
                                    {
                                        _cust_id = items[0].getAttribute("ID");
                                    }
                                }
                                if(!edit){
                                    cust_select = document.getElementById("cust");
                                    cust_select.innerHTML = cust_select.innerHTML + "<option value='"+_cust_id+"'>" + document.getElementById('txtFirstName').value + " " + document.getElementById('txtLastName').value + "</option>\n";
                                    select_setValue("cust", _cust_id);
                                }else{
                                    i = document.getElementById("cust").selectedIndex;
                                    o = document.getElementById("cust").getElementsByTagName("option");
                                    o[i].childNodes[0].nodeValue = document.getElementById('txtFirstName').value + " " + document.getElementById('txtLastName').value;
                                    select_setValue("cust", o[i].value);
                                }
                            }
                        }
                    }
                    request.send('');
                } else alert("Please insert customer data!!!");
            } 
            catch(error)
            {
                alert("saveCust "+error);
            }
        }

        function showHistory(){
                cust_select = document.getElementById("cust");
                opt = cust_select.getElementsByTagName("option");
                if(opt.length > 0){
                    var _cust_id = opt[cust_select.selectedIndex].value;
                    if(_cust_id != ""){
                        var currentDate2 = new Date("<%=dt%>");
                        var newCurrentDate2 = currentDate2.getUTCFullYear() + "/" + (currentDate2.getUTCMonth() + 1) + "/" + currentDate2.getUTCDate();
                        window.location.href='./history_customer.jsp?id='+_cust_id+'&dt='+newCurrentDate2+'&rp=chk&action=hist';
//                        Modalbox.show('history.jsp?id=' + _cust_id + '&rnd=' + Math.random() * 99999, {width: 1000});
                        <%--Modalbox.show('./trans_history.jsp?&idc='+_cust_id+'&loc=<%=loc%>&rnd=' + Math.random() * 99999, {width: 1000});--%>
                    }else{
                        alert("Customer not selected");
                    }
                }
        }

    </script>

    <script type="text/javascript" src="./ajax/yahoo-min.js"></script>
    <script type="text/javascript" src="./ajax/event-min.js"></script>
    <script type="text/javascript" src="./ajax/connection-min.js"></script>

<style>
BODY {height: 100%;}
</style>
</head>

<body class="yui-skin-sam" topmargin="0"
      onload="MM_preloadImages('../HAIR 233/images/home red.gif','../HAIR 233/images/schedule red.gif')">
<div style="z-index: 1111; width:100%; height: 150%; position: absolute; top: 0; left: 0; background-color: #FFFFFF; opacity: 0.5; filter: alpha(opacity=50); text-align: center; color:red; display: none; font-size: 14pt" id="overlay">
<br />
<br />
Please wait...
</div>
<script type="text/javascript">
    <!--
    var payment = "";
    var service = null;
    var serviceid = new Array();
    var product = null;
    var productid = new Array();

    function checkout(type) {
        payment = type;
        str_paym = type.toString();
        loadMB_window();
    }

    function loadMB_window(){
        ApplyButtonValidate();
        document.getElementById("cash_error").style.display = "none";
        var ctrl = document.getElementById("MB_caption");
        if (ctrl)
            ctrl.innerHTML = document.getElementById(payment).value;
        var ctrlx = document.getElementById("cashInput");
        if (ctrlx)
            if (ctrl.innerHTML.toString() == "Cash"){
                    ctrlx.style.display = "";
                document.getElementById("changeCash").style.display = "";
            } else{
                ctrlx.style.display = "none";
                document.getElementById("changeCash").style.display = "none";
            }
        if (ctrl.innerHTML.toString() == 'Giftcard'){
            document.getElementById("giftInput").style.display = '';
            document.getElementById("giftAmount").style.display = '';
        }else {
            document.getElementById("giftInput").style.display = 'none';
            document.getElementById("giftAmount").style.display = 'none';
        }

        ctrl = document.getElementById("MB_window");
        if (ctrl){
            if (ctrl.style.display == "none")
                ctrl.style.display = "block";
            else
                ctrl.style.display = "none";
        }
        ctrl = document.getElementById("MB_overlay");
        if (ctrl)
            if (ctrl.style.display == "none")
                ctrl.style.display = "block";
            else
                ctrl.style.display = "none";
    }

    function displaySecondPaymentMethod() {
        ApplyButtonValidate();
        var ctrl = document.getElementById("SplitMethodOfPaymentID");
        if (ctrl) {
            if (ctrl.checked) {
                ctrl = document.getElementById("MB_window");
                if (ctrl)
                    ctrl.style.height = "280";
                ctrl = document.getElementById("secondPaymentMethodID");
                if (ctrl)
                    ctrl.style.display = "block";
            }
            else {
                ctrl = document.getElementById("MB_window");
                if (ctrl)
                    ctrl.style.height = "229";
                ctrl = document.getElementById("secondPaymentMethodID");
                if (ctrl)
                    ctrl.style.display = "none";
                ctrl = document.getElementById("secondPaymentAmount");
                if (ctrl)
                    ctrl.value = "0";
            }
        }
    }

    function AddReconciliation(status_){
        AddReconciliation2(status_, true, false);
    }

    function AddReconciliation2(status_, redirect, isprint){
        if(transIDs.length == 0){
            alert('Cannot do any modifications on empty transaction');
            return;
        }
        var loc = "<%=loc%>";
        var code_trans = "<%=code_trans%>";
        var cust = <%=id_cust.equals("") ? "0" : "\""+id_cust+"\""%>;
        var sub_total = document.getElementById("sub_total").value;
        var taxe = document.getElementById("taxe").value;
        var total_ = document.getElementById("total").value-0;
        var status = status_;

        if ((total_ == 0) && (!status == 6)) return;

        var paym = "";
        var cdt = "<%=dt%>";
        var visa = 0;
        var mastercard = 0;
        var amex = 0;
        var cheque = 0;
        var cashe = 0;
        var change = 0;
        var giftcard = 0;
        var gcAmount3= -1;
        var totalGC = 0;
        var giftnum = document.getElementById("gift_paym").value;
        if (document.getElementById("chb_gift").checked) {
            if (giftnum == "") {
                alert("please input a giftcard number!");
                return;
            } else {
                getGiftCardAmount2(status);
            }
        } else {
            var tp = "<%=tp%>";

            if (document.getElementById("chb_visa").checked)
            {
                visa = document.getElementById("pm_visa").value-0;
                if (visa > 0){
                    paym = paym + 'visa ';
                } else visa = 0;
            }
            if (document.getElementById("chb_mastercard").checked)
            {
                mastercard = document.getElementById("pm_mastercard").value-0;
                if (mastercard > 0) {
                    paym = paym + 'mastercard ';
                } else mastercard = 0;
            }
            if (document.getElementById("chb_amex").checked)
            {
                amex = document.getElementById("pm_amex").value-0;
                if (amex > 0){
                    paym = paym + 'amex ';
                }  else amex = 0;
            }
            if (document.getElementById("chb_cash").checked)
            {
                cashe = document.getElementById("pm_cash").value-0;
                if (cashe > 0){
                    paym = paym + 'cash ';
                } else cashe = 0;
            }
            if (document.getElementById("chb_chk").checked)
            {
                cheque = document.getElementById("pm_check").value-0;
                if (cheque > 0){
                    paym = paym + 'cheque ';
                } else cheque = 0;
            }
            if (document.getElementById("chb_gift").checked)
            {
                giftcard = document.getElementById("pm_giftCard").value-0;
                if (giftcard > 0){
                    paym = paym + 'GiftCard:'+document.getElementById("gift_paym").value+' ';
                } else giftcard = 0;
            }
            change = document.getElementById("change_cashe").value-0;
            if (gcAmount3 != -1){
                if (gcAmount3  < giftcard){
                    alert("On a gift card the rest of "+gcAmount3+" $");
                    document.getElementById("pm_giftCard").value = gcAmount3.toFixed(2);
                    return;
                }
                totalGC = gcAmount3 - giftcard;
            }
            if(change > cashe)
            {
                alert("* Change: can not be more than cashe("+ cashe +")");
                return;
            }

            var fSum = parseFloat(visa + mastercard + amex + cashe + cheque + giftcard - change);
            if ((status == 0) && (fSum.toFixed(2) != total_)){
                alert("* Money: should be equal to "+ total_ +"");
                return;
            }

            var actionRec = "";
            if (tp == 2 || tp == 3 ) {
                actionRec = "edit";
            } else {
                actionRec = "add";
            }
            var recAction = "edit";
            if (status==0){
                recAction = "add";
            }
            var st = <%=status%>;
            document.getElementById("overlay").style.display = "block";
            new Ajax.Request( './check-out.do?rnd=' + Math.random() * 99999, { method: 'get',
                    parameters: {
                        action: actionRec,
                        id: "<%=idt%>",
                        id_location: "<%=loc%>",
                        code_transaction: code_trans,
                        id_customer: "<%=id_cust%>",
                        sub_total: sub_total,
                        taxe: taxe,
                        total: total_,
                        payment: paym,
                        status: status,
                        created_dt: "<%=dt%>",
                        chg: change,
                        amex: amex,
                        visa: visa,
                        mastercard: mastercard,
                        cheque: cheque,
                        cashe: cashe,
                        giftcard: giftcard,
                        giftcard_pay: ""
                    },
                    onSuccess: function(transport) {
                    	
                        var response = new String(transport.responseText);
                           //.x.m.
                            var idCustomer = "<%=id_cust%>";
                            var location = <%=loc%>;
                            var transactionCode = "<%=code_trans%>";
                            sendCheckoutEmail(idCustomer,location, transactionCode, isprint, function(){
                            	if (giftcard != 0){
                                    var gnum = document.getElementById("gift_paym").value;
                                    new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
                                    parameters: {
                                        query: "giftcard",
                                        code: gnum,
                                        created: "123",
                                        id_customer: "<%=id_cust%>",
                                        amount: totalGC
                                    },
                                    onSuccess: function(transport) {
                                        var response = new String(transport.responseText);

                                        if(st == 2 || tp != 2){
                                            updateTransactionValues(redirect,recAction);
                                        } else if(redirect){
                                            document.location.href = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
                                        }
                                    }.bind(this),
                                    onException: function(instance, exception){
                                        alert('Error update gift: ' + exception);
                                    }
                                    });
                                } else if (st == 2 || tp != 2){
                                    updateTransactionValues(redirect,recAction);
                                } else if(redirect){
                                    document.location.href = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
                                }else {
                                	document.getElementById("overlay").style.display = "none";
                                }
                            });
                    }.bind(this),
                    onException: function(instance, exception){
                        alert('Error add reconcil: ' + exception);
                    }
                });
        }
    }

    function deleteTicket(dt, idc, idt, tp, ct, id){
    new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
    parameters: {
        action: "removeTicket",
        remove_id: id
    },
    onSuccess: function(transport) {
        var str = "./checkout.jsp?dt=" + dt;
        if (idc != "" || ct != ""){
            str += "&ct=" + ct +"&idc=" + idc + "&tp=" + tp + "&idt=" + idt + "&rel=true";
        }
        document.location.href = str;
    }.bind(this),
    onException: function(instance, exception){
        alert('Error removeTicket: ' + exception);
    }
    });
}
function updateTransactionValuesRec(i,sub_total_,taxe_,redirect,recAction){
    if(i >= transIDs.length){
       if(redirect){
            document.location.href = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
        }
        document.getElementById("overlay").style.display = "none";
        return;
    }

             var id = transIDs[i];
            var qty = document.getElementById("qty_" + transIDs[i]).value;
            var discount = document.getElementById("disc_" + transIDs[i]).value;
            var price = document.getElementById("price_real_" + transIDs[i]).value;
            var _taxe = document.getElementById("taxe_" + transIDs[i]).value;
            sub_total_ += (qty * price) * (1 - (discount > 100 ? 100 : discount)/100);
            taxe_ += (qty * price)*(_taxe/100)* (1 - (discount > 100 ? 100 : discount)/100);
            var total = sub_total_ + taxe_;
            new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "updateTransactionValues",
                id: id,
                qty: qty,
                price: price,
                discount: discount,
                subtotal: sub_total_,
                taxe: taxe_,
                actionRec: recAction,
                total: total
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                i = i + 1;
                updateTransactionValuesRec(i,sub_total_,taxe_,redirect,recAction);

            }.bind(this),
            onException: function(instance, exception){
                alert('Error updateTransactionValues: ' + exception);
            }
            });
}
    function updateTransactionValues(redirect,recAction){
        var sub_total_ = 0;
        var taxe_ = 0;
        updateTransactionValuesRec(0,sub_total_,taxe_,redirect,recAction);
    }

    function setToFixed2(idElement){
        var a = document.getElementById(idElement).value-0;
        document.getElementById(idElement).value = a.toFixed(2);
    }

    function ChangeValueCard()
    {
        var total = document.getElementById("total").value-0;
        if (total == 0) return;
        var visa = 0;
        var mastercard = 0;
        var amex = 0;
        var cheque = 0;
        var change = 0;
        var giftcard = 0;
        getGiftCardAmount();
        var gcAmount2 = document.getElementById("amntExistGC").value-0;

        if (document.getElementById("chb_visa").checked)
        {
            visa = document.getElementById("pm_visa").value-0;
            if(visa > total)
            {
                alert('This value can not be more total.');
                document.getElementById("pm_visa").value = total;
            }
        }
        if (document.getElementById("chb_mastercard").checked)
        {
            mastercard = document.getElementById("pm_mastercard").value-0;
            if(mastercard > total)
            {
                alert('This value can not be more total.');
                document.getElementById("pm_mastercard").value = total;
            }
        }
        if (document.getElementById("chb_amex").checked)
        {
            amex = document.getElementById("pm_amex").value-0;
            if(amex > total)
            {
                alert('This value can not be more total.');
                document.getElementById("pm_amex").value = total;
            }
        }
        if (document.getElementById("chb_chk").checked)
        {
            cheque = document.getElementById("pm_check").value-0;
            if(cheque > total)
            {
                alert('This value can not be more total.');
                document.getElementById("pm_check").value = total;
            }
        }
        if (document.getElementById("chb_gift").checked)
        {
            giftcard = document.getElementById("pm_giftCard").value-0;
            if(giftcard > total)
            {
                alert('This value can not be more total.');
                document.getElementById("pm_giftCard").value = total;
            }
        }
    }

    function calculationChange(){
        var total = document.getElementById("total").value-0;
        if (total == 0) return;
        var cashe = 0;

        if (document.getElementById("chb_cash").checked)
        {
            cashe = document.getElementById("pm_cash").value-0;
        }
        var change = 0;
        if (total < cashe)
            change = cashe - total;
        document.getElementById("change_cashe").value = change.toFixed(2);
    }

    function fillAmount(){
        var total = document.getElementById("total").value-0;
        if (total == 0) return;
        var countPayMeth = 0;
        var payMeth = 0;
        var gcAmount = document.getElementById("amntExistGC").value-0;

        if (document.getElementById("chb_visa").checked)
        {
            countPayMeth ++;
            payMeth =1;
        }

        if (document.getElementById("chb_mastercard").checked)
        {
            countPayMeth ++;
            payMeth =2;
        }
        if (document.getElementById("chb_amex").checked)
        {
            countPayMeth ++;
            payMeth =3;
        }
        if (document.getElementById("chb_cash").checked)
        {
            countPayMeth ++;
            payMeth =4;
        }

        if (document.getElementById("chb_chk").checked)
        {
            countPayMeth ++;
            payMeth =5;
        }
        if (document.getElementById("chb_gift").checked)
        {
            countPayMeth ++;
            payMeth =6;
        }
        if (countPayMeth ==1)
        {
            document.getElementById("pm_visa").value = "";
            document.getElementById("pm_mastercard").value = "";
            document.getElementById("pm_amex").value = "";
            document.getElementById("pm_check").value = "";
            document.getElementById("pm_giftCard").value = "";
            document.getElementById("pm_cash").value = "";
            document.getElementById("change_cashe").value = "";
            switch (payMeth) {
                case 1: {
                    document.getElementById("pm_visa").value = total.toFixed(2);
                    break;
                }
                case 2: {
                    document.getElementById("pm_mastercard").value = total.toFixed(2);
                    break;
                }
                case 3: {
                    document.getElementById("pm_amex").value = total.toFixed(2);
                    break;
                }
                case 4: {
                    document.getElementById("pm_cash").value = total.toFixed(2);
                    break;
                }
                case 5: {
                    document.getElementById("pm_check").value = total.toFixed(2);
                    break;
                }
                case 6: {
                    document.getElementById("pm_giftCard").value = total.toFixed(2);
                    break;
                }
            }
        }
    }

    function ApplyButtonValidate(){
        document.getElementById("ApplyButton").value = "Validate";
    }

    function AddGiftCard(){
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

    function SaveGiftCard() {
        var giftcardnumber = document.getElementById("giftcardnumber").value - 0;
        var giftcardamount = document.getElementById("giftcardamount").value - 0;
        var idcustomer = document.getElementById("cust").value;
        var paymmethod = "";
        var amex = 0;
        var visa = 0;
        var mastercard = 0;
        var cheque = 0;
        var cashe = 0;
        if (giftcardnumber == 0) {
            alert("Please enter card number!");
            return;
        }
        if (giftcardamount == 0) {
            alert("Please enter amount!");
            return;
        }
        var ctrl = document.getElementsByName("giftpayment");
        for (i = 0; i < ctrl.length; i++) {
            if (ctrl[i].checked) {
                paymmethod = ctrl[i].value;
                switch (paymmethod) {
                    case "amex":
                        amex = giftcardamount;
                        break;
                    case "visa":
                        visa = giftcardamount;
                        break;
                    case "mastercard":
                        mastercard = giftcardamount;
                        break;
                    case "cheque":
                        cheque = giftcardamount;
                        break;
                    case "cash":
                        cashe = giftcardamount;
                        break;
                }
            }
        }
        var xmlRequestAppointmentTr;
        try {
            xmlRequestAppointmentTr = new XMLHttpRequest();
        } catch(e) {
            try {
                xmlRequestAppointmentTr = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
            }
        }
        xmlRequestAppointmentTr.open("POST", "./check-out.do?action=add&location_id=<%=loc%>&customer_id=" + idcustomer + "&employee_id=0&service_id=0&product_id=&prod_qty=1&payment=" + paymmethod + "&price=" + giftcardamount + "&discount=0&code=<%=code_trans%>&created_dt=<%=dt%>&sn=&tax=0&remainder=0&change=0&amex=" + amex + "&visa=" + visa + "&mastercard=" + mastercard + "&cheque=" + cheque + "&cashe=" + cashe);
        xmlRequestAppointmentTr.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
        xmlRequestAppointmentTr.send('');

        var xmlRequestAppointmentGift;
        try {
            xmlRequestAppointmentGift = new XMLHttpRequest();
        } catch(e) {
            try {
                xmlRequestAppointmentGift = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
            }
        }
        xmlRequestAppointmentGift.open("POST", "./chkqry?query=giftcard&code=" + giftcardnumber + "&created=&amount=" + giftcardamount + "&payment=" + paymmethod);
        xmlRequestAppointmentGift.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
        xmlRequestAppointmentGift.send('');

        document.location = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
    }

    function searchGiftCard() {
        var giftnum = document.getElementById("numberExistGC").value;
        if (giftnum == "") {
            alert("* Please enter a gift card #!");
            return;
        }

        var xmlRequestAppointmentSearchGift;
        try {
            xmlRequestAppointmentSearchGift = new XMLHttpRequest();
        } catch(e) {
            try {
                xmlRequestAppointmentSearchGift = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
            }
        }

        xmlRequestAppointmentSearchGift.onreadystatechange = function() {
            if (xmlRequestAppointmentSearchGift.readyState ==4 ) {
                var r = xmlRequestAppointmentSearchGift.responseText;
                var rspnc = r.split('~~');
                if (rspnc.length > 1) {
                    var a = rspnc[0].split(" ");
                    var b = rspnc[1].split(" ");
                    var amnt = b[0];
                    if (amnt == "NotFound") {
                        alert("* Card with number " + giftnum + " not found");
                    } else {
                        document.getElementById("balanceExistGC").value = amnt;
                    }
                }
            }
        };



        xmlRequestAppointmentSearchGift.open("POST", "./chkqry?query=giftcard&code=" + giftnum + "&get=1");
        xmlRequestAppointmentSearchGift.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
        xmlRequestAppointmentSearchGift.send('');
    }

    function getGiftCardAmount() {
//        alert("getGiftCArdAmount");
        document.getElementById("amntExistGC").value = "-1";
        var giftnum = document.getElementById("gift_paym").value;
        var amnt = -1;
        if (giftnum == "") {
            return;
        }


        var xmlRequestAppointmentSearchGift;
        try {
            xmlRequestAppointmentSearchGift = new XMLHttpRequest();
        } catch(e) {
            try {
                xmlRequestAppointmentSearchGift = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
            }
        }

        xmlRequestAppointmentSearchGift.onreadystatechange = function() {
            if (xmlRequestAppointmentSearchGift.readyState ==4 ) {
                var r = xmlRequestAppointmentSearchGift.responseText;
                var rspnc = r.split('~~');
                if (rspnc.length > 1) {
                    var a = rspnc[0].split(" ");
                    var b = rspnc[1].split(" ");
                    var amnt = b[0];
                    if (amnt == "NotFound") {
                        alert("* Card with number " + giftnum + " not found");
                        document.getElementById("amntExistGC").value = "-2";
                    } else {
//                        alert(amnt);
                        document.getElementById("amntExistGC").value = "\""+amnt+"\"";
//                        alert(document.getElementById("amntExistGC").value);
                    }
                }
            }
        };



        xmlRequestAppointmentSearchGift.open("POST", "./chkqry?query=giftcard&code=" + giftnum + "&get=1");
        xmlRequestAppointmentSearchGift.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
        xmlRequestAppointmentSearchGift.send('');
    }

   function getGiftCardAmount2(status2) {
        document.getElementById("amntExistGC").value = "-1";
        var giftnum = document.getElementById("gift_paym").value;
        var amnt = -1;
        if (giftnum == "") {
            return;
        }


        var xmlRequestAppointmentSearchGift;
        try {
            xmlRequestAppointmentSearchGift = new XMLHttpRequest();
        } catch(e) {
            try {
                xmlRequestAppointmentSearchGift = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
            }
        }

        xmlRequestAppointmentSearchGift.onreadystatechange = function() {
            if (xmlRequestAppointmentSearchGift.readyState ==4 ) {
                var r = xmlRequestAppointmentSearchGift.responseText;
                var rspnc = r.split('~~');
                if (rspnc.length > 1) {
                    var a = rspnc[0].split(" ");
                    var b = rspnc[1].split(" ");
                    var amnt = b[0];
                    if (amnt == "NotFound") {
                        alert("* Card with number " + giftnum + " not found");
                        document.getElementById("amntExistGC").value = "-2";
                    } else {
                        document.getElementById("amntExistGC").value = amnt;
                        payGC(status2);
                    }
                }
            }
        };



        xmlRequestAppointmentSearchGift.open("POST", "./chkqry?query=giftcard&code=" + giftnum + "&get=1");
        xmlRequestAppointmentSearchGift.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
        xmlRequestAppointmentSearchGift.send('');
    }

    function payGC(status3){
        var loc = "<%=loc%>";
        var code_trans = "<%=code_trans%>";
        var cust = <%=id_cust.equals("") ? "0" : "\""+id_cust+"\""%>;
        var sub_total = document.getElementById("sub_total").value;
        var taxe = document.getElementById("taxe").value;
        var total = document.getElementById("total").value;
        if (total == 0) return;
        var paym = "";
        var status = status3;
        var cdt = "<%=dt%>";
        var visa = 0;
        var mastercard = 0;
        var amex = 0;
        var cheque = 0;
        var cashe = 0;
        var change = 0;
        var giftcard = 0;
        var gcAmount3= document.getElementById("amntExistGC").value-0;
        var totalGC = 0;
        var giftnum = document.getElementById("gift_paym").value;
        var tp = "<%=tp%>";

        if (document.getElementById("chb_visa").checked)
        {
            visa = document.getElementById("pm_visa").value-0;
            if (visa > 0){
                paym = paym + 'visa ';
            } else visa = 0;
        }
        if (document.getElementById("chb_mastercard").checked)
        {
            mastercard = document.getElementById("pm_mastercard").value-0;
            if (mastercard > 0) {
                paym = paym + 'mastercard ';
            } else mastercard = 0;
        }
        if (document.getElementById("chb_amex").checked)
        {
            amex = document.getElementById("pm_amex").value-0;
            if (amex > 0){
                paym = paym + 'amex ';
            }  else amex = 0;
        }
        if (document.getElementById("chb_cash").checked)
        {
            cashe = document.getElementById("pm_cash").value-0;
            if (cashe > 0){
                paym = paym + 'cash ';
            } else cashe = 0;
        }
        if (document.getElementById("chb_chk").checked)
        {
            cheque = document.getElementById("pm_check").value-0;
            if (cheque > 0){
                paym = paym + 'cheque ';
            } else cheque = 0;
        }
        if (document.getElementById("chb_gift").checked)
        {
            giftcard = document.getElementById("pm_giftCard").value-0;

            if (gcAmount3  < giftcard){
                alert("On a gift card the rest of "+gcAmount3+" $");
                document.getElementById("pm_giftCard").value = gcAmount3.toFixed(2);
                return;
            }
                totalGC = gcAmount3 - giftcard;
            if (giftcard > 0){
                paym = paym + 'GiftCard:'+document.getElementById("gift_paym").value+' ';
            } else giftcard = 0;
        }
        change = document.getElementById("change_cashe").value-0;

        if ((status == 0) && ((visa + mastercard + amex + cashe + cheque + giftcard) < total)){
            alert("* Money: can not be less than "+ total +"");
            return;
        }

        var actionRec = "";
        if (tp == 2 || tp == 3 ) {
            actionRec = "edit";
        } else {
            actionRec = "add";
        }

//        var gnum = document.getElementById("gift_paym").value;
        document.getElementById("overlay").style.display = "block";
        new Ajax.Request( './check-out.do?rnd=' + Math.random() * 99999, { method: 'get',
                parameters: {
                    action: actionRec,
                    id: "<%=idt%>",
                    id_location: "<%=loc%>",
                    code_transaction: code_trans,
                    id_customer: "<%=id_cust%>",
                    sub_total: sub_total,
                    taxe: taxe,
                    total: total,
                    payment: paym,
                    status: status,
                    created_dt: "<%=dt%>",
                    chg: change,
                    amex: amex,
                    visa: visa,
                    mastercard: mastercard,
                    cheque: cheque,
                    cashe: cashe,
                    giftcard: giftcard,
                    giftcard_pay: giftnum
                },
                onSuccess: function(transport) {
                    var response = new String(transport.responseText);
                        if (giftcard != 0 && status != 2){
                            new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
                            parameters: {
                                query: "giftcard",
                                code: giftnum,
                                created: "123",
                                id_customer: "<%=id_cust%>",
                                amount: totalGC
                            },
                            onSuccess: function(transport) {
                                document.location.href = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
                            }.bind(this),
                            onException: function(instance, exception){
                                alert('Error update gift2: ' + exception);
                            }
                            });
                        } else {
                           document.location.href = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
                        }
                }.bind(this),
                onException: function(instance, exception){
                    alert('Error add reconcil2: ' + exception);
                }
            });

<%--
            var xmlRequestAppointment;
            try {
               xmlRequestAppointment = new XMLHttpRequest();
            }catch(e) {
                try {
                    xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e) {}
            }
        if (tp == 2 ){
                xmlRequestAppointment.open("POST", "./check-out.do?action=edit&id=<%=idt%>&id_location=<%=loc%>&code_transaction="+ code_trans +"&id_customer=<%=id_cust%>&sub_total="+sub_total+"&taxe="+ taxe +"&total="+total+"&payment=" + paym + "&status="+status+"&created_dt=<%=dt%>&chg="+change+"&amex="+amex+"&visa="+visa+"&mastercard="+mastercard+"&cheque="+cheque+"&cashe="+cashe+"&giftcard="+giftcard+"&rnd=" + Math.random());
        }else {
                xmlRequestAppointment.open("POST", "./check-out.do?action=add&id_location=<%=loc%>&code_transaction="+ code_trans +"&id_customer=<%=id_cust%>&sub_total="+sub_total+"&taxe="+ taxe +"&total="+total+"&payment=" + paym + "&status="+status+"&created_dt=<%=dt%>&chg="+change+"&amex="+amex+"&visa="+visa+"&mastercard="+mastercard+"&cheque="+cheque+"&cashe="+cashe+"&giftcard="+giftcard+"&rnd=" + Math.random());
        }
                xmlRequestAppointment.setRequestHeader("Accept-Encoding","text/html; charset=utf-8");
                xmlRequestAppointment.send('');

        if (giftcard != 0){
                            alert("totalGC"+totalGC);
            var gnum = document.getElementById("gift_paym").value;
            alert("gnum"+gnum);
            var xmlRequestAppointmentUpdateGift;
            try {
               xmlRequestAppointmentUpdateGift = new XMLHttpRequest();
            }catch(e) {
                try {
                    xmlRequestAppointmentUpdateGift = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e) {}
            }
                xmlRequestAppointmentUpdateGift.open("POST", "./chkqry?query=giftcard&code="+gnum+"&created=123&amount="+totalGC+"&rnd=" + Math.random());
                xmlRequestAppointmentUpdateGift.setRequestHeader("Accept-Encoding","text/html; charset=utf-8");
                xmlRequestAppointmentUpdateGift.send('');

        } --%>



    }

    function addSelTicket(){
        var empl = '';
        var ctrl = document.getElementById("emp");
        empl = ctrl.value;
        if (empl == '') {
            alert("Please choose an employee!");
            return;
        }
        var serv = '0';
        ctrl = document.getElementById("svc");
        serv = ctrl.value;
        if (serv == '')
            serv = '0';
        var prdt = '0';
        ctrl = document.getElementById("prod");
        prdt = ctrl.value;
        if (prdt == '')
            prdt = '0';
        var new_gc = document.getElementById("numberNewGC").value;
        var new_am = document.getElementById("amountNewGC").value;
        var ex_gc = document.getElementById("numberExistGC").value;
        var ex_am = document.getElementById("reloadExistGC").value;
        if (serv == '0' && prdt == '0' && (new_gc == '' && new_am == '') && (ex_gc == '' && ex_am == '')) {
            alert("Please choose a service or a product!");
            return;
        }
        if (new_gc == '' && new_am == '') {
            new_gc = -1;
        }
        if (ex_gc == '' && ex_am == '') {
            ex_gc = -1;
        }
        var cust = '';
        ctrl = document.getElementById("cust");
        cust = ctrl.value;
        if (cust == '') {
            alert("Please choose an customer!");
            return;
        }
        var app = '';
        <%--var id_app = <%=id_appt%>;--%>
        ctrl = document.getElementById("appoinment_id");
        app = ctrl.value;
//        if ((app == '') && (id_app == '0') && (serv != '0')) {
//            alert("Please choose an appointment!");
//            return;
//        }
//        prdt = 1;
        var cdt = "<%=code_trans%>";
        var status = 0;
        if (cdt == 0)
            cdt = mkTransNum();
        document.location = "./checkout.jsp?dt=<%=dt%>&ide="+empl.toString()+"&idc="+cust.toString()+"&ids="+serv.toString()+"&idp="+prdt+"&ct="+cdt+"&st="+status+"&new_gc="+new_gc+"&new_am="+new_am+"&ex_gc="+ex_gc+"&ex_am="+ex_am+"&tp=<%=tp%>&idt=<%=idt%>&ida="+app+"&rnd=" + Math.random();
    }

    function clear_all(){
        document.getElementById("cust").selectedIndex = 0;
        document.getElementById("emp").selectedIndex = 0;
        document.getElementById("svc").selectedIndex = 0;
        document.getElementById("prod").selectedIndex = 0;
        document.getElementById("appoinment_id").selectedIndex = 0;
        select_OnChange('cust');
        select_OnChange('emp');
        select_OnChange('svc');
        select_OnChange('prod');
        select_OnChange('appoinment_id');
        document.getElementById("emp_search").value = "";
        document.getElementById("svc_search").value = "";
        document.getElementById("prod_search").value = "";
        document.getElementById("amountNewGC").value = "";
        document.getElementById("numberNewGC").value = "";
        document.getElementById("numberExistGC").value = "";
        document.getElementById("balanceExistGC").value = "";
        document.getElementById("reloadExistGC").value = "";
    }

    function mtRand(min, max)
    {
        var range = max - min + 1;
        var n = Math.floor(Math.random() * range) + min;
        return n;
    }

    function mkGiftNum()
    {
        var len=5;
        var giftNum = '';
        var rnd = 0;
        var c = '';
        for (i = 0; i < len; i++) {
            if (i < 3) {
                c = String.fromCharCode(mtRand(48, 57));
            }
            else {
                c = String.fromCharCode(mtRand(97, 122));
            }
            giftNum += c;
        }
        return giftNum;
    }

    function mkTransNum()
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

    function getNumberNewGC(){
        var amountGC_ = document.getElementById("amountNewGC").value;
        if (amountGC_ == "") {
            alert("Please input amount!");
            return;
        }
        document.getElementById("numberNewGC").value = mkGiftNum();
//        createNewGiftCard();
    }

    function createNewGiftCard(){
        var amountGC = document.getElementById("amountNewGC").value;
        var numberGC = document.getElementById("numberNewGC").value;
        var xmlRequestAppointmentGift;
        try {
            xmlRequestAppointmentGift = new XMLHttpRequest();
        } catch(e) {
            try {
                xmlRequestAppointmentGift = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
            }
        }
        xmlRequestAppointmentGift.open("POST", "./chkqry?query=giftcard&code=" + numberGC + "&created=&amount=" + amountGC + "&payment=");
        xmlRequestAppointmentGift.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
        xmlRequestAppointmentGift.send('');

        <%--document.location = "./checkout.do?dt=<%=dt%>";--%>
    }

    function search(type){
        if (service == null){
            service = new Array();
            var opt = document.getElementById("svc").options;
            for (var i = 0; i<opt.length; i++){
                service[i] = opt[i].text;
                serviceid[i] = opt[i].value;
            }
        }
        if (product == null){
            product = new Array();
            var opt = document.getElementById("prod").options;
            for (var i = 0; i<opt.length; i++){
                product[i] = opt[i].text;
                productid[i] = opt[i].value;
            }
        }
        var type_str = type.toString();
        var ctrl;
        var select;
        var selectid;
        var ctr;
        var srch_;
        var srch_str;
        var elem;
        if (type_str == 'svc'){
            ctrl = document.getElementById("searchSvc");
            select = service;
            selectid = serviceid;
            ctr = document.getElementById("svc");
            document.getElementById("searchProd").value = "";
            fill('prod');
        }else {
            ctrl = document.getElementById("searchProd");
            select = product;
            selectid = productid;
            ctr = document.getElementById("prod");
            document.getElementById("searchSvc").value = "";
            fill('svc');
        }
        srch_str = ctrl.value;
        if (srch_str.length > 0){
            ctr.options.length = 0;
            for (var i = 0; i < select.length; i++){
                srch_ = select[i];
                if (srch_.toString().toLowerCase().indexOf(srch_str.toLowerCase()) > -1){
                    elem = new Option(select[i], selectid[i]);
                    ctr.options.add(elem);
                }
            }
        } else{
            ctr.options.length = 0;
            for (var i = 0; i < select.length; i++){
                    elem = new Option(select[i], selectid[i]);
                    ctr.options.add(elem);
                }
        }
    }

    function fill(type){
        var sel;
        var selid;
        var ct;
        var el;
        if (type == "prod"){
            sel = product;
            selid = productid;
            ct = document.getElementById("prod");
        } else {
            sel = service;
            selid = serviceid;
            ct = document.getElementById("svc");
        }
            ct.options.length = 0;
            for (var i = 0; i < sel.length; i++){
                    el = new Option(sel[i], selid[i]);
                    ct.options.add(el);
                }
    }

    function dochkout() {
        var divctrl = document.getElementById('divchk');
        if (divctrl != null)
            divctrl.style.display = 'none';

        var ctrl = document.getElementById("employee_id");
        if (ctrl)
            ctrl.value = document.getElementById("emp").value;
        ctrl = document.getElementById("service_id");
        if (ctrl)
            ctrl.value = document.getElementById("svc").value;
        ctrl = document.getElementById("product_id");
        if (ctrl)
            ctrl.value = document.getElementById("prod").value;
        ctrl = document.getElementById("payment");
        if (ctrl)
            ctrl.value = payment;
        //var frm = document.forms["chkfrm"];
        //frm.submit();

        return true;
    }

    function removeTran(tran_id) {
        try {
            var cb = {
                success:onSuccess = function(o) {
                    document.URL = location.href;//window.location.reload();
                    if (o.responseText != undefined)
                        alert("removeTran: "+o.responseText);
                },
                failure:onFailure = function(o) {
                    alert("Failed deleting the transactions.");
                },
                argument: { }
            };
            YAHOO.util.Connect.asyncRequest('GET', './chkqry?query=trans&action=delete&id=' + tran_id, cb, '');
        } catch(e) {
            alert("Getting code operation error.");
        }
    }
    //-->
    function deleteRow(id){
        if (confirm('Will be removed only Appointment. All tickets attached to this Appointment will not be removed.')){
//                win = window.open('admin/list_appointment.jsp?action=delete&id='+id+'&page=0','win', '');
//                win.close();
            var xmlRequestService;

            try {
                xmlRequestService = new XMLHttpRequest();
            }
            catch(e) {
                try {
                    xmlRequestService = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e) { }
            }

            xmlRequestService.onreadystatechange = function() {
                if (xmlRequestService.readyState ==4 ) {
                    Modalbox.loadContent();
                }
            };

            xmlRequestService.open("POST", 'admin/list_appointment.jsp?action=delete&id='+id+'&page=0');
            xmlRequestService.setRequestHeader("Accept-Encoding","text/html; charset=utf-8");
            xmlRequestService.send('');
        <%--Modalbox.show('history.jsp?id=' + <%=id%> + '&rnd=' + Math.random() * 99999, {width: 1000});--%>
        }
    }
</script>
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
<script>
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
        document.getElementById("giftcard_value").value = 0.0;
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

    var _transNum = 0;

    function savePIOvalue(){
        _payment_method = "";
		inputs = document.getElementsByTagName("input");
		for(a = 0; a < inputs.length; a++) {
			if(inputs[a].name == 'payment_method' && inputs[a].type == 'radio' && inputs[a].checked) {
                _payment_method = inputs[a].value;
			}
		}

        _vendor = document.getElementById("vendor").value;
        _desc = document.getElementById("description").value;
        _total = document.getElementById("total_value").value;

        if(_payment_method != ""  && _total != ""){
            var loc = "<%=loc%>";
            var code_trans = "<%=code_trans%>";
            var cust = <%=id_cust.equals("") ? "0" : "\""+id_cust+"\""%>;
            var sub_total = document.getElementById("subtotal_value").value;
            var taxe = document.getElementById("taxe_value").value;
            var total = document.getElementById("total_value").value;
            if (total == 0) return;
            var paym = _payment_method;
            var status = 4;
            var cdt = document.getElementById("RefundDate").value;//"<%=dt%>";
            var visa = paym == "visa" ? _total : 0;
            var mastercard = paym == "mastercard" ? _total : 0;
            var amex = paym == "amex" ? _total : 0;
            var cheque = paym == "check" ? _total : 0;
            var cashe = paym == "cash" ? _total : 0;
            var change = 0;
            var giftcard = 0;
            var gcAmount = -1;
            var totalGC = 0;
            change = 0;

    		<%--var xmlRequestAppointment;--%>
            <%--try {--%>
    		   <%--xmlRequestAppointment = new XMLHttpRequest();--%>
    		<%--}catch(e) {--%>
    		    <%--try {--%>
    		        <%--xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");--%>
    		    <%--} catch(e) {}--%>
    		<%--}--%>
            <%--xmlRequestAppointment.open("POST", "./check-out.do?action=add&id_location=<%=loc%>&created_dt=" + cdt + "&code_transaction="+--%>
            <%--code_trans +"&id_customer=<%=id_cust%>&sub_total="+sub_total+"&taxe="+ taxe +"&total="+total+"&payment=" + paym + --%>
            <%--"&status="+status+"&created_dt=<%=dt%>&change="+change+"&amex="+amex+"&visa="+visa+"&mastercard="+mastercard+"&cheque="+cheque+"--%>
                    <%--&cashe="+cashe+"&giftcard="+giftcard);--%>
            <%--xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");--%>
            <%--xmlRequestAppointment.send('');--%>
            var t = document.getElementById("refundTicketsList").value;

            document.getElementById("overlay").style.display = "block";
            new Ajax.Request( './check-out.do?rnd=' + Math.random() * 99999, { method: 'get',
                    parameters: {
                        action: "add",
                        id_location: "<%=loc%>",
                        created_dt: cdt,
                        code_transaction: code_trans,
                        id_customer: "<%=id_cust%>",
                        sub_total: sub_total,
                        taxe: taxe,
                        total: total,
                        payment: paym,
                        status: status,
                        <%--created_dt: <%=dt%>,--%>
                        change: change,
                        amex: amex,
                        visa: visa,
                        mastercard: mastercard,
                        cheque: cheque,
                        cashe: cashe,
                        giftcard_pay: "",
                        giftcard: giftcard,
                        ticket_id: t },
            onSuccess: function(transport) {
                        var response = new String(transport.responseText);
                        if(response != ''){
//                             alert(response);
                        }
                                    Modalbox.hide();
                                    document.location.href = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
//                        updateTicketsStatus("4", t);
                    }.bind(this),
                    onException: function(instance, exception){
                        Modalbox.hide();
                        alert('Reconciliation Loading Error: ' + exception);
                    }
                });
        }else{
            alert("Please check fields");
        }
    }

    function updateTicketsStatus(stat, IDs){
        var status = stat;
        var _IDs = IDs;
        new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
                            parameters: {
                                action: "updateTicketsStatus",
                                status: stat,
                                ticketIDs: _IDs
                            },
                            onSuccess: function(transport) {
                                var response = new String(transport.responseText);
                                if(response != ''){
//                                     alert(response);
                                }
                                else
                                {
                                    Modalbox.hide();
                                    document.location.href = "./checkout.do?dt=<%=dt%>&rnd=" + Math.random();
                                }
                            }.bind(this),
                            onException: function(instance, exception){
        					    Modalbox.hide();
                                alert('Error updateTicketsStatus: ' + exception);
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
<table width="998" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" align="center">
    <tr valign="top">
        <%
            String activePage = "Checkout";
            String rootPath = "";
        %>
        <%@ include file="top_page.jsp" %>
    </tr>
    <tr>
        <td height="47" colspan="3">
            <table width="998" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                    <%@ include file="menu_main.jsp" %>
                    <%--<div style = "text-align: right;"><a style="color: white;" href = "./index.jsp"> Sign Out</a> </div>--%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<style>
.floater {
z-index:2;
display:none;
padding:0;
}

.floater td {
font-family: Gill, Helvetica, sans-serif;
background-color:white;
border:1px inset #979797;
color:black;
}

.matchedSmartInputItem {
font-size:0.8em;
padding: 5px 10px 1px 5px;
margin:0;
cursor:pointer;
text-align:left;
}

.selectedSmartInputItem {
color:white;
background-color:#3875D7;
}

#smartInputResults {
padding:0;margin:0;
}

.siwCredit {
margin:0;padding:0;margin-top:10px;font-size:0.7em;color:black;
}

</style>
<script>
    function autoCompleteCustomer(customerID){
		var strURL = 'customerData?search=' + customerID + '&type=0';

		var request = getXmlHttpObject();

		if(request == null)
		{
			alert('Your browser does not support AJAX!');
			return;
		}

		request.open("GET", strURL, true);
		request.onreadystatechange = function()
			{
				if (request.readyState == 4)
				{
					if (request.status == 200)
					{
						xmlDoc = request.responseXML;
						var items = xmlDoc.getElementsByTagName("customer");

                    	document.getElementById('txtFirstName').value = items[0].getAttribute("FirstName");
                    	document.getElementById('txtLastName').value = items[0].getAttribute("LastName");
                    	document.getElementById('txtPhone').value = items[0].getAttribute("Phone");
                    	document.getElementById('txtCellPhone').value = items[0].getAttribute("CellPhone");
                    	document.getElementById('txtEmail').value = items[0].getAttribute("Email");
                    	document.getElementById('email_ticket_client').value = items[0].getAttribute("Email");
					}
				}
			}
		request.send('');
    }

    function select_OnChange(id){
        select = document.getElementById(id);
        options = select.getElementsByTagName("option");
        selOption = options[select.selectedIndex];
        select_setValue(id, selOption.value);
        if(id == 'cust')
            autoCompleteCustomer(selOption.value);
        else if (id == 'emp')
        	document.getElementById('emp_search').value = selOption.childNodes[0].nodeValue.replace(/(^\s+)|(\s+$)/g, "");
        else if (id == 'svc'){
        	document.getElementById('svc_search').value = selOption.childNodes[0].nodeValue.replace(/(^\s+)|(\s+$)/g, "");
        }
        else if (id == 'prod')
        	document.getElementById('prod_search').value = selOption.childNodes[0].nodeValue.replace(/(^\s+)|(\s+$)/g, "");
        else if (id == 'appoinment_id'){
        	//document.getElementById('appoinment_id').value = selOption.childNodes[0].nodeValue.replace(/(^\s+)|(\s+$)/g, "");
        	// select customer
            _select = document.getElementById('cust');
            _options = _select.getElementsByTagName("option");
            var c = 0;
            for(i = 0; i < _options.length; i++) {
                if(_options[i].value == app_client[options[select.selectedIndex].value]){
                    c = i;
                    break;
                }
            }
            _select.selectedIndex = c;
        	// select service
            _select = document.getElementById('svc');
            _options = _select.getElementsByTagName("option");
            c = 0;
            for(i = 0; i < _options.length; i++) {
                if(_options[i].value == app_service[options[select.selectedIndex].value]){
                    c = i;
                    break;
                }
            }
            _select.selectedIndex = c;

        	// select employee
            _select = document.getElementById('emp');
            _options = _select.getElementsByTagName("option");
            c = 0;
            for(i = 0; i < _options.length; i++) {
                if(_options[i].value == app_employee[options[select.selectedIndex].value]){
                    c = i;
                    break;
                }
            }
            _select.selectedIndex = c;

            select_OnChange('svc');
            select_OnChange('cust');
            select_OnChange('emp');
        }
    }
</script>
<div id="customerDiv" style="position:absolute;z-index:5;">
<table id="smartInputFloater" class="floater" cellpadding="0" cellspacing="0">
<tr><td id="smartInputFloaterContent" nowrap="nowrap"></td></tr>
</table>
</div>
         <%
            int id_tran = Integer.parseInt(idt);
            Reconciliation rec = null;
            BigDecimal visa, amex, mastercard, cheque, cashe, change, gc_am;
            visa= amex= mastercard= cheque= cashe= change= gc_am= new BigDecimal(0);
            String gc_num = "";
            boolean recStatus_2 = false;
            boolean recStatus_0 = false;

            if (id_tran != 0 ){
                rec = Reconciliation.findById(id_tran);
                if (rec != null){

                    if (rec.getVisa().compareTo(new BigDecimal(0)) !=0){
                        visa = rec.getVisa();
                    }
                    if (rec.getMastercard().compareTo(new BigDecimal(0)) !=0){
                         mastercard = rec.getMastercard();
                    }
                    if (rec.getAmex().compareTo(new BigDecimal(0)) !=0){
                        amex = rec.getAmex();
                    }
                    if (rec.getCheque().compareTo(new BigDecimal(0)) !=0){
                        cheque = rec.getCheque();
                    }
                    if (rec.getCashe().compareTo(new BigDecimal(0)) !=0){
                        cashe = rec.getCashe();
                    }
                    if (rec.getChange().compareTo(new BigDecimal(0)) !=0){
                        change = rec.getChange();
                    }
                    if (rec.getGiftcard().compareTo(new BigDecimal(0)) !=0){
                        gc_am = rec.getGiftcard();
                        gc_num = rec.getGiftcard_pay();
                    }
                    if (rec.getStatus() == 2) {
                        recStatus_2 = true;
                    }
                    if (rec.getStatus() == 0) {
                        recStatus_0 = true;
                    }
                }
            }
         %>

<table width="998" border="0" cellpadding="0" cellspacing="0" align="center">
<tr>
<td >
<table id="homeTBL" bgcolor="#000000" width="178" height="927" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_01.png" width="178" height="33" alt=""></td>

	</tr>
	<tr>
		<td colspan="10">
			<!--img src="img/checkout_le_final_02.png" width="178" height="19" alt=""-->
                <select name="cust" id="cust" class="styled2" onchange="select_OnChange(this.id); " <%if(tp.equals("-1")){%>disabled<%}%>>
                     <%
                        if (!id_cust.equals("")) {
                            for (int i = 0; i < list_cust.size(); i++) {
                                Customer cust = (Customer)list_cust.get(i);
                                if (id_cust.equals(String.valueOf(cust.getId()))) { %>
                    <option value="<%=cust.getId()%>" selected><%=cust.getFname() + " " + cust.getLname()%></option>
                     <%
                            }
                        }
                    } else {
                                for (int i = 0; i < list_cust.size(); i++) {
                                    Customer cust = (Customer)list_cust.get(i);
                    %>
                    <option value="<%=cust.getId()%>"><%=cust.getFname() + " " + cust.getLname()%></option>
                     <%
                            }
                        }
                    %>
                </select>
		</td>

	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_03.png" width="178" height="9" alt=""></td>
	</tr>
	<tr>
		<td colspan="5">
			<img src="img/checkout_le_final_04.png" width="56" height="19" alt=""></td>
		<td colspan="5">

			<!--img src="img/checkout_le_final_05.png" width="122" height="19" alt=""-->
			<input type="text" <%if(tp.equals("-1")){%>disabled<%}%> class="wickEnabled" name="txtFirstName" id="txtFirstName" style="background: url(img/checkout_le_final_05.png); width: 122px; height: 19px; padding-top: 4px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>
	</tr>
	<tr>
		<td colspan="5">
			<img src="img/checkout_le_final_06.png" width="56" height="21" alt=""></td>
		<td colspan="5">
			<!--img src="img/checkout_le_final_07.png" width="122" height="21" alt=""-->

			<input type="text" <%if(tp.equals("-1")){%>disabled<%}%> class="wickEnabled" name="txtLastName" id="txtLastName" style="background: url(img/checkout_le_final_07.png); width: 122px; height: 19px; padding-top: 5px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>
	</tr>
	<tr>
		<td colspan="5">
			<img src="img/checkout_le_final_08.png" width="56" height="20" alt=""></td>
		<td colspan="5">
			<!--img src="img/checkout_le_final_09.png" width="122" height="20" alt=""-->
			<input type="text" <%if(tp.equals("-1")){%>disabled<%}%> class="wickEnabled" name="txtPhone" value="1-()" id="txtPhone" style="background: url(img/checkout_le_final_09.png); width: 122px; height: 20px; padding-top: 4px; padding-right: 5px; padding-left: 5px; border: 0">

		</td>
	</tr>
	<tr>
		<td colspan="5">
			<img src="img/checkout_le_final_10.png" width="56" height="20" alt=""></td>
		<td colspan="5">
			<!--img src="img/checkout_le_final_11.png" width="122" height="20" alt=""-->
			<input type="text" <%if(tp.equals("-1")){%>disabled<%}%> class="wickEnabled" name="txtCellPhone" value="1-()" id="txtCellPhone" style="background: url(img/checkout_le_final_11.png); width: 122px; height: 19px; padding-top: 5px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>

	</tr>
	<tr>
		<td colspan="5">
			<img src="img/checkout_le_final_12.png" width="56" height="21" alt=""></td>
		<td colspan="5">
			<!--img src="img/checkout_le_final_13.png" width="122" height="21" alt=""-->
			<input type="text" <%if(tp.equals("-1")){%>disabled<%}%> class="wickEnabled" name="txtEmail" id="txtEmail" style="background: url(img/checkout_le_final_13.png); width: 122px; height: 19px; padding-top: 5px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>
	</tr>

	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_14.png" width="178" height="11" alt=""></td>
	</tr>
	<tr>
		<td colspan="10" align=center>
			<!--img src="img/checkout_le_final_15.png" width="89" height="28" alt=""-->
			<!--input type="image" src="img/checkout_le_final_15.png" /-->
		<!--/td>

		<td colspan="3"-->
			<!--img src="img/checkout_le_final_16.png" width="89" height="28" alt=""-->
			<input type="image" src="img/checkout_le_final_16.png"
                   onclick="showHistory();"/>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<!--img src="img/checkout_le_final_17.png" width="59" height="33" alt=""-->
			<input type="image" src="img/checkout_le_final_17.png" onclick="clearCustomerData();" <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%>/>

		</td>
		<td colspan="3">
			<!--img src="img/checkout_le_final_18.png" width="60" height="33" alt=""-->
			<input type="image" src="img/checkout_le_final_18.png" onclick="saveCust(false);" <%if(tp.equals("2") || tp.equals("-1")){%>disabled<%}%>/>
		</td>
		<td>
			<!--img src="img/checkout_le_final_19.png" width="59" height="33" alt=""-->
			<input type="image" src="img/checkout_le_final_19.png" onclick="saveCust(true);" <%if(tp.equals("-1")){%>disabled<%}%>/>
		</td>

	</tr>
	<tr>
		<td colspan="10" align=center>
			<img src="img/checkout_le_final_hr.png" width="175" height="14" alt=""></td>
	</tr>
	<tr>
		<td colspan="7">
			<!--img src="img/checkout_le_final_51.png" width="89" height="31" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> type="image" src="img/checkout_le_final_51.png" onclick="clear_all();" />
		</td>
		<td colspan="3">
			<!--img src="img/checkout_le_final_52.png" width="89" height="31" alt=""-->

			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> type="image" src="img/checkout_le_final_52.png" onclick="addSelTicket();" />
		</td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_20.png" width="178" height="40" alt=""></td>
	</tr>
	<tr>
		<td colspan="10">
			<!--img src="img/checkout_le_final_21.png" width="178" height="20" alt=""-->
                <select name="emp" id="emp" class="styled2" onchange="select_OnChange(this.id); " <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%>>
                        <!--option value="-1">none</option-->
                    <%

                        for (int i = 0; i < list_emp.size(); i++) {
                            Employee emp = (Employee) list_emp.get(i);
                    %>
                    <option value="<%=emp.getId()%>" <%=id_empl.equalsIgnoreCase(String.valueOf(emp.getId())) ? "selected" : ""%>><%=emp.getFname() + " " + emp.getLname()%>
                    </option>
                    <%}%>

                </select>

		</td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_22.png" width="178" height="9" alt=""></td>
	</tr>

	<tr>
		<td colspan="2">
			<!--img src="img/checkout_le_final_23.png" width="31" height="21" alt=""-->
			<input type="image" src="img/checkout_le_final_23.png" />
		</td>
		<td colspan="8">
			<!--img src="img/checkout_le_final_24.png" width="147" height="21" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> id="emp_search" name="emp_search" type="text" class="wickEnabled" style="background: url(img/checkout_le_final_24.png); width: 147px; height: 21px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>

	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_25.png" width="178" height="40" alt=""></td>
	</tr>
	<tr>
		<td colspan="10">
			<!--img src="img/checkout_le_final_26.png" width="178" height="19" alt=""-->
            <select name="svc" id="svc" class = "styled2" onchange="select_OnChange(this.id); " <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%>>
                        <%if (id_serv.equals("0")) {%><option value="0">&nbsp;</option><%}%>
                        <%
                            ArrayList ss = Service.findAllArray();
                            for(int i = 0; i < ss.size(); i++){
                                Service s = (Service)ss.get(i);
                                if (id_serv.equals(Integer.toString(s.getId()))) { %>
                                    <option value="<%=s.getId()%>" selected><%=s.getCode()%></option>
                                <%} else { %>
                                    <option value="<%=s.getId()%>"><%=s.getCode()%></option>
                                <%}
                            }
                        %>
                    </select>
		</td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_27.png" width="178" height="9" alt=""></td>
	</tr>

	<tr>
		<td colspan="2">
			<!--img src="img/checkout_le_final_28.png" width="31" height="21" alt=""-->
			<input type="image" src="img/checkout_le_final_28.png" />
		</td>
		<td colspan="8">
			<!--img src="img/checkout_le_final_29.png" width="147" height="21" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> id="svc_search" name="svc_search" type="text" class="wickEnabled" style="background: url(img/checkout_le_final_29.png); width: 147px; height: 21px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>

	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_30.png" width="178" height="40" alt=""></td>
	</tr>
	<tr>
		<td colspan="10">
			<!--img src="img/checkout_le_final_31.png" width="178" height="19" alt=""-->
            <select name="prod" id="prod" class="styled2" onchange="select_OnChange(this.id); " <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%>>
                <%if ((id_prod.equals("0")) || (id_prod.equals(""))) {%>
                <option value="">&nbsp;</option>
                <%}%>
<%--                 <%
                    Iterator itr = hm_prod.keySet().iterator();
                    while (itr.hasNext()) {
                        Object key = itr.next();
                 %>
                <option value="<%=key%>" <%=key.toString().equalsIgnoreCase(id_prod) ? "selected" : ""%>><%=hm_prod.get(key)%></option>
                <%}%>
--%>
                <%
                    ArrayList pp = Inventory.findAll();
                    for(int i = 0; i < pp.size(); i++){
                        Inventory p = (Inventory)pp.get(i);
                        if (id_prod.equals(Integer.toString(p.getId()))) { %>
                            <option value="<%=p.getId()%>" selected><%=p.getName() + " [" + p.getUpc() + "]"%></option>
                        <%} else { %>
                            <option value="<%=p.getId()%>"><%=p.getName() + " [" + p.getUpc() + "]"%></option>
                        <%}
                    }
                %>
            </select>

		</td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_32.png" width="178" height="9" alt=""></td>
	</tr>
	<tr>
		<td>
			<!--img src="img/checkout_le_final_33.png" width="30" height="20" alt=""-->
			<input type="image" src="img/checkout_le_final_33.png" onClick="processSmartInput(document.getElementById('prod_search'));" />
		</td>
		<td colspan="9">
			<!--img src="img/checkout_le_final_34.png" width="148" height="20" alt=""-->
			<input id="prod_search" <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> name="prod_search" class="wickEnabled" type="text" style="background: url(img/checkout_le_final_34.png); width: 148px; height: 20px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>

	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_30_.png" width="178" height="40" alt=""></td>
	</tr>
	<tr>
		<td colspan="10">
			<!--img src="img/checkout_le_final_31.png" width="178" height="19" alt=""-->
            <select  name="appoinment_id" id="appoinment_id" class="styled2" onchange="select_OnChange(this.id); " <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%>>
                <option value="">&nbsp;</option>
                <%
                    ArrayList appt = Appointment.findAllNotPaidApptbyDate(dt);
                    for(int i = 0; i < appt.size(); i++){
                        Appointment ap = (Appointment)appt.get(i);
                        if ((ap != null) && (hm_cust.get(String.valueOf(ap.getCustomer_id())) != null) && (hm_svc.get(String.valueOf(ap.getService_id())) != null)){
                            if (!hm_svc.get(String.valueOf(ap.getService_id())).toString().toLowerCase().equals("break")){
                                if (id_appt.equals(Integer.toString(ap.getId()))) { %>
                                    <option value="<%=ap.getId()%>" selected title="<%=hm_cust.get(String.valueOf(ap.getCustomer_id())) + " - " + hm_emp.get(String.valueOf(ap.getEmployee_id())) + " - " + hm_svc.get(String.valueOf(ap.getService_id())) + "[" + ap.getSt_time() + ":" + ap.getEt_time() + "]"%>"><%=hm_cust.get(String.valueOf(ap.getCustomer_id())) + " - " + hm_emp.get(String.valueOf(ap.getEmployee_id())) + " - " + hm_svc.get(String.valueOf(ap.getService_id())) + "[" + ap.getSt_time() + ":" + ap.getEt_time() + "]" %> </option>
                                <%} else { %>
                                    <option value="<%=ap.getId()%>" title="<%=hm_cust.get(String.valueOf(ap.getCustomer_id())) + " - " + hm_emp.get(String.valueOf(ap.getEmployee_id())) + " - " + hm_svc.get(String.valueOf(ap.getService_id())) + "[" + ap.getSt_time() + ":" + ap.getEt_time() + "]"%>" ><%=hm_cust.get(String.valueOf(ap.getCustomer_id())) + " - " + hm_emp.get(String.valueOf(ap.getEmployee_id())) + " - " + hm_svc.get(String.valueOf(ap.getService_id())) + "[" + ap.getSt_time() + ":" + ap.getEt_time() + "]"%></option>
                                <%}
                            }
                        }
                    }
                %>
            </select>
            <script>
            var app_client = new Array();
            var app_service = new Array();
            var app_employee = new Array();
            <%
                    for(int i = 0; i < appt.size(); i++){
                        Appointment ap = (Appointment)appt.get(i);
                        %>
                        app_client[<%=ap.getId()%>] = <%=ap.getCustomer_id()%>;
                        app_service[<%=ap.getId()%>] = <%=ap.getService_id()%>;
                        app_employee[<%=ap.getId()%>] = <%=ap.getEmployee_id()%>;
                        <%
                    }
            %>
            </script>
		</td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_32.png" width="178" height="9" alt=""></td>
	</tr>

	<%--<tr>--%>
		<%--<td>--%>
			<%--<!--img src="img/checkout_le_final_33.png" width="30" height="20" alt=""-->--%>
			<%--<input type="image" src="img/checkout_le_final_33.png" onClick="processSmartInput(document.getElementById('appt_search'));" />--%>
		<%--</td>--%>
		<%--<td colspan="9">--%>
			<%--<!--img src="img/checkout_le_final_34.png" width="148" height="20" alt=""-->--%>
			<%--<input id="appt_search" <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> name="appt_search" class="wickEnabled" type="text" style="background: url(img/checkout_le_final_34.png); width: 148px; height: 20px; padding-right: 5px; padding-left: 5px; border: 0">--%>
		<%--</td>--%>

	<%--</tr>--%>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_35.png" width="178" height="40" alt=""></td>
	</tr>
	<tr>
		<td colspan="3">
			<img src="img/checkout_le_final_36.png" width="40" height="20" alt=""></td>
		<td colspan="6">

			<!--img src="img/checkout_le_final_37.png" width="79" height="20" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> id="amountNewGC" name="amountNewGC" type="text" style="background: url(img/checkout_le_final_37.png); width: 79px; height: 20px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>
		<td>
			<!--img src="img/checkout_le_final_38.png" width="59" height="20" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> type="image" src="img/checkout_le_final_38.png" onclick="getNumberNewGC();"/>
		</td>
	</tr>
	<tr>

		<td colspan="10">
			<img src="img/checkout_le_final_39.png" width="178" height="6" alt=""></td>
	</tr>
	<tr>
		<td colspan="4">
			<img src="img/checkout_le_final_40.png" width="55" height="19" alt=""></td>
		<td colspan="6">
			<!--img src="img/checkout_le_final_41.png" width="123" height="19" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> id="numberNewGC" name="numberNewGC" type="text" style="background: url(img/checkout_le_final_41.png); width: 123px; height: 19px; padding-right: 5px; padding-left: 5px; border: 0">

		</td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_42.png" width="178" height="40" alt=""></td>
	</tr>
	<tr>
		<td colspan="5">
			<img src="img/checkout_le_final_43.png" width="56" height="19" alt=""></td>

		<td colspan="5" valign=center>
			<!--img src="img/checkout_le_final_44.png" width="122" height="19" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> id="numberExistGC" name="numberExistGC" type="text" style="background: url(img/checkout_le_final_44.png); width: 103px; height: 19px; padding-right: 5px; padding-left: 5px; border: 0">
            <input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> type="image" src="img/search.png" width="15" onclick="searchGiftCard(); "/>
		</td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/checkout_le_final_45.png" width="178" height="4" alt=""></td>
	</tr>

	<tr>
		<td colspan="8">
			<img src="img/checkout_le_final_46.png" width="95" height="19" alt=""></td>
		<td colspan="2">
			<!--img src="img/checkout_le_final_47.png" width="83" height="19" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> id="balanceExistGC" name="balanceExistGC" type="text" style="background: url(img/checkout_le_final_47.png); width: 83px; height: 19px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>
	</tr>
	<tr>

		<td colspan="8">
			<img src="img/checkout_le_final_48.png" width="95" height="19" alt=""></td>
		<td colspan="2">
			<!--img src="img/checkout_le_final_49.png" width="83" height="19" alt=""-->
			<input <%if((tp.equals("2") && !recStatus_2) || tp.equals("-1")){%>disabled<%}%> id="reloadExistGC" name="reloadExistGC" type="text" style="background: url(img/checkout_le_final_49.png); width: 83px; height: 19px; padding-right: 5px; padding-left: 5px; border: 0">
		</td>
	</tr>
	<tr>
		<td colspan="10">

			<img src="img/checkout_le_final_50.png" width="178" height="23" alt=""></td>
	</tr>
	<tr>
		<td colspan="10">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<img src="img/spacer.gif" width="30" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td>

			<img src="img/spacer.gif" width="9" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="15" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="3" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="30" height="1" alt=""></td>

		<td>
			<img src="img/spacer.gif" width="6" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="24" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="59" height="1" alt=""></td>
	</tr>
</table>
<script>
Custom2.init();
</script>
<script language="javascript" type="text/javascript" src="Js/includes/prototype.js"></script>
<script language="javascript" type="text/javascript" src="Js/scriptaculous/scriptaculous.js?load=builder,effects"></script>
<script language="javascript" type="text/javascript" src="Js/includes/modalbox.js"></script>
<style type="text/css">@import "./css/modalbox.css";</style>

</td>
<td width="30">&nbsp;</td>
<td valign="top">
    <table width="771" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr>
            <td width=33% align=center><%=dt%></td>

            <td width=34% align=center><img src="img/checkout_clientticket.png"></td>
            <td id="trans_num" name="trans_num" width=33% align=center>Transaction #<%=code_trans%></td>
        </tr>
    </table>
    <script>
        var transIDs = new Array();

        function __recalc(id){

            document.getElementById("qty_" + id).value = document.getElementById("qty_" + id).value.replace(/[^0-9]/gi,'');
            document.getElementById("disc_" + id).value = document.getElementById("disc_" + id).value.replace(/[^0-9]/gi,'');
            document.getElementById("price_" + id).value = document.getElementById("price_" + id).value.replace(/[\,]/gi,'.').replace(/[^0-9\.]/gi,'');
            if (document.getElementById("qty_" + id).value=="") document.getElementById("qty_" + id).value = 0;
            if (document.getElementById("disc_" + id).value=="") document.getElementById("disc_" + id).value = 0;
            if (document.getElementById("price_" + id).value=="") document.getElementById("price_" + id).value = 0;
            var sub_total = 0;
            var sub_total_item = 0;
            var taxe = 0;
            var price = 0;
            var _taxe = 0;
            for(i = 0; i < transIDs.length; i++){
                qty = document.getElementById("qty_" + transIDs[i]).value;
                discount = document.getElementById("disc_" + transIDs[i]).value;
                price = document.getElementById("price_real_" + transIDs[i]).value;
                _taxe = document.getElementById("taxe_" + transIDs[i]).value;
                if (discount > 100){
                    discount = 100;
//                    document.getElementById("disc_" + transIDs[i]).value = 100;
                }
                sub_total_item = (qty * price) * (1 - (discount > 100 ? 100 : discount)/100);
                sub_total += sub_total_item;
                document.getElementById("price_" + transIDs[i]).value = sub_total_item.toFixed(2);
                taxe += (qty * price)*(_taxe / 100)* (1 - (discount > 100 ? 100 : discount)/100);
            }
            var total = sub_total + taxe;
            document.getElementById('sub_total').value = sub_total.toFixed(2);
            document.getElementById("taxe").value = taxe.toFixed(2);
            document.getElementById("total").value = total.toFixed(2);

            var qty = document.getElementById("qty_" + id).value;
            var discount = document.getElementById("disc_" + id).value;
            var price_real = document.getElementById("price_real_" + id).value;
            var taxe_tick = document.getElementById("taxe_" + id).value;
            var taxe_real = (qty * price_real)*(taxe_tick / 100)* (1 - (discount > 100 ? 100 : discount)/100);
            new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "updateTicketAndTransValues",
                id: id,
                qty: qty,
                price: price_real,
                subtotal: sub_total,
                taxe: taxe,
                total: total,
                discount: discount,
                taxe_real: taxe_real
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                if (response != ''){
                    alert(response);
                }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error updateTicketValues: ' + exception);
            }
            });

            var request = getXmlHttpObject();
            if (request == null) {
                alert('Your browser does not support AJAX!');
            }

            var strURL = "chkqry?action=checkProductQty&id=" + id + "&qty=" + qty;
    		request.open("GET", strURL, true);
    		request.onreadystatechange = function()
    			{
    				if (request.readyState == 4)
    				{
    					if (request.status == 200)
    					{
    						res = request.responseText;
                            var s = res-0;
    						if(res != '') {
                                if (s < 0) res = 0;
                                alert("Product is out of stock, Available: " + res + " pcs");
//                                document.getElementById("qty_" + id).value = res;
//                                __recalc(id);
    						}
    					}
    				}
    			}
    		request.send(null);

        }

        function __recalc2(id){

//            document.getElementById("qty_" + id).value = document.getElementById("qty_" + id).value.replace(/[^0-9]/gi,'');
//            document.getElementById("disc_" + id).value = document.getElementById("disc_" + id).value.replace(/[\,]/gi,'.').replace(/[^0-9\.]/gi,'');
//            document.getElementById("price_" + id).value = document.getElementById("price_" + id).value.replace(/[\,]/gi,'.').replace(/[^0-9\.]/gi,'');
            var sub_total = 0;
            var sub_total_item = 0;
            var taxe = 0;
            var price = 0;
            var _taxe = 0;
            for(i = 0; i < transIDs.length; i++){
                qty = document.getElementById("qty_" + transIDs[i]).value;
                discount = document.getElementById("disc_" + transIDs[i]).value;
                price = document.getElementById("price_real_" + transIDs[i]).value;
                _taxe = document.getElementById("taxe_" + transIDs[i]).value;
                if (discount > 100){
                    discount = 100;
//                    document.getElementById("disc_" + transIDs[i]).value = 100;
                }
                sub_total_item = (qty * price) * (1 - (discount > 100 ? 100 : discount)/100);
                sub_total += sub_total_item;
//                document.getElementById("price_" + transIDs[i]).value = sub_total_item;
                taxe += (qty * price)*(_taxe / 100)* (1 - (discount > 100 ? 100 : discount)/100);
            }
            var total = sub_total + taxe;
            document.getElementById('sub_total').value = sub_total.toFixed(2);
            document.getElementById("taxe").value = taxe.toFixed(2);
            document.getElementById("total").value = total.toFixed(2);

            var qty = document.getElementById("qty_" + id).value;
            var discount = document.getElementById("disc_" + id).value;
            var price_real = document.getElementById("price_real_" + id).value;
            var taxe_tick = document.getElementById("taxe_" + id).value;
            var taxe_real = (qty * price_real)*(taxe_tick / 100)* (1 - (discount > 100 ? 100 : discount)/100);
            new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "updateTicketAndTransValues",
                id: id,
                qty: qty,
                price: price_real,
                subtotal: sub_total,
                taxe: taxe,
                total: total,
                discount: discount,
                taxe_real: taxe_real
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                if (response != ''){
                    alert(response);
                }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error updateTicketValues: ' + exception);
            }
            });

            var request = getXmlHttpObject();
            if (request == null) {
                alert('Your browser does not support AJAX!');
            }

            var strURL = "chkqry?action=checkProductQty&id=" + id + "&qty=" + qty;
    		request.open("GET", strURL, true);
    		request.onreadystatechange = function()
    			{
    				if (request.readyState == 4)
    				{
    					if (request.status == 200)
    					{
    						res = request.responseText;
                            var s = res-0;
    						if(res != '') {
                                if (s < 0) res = 0;
                                alert("Product is out of stock, Available: " + res + " pcs");
//                                document.getElementById("qty_" + id).value = res;
//                                __recalc(id);
    						}
    					}
    				}
    			}
    		request.send(null);

        }

        function reprice(id){
            var price_real = 0;
            document.getElementById("qty_" + id).value = document.getElementById("qty_" + id).value.replace(/[^0-9]/gi,'');
            document.getElementById("disc_" + id).value = document.getElementById("disc_" + id).value.replace(/[^0-9]/gi,'');
            document.getElementById("price_" + id).value = document.getElementById("price_" + id).value.replace(/[\,]/gi,'.').replace(/[^0-9\.]/gi,'');
            if (document.getElementById("qty_" + id).value=="") document.getElementById("qty_" + id).value = 0;
            if (document.getElementById("disc_" + id).value=="") document.getElementById("disc_" + id).value = 0;
            if (document.getElementById("price_" + id).value=="") document.getElementById("price_" + id).value = 0;
            var price = document.getElementById("price_" + id).value;
            var disc = document.getElementById("disc_" + id).value;
            var qty = document.getElementById("qty_" + id).value;
            price_real = price/(qty*(1-(disc > 100 ? 100 : disc)/100));
            document.getElementById("price_real_" + id).value = price_real;


             __recalc2(id);
        }
    </script>
    <table width="759" height="19" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td><img src="img/checkout_ti_final_table1_01.png" width="235" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_02.png" width="235" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_03.png" width="58" height="19" alt=""></td>

            <td><img src="img/checkout_ti_final_table1_04.png" width="58" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_05.png" width="58" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_06.png" width="58" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_07.png" width="57" height="19" alt=""></td>
        </tr>
         <%
                        BigDecimal _price = new BigDecimal(0.0);
                        BigDecimal _taxe = new BigDecimal(0.0);
                        BigDecimal _total = new BigDecimal(0.0);
                        boolean allRefunded = false;
                        if (!loc.equals("") && !id_cust.equals("")) {
//                            ArrayList transList = TransactionCust.findTransByLocCust(Integer.parseInt(loc), Integer.parseInt(id_cust));
                            ArrayList transList = Ticket.findTicketByLocCodeTrans(Integer.parseInt(loc), code_trans);
                            int qty=1;
                            int count = 0;
                            for (int i = 0; i < transList.size(); i++) {
                                Ticket trans = (Ticket) transList.get(i);
                                count++;
                                BigDecimal price, taxe, total, price_item, taxe_real;
                                String empl = (String) hm_emp.get(String.valueOf(trans.getEmployee_id()));
                                String namesvpr = "";
                                qty = trans.getQty();
                                price = trans.getPrice();
                                price_item = taxe_real = BigDecimal.ONE;
                                price_item = price_item.multiply(new BigDecimal(qty)).multiply(new BigDecimal(1.0-trans.getDiscount()/100.0f)).multiply(price);
                                taxe = trans.getTaxe();
//                                taxe = new BigDecimal(0.0);
                                if (trans.getGiftcard().equals("-1")) {
                                    if (trans.getService_id() == 0) {
                                        Inventory prod = Inventory.findById(trans.getProduct_id());
                                        namesvpr = prod.getName();
                                        taxe_real= prod.getTaxes();
//                                        if (prod.getTaxes().equals(new BigDecimal(0.0))){
//                                            taxe = new BigDecimal(0.0);
//                                        }else{
//                                            taxe = price.multiply(new BigDecimal(qty)).divide(trans.getTaxe().divide(new BigDecimal(100)));
//                                        }
                                    } else {
                                        EmpServ es = EmpServ.findByEmployeeIdAndServiceID(trans.getEmployee_id(), trans.getService_id());
                                        Service serv = Service.findById(trans.getService_id());
                                        namesvpr = serv.getName();
                                        if (es != null){
                                            taxe_real = es.getTaxes();
                                        }else{
                                            taxe_real = serv.getTaxes();
                                        }
                                    }
                                } else {
                                    if (trans.getStatus() == 1)
                                        namesvpr = "Reload Gift Card: #" + trans.getGiftcard();
                                    else
                                        namesvpr = "New Gift Card: #" + trans.getGiftcard();
                                }
                                if (trans.getStatus() == 4){
                                    namesvpr = namesvpr + " <b>REFUNDED</b>";
                                    allRefunded = true;
                                } else allRefunded = false;
                                total = price.multiply(new BigDecimal(qty)).multiply(new BigDecimal(1.0-trans.getDiscount()/100.0f)).add(taxe);
                     %>
        <script>
            transIDs.push(<%=trans.getId()%>);
        </script>
        <tr>
            <td style="color: #000000; width: 235px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
            <%= empl == null ? "none" : empl%>
            </td>

            <td style="color: #000000; width: 235px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
            <%= namesvpr %>
            </td>
            <td id="quant_svc" style="color: #000000; width: 58px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
            <%--<%= qty %> --%>
                <input <%if(tp.equals("-1") || recStatus_0 /*|| tp.equals("2")*/){%>readonly<%}%> id="qty_<%=trans.getId()%>" value="<%=qty%>" onkeyup="__recalc(<%=trans.getId()%>)" style="border-right: solid 0px; width: 57px; border-left: solid 0px; border-top: solid 0px; border-bottom: solid 0px; background-color: #e2e3e4; text-align: center" value="1"/>
            </td>
            <td style="color: #000000; width: 58px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
            <input <%if(tp.equals("-1") || recStatus_0 /*|| tp.equals("2")*/){%>readonly<%}%> id="disc_<%=trans.getId()%>" value="<%=trans.getDiscount()%>" onkeyup="__recalc(<%=trans.getId()%>)" style="border-right: solid 0px; width: 57px; border-left: solid 0px; border-top: solid 0px; border-bottom: solid 0px; background-color: #e2e3e4; text-align: center" value="0"/>
            </td>

            <td id="price_svc" style="color: #000000; width: 58px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                <input <%if(tp.equals("-1") || recStatus_0 /*|| tp.equals("2")*/){%>readonly<%}%> onkeyup="reprice(<%=trans.getId()%>)" id="price_<%=trans.getId()%>" value="<%= price_item.setScale(2,BigDecimal.ROUND_HALF_DOWN) %>" style="color: #000000; border-right: solid 0px; width: 57px; border-left: solid 0px; border-top: solid 0px; border-bottom: solid 0px; background-color: #e2e3e4; text-align: center"/>
                <input type="hidden" id="price_real_<%=trans.getId()%>" value="<%= trans.getPrice().setScale(2,BigDecimal.ROUND_HALF_DOWN) %>" />
                <input type="hidden" id="taxe_<%=trans.getId()%>" value="<%=taxe_real%>" />
            </td>
            <td style="color: #000000; width: 58px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                <%if((!tp.equals("2") && !tp.equals("-1")) || recStatus_2 ){%>
                <a href="#" onclick="if(confirm('Do you really want to delete?')) deleteTicket('<%=dt%>','<%=id_cust%>','<%=idt%>','<%=tp%>','<%=code_trans%>','<%=trans.getId()%>');"><img src="img/checkout_remove_row.png" border="0" /></a>
                <%}else{%>
                &nbsp;
                <%}%>
            </td>
            <td style="color: #000000; width: 57px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                <!--a href="#" onclick=""><img src="img/checkout_remove_row.png" border="0" /></a-->
                <%if (trans.getStatus() != 4) {%><input type="checkbox" id="refund_<%=trans.getId()%>" />
                <% } else { %>
                &nbsp;
                <% } %>
            </td>
        </tr>
         <%
                    _price = price_item.add(_price);
                    _taxe = _taxe.add(taxe);
                    _total = _total.add(total);
                }
             }
         %>
    </table>
    <br />
    <br />
    <br />
    <img src="img/checkout_hr.png" />


    <table id="Table_01" width="691" height="242" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="5" rowspan="2">
                <img src="img/checkout_ti_final_form1_01.png" width="227" height="38" alt=""></td>
            <td colspan="3" rowspan="13" width="238" height="150" valign="bottom">
                <!--img src="img/checkout_ti_final_form1_02.png" width="238" height="150" alt=""-->
                <table style="margin-bottom: 3px;">
                <tr>
                    <td><img src="img/checkout_ti_final_form1_31.png" width="70" height="23" alt=""></td>
                <!--img src="img/checkout_ti_final_form1_32.png" width="84" height="23" alt=""-->
                    <td><input <%if((tp.equals("-1") || tp.equals("2")) && !recStatus_2){%>disabled<%}%> readonly id="change_cashe" name="change_cashe" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_32.png); width: 82px; height: 21px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px" value="<%=change.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"></td>
                </tr>
                </table>
            </td>

            <td colspan="3">
                <img src="img/checkout_ti_final_form1_03.png" width="128" height="31" alt=""></td>
            <td>
                <!--img src="img/checkout_ti_final_form1_04.png" width="97" height="31" alt=""-->
                <input id="sub_total" name="sub_total" readonly type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_04.png); width: 97px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px; text-align:center;" value="<%=_price.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" >
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="31" alt=""></td>
        </tr>

        <tr>
            <td colspan="3" rowspan="3">
                <img src="img/checkout_ti_final_form1_05.png" width="128" height="34" alt=""></td>
            <td rowspan="3">
                <!--img src="img/checkout_ti_final_form1_06.png" width="97" height="34" alt=""-->
                <input id="taxe" name="taxe" type="text" readonly style="text-align:center; background: url(img/checkout_ti_final_form1_06.png); width: 97px; height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 8px; text-align:center;" value="<%=_taxe.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="7" alt=""></td>

        </tr>
        <tr>
            <td colspan="2">
                <!--img src="img/checkout_ti_final_form1_07.png" width="24" height="22" alt=""-->
                <%if(!tp.equals("-1")){%>
                <input type="checkbox"  class="styled3" name="payment_method" id="chb_visa" <%if (visa.compareTo(new BigDecimal(0)) == 1){%>checked<%}%>/>
                <%}%>
            </td>
            <td colspan="2">
                <img src="img/checkout_ti_final_form1_08.png" width="121" height="22" alt=""></td>
            <td>

                <!--img src="img/checkout_ti_final_form1_09.png" width="82" height="22" alt=""-->
                <%--<%if(tp.equals("-1") || tp.equals("2")){%>readonly<%}%>--%>
                <input onblur="setToFixed2('pm_visa')" <%if((tp.equals("-1") || tp.equals("2")) && !recStatus_2){%>disabled<%}%> id="pm_visa" name="pm_visa" onkeyup="ChangeValueCard();" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_09.png); width: 82px; height: 21px; padding-top: 5px; border: 0; padding-left: 5px; padding-right: 5px;" value="<%=visa.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="22" alt=""></td>
        </tr>
        <tr>
            <td colspan="5">
                <img src="img/checkout_ti_final_form1_10.png" width="227" height="5" alt=""></td>

            <td>
                <img src="img/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
        <tr>
            <td colspan="2">
                <!--img src="img/checkout_ti_final_form1_11.png" width="24" height="22" alt=""-->
                <%if(!tp.equals("-1")){%>
                <input type="checkbox" class="styled3"  name="payment_method" id="chb_mastercard" <%if (mastercard.compareTo(new BigDecimal(0)) == 1){%>checked<%}%>/>
                <%}%>
            </td>
            <td colspan="2">

                <img src="img/checkout_ti_final_form1_12.png" width="121" height="22" alt=""></td>
            <td>
                <!--img src="img/checkout_ti_final_form1_13.png" width="82" height="22" alt=""-->
                <input onblur="setToFixed2('pm_mastercard')" id="pm_mastercard" <%if((tp.equals("-1") || tp.equals("2")) && !recStatus_2){%>disabled<%}%> name="pm_mastercard" onkeyup="ChangeValueCard();" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_13.png); width: 82px; height: 21px; padding-top: 5px; border: 0; padding-left: 5px; padding-right: 5px;" value="<%=mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
            </td>
            <td colspan="3" rowspan="3">
                <img src="img/checkout_ti_final_form1_14.png" width="128" height="34" alt=""></td>
            <td rowspan="3">
                <!--img src="img/checkout_ti_final_form1_15.png" width="97" height="34" alt=""-->

                <input id="total" readonly name="total" type="text" style="background: url(img/checkout_ti_final_form1_15.png); width: 97px; height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 8px; text-align:center;" value="<%=_total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="22" alt=""></td>
        </tr>
        <tr>
            <td colspan="5">
                <img src="img/checkout_ti_final_form1_16.png" width="227" height="7" alt=""></td>
            <td>

                <img src="img/spacer.gif" width="1" height="7" alt=""></td>
        </tr>
        <tr>
            <td colspan="2" rowspan="3">
                <!--img src="img/checkout_ti_final_form1_17.png" width="24" height="23" alt=""-->
                <%if(!tp.equals("-1")){%>
                <input type="checkbox" class="styled3" name="payment_method" id="chb_amex" <%if (amex.compareTo(new BigDecimal(0)) == 1){%>checked<%}%>/>
                <%}%>
            </td>
            <td colspan="2" rowspan="3">
                <img src="img/checkout_ti_final_form1_18.png" width="121" height="23" alt=""></td>

            <td rowspan="3">
                <!--img src="img/checkout_ti_final_form1_19.png" width="82" height="23" alt=""-->
                <input onblur="setToFixed2('pm_amex')" id="pm_amex" <%if((tp.equals("-1") || tp.equals("2")) && !recStatus_2){%>disabled<%}%> name="pm_amex" onkeyup="ChangeValueCard();" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_19.png); width: 82px; height: 20px; padding-top: 4px; border: 0; padding-left: 5px; padding-right: 5px;" value="<%=amex.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
        <tr>
            <td colspan="4">

                <img src="img/checkout_ti_final_form1_20.png" width="225" height="7" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="7" alt=""></td>
        </tr>
        <%
            boolean DeleteVisible = true;
            boolean RefundVisible = true;
            boolean SaveVisible = true;
            boolean PayVisible = true;
            boolean PrintVisible = true;
            String __action = StringUtils.defaultString(request.getParameter("actio"), "");

            if(rec != null){
                if(rec.getStatus() == 0){
                    DeleteVisible = PayVisible = false;
                }
                if(rec.getStatus() == 2){
                    RefundVisible = false;
                }
            }

            if(tp.equals("-1")){
                DeleteVisible = SaveVisible = RefundVisible = PayVisible = false;
                if(refFlag)
                    RefundVisible = true;
            }

            if(__action.equals("add") || tp.equals("0")){
                RefundVisible = false;
            }
        %>
        <tr>
            <td rowspan="3">
                <!--img src="img/checkout_ti_final_form1_21.png" width="99" height="21" alt=""-->
            </td>

            <td rowspan="9">
                <!--img src="img/checkout_ti_final_form1_22.png" width="28" height="68" alt=""--></td>
            <td colspan="2" rowspan="11" valign=top>
                <script>
                function save_pay()
                {
                    Modalbox.hide();
                    var bFlag = true;
                    if(document.getElementById("no_receipt").checked)
                    {
                    }else if(document.getElementById("print_receipt").checked)
                    {
                        window.open('./report?query=invoice&varNameTran=<%=request.getParameter("ct")%>','name', 'toolbar=no,directories=no,status=no, menubar=no');
                    }else
                    if(document.getElementById("email_receipt").checked)
                    {
                        bFlag = false;
                        var email_1 = document.getElementById("emailreceipt1").value;
                        var email_2 = document.getElementById("emailreceipt2").value;
                        if(email_1 == "" && email_2 == "")
                            alert("You must enter the e-mail address");
                        else
                        {
                            //window.open('./report?query=invoiceemail&varNameTran=<%=request.getParameter("ct")%>&email_1='+email_1+'&email_2='+email_2,'name', 'toolbar=no,directories=no,status=no, menubar=no');
                            new Ajax.Request( './report?rnd=' + Math.random() * 99999, { method: 'get',
                                    parameters: {
                                        query: "invoiceemail",
                                        varNameTran: '<%=request.getParameter("ct")%>',
                                        email_1: email_1,
                                        email_2: email_2
                                    },
                                    onSuccess: function(transport) {
                                        var response = new String(transport.responseText);
                                        if(response != '')
                                        {
                                            alert(response);
                                            AddReconciliation(0);
                                        }
                                    }.bind(this),
                                    onException: function(instance, exception){
                                        alert('Error send email: ' + exception);
                                    }
                                    });
                        }
                    }
                    if(bFlag)
                        AddReconciliation(0);

                }
                </script>
                <!-- <input type="image" src="img/checkout_pay_options_button.png"
                    onclick="var _t=document.getElementById('total').value; Modalbox.show('./pay_options.jsp?total='+_t+'&ct=<%=code_trans%>&dt=<%=dt%>&idc=<%=id_cust%>&rnd=' + Math.random() * 99999, {width: 600});"/>
                -->
                <%if(PrintVisible){%>
                    <input type="image" src="img/checkout_ti_final_form1_29.png" onclick="if(document.getElementById('chb_gift') != null)AddReconciliation2(2, false, true); document.location.href='./report?query=invoice&varNameTran=<%=code_trans%>'" />
                <%}%>
                <%if(DeleteVisible){%>
                <input type="image" src="img/checkout_ti_final_form1_21.png"  onclick="AddReconciliation(6);" />
                <%}%>
                <%if(SaveVisible){%>
                <input type="image" src="img/checkout_ti_final_form1_34.png"  onclick="AddReconciliation2(2, true, true);" />
                <%}%>
                <%if(RefundVisible){%>
                <input type="image" src="img/checkout_ti_final_form1_28.png"
                    onclick="refundOnClick()"/>
                <%}%>
                <%
                //.x.m.
                if(code_trans.equals("0")==false){%>
                <input type="image" src="img/checkout_send_mail.png"
                    onclick="sendInvoiceEmail(<%=id_cust%>,<%=loc%>, '<%=code_trans%>')"/>
                <%}%>
                <!--img src="img/checkout_ti_final_form1_23.png" width="98" height="21" alt=""-->
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="11" alt=""></td>
        </tr>

        <tr>
            <td colspan="5">
                <img src="img/checkout_ti_final_form1_24.png" width="227" height="5" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
        <tr>
            <td colspan="2" rowspan="2">
                <!--img src="img/checkout_ti_final_form1_25.png" width="24" height="23" alt=""-->

                <%if(!tp.equals("-1")){%>
                <input type="checkbox" class="styled3" name="payment_method" id="chb_cash" <%if (cashe.compareTo(new BigDecimal(0)) == 1){%>checked<%}%> />
                <%}%>
            </td>
            <td colspan="2" rowspan="2">
                <img src="img/checkout_ti_final_form1_26.png" width="121" height="23" alt=""></td>
            <td rowspan="2">
                <!--img src="img/checkout_ti_final_form1_27.png" width="82" height="23" alt=""-->
                <input onblur="setToFixed2('pm_cash')" id="pm_cash" <%if((tp.equals("-1") || tp.equals("2")) && !recStatus_2){%>disabled<%}%> name="pm_cash" onkeyup="calculationChange();" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_27.png); width: 82px; height: 20px; padding-top: 4px; border: 0; padding-left: 5px; padding-right: 5px;" value="<%=cashe.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
            </td>
            <td rowspan="3">
            </td>
            <td rowspan="3">
            </td>

            <td rowspan="3" width="84" height="23">
                <div  style="position: relative; height: 1px; bottom: 80px; left: 20px">
                <%if(PayVisible){%>
                <input type="image" src="img/checkout_quick_pay_button.png" onclick="AddReconciliation(0);" />
                <%}%>
                </div>
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
        <tr>
            <td rowspan="2">
                <!--img src="img/checkout_ti_final_form1_28.png" width="99" height="23" alt=""-->
                <!--AddReconciliation(4);-->
                <%if(RefundVisible){%>
                <script>
                    function refundOnClick(){
                        var refundIDs = "";
                        for(i = 0; i < transIDs.length; i++){
                            var ch = document.getElementById("refund_" + transIDs[i]);
                            if ((ch != null)&&(ch.checked))
                                refundIDs += "%20" + transIDs[i];
                        }
                        if(refundIDs != ''){
                            Modalbox.show('./refund.jsp?dt=<%=dt%>&idt=<%=idt%>&tp=<%=tp%>&idc=<%=id_cust%>&ct=<%=code_trans%>&refundIDs=' + refundIDs
                                + '&rnd=' + Math.random() * 99999, {width: 1000});
                        }else{
                            <% if (allRefunded) { %>
                            alert("Invoice have already been refunded.");
                            <% } else  { %>
                            alert("Please select one or more transactions");
                            <% } %>
                        }
                    }
                </script>
                <%}%>
            </td>
            <!--td colspan="2" rowspan="2">
                <img src="img/checkout_ti_final_form1_29.png" width="98" height="23" alt="">
            </td-->
            <td>
                <img src="img/spacer.gif" width="1" height="18" alt=""></td>
        </tr>
        <tr>
            <td colspan="5" rowspan="2">
                <img src="img/checkout_ti_final_form1_30.png" width="227" height="6" alt=""></td>
            <td>

                <img src="img/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
        <tr>
            <td rowspan="3">
            </td>
            <td rowspan="3">
            </td>
            <td rowspan="3"></td>
            <td rowspan="4">
            </td>
            <td>

                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
        </tr>
        <tr>
            <td colspan="2">
                <%if(!tp.equals("-1")){%>
                <input type="checkbox" class="styled3" name="payment_method" id="chb_chk" <%if (cheque.compareTo(new BigDecimal(0)) == 1){%>checked<%}%>/>
                <%}%>
            </td>
            <td colspan="2">
                <img src="img/checkout_ti_final_form1_37.png" width="121" height="21" alt=""></td>

            <td>
                <!--img src="img/checkout_ti_final_form1_38.png" width="82" height="21" alt=""-->
                <input onblur="setToFixed2('pm_check')" id="pm_check" <%if((tp.equals("-1") || tp.equals("2")) && !recStatus_2){%>disabled<%}%> name="pm_check" onkeyup="ChangeValueCard();" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_38.png); width: 82px; height: 21px; padding-top: 4px; border: 0; padding-left: 5px; padding-right: 5px;" value="<%=cheque.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="21" alt=""></td>
        </tr>
        <tr>
            <td colspan="5" rowspan="3">

                <img src="img/checkout_ti_final_form1_39.png" width="227" height="46" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
        </tr>
        <tr>
            <td colspan="3" rowspan="3">
                <img src="img/checkout_ti_final_form1_40.png" width="238" height="68" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>

        </tr>
        <tr>
            <td colspan="2" rowspan="2">
                <img src="img/checkout_ti_final_form1_41.png" width="110" height="67" alt=""></td>
            <!--td colspan="2" rowspan="2">
                <img src="img/checkout_ti_final_form1_41.png" width="110" height="67" alt=""></td-->
            <td>
                <img src="img/spacer.gif" width="1" height="44" alt=""></td>
        </tr>
        <tr>
            <td>
                <%if(!tp.equals("-1")){%>
                <input type="checkbox" class="styled3" name="payment_method" id="chb_gift" <%if (gc_am.compareTo(new BigDecimal(0)) == 1){%>checked<%}%>/>
                <%}%>
                <%--<img src="img/checkout_ti_final_form1_42.png" width="18" height="23" alt=""></td>--%>
            <td colspan="2">
                <!--img src="img/checkout_ti_final_form1_43.png" width="120" height="23" alt=""-->
                <input id="gift_paym" <%if((tp.equals("-1")) && !recStatus_2){%>disabled<%}%> name="gift_paym" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_43.png); width: 120px; height: 21px; padding-top: 5px; border: 0; padding-left: 5px; padding-right: 5px;" value="<%=gc_num%>">
            </td>
            <td>
                <img src="img/checkout_ti_final_form1_44.png" width="7" height="23" alt=""></td>
            <td>
                <!--img src="img/checkout_ti_final_form1_45.png" width="82" height="23" alt=""-->

                <input <%if((tp.equals("-1") || tp.equals("2")) && !recStatus_2){%>disabled<%}%> onblur="setToFixed2('pm_giftCard')" id="pm_giftCard" name="pm_giftCard" onkeyup="ChangeValueCard();" type="text" style="text-align:center; background: url(img/checkout_ti_final_form1_45.png); width: 82px; height: 21px; padding-top: 3px; border: 0; padding-left: 5px; padding-right: 5px;" value="<%=gc_am.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>">
                <input id = "amntExistGC" name = "amntExistGC" type="hidden" value="-1" />
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="23" alt=""></td>
        </tr>
        <tr>
            <td>
                <img src="img/spacer.gif" width="18" height="1" alt=""></td>
            <td>

                <img src="img/spacer.gif" width="6" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="114" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="7" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="82" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="70" height="1" alt=""></td>

            <td>
                <img src="img/spacer.gif" width="84" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="84" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="99" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="28" height="1" alt=""></td>
            <td>

                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="97" height="1" alt=""></td>
            <td></td>
        </tr>
    </table>
    <img src="img/checkout_hr.png" />
    <script>
    Custom3.init();
    </script>
</td>
</tr>
</table>


<script type="text/javascript">
    YAHOO.namespace("example.container");

    function init() {
        // Define various event handlers for Dialog
        var handleSubmit = function() {
            var ctrl = document.getElementById("employee_id");
            if (ctrl)
                ctrl.value = document.getElementById("emp").value;
            ctrl = document.getElementById("service_id");
            if (ctrl)
                ctrl.value = document.getElementById("svc").value;
            ctrl = document.getElementById("product_id");
            if (ctrl)
                ctrl.value = document.getElementById("prod").value;
            ctrl = document.getElementById("payment");
            if (ctrl)
                ctrl.value = payment;

            this.submit();
        };

        var handleCancel = function() {
            this.cancel();
        };

        var handleSuccess = function(o) {
            //var rs = o.responseText;
            //alert(rs);
            document.URL = location.href;//window.location.reload();
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
            if (data.employee_id == "") {
                alert("Please choose an employee!");
                return false;
            }
            else if (data.service_id == "" && data.product_id == "") {
                alert("Please choose a service or a product!");
                return false;
            } else {
                return true;
            }
        };

        // Wire up the success and failure handlers
        YAHOO.example.container.dialog1.callback = { success: handleSuccess, failure: handleFailure };

        // Render the Dialog
        YAHOO.example.container.dialog1.render();

        YAHOO.util.Event.addListener("amex", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        //YAHOO.util.Event.addListener("amex", "click", YAHOO.example.container.dialog1.hide, YAHOO.example.container.dialog1, true);
        YAHOO.util.Event.addListener("visa", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        YAHOO.util.Event.addListener("mastercard", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        YAHOO.util.Event.addListener("check", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        YAHOO.util.Event.addListener("cash", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
        YAHOO.util.Event.addListener("giftcard", "click", YAHOO.example.container.dialog1.show, YAHOO.example.container.dialog1, true);
    }

    YAHOO.util.Event.onDOMReady(init);
</script>

    <script type="text/javascript" src="script/checkout.js"></script>
    <script>
        <%if(tp.equals("2") || tp.equals("-1") || !code_trans.equals("0")){%>
        try{
            var select = document.getElementById('cust');
            var options = select.getElementsByTagName("option");
            var selOption = options[select.selectedIndex];
            select_setValue('cust', selOption.value);
            autoCompleteCustomer(selOption.value);
        }catch(error){
            alert("finish: "+error);
        }
        <%}
            if (rel.equals("true")) {%>
                updateTransactionValues(false,"edit");
        <%}%>

    </script>

</body>
</html>
