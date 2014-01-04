<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.*" %>
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
    EmpServ es = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(EmpServ.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        es = EmpServ.findById(Integer.parseInt(id));
    else
        es = (EmpServ) request.getAttribute("OBJECT");

    ArrayList empList = Employee.findAll();
    ArrayList svcList = Service.findAll();

    String name = "not found";
    if (es!=null){
    Service svc = Service.findById(es.getService_id());
        if (svc != null) name = svc.getName();
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Edit employee service "<%=name%>"</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
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

    function check(form) {
        if (document.getElementById('duration').value > 360){
            alert('Duration could not be more than 6 hours');
            return false;
        } else {
            return true;
//             return formvalidate(form);
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
				<td valign="top">
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1>Edit employee service "<%=name%>"</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <!-- success/error message:
                            <div class="error"><p>Error message</p></div>
                            <div class="success"><p>Success message</p></div>
                            -->
                            <form id="empserv" name="empserv" method="post" action="./empserv.do?action=<%=action%>" onsubmit="javascript: return check(this);">
                            <logic:notPresent name="org.apache.struts.action.MESSAGE" scope="application">
                            <font color="red"> ERROR: Application resources not loaded -- check servlet container logs for error messages. </font>
                            </logic:notPresent>
                            <% String prompt = (String) request.getAttribute("MESSAGE");  if (StringUtils.isNotEmpty(prompt)){%>
                            <p><font color="red" face=verdana size="-1"> <bean:message key="<%=prompt%>"/> </font></p><%}%>
                            <input name="id" type="hidden" value="<%=(es!=null?String.valueOf(es.getId()):"")%>">
                            <input name="employee_id" type="hidden" value="<%=(es!=null?String.valueOf(es.getEmployee_id()):"")%>">

                            <%--<div class="field">--%>
                                <%--<label for="employee_id">Employee</label>--%>
                                <%--<select id="employee_id" name="employee_id">--%>
                                <%--<%for(int i=0; i<empList.size(); i++){--%>
                                    <%--Employee emp = (Employee)empList.get(i);%>--%>
                                    <%--<option value="<%=emp.getId()%>" <%=(es!=null && es.getEmployee_id()==emp.getId()?"selected":"")%>><%=emp.getFname() + " " + emp.getLname()%></option>--%>
                                <%--<%}%>--%>
                                <%--</select>--%>
                            <%--</div>--%>

                            <div class="field">
                                <label for="service_id">Service</label>
                                <input id="service_id" name="service_id" type="hidden" maxlength="20" value="<%=(es!=null?es.getService_id():0)%>">
                                <span id="service_name" class="fakefield" name="service_name"><%=name%></span>
                                <%--<input id="servname" name="servname" type="text" maxlength="20" disabled value="<%=name%>">--%>

                                <%--<select id="service_id1" name="service_id1" >--%>
                                <%--<%for(int i=0; i<svcList.size(); i++){--%>
                                    <%--Service svc = (Service)svcList.get(i);%>--%>
                                    <%--<option value="<%=svc.getId()%>" <%=(es!=null && es.getService_id()==svc.getId()?"selected":"")%>><%=svc.getName()%></option>--%>
                                <%--<%}%>--%>
                                <%--</select>--%>
                            </div>

                            <div class="field">
                                <label for="price">Price (0.00)</label>
                                <input id="price" name="price" type="text" maxlength="20" value="<%=(es!=null?es.getPrice().toString():"")%>">
                            </div>

                            <div class="field">
                                <label for="price">Duration (min)</label>
                                <input name="duration" id="duration" type="text" maxlength="20" value="<%=(es!=null?es.getDuration():0)%>">
                            </div>

                            <div class="field">
                                <label for="price">Taxes (0.00)</label>
                                <input name="taxes" type="text" maxlength="20" value="<%=(es!=null?es.getTaxes().toString():"")%>">
                            </div>

                            <div class="field">
                                <label for="price">Commission (%) Services (0.00)</label>
                                <input name="commission" type="text" maxlength="20" value="<%=(es!=null?es.getCommission().toString():"")%>">
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