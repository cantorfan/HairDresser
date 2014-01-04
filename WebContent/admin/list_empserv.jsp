<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
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
    }
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.EMPTY);
    String id = StringUtils.defaultString(request.getParameter(EmpServ.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        EmpServ.deleteEmpServ(Integer.parseInt(id));
    }

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
    ArrayList list = EmpServ.findAll(offset,ActionUtil.PAGE_ITEMS);

    HashMap employees = Employee.findAllMap();
    HashMap services = Service.findAllMap();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>List Employee's Service</title>
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
                            <h1>Manage Employee Svc</h1>
                        </div>
                        <table class="data">
                        <tr>
                            <th class="halfname" title="Employee's name">Employee</th>
                            <th class="service" title="Service's name">Service</th>
                            <th class="money" title="Price">Price</th>
                            <th class="money" title="Duraion">Duraion</th>
                            <th class="taxes" title="Taxes">Taxes</th>
                            <th />
                        </tr>
                        <%for(int i=0; i<list.size(); i++){
                            EmpServ es = (EmpServ)list.get(i);%>
                        <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                            <TD>
                                <%=employees.get(String.valueOf(es.getEmployee_id()))%>
                            </TD>
                            <TD>
                                <%=services.get(String.valueOf(es.getService_id()))%>
                            </TD>
                            <TD>
                                <%=es.getPrice()%>
                            </TD>
                            <TD>
                                <%=es.getDuration()%>
                            </TD>
                            <TD>
                                <%=es.getTaxes()%>
                            </TD>
                            <TD>
                                <%--<a href="./edit_empserv.jsp?action=add"><IMG height="16" alt="Add" src="../images/add.png" width="16" longDesc="../images/add.png"></a>--%>
                                <a href="./edit_empserv.jsp?action=edit&id=<%=es.getId()%>"><IMG height="16" alt="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png"></a>
                                <a href="./list_empserv.jsp?action=delete&id=<%=es.getId()%>&<%=ActionUtil.PAGE%>=<%=pg_num%>" onclick="confirm('Are you sure to delete?')"><IMG height="16" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png"></a>
                            </TD>
                        </TR><%}%>
                        </table>
                        <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                        <table>
                        <tr><td><a href="./list_empserv.jsp?<%=ActionUtil.PAGE%>=<%=pg_num + 1%>">Next &gt;&gt;</a></td></tr>
                        </table>
                        <%}%>
                    </div>
                </div>
				</td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
	</body>
</html>