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
    int id = Integer.parseInt(StringUtils.defaultString(request.getParameter("tran"), ""));
    String action = StringUtils.defaultString(request.getParameter("action"), "");
    String rootPath = StringUtils.defaultString(request.getParameter("rootPath"), "");

    boolean bActionDelete = false;

    if(action.equals("delete"))
        bActionDelete = true;

    boolean bAction = bActionDelete;
    Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(dt);
    if (lMatcher.matches()) {
        dt = dt.trim().replace('-', '/').replaceAll("/0", "/");
    } else {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
        dt = sdf.format(Calendar.getInstance().getTime());
    }

    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id

    Reconciliation rec = Reconciliation.findById(id);
%>    
<div style="width: 662px; height: 242px; background: url(<%=rootPath%>img/dt_bg.png);">
<br />
<table width="617" height="175" border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td>
			<!--img src="img/deltrans_01.png" width="104" height="74" alt=""-->
                  <%
                      Date _d;
                      String time;
                      _d = rec.getCreated_dt();
                      time = "0:00:00";
                      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                      String date = sdf.format(_d);
                  %>
                  <%=date%>
            </td>
		<td colspan="4">
			<img src="<%=rootPath%>img/deltrans_02.png" width="413" height="74" alt=""></td>
		<td colspan="2">
			<a href="#" onclick="Modalbox.hide()"><img src="<%=rootPath%>img/deltrans_03.png" border=0 width="100" height="74" alt=""></a>
        </td>
	</tr>
	<tr>
		<td colspan="2">
			<img src="<%=rootPath%>img/deltrans_04.png" width="166" height="38" alt=""></td>
		<td>
			<!--img src="img/deltrans_05.png" width="206" height="38" alt=""-->
			<input type="text"  name="user" id="user" style="width: 206px; height: 38px; background: url(<%=rootPath%>img/deltrans_05.png); border: 0; padding: 11px 10px 5px 10px;">
        </td>
		<td>
			<img src="<%=rootPath%>img/deltrans_06.png" width="88" height="38" alt=""></td>
		<td colspan="2" align=center>
			<!--img src="img/deltrans_07.png" width="107" height="38" alt=""-->
                #<%=rec.getCode_transaction()%>
                <input type="hidden" name="transNumEdit" id="transNumEdit" value="<%=rec.getCode_transaction()%>">
                <input type="hidden" name="recID" id="recID" value="<%=rec.getId()%>">
        </td>
		<td>
			<img src="<%=rootPath%>img/deltrans_08.png" width="50" height="38" alt=""></td>
	</tr>
	<tr>
		<td colspan="7">
			<img src="<%=rootPath%>img/deltrans_09.png" width="617" height="21" alt=""></td>
	</tr>
	<tr>
		<td colspan="2">
			<img src="<%=rootPath%>img/deltrans_10.png" width="166" height="41" alt=""></td>
		<td>
			<!--img src="img/deltrans_11.png" width="206" height="41" alt=""-->
			<input type="password" name="pwd" id="pwd" style="width: 206px; height: 41px; background: url(<%=rootPath%>img/deltrans_11.png); border: 0; padding: 11px 10px 5px 10px;">
        </td>
		<td colspan="4">
			<!--img src="img/deltrans_12.png" width="245" height="41" alt=""-->
			<input type="image" src="<%=rootPath%>img/deltrans_12.png"  onclick="deleteTransaction(document.getElementById('user').value,document.getElementById('pwd').value,<%=rec.getId()%>);"/>
        </td>
	</tr>
	<tr>
		<td>
			<img src="<%=rootPath%>img/spacer.gif" width="104" height="1" alt=""></td>
		<td>
			<img src="<%=rootPath%>img/spacer.gif" width="62" height="1" alt=""></td>
		<td>
			<img src="<%=rootPath%>img/spacer.gif" width="206" height="1" alt=""></td>
		<td>
			<img src="<%=rootPath%>img/spacer.gif" width="88" height="1" alt=""></td>
		<td>
			<img src="<%=rootPath%>img/spacer.gif" width="57" height="1" alt=""></td>
		<td>
			<img src="<%=rootPath%>img/spacer.gif" width="50" height="1" alt=""></td>
		<td>
			<img src="<%=rootPath%>img/spacer.gif" width="50" height="1" alt=""></td>
	</tr>
</table>
</div>

    <!--div style="width:901px; height: 451px; background: url(img/checkout_payout_bg.png)">
    <br />
    <div style="font-size: 14pt; color: #FFFFFF; cursor: pointer; text-align: right" onclick="Modalbox.hide()">X&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <table class="clearTable" width="837" height="355" border="0" cellpadding="0" cellspacing="0" align=center bgcolor="#000000">
        <tr>
            <td width="147" height="51" style="text-align:center; font-size: 12pt">
            </td>
            <td width="527" height="51">
                <img src="img/deletetran_delete_all.png" width="527" height="51" alt="">
            </td>
            <td width="161" height="51" style="text-align:center; font-size: 14pt">
                <%--# <%=rec.getCode_transaction()%>--%>
                <%--<input type="hidden" name="transNumEdit" id="transNumEdit" value="<%=rec.getCode_transaction()%>">--%>
                <%--<input type="hidden" name="recID" id="recID" value="<%=rec.getId()%>">--%>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <img src="img/checkout_payout_12.png" width="835" height="47" alt="">
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <img src="img/login_03.png" width="190" height="33" alt="">
                <input type="text" name="user" id="user" style="border: 0; background:url(img/login_06.png) no-repeat; width:190px; height: 44px; padding-left: 10px; padding-right: 10px; padding-top: 15px"/>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <img src="img/login_07.png" width="190" height="59" alt="">
                <input type="password" name="pwd" id="pwd" style="border: 0; background:url(img/login_08.png) no-repeat; width:190px; height: 42px; padding-left: 10px; padding-right: 10px; padding-top: 15px"/>
            </td>
        </tr>
        <tr>
            <td>
                <input type="image" src="img/rec_lc_11.png" onclick="deleteTransaction(document.getElementById('user').value,document.getElementById('pwd').value,<%=rec.getId()%>);"/>
            </td>
        </tr>
    </table>
    </div-->
