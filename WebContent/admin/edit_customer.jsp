<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
<%@ page import="org.xu.swan.bean.Customer" %>
<%@ page import="org.xu.swan.bean.Location" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
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
    Customer cust = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(Customer.ID), ActionUtil.EMPTY);
    String location = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        cust = Customer.findById(Integer.parseInt(id));
    else
        cust = (Customer) request.getAttribute("OBJECT");
    String title = "";
    if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
        title = "Add";
    } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
        title = "Edit";
    }
    String dt = "";
    if(cust != null && cust.getDate_of_birth() != null)
    {
        dt = StringUtils.defaultString(cust.getDate_of_birth().toString(), "");
        Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(dt);
        if (lMatcher.matches()) {
            dt = dt.trim().replace('-', '/').replaceAll("/0", "/");
        }
    }
    ArrayList list = Location.findAll();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=title%> Customer</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
        <link rel="stylesheet" type="text/css" media="all" href="../jscalendar/calendar-hd-admin.css" title="hd" />
        <script type="text/javascript" src="../jscalendar/calendar.js"></script>
        <script type="text/javascript" src="../jscalendar/lang/calendar-en.js"></script>
        <script type="text/javascript" src="../jscalendar/calendar-setup.js"></script>
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
                                <h1><%=title%> Customer</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <form id="customer" name="customer" method="post" action="./customer.do?action=<%=action%>"  enctype="multipart/form-data" onsubmit="return formvalidate(this);">
                                <input name="id" type="hidden" value="<%=(cust!=null?String.valueOf(cust.getId()):"")%>">

                                <div class="validation"><%=resx.getREQMESSAGE()%></div>
                                <div class="field">
                                    <label for="fname">First Name <%=resx.getVALIDATOR()%></label>
                                    <input  id="fname" name="fname" valid="text" type="text" maxlength="30" value="<%=(cust!=null?cust.getFname():"")%>">
                                </div>

                                <div class="field">
                                    <label for="lname">Last Name <%=resx.getVALIDATOR()%></label>
                                    <input id="lname" name="lname" valid="text" type="text" maxlength="30" value="<%=(cust!=null?cust.getLname():"")%>">
                                </div>

                                <div class="field">
                                    <label for="email">Email</label>
                                    <input id="email" name="email" type="text" maxlength="30" value="<%=(cust!=null?cust.getEmail():"")%>">
                                </div>

                                <div class="field">
                                    <label for="phone">Phone <%=resx.getVALIDATOR()%></label>
                                    <input id="phone" name="phone" valid="text" type="text" maxlength="30" value="<%=(cust!=null?cust.getPhone():"")%>">
                                </div>

                                <div class="field">
                                    <label for="cell_phone">Cell phone</label>
                                    <input id="cell_phone" name="cell_phone" type="text" maxlength="30" value="<%=(cust!=null?cust.getCell_phone():"")%>">
                                </div>

                                <div class="field">
                                    <label for="work_phone_ext">Work phone ext</label>
                                    <input id="work_phone_ext" name="work_phone_ext" type="text" maxlength="30" value="<%=(cust!=null?cust.getWork_phone_ext():"")%>">
                                </div>

                                <div class="field">
                                    <label>Sex</label>
                                    <input type="radio" name="male_female" value="male" <%if(cust!=null && cust.getMale_female() == 1){%>checked="true" <%}%>>Male
                                    <input type="radio" name="male_female" value="female" <%if(cust!=null && cust.getMale_female() == 2){%>checked="true" <%}%>>Female
                                </div>

                                <div class="field">
                                    <label for="address">Address</label>
                                    <input id="address" name="address" type="text" maxlength="50" value="<%=(cust!=null?cust.getAddress():"")%>">
                                </div>
                                <div class="field">
                                    <label for="country">Country</label>
                                    <select id="country" name="country">
                                        <%--<option value="0" <%=(cust!=null && cust.getCountry()==0?"selected":"")%>>USA</option>--%>
                                        <%--<option value="" selected="selected">Select Country</option>--%>
                                        <option value="1" <%=(cust!=null && cust.getCountry()==1?"selected":"")%>>Albania</option>
                                        <option value="2" <%=(cust!=null && cust.getCountry()==2?"selected":"")%>>Algeria</option>
                                        <option value="3" <%=(cust!=null && cust.getCountry()==3?"selected":"")%>>American Samoa</option>
                                        <option value="4" <%=(cust!=null && cust.getCountry()==4?"selected":"")%>>Andorra</option>
                                        <option value="5" <%=(cust!=null && cust.getCountry()==5?"selected":"")%>>Angola</option>
                                        <option value="6" <%=(cust!=null && cust.getCountry()==6?"selected":"")%>>Anguilla</option>
                                        <option value="7" <%=(cust!=null && cust.getCountry()==7?"selected":"")%>>Antarctica</option>
                                        <option value="8" <%=(cust!=null && cust.getCountry()==8?"selected":"")%>>Antigua and Barbuda</option>
                                        <option value="9" <%=(cust!=null && cust.getCountry()==9?"selected":"")%>>Argentina</option>
                                        <option value="10" <%=(cust!=null && cust.getCountry()==10?"selected":"")%>>Armenia</option>
                                        <option value="11" <%=(cust!=null && cust.getCountry()==11?"selected":"")%>>Aruba</option>
                                        <option value="12" <%=(cust!=null && cust.getCountry()==12?"selected":"")%>>Australia</option>
                                        <option value="13" <%=(cust!=null && cust.getCountry()==13?"selected":"")%>>Austria</option>
                                        <option value="14" <%=(cust!=null && cust.getCountry()==14?"selected":"")%>>Azerbaijan</option>
                                        <option value="15" <%=(cust!=null && cust.getCountry()==15?"selected":"")%>>Bahamas</option>
                                        <option value="16" <%=(cust!=null && cust.getCountry()==16?"selected":"")%>>Bahrain</option>
                                        <option value="17" <%=(cust!=null && cust.getCountry()==17?"selected":"")%>>Bangladesh</option>
                                        <option value="18" <%=(cust!=null && cust.getCountry()==18?"selected":"")%>>Barbados</option>
                                        <option value="19" <%=(cust!=null && cust.getCountry()==19?"selected":"")%>>Belarus</option>
                                        <option value="20" <%=(cust!=null && cust.getCountry()==20?"selected":"")%>>Belgium</option>
                                        <option value="21" <%=(cust!=null && cust.getCountry()==21?"selected":"")%>>Belize</option>
                                        <option value="22" <%=(cust!=null && cust.getCountry()==22?"selected":"")%>>Benin</option>
                                        <option value="23" <%=(cust!=null && cust.getCountry()==23?"selected":"")%>>Bermuda</option>
                                        <option value="24" <%=(cust!=null && cust.getCountry()==24?"selected":"")%>>Bhutan</option>
                                        <option value="25" <%=(cust!=null && cust.getCountry()==25?"selected":"")%>>Bolivia</option>
                                        <option value="26" <%=(cust!=null && cust.getCountry()==26?"selected":"")%>>Bosnia and Herzegovina</option>
                                        <option value="27" <%=(cust!=null && cust.getCountry()==27?"selected":"")%>>Botswana</option>
                                        <option value="28" <%=(cust!=null && cust.getCountry()==28?"selected":"")%>>Bouvet Island</option>
                                        <option value="29" <%=(cust!=null && cust.getCountry()==29?"selected":"")%>>Brazil</option>
                                        <option value="30" <%=(cust!=null && cust.getCountry()==30?"selected":"")%>>British Indian Ocean Territory</option>
                                        <option value="31" <%=(cust!=null && cust.getCountry()==31?"selected":"")%>>Brunei Darussalam</option>
                                        <option value="32" <%=(cust!=null && cust.getCountry()==32?"selected":"")%>>Bulgaria</option>
                                        <option value="33" <%=(cust!=null && cust.getCountry()==33?"selected":"")%>>Burkina Faso</option>
                                        <option value="34" <%=(cust!=null && cust.getCountry()==34?"selected":"")%>>Burundi</option>
                                        <option value="35" <%=(cust!=null && cust.getCountry()==35?"selected":"")%>>Cambodia</option>
                                        <option value="36" <%=(cust!=null && cust.getCountry()==36?"selected":"")%>>Cameroon</option>
                                        <option value="37" <%=(cust!=null && cust.getCountry()==37?"selected":"")%>>Canada</option>
                                        <option value="38" <%=(cust!=null && cust.getCountry()==38?"selected":"")%>>Cape Verde</option>
                                        <option value="39" <%=(cust!=null && cust.getCountry()==39?"selected":"")%>>Cayman Islands</option>
                                        <option value="40" <%=(cust!=null && cust.getCountry()==40?"selected":"")%>>Central African Republic</option>
                                        <option value="41" <%=(cust!=null && cust.getCountry()==41?"selected":"")%>>Chad</option>
                                        <option value="42" <%=(cust!=null && cust.getCountry()==42?"selected":"")%>>Chile</option>
                                        <option value="43" <%=(cust!=null && cust.getCountry()==43?"selected":"")%>>China</option>
                                        <option value="44" <%=(cust!=null && cust.getCountry()==44?"selected":"")%>>Christmas Island</option>
                                        <option value="45" <%=(cust!=null && cust.getCountry()==45?"selected":"")%>>Cocos (Keeling) Islands</option>
                                        <option value="46" <%=(cust!=null && cust.getCountry()==46?"selected":"")%>>Colombia</option>
                                        <option value="47" <%=(cust!=null && cust.getCountry()==47?"selected":"")%>>Comoros</option>
                                        <option value="48" <%=(cust!=null && cust.getCountry()==48?"selected":"")%>>Congo</option>
                                        <option value="49" <%=(cust!=null && cust.getCountry()==49?"selected":"")%>>Congo, The Democratic Republic of The</option>
                                        <option value="50" <%=(cust!=null && cust.getCountry()==50?"selected":"")%>>Cook Islands</option>
                                        <option value="51" <%=(cust!=null && cust.getCountry()==51?"selected":"")%>>Costa Rica</option>
                                        <option value="52" <%=(cust!=null && cust.getCountry()==52?"selected":"")%>>Cote D'ivoire</option>
                                        <option value="53" <%=(cust!=null && cust.getCountry()==53?"selected":"")%>>Croatia</option>
                                        <option value="54" <%=(cust!=null && cust.getCountry()==54?"selected":"")%>>Cuba</option>
                                        <option value="55" <%=(cust!=null && cust.getCountry()==55?"selected":"")%>>Cyprus</option>
                                        <option value="56" <%=(cust!=null && cust.getCountry()==56?"selected":"")%>>Czech Republic</option>
                                        <option value="57" <%=(cust!=null && cust.getCountry()==57?"selected":"")%>>Denmark</option>
                                        <option value="58" <%=(cust!=null && cust.getCountry()==58?"selected":"")%>>Djibouti</option>
                                        <option value="59" <%=(cust!=null && cust.getCountry()==59?"selected":"")%>>Dominica</option>
                                        <option value="60" <%=(cust!=null && cust.getCountry()==60?"selected":"")%>>Dominican Republic</option>
                                        <option value="61" <%=(cust!=null && cust.getCountry()==61?"selected":"")%>>Ecuador</option>
                                        <option value="62" <%=(cust!=null && cust.getCountry()==62?"selected":"")%>>Egypt</option>
                                        <option value="63" <%=(cust!=null && cust.getCountry()==63?"selected":"")%>>El Salvador</option>
                                        <option value="64" <%=(cust!=null && cust.getCountry()==64?"selected":"")%>>Equatorial Guinea</option>
                                        <option value="65" <%=(cust!=null && cust.getCountry()==65?"selected":"")%>>Eritrea</option>
                                        <option value="66" <%=(cust!=null && cust.getCountry()==66?"selected":"")%>>Estonia</option>
                                        <option value="67" <%=(cust!=null && cust.getCountry()==67?"selected":"")%>>Ethiopia</option>
                                        <option value="68" <%=(cust!=null && cust.getCountry()==68?"selected":"")%>>Falkland Islands (Malvinas)</option>
                                        <option value="69" <%=(cust!=null && cust.getCountry()==69?"selected":"")%>>Faroe Islands</option>
                                        <option value="70" <%=(cust!=null && cust.getCountry()==70?"selected":"")%>>Fiji</option>
                                        <option value="71" <%=(cust!=null && cust.getCountry()==71?"selected":"")%>>Finland</option>
                                        <option value="72" <%=(cust!=null && cust.getCountry()==72?"selected":"")%>>France</option>
                                        <option value="73" <%=(cust!=null && cust.getCountry()==73?"selected":"")%>>French Guiana</option>
                                        <option value="74" <%=(cust!=null && cust.getCountry()==74?"selected":"")%>>French Polynesia</option>
                                        <option value="75" <%=(cust!=null && cust.getCountry()==75?"selected":"")%>>French Southern Territories</option>
                                        <option value="76" <%=(cust!=null && cust.getCountry()==76?"selected":"")%>>Gabon</option>
                                        <option value="77" <%=(cust!=null && cust.getCountry()==77?"selected":"")%>>Gambia</option>
                                        <option value="78" <%=(cust!=null && cust.getCountry()==78?"selected":"")%>>Georgia</option>
                                        <option value="79" <%=(cust!=null && cust.getCountry()==79?"selected":"")%>>Germany</option>
                                        <option value="80" <%=(cust!=null && cust.getCountry()==80?"selected":"")%>>Ghana</option>
                                        <option value="81" <%=(cust!=null && cust.getCountry()==81?"selected":"")%>>Gibraltar</option>
                                        <option value="82" <%=(cust!=null && cust.getCountry()==82?"selected":"")%>>Greece</option>
                                        <option value="83" <%=(cust!=null && cust.getCountry()==83?"selected":"")%>>Greenland</option>
                                        <option value="84" <%=(cust!=null && cust.getCountry()==84?"selected":"")%>>Grenada</option>
                                        <option value="85" <%=(cust!=null && cust.getCountry()==85?"selected":"")%>>Guadeloupe</option>
                                        <option value="86" <%=(cust!=null && cust.getCountry()==86?"selected":"")%>>Guam</option>
                                        <option value="87" <%=(cust!=null && cust.getCountry()==87?"selected":"")%>>Guatemala</option>
                                        <option value="88" <%=(cust!=null && cust.getCountry()==88?"selected":"")%>>Guinea</option>
                                        <option value="89" <%=(cust!=null && cust.getCountry()==89?"selected":"")%>>Guinea-bissau</option>
                                        <option value="90" <%=(cust!=null && cust.getCountry()==90?"selected":"")%>>Guyana</option>
                                        <option value="91" <%=(cust!=null && cust.getCountry()==91?"selected":"")%>>Haiti</option>
                                        <option value="92" <%=(cust!=null && cust.getCountry()==92?"selected":"")%>>Heard Island and Mcdonald Islands</option>
                                        <option value="93" <%=(cust!=null && cust.getCountry()==93?"selected":"")%>>Holy See (Vatican City State)</option>
                                        <option value="94" <%=(cust!=null && cust.getCountry()==94?"selected":"")%>>Honduras</option>
                                        <option value="95" <%=(cust!=null && cust.getCountry()==95?"selected":"")%>>Hong Kong</option>
                                        <option value="96" <%=(cust!=null && cust.getCountry()==96?"selected":"")%>>Hungary</option>
                                        <option value="97" <%=(cust!=null && cust.getCountry()==97?"selected":"")%>>Iceland</option>
                                        <option value="98" <%=(cust!=null && cust.getCountry()==98?"selected":"")%>>India</option>
                                        <option value="99" <%=(cust!=null && cust.getCountry()==99?"selected":"")%>>Indonesia</option>
                                        <option value="100" <%=(cust!=null && cust.getCountry()==100?"selected":"")%>>Iran, Islamic Republic of</option>
                                        <option value="101" <%=(cust!=null && cust.getCountry()==101?"selected":"")%>>Iraq</option>
                                        <option value="102" <%=(cust!=null && cust.getCountry()==102?"selected":"")%>>Ireland</option>
                                        <option value="103" <%=(cust!=null && cust.getCountry()==103?"selected":"")%>>Israel</option>
                                        <option value="104" <%=(cust!=null && cust.getCountry()==104?"selected":"")%>>Italy</option>
                                        <option value="105" <%=(cust!=null && cust.getCountry()==105?"selected":"")%>>Jamaica</option>
                                        <option value="106" <%=(cust!=null && cust.getCountry()==106?"selected":"")%>>Japan</option>
                                        <option value="107" <%=(cust!=null && cust.getCountry()==107?"selected":"")%>>Jordan</option>
                                        <option value="108" <%=(cust!=null && cust.getCountry()==108?"selected":"")%>>Kazakhstan</option>
                                        <option value="109" <%=(cust!=null && cust.getCountry()==109?"selected":"")%>>Kenya</option>
                                        <option value="110" <%=(cust!=null && cust.getCountry()==110?"selected":"")%>>Kiribati</option>
                                        <option value="111" <%=(cust!=null && cust.getCountry()==111?"selected":"")%>>Korea, Democratic People's Republic of</option>
                                        <option value="112" <%=(cust!=null && cust.getCountry()==112?"selected":"")%>>Korea, Republic of</option>
                                        <option value="113" <%=(cust!=null && cust.getCountry()==113?"selected":"")%>>Kuwait</option>
                                        <option value="114" <%=(cust!=null && cust.getCountry()==114?"selected":"")%>>Kyrgyzstan</option>
                                        <option value="115" <%=(cust!=null && cust.getCountry()==115?"selected":"")%>>Lao People's Democratic Republic</option>
                                        <option value="116" <%=(cust!=null && cust.getCountry()==116?"selected":"")%>>Latvia</option>
                                        <option value="117" <%=(cust!=null && cust.getCountry()==117?"selected":"")%>>Lebanon</option>
                                        <option value="118" <%=(cust!=null && cust.getCountry()==118?"selected":"")%>>Lesotho</option>
                                        <option value="119" <%=(cust!=null && cust.getCountry()==119?"selected":"")%>>Liberia</option>
                                        <option value="120" <%=(cust!=null && cust.getCountry()==120?"selected":"")%>>Libyan Arab Jamahiriya</option>
                                        <option value="121" <%=(cust!=null && cust.getCountry()==121?"selected":"")%>>Liechtenstein</option>
                                        <option value="122" <%=(cust!=null && cust.getCountry()==122?"selected":"")%>>Lithuania</option>
                                        <option value="123" <%=(cust!=null && cust.getCountry()==123?"selected":"")%>>Luxembourg</option>
                                        <option value="124" <%=(cust!=null && cust.getCountry()==124?"selected":"")%>>Macao</option>
                                        <option value="125" <%=(cust!=null && cust.getCountry()==125?"selected":"")%>>Macedonia, The Former Yugoslav Republic of</option>
                                        <option value="126" <%=(cust!=null && cust.getCountry()==126?"selected":"")%>>Madagascar</option>
                                        <option value="127" <%=(cust!=null && cust.getCountry()==127?"selected":"")%>>Malawi</option>
                                        <option value="128" <%=(cust!=null && cust.getCountry()==128?"selected":"")%>>Malaysia</option>
                                        <option value="129" <%=(cust!=null && cust.getCountry()==129?"selected":"")%>>Maldives</option>
                                        <option value="130" <%=(cust!=null && cust.getCountry()==130?"selected":"")%>>Mali</option>
                                        <option value="131" <%=(cust!=null && cust.getCountry()==131?"selected":"")%>>Malta</option>
                                        <option value="132" <%=(cust!=null && cust.getCountry()==132?"selected":"")%>>Marshall Islands</option>
                                        <option value="133" <%=(cust!=null && cust.getCountry()==133?"selected":"")%>>Martinique</option>
                                        <option value="134" <%=(cust!=null && cust.getCountry()==134?"selected":"")%>>Mauritania</option>
                                        <option value="135" <%=(cust!=null && cust.getCountry()==135?"selected":"")%>>Mauritius</option>
                                        <option value="136" <%=(cust!=null && cust.getCountry()==136?"selected":"")%>>Mayotte</option>
                                        <option value="137" <%=(cust!=null && cust.getCountry()==137?"selected":"")%>>Mexico</option>
                                        <option value="138" <%=(cust!=null && cust.getCountry()==138?"selected":"")%>>Micronesia, Federated States of</option>
                                        <option value="139" <%=(cust!=null && cust.getCountry()==139?"selected":"")%>>Moldova, Republic of</option>
                                        <option value="140" <%=(cust!=null && cust.getCountry()==140?"selected":"")%>>Monaco</option>
                                        <option value="141" <%=(cust!=null && cust.getCountry()==141?"selected":"")%>>Mongolia</option>
                                        <option value="142" <%=(cust!=null && cust.getCountry()==142?"selected":"")%>>Montserrat</option>
                                        <option value="143" <%=(cust!=null && cust.getCountry()==143?"selected":"")%>>Morocco</option>
                                        <option value="144" <%=(cust!=null && cust.getCountry()==144?"selected":"")%>>Mozambique</option>
                                        <option value="145" <%=(cust!=null && cust.getCountry()==145?"selected":"")%>>Myanmar</option>
                                        <option value="146" <%=(cust!=null && cust.getCountry()==146?"selected":"")%>>Namibia</option>
                                        <option value="147" <%=(cust!=null && cust.getCountry()==147?"selected":"")%>>Nauru</option>
                                        <option value="148" <%=(cust!=null && cust.getCountry()==148?"selected":"")%>>Nepal</option>
                                        <option value="149" <%=(cust!=null && cust.getCountry()==149?"selected":"")%>>Netherlands</option>
                                        <option value="150" <%=(cust!=null && cust.getCountry()==150?"selected":"")%>>Netherlands Antilles</option>
                                        <option value="151" <%=(cust!=null && cust.getCountry()==151?"selected":"")%>>New Caledonia</option>
                                        <option value="152" <%=(cust!=null && cust.getCountry()==152?"selected":"")%>>New Zealand</option>
                                        <option value="153" <%=(cust!=null && cust.getCountry()==153?"selected":"")%>>Nicaragua</option>
                                        <option value="154" <%=(cust!=null && cust.getCountry()==154?"selected":"")%>>Niger</option>
                                        <option value="155" <%=(cust!=null && cust.getCountry()==155?"selected":"")%>>Nigeria</option>
                                        <option value="156" <%=(cust!=null && cust.getCountry()==156?"selected":"")%>>Niue</option>
                                        <option value="157" <%=(cust!=null && cust.getCountry()==157?"selected":"")%>>Norfolk Island</option>
                                        <option value="158" <%=(cust!=null && cust.getCountry()==158?"selected":"")%>>Northern Mariana Islands</option>
                                        <option value="159" <%=(cust!=null && cust.getCountry()==159?"selected":"")%>>Norway</option>
                                        <option value="160" <%=(cust!=null && cust.getCountry()==160?"selected":"")%>>Oman</option>
                                        <option value="161" <%=(cust!=null && cust.getCountry()==161?"selected":"")%>>Pakistan</option>
                                        <option value="162" <%=(cust!=null && cust.getCountry()==162?"selected":"")%>>Palau</option>
                                        <option value="163" <%=(cust!=null && cust.getCountry()==163?"selected":"")%>>Palestinian Territory, Occupied</option>
                                        <option value="164" <%=(cust!=null && cust.getCountry()==164?"selected":"")%>>Panama</option>
                                        <option value="165" <%=(cust!=null && cust.getCountry()==165?"selected":"")%>>Papua New Guinea</option>
                                        <option value="166" <%=(cust!=null && cust.getCountry()==166?"selected":"")%>>Paraguay</option>
                                        <option value="167" <%=(cust!=null && cust.getCountry()==167?"selected":"")%>>Peru</option>
                                        <option value="168" <%=(cust!=null && cust.getCountry()==168?"selected":"")%>>Philippines</option>
                                        <option value="169" <%=(cust!=null && cust.getCountry()==169?"selected":"")%>>Pitcairn</option>
                                        <option value="170" <%=(cust!=null && cust.getCountry()==170?"selected":"")%>>Poland</option>
                                        <option value="171" <%=(cust!=null && cust.getCountry()==171?"selected":"")%>>Portugal</option>
                                        <option value="172" <%=(cust!=null && cust.getCountry()==172?"selected":"")%>>Puerto Rico</option>
                                        <option value="173" <%=(cust!=null && cust.getCountry()==173?"selected":"")%>>Qatar</option>
                                        <option value="174" <%=(cust!=null && cust.getCountry()==174?"selected":"")%>>Reunion</option>
                                        <option value="175" <%=(cust!=null && cust.getCountry()==175?"selected":"")%>>Romania</option>
                                        <option value="176" <%=(cust!=null && cust.getCountry()==176?"selected":"")%>>Russian Federation</option>
                                        <option value="177" <%=(cust!=null && cust.getCountry()==177?"selected":"")%>>Rwanda</option>
                                        <option value="178" <%=(cust!=null && cust.getCountry()==178?"selected":"")%>>Saint Helena</option>
                                        <option value="179" <%=(cust!=null && cust.getCountry()==179?"selected":"")%>>Saint Kitts and Nevis</option>
                                        <option value="180" <%=(cust!=null && cust.getCountry()==180?"selected":"")%>>Saint Lucia</option>
                                        <option value="181" <%=(cust!=null && cust.getCountry()==181?"selected":"")%>>Saint Pierre and Miquelon</option>
                                        <option value="182" <%=(cust!=null && cust.getCountry()==182?"selected":"")%>>Saint Vincent and The Grenadines</option>
                                        <option value="183" <%=(cust!=null && cust.getCountry()==183?"selected":"")%>>Samoa</option>
                                        <option value="184" <%=(cust!=null && cust.getCountry()==184?"selected":"")%>>San Marino</option>
                                        <option value="185" <%=(cust!=null && cust.getCountry()==185?"selected":"")%>>Sao Tome and Principe</option>
                                        <option value="186" <%=(cust!=null && cust.getCountry()==186?"selected":"")%>>Saudi Arabia</option>
                                        <option value="187" <%=(cust!=null && cust.getCountry()==187?"selected":"")%>>Senegal</option>
                                        <option value="188" <%=(cust!=null && cust.getCountry()==188?"selected":"")%>>Serbia and Montenegro</option>
                                        <option value="189" <%=(cust!=null && cust.getCountry()==189?"selected":"")%>>Seychelles</option>
                                        <option value="190" <%=(cust!=null && cust.getCountry()==190?"selected":"")%>>Sierra Leone</option>
                                        <option value="191" <%=(cust!=null && cust.getCountry()==191?"selected":"")%>>Singapore</option>
                                        <option value="192" <%=(cust!=null && cust.getCountry()==192?"selected":"")%>>Slovakia</option>
                                        <option value="193" <%=(cust!=null && cust.getCountry()==193?"selected":"")%>>Slovenia</option>
                                        <option value="194" <%=(cust!=null && cust.getCountry()==194?"selected":"")%>>Solomon Islands</option>
                                        <option value="195" <%=(cust!=null && cust.getCountry()==195?"selected":"")%>>Somalia</option>
                                        <option value="196" <%=(cust!=null && cust.getCountry()==196?"selected":"")%>>South Africa</option>
                                        <option value="197" <%=(cust!=null && cust.getCountry()==197?"selected":"")%>>South Georgia and The South Sandwich Islands</option>
                                        <option value="198" <%=(cust!=null && cust.getCountry()==198?"selected":"")%>>Spain</option>
                                        <option value="199" <%=(cust!=null && cust.getCountry()==199?"selected":"")%>>Sri Lanka</option>
                                        <option value="200" <%=(cust!=null && cust.getCountry()==200?"selected":"")%>>Sudan</option>
                                        <option value="201" <%=(cust!=null && cust.getCountry()==201?"selected":"")%>>Suriname</option>
                                        <option value="202" <%=(cust!=null && cust.getCountry()==202?"selected":"")%>>Svalbard and Jan Mayen</option>
                                        <option value="203" <%=(cust!=null && cust.getCountry()==203?"selected":"")%>>Swaziland</option>
                                        <option value="204" <%=(cust!=null && cust.getCountry()==204?"selected":"")%>>Sweden</option>
                                        <option value="205" <%=(cust!=null && cust.getCountry()==205?"selected":"")%>>Switzerland</option>
                                        <option value="206" <%=(cust!=null && cust.getCountry()==206?"selected":"")%>>Syrian Arab Republic</option>
                                        <option value="207" <%=(cust!=null && cust.getCountry()==207?"selected":"")%>>Taiwan, Province of China</option>
                                        <option value="208" <%=(cust!=null && cust.getCountry()==208?"selected":"")%>>Tajikistan</option>
                                        <option value="209" <%=(cust!=null && cust.getCountry()==209?"selected":"")%>>Tanzania, United Republic of</option>
                                        <option value="210" <%=(cust!=null && cust.getCountry()==210?"selected":"")%>>Thailand</option>
                                        <option value="211" <%=(cust!=null && cust.getCountry()==211?"selected":"")%>>Timor-leste</option>
                                        <option value="212" <%=(cust!=null && cust.getCountry()==212?"selected":"")%>>Togo</option>
                                        <option value="213" <%=(cust!=null && cust.getCountry()==213?"selected":"")%>>Tokelau</option>
                                        <option value="214" <%=(cust!=null && cust.getCountry()==214?"selected":"")%>>Tonga</option>
                                        <option value="215" <%=(cust!=null && cust.getCountry()==215?"selected":"")%>>Trinidad and Tobago</option>
                                        <option value="216" <%=(cust!=null && cust.getCountry()==216?"selected":"")%>>Tunisia</option>
                                        <option value="217" <%=(cust!=null && cust.getCountry()==217?"selected":"")%>>Turkey</option>
                                        <option value="218" <%=(cust!=null && cust.getCountry()==218?"selected":"")%>>Turkmenistan</option>
                                        <option value="219" <%=(cust!=null && cust.getCountry()==219?"selected":"")%>>Turks and Caicos Islands</option>
                                        <option value="220" <%=(cust!=null && cust.getCountry()==220?"selected":"")%>>Tuvalu</option>
                                        <option value="221" <%=(cust!=null && cust.getCountry()==221?"selected":"")%>>Uganda</option>
                                        <option value="222" <%=(cust!=null && cust.getCountry()==222?"selected":"")%>>Ukraine</option>
                                        <option value="223" <%=(cust!=null && cust.getCountry()==223?"selected":"")%>>United Arab Emirates</option>
                                        <option value="224" <%=(cust!=null && cust.getCountry()==224?"selected":"")%>>United Kingdom</option>
                                        <option value="225" <%=(cust!=null && (cust.getCountry()==225 || cust.getCountry()==0)?"selected":"")%>>United States</option>
                                        <option value="226" <%=(cust!=null && cust.getCountry()==226?"selected":"")%>>United States Minor Outlying Islands</option>
                                        <option value="227" <%=(cust!=null && cust.getCountry()==227?"selected":"")%>>Uruguay</option>
                                        <option value="228" <%=(cust!=null && cust.getCountry()==228?"selected":"")%>>Uzbekistan</option>
                                        <option value="229" <%=(cust!=null && cust.getCountry()==229?"selected":"")%>>Vanuatu</option>
                                        <option value="230" <%=(cust!=null && cust.getCountry()==230?"selected":"")%>>Venezuela</option>
                                        <option value="231" <%=(cust!=null && cust.getCountry()==231?"selected":"")%>>Viet Nam</option>
                                        <option value="232" <%=(cust!=null && cust.getCountry()==232?"selected":"")%>>Virgin Islands, British</option>
                                        <option value="233" <%=(cust!=null && cust.getCountry()==233?"selected":"")%>>Virgin Islands, U.S.</option>
                                        <option value="234" <%=(cust!=null && cust.getCountry()==234?"selected":"")%>>Wallis and Futuna</option>
                                        <option value="235" <%=(cust!=null && cust.getCountry()==235?"selected":"")%>>Western Sahara</option>
                                        <option value="236" <%=(cust!=null && cust.getCountry()==236?"selected":"")%>>Yemen</option>
                                        <option value="237" <%=(cust!=null && cust.getCountry()==237?"selected":"")%>>Zambia</option>
                                        <option value="238" <%=(cust!=null && cust.getCountry()==238?"selected":"")%>>Zimbabwe</option>



                                    </select>
                                </div>

                                <div class="field">
                                    <label for="city">City</label>
                                    <input id="city" name="city" type="text" maxlength="50" value="<%=(cust!=null?cust.getCity():"")%>">
                                </div>

                                <div class="field">
                                    <label for="state">State</label>
                                    <input id="state" name="state" type="text" maxlength="50" value="<%=(cust!=null?cust.getState():"")%>">
                                </div>

                                <div class="field">
                                    <label for="zip_code">Zip code</label>
                                    <input id="zip_code" name="zip_code" type="text" maxlength="50" value="<%=(cust!=null?cust.getZip_code():"")%>">
                                </div>

                                <div class="field">
                                    <label for="picture">Customer photo</label>
                                    <input id="picture" name="picture" type="file">
                                </div>

                                <div class="field">
                                    <label>Picture</label>
                                    <IMG height="50"  <% String image; String alt;
                                    if (cust!=null && cust.getPicture()!=null && cust.getPicture().length()!=0){
                                        image = "./ShowPhotoCustomer.do?id="+String.valueOf(cust.getId());
                                        alt = String.valueOf(cust.getFname()) + String.valueOf(cust.getLname());
                                    }else {
                                        image = "../images/noimage.jpg";
                                        alt = "No Photo";
                                    }%>
                                    src= "<%=image%>" alt="<%=alt%>">
                                </div>

                                <div class="field">
                                    <label>Date of Birth</label>
                                    <table cellspacing="0" cellpadding="0" style="float: left">
                                    <tr>
                                    <td style="margin:0; padding: 0"><input readonly id="b_date" name="b_date" type="text" maxlength="30" value="<%=dt%>"></td>
                                    <td style="margin:0; padding: 0"><input type="button" id="selDate" value='' style="background: url(../img/cal.png); width: 22px;height: 22px; border:0;"/></td>
                                    </tr></table>
                                        <SCRIPT type="text/javascript">
                                                    Calendar.setup(
                                                    {
                                                    inputField  : "b_date",     // ID of the input field
                                                    button      : "selDate",  // ID of the button
                                                    showsTime	: false,
                                                    electric    : false
                                                    }
                                                    );
                                        </SCRIPT>
                                </div>
                                <br />
                                <div id="error_message" name="error_message" class="error" style="float: left; clear: left; width: 100%">
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
                                                <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_customer.jsp'">--%>
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
