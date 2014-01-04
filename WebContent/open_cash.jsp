<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>

<%
    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id
    ArrayList list_emp = Employee.findAllByLoc(Integer.parseInt(loc));
%>

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

<div id="customerDiv" style="position:absolute;z-index:1000000;">
<table id="smartInputFloater" class="floater" cellpadding="0" cellspacing="0">
<tr><td id="smartInputFloaterContent" nowrap="nowrap"></td></tr>
</table>
</div>

<style>
        span.select6 {
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
</style>

<div style="display:block; width: 901px; height: 490px; background: url(img/open_cash_bg.png);">
    <br />
    <div style="font-size: 14pt; color: #FFFFFF; cursor: pointer; text-align: right" onclick="Modalbox.hide()">X&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
  <table id="homeTBL" width="754" height="430" border="0" cellpadding="0" cellspacing="0" align="center">
  	<tr>
  		<td align=center>
  			<!--img src="img/open_cash_01.png" width="115" height="43" alt=""-->
  			<!--date<br /> time-->
              <%
                  Date _d = new Date(request.getParameter("dt"));
                  Date d = Calendar.getInstance().getTime();
                  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                  String date = sdf.format(_d);
                  String time = Integer.toString(d.getHours()+1) + ":" + (d.getMinutes() < 10 ? "0" : "") + Integer.toString(d.getMinutes());
              %>
              <%=date+"<br />" + time%>
              <input type="hidden" name="CashDrawingDate" id="CashDrawingDate" value="<%=date + " " + time+":00"%>">
              <input type="hidden" name="cashDrawing_id" id="cashDrawing_id" value="0">
              <%--<input type="hidden" name="amex_amount" id="amex_amount" value="0">--%>
              <%--<input type="hidden" name="visa_amount" id="visa_amount" value="0">--%>
              <%--<input type="hidden" name="mastercard_amount" id="mastercard_amount" value="0">--%>
              <input type="hidden" name="creditcard" id="creditcard" value="0">
              <input type="hidden" name="check_amount" id="check_amount" value="0">
              <input type="hidden" name="cash_amount" id="cash_amount" value="0">
              <input type="hidden" name="gift_amount" id="gift_amount" value="0">
              <input type="hidden" name="creditcard_over" id="creditcard_over" value="0">
              <input type="hidden" name="check_over" id="check_over" value="0">
              <input type="hidden" name="cash_over" id="cash_over" value="0">
              <input type="hidden" name="gift_over" id="gift_over" value="0">
              <input type="hidden" name="creditcard_short" id="creditcard_short" value="0">
              <input type="hidden" name="check_short" id="check_short" value="0">
              <input type="hidden" name="cash_short" id="cash_short" value="0">
              <input type="hidden" name="gift_short" id="gift_short" value="0">
      </td>
  		<td colspan="9">
  			<img src="img/open_cash_02.png" width="639" height="43" alt=""></td>
  	</tr>
  	<tr>
  		<td colspan="10">
  			<img src="img/open_cash_03.png" width="754" height="15" alt=""></td>
  	</tr>
  	<tr>
  		<td colspan="4">
  			<img src="img/open_cash_04.png" width="318" height="33" alt=""></td>
  		<td colspan="6">
  			<!--img src="img/open_cash_05.png" width="436" height="33" alt=""-->
  			<%--input type="text" class="wickEnabled" name="OC_employee" value="<%=femp.getFname() + " " + femp.getLname()%>" id="OC_employee" style="border: 0; background: url(img/open_cash_05.png); width: 400px; height: 33px; padding: 10px 185px 0px 5px" /--%>
            <select name="empSelect" id="empSelect" class="styled6">
                <%
                        for(int i = 0; i < list_emp.size(); i++){
                            Employee emp = (Employee) list_emp.get(i);
                            %>
                            <option value="<%=emp.getId()%>"><%=emp.getFname() + " " + emp.getLname()%>
                            </option>
                            <%
                        }
                        //Employee femp = (Employee) list_emp.get(0);
                        
                %>
            </select>
      </td>
  	</tr>
  	<tr>
  		<td colspan="10">
  			<img src="img/open_cash_06.png" width="754" height="43" alt=""></td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<img src="img/open_cash_07.png" width="173" height="37" alt=""></td>
  		<td>
  			<!--img src="img/open_cash_08.png" width="58" height="37" alt=""-->
        <input type="text" onchange="calcAmount('pennies')" name="pennies_qty" id="pennies_qty" value="0"
            style="border: 0; background: url(img/open_cash_08.png); width: 58px; height: 37px; padding: 10px 5px 0px 5px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_09.png" width="118" height="37" alt=""-->
        <input type="text" onchange="calcQty('pennies')" name="pennies_amount" id="pennies_amount"  value="0"
            style="border: 0; background: url(img/open_cash_09.png); width: 118px; height: 37px; padding: 10px 5px 0px 9px" />
      </td>
  		<td>
  			<img src="img/open_cash_10.png" width="174" height="37" alt=""></td>
  		<td colspan="2">
  			<!--img src="img/open_cash_11.png" width="62" height="37" alt=""-->
        <input type="text" onchange="calcAmount('singles')" name="singles_qty" id="singles_qty"  value="0"
            style="border: 0; background: url(img/open_cash_11.png); width: 62px; height: 37px; padding: 10px 5px 0px 10px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_12.png" width="169" height="37" alt=""-->
        <input type="text" onchange="calcQty('singles')" name="singles_amount" id="singles_amount"  value="0"
            style="border: 0; background: url(img/open_cash_12.png); width: 169px; height: 37px; padding: 10px 5px 0px 10px" />
      </td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<img src="img/open_cash_13.png" width="173" height="40" alt=""></td>
  		<td>
  			<!--img src="img/open_cash_14.png" width="58" height="40" alt=""-->
        <input type="text" onchange="calcAmount('nickels')" name="nickels_qty" id="nickels_qty"  value="0"
            style="border: 0; background: url(img/open_cash_14.png); width: 58px; height: 40px; padding: 13px 5px 0px 5px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_15.png" width="118" height="40" alt=""-->
        <input type="text" onchange="calcQty('nickels')" name="nickels_amount" id="nickels_amount"  value="0"
            style="border: 0; background: url(img/open_cash_15.png); width: 118px; height: 40px; padding: 13px 5px 0px 9px" />
      </td>
  		<td>
  			<img src="img/open_cash_16.png" width="174" height="40" alt=""></td>
  		<td colspan="2">
  			<!--img src="img/open_cash_17.png" width="62" height="40" alt=""-->
        <input type="text" onchange="calcAmount('fives')" name="fives_qty" id="fives_qty" value="0"
            style="border: 0; background: url(img/open_cash_17.png); width: 62px; height: 40px; padding: 13px 5px 0px 10px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_18.png" width="169" height="40" alt=""-->
        <input type="text" onchange="calcQty('fives')" name="fives_amount" id="fives_amount" value="0"
            style="border: 0; background: url(img/open_cash_18.png); width: 169px; height: 40px; padding: 13px 5px 0px 10px" />
      </td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<img src="img/open_cash_19.png" width="173" height="39" alt=""></td>
  		<td>
  			<!--img src="img/open_cash_20.png" width="58" height="39" alt=""-->
        <input type="text" onchange="calcAmount('dimes')" name="dimes_qty" id="dimes_qty"  value="0"
            style="border: 0; background: url(img/open_cash_20.png); width: 58px; height: 39px; padding: 12px 5px 0px 5px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_21.png" width="118" height="39" alt=""-->
        <input type="text" onchange="calcQty('dimes')" name="dimes_amount" id="dimes_amount"  value="0"
            style="border: 0; background: url(img/open_cash_21.png); width: 118px; height: 39px; padding: 12px 5px 0px 9px" />
      </td>
  		<td>
  			<img src="img/open_cash_22.png" width="174" height="39" alt=""></td>
  		<td colspan="2">
  			<!--img src="img/open_cash_23.png" width="62" height="39" alt=""-->
        <input type="text" onchange="calcAmount('tens')" name="tens_qty" id="tens_qty"  value="0"
            style="border: 0; background: url(img/open_cash_23.png); width: 62px; height: 39px; padding: 12px 5px 0px 10px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_24.png" width="169" height="39" alt=""-->
            <input type="text" onchange="calcQty('tens')" name="tens_amount" id="tens_amount"  value="0"
                style="border: 0; background: url(img/open_cash_24.png); width: 169px; height: 39px; padding: 12px 5px 0px 10px" />
      </td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<img src="img/open_cash_25.png" width="173" height="39" alt=""></td>
  		<td>
  			<!--img src="img/open_cash_26.png" width="58" height="39" alt=""-->
            <input type="text" onchange="calcAmount('quarters')" name="quarters_qty" id="quarters_qty"  value="0"
                style="border: 0; background: url(img/open_cash_26.png); width: 58px; height: 39px; padding: 12px 5px 0px 5px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_27.png" width="118" height="39" alt=""-->
            <input type="text" onchange="calcQty('quarters')" name="quarters_amount" id="quarters_amount"  value="0"
                style="border: 0; background: url(img/open_cash_27.png); width: 118px; height: 39px; padding: 12px 5px 0px 9px" />
      </td>
  		<td>
  			<img src="img/open_cash_28.png" width="174" height="39" alt=""></td>
  		<td colspan="2">
  			<!--img src="img/open_cash_29.png" width="62" height="39" alt=""-->
        <input type="text" onchange="calcAmount('twenties')" name="twenties_qty" id="twenties_qty"  value="0"
            style="border: 0; background: url(img/open_cash_29.png); width: 62px; height: 39px; padding: 12px 5px 0px 10px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_30.png" width="169" height="39" alt=""-->
        <input type="text" onchange="calcQty('twenties')" name="twenties_amount" id="twenties_amount"  value="0"
            style="border: 0; background: url(img/open_cash_30.png); width: 169px; height: 39px; padding: 12px 5px 0px 10px" />
      </td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<img src="img/open_cash_31.png" width="173" height="39" alt=""></td>
  		<td>
  			<!--img src="img/open_cash_32.png" width="58" height="39" alt=""-->
        <input type="text" onchange="calcAmount('half_dollars')" name="half_dollars_qty" id="half_dollars_qty"  value="0"
            style="border: 0; background: url(img/open_cash_32.png); width: 58px; height: 39px; padding: 12px 5px 0px 5px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_33.png" width="118" height="39" alt=""-->
        <input type="text" onchange="calcQty('half_dollars')" name="half_dollars_amount" id="half_dollars_amount"  value="0"
            style="border: 0; background: url(img/open_cash_33.png); width: 118px; height: 39px; padding: 12px 5px 0px 9px" />
      </td>
  		<td>
  			<img src="img/open_cash_34.png" width="174" height="39" alt=""></td>
  		<td colspan="2">
  			<!--img src="img/open_cash_35.png" width="62" height="39" alt=""-->
        <input type="text" onchange="calcAmount('fifties')" name="fifties_qty" id="fifties_qty"  value="0"
            style="border: 0; background: url(img/open_cash_35.png); width: 62px; height: 39px; padding: 12px 5px 0px 10px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_36.png" width="169" height="39" alt=""-->
        <input type="text" onchange="calcQty('fifties')" name="fifties_amount" id="fifties_amount"  value="0"
            style="border: 0; background: url(img/open_cash_36.png); width: 169px; height: 39px; padding: 12px 5px 0px 10px" />
      </td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<img src="img/open_cash_37.png" width="173" height="40" alt=""></td>
  		<td>
  			<!--img src="img/open_cash_38.png" width="58" height="40" alt=""-->
        <input type="text" onchange="calcAmount('dollars')" name="dollars_qty" id="dollars_qty"  value="0"
            style="border: 0; background: url(img/open_cash_38.png); width: 58px; height: 40px; padding: 13px 5px 0px 5px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_39.png" width="118" height="40" alt=""-->
        <input type="text" onchange="calcQty('dollars')" name="dollars_amount" id="dollars_amount"  value="0"
            style="border: 0; background: url(img/open_cash_39.png); width: 118px; height: 40px; padding: 13px 5px 0px 9px" />
      </td>
  		<td>
  			<img src="img/open_cash_40.png" width="174" height="40" alt=""></td>
  		<td colspan="2">
  			<!--img src="img/open_cash_41.png" width="62" height="40" alt=""-->
        <input type="text" onchange="calcAmount('hundreds')" name="hundreds_qty" id="hundreds_qty"  value="0"
            style="border: 0; background: url(img/open_cash_41.png); width: 62px; height: 40px; padding: 13px 5px 0px 10px" />
      </td>
  		<td colspan="2">
  			<!--img src="img/open_cash_42.png" width="169" height="40" alt=""-->
        <input type="text" onchange="calcQty('hundreds')" name="hundreds_amount" id="hundreds_amount"  value="0"
            style="border: 0; background: url(img/open_cash_42.png); width: 169px; height: 40px; padding: 13px 5px 0px 10px" />
      </td>
  	</tr>
  	<tr>
  		<td colspan="10">
  			<img src="img/open_cash_43.png" width="754" height="15" alt=""></td>
  	</tr>
  	<tr>
  		<td colspan="2">
  			<img src="img/open_cash_44.png" width="173" height="46" alt=""></td>
  		<td colspan="3">
  			<!--img src="img/open_cash_45.png" width="176" height="46" alt=""-->
  			<input type="image" src="img/open_cash_45.png" onclick="saveCashDrawing(0);"/>
      </td>
  		<td colspan="2">
  			<img src="img/open_cash_46.png" width="228" height="46" alt=""></td>
  		<td colspan="2">
  			<!--img src="img/open_cash_47.png" width="121" height="46" alt=""-->
        <input type="text" name="total" id="total"  value="0"
            style="border: 0; background: url(img/open_cash_47.png); width: 121px; height: 46px; padding: 12px 5px 0px 12px" />
      </td>
  		<td>
  			<img src="img/open_cash_48.png" width="56" height="46" alt=""></td>
  	</tr>
  	<tr>
  		<td>
  			<img src="img/spacer.gif" width="115" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="58" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="58" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="87" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="31" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="174" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="54" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="8" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="113" height="1" alt=""></td>
  		<td>
  			<img src="img/spacer.gif" width="56" height="1" alt=""></td>
  	</tr>
  </table>
</div>
<script>
  Custom6.init();
</script>
