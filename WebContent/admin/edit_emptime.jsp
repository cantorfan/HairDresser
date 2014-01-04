<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.*" %>
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
    NotWorkingtimeEmp nwte = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(org.xu.swan.bean.NotWorkingtimeEmp.ID), ActionUtil.EMPTY);
    String ide = StringUtils.defaultString(request.getParameter(org.xu.swan.bean.NotWorkingtimeEmp.EMP), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        nwte = NotWorkingtimeEmp.findById(Integer.parseInt(id));
    else
        nwte = (NotWorkingtimeEmp) request.getAttribute("OBJECT");
    String title = "";
    if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
        title = "Add";
    } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
        title = "Edit";
    }
    int iID = 0;
    try
    {
        iID = Integer.parseInt(id);
    }
    catch (Exception ex)
    {}
    ArrayList list = Category.findAll();
    ArrayList wtime = (iID != 0? WorkingtimeEmp.findAllByEmployeeId(iID) : null) ;
    java.util.List work_time = new ArrayList();
        work_time.add("08:00:00");
        work_time.add("08:15:00");
        work_time.add("08:30:00");
        work_time.add("08:45:00");
        work_time.add("09:00:00");
        work_time.add("09:15:00");
        work_time.add("09:30:00");
        work_time.add("09:45:00");
        work_time.add("10:00:00");
        work_time.add("10:15:00");
        work_time.add("10:30:00");
        work_time.add("10:45:00");
        work_time.add("11:00:00");
        work_time.add("11:15:00");
        work_time.add("11:30:00");
        work_time.add("11:45:00");
        work_time.add("12:00:00");
        work_time.add("12:15:00");
        work_time.add("12:30:00");
        work_time.add("12:45:00");
        work_time.add("13:00:00");
        work_time.add("13:15:00");
        work_time.add("13:30:00");
        work_time.add("13:45:00");
        work_time.add("14:00:00");
        work_time.add("14:15:00");
        work_time.add("14:30:00");
        work_time.add("14:45:00");
        work_time.add("15:00:00");
        work_time.add("15:15:00");
        work_time.add("15:30:00");
        work_time.add("15:45:00");
        work_time.add("16:00:00");
        work_time.add("16:15:00");
        work_time.add("16:30:00");
        work_time.add("16:45:00");
        work_time.add("17:00:00");
        work_time.add("17:15:00");
        work_time.add("17:30:00");
        work_time.add("17:45:00");
        work_time.add("18:00:00");
        work_time.add("18:15:00");
        work_time.add("18:30:00");
        work_time.add("18:45:00");
        work_time.add("19:00:00");
        work_time.add("19:15:00");
        work_time.add("19:30:00");
        work_time.add("19:45:00");
        work_time.add("20:00:00");
        work_time.add("20:15:00");
        work_time.add("20:30:00");
        work_time.add("20:45:00");
        work_time.add("21:00:00");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=title%> Employee Break</title>
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
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1><%=title%> Employee Break</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <form id="service" name="service" method="post" action="./nwte.do?action=<%=action%>" onsubmit="javascript: return formvalidate(this);">
                                <input name="id" type="hidden" value="<%=(nwte!=null?String.valueOf(nwte.getId()):"")%>">
                                <div class="validation"><%=resx.getREQMESSAGE()%></div>
                                <input name="employee_id" type="hidden" value="<%=ide%>">
                                <div class="field">
                                    <label for="w_date">Date (yyyy-mm-dd) <%=resx.getVALIDATOR()%></label>
                                    <table cellspacing="0" cellpadding="0" style="float: left; clear:right"><tr>
                                    <td style="margin:0; padding: 0">
                                    <input readonly valid="text" type="text" id="w_date" name="w_date" style="width: 105px" value="<%=(nwte!=null?nwte.getW_date().toString():"")%>" />
                                    </td>
                                    <td style="margin:0; padding: 0"><input type="button" id="selDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                    </tr></table>
                                    <link rel="stylesheet" type="text/css" media="all" href="../jscalendar/calendar-hd-admin.css" title="hd" />
                                    <script type="text/javascript" src="../jscalendar/calendar.js"></script>
                                    <script type="text/javascript" src="../jscalendar/lang/calendar-en.js"></script>
                                    <script type="text/javascript" src="../jscalendar/calendar-setup.js"></script>
                                        <SCRIPT type="text/javascript">
                                                    Calendar.setup(
                                                    {
                                                    inputField  : "w_date",     // ID of the input field
                                                    button      : "selDate",  // ID of the button
                                                    showsTime	: false,
                                                    electric    : false
                                                    }
                                                    );
                                        </SCRIPT>
                                </div>
                                <br /><br /><br />
                                <div class="field">
                                    <label for="hfrom">From (00:00:00)</label>
                                    <select id="hfrom" name="hfrom" class="ctrl" style="WIDTH:135px">
                                        <%for(int i=0; i<work_time.size(); i++){
                                            WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(0) : new WorkingtimeEmp());
                                            %>
                                            <option value="<%=work_time.get(i)%>"><%=work_time.get(i)%></option>
                                        <%}%>
                                    </select>
                                </div>

                                <div class="field">
                                    <label for="hto">Until (00:00:00)</label>
                                    <select id="hto" name="hto" class="ctrl" style="WIDTH:135px">
                                    <%for(int i=0; i<work_time.size(); i++){
                                        WorkingtimeEmp wtemp = (wtime != null? (WorkingtimeEmp)wtime.get(0) : new WorkingtimeEmp());
                                        %>
                                        <option value="<%=work_time.get(i)%>"><%=work_time.get(i)%></option>
                                    <%}%>
                                    </select>
                                </div>

                                <div class="field">
                                    <label for="comment">Comment</label>
                                    <input id="comment" name="comment" type="text" value="<%=(nwte!=null?nwte.getComment():"")%>">
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
                                                <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./time_employee.jsp?action=time&id='+'<%=ide%>'">--%>
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
