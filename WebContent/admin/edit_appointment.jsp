<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
<%@ page import="java.sql.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
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
    Appointment appt = null;
    ResourcesManager resx = new ResourcesManager();
//    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String action = ActionUtil.ACT_EDIT; // ONLY EDIT APPOINTMENT
    String id = StringUtils.defaultString(request.getParameter(Appointment.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        appt = Appointment.findById(Integer.parseInt(id));
    else
        appt = (Appointment) request.getAttribute("OBJECT");

    ArrayList empList = Employee.findAll();
    ArrayList svcList = Service.findAll();
    ArrayList custList = Customer.findAll();
    ArrayList locList = Location.findAll();
    ArrayList cateList = Category.findAll();


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Edit Appointment</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
        <script type="text/javascript" src="../Js/formvalidate.js"></script>
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
		<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
			<tr valign="top">
                <%
                    String activePage = "Admin";
                    String rootPath = "../";
                %>
                <%@ include file="../top_page.jsp" %>
			</tr>
			<tr>
				<td height="47" colspan="3">
                     <%@ include file="../menu_main.jsp" %>
				</td>
			</tr>
            <%@ include file="menu.jsp"%>
		</table>
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1>Edit Appointment</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <!-- success/error message:
                            <div class="error"><p>Error message</p></div>
                            <div class="success"><p>Success message</p></div>
                            -->
                            <form id="appointment" name="appointment" method="post" action="./appointment.do?action=<%=action%>" onsubmit="javascript: return formvalidate(this);">
                                <%--<logic:notPresent name="org.apache.struts.action.MESSAGE" scope="application">--%>
                                <%--<font color="red"> ERROR: Application resources not loaded -- check servlet container logs for error messages. </font>--%>
                                <%--</logic:notPresent>--%>
                                <%--<% String prompt = (String) request.getAttribute("MESSAGE");  if (StringUtils.isNotEmpty(prompt)){%>--%>
                                <%--<p><font color="red" face=verdana size="-1"> <bean:message key="<%=prompt%>"/> </font></p><%}%>--%>
                                    <div class="validation"><%=resx.getREQMESSAGE()%></div>
                                <input name="id" type="hidden" value="<%=(appt!=null?String.valueOf(appt.getId()):"")%>">

                                <div class="field">
                                    <label for="customer_id">Customer <%=resx.getVALIDATOR()%></label>
                                    <select valid="select" id="customer_id" name="customer_id">
                                    <%for(int i=0; i<custList.size(); i++){
                                        Customer cust = (Customer)custList.get(i);%>
                                        <option value="<%=cust.getId()%>" <%=(appt!=null && appt.getCustomer_id()==cust.getId()?"selected":"")%>><%=cust.getFname() + " " + cust.getLname()%></option>
                                    <%}%>
                                    </select>
                                </div>

                                <div class="field">
                                    <label for="employee_id">Employee <%=resx.getVALIDATOR()%></label>
                                    <select valid="select" id="employee_id" name="employee_id">
                                    <%for(int i=0; i<empList.size(); i++){
                                        Employee emp = (Employee)empList.get(i);%>
                                        <option value="<%=emp.getId()%>" <%=(appt!=null && appt.getEmployee_id()==emp.getId()?"selected":"")%>><%=emp.getFname() + " " + emp.getLname()%></option>
                                    <%}%>
                                    </select>
                                </div>

                                <div class="field">
                                    <label for="service_id">Service <%=resx.getVALIDATOR()%></label>
                                    <select valid="select" id="service_id" name="service_id" >
                                    <%for(int i=0; i<svcList.size(); i++){
                                        Service svc = (Service)svcList.get(i);%>
                                        <option value="<%=svc.getId()%>" <%=(appt!=null && appt.getService_id()==svc.getId()?"selected":"")%>><%=svc.getName()%></option>
                                    <%}%>
                                    </select>
                                </div>

                                <%--<div class="field">--%>
                                    <%--<label for="price">Price <%=resx.getVALIDATOR()%></label>--%>
                                    <input id="price" name="price" type="hidden" maxlength="30" value="<%=(appt!=null?appt.getPrice().setScale(2, BigDecimal.ROUND_HALF_DOWN):new BigDecimal(0))%>">
                                <%--</div>--%>

                                <div class="field">
                                    <label for="location_id">Location <%=resx.getVALIDATOR()%></label>
                                    <select valid="select" id="location_id" name="location_id">
                                    <%for(int i=0; i<locList.size(); i++){
                                        Location loc = (Location)locList.get(i);%>
                                        <option value="<%=loc.getId()%>" <%=(appt!=null && appt.getLocation_id()==loc.getId()?"selected":"")%>><%=loc.getName()%></option>
                                    <%}%>
                                    </select>
                                </div>

                                <div class="field">
                                    <label for="category_id">Category Name <%=resx.getVALIDATOR()%></label>
                                    <select valid="select" id="category_id" name="category_id">
                                    <%for(int i=0; i<cateList.size(); i++){
                                        Category cate = (Category)cateList.get(i);%>
                                        <option value="<%=cate.getId()%>" <%=(appt!=null && appt.getCategory_id()==cate.getId()?"selected":"")%>><%=cate.getDetails()%></option>
                                    <%}%>
                                    </select>
                                </div>

                                <div class="field">
                                    <label for="appt_date">Date (yyyy/dd/mm) <%=resx.getVALIDATOR()%></label>
                                    <input valid="text" id="appt_date" name="appt_date" type="text" maxlength="10" value="<%=(appt!=null?DateUtil.formatYmd(appt.getApp_dt()):"")%>">
                                </div>

                                <div class="field">
                                    <label for="st_time">Start <%=resx.getVALIDATOR()%></label>
                                    <input valid="text" id="st_time" name="st_time" type="text" maxlength="8" value="<%=(appt!=null?DateUtil.formatTime(appt.getSt_time()):"")%>">
                                </div>

                                <div class="field">
                                    <label for="et_time">End <%=resx.getVALIDATOR()%></label>
                                    <input valid="text" id="et_time" name="et_time" type="text" maxlength="8" value="<%=(appt!=null?DateUtil.formatTime(appt.getEt_time()):"")%>">
                                </div>

                                <div class="field">
                                    <label for="comment">Comment</label>
                                    <input id="comment" name="comment" type="text" maxlength="30" value="<%=(appt!=null?appt.getComment():"")%>">
                                </div>

                                <div class="field">
                                    <label for="et_time">Status</label>
                                    <%
                                        String status = "";
                                        String ct = "";
                                        int idt = 0;
                                        int idc = 0;
                                        Date dt = null;
                                        boolean trans = false;
                                        if (appt != null){
                                            if (appt.getState()==2){
                                                status = "Customer not show";
                                            } else if (appt.getState()==4){
                                                status = "Canceled by Customer";
                                            } else{
                                                Ticket t = Ticket.findTicketById(appt.getTicket_id());
                                                if(t != null){
                                                    ArrayList a = Reconciliation.findTransByCode(t.getCode_transaction());
                                                    if(a != null && a.size() > 0){
                                                        Reconciliation r = (Reconciliation)a.get(0);
                                                        if(r != null){
                                                            trans = true;
                                                            ct = r.getCode_transaction();
                                                            idt = r.getId();
                                                            idc = r.getId_customer();
                                                            dt = r.getCreated_dt();
                                                            if (r.getStatus() == 0){
                                                                status = "Paid";
                                                            }
                                                           }
                                                    }
                                                }
                                            }
                                        }
                                    %>
                                    <label><%=status%></label>
                                </div>
                                <br/><br/>

                                    <div id="error_message" name="error_message" class="error">
                                        <%=resx.getREQERROR()%>
                                    </div>

                                    <div>
                                        <table align="left" class="submit" style="padding-left:0px">
                                        <br/>
                                            <tr>
                                                <td>
                                                    <input name="view" type="button" class="button" style="width:150px; background:#351717;" value="View Transaction" <%if (trans) {%>onclick="window.location.href='../checkout.jsp?dt=<%=dt!=null?dt:""%>&ct=<%=ct%>&idc=<%=idc%>&idt=<%=idt%>&tp=-1'"<%} else {%>onclick="alert('This Appointment don`t have transaction.')"<%}%>>
                                                </td>
                                                <td>
                                                    <input name="submit" type="submit" class="button_small" value="Save">
                                                </td>
                                                <td>
                                                    <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_appointment.jsp'">--%>
                                                    <input name="back" type="button" class="button_small" value="back" onclick="window.history.back();">
                                                <td>
                                            </tr>
                                        </table>
                                    </div>
                                
                                </form>
                            <!-- main content ends here -->
                        </div>
                    </div>
				</td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
	</body>
</html>