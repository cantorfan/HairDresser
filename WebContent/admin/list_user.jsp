<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="java.security.acl.Permission" %>
<%@ page import="org.xu.swan.bean.Transaction" %>
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
    String id = StringUtils.defaultString(request.getParameter(User.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        User.deleteUser(Integer.parseInt(id));
    }

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
//    ArrayList list = User.findAll(offset,ActionUtil.PAGE_ITEMS);

    String p_fname = StringUtils.defaultString(request.getParameter("fname"), "");
    String p_lname = StringUtils.defaultString(request.getParameter("lname"), "");
    String p_email = StringUtils.defaultString(request.getParameter("email"), "");
    String p_user = StringUtils.defaultString(request.getParameter("user"), "");
    String p_pass = StringUtils.defaultString(request.getParameter("pwd"), "");
    String p_permission = StringUtils.defaultString(request.getParameter("permission"), "allperm");

    String perm_stmt = p_permission.equals("allperm")? "" : (User.PERM + " = '" + p_permission + "' AND ");
    String email_stmt = p_email.equals("") ? "" : User.EMAIL + " LIKE '%" + p_email + "%' AND ";
    String filter =
            perm_stmt +
            User.FNAME + " LIKE '%" + p_fname + "%' AND " +
            User.LNAME + " LIKE '%" + p_lname + "%' AND " +
            User.USER + " LIKE '%" + p_user + "%' AND " +
            email_stmt +
            User.PWD + " LIKE '%" + p_pass + "%' " ;
    ArrayList list = User.findByFilter(filter + " LIMIT " + offset + "," + ActionUtil.PAGE_ITEMS);
    int count = User.countByFilter(filter);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage Users</title>
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
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
    <form action="./list_user.jsp" method="post" id="list_form" name="list_form">
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
				<td>
                    <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                    <div class="padder">
                        <!-- main content begins here -->
                        <div class="heading">
                            <h1>Manage Users <a>(<%=count%> records)</a></h1>
                        </div>
                        <table class="data">
                        <tr>
                            <th class="halfname" style="text-align:center;" title="User's first name">First Name</th>
                            <th class="halfname" style="text-align:center;" title="User's last name">Last Name</th>
                            <th class="email" style="text-align:center;" title="Email address">Email</th>
                            <th class="login" style="text-align:center;" title="Login name">Login</th>                            
                            <th class="permission" style="text-align:center;" title="Permission level">Permission</th>
                            <th class="phone" style="text-align:center;" title="Send email">Send email</th>
                            <th style="width:70px;"/>
                        </tr>
                        <TR class="filter">
                            <TD class="halfname">
                                <input type="text" id="fname" name="fname" value="<%=p_fname%>"/>
                            </TD>
                            <TD class="halfname">
                                <input type="text" id="lname" name="lname" value="<%=p_lname%>"/>
                            </TD>
                            <TD class="email">
                                <input type="text" id="email" name="email" value="<%=p_email%>"/>
                            </TD>
                            <TD class="login">
                                <input type="text" id="user" name="user" value="<%=p_user%>"/>
                            </TD>
                            <TD class="permission">
                                <select name="permission" class="ctrl">
                                    <option value="allperm" <%=(p_permission.equals("allperm")?"selected":"")%>>- All -</option>
                                    <option value="<%=Role.R_ADMIN%>" <%=(p_permission.equals(String.valueOf(Role.R_ADMIN))?"selected":"")%>><%=Role.S_ADMIN%></option>
                                    <option value="<%=Role.R_RECEP%>" <%=(p_permission.equals(String.valueOf(Role.R_RECEP))?"selected":"")%>><%=Role.S_RECEP%></option>
                                    <option value="<%=Role.R_EMP%>" <%=(p_permission.equals(String.valueOf(Role.R_EMP))?"selected":"")%>><%=Role.S_EMP%></option>
                                    <option value="<%=Role.R_VIEW%>" <%=(p_permission.equals(String.valueOf(Role.R_VIEW))?"selected":"")%>><%=Role.S_VIEW%></option>
                                    <option value="<%=Role.R_SHD_CHK%>" <%=(p_permission.equals(String.valueOf(Role.R_SHD_CHK))?"selected":"")%>><%=Role.S_SHD_CHK%></option>
                                </select>
                            </TD>
                            <TD>
                            </TD>
                            <td class="submit">
                                <input class="button_small" type="submit" value="Search" onclick="document.getElementById('<%=ActionUtil.PAGE%>').value='0'; document.list_form.submit();" />
                            </td>
                        </TR>
                        <%for(int i=0; i<list.size(); i++){
                            User u = (User)list.get(i);
                            boolean b = true;
                            if (!u.getFname().toLowerCase().contains(p_fname.toLowerCase()) & !p_fname.equals("")) b = false;
                            if (!u.getLname().toLowerCase().contains(p_lname.toLowerCase()) & !p_lname.equals("")) b = false;
                            if (u.getEmail() != null?(!u.getEmail().toLowerCase().contains(p_email.toLowerCase()) & !p_email.equals("")):(!p_email.equals(""))) b = false;
                            if (!u.getUser().toLowerCase().contains(p_user.toLowerCase()) & !p_user.equals("")) b = false;
                            if (!u.getPwd().toLowerCase().contains(p_pass.toLowerCase()) & !p_pass.equals("")) b = false;
                            if (b) {
                        %>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <TD>
                                <%=u.getFname()%>
                            </TD>
                            <TD>
                                <%=u.getLname()%>
                            </TD>
                            <TD>
                                <%=u.getEmail()%>
                            </TD>
                            <TD>
                                <%=u.getUser()%>
                            </TD>
                            <TD>
                                <%=Role.ROLES.get(String.valueOf(u.getPermission()))%>
                            </TD>
                            <TD align="center">
                                <input type="checkbox" disabled="true" name="cbSend_Email" <%if(u.getSend_email()==1){%>checked="true"<%}%>>
                            </TD>
                            <TD>
                                <IMG title="Edit" onclick="window.location.href='./edit_user.jsp?action=edit&id=<%=u.getId()%>'" height="16" alt="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png"></a>
                                <IMG title="Delete" onclick="if (confirm('Are you sure to delete?')) window.location.href='./list_user.jsp?action=delete&id=<%=u.getId()%>&<%=ActionUtil.PAGE%>=<%=pg_num%>'" height="16" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png">
                            </TD>
                        </TR><%}}%>
                            <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                            <div class="pagelinks">
                            <%--<span class="disabled">« Previous</span> <!-- disabled 'previous' link -->--%>
                            <%--<span>1</span>  <!-- current page -->--%>
                            <%--<a href="#">2</a> <!-- nth page -->--%>
                            <input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />
                            <a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num - 1%>';document.list_form.submit()">« Previous</a>  <!-- active 'next' link -->
                            <a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num + 1%>';document.list_form.submit()">Next »</a>  <!-- active 'next' link -->
                        </div>
                        <%--<table>--%>
                        <%--<tr><td>--%>
                            <%--<a href="./list_appointment.jsp?<%=ActionUtil.PAGE%>=<%=pg_num + 1%>">Next &gt;&gt;</a>--%>
                                <%--<input  type="hidden" id="<%=ActionUtil.PAGE%>" name="<%=ActionUtil.PAGE%>" value="<%=pg_num + 1%>" />--%>
                                <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num - 1%>';document.list_form.submit()">&lt;&lt; Prev</a>--%>
                                <%--<a href="javascript: document.getElementById('<%=ActionUtil.PAGE%>').value = '<%=pg_num + 1%>';document.list_form.submit()">Next &gt;&gt;</a>--%>
                        <%--</td></tr>--%>
                        <%--</table>--%>
                            <%}%>
                        </table>
                    </div>
                </div>
				</td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
    </form>
	</body>
</html>
