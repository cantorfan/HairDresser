
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.EMPTY);
    String id = StringUtils.defaultString(request.getParameter(Category.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        EmailTemplate.deleteTemplate(Integer.parseInt(id));
    }

    ArrayList list = EmailTemplate.findAll();

//    int count = EmailTemplate.

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage Email Template</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
        <script type="text/javascript" src="../Js/includes/prototype.js"></script>
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
    //-->

		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_category.jsp" method="post" name="list_form" id="list_form">
		<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
			<tr valign="top">
                <%
                    String activePage = "Admin";
                    String rootPath = "../";
                %>
                <%@ include file="../top_page.jsp" %>
			</tr>
			<tr>
				<td height="47" background="../images/ADMIN_03.gif" colspan="3">
                     <%@ include file="../menu_main.jsp" %>
				</td>
			</tr>
            <%@ include file="menu.jsp"%>
		</table>
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td valign = "top">
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                    <div class="padder">
                        <!-- main content begins here -->
                        <div class="heading">
                            <h1>Manage Email Template <%--<a>(<%=count%> records)</a>--%></h1>
                        </div>
                        <table class="data">
                        <tr>
                            <%--<th class="name" title="Category name">Name</th>--%>
                            <th class="name-service" title="Type Template">Type Email Template</th>
                            <th class="name-service" title="Category Name">Description Email Template</th>
                            <th style="width:80px" />
                        </tr>
                        <%--<TR class="filter">--%>
                            <%--<TD class="name">--%>
                                <%--<input type="text" id="name" name="name" value="<%=p_name%>"/>--%>
                            <%--</TD>--%>
                            <%--<TD class="description-category">--%>
                                <%--<input type="text" id="description" name="description" value="<%=p_descr%>"/>--%>
                            <%--</TD>--%>
                            <%--<td class="submit" align="center">--%>
                                <%--<input class="button_small" type="submit" value="Search" />--%>
                            <%--</td>--%>
                        <%--</TR>--%>
                        <%for(int i=0; i<list.size(); i++){
                            EmailTemplate etp = (EmailTemplate)list.get(i);
                            boolean b = true;
//                            if (!cate.getName().toLowerCase().contains(p_name.toLowerCase()) & !p_name.equals("")) b = false;
//                            if (!cate.getDetails().toLowerCase().contains(p_descr.toLowerCase()) & !p_descr.equals("")) b = false;
                            if (b) {
                        %>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <%--<TD>--%>
                                <%--<%=cate.getName()%>--%>
                            <%--</TD>--%>
                            <TD>
                                <%
                                    String type = "";
                                    switch (etp.getType()) {
                                        case 0: type = "New Customer added Email"; break;
                                        case 1: type = "Online Booking Confirmation Email"; break;
                                        case 2: type = "Appointment Confirmation Email"; break;
                                        case 3: type = "Reschedule Confirmation Email"; break;
                                        case 4: type = "Forgot Username and Password Email"; break;
                                        case 5: type = "Delete Booking"; break;
                                        case 100: type ="Appointment Reminder Email"; break;
                                        case 101: type ="Appointment Canceled"; break;
                                    }
                                %>
                                <%=type%>
                            </TD>
                            <TD>
                                <%=etp.getDescription()%>
                            </TD>
                            <TD>
                                <IMG height="16" alt="Edit" title="Edit" onclick="window.location.href='./edit_emailtemplate.jsp?action=edit&id=<%=etp.getId()%>'" src="../images/edit.png" width="16" longDesc="../images/edit.png">
                                <IMG title="Delete" onclick="if (confirm('Are you sure to delete?')) window.location.href='./list_emailtemplate.jsp?action=delete&id=<%=etp.getId()%>'" height="16" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png">
                            </TD>
                        </TR><%}}%>
                        </table>
                        <%--<%if(list.size() >= ActionUtil.PAGE_ITEMS){%>--%>
                        <%--<div class="pagelinks">--%>
                            <%--<input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />--%>
                            <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num - 1%>';document.list_form.submit()">« Previous</a>  <!-- active 'next' link -->--%>
                            <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num + 1%>';document.list_form.submit()">Next »</a>  <!-- active 'next' link -->--%>
                        <%--</div>--%>
                        <%--<%}%>--%>
                    </div>
                </div>
                    
				</td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
    </form>
	</body>
</html>