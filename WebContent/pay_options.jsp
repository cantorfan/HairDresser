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
    int idc = 0;
    if(!request.getParameter("idc").equals(""))
        idc = Integer.parseInt(request.getParameter("idc"));
    Customer cust = Customer.findById(idc); 
    if(cust == null)
        cust = new Customer();   
%>

<div style="width: 646px; height: 324px; background: url(img/ro_bg.png)">
<br />
<table id="Table_01" width="587" height="261" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td colspan="3" rowspan="2" align=center>
			<!--img src="img/ro_01.png" width="193" height="67" alt=""-->
            <%=request.getParameter("dt")%>
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/ro_02.png" width="86" height="67" alt=""></td>
		<td colspan="3">
			<!--img src="img/ro_03.png" width="215" height="33" alt=""-->
			<input readonly type="text" value="<%=cust.getFname() + " " + cust.getLname()%>" style="width:215px; height: 33px; background: url(img/ro_03.png); border: 0; padding: 10px 5px 5px 3px">
        </td>
		<td colspan="2">
			<a href="#" onclick="Modalbox.hide()"><img src="img/ro_04.png" width="92" height="33" alt="" border=0></a>
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="33" alt=""></td>
	</tr>
	<tr>
		<td colspan="5">
			<img src="img/ro_05.png" width="307" height="34" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="34" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<!--img src="img/ro_06.png" width="32" height="38" alt=""-->
			<input type="radio" name="receipt" id="no_receipt" class="styled7" checked="checked" />
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/ro_07.png" width="161" height="38" alt=""></td>
		<td colspan="7">
			<img src="img/ro_08.png" width="393" height="18" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="18" alt=""></td>
	</tr>
	<tr>
		<td colspan="3" rowspan="2">
			<img src="img/ro_09.png" width="182" height="39" alt=""></td>
		<td colspan="4" rowspan="2">
			<!--img src="img/ro_10.png" width="211" height="39" alt=""-->
			<input type="text" id="emailreceipt1" value="<%=cust.getEmail()%>" style="width:211px; height: 39px; background: url(img/ro_10.png); border: 0; padding: 10px 5px 5px 3px">
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="20" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<!--img src="img/ro_11.png" width="32" height="39" alt=""-->
			<input type="radio" name="receipt" id="print_receipt" class="styled7" />
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/ro_12.png" width="161" height="39" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="19" alt=""></td>
	</tr>
	<tr>
		<td colspan="3" rowspan="2">
			<img src="img/ro_13.png" width="182" height="43" alt=""></td>
		<td colspan="4" rowspan="2">
			<!--img src="img/ro_14.png" width="211" height="43" alt=""-->
			<input type="text" id="emailreceipt2" style="width:211px; height: 43px; background: url(img/ro_14.png); border: 0; padding: 15px 5px 5px 3px">
        </td>
		<td>
			<img src="img/spacer.gif" width="1" height="20" alt=""></td>
	</tr>
	<tr>
		<td rowspan="2">
			<!--img src="img/ro_15.png" width="32" height="46" alt=""-->
			<input type="radio" name="receipt" id="email_receipt" class="styled7" />
        </td>
		<td colspan="2" rowspan="2">
			<img src="img/ro_16.png" width="161" height="46" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="23" alt=""></td>
	</tr>
	<tr>
		<td colspan="7">
			<img src="img/ro_17.png" width="393" height="23" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="23" alt=""></td>
	</tr>
	<tr>
		<td colspan="10">
			<img src="img/ro_18.png" width="586" height="30" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="30" alt=""></td>
	</tr>
	<tr>
		<td colspan="2">
			<img src="img/ro_19.png" width="63" height="40" alt=""></td>
		<td colspan="2">
			<!--img src="img/ro_20.png" width="208" height="40" alt=""-->
			<input type="image" src="img/ro_20.png" onclick="save_pay();"/>
        </td>
		<td colspan="3">
			<img src="img/ro_21.png" width="116" height="40" alt=""></td>
		<td colspan="2">
			<!--img src="img/ro_22.png" width="119" height="40" alt=""-->
			<input type="text" value="<%=request.getParameter("total")%>" readonly style="width:119px; height: 40px; background: url(img/ro_22.png); border: 0; padding: 13px 5px 5px 3px">
        </td>
		<td>
			<img src="img/ro_23.png" width="80" height="40" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="1" height="40" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/spacer.gif" width="32" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="31" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="130" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="78" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="8" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="96" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="12" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="107" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="12" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="80" height="1" alt=""></td>
		<td></td>
	</tr>
</table>
</div>
<script>
	Custom7.init();
</script>
