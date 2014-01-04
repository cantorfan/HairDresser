<%@ page import="org.xu.swan.bean.Transaction" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
<%
    String error_code = StringUtils.defaultString(request.getParameter("ec"), "0");
    ResourcesManager resx = new ResourcesManager();
    String message = "Error.";
    if (error_code.equals("1")){
        message = resx.getREDIRECTMSG();
    } else if (error_code.equals("2")){
        message = resx.getPERMISSIONMSG();
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Error</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
        <meta content="5; url=index.jsp" http-equiv="refresh">
        <LINK href="css/style.css" type=text/css rel=stylesheet>

	</head>
	<body topmargin="0" onload="/*menuFix(); */MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
		<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
			<tr valign="top">
                <%
                    String activePage = "error";
                    String rootPath = "";
                %>
                <%@ include file="top_page.jsp" %>
			</tr>

		</table>
		<table width="1040" border="0" cellspacing="0" cellpadding="0">
        <tr>
				<td align="center" valign="middle">
                    <div id="container">
                    <img class="rightcorner" src="images/page_right.jpg" alt="">
                    <img class="leftcorner" src="images/page_left.jpg" alt="">

                    <div class="padder">

                    </div>
                        <div style="color: rgb(255, 0, 0); font-size: 18px;"><%=message%></div>
                        <br/>
                         <div style="font-size: 14px;">You will be redirected to the <a style="font-size: 14px;" href="index.jsp">login</a> page in 5 seconds.</div>
                </div>
				</td>
            <td>
            </td>
			</tr>
            <%@ include file="copyright.jsp" %>
		</table>
	</body>
</html>
