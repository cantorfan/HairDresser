<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.util.Calendar" %>

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
    String dt = StringUtils.defaultString(request.getParameter("dt"), "");
    Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(dt);
    if (lMatcher.matches()) {
        dt = dt.trim().replace('-', '/').replaceAll("/0", "/");
    } else {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
        dt = sdf.format(Calendar.getInstance().getTime());
    }
    
    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id
    String table = StringUtils.defaultString(request.getParameter("tb"), "%");//TODO location_id

    ArrayList list_trail = Trail.findByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), table);
    HashMap hm_emp = Employee.findAllMap();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> <!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0
Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">-->
<html><!--<html xmlns="http://www.w3.org/1999/xhtml">-->
<head>
    <title>Audit trail</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <%--<LINK href="../css/style.css" type=text/css rel=stylesheet>--%>
    <style type="text/css"> * {
        margin-right: auto;
        margin-left: auto;
        font-family: Arial;
    }

    body {
        background-color: #101010;
        color: #FFFFFF;
        margin: 0;
        padding: 0;
    }

    .banner {
        padding-top: 3px;
        padding-bottom: 3px;
    }

    .banner img {
        border-top-width: medium;
        border-right-width: medium;
        border-bottom-width: medium;
        border-left-width: medium;
        border-top-style: solid;
        border-right-style: solid;
        border-bottom-style: solid;
        border-left-style: solid;
        border-top-color: #4A4A4A;
        border-right-color: #6E9AAD;
        border-bottom-color: #4A4A4A;
        border-left-color: #4A4A4A;
        padding: 2px;
    }

    #mev {
        color: #6E6E6E;
        text-transform: capitalize;
        font-size: 14pt;
    }

    .left {
        padding-top: 2px;
        border: medium solid #000000;
    }

    .a {
        font-weight: bold;
        text-transform: capitalize;
        color: #CB2A0F;
        padding-left: 20px;
    }

    .b {
        text-transform: capitalize;
        color: #888888;
        padding-left: 15px;
        font-weight: bold;
        font-size: 12px;
    }

    div {
        margin: 0px;
        padding: 0px;
    }

    .bg {
    /*background-image: url(./images/bg_content.gif);*/
        background-repeat: no-repeat;
        background-position: bottom;
    }

    .d {
        color: #464646;
        font-weight: bold;
        text-transform: capitalize;
        font-size: 12px;
        padding-left: 10px;
    }

    .c {
        color: #B7B7B7;
        font-size: 12px;
        margin-top: 0px;
        margin-bottom: 0px;
        padding-top: 0px;
        padding-bottom: 0px;
        background-image: url( ../images/schdule_12.jpg );
        background-repeat: no-repeat;
        width: 20px;
    }

    .e {
        border: 1px solid #999999;
    }

    .g {
        border-left-width: 1px;
        border-left-style: solid;
        border-left-color: #929191;
    }

    #g {
        background-image: url( ../images/checkout-11NEW_26.gif );
        background-repeat: no-repeat;
        background-position: bottom;
    }

    #f {
        margin-top: 15px;
        margin-left: 20px;
    }

    #f td {
        border-right-width: 1px;
        border-bottom-width: 1px;
        border-right-style: solid;
        border-bottom-style: solid;
        border-right-color: #929191;
        border-bottom-color: #929191;
    }

    .m {
        background-image: url( ../images/ADMIN_04.gif );
        background-repeat: no-repeat;
        background-position: left;
        height: 47px;
    }

    .m_1 {
        background-image: url( ../images/ADMIN_04.gif );
        background-repeat: no-repeat;
        background-position: left;
        height: 47px;
    }

    a:link {
        color: #6E6E6E;
        text-decoration: none
    }

    a:visited {
        color: #6E6E6E;
        text-decoration: none
    }

    a:hover {
        color: #6E6E6E;
        text-decoration: underline
    }

    a:active {
        color: #6E6E6E;
        text-decoration: underline
    }

    .STYLE1 {
        color: #CB2A0F;
        padding-left: 10px;
        text-transform: capitalize;
    }

    .STYLE2 {
        text-transform: capitalize;
        font-size: 12px;
        padding-left: 10px;
        color: #D6D6D6;
    }

    .STYLE3 {
        border-left-width: 1px;
        border-left-style: solid;
        border-left-color: #929191;
        color: #FF9900;
    }

    .STYLE4 {
        color: #339966;
        font-size: 12px;
    }

    .STYLE5 {
        font-size: 12px
    }

    .STYLE6 {
        color: #0033FF
    }

    .STYLE7 {
        color: #CC0099
    }

    .STYLE10 {
        color: #666666;
        font-size: 11px;
        font-family: Verdana, Arial, Helvetica, sans-serif;
    }

    .STYLE17 {
        color: #666666
    }

    label {
        display: block;
        float: left;
        width: 45%;
        clear: left;
        color: #666666;
    }

    .clear {
        clear: both;
    }
    </style>

    <link rel="stylesheet" type="text/css" media="all" href="../jscalendar/calendar-win2k-cold-1.css"
          title="win2k-cold-1"/>
    <script type="text/javascript" src="../jscalendar/calendar.js"></script>
    <script type="text/javascript" src="../jscalendar/lang/calendar-en.js"></script>
    <script type="text/javascript" src="../jscalendar/calendar-setup.js"></script>

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
<body class="yui-skin-sam" topmargin="0"
      onload="MM_preloadImages('images/home red.gif','images/schedule red.gif','images/checkout.gif')">
<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr valign="top">
        <%
            String activePage = "Admin";
            String rootPath = "../";
        %>
        <%@ include file="../top_page.jsp" %>
    </tr>
    <tr>
        <td height="47" background="../images/ADMIN_03.gif" colspan="2">
            <table  border="0" cellspacing="0" cellpadding="0" id="mev">
                <tr>
                    <td width="300"></td>
                    <td width="120" align="center" class="m"><a href="../index.jsp" onmouseout="MM_swapImgRestore()"
                                                                onmouseover="MM_swapImage('Image20','','../images/home red.gif',1)"><img
                            alt="home" src="../images/home.gif" name="Image20" width="96" height="39" border="0"
                            id="Image20"></a></td>
                    <%User sess_user = (User)session.getAttribute("user"); if(sess_user!=null && sess_user.getPermission()==Role.R_ADMIN){%>
                    <td width="120" align="center" class="m"><a href="./admin.jsp" onmouseout="MM_swapImgRestore()"
                                                                onmouseover="MM_swapImage('Image5','','../images/ADMIN.gif',1)"><img
                            alt="admin" src="../images/ADMIN red.gif" name="Image5" width="96" height="39" border="0"
                            id="Image5"></a></td>
                    <%}%>
                    <td width="120" align="center" class="m"><a href="../schedule.do" onmouseout="MM_swapImgRestore()"
                                                                onmouseover="MM_swapImage('Image21','','../images/schedule red.gif',1)"><img
                            alt="schedule" src="../images/schedule.gif" name="Image21" width="96" height="39" border="0"
                            id="Image21"></a></td>
                    <td width="120" align="center" class="m"><a href="../checkout.do" onmouseout="MM_swapImgRestore()"
                                                                onmouseover="MM_swapImage('Image22','','../images/checkout red 2.gif',1)"><img
                            alt="checkout" src="../images/checkout.gif" name="Image22" width="96" height="39"
                            border="0" id="Image22"></a></td>
                    <td width="120" align="center" class="m"><FONT face="Arial"></FONT><a href="#"></a></td>
                    <td width="158">&nbsp;</td>
                </tr>
                <%--<%@ include file="menu.jsp"%>--%>
            </table>
        </td>
    </tr>
</table>
<table width="1000" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<table width="1000" border="0" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
    <table width="200" border="0" cellspacing="0" cellpadding="0" bgcolor="#101010">
        <tr>
            <td height="4"></td>
        </tr>
        <tr>
            <td height="4"></td>
        </tr>
        <tr>
            <td width="2"></td>
            <td align="left">
                <table width="180" border="0" cellspacing="0" cellpadding="0" class="left">
                    <tr>
                        <td align="left" class="STYLE1">Audit Trail</td>
                    </tr>
                    <tr>
                        <td height="30"></td>
                    </tr>
                    <tr>
                        <td align="center"><!--<img src="./images/checkoutweb.gif">-->
                            <table>
                                <tr>
                                    <td>
                                        <div id="calendar-container">
                                            <script type="text/javascript">
                                                function dateChanged(calendar) {
                                                    //  In order to determine if a date was clicked you can use the dateClicked property of the calendar:
                                                    if (calendar.dateClicked) {
                                                        // OK, a date was clicked, redirect to /yyyy/mm/dd/index.php
                                                        var y = calendar.date.getFullYear();
                                                        var m = calendar.date.getMonth();
                                                        // integer, 0..11
                                                        var d = calendar.date.getDate();
                                                        // integer, 1..31
                                                        // redirect...
                                                        window.location = "./audittrail.jsp?dt=" + y + "/" + (1 + m) + "/" + d;
                                                    }
                                                }
                                                ;
                                                Calendar.setup(
                                                {
                                                    date : "<%=dt%>",
                                                                    flat : "calendar-container", // ID of the parent element
                                                                    flatCallback : dateChanged // our callback function
                                                                }
                                                            );
                                                            </script></div>
                                                        </td></tr></table>
                                                    </td>
												</tr>
												<tr>
													<td align="left" class="c"></td>
												</tr>
												<tr>
													<td align="left" class="c"></td>
												</tr>
												<!--<tr>
													<td height="110"></td>
												</tr>-->
												<tr>
													<td height="10"></td>
												</tr>
                                                <tr>
													<td height="150"></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>

                            <!--<td width="5"></td>-->

                            <td width="795" height="579" align="left" valign="top" id="g">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="10" colspan="3" bgcolor="#101010"></td>
									</tr>
									<tr>
										<td height="10" colspan="3" bgcolor="#101010"></td>
									</tr>
									<tr>
										<td colspan="3" align="left">
                                            <table width="700" border="1" align="left" cellpadding="0" cellspacing="0" id="f">
												<tr>
													<td width="60" height="24">No.</td>
													<td width="100" nowrap>User</td>
													<td width="80" nowrap>Table Name</td>
													<td width="80" nowrap>Action</td>
													<td width="80" nowrap>Row Id</td>
													<td width="120" nowrap>Created</td>
													<td width="200" nowrap>Notes</td>
												</tr>

                                                <%
                                                    for (int i = 0; i < list_trail.size(); i++) {
                                                        Trail trail = (Trail) list_trail.get(i);
                                                        String emp = (String) hm_emp.get(String.valueOf(trail.getUser_id()));
                                                %>
                                                <tr>
													<td class="g"><%=trail.getId()%></td>
													<td><%=(emp==null ? "&nbsp;" : emp)%></td>
													<td><%=trail.getTable_name()%></td>
													<td><%=trail.getAction()%></td>
													<td><%=trail.getRow_id()%></td>
													<td><%=trail.getCreated()%></td>
													<td><%=StringUtils.left(trail.getNotes(),30) + "..."%></td>
												</tr>
                                                <%}%>
											</table>
										</td>
									</tr>
									<tr>
										<td height="390" colspan="3"></td>
									</tr>
									<tr align="center" valign="bottom">
										<td align="center">

                </td>
                                    </tr>
                                    <%@ include file="../copyright.jsp" %>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

    </body>
</html>
