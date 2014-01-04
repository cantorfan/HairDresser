<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%
    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id
    String id_cust = StringUtils.defaultString(request.getParameter("idc"), "");
%>
<div align="center">
    <div style="width:901px; height: 451px; background: url(img/checkout_payout_bg.png); ">
    <div style="font-size: 14pt; color: #FFFFFF; position: relative; top: 20px;
        left: 380px; height: 0; width: 0; cursor: pointer" onclick="Modalbox.hide()">X</div>
    <br />
    <br />
    <div style="height: 400px; width: 850px;overflow-y: scroll; overflow-x:hidden">
    <table width="644" height="19" border="0" cellpadding="0" cellspacing="0" align=center>
        <tr>
            <td><img src="img/checkout_ti_final_table1_01.png" width="235" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_02.png" width="235" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_03.png" width="58" height="19" alt=""></td>

            <td><img src="img/checkout_ti_final_table1_04.png" width="58" height="19" alt=""></td>
            <td><img src="img/checkout_ti_final_table1_05.png" width="58" height="19" alt=""></td>
        </tr>
         <%
                        BigDecimal _price = new BigDecimal(0.0);
                        BigDecimal _taxe = new BigDecimal(0.0);
                        BigDecimal _total = new BigDecimal(0.0);
                        HashMap hm_emp = Employee.findAllMap();
                        HashMap hm_serv = Service.findAllMap();
                        HashMap hm_prod = Inventory.findAllMap();
                        if (!loc.equals("") && !id_cust.equals("")) {
                            ArrayList transList = Ticket.findTicketByLocCustomer(Integer.parseInt(loc), Integer.parseInt(id_cust));
                            int qty=0;
                            int disc = 0;
                            int count = 0;
                            for (int i = 0; i < transList.size(); i++) {
                                Ticket trans = (Ticket) transList.get(i);
                                count++;
                                BigDecimal price, taxe, total;
                                String empl = (String) hm_emp.get(String.valueOf(trans.getEmployee_id()));
                                String namesvpr = "";
                                qty = trans.getQty();
                                disc = trans.getDiscount();
                                taxe = trans.getTaxe().multiply(new BigDecimal(qty));
                                price = (trans.getPrice().multiply(new BigDecimal(qty)).multiply(new BigDecimal(1).subtract(new BigDecimal(disc).divide(new BigDecimal(100))))).add(taxe);                                
                                if (trans.getService_id() == 0 && trans.getProduct_id() !=0) {
                                    namesvpr = (String)hm_prod.get(String.valueOf(trans.getProduct_id()));
                                } else if (trans.getService_id() != 0 && trans.getProduct_id() ==0) {
                                    namesvpr = (String)hm_serv.get(String.valueOf(trans.getService_id()));
                                } else if (!trans.getGiftcard().equals("-1")){
                                    namesvpr = "GIFTCARD: #"+trans.getGiftcard();
                                } else {
                                    namesvpr = "UNKNOWN";    
                                }
                     %>
                    <tr>
                        <td style="color: #000000; width: 235px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                        <%= empl %>
                        </td>
            
                        <td style="color: #000000; width: 235px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                        <%= namesvpr %>
                        </td>
                        <td id="quant_svc" style="color: #000000; width: 58px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                        <%--<%= qty %> --%>
                            <input id="qty" style="border-right: solid 0px; width: 57px; border-left: solid 0px; border-top: solid 0px; border-bottom: solid 0px; background-color: #e2e3e4; text-align: center" value="<%=qty%>"/>
                        </td>
                        <td style="color: #000000; width: 58px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                        <input id="disc" style="border-right: solid 0px; width: 57px; border-left: solid 0px; border-top: solid 0px; border-bottom: solid 0px; background-color: #e2e3e4; text-align: center" value="<%=disc%>"/>
                        </td>
            
                        <td id="price_svc" style="color: #000000; width: 58px; height: 33px; border-right: solid 1px #b8babd; border-bottom: solid 1px #7a7879; background-color: #e2e3e4; text-align: center">
                        <%= price.setScale(2,BigDecimal.ROUND_HALF_DOWN) %>
                        </td>
                    </tr>
                 <%
                        }
                     }
                 %>
    </table>
    </div>
    </div>
    </div>
