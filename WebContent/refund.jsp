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
<%@ page import="org.xu.swan.bean.*" %>
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
    String id_cust = StringUtils.defaultString(request.getParameter("idc"), "");
    String code_trans = StringUtils.defaultString(request.getParameter("ct"), "");
    String refundStr = StringUtils.defaultString(request.getParameter("refundIDs"), "");
    String action = StringUtils.defaultString(request.getParameter("action"), "");
    String id_trans = StringUtils.defaultString(request.getParameter("idt"), "");

    boolean edit = false;
    if (action.equals("edit")) edit = true;

    String[] refunds = refundStr.split(" ");
    ArrayList refids = new ArrayList(); 
    for(int i = 0; i < refunds.length; i++){
        if(!refunds[i].trim().equals(""))
            refids.add(new Integer(Integer.parseInt(refunds[i].trim())));
    }

    ArrayList list_trans = Transaction.findTransByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt));

    HashMap hm_emp = Employee.findAllMap();
    HashMap hm_cust = Customer.findAllMap();
    HashMap hm_svc = Service.findAllMap();
    HashMap hm_prod = Inventory.findAllMap();

%>
    <input type="hidden" id="refundTicketsList" value="<%=refundStr%>">
        <%
            BigDecimal _price = new BigDecimal(0.0);
            BigDecimal _taxe = new BigDecimal(0.0);
            BigDecimal _total = new BigDecimal(0.0);
            if (!loc.equals("") && !id_cust.equals("")) {
                List transList = Ticket.findTicketByLocCodeTrans(Integer.parseInt(loc), code_trans);
                int qty = 1;
                int count = 0;
                int disc = 0;
                for (int i = 0; i < transList.size(); i++) {
                    Ticket trans = (Ticket) transList.get(i);
                    if(refids.contains(new Integer(trans.getId()))){
                        count++;
                        BigDecimal price, taxe, total;
                        String empl = (String) hm_emp.get(String.valueOf(trans.getEmployee_id()));
                        String namesvpr = "";
                        qty = trans.getQty();
                        disc = trans.getDiscount();
                        price = trans.getPrice();
                        taxe = trans.getTaxe();
                        _price = price.multiply(new BigDecimal(qty)).multiply(new BigDecimal(1.0 - disc/100.0f)).add(_price);
                        _taxe = taxe.multiply(new BigDecimal(qty)).add(_taxe);
                        total = price.multiply(new BigDecimal(qty)).multiply(new BigDecimal(1.0 - disc/100.0f))/*.add(taxe.multiply(new BigDecimal(qty)))*/;
                        _total = _total.add(total);
                        _total = _total.add(_taxe);
                    }
                }
             } else if (!loc.equals("") && !id_trans.equals("") && edit){

            }

            ArrayList a = Reconciliation.findTransByCode(code_trans);
            Reconciliation r = null;
            if (edit) {
                r = Reconciliation.findById(Integer.parseInt(id_trans));
                _total = r.getTotal();
            } else {
                r = (Reconciliation)a.get(0);
            }
            boolean isVisa = r.getPayment().contains("visa");
            boolean isMC = r.getPayment().contains("mastercard");
            boolean isAmex = r.getPayment().contains("amex");
            boolean isCash = r.getPayment().contains("cash");
            boolean isCheck = r.getPayment().contains("check");
            boolean isGiftcard =  r.getPayment().contains("GiftCard");
            BigDecimal visa_value = isVisa ? new BigDecimal(_total.toString()) : new BigDecimal(0);//r.getVisa();
            BigDecimal mastercard_value = isMC ? new BigDecimal(_total.toString()) : new BigDecimal(0);//r.getMastercard();
            BigDecimal amex_value = isAmex ? new BigDecimal(_total.toString()) : new BigDecimal(0);//r.getAmex();
            BigDecimal cash_value = isCash ? new BigDecimal(_total.toString()) : new BigDecimal(0);//r.getCashe();
            BigDecimal check_value = isCheck ? new BigDecimal(_total.toString()) : new BigDecimal(0);//r.getCheque();
            BigDecimal giftcard_value = isGiftcard ? new BigDecimal(_total.toString()) : new BigDecimal(0);
            BigDecimal total = new BigDecimal(0);
/*            if(isVisa)
                total = new BigDecimal(visa_value.toString());
            else if(isMC)
                total = new BigDecimal(mastercard_value.toString());
            else if(isAmex)
                total = new BigDecimal(amex_value.toString());
            else if(isCash)
                total = new BigDecimal(cash_value.toString());
            else if(isCheck)
                total = new BigDecimal(check_value.toString());*/
            total = new BigDecimal(_total.toString());
         %>
    <input type="hidden" id="subtotal_value" value="<%=total.toString()%>">
    <input type="hidden" id="taxe_value" value="0<%=_taxe.toString()%>">
    <div style="width:901px; height: 451px; background: url(img/checkout_payout_bg.png); text-align: right;">
    <br />
    <div style="font-size: 14pt; color: #FFFFFF; cursor: pointer; " onclick="Modalbox.hide()">X&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <br />
    <script type="text/javascript">

    edit_REFUND=<%=edit%>;

    </script>
    <table class="clearTable" width="837" height="355" border="0" cellpadding="0" cellspacing="0" align=center bgcolor="#000000">
        <tr>
            <td colspan="3" rowspan="4" width="147" height="51" style="text-align:center; font-size: 12pt">
                <!--img src="img/checkout_payout_01.png" width="147" height="51" alt=""-->
        		<!--date<br /> time-->
                  <%
                      Date _d = new Date(request.getParameter("dt"));
                      Date d = Calendar.getInstance().getTime();
                      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                      String date = sdf.format(_d);
                      if (edit) date = r.getCreated_dt().toString();
                      String time = Integer.toString(d.getHours()+1) + ":" + (d.getMinutes() < 10 ? "0" : "") + Integer.toString(d.getMinutes());
                  %>
                  <%=date+"<br />" + time%>
                  <input type="hidden" name="RefundDate" id="RefundDate" value="<%=date%>">
                  <input type="hidden" name="CashioDate" id="CashioDate" value="<%=date + " " + time+":00"%>">
                  <input type="hidden" name="reconciliation_id" id="reconciliation_id" value="<%=id_trans%>">
            </td>
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
                #<%=request.getParameter("ct")%>
            </td>
            <td rowspan="6">
                <img src="img/checkout_payout_05.png" width="1" height="134" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="5" alt=""></td>
        </tr>
        <tr>
            <%--<td colspan="4">--%>
                <%--<img src="img/checkout_payout_06.png" width="202" height="36" alt=""></td>--%>
            <%--<td width="37" height="36" bgcolor="#00aeef">--%>
                <%--<!--img src="img/checkout_payout_07.png" width="37" height="36" alt=""-->--%>
                <%--<input type="radio" name="payout" class="styled5" value="in" checked="checked"/>--%>
            <%--</td>--%>
            <%--<td>--%>
                <%--<img src="img/checkout_payout_08.png" width="72" height="36" alt=""></td>--%>
            <%--<td width="36" height="36" bgcolor="#00aeef">--%>
                <%--<!--img src="img/checkout_payout_09.png" width="36" height="36" alt=""-->--%>
                <%--<input type="radio" name="payout" class="styled5" value="out" />--%>
            <%--</td>--%>
            <%--<td colspan="3">--%>
                <%--<img src="img/checkout_payout_10.png" width="180" height="36" alt=""></td>--%>
            <%--<td>--%>
                <%--<img src="img/spacer.gif" width="1" height="36" alt=""></td>--%>
            <td colspan="11">
                <table width="527" height="36" cellspacing="0" cellpadding="0" bgcolor="#00aeef">
                    <tr>
                        <td><img src="img/checkout_refund_06.png" width="30" height="36" alt=""></td>
                        <!--td width="233" valign=center><input type="radio" name="pay_type" class="styled5" value="payout" checked="checked"/>PAYOUT</td>
                        <td width="234" valign=center><input type="radio" name="pay_type" class="styled5" value="refund"/>REFUND</td-->
                        <td width="467" align="center">REFUND</td>
                        <td><img src="img/checkout_refund_10.png" width="30" height="36" alt=""></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="10">
                <img src="img/checkout_payout_11.png" width="527" height="9" alt=""></td>
            <td>
                <img src="img/spacer.gif" width="1" height="9" alt=""></td>
        </tr>
        <tr>
            <td colspan="15" style = "font-size: 22pt; font-family: Calibri; text-align: center;">
                Add tax amount into your refund if need it
            <td>
                <img src="img/spacer.gif" width="1" height="47" alt=""></td>
        </tr>
        <tr>
            <td>
                <!--img src="img/checkout_payout_13.png" width="35" height="34" alt=""-->
                <input type="radio" class="styled4" value="visa" <%=(isVisa ? "checked='checked'" : "")%> id="visa_radio" name="payment_method" onclick="<%=(edit?"setREFvalue(this)":"setPIOvalue(this)")%>"/>
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_14.png" width="147" height="34" alt=""></td>
            <td>
                <!--img src="img/checkout_payout_15.png" width="102" height="34" alt=""-->
                <input type="text" onchange="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" name="visa_value" <%=(edit? "disabled":"")%> value="<%=visa_value.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" id="visa_value" style="text-align: center; background: url(img/checkout_payout_15.png); width: 102px; height: 34px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 5px">
            </td>
            <td colspan="6" rowspan="2">
                <img src="img/checkout_payout_16.png" width="280" height="37" alt=""></td>
            <td colspan="4" rowspan="2">
                <!--img src="img/checkout_payout_17.png" width="271" height="37" alt=""-->
                <input type="text" name="vendor" id="vendor" style="background: url(img/checkout_payout_17.png); width: 271px; height: 37px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 12px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="34" alt=""></td>
        </tr>
        <tr>
            <!--td rowspan="2">
                <img src="img/checkout_payout_18.png" width="35" height="30" alt=""></td-->
            <td width="35" height="30" rowspan="2">
                <input type="radio" class="styled4" value="mastercard" <%=(isMC ? "checked='checked'" : "")%> id="mastercard_radio" name="payment_method" onclick="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" />
            </td>
            <td colspan="3" rowspan="2">
                <img src="img/checkout_payout_19.png" width="147" height="30" alt=""></td>
            <td rowspan="2">
                <!--img src="img/checkout_payout_20.png" width="102" height="30" alt=""-->
                <input type="text" onchange="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" name="mastercard_value" <%=(edit? "disabled":"")%> value="<%=mastercard_value.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" id="mastercard_value" style="text-align:center; background: url(img/checkout_payout_20.png); width: 102px; height: 30px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="3" alt=""></td>
        </tr>
        <tr>
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
        </tr>
        <tr>
            <!--td>
                <img src="img/checkout_payout_23.png" width="35" height="40" alt=""></td-->
            <td width="35" height="40">
                <input type="radio" class="styled4" value="amex" <%=(isAmex ? "checked='checked'" : "")%> id="amex_radio" name="payment_method" onclick="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" />
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_24.png" width="147" height="40" alt=""></td>
            <td>
                <!--img src="img/checkout_payout_25.png" width="102" height="40" alt=""-->
                <input type="text" onchange="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" name="amex_value" <%=(edit? "disabled":"")%> value="<%=amex_value.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" id="amex_value" style="text-align:center; background: url(img/checkout_payout_25.png); width: 102px; height: 40px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 13px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="40" alt=""></td>
        </tr>
        <tr>
            <!--td>
                <img src="img/checkout_payout_26.png" width="35" height="36" alt=""></td-->
            <td width="35" height="36">
                <input type="radio" class="styled4" value="cash" <%=(isCash ? "checked='checked'" : "")%> id="cash_radio" name="payment_method" onclick="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" />
            </td>
            <td colspan="3">
                <img src="img/checkout_payout_27.png" width="147" height="36" alt=""></td>
            <td>
                <!--img src="img/checkout_payout_28.png" width="102" height="36" alt=""-->
                <input type="text" onchange="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" name="cash_value" <%=(edit? "disabled":"")%> value="<%=cash_value.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" id="cash_value" style="text-align:center; background: url(img/checkout_payout_28.png); width: 102px; height: 36px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 10px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="36" alt=""></td>
        </tr>
        <tr>
            <!--td>
                <img src="img/checkout_payout_29.png" width="35" height="31" alt=""></td-->
            <td width="35" height="31">
                <input type="radio" class="styled4" value="check" <%=(isCheck ? "checked='checked'" : "")%> id="check_radio" name="payment_method" onclick="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" />
            </td>
            <td>
                <img src="img/checkout_payout_30.png" width="59" height="31" alt=""></td>
            <td colspan="2">
                <!--img src="img/checkout_payout_31.png" width="88" height="31" alt=""-->
                <!--input type="text" style="background: url(img/checkout_payout_31.png); width: 88px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px"-->
            </td>
            <td>
                <!--img src="img/checkout_payout_32.png" width="102" height="31" alt=""-->
                <input type="text" onchange="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" name="check_value" <%=(edit? "disabled":"")%> value="<%=check_value.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" id="check_value" style="text-align:center; background: url(img/checkout_payout_32.png); width: 102px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="31" alt=""></td>
        </tr>
        <tr>
            <!--td>
                <img src="img/checkout_payout_29.png" width="35" height="31" alt=""></td-->
            <td width="35" height="31">
                <input type="radio" class="styled4" value="giftcard" <%=(isGiftcard ? "checked='checked'" : "")%> id="giftcard_radio" name="payment_method" onclick="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" />
            </td>
            <td>
                <img src="img/checkout_payment_giftcard.gif" width="80" height="31" alt=""></td>
            <td colspan="2">
                <!--img src="img/checkout_payout_31.png" width="88" height="31" alt=""-->
                <!--input type="text" style="background: url(img/checkout_payout_31.png); width: 88px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px"-->
            </td>
            <td>
                <!--img src="img/checkout_payout_32.png" width="102" height="31" alt=""-->
                <input type="text" onchange="<%=(edit?"setREFvalue(this);":"setPIOvalue(this);")%>" name="giftcard_value" <%=(edit? "disabled":"")%> value="<%=giftcard_value.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" id="giftcard_value" style="text-align:center; background: url(img/checkout_payout_32.png); width: 102px; height: 31px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 7px">
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="31" alt=""></td>
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
            <td>
                <img src="img/checkout_payout_37.png" width="1" height="43" alt=""></td>
            <td>
                <img src="img/checkout_payout_38.png" width="1" height="43" alt=""></td>
            <td colspan="2">
                <!--img src="img/checkout_payout_39.png" width="150" height="43" alt=""-->
                <input type="text" value="<%=total.setScale(2,BigDecimal.ROUND_HALF_DOWN)%>" name="total_value" <%=(edit? "disabled":"")%> id="total_value" style="text-align:center; background: url(img/checkout_payout_39.png); width: 150px; height: 43px; border: 0; padding-left: 5px; padding-right: 5px; padding-top: 15px">
            </td>
            <td colspan="2">
                <!--img src="img/checkout_payout_40.png" width="121" height="43" alt=""-->
                <input type="image" src="img/checkout_payout_40.png" onclick="<%=(edit?"saveREFvalue(this);":"if(isDayOpen){savePIOvalue(this);}else{alert('Please open " + date + " day');}")%>"/>
            </td>
            <td>
                <img src="img/spacer.gif" width="1" height="43" alt=""></td>
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

    <script type="text/javascript">
        Custom4.init();
        Custom5.init();

    </script>
