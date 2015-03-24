<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.bean.Location" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
<%@ page import="org.xu.swan.bean.WorkingtimeLoc" %>
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
    Location loc = null;                                      
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(Location.ID), ActionUtil.EMPTY);
    if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        loc = Location.findById(Integer.parseInt(id));
    else
        loc = (Location)request.getAttribute("OBJECT");
    ArrayList wtime = (loc != null? WorkingtimeLoc.findAllByLocationId(loc.getId()) : null) ;
//    if (wtime.size() == 0) wtime = null;
    java.util.List work_time = new ArrayList();
    for(double i = 0; i <= 24; i+=0.25){
        int h = (int)i;
        int m = (int)((i - h)*60);
        String s = (h < 10 ? "0" : "") + Integer.toString(h) + ":" +
                (m < 10 ? "0" : "") + Integer.toString(m) + ":00";
        work_time.add(s);
    }

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Edit Location</title>
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
                                <h1>Edit Location</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <!-- success/error message:
                            <div class="error"><p>Error message</p></div>
                            <div class="success"><p>Success message</p></div>
                            -->
                            <%--<logic:notPresent name="org.apache.struts.action.MESSAGE" scope="application">--%>
                            <%--<font color="red"> ERROR: Application resources not loaded -- check servlet container logs for error messages. </font>--%>
                            <%--</logic:notPresent>--%>
                            <%--<% String prompt = (String) request.getAttribute("MESSAGE");  if (StringUtils.isNotEmpty(prompt)){%>--%>
                            <%--<p><font color="red" face=verdana size="-1"> <bean:message key="<%=prompt%>"/> </font></p><%}%>--%>
                            <%  String[] tmp;
                                String[] addr2;
                                String temp;
                                String city = "";
                                String state = "";
                                String zip = "";
                                String country = "";
                                String telephone = "";
                                String fax = "";
                                String email = "";
                                String facebook = "";
                                String twitter = "";
                                String blog = "";
                                String idloc = "";
                                String name = "";
                                String address = "";
                                String currency = "";
                                String timezone = "";
//                                                                tmp = new String[6];
                                if (loc != null) {
                                    idloc = String.valueOf(loc.getId());
                                    name = loc.getName();
                                    address = loc.getAddress();
                                    telephone = loc.getPhone();
                                    fax = loc.getFax();
                                    email = loc.getEmail();
                                    facebook = loc.getFacebook();
                                    twitter = loc.getTwitter();
                                    blog = loc.getBlogger();
                                    country = loc.getCountry();
                                    state = loc.getState();
                                    city = loc.getCity();
                                    zip = loc.getZipcode();
                                    currency = loc.getCurrency();
                                    timezone = loc.getTimezone();
                                    if(timezone==null || timezone.length()==0)
                                    	timezone="";
                                    if (facebook.equals("")) facebook = "http://www.facebook.com/";
                                    if (twitter.equals("")) twitter = "http://www.twitter.com/";
                                    if (blog.equals("")) blog = "http://www.blogger.com/";

                                        tmp = loc.getAddress2().split(";");
                                        if (!tmp[0].equals("")){
                                            for (int i = 0; i<7; i++){
                                                temp = tmp[i];
                                                addr2 = temp.split(":");
                                                if (addr2.length == 2) {
                                                    if (addr2[0].equals("city")){
                                                        city = addr2[1];
                                                    }else if (addr2[0].equals("state")){
                                                        state = addr2[1];
                                                    }else if (addr2[0].equals("zip")){
                                                        zip = addr2[1];
                                                    }else if (addr2[0].equals("country")){
                                                        country = addr2[1];
                                                    }else if (addr2[0].equals("telephone")){
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
                            <form id="location" name="location" method="post" action="./location.do?action=<%=action%>" enctype="multipart/form-data" onsubmit="javascript: return formvalidate(this);">
                                <input name="idloc" type="hidden" value="<%=idloc%>">
                                <div class="validation"><%=resx.getREQMESSAGE()%></div>
                                <div class="field">
                                    <label for="name">Name <%=resx.getVALIDATOR()%></label>
                                    <input valid="text" id="name" name="name" type="text" maxlength="30" value="<%=name%>">
                                </div>

                                <div class="field" align="left">
                                    <label for="address" >Address</label>
                                    <textarea id="address" name="address" class="address" style="text-align:left;" rows="5" cols="50"><%=address%></textarea>
                                </div>
                                <%--<div class="field" >--%>
                                    <%--<label for="address">Address 2:</label>--%>
                                    <%--&nbsp;--%>

                                <%--</div>--%>

                                <%--<div class="field">--%>
                                    <%--<label for="A2city">City</label>--%>
                                    <%--<input id="A2city" name="A2city" type="text" maxlength="30" value="<%=city%>">--%>
                                <%--</div>--%>

                                <%--<div class="field">--%>
                                    <%--<label for="A2state">State</label>--%>
                                    <%--<input id="A2state" name="A2state" type="text" maxlength="30" value="<%=state%>">--%>
                                <%--</div>--%>

                                <%--<div class="field">--%>
                                    <%--<label for="A2zip">Zip</label>--%>
                                    <%--<input id="A2zip" name="A2zip" type="text" maxlength="10" value="<%=zip%>">--%>
                                <%--</div>--%>

                                <%--<div class="field">--%>
                                    <%--<label for="A2country">Country</label>--%>
                                    <%--<input id="A2country" name="A2country" type="text" maxlength="30" value="<%=country%>">--%>
                                <%--</div>--%>
                                <div class="field">
                                    <div style="float: left;">
                                        <label  for="A2telephone">Telephone</label>
                                        <input id="A2telephone" name="A2telephone" type="text" maxlength="30" value="<%=telephone%>">
                                    </div>

                                    <div class="contacts">
                                        <label for="A2fax">Fax</label>
                                        <input id="A2fax" name="A2fax" type="text" maxlength="30" value="<%=fax%>">
                                    </div>

                                    <div class="contacts">
                                        <label for="A2email">Email</label>
                                        <input id="A2email" name="A2email" type="text" maxlength="100" value="<%=email%>">
                                    </div>
                                    <div class="clear"></div>
                                </div>
                                <div class="field">
                                    <div style="float: left;">
                                        <label  for="Facebook">Facebook</label>
                                        <input id="facebook" name="facebook" type="text" maxlength="200" value="<%=facebook%>">
                                    </div>

                                    <div class="contacts">
                                        <label for="Twitter">Twitter</label>
                                        <input id="twitter" name="twitter" type="text" maxlength="200" value="<%=twitter%>">
                                    </div>

                                    <div class="contacts">
                                        <label for="Blog">Blog</label>
                                        <input id="blog" name="blog" type="text" maxlength="200" value="<%=blog%>">
                                    </div>
                                    <div class="clear"></div>
                                </div>
                                <div class="field">
                                    <label for="currency">Currency</label>
                                    <select name="currency" id="currency">
                                        <option value="1" <%=(currency.equals("1")?"selected":"")%>>U.S. dollars (USD)</option>
                                        <option value="2" <%=(currency.equals("2")?"selected":"")%>>Euros (EUR)</option>
                                        <option value="3" <%=(currency.equals("3")?"selected":"")%>>Pounds sterling (GBP)</option>
                                        <option value="4" <%=(currency.equals("4")?"selected":"")%>>Canadian dollars (CAD)</option>
                                        <option value="5" <%=(currency.equals("5")?"selected":"")%>>Australian dollars (AUD)</option>
                                        <option value="6" <%=(currency.equals("6")?"selected":"")%>>Swiss francs (CHF)</option>
                                        <option value="7" <%=(currency.equals("7")?"selected":"")%>>Japanese yen (JPY)</option>
                                    </select>
                                </div>
                                <div class="field">
                                    <label for="currency">Time Zone</label>
                      <%--              <script type="text/javascript">
                                        TimeZones=new Array(                              // UTC offset '=' locations
                                                'UTC -12:00=-720=Eniwelok, Kwajalein',
                                                'UTC -11:00=-660=Midway Island, Samoa',
                                                'UTC -10:30=-630=Cook Islands',
                                                'UTC -10:00=-600=Hawaii; Western Aleutian Islands=was Alaska/Hawaii timezone',
                                                'UTC -09:30=-570=Marquesas Islands',
                                                'UTC -09:00=-540=Alaska; Eastern Aleutian Islands=was Yukon timezone',
                                                'UTC -08:30=-510=Pitcairn Island',
                                                'UTC -08:00=-480=Pacific Time (US & Canada); Yukon; Tijuana',
                                                'UTC -07:00=-420=Mountain Time (US & Canada)',
                                                'UTC -06:00=-360=Central Time (US & Canada); Mexico City, Tegucigalpa',
                                                'UTC -05:00=-300=Eastern Time (US & Canada); Bogota; Lima; Quito',
                                                'UTC -04:30=-270=Caracas',
                                                'UTC -04:00=-240=Atlantic Time (Canada); Caracas, La Paz; Santiago',
                                                'UTC -03:45=-225=Guyana, South America',
                                                'UTC -03:30=-210=Newfoundland; Suriname, South America',
                                                'UTC -03:00=-180=Greenland; Brasilia; Buernos Aires; Puerto Rico',
                                                'UTC -02:00=-120=Mid-Atlantic',
                                                'UTC -01:00=-60=Azores, Cape Verde Is.',
                                                'UTC +00:00=0=Greenwich Mean Time',
                                                'UTC +01:00=60=Amsterdam; Berlin; Bern; Rome; Stockholm; Vienna',
                                                'UTC +02:00=120=Athens; Istanbul; Minsk; Jerusalem',
                                                'UTC +03:00=180=Baghdad; Kuwait',
                                                'UTC +03:30=210=Tehran, Iran',
                                                'UTC +04:00=240=Abu Dhabi; Muscat; Moscow',
                                                'UTC +04:30=270=Kabul, Afghanistan',
                                                'UTC +05:00=300=Ekaterinburg',
                                                'UTC +05:30=330=India; Bombay; Calcutta; New Delhi; Sri Lanka',
                                                'UTC +05:45=345=Kathmandu, Nepal',
                                                'UTC +06:00=360=Astana; Dhaka',
                                                'UTC +06:30=390=Cocos Islands; Yangon; Myanmar',
                                                'UTC +07:00=420=Bangkok; Hanoi',
                                                'UTC +08:00=480=Perth; Singapore; China',
                                                'UTC +08:45=525=South Australia',
                                                'UTC +09:00=540=Osaka; Tokyo; Seoul',
                                                'UTC +09:30=570=Northern Australia',
                                                'UTC +10:00=600=Brisbane; Canberra; Sydney; Guam',
                                                'UTC +11:00=660=Magadan; Solomon Is.; New Caledonia',
                                                'UTC +11:30=690=New Zealand?; Norfold Island, Australia',
                                                'UTC +12:00=720=Auckland; Wellington; Fiji; Marshall Is.; Tuvalu',
                                                'UTC +12:45=765=Chatham Island, New Zealand',
                                                'UTC +13:00=780=Nukulalofa; Phoenix Islands=1 hour EAST of the dateline',
                                                'UTC +14:00=840=Line Islands; Christmas Islands=2 hours EAST of the dateline',
                                                '');
                                        for (var i1=0; i<TimeZones.length; i++){

                                        }
                                    </script>--%>
                                    <%

                                        ArrayList<String> TimeZones=new ArrayList<String>();
                                        TimeZones.add("");
                                        TimeZones.add("GMT-12:00=-720=Eniwelok, Kwajalein");
                                        TimeZones.add("GMT-11:00=-660=Midway Island, Samoa");
                                        TimeZones.add("GMT-10:30=-630=Cook Islands");
                                        TimeZones.add("GMT-10:00=-600=Hawaii; Western Aleutian Islands=was Alaska/Hawaii timezone");
                                        TimeZones.add("GMT-09:30=-570=Marquesas Islands");
                                        TimeZones.add("GMT-09:00=-540=Alaska; Eastern Aleutian Islands=was Yukon timezone");
                                        TimeZones.add("GMT-08:30=-510=Pitcairn Island");
                                        TimeZones.add("GMT-08:00=-480=Pacific Time (US & Canada); Yukon; Tijuana");
                                        TimeZones.add("GMT-07:00=-420=Mountain Time (US & Canada)");
                                        TimeZones.add("GMT-06:00=-360=Central Time (US & Canada); Mexico City, Tegucigalpa");
                                        TimeZones.add("GMT-05:00=-300=Eastern Time (US & Canada); Bogota; Lima; Quito");
                                        TimeZones.add("GMT-04:30=-270=Caracas");
                                        TimeZones.add("GMT-04:00=-240=Atlantic Time (Canada); Caracas, La Paz; Santiago");
                                        TimeZones.add("GMT-03:45=-225=Guyana, South America");
                                        TimeZones.add("GMT-03:30=-210=Newfoundland; Suriname, South America");
                                        TimeZones.add("GMT-03:00=-180=Greenland; Brasilia; Buernos Aires; Puerto Rico");
                                        TimeZones.add("GMT-02:00=-120=Mid-Atlantic");
                                        TimeZones.add("GMT-01:00=-60=Azores, Cape Verde Is.");
                                        TimeZones.add("GMT+00:00=0=Greenwich Mean Time");
                                        TimeZones.add("GMT+01:00=60=Amsterdam; Berlin; Bern; Rome; Stockholm; Vienna");
                                        TimeZones.add("GMT+02:00=120=Athens; Istanbul; Minsk; Jerusalem");
                                        TimeZones.add("GMT+03:00=180=Baghdad; Kuwait");
                                        TimeZones.add("GMT+03:30=210=Tehran, Iran");
                                        TimeZones.add("GMT+04:00=240=Abu Dhabi; Muscat; Moscow");
                                        TimeZones.add("GMT+04:30=270=Kabul, Afghanistan");
                                        TimeZones.add("GMT+05:00=300=Ekaterinburg");
                                        TimeZones.add("GMT+05:30=330=India; Bombay; Calcutta; New Delhi; Sri Lanka");
                                        TimeZones.add("GMT+05:45=345=Kathmandu, Nepal");
                                        TimeZones.add("GMT+06:00=360=Astana; Dhaka");
                                        TimeZones.add("GMT+06:30=390=Cocos Islands; Yangon; Myanmar");
                                        TimeZones.add("GMT+07:00=420=Bangkok; Hanoi");
                                        TimeZones.add("GMT+08:00=480=Perth; Singapore; China");
                                        TimeZones.add("GMT+08:45=525=South Australia");
                                        TimeZones.add("GMT+09:00=540=Osaka; Tokyo; Seoul");
                                        TimeZones.add("GMT+09:30=570=Northern Australia");
                                        TimeZones.add("GMT+10:00=600=Brisbane; Canberra; Sydney; Guam");
                                        TimeZones.add("GMT+11:00=660=Magadan; Solomon Is.; New Caledonia");
                                        TimeZones.add("GMT+11:30=690=New Zealand?; Norfold Island, Australia");
                                        TimeZones.add("GMT+12:00=720=Auckland; Wellington; Fiji; Marshall Is.; Tuvalu");
                                        TimeZones.add("GMT+12:45=765=Chatham Island, New Zealand");
                                        TimeZones.add("GMT+13:00=780=Nukulalofa; Phoenix Islands=1 hour EAST of the dateline");
                                        TimeZones.add("GMT+14:00=840=Line Islands; Christmas Islands=2 hours EAST of the dateline");
//
//                                        ArrayList<String> TimeZones=new ArrayList<String>();
//                                        TimeZones.add("UTC -12:00=-720=Eniwelok, Kwajalein");
//                                        TimeZones.add("UTC -11:00=-660=Midway Island, Samoa");
//                                        TimeZones.add("UTC -10:30=-630=Cook Islands");
//                                        TimeZones.add("UTC -10:00=-600=Hawaii; Western Aleutian Islands=was Alaska/Hawaii timezone");
//                                        TimeZones.add("UTC -09:30=-570=Marquesas Islands");
//                                        TimeZones.add("UTC -09:00=-540=Alaska; Eastern Aleutian Islands=was Yukon timezone");
//                                        TimeZones.add("UTC -08:30=-510=Pitcairn Island");
//                                        TimeZones.add("UTC -08:00=-480=Pacific Time (US & Canada); Yukon; Tijuana");
//                                        TimeZones.add("UTC -07:00=-420=Mountain Time (US & Canada)");
//                                        TimeZones.add("UTC -06:00=-360=Central Time (US & Canada); Mexico City, Tegucigalpa");
//                                        TimeZones.add("UTC -05:00=-300=Eastern Time (US & Canada); Bogota; Lima; Quito");
//                                        TimeZones.add("UTC -04:30=-270=Caracas");
//                                        TimeZones.add("UTC -04:00=-240=Atlantic Time (Canada); Caracas, La Paz; Santiago");
//                                        TimeZones.add("UTC -03:45=-225=Guyana, South America");
//                                        TimeZones.add("UTC -03:30=-210=Newfoundland; Suriname, South America");
//                                        TimeZones.add("UTC -03:00=-180=Greenland; Brasilia; Buernos Aires; Puerto Rico");
//                                        TimeZones.add("UTC -02:00=-120=Mid-Atlantic");
//                                        TimeZones.add("UTC -01:00=-60=Azores, Cape Verde Is.");
//                                        TimeZones.add("UTC +00:00=0=Greenwich Mean Time");
//                                        TimeZones.add("UTC +01:00=60=Amsterdam; Berlin; Bern; Rome; Stockholm; Vienna");
//                                        TimeZones.add("UTC +02:00=120=Athens; Istanbul; Minsk; Jerusalem");
//                                        TimeZones.add("UTC +03:00=180=Baghdad; Kuwait");
//                                        TimeZones.add("UTC +03:30=210=Tehran, Iran");
//                                        TimeZones.add("UTC +04:00=240=Abu Dhabi; Muscat; Moscow");
//                                        TimeZones.add("UTC +04:30=270=Kabul, Afghanistan");
//                                        TimeZones.add("UTC +05:00=300=Ekaterinburg");
//                                        TimeZones.add("UTC +05:30=330=India; Bombay; Calcutta; New Delhi; Sri Lanka");
//                                        TimeZones.add("UTC +05:45=345=Kathmandu, Nepal");
//                                        TimeZones.add("UTC +06:00=360=Astana; Dhaka");
//                                        TimeZones.add("UTC +06:30=390=Cocos Islands; Yangon; Myanmar");
//                                        TimeZones.add("UTC +07:00=420=Bangkok; Hanoi");
//                                        TimeZones.add("UTC +08:00=480=Perth; Singapore; China");
//                                        TimeZones.add("UTC +08:45=525=South Australia");
//                                        TimeZones.add("UTC +09:00=540=Osaka; Tokyo; Seoul");
//                                        TimeZones.add("UTC +09:30=570=Northern Australia");
//                                        TimeZones.add("UTC +10:00=600=Brisbane; Canberra; Sydney; Guam");
//                                        TimeZones.add("UTC +11:00=660=Magadan; Solomon Is.; New Caledonia");
//                                        TimeZones.add("UTC +11:30=690=New Zealand?; Norfold Island, Australia");
//                                        TimeZones.add("UTC +12:00=720=Auckland; Wellington; Fiji; Marshall Is.; Tuvalu");
//                                        TimeZones.add("UTC +12:45=765=Chatham Island, New Zealand");
//                                        TimeZones.add("UTC +13:00=780=Nukulalofa; Phoenix Islands=1 hour EAST of the dateline");
//                                        TimeZones.add("UTC +14:00=840=Line Islands; Christmas Islands=2 hours EAST of the dateline");

                                    %>
                                    <select name="timezone" id="timezone">
                                        <%
                                        for (int i=0; i<TimeZones.size(); i++){
                                        	String tz = TimeZones.get(i);
                                        	String[] arr = null;
                                        	if(tz==""){
                                        		arr = new String[]{"","",""};
                                        	}else{
                                        		arr = tz.split("=");
                                        	}
                                        %>
                                        <option value="<%=arr[0]%>" <%=(timezone.equals(arr[0])?"selected":"")%>><%=arr[0] + " " + arr[2]%></option>
                                        <%}%>
                                    </select>
                                </div>

                                <div class="field">
                                    <label for="logo">Upload logo</label>
                                    <input id="logo" name="logo" type="file">
                                </div>


                                <div class="field">
                                    <label>Logo</label>
                                    <IMG height="50"  <% String image; String alt;
                                    if (loc!=null && loc.getLogo()!=null && loc.getLogo().length()!=0){
                                        image = "./ShowLocLogo.do?id="+String.valueOf(loc.getId());
                                        alt = String.valueOf(loc.getName());
                                    }else {
                                        image = "../images/noimage.jpg";
                                        alt = "No Photo";
                                    }%>
                                    src= "<%=image%>" alt="<%=alt%>">
                                </div>
                                <%--<div class="field">--%>
                                    <%--<label for="taxes">Taxes (0.00)</label>--%>
                                    <%--<input id="taxes" name="taxes" type="hidden" maxlength="5" value="0">--%>
                                <%--</div>--%>

                                <div class="field">
                                    <label>Business hours:</label>
                                    &nbsp;
                                </div>

                                <div>
                                    <div class="field"><label>Working from</label></div>
                                    <table align="left">
                                        <tr>
                                            <td style="text-align: center;">
                                                Monday
                                            </td>
                                            <td style="text-align: center;">
                                                Tuesday
                                            </td>
                                            <td style="text-align: center;">Wednesday</td>
                                            <td style="text-align: center;">
                                                Thursday
                                            </td>
                                            <td style="text-align: center;">
                                                Friday
                                            </td>
                                            <td style="text-align: center;">
                                               Saturday
                                            </td>
                                            <td style="text-align: center;">
                                                Sunday
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="STYLE7">
                                                <select name="fmon" class="ctrl" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(0) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==1 && ((wtemp.getH_from().getHours())*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td class="STYLE7">
                                                <select name="ftue" class="ctrl" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(1) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==2 && ((wtemp.getH_from().getHours())*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td class="STYLE7">
                                                <select name="fwen" class="ctrl" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(2) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==3 && ((wtemp.getH_from().getHours())*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td class="STYLE7">
                                                <select name="fthu" class="ctrl" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(3) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==4 && ((wtemp.getH_from().getHours())*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td class="STYLE7">
                                                <select name="ffri" class="ctrl" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(4) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==5 && ((wtemp.getH_from().getHours())*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td class="STYLE7">
                                               <select name="fsat" class="ctrl" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(5) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==6 && ((wtemp.getH_from().getHours())*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td class="STYLE7">
                                                <select name="fsun" class="ctrl" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(6) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==7 && ((wtemp.getH_from().getHours())*4+wtemp.getH_from().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                     &nbsp;
                                </div>

                                <div>
                                    <br><br>
                                    <div class="field"><label>Working to</label></div>
                                    <table align="left">
                                        <tr>
                                            <td>
                                                <select name="tmon" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(0) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==1 && ((wtemp.getH_to().getHours())*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="ttue" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(1) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==2 && ((wtemp.getH_to().getHours())*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="twen" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(2) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==3 && ((wtemp.getH_to().getHours())*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="tthu" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(3) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==4 && ((wtemp.getH_to().getHours())*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="tfri" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(4) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==5 && ((wtemp.getH_to().getHours())*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td>
                                               <select name="tsat" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(5) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==6 && ((wtemp.getH_to().getHours())*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="tsun" style="WIDTH:70px">
                                                <%for(int i=0; i<work_time.size(); i++){
                                                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(6) : new WorkingtimeLoc());
                                                    %>
                                                    <option value="<%=work_time.get(i)%>"  <%=(wtemp.getDay()==7 && ((wtemp.getH_to().getHours())*4+wtemp.getH_to().getMinutes()/15)==i?"selected":"")%>><%=work_time.get(i)%></option>
                                                <%}%>
                                                </select>
                                            </td>
                                         </tr>
                                    </table>
                                    &nbsp;
                                </div>
                                <div>
                                <div class="field">
                                    <br>
                                    <label>Comments</label>
                                </div>
                                    <table align="left">
                                        <tr>
                                            <td>
                                                <input type="text" name="cmon" style="WIDTH:60px" value="<%= ((wtime != null)&& (wtime.size() != 0)? ((WorkingtimeLoc)wtime.get(0)).getComment() == null ? "" : ((WorkingtimeLoc)wtime.get(0)).getComment() : "") %>">
                                            </td>
                                            <td>
                                                <input type="text" name="ctue" style="WIDTH:60px" value="<%= ((wtime != null)&& (wtime.size() != 0)? ((WorkingtimeLoc)wtime.get(1)).getComment() == null ? "" : ((WorkingtimeLoc)wtime.get(1)).getComment() : "") %>">
                                            </td>
                                            <td>
                                                <input type="text" name="cwen" style="WIDTH:60px" value="<%= ((wtime != null)&& (wtime.size() != 0)? ((WorkingtimeLoc)wtime.get(2)).getComment() == null ? "" : ((WorkingtimeLoc)wtime.get(2)).getComment() : "") %>">
                                            </td>
                                            <td>
                                                <input type="text" name="cthu" style="WIDTH:60px" value="<%= ((wtime != null)&& (wtime.size() != 0)? ((WorkingtimeLoc)wtime.get(3)).getComment() == null ? "" : ((WorkingtimeLoc)wtime.get(3)).getComment() : "") %>">
                                            </td>
                                            <td>
                                                <input type="text" name="cfri" style="WIDTH:60px" value="<%= ((wtime != null)&& (wtime.size() != 0)? ((WorkingtimeLoc)wtime.get(4)).getComment() == null ? "" : ((WorkingtimeLoc)wtime.get(4)).getComment() : "") %>">
                                            </td>
                                            <td>
                                                <input type="text" name="csat" style="WIDTH:60px" value="<%= ((wtime != null)&& (wtime.size() != 0)? ((WorkingtimeLoc)wtime.get(5)).getComment() == null ? "" : ((WorkingtimeLoc)wtime.get(5)).getComment() : "") %>">
                                            </td>
                                            <td>
                                                <input type="text" name="csun" style="WIDTH:60px" value="<%= ((wtime != null)&& (wtime.size() != 0)? ((WorkingtimeLoc)wtime.get(6)).getComment() == null ? "" : ((WorkingtimeLoc)wtime.get(6)).getComment() : "") %>">
                                            </td>
                                         </tr>
                                    </table>
                                    <br>
                                    <br>
                                    <br>
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
                                                <%--<input name="back" type="button" class="button_small" value="back" onclick="window.location.href='./list_location.jsp'">--%>
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