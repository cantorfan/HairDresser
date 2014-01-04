<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.bean.Location" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Transaction" %>
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
    ArrayList list = Location.findAll();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Appointments Report</title>
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
				<td height="47"  colspan="3">
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
                        <h1>Salaries and statistic report</h1>
                    </div>
                    <div align = "center" class="data">
                    <form id="report" name="report" method="post" action="../report?query=salaries_and_statistic">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                   <table border="0" cellpadding="0" cellspacing="0">
                                        <tr><td>From Date</td></tr>
                                        <tr>
                                            <td><font size="1">Year</font></td>
                                            <td><font size="1">Month</font></td>
                                            <td><font size="1">Day</font></td>
                                        </tr>
                                        <tr>
                                             <td>
                                                <select id="tbFromSelYear" name="tbFromSelYear">
                                                <option value="2007">2007</option>
                                                <option value="2008">2008</option>
                                                <option value="2009">2009</option>
                                                <option value="2010">2010</option>
                                                <option value="2011">2011</option>
                                                <option value="2012">2012</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select id="tbFromSelMonth" name="tbFromSelMonth" >
                                                    <option value="1">January</option>
                                                    <option value="2">February</option>
                                                    <option value="3">March</option>
                                                    <option value="4">April</option>
                                                    <option value="5">May</option>
                                                    <option value="6">June</option>
                                                    <option value="7">July</option>
                                                    <option value="8">August</option>
                                                    <option value="9">September</option>
                                                    <option value="10">October</option>
                                                    <option value="11">November</option>
                                                    <option value="12">December</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select id="tbFromSelDay" name="tbFromSelDay">
                                                <option value="1">1</option>
                                                <option value="2">2</option>
                                                <option value="3">3</option>
                                                <option value="4">4</option>
                                                <option value="5">5</option>
                                                <option value="6">6</option>
                                                <option value="7">7</option>
                                                <option value="8">8</option>
                                                <option value="9">9</option>
                                                <option value="10">10</option>
                                                <option value="11">11</option>
                                                <option value="12">12</option>
                                                <option value="13">13</option>
                                                <option value="14">14</option>
                                                <option value="15">15</option>
                                                <option value="16">16</option>
                                                <option value="17">17</option>
                                                <option value="18">18</option>
                                                <option value="19">19</option>
                                                <option value="20">20</option>
                                                <option value="21">21</option>
                                                <option value="22">22</option>
                                                <option value="23">23</option>
                                                <option value="24">24</option>
                                                <option value="25">25</option>
                                                <option value="26">26</option>
                                                <option value="27">27</option>
                                                <option value="28">28</option>
                                                <option value="29">29</option>
                                                <option value="30">30</option>
                                                <option value="31">31</option>
                                                </select>
                                            </td>
                                       </tr>
                                   </table>
                                </td>
                                <td>&nbsp;</td>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0">
                                         <tr><td>To Date</td></tr>
                                         <tr>
                                             <td><font size="1">Year</font></td>
                                             <td><font size="1">Month</font></td>
                                             <td><font size="1">Day</font></td>
                                         </tr>
                                         <tr>
                                              <td>
                                                 <select id="tbToSelYear" name="tbToSelYear">
                                                 <option value="2007">2007</option>
                                                 <option value="2008">2008</option>
                                                 <option value="2009">2009</option>
                                                 <option value="2010">2010</option>
                                                 <option value="2011">2011</option>
                                                 <option value="2012">2012</option>
                                                 </select>
                                             </td>
                                             <td>
                                                 <select id="tbToSelMonth" name="tbToSelMonth" >
                                                 <option value="1">January</option>
                                                 <option value="2">February</option>
                                                 <option value="3">March</option>
                                                 <option value="4">April</option>
                                                 <option value="5">May</option>
                                                 <option value="6">June</option>
                                                 <option value="7">July</option>
                                                 <option value="8">August</option>
                                                 <option value="9">September</option>
                                                 <option value="10">October</option>
                                                 <option value="11">November</option>
                                                 <option value="12">December</option>
                                                 </select>
                                             </td>
                                             <td>
                                                 <select id="tbToSelDay" name="tbToSelDay" >
                                                 <option value="1">1</option>
                                                 <option value="2">2</option>
                                                 <option value="3">3</option>
                                                 <option value="4">4</option>
                                                 <option value="5">5</option>
                                                 <option value="6">6</option>
                                                 <option value="7">7</option>
                                                 <option value="8">8</option>
                                                 <option value="9">9</option>
                                                 <option value="10">10</option>
                                                 <option value="11">11</option>
                                                 <option value="12">12</option>
                                                 <option value="13">13</option>
                                                 <option value="14">14</option>
                                                 <option value="15">15</option>
                                                 <option value="16">16</option>
                                                 <option value="17">17</option>
                                                 <option value="18">18</option>
                                                 <option value="19">19</option>
                                                 <option value="20">20</option>
                                                 <option value="21">21</option>
                                                 <option value="22">22</option>
                                                 <option value="23">23</option>
                                                 <option value="24">24</option>
                                                 <option value="25">25</option>
                                                 <option value="26">26</option>
                                                 <option value="27">27</option>
                                                 <option value="28">28</option>
                                                 <option value="29">29</option>
                                                 <option value="30">30</option>
                                                 <option value="31">31</option>
                                                 </select>
                                             </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" align="right">
                                    <input type="button" value="Generate" onclick="submit();">
                                </td>
                            </tr>
                        </table>
                    </form>
                    </div>
                </div>
            </div>
            </td>
			</tr>
            <%@ include file="../copyright.jsp" %>
        </table>
    <script type="text/javascript">
        var current_date = new Date;
        var _tbFromSelYear = document.getElementById("tbFromSelYear");
        var _tbFromSelMonth = document.getElementById("tbFromSelMonth");
        var _tbFromSelDay = document.getElementById("tbFromSelDay");
        var _tbToSelYear = document.getElementById("tbToSelYear");
        var _tbToSelMonth = document.getElementById("tbToSelMonth");
        var _tbToSelDay = document.getElementById("tbToSelDay");

        for (var i=0; i< _tbFromSelYear.options.length;i++){
            if (_tbFromSelYear.options[i].text == current_date.getUTCFullYear()){
                _tbFromSelYear.options[i].selected = true;
            }
        }
        for (var i=0; i< _tbFromSelMonth.options.length;i++){
            if (_tbFromSelMonth.options[i].value -1 == current_date.getUTCMonth()){
                _tbFromSelMonth.options[i].selected = true;
            }
        }
        for (var i=0; i< _tbFromSelDay.options.length;i++){
            if (_tbFromSelDay.options[i].text == current_date.getDate()){
                _tbFromSelDay.options[i].selected = true;
            }
        }
        for (var i=0; i< _tbToSelYear.options.length;i++){
            if (_tbToSelYear.options[i].text == current_date.getUTCFullYear()){
                _tbToSelYear.options[i].selected = true;
            }
        }
        for (var i=0; i< _tbToSelMonth.options.length;i++){
            if (_tbToSelMonth.options[i].value -1 == current_date.getUTCMonth()){
                _tbToSelMonth.options[i].selected = true;
            }
        }
        for (var i=0; i< _tbToSelDay.options.length;i++){
            if (_tbToSelDay.options[i].text == current_date.getDate()){
                _tbToSelDay.options[i].selected = true;
            }
        }
//         = _tbToSelYear = current_date.getYear();
    </script>
	</body>
</html>