<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
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
    ResourcesManager resx = new ResourcesManager();
    EmpServ es = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(EmpServ.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        EmpServ.deleteEmpServ(Integer.parseInt(id));
        action = ActionUtil.ACT_ADD; 
    }

    String id_emp = StringUtils.defaultString(request.getParameter(EmpServ.EMP), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_ADD) && StringUtils.isNotEmpty(id))
        es = EmpServ.findById(Integer.parseInt(id));
    else
        es = (EmpServ) request.getAttribute("OBJECT");
    ArrayList list_es = EmpServ.findByEmployeeId(Integer.parseInt(id_emp));
    ArrayList empList = Employee.findAll();
    ArrayList svcList = Service.findAll();
    HashMap services = Service.findAllMap();
    HashMap employee = Employee.findAllMap();
    BigDecimal comm = new BigDecimal(0.0);
    if (StringUtils.isNotEmpty(id_emp)){
       comm = Employee.findById(Integer.parseInt(id_emp)).getCommission();
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Add Employee's Services</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
        <script type="text/javascript" src="../Js/formvalidate.js"></script>
		<script type="text/javascript">
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

    function SelectService(){
        var ctrl = document.getElementById("service_name");
        var ctrl_ = document.getElementById("service_id");
        ctrl.innerHTML = ctrl_.options[ctrl_.selectedIndex].text;

    }

    function check(form) {
        if (document.getElementById('duration').value > 360){
            alert('Duration could not be more than 6 hours');
            return false;
        } else {
            return formvalidate(form);
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
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>

                    <div id="container">

                        <img class="rightcorner" src="../images/page_right.jpg" alt="">
                        <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">

                            <!-- main content begins here -->
                            <div class="heading">
                                <h1>Add Employee's Services <span style="font-size:12pt;">&nbsp;&nbsp;&nbsp;<%=employee.get(id_emp)%></span></h1> <!-- note: I would do headings like this: Add employee, Editing employee "Name" -->

                            </div>

                            <p>Select a service on the left and then enter the price, duration and taxes on the right.</p>
                            <form id="empserv" name="empserv" method="post" action="./empserv.do?action=<%=action%>" onsubmit="javascript: return check(this);">
                            <table class="serviceslist">
                            <tr>

                                <td class="subform">
                                    <h2>Add service <%=resx.getVALIDATOR()%></h2>

                                <logic:notPresent name="org.apache.struts.action.MESSAGE" scope="application">
                                <font color="red"> ERROR: Application resources not loaded -- check servlet container logs for error messages. </font>
                                </logic:notPresent>
                                <div class="validation"><%=resx.getREQMESSAGE()%></div>
                                <input name="id" type="hidden" value="<%=(es!=null?String.valueOf(es.getId()):"")%>">
                                <input name="employee_id" type="hidden" value="<%=id_emp%>">

                                <select valid="select" id="service_id" name="service_id" size="10" onchange="SelectService();">
                                <%for(int i=0; i<svcList.size(); i++){
                                    Service svc = (Service)svcList.get(i);%>
                                    <option value="<%=svc.getId()%>" <%=(es!=null && es.getService_id()==svc.getId()?"selected":"")%>><%=svc.getName()%></option>
                                <%}%>
                                </select>

                                </td>
                                <td>

                                    <h2>Enter service details</h2>

                                    <div class="field">
                                        <label>Service</label>
                                        <span id="service_name" name="service_name" class="fakefield">Select a service to add</span>
                                    </div>

                                    <div class="field">
                                        <label for="price">Price </label>
                                        <input valid="money" id="price" name="price" type="text" maxlength="20" value="0">
                                    </div>

                                    <div class="field">

                                        <label for="duration">Duration (min)</label>
                                        <input valid="digits" id="duration" name="duration" type="text" maxlength="20" value="0">
                                    </div>

                                    <div class="field">
                                        <label for="taxes">Taxes <span style="color:#000;">(%)</span></label>
                                        <input valid="taxe" id="taxes" name="taxes" type="text" maxlength="20" value="0">
                                    </div>

                                    <div class="field">
                                        <label for="commission">Commission <span style="color:#000;">(%)</span> Service</label>
                                        <input valid="taxe" id="commission" name="commission" type="text" maxlength="20" value="<%=comm.setScale(2,BigDecimal.ROUND_HALF_DOWN).toString()%>">
                                    </div>

                                    <div id="error_message" name="error_message" class="error">
                                        <%=resx.getREQERROR()%>
                                    </div>
                                    <div>
                                        <table align="left" class="submit">
                                        <br/>
                                            <tr>
                                                <td>
                                                    <input name="submit" type="submit" class="button_small" value="Save">
                                                </td>
                                                <td>
                                                    <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_empserv.jsp'">--%>
                                                        <input name="back" type="button" class="button_small" value="back" onclick="window.history.back();">
                                                <td>
                                            </tr>
                                        </table>
                                    </div>

                                </td>

                            </tr>
                            </table>
                            </form>
                            <h2>My services</h2>

                            <table id="my_services" class="data">
                            <tr>
                                <th style="width:46%; text-align:center;">Service</th>
                                <th style="width:15%; text-align:center;">Price</th>
                                <th style="width:15%; text-align:center;">Duration</th>
                                <th style="width:15%; text-align:center;" >Taxes</th>
                                <th style="width:15%; text-align:center;" >Commission (%) Service</th>
                                <th style="width:50px;"/>
                            </tr>
                            <%for(int i=0; i<list_es.size(); i++){
                            EmpServ es_ = (EmpServ)list_es.get(i);
                            if (es_.getEmployee_id() == Integer.parseInt(id_emp)){
                            %>
                            <TR <%
                            int a = i%2;
                            if(a != 0) {%>class="alt"<%}%>>
                                <TD>
                                    <%=services.get(String.valueOf(es_.getService_id()))%>
                                </TD>
                                <TD>
                                    <%=es_.getPrice().setScale(2, BigDecimal.ROUND_HALF_DOWN).toString()%>
                                </TD>
                                <TD>
                                    <%=(es_!=null?es_.getDuration():0)%>
                                </TD>
                                <TD>
                                    <%=es_.getTaxes().setScale(2,BigDecimal.ROUND_HALF_DOWN).toString()%>
                                </TD>
                                <TD>
                                    <%=es_.getCommission().setScale(2,BigDecimal.ROUND_HALF_DOWN).toString()%>
                                </TD>
                                <TD >
                                    <%--<a href="./edit_empserv.jsp?action=add"><IMG height="16" alt="Add" src="../images/add.png" width="16" longDesc="../images/add.png"></a>--%>
                                    <a href="./edit_empserv2.jsp?action=edit&id=<%=es_.getId()%>&employee_id=<%=es_.getEmployee_id()%>"><IMG title="Edit" height="16" alt="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png"></a>
                                    <a href="#" onclick="if (confirm('Are you sure to delete?')) window.location.href = './edit_empserv.jsp?action=delete&id=<%=es_.getId()%>&employee_id=<%=es_.getEmployee_id()%>'"><IMG height="16" title="Delete" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png"></a>
                                </TD>
                            </TR><%}}%>
                            </table>
                        </div>
                    </div>
				</td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
    <script type="text/javascript">
        document.getElementById("service_id").selectedIndex = -1;
    </script>
	</body>
</html>
