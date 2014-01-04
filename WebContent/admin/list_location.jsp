<%@ page import="org.xu.swan.bean.Location" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
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
    String id = StringUtils.defaultString(request.getParameter(Location.ID), ActionUtil.EMPTY);
       if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        Location.deleteLocation(Integer.parseInt(id));
    }

    ArrayList array = Location.findAll();
    int count = Location.countAll();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage store locations</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
        <LINK href="../css/style.css" type=text/css rel=stylesheet>
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

        <table width="1040" border="0" cellpadding="0" cellspacing="0">
            <tr>
            <td>
            <div id="container">
                <img class="rightcorner" src="../images/page_right.jpg" alt="">
                <img class="leftcorner" src="../images/page_left.jpg" alt="">
                <div class="padder">
                    <!-- main content begins here -->
                    <div class="heading">
                        <h1>Manage store locations <a>(<%=count%> records)</a></h1>
                    </div>
                    <form action="./list_location.jsp" method="post">
                    <table class="data">
                    <tr>
                        <th class="name" title="Store name">Name</th>
                        <th class="address" title="Address">Address</th>
                        <th class="currency" title="City">Telephone</th>
                        <th class="taxes" title="State">Fax</th>
                        <th class="taxes" title="Zip">Email</th>
                        <%--<th class="taxes" title="Country">Country</th>--%>
                        <th style="width:20px" align="center">&nbsp;</th>
                    </tr>
                    <%
                        String[] tmp;
                        String[] addr2;
                        String temp;
                        String telephone = "";
                        String fax = "";
                        String email = "";
//                        String country = "";
                    for(int i=0; i<array.size(); i++)
                    {
                        Location loc = (Location)array.get(i);
                        if (loc != null){
                            telephone = loc.getPhone();
                            fax = loc.getFax();
                            email = loc.getEmail();
                            tmp = loc.getAddress2().split(";");
                            if (!tmp[0].equals("")){
                                for (int j = 0; j<7; j++){
                                    temp = tmp[j];
                                    addr2 = temp.split(":");
                                    if (addr2.length == 2) {
                                        if (addr2[0].equals("telephone")){
                                             telephone = addr2[1];
                                        }else if (addr2[0].equals("fax")){
                                             fax = addr2[1];
                                        }else if (addr2[0].equals("email")){
                                             email = addr2[1];
                                        }
                                    }
                                }
                            }
                        }

                    %>
                    <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                        <TD>
                            <%=loc.getName()%>
                        </TD>
                        <TD>
                            <%=loc.getAddress()%>
                        </TD>
                        <TD>
                            <%=telephone%>
                        </TD>
                        <TD>
                            <%=fax%>
                        </TD>
                        <TD>
                            <%=email%>
                        </TD>
                        <%--<TD>--%>
                            <%--<%=country%>--%>
                        <%--</TD>--%>
                        <TD>
                                <IMG height="16" alt="Edit" title="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png" onclick="window.location.href='./edit_location.jsp?action=edit&id=<%=loc.getId()%>'">
                                <%--<IMG height="16" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png" onclick="if (confirm('Are you sure want to delete this?')) window.location.href = './list_location.jsp?action=delete&id=<%=loc.getId()%>'">--%>
                        </TD>
                    </TR><%}%>
                    </table>
                    </form>
                </div>
            </div>
            </td>
            </tr>
            <%@ include file="../copyright.jsp" %>
        </table>
	</body>
</html>