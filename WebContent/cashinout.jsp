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
    <div align="center">
    <div style="width:901px; height: 451px; background: url(img/checkout_payout_bg.png)">
    <br />
    <div style="font-size: 14pt; color: #FFFFFF; cursor: pointer; text-align: right" onclick="Modalbox.hide()">X&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <table class="clearTable" width="837" height="355" border="0" cellpadding="0" cellspacing="0" align=center bgcolor="#000000">
        <tr>
            <td colspan="3" rowspan="4" width="147" height="51" style="text-align:center; font-size: 12pt">
                <!--img src="img/checkout_payout_01.png" width="147" height="51" alt=""-->
        		<!--date<br /> time-->
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
                  <%=date+"<br />" + time%><input type="hidden" name="CashioDate" id="CashioDate" value="<%=date + " " + time+":00"%>"></td>
            <td colspan="10" rowspan="2">
                <img src="img/checkout_payout_02.png" width="527" height="6" alt=""></td>
            <td colspan="3">
                <img src="img/checkout_payout_03.png" width="162" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
        </tr>
        <tr>
            <td colspan="2" rowspan="3" width="161" height="50" style="text-align:center; font-size: 14pt">
                <!--img src="img/checkout_payout_04.png" width="161" height="50" alt=""-->
                <%if(bAction){%>
                    # <%=rec.getCode_transaction()%>
                    <input type="hidden" name="transNumEdit" id="transNumEdit" value="<%=rec.getCode_transaction()%>">
                    <input type="hidden" name="recID" id="recID" value="<%=rec.getId()%>">
                <%}else{%>
                    # <span id="transNum"></span>
                <%}%></td>
            <td rowspan="6">
                <img src="img/checkout_payout_05.png" width="1" height="134" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
        <tr>
            <%if(!bAction){%>
                <td colspan="4">
                    <img src="img/checkout_payout_06.png" width="202" height="36" alt=""></td>
                <td width="37" height="36" bgcolor="#00aeef">
                    <!--img src="img/checkout_payout_07.png" width="37" height="36" alt=""-->
                    <input type="radio" name="payout" class="styled5" value="in" checked="checked"/>
                </td>
                <td>
                    <img src="img/checkout_payout_08.png" width="72" height="36" alt=""></td>
                <td width="36" height="36" bgcolor="#00aeef">
                    <!--img src="img/checkout_payout_09.png" width="36" height="36" alt=""-->
                   <input type="radio" name="payout" class="styled5" value="out" />
                </td>
                <td colspan="3">
                    <img src="img/checkout_payout_10.png" width="180" height="36" alt=""></td>
                <td>
                    <img src="img/spacer.gif" width="1" height="36" alt=""></td>
             <%}else{%>
             <%}if(bActionView){%>
                <td colspan="10">
                    <%if(rec.getStatus() == 5){%>
                        <img src="img/checkout_payout_IN.png" width="527" height="36" alt="">
                    <%}else{%>
                        <img src="img/checkout_payout_OUT.png" width="527" height="36" alt="">
                    <%}%>
                </td>
            <%}else{%>
            <%}if(bActionEdit){%>
                <td colspan="4">
                    <img src="img/checkout_payout_06.png" width="202" height="36" alt="">
                </td>
                <td width="37" height="36" bgcolor="#00aeef">
                    <input type="radio" <%if(rec.getStatus() == 5){%>checked="true"<%}%>name="payout" class="styled5" value="in"/>
                </td>
                <td>
                    <img src="img/checkout_payout_08.png" width="72" height="36" alt=""></td>
                <td width="36" height="36" bgcolor="#00aeef">
                   <input type="radio" <%if(rec.getStatus() == 3){%>checked="true"<%}%> name="payout" class="styled5" value="out" />
                </td>
                <td colspan="3">
                    <img src="img/checkout_payout_10.png" width="180" height="36" alt=""></td>
                <td>
                    <img src="img/spacer.gif" width="1" height="36" alt=""></td>
            <%}%>
        </tr>
        <tr>
            <td colspan="10">
                <img src="img/checkout_payout_11.png" width="527" height="9" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="9" alt=""></td>
        </tr>
        <tr>
            <td colspan="15">
                <img src="img/checkout_payout_12.png" width="835" height="47" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="47" alt=""></td>
        </tr>
        <tr>
        <%if(!bAction){%>
            <td>
                <!--img src="img/checkout_payout_13.png" width="35" height="34" alt=""-->
                <input type="radio" class="styled4" value="visa" id="visa_radio" name="payment_method" onclick="setPIOvalue(this)"/>
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_14.png" width="147" height="34" alt=""></td>
            <td>
                <!--img src="img/checkout_payout_15.png" width="102" height="34" alt=""-->
                <input type="text" onchange="setPIOvalue(this);" name="visa_value" id="visa_value" style="background: url(img/checkout_payout_15.png); width: 102px; height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px">
            </td>
            <td colspan="6" rowspan="2">
                <img src="img/checkout_payout_16.png" width="280" height="37" alt=""></td>
            <td colspan="4" rowspan="2">
                <!--img src="img/checkout_payout_17.png" width="271" height="37" alt=""-->
                <input type="text" name="vendor" id="vendor" style="background: url(img/checkout_payout_17.png); width: 271px; height: 37px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 12px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="34" alt=""></td>
         <%}else{%>
        <%}if(bActionView){%>
            <td colspan="4">
                <img src="img/checkout_payout_14.png" width="147" height="34" alt=""></td>
            <td>
                <input type="text" disabled="true" name="visa_value" value="<%if(rec.getPayment().equals("visa")){%><%=rec.getVisa().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="background: url(img/checkout_payout_15.png); width: 102px; height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px">
            </td>
            <td colspan="6" rowspan="2">
                <img src="img/checkout_payout_16.png" width="280" height="37" alt=""></td>
            <td colspan="4" rowspan="2">
                <input type="text" name="vendor" disabled="true" value="<%=rec.getVendor()%>" style="background: url(img/checkout_payout_17.png); width: 271px; height: 37px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 12px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="34" alt="">
            </td>
        <%}else{%>
        <%}if(bActionEdit){%>
            <td>
                <input type="radio" class="styled4" value="visa" <%if(rec.getPayment().equals("visa")){%>checked="true" <%}%> id="visa_radio_edit" name="payment_method" onclick="setPIOvalueEdit(this)"/>
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_14.png" width="147" height="34" alt=""></td>
            <td>
                <input type="text" value="<%if(rec.getPayment().equals("visa")){%><%=rec.getVisa().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" onchange="setPIOvalueEdit(this);" name="visa_value" id="visa_value_edit" style="background: url(img/checkout_payout_15.png); width: 102px; height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px">
            </td>
            <td colspan="6" rowspan="2">
                <img src="img/checkout_payout_16.png" width="280" height="37" alt=""></td>
            <td colspan="4" rowspan="2">
                <input type="text" name="vendor" value="<%=rec.getVendor()%>"  id="vendor_edit" style="background: url(img/checkout_payout_17.png); width: 271px; height: 37px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 12px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="34" alt=""></td>
        <%}%>
        </tr>
        <tr>
            <!--td rowspan="2">
                <img src="img/checkout_payout_18.png" width="35" height="30" alt=""></td-->
        <%if(!bAction){%>
            <td width="35" height="30" rowspan="2">
                <input type="radio" class="styled4" value="mastercard" id="mastercard_radio" name="payment_method" onclick="setPIOvalue(this)" />
            </td>
            <td colspan="3" rowspan="2">
                <img src="img/checkout_payout_19.png" width="147" height="30" alt=""></td>
            <td rowspan="2">
                <input type="text" onchange="setPIOvalue(this);" name="mastercard_value" id="mastercard_value" style="background: url(img/checkout_payout_20.png); width: 102px; height: 30px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="3" alt="">
            </td>
        <%}else{%>
        <%}if(bActionView){%>
            <td colspan="4" rowspan="2">
                <img src="img/checkout_payout_19.png" width="147" height="30" alt=""></td>
            <td rowspan="2">
                <input type="text" name="mastercard_value" disabled="true" value="<%if(rec.getPayment().equals("mastercard")){%><%=rec.getMastercard().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="background: url(img/checkout_payout_20.png); width: 102px; height: 30px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="3" alt="">
            </td>
        <%}else{%>
        <%}if(bActionEdit){%>
            <td width="35" height="30" rowspan="2">
                <input type="radio" class="styled4" <%if(rec.getPayment().equals("mastercard")){%>checked="true" <%}%> value="mastercard" id="mastercard_radio_edit" name="payment_method" onclick="setPIOvalueEdit(this)" />
            </td>
            <td colspan="3" rowspan="2">
                <img src="img/checkout_payout_19.png" width="147" height="30" alt=""></td>
            <td rowspan="2">
                <input type="text" value="<%if(rec.getPayment().equals("mastercard")){%><%=rec.getMastercard().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>"  onchange="setPIOvalueEdit(this);" name="mastercard_value" id="mastercard_value_edit" style="background: url(img/checkout_payout_20.png); width: 102px; height: 30px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="3" alt="">
            </td>
        <%}%>
        </tr>
        <tr>
             <%if(!bAction){%>
            <td colspan="6" rowspan="6">
                <img src="img/checkout_payout_21.png" width="280" height="175" alt=""></td>
            <td colspan="5" rowspan="7">
                <!--img src="img/checkout_payout_22.png" width="272" height="176" alt=""-->
                <textarea name="description" id="description" style="background: url('img/checkout_payout_22.png');
                                width: 272px;
                                height: 176px;
                                overflow: hidden;
                                font-size: 8pt;
                                text-align:left;
                                padding-top: 15px;
                                padding-right: 2px;
                                padding-left: 5px;
                                margin: 0px;
                                border: 0;
                                background-color: #000000;"></textarea>
                </td>
            <td>
                <img src="img/spacer.gif" width="1" height="27" alt=""></td>
            <%}else{%>
            <td colspan="6" rowspan="6">
                <img src="img/checkout_payout_21.png" width="280" height="175" alt=""></td>
            <td colspan="5" rowspan="7">
                <textarea id="description_edit" name="description" <%if(bActionView){%>disabled="true"<%}%> style="background: url('img/checkout_payout_22.png');
                                width: 272px;
                                height: 176px;
                                overflow: hidden;
                                font-size: 8pt;
                                text-align:left;
                                padding-top: 15px;
                                padding-right: 2px;
                                padding-left: 5px;
                                margin: 0px;
                                border: 0;
                                background-color: #000000;"><%=rec.getDescription()%></textarea>
                </td>
            <td>
                <img src="img/spacer.gif" width="1" height="27" alt=""></td>
             <%}%>
        </tr>
        <tr>
            <!--td>
                <img src="img/checkout_payout_23.png" width="35" height="40" alt=""></td-->
            <%if(!bAction){%>
            <td width="35" height="40">
                <input type="radio" class="styled4" value="amex" id="amex_radio" name="payment_method" onclick="setPIOvalue(this)" />
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_24.png" width="147" height="40" alt=""></td>
            <td>
                <!--img src="img/checkout_payout_25.png" width="102" height="40" alt=""-->
                <input type="text" onchange="setPIOvalue(this);" name="amex_value" id="amex_value" style="background: url(img/checkout_payout_25.png); width: 102px; height: 40px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 13px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="40" alt=""></td>
            <%}else{%>
            <%}if(bActionView){%>
            <td colspan="4">
                <img src="img/checkout_payout_24.png" width="147" height="40" alt=""></td>
            <td>
                <input type="text" name="amex_value" disabled="true" value="<%if(rec.getPayment().equals("amex")){%><%=rec.getAmex().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="background: url(img/checkout_payout_25.png); width: 102px; height: 40px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 13px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="40" alt=""></td>
            <%}else{%>
            <%}if(bActionEdit){%>
            <td width="35" height="40">
                <input type="radio" class="styled4" value="amex" id="amex_radio_edit" <%if(rec.getPayment().equals("amex")){%>checked="true"<%}%> name="payment_method" onclick="setPIOvalueEdit(this)" />
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_24.png" width="147" height="40" alt=""></td>
            <td>
                <input type="text" onchange="setPIOvalueEdit(this);" name="amex_value" id="amex_value_edit" value="<%if(rec.getPayment().equals("amex")){%><%=rec.getAmex().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="background: url(img/checkout_payout_25.png); width: 102px; height: 40px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 13px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="40" alt=""></td>
            <%}%>
        </tr>
        <tr>
            <%if(!bAction){%>
            <td width="35" height="36">
                <input type="radio" class="styled4" value="cash" id="cash_radio" name="payment_method" onclick="setPIOvalue(this)" />
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_27.png" width="147" height="36" alt=""></td>
            <td>
                <input type="text" onchange="setPIOvalue(this);" name="cash_value" id="cash_value" style="background: url(img/checkout_payout_28.png); width: 102px; height: 36px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 10px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="36" alt=""></td>
            <%}else{%>
            <%}if(bActionView){%>
            <td colspan="4">
                <img src="img/checkout_payout_27.png" width="147" height="36" alt=""></td>
            <td>
                <input type="text" name="cash_value" disabled="true" value="<%if(rec.getPayment().equals("cash")){%><%=rec.getCashe().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>"  style="background: url(img/checkout_payout_28.png); width: 102px; height: 36px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 10px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="36" alt="">
            </td>
            <%}else{%>
            <%}if(bActionEdit){%>
            <td width="35" height="36">
                <input type="radio" class="styled4" value="cash" id="cash_radio_edit" <%if(rec.getPayment().equals("cash")){%>checked="true" <%}%> name="payment_method" onclick="setPIOvalueEdit(this)" />
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_27.png" width="147" height="36" alt=""></td>
            <td>
                <input type="text" onchange="setPIOvalueEdit(this);" value="<%if(rec.getPayment().equals("cash")){%><%=rec.getCashe().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" name="cash_value" id="cash_value_edit" style="background: url(img/checkout_payout_28.png); width: 102px; height: 36px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 10px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="36" alt="">
            </td>
            <%}%>
        </tr>
        <tr>
            <!--td>
                <img src="img/checkout_payout_29.png" width="35" height="31" alt=""></td-->
            <%if(!bAction){%>
            <td width="35" height="31">
                <input type="radio" class="styled4" value="check" id="check_radio" name="payment_method" onclick="setPIOvalue(this)" />
            </td>
            <td>
                <img src="img/checkout_payout_30.png" width="59" height="31" alt=""></td>
            <td colspan="2">
                <!--img src="img/checkout_payout_31.png" width="88" height="31" alt=""-->
                <!--input type="text" style="background: url(img/checkout_payout_31.png); width: 88px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px"-->
            </td>
            <td>
                <!--img src="img/checkout_payout_32.png" width="102" height="31" alt=""-->
                <input type="text" onchange="setPIOvalue(this);" name="check_value" id="check_value" style="background: url(img/checkout_payout_32.png); width: 102px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="31" alt=""></td>
            <%}else{%>
            <%}if(bActionView){%>
            <td>
                <img src="img/checkout_payout_30.png" width="59" height="31" alt=""></td>
            <td colspan="3">
            </td>
            <td>
                <input type="text" name="check_value" disabled="true" value="<%if(rec.getPayment().equals("check")){%><%=rec.getCheque().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" style="background: url(img/checkout_payout_32.png); width: 102px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="31" alt=""></td>
            <%}else{%>
            <%}if(bActionEdit){%>
            <td width="35" height="31">
                <input type="radio" class="styled4" value="check" id="check_radio_edit" <%if(rec.getPayment().equals("check")){%>checked="true" <%}%> name="payment_method" onclick="setPIOvalueEdit(this)" />
            </td>
            <td>
                <img src="img/checkout_payout_30.png" width="59" height="31" alt=""></td>
            <td colspan="2">
            </td>
            <td>
                <input type="text" onchange="setPIOvalueEdit(this);" value="<%if(rec.getPayment().equals("check")){%><%=rec.getCheque().setScale(2,BigDecimal.ROUND_HALF_DOWN)%><%}%>" name="check_value" id="check_value_edit" style="background: url(img/checkout_payout_32.png); width: 102px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="31" alt="">
            </td>
            <%}%>
        </tr>
        <tr>
            <td colspan="5">
                <img src="img/checkout_payout_33.png" width="284" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
        </tr>
        <tr>
            <td colspan="5" rowspan="3">
                <img src="img/checkout_payout_34.png" width="284" height="84" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="40" alt=""></td>
        </tr>
        <tr>
            <td>
                <img src="img/checkout_payout_35.png" width="1" height="1" alt=""></td>
            <td colspan="5" rowspan="2">
                <img src="img/checkout_payout_36.png" width="279" height="44" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
        </tr>
        <tr>
        <%if(!bAction){%>             
            <td>
                <img src="img/checkout_payout_37.png" width="1" height="43" alt=""></td>
            <td>
                <img src="img/checkout_payout_38.png" width="1" height="43" alt=""></td>
            <td colspan="2">
                <!--img src="img/checkout_payout_39.png" width="150" height="43" alt=""-->
                <input type="text" name="total_value" id="total_value" style="background: url(img/checkout_payout_39.png); width: 150px; height: 43px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 15px">
            </td>
            <td colspan="2">
                <!--img src="img/checkout_payout_40.png" width="121" height="43" alt=""-->
                <input type="image" src="img/checkout_payout_40.png" onclick="savePIOvalue();"/>
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="43" alt=""></td>
        <%}else{%>
        <%}if(bActionView){%>
            <td>
                <img src="img/checkout_payout_37.png" width="1" height="43" alt=""></td>
            <td>
                <img src="img/checkout_payout_38.png" width="1" height="43" alt=""></td>
            <td colspan="2">
                <input type="text" name="total_value" disabled="true" value="<%=rec.getVisa().add(rec.getMastercard().add(rec.getAmex().add(rec.getCashe().add(rec.getCheque())))).setScale(2,BigDecimal.ROUND_HALF_DOWN)%>"  style="background: url(img/checkout_payout_39.png); width: 150px; height: 43px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 15px">
            </td>
            <td colspan="2">
                <input type="image" src="img/checkout_payout_40.png" onclick="Modalbox.hide();"/>
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="43" alt="">
            </td>
        <%}else{%>
        <%}if(bActionEdit){%>
            <td>
                <img src="img/checkout_payout_37.png" width="1" height="43" alt=""></td>
            <td>
                <img src="img/checkout_payout_38.png" width="1" height="43" alt=""></td>
            <td colspan="2">
                <input type="text" name="total_value" id="total_value_edit" value="<%=rec.getVisa().add(rec.getMastercard().add(rec.getAmex().add(rec.getCashe().add(rec.getCheque())))).setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" style="background: url(img/checkout_payout_39.png); width: 150px; height: 43px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 15px">
            </td>
            <td colspan="2">
                <input type="image" src="img/checkout_payout_40.png" onclick="editPIOvalue();"/>
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="43" alt=""></td>
        <%}%>
        </tr>
        <tr>
            <td>
                <img src="img/spacer.gif" width="35" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="59" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="53" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="35" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="102" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="64" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="37" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="72" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="36" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="70" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="109" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="41" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="120" height="1" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="1" alt=""></td>
            <td></td>
        </tr>
    </table>
    </div>
   </div>
    <script type="text/javascript">
        Custom4.init();
        Custom5.init();
        _transNum = createTransNum();
        document.getElementById("transNum").innerHTML = _transNum;
    </script>
