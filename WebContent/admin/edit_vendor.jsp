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
    org.xu.swan.bean.Vendor ven = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(Inventory.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        ven = Vendor.findById(Integer.parseInt(id));
    else
        ven = (Vendor) request.getAttribute("OBJECT");
    String title = "";
    if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
        title = "Add";
    } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
        title = "Edit";
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Add or edit Inventory</title>
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
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
                <div id="container">
                    <img class="rightcorner" src="../images/page_right.jpg" alt="">
                    <img class="leftcorner" src="../images/page_left.jpg" alt="">
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1><%=title%> Vendor</h1> 
                            </div>

                            <form id="vendor" name="vendor" method="post" action="./vendor.do?action=<%=action%>" onsubmit="javascript: return formvalidate(this);">
                            <input name="id" id="id" type="hidden" value="<%=(ven!=null?String.valueOf(ven.getId()):"")%>">
                                <div class="validation"><%=resx.getREQMESSAGE()%></div>
                                <div class="field">
                                    <label for="name">Company Name <%=resx.getVALIDATOR()%></label>
                                    <input valid="text" name="name" id="name" type="text" class="ctrl" maxlength="30" value="<%=(ven!=null?ven.getName():"")%>">
                                </div>
                                
                                <div class="field">
                                    <label for="address">Address</label>
                                    <input name="address" id="address" type="text" maxlength="30" value="<%=(ven!=null?ven.getAddress():"")%>">
                                </div>

                                <div class="field">
                                    <label for="city">City</label>
                                    <input name="city" id="city" type="text" maxlength="30" value="<%=(ven!=null?ven.getCity():"")%>">
                                </div>

                                <div class="field">
                                    <label for="state">State</label>
                                    <input name="state" id="state" type="text" maxlength="30" value="<%=(ven!=null?ven.getState():"")%>">
                                </div>

                                <div class="field">
                                    <label for="zip">Zip</label>
                                    <input name="zip" id="zip" type="text" maxlength="30" value="<%=(ven!=null?ven.getZip():"")%>">
                                </div>

                                <div class="field">
                                    <label for="country">Country</label>
                                    <input name="country" id="country" type="text" maxlength="30" value="<%=(ven!=null?ven.getCountry():"")%>">
                                </div>

                                <div class="field">
                                    <label for="phone_number">Phone number Ext</label>
                                    <input name="phone_number" id="phone_number" type="text" maxlength="30" value="<%=(ven!=null?ven.getPhoneNumber():"")%>">
                                </div>

                               <div class="field">
                                    <label for="email_address">Contact name</label>
                                    <input name="contact_name" id="contact_name" type="text" class="ctrl" maxlength="30" value="<%=(ven!=null?ven.getContact_name():"")%>">
                               </div>

                               <div class="field">
                                    <label for="email_address"><nobr>Phone number of contact</nobr></label>
                                    <input name="ph_num_contact" id="ph_num_contact" type="text" class="ctrl" maxlength="30" value="<%=(ven!=null?ven.getPh_num_contact():"")%>">
                               </div>

                               <div class="field">
                                    <label for="email_address">Email address</label>
                                    <input name="email_address" id="email_address" type="text" class="ctrl" maxlength="30" value="<%=(ven!=null?ven.getEmailAddress():"")%>">
                               </div>

                               <div class="field">
                                    <label for="email_address">Website</label>
                                    <input name="website" id="website" type="text" class="ctrl" maxlength="30" value="<%=(ven!=null?ven.getWebsite():"")%>">
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
                                                <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_vendor.jsp'">--%>
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