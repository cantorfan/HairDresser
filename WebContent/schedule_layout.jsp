<%@ page import="org.xu.swan.bean.Employee" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.Service" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.Time" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="org.xu.swan.bean.Appointment" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String dt = StringUtils.defaultString(request.getParameter("dt"), "");
    Matcher lMatcher = Pattern.compile("\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}", Pattern.CASE_INSENSITIVE).matcher(dt);
    if (lMatcher.matches()) {
        dt = dt.trim().replace('-', '/').replaceAll("/0", "/");
    } else {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/M/d");
        dt = sdf.format(Calendar.getInstance().getTime());
    }

    String loc = StringUtils.defaultString(request.getParameter("loc"), "1");//TODO location_id
    /*System.out.println("test3");
    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.NUMPAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if (StringUtils.isNumeric(pg)) {
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }*/
    ArrayList list_emp = Employee.findAvaiableByLoc(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), 0);//Employee.findAll(offset, ActionUtil.PAGE_ITEMS);
    ArrayList list_svc = Service.findAll();
    HashMap hm_appt = Appointment.findApptByLocDate(Integer.parseInt(loc), DateUtil.parseSqlDate(dt),0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
	<HEAD>
		<title>Schedule</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<style  type="text/css"> *{ margin-right: auto; margin-left: auto; font-size: 12px; }
        body{ background-color: #000000; margin-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; }
        .banner{ padding-top: 3px; padding-bottom: 3px; }
        .banner img{ border-top-width: medium; border-right-width: medium; border-bottom-width: medium; border-left-width: medium; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #4A4A4A; border-right-color: #6E9AAD; border-bottom-color: #4A4A4A; border-left-color: #4A4A4A; padding: 2px; }
        #mev{ color: #6E6E6E; text-transform: capitalize; font-weight: bold; font-size: 14pt; font-family: "Arial"; height: 47px; }
        .left { padding-left: 10px; padding-top: 2px; border: medium solid #000000; }
        .a{ font-weight: bold; text-transform: capitalize; color: #CB2A0F; line-height: 18px; }
        .b input{ border: 1px solid #313131; background-color: #101010; }
        .b{ font-weight: bold; text-transform: capitalize; color:#B7B7B7}
        .c{ color:#B7B7B7; font-size: 12px; }
        .d{ border-left-width: medium; border-left-style: solid; border-left-color: #000000; }
        .e { padding-right: 80px; font-weight: bold; text-transform: capitalize; color: #B7B7B7; }
        .f{ background-image: url(images/schdule_16_01.gif); background-repeat: no-repeat; }
        .g{ background-image: url(images/schdule_16_15.gif); background-repeat: repeat-x; color: #FFFFFF; font-size: 12px; border-right-width: 1px; border-right-style: solid; border-right-color: #1A1818; text-align: center; }
        #h{ left: 50px; }
        #i td{ border-right-width: 1px; border-bottom-width: 1px; border-right-style: solid; border-bottom-style: solid; border-right-color: #1A1818; border-bottom-color: #1A1818; }
        .j{ border-bottom-style: solid; border-bottom-width: medium; border-bottom-color: #31302D; }
        .r{ background-color: #333333; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-top-color: #2f2e2e; border-right-color: #2f2e2e; border-bottom-color: #2f2e2e; border-left-color: #2f2e2e; }
        .bg{ /*background-image: url(images/bg_content.gif);*/ background-repeat: no-repeat; background-position: bottom; }
        .STYLE1 { font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-style: normal; line-height: normal; font-weight: normal; text-transform: capitalize; }
        .STYLE2 { font-weight: normal; text-transform: capitalize; color: #CB2A0F; line-height: 18px; font-family: Arial, Helvetica, sans-serif; font-size: 16px; font-style: normal; }
        .STYLE4 { font-family: Arial, Helvetica, sans-serif; font-size: 9px; color: #999999; font-weight: normal; text-transform: capitalize; text-indent: 5px; text-align: left; }
        .STYLE8 { font-family: Arial, Helvetica, sans-serif; font-size: 10px; font-style: normal; font-weight: normal; }
        .STYLE15 {font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #333333; font-weight: bold; text-transform: capitalize; }
        .b1 { font-weight: bold; text-transform: capitalize; color:#B7B7B7; text-indent: 32px; }
        #Layer1 { position:absolute; left:7px; top:120px; width:180px; height:769px; z-index:1; }
        #Layer2 { position:absolute; width:200px; height:114px; z-index:2; left: 9px; top: 204px; border: 1px solid #000000; overflow: visible; }
        .STYLE9 { color: #999999; font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
        .STYLE16 { font-size: 14px; font-weight: bold; color: #999999; }
        #Layer3 { position:absolute; width:713px; height:42px; z-index:2; left: 235px; top: 710px; background-color: #000000; }
        .STYLE17 {color: #666666}
        #Layer4 { position:absolute; width:200px; height:115px; z-index:2; left: 30px; top: 325px; }
        .STYLE18 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #999999; font-weight: normal; text-transform: capitalize; text-indent: 5px; text-align: left; }
        .STYLE20 {font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #999999; font-weight: normal; text-transform: capitalize; text-indent: 5px; text-align: left; }
        .STYLE21 {background-repeat: repeat-x; color: #999999; font-size: 11px; border-right-width: 1px; border-right-style: solid; border-right-color: #1A1818; text-align: center; font-family: Arial, Helvetica, sans-serif; font-style: normal; font-weight: normal; text-transform: capitalize; font-variant: normal; }
        .STYLE23 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; font-weight: bold; text-transform: capitalize; }
        .STYLE24 { font-size: 12px; }
        </style>


        <style type="text/css">
        /*margin and padding on body element can introduce errors in determining element position and are not recommended;
          we turn them off as a foundation for YUI CSS treatments. */
        body {
            margin:0;
            padding:0;
        }
        </style>

        <link rel="stylesheet" type="text/css" href="./dragdrop/fonts-min.css" />
        <script type="text/javascript" src="./dragdrop/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="./dragdrop/dragdrop-min.js"></script>

        <!--<link rel="stylesheet" type="text/css" href="./ajax/fonts-min.css" />-->
        <script type="text/javascript" src="./ajax/yahoo-min.js"></script>
        <script type="text/javascript" src="./ajax/event-min.js"></script>
        <script type="text/javascript" src="./ajax/connection-min.js"></script>

        <!--begin custom header content for this example-->
        <style type="text/css">
        .slot { border:0px solid #aaaaaa; color:#666666; text-align:center; position: absolute; width:70px; height:17px; }
        .player { border:0px solid #bbbbbb; background-color:#552E37; color:#eeeeee; text-align:center; position: absolute; width:150px; height:20px; }
        .target { border:0px solid #574188; text-align:center; position: absolute; width:70px; height:17px; }
        .placeholder { border:0 px; position: absolute; width:1px; height:1px; }
        </style>
        <!--end custom header content for this example-->

        <link rel="stylesheet" type="text/css" media="all" href="./jscalendar/calendar-win2k-cold-1.css" title="win2k-cold-1" />
        <script type="text/javascript" src="./jscalendar/calendar.js"></script>
        <script type="text/javascript" src="./jscalendar/lang/calendar-en.js"></script>
        <script type="text/javascript" src="./jscalendar/calendar-setup.js"></script>

        <script type="text/JavaScript">
        <!--
        function MM_preloadImages() { //v3.0
          var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }

        function MM_swapImgRestore() { //v3.0
          var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
        }

        function MM_findObj(n, d) { //v4.01
          var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
          if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
          for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
          if(!x && d.getElementById) x=d.getElementById(n); return x;
        }

        function MM_swapImage() { //v3.0
          var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
           if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
        }
        //-->
        </script>
    </HEAD>

    <body onload="MM_preloadImages('images/schdule_h2.gif','images/schdule_c2.gif')"><!--class="yui-skin-sam" -->
    
    <script type="text/javascript">
        //var div = document.getElementById('container');
        var handleSuccess = function(o){
            //YAHOO.log("The success handler was called.  tId: " + o.tId + ".", "info", "example");
            if(o.responseText !== undefined){
                /*div.innerHTML = "<li>Transaction id: " + o.tId + "</li>";
                div.innerHTML += "<li>HTTP status: " + o.status + "</li>";
                div.innerHTML += "<li>Status code message: " + o.statusText + "</li>";
                div.innerHTML += "<li>HTTP headers: <ul>" + o.getAllResponseHeaders + "</ul></li>";
                div.innerHTML += "<li>Server response: " + o.responseText + "</li>";
                div.innerHTML += "<li>Argument object: Object ( [foo] => " + o.argument.foo + " [bar] => " + o.argument.bar +" )</li>";*/
                var customers = o.responseText.split(';;');
                if(customers && customers.length>0){
                    var custAttr = customers[0].split('$$');
                    if(custAttr && custAttr.length>=6){
                        var ctrl = document.getElementById('cust_id');
                        ctrl.value = custAttr[0];
                        ctrl = document.getElementById('fname');
                        if(o.argument.src != "fname")ctrl.value = custAttr[1];
                        ctrl = document.getElementById('lname');
                        if(o.argument.src != "lname")ctrl.value = custAttr[2];
                        ctrl = document.getElementById('phone');
                        if(o.argument.src != "phone")ctrl.value = custAttr[3];
                        ctrl = document.getElementById('cell');
                        if(o.argument.src != "cell")ctrl.value = custAttr[4];
                        ctrl = document.getElementById('email');
                        if(o.argument.src != "email")ctrl.value = custAttr[5];
                    }else{
                        var ctrl = document.getElementById('cust_id');
                        ctrl.value = "";
                        ctrl = document.getElementById('fname');
                        if(o.argument.src != "fname")ctrl.value = "";
                        ctrl = document.getElementById('lname');
                        if(o.argument.src != "lname")ctrl.value = "";
                        ctrl = document.getElementById('phone');
                        if(o.argument.src != "phone")ctrl.value = "";
                        ctrl = document.getElementById('cell');
                        if(o.argument.src != "cell")ctrl.value = "";
                        ctrl = document.getElementById('email');
                        if(o.argument.src != "email")ctrl.value = "";
                    }
                }
            }
        }
        var handleFailure = function(o){
            //YAHOO.log("The failure handler was called.  tId: " + o.tId + ".", "info", "example");
            if(o.responseText !== undefined){
            }
        }
       /* var callback =
        {
          success:handleSuccess,
          failure:handleFailure,
          argument: { foo:"foo", bar:"bar" }
        };*/
        //var sUrl = "assets/get.php?username=anonymous&userid=0";
        //var postData = "username=anonymous&userid=0";
        function makeRequest(id, el){
            var sUrl = "./schqry?query=contact";
            var postData = id + "=" + el.value;
            //var request = YAHOO.util.Connect.asyncRequest('GET', sUrl, callback);
            var callback =
            {
                success:handleSuccess,
                failure:handleFailure,
                argument: { src: id }
            };
            var request = YAHOO.util.Connect.asyncRequest('POST', sUrl, callback, postData);
            //YAHOO.log("Initiating request; tId: " + request.tId + ".", "info", "example");
        }
        //YAHOO.log("As you interact with this example, relevant steps in the process will be logged here.", "info", "example");
    </script>

	<!--here "Layer1" div-->
		<table width="1027" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000" height="120">
			<%--<tr valign="top">--%>
                <%--<%@ include file="top_page.jsp" %>--%>
			<%--</tr>--%>
			<tr>
				<td height="28" background="images/schdule_033.gif">&nbsp;</td>
				<td width="30" height="28" background="images/schdule_033.gif">&nbsp;</td>
				<td width="140" background="images/schdule_033.gif"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image8','','images/schdule_h2.gif',1)"><img src="images/schdule_h1.gif" name="Image8" width="126" height="30" border="0" id="Image8"></a></td>
				<td width="139" background="images/schdule_s2.gif">&nbsp;</td>
				<td width="136" background="images/schdule_033.gif"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image9','','images/schdule_c2.gif',1)"><img src="images/schdule_c1.gif" name="Image9" width="133" height="30" border="0" id="Image9"></a></td>
				<td width="339" background="images/schdule_033.gif">&nbsp;</td>
			</tr>
		</table>
		<table width="1025" border="0" cellspacing="0" cellpadding="0">
			<tr><td width="1025" bgcolor="#000000">

        <!--<div id="Layer1">-->
			<table width="218" height="610" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
				<tr>
					<td height="4"></td>
				</tr>
				<!--<tr>
				<td><table width="998" border="0" cellpadding="0" cellspacing="0">-->
						<tr><td width="18" height="606"></td>
					<td align="right" bgcolor="#000000"><table width="180" border="0" cellspacing="0" cellpadding="0" class="left">
							<tr>
								<td align="left" class="STYLE2">Schedule&nbsp;&gt;&nbsp;main</td>
							</tr>
							<!--<tr>
								<td><div class="b1">
										<div align="center">
                <span class="STYLE16">Customer<input name="customer" class="r" type="text" style="HEIGHT:8px" size="10"></span>
										<img src="./images/schdule_20.gif" alt="search"></div>
									</div>
								</td>
							</tr>-->
							<tr>
								<td align="right">
									<div align="left"><span class="STYLE15"><span class="STYLE24">select date&nbsp;&nbsp;&nbsp;&nbsp;</span></span></div>
								</td>
							</tr>
							<tr>
								<td><!--<img src="images/checkoutweb.gif" alt="30" longdesc="images/schdule2_31.gif" width="179" height="170">-->
                                    <table><tr><td>
                                        <div id="calendar-container">
                                        <script type="text/javascript">
                                        function dateChanged(calendar) {
                                        //  In order to determine if a date was clicked you can use the dateClicked property of the calendar:
                                            if (calendar.dateClicked) {
                                                // OK, a date was clicked, redirect to /yyyy/mm/dd/index.php
                                                var y = calendar.date.getFullYear();
                                                var m = calendar.date.getMonth(); // integer, 0..11
                                                var d = calendar.date.getDate(); // integer, 1..31
                                                // redirect...
                                                window.location = "./schedule.jsp?dt=" + y + "/" + (1 + m) + "/" + d;
                                            }
                                        };
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
								<td align="right">
                                    <div align="left"><span class="STYLE15"><span class="STYLE24">&nbsp;enter contact info&nbsp;&nbsp;&nbsp;&nbsp;</span></span></div> 										
								</td>
							</tr>
							<tr class="c">
								<td align="left"><table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100" height="10" class="STYLE20">First&nbsp;Name</td>
											<td class="STYLE18"><div class="b1">
												<input name="fname" id="fname" class="r" type="text" style="HEIGHT:8px" size="10" onchange="makeRequest('fname',this);">
											</div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="c">
								<td align="left"><table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100" height="10" class="STYLE20">Last&nbsp;Name</td>
											<td class="STYLE18"><div class="b1">
												<input name="lname" id="lname" class="r" type="text" style="HEIGHT:8px" size="10" onchange="makeRequest('lname',this);">
											</div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="c">
								<td align="left"><table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100" height="9" class="STYLE20">Phone</td>
											<td class="STYLE18"><div class="b1">
												<input name="phone" id="phone" type="text" class="r" style="HEIGHT:8px" size="10" onchange="makeRequest('phone',this);">
											</div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="c">
								<td align="left"><table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100" height="9" class="STYLE20">Cell&nbsp; Phone</td>
											<td class="STYLE18"><div class="b1">
												<input name="cell" id="cell" type="text" class="r" style="HEIGHT:8px" size="10" onchange="makeRequest('cell',this);">
											</div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="c">
								<td align="left"><table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100" height="9" class="STYLE20">Email</td>
											<td class="STYLE4"><div class="b1">
												<input name="email" id="email" type="text" class="r" style="HEIGHT:8px" size="10" onchange="makeRequest('email',this);">
											</div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr class="c">
								<td align="left"><table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="100" height="17" class="STYLE20">Please&nbsp;Confirm</td>
											<td align="left" class="STYLE4"><input name="cust_id" id="cust_id" type="hidden">
                                            <div class="b1" align="left"><img src="./images/schdule_25.gif" width="44" height="14" alt=""></div></td>
										</tr>
									</table>
								</td>
							</tr>

                            <tr>
								<td align="left"><table border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="179" height="20"><!--<th height="25" align="right" scope="col">-->
												<div align="left"><span class="STYLE23"> Service &nbsp;&nbsp;&nbsp;&nbsp;</span></div>
										  </td><!--</th>-->
										</tr>
										<tr>
											<td width="179" height="20"><!--<th class="STYLE4" scope="row">-->
												<table border="0" cellpadding="0" cellspacing="0">
                                                    <%
                                                        int min_svc = 10;//25;
                                                        for(int i=0; i<list_svc.size() || i<min_svc; i++){
                                                            Service svc = (i<list_svc.size()) ? (Service)list_svc.get(i) : null;
                                                            if(svc!=null){
                                                     %>
                                                    <tr>
														<td width="179" height="20"><!--<th align="right" class="STYLE20" scope="col">-->
															<%--<div align="left" id="<%="svc_" + svc.getId()%>"><%=svc.getName()%></div>--%>
                                                            <div align="left" class="placeholder" id="org_<%="svc_" + svc.getId()%>"></div><div align="left" class="player" id="svc_<%=svc.getId()%>"><%=svc.getName()%></div>
                                                      </td><!--</th>-->
													</tr>
                                                    <%}else{%>
                                                    <tr>
														<td width="179" height="20"><!--<th align="right" class="STYLE20" scope="col">-->
															<div align="left">&nbsp;</div>
													  </td><!--</th>-->
													</tr>
                                                    <%  }
                                                    }%>
                                                    <tr>
														<td align="right" class="STYLE4" scope="row"><!--<th align="right" class="STYLE4" scope="row">-->
                                                            &nbsp;</td><!--</th>-->
													</tr>
													<tr>
														<td align="right" class="STYLE4" scope="row"><!--<th height="15" class="STYLE4" scope="row">-->
                                                            &nbsp;</td><!--</th>-->
													</tr>
												</table>
										  </td><!--</th>-->
										</tr>
									</table>
								<!--</td>
							</tr>
						</table>-->
					</td>					
				</tr>
			</table>
			<!--</div>-->
                    
                    </td>
							<!--<td valign="top">&nbsp;</td>-->
							<td width="780" align="left" valign="top">
                                <table width="780" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000" bgcolor="#000000">
									<tr>
										<td height="607" valign="top" class="bg">
                                            <table width="780" height="607" border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td height="4" bgcolor="#000000"></td>
												</tr>
												<tr>
													<td height="28" align="right" valign="bottom"><div class="e"><img src="images/schdule_12.jpg" width="21" height="15" align="top"><span class="STYLE8">Print</span></div>
													</td>
												</tr>
												<tr>
													<td height="575" valign="top">
                                                        <table width="720" border="0" align="left" cellpadding="0" cellspacing="0">
															<tr>
																<td width="20"></td>
																<td width="51" height="21" background="./images/schdule_16_01.gif" class="f"><img src="./images/schdule_16_15.gif" width="51" height="23"></td>
																<td width="649" valign="top" background="./images/schdule_06.gif">
                                                                    <table width="649" border="0" cellspacing="0" cellpadding="0">
																		<tr>
                                                                            <%int min_col = 10;
                                                                            for(int i=0; i<list_emp.size() || i<min_col; i++){
                                                                                Employee emp = list_emp.size()>i? (Employee)list_emp.get(i) : null;
                                                                                if(emp != null){%>
																			<td width="70" height="23" background="./images/schdule_16_15.gif" class="STYLE21">
                                                                                <%=emp.getFname()%>&nbsp;<%=emp.getLname()%></td>
                                                                            <%}else{%>
                                                                            <td width="70" height="23" background="./images/schdule_16_15.gif" class="STYLE21">&nbsp;</td>
                                                                            <%  }
                                                                            }%>
                                                                        </tr>
																	</table>
																</td>
															</tr>

                                                            <%for(int j=2; j<10; j++){%>
                                                            <tr>
																<td width="20"></td>
																<td width="51" height="<%=(j<9) ? 70: 35 %>" background="./images/schdule_16_0<%=j%>.gif">&nbsp;</td>
																<td valign="top">
                                                                    <table width="649" border="0" cellspacing="0" cellpadding="0" id="i<%=j-1%>">
																		<tr>
                                                                            <%
                                                                            for(int i=0; i<list_emp.size() || i<min_col; i++){
                                                                                Employee emp = list_emp.size()>i? (Employee)list_emp.get(i) : null;
                                                                            %>
																			<td width="70" height="17"><%=(emp!=null) ? "<div class=\"slot\" id=emp_" + j + "_" + emp.getId() + "_a></div>" : "&nbsp;"%></td>
                                                                            <%}%>
                                                                        </tr>
																		<tr>
                                                                            <%
                                                                            for(int i=0; i<list_emp.size() || i<min_col; i++){
                                                                                Employee emp = list_emp.size()>i? (Employee)list_emp.get(i) : null;
                                                                            %>
                                                                            <td width="70" height="17"><%=(emp!=null) ? "<div class=\"slot\" id=emp_" + j + "_" + emp.getId() + "_b></div>" : "&nbsp;"%></td>
                                                                            <%}%>
                                                                        </tr>
                                                                        <%if(j<9){%>
                                                                        <tr>
                                                                            <%
                                                                            for(int i=0; i<list_emp.size() || i<min_col; i++){
                                                                                Employee emp = list_emp.size()>i? (Employee)list_emp.get(i) : null;
                                                                            %>
																			<td width="70" height="17"><%=(emp!=null) ? "<div class=\"slot\" id=emp_" + j + "_" + emp.getId() + "_c></div>" : "&nbsp;"%></td>
                                                                            <%}%>
																		</tr>
                                                                        <tr>
                                                                            <%
                                                                            for(int i=0; i<list_emp.size() || i<min_col; i++){
                                                                                Employee emp = list_emp.size()>i? (Employee)list_emp.get(i) : null;
                                                                            %>
                                                                            <td width="70" height="17"><%=(emp!=null) ? "<div class=\"slot\" id=emp_" + j + "_" + emp.getId() + "_d></div>" : "&nbsp;"%></td>
                                                                            <%}%>
																		</tr>
                                                                        <%}%>
                                                                    </table>
																</td>
															</tr>
                                                            <%}%>
                                                        </table>
													</td>
												</tr>
											</table>
									  </td>
									</tr>
								</table>
							</td>
						</tr>
			  </table>
				</td>
			</tr>
	</table>
		<table width="1024" border="0" cellspacing="0" cellpadding="0">
			<%@ include file="copyright.jsp" %>
	</table>

<script type="text/javascript">
	function edit(){
		alert("you clicked here.");
	}
</script>

<script type="text/javascript">
(function() {

YAHOO.example.DDPlayer = function(id, sGroup, config) {
    YAHOO.example.DDPlayer.superclass.constructor.apply(this, arguments);
    this.initPlayer(id, sGroup, config);
};

YAHOO.extend(YAHOO.example.DDPlayer, YAHOO.util.DDProxy, {

    TYPE: "DDPlayer",

    initPlayer: function(id, sGroup, config) {
        if (!id) {
            return;
        }

        var el = this.getDragEl()
        YAHOO.util.Dom.setStyle(el, "borderColor", "transparent");
        YAHOO.util.Dom.setStyle(el, "opacity", 0.6);

        // specify that this is not currently a drop target
        this.isTarget = false;

        this.originalStyles = [];

        this.type = YAHOO.example.DDPlayer.TYPE;
        this.slot = null;

        this.startPos = YAHOO.util.Dom.getXY( this.getEl() );
        YAHOO.log(id + " startpos: " + this.startPos, "info", "example");
    },

    startDrag: function(x, y) {
        YAHOO.log(this.id + " startDrag", "info", "example");

        /*if(!this.getEl().customer_id && document.getElementById("cust_id").value==''){
            alert("Please enter customer info firstly.");
            return;
        }*/
        var Dom = YAHOO.util.Dom;

        var dragEl = this.getDragEl();
        var clickEl = this.getEl();

        dragEl.innerHTML = clickEl.innerHTML;
        dragEl.className = clickEl.className;

        Dom.setStyle(dragEl, "color",  Dom.getStyle(clickEl, "color"));
        Dom.setStyle(dragEl, "backgroundColor", Dom.getStyle(clickEl, "backgroundColor"));

        Dom.setStyle(clickEl, "opacity", 0.5);//0.1);
    },

    getTargetDomRef: function(oDD) {
        if (oDD.player) {
            return oDD.player.getEl();
        } else {
            return oDD.getEl();
        }
    },

    endDrag: function(e) {
        // reset the linked element styles
        YAHOO.util.Dom.setStyle(this.getEl(), "opacity", 1);

		if(e.altKey || e.ctrlKey || e.shiftKey){
            remove(this);

            this.slot.player = null;
			this.getEl().parentNode.removeChild(this.getEl());
		}

        this.resetTargets();
    },

    resetTargets: function() {

        // reset the target styles
        var targets = YAHOO.util.DDM.getRelated(this, true);
        for (var i=0; i<targets.length; i++) {
            var targetEl = this.getTargetDomRef(targets[i]);
            var oldStyle = this.originalStyles[targetEl.id];
            if (oldStyle) {
                targetEl.className = oldStyle;
            }
        }
    },

    onDragDrop: function(e, id) {
        if(!this.getEl().customer_id && document.getElementById("cust_id").value==''){
            alert("Please enter customer info firstly.");
            return;
        }

        // get the drag and drop object that was targeted
        var oDD;
        if ("string" == typeof id) {
            oDD = YAHOO.util.DDM.getDDById(id);
        } else {
            oDD = YAHOO.util.DDM.getBestMatch(id);
        }

        var el = this.getEl();
        // check if the slot has a player in it already
        if (oDD.player) {
            // check if the dragged player was already in a slot
            if (this.slot) {
                // check to see if the player that is already in the slot can go to the slot the dragged player is in
                // YAHOO.util.DDM.isLegalTarget is a new method
                if ( YAHOO.util.DDM.isLegalTarget(oDD.player, this.slot) ) {//TODO move exists one to non-empty slot, swap them
                    YAHOO.log("swapping player positions", "info", "example");
                    YAHOO.util.DDM.moveToEl(oDD.player.getEl(), el);
                    this.slot.player = oDD.player;
                    oDD.player.slot = this.slot;

                    update(this, oDD);
                    update(oDD.player, this.slot);
                } else {//TODO  move exists one to non-empty slot, but be not legal
                    YAHOO.log("moving player in slot back to start", "info", "example");
                    YAHOO.util.Dom.setXY(oDD.player.getEl(), oDD.player.startPos);
                    this.slot.player = null;
                    oDD.player.slot = null
                }
            } else {//TODO move new one to non-empty slot
                // the player in the slot will be moved to the dragged players start position
                //oDD.player.slot = null;
                //YAHOO.util.DDM.moveToEl(oDD.player.getEl(), el);

                remove(oDD.player);
                
                oDD.player.getEl().parentNode.removeChild(oDD.player.getEl());
				oDD.player.slot = null;
				oDD.player = null;

				var divPl = createPlayer(el);

                el.style.width = "70px";
                el.style.height = "17px";
                this.resizeFrame = true;

                insert(divPl, el, oDD);
            }
        } else {
            // Move the player into the emply slot
            // I may be moving off a slot so I need to clear the player ref
            if (this.slot) {//TODO move exists one to another empty slot
                this.slot.player = null;

                update(this, oDD);
            }
			else{//TODO move new one to an empty slot
				var divPl = createPlayer(el);
                
                el.style.width = "70px";
                el.style.height = "17px";
                this.resizeFrame = true;

                insert(divPl, el, oDD);
            }
        }

        YAHOO.util.DDM.moveToEl(el, oDD.getEl());
        this.resetTargets();
        this.slot = oDD;
        this.slot.player = this;
    },

    swap: function(el1, el2) {
        var Dom = YAHOO.util.Dom;
        var pos1 = Dom.getXY(el1);
        var pos2 = Dom.getXY(el2);
        Dom.setXY(el1, pos2);
        Dom.setXY(el2, pos1);
    },

    onDragOver: function(e, id) {
    },

    onDrag: function(e, id) {
    }
});

function createPlayer(el){
    if(el==null)
        return null;

    var Dom = YAHOO.util.Dom;
    var divEl = document.createElement("div");
    Dom.generateId(divEl);
    divEl.originalId = el.originalId;
    divEl.innerHTML = el.innerHTML;
    divEl.className = el.className;
    divEl.style.color = el.color;
    divEl.style.backgroundColor = el.backgroundColor;
    divEl.style.position = "absolute";
    var p = document.getElementById("org_" + el.originalId);
    Dom.setXY(divEl, p.originalPos);
    p.parentNode.insertBefore(divEl,p); //p.appendChild(divEl);
    var divPl = new YAHOO.example.DDPlayer(divEl.id, "slots");
    divPl.getEl().onclick = edit;
    //el.style.width = "70px";
    //el.style.height = "17px";
    //this.resizeFrame = true;
    return divPl;
};

function insert(player, el, oDD){
    try{
        var v = player.getEl();
        v.service_id = el.originalId.substr("svc_".length);
        v.customer_id = document.getElementById("cust_id").value;
        var dest_id = oDD.getEl().id;
        dest = dest_id.split("_");
        v.employee_id = dest[2];
        v.appt_dt = '<%=dt%>';
        var hr = parseInt(dest[1]);
        hr = hr*2 + 4;
        if(dest[3]=='c' || dest[3]=='d')
            hr += 1;
        var min = "00";
        if(dest[3]=='b' || dest[3]=='d')
            min = "30";
        v.start_time = hr + ':' +min + ":00";
        if(min=='30')
            v.end_time = (hr+1) + ':00:00';
        else
            v.end_time = hr + ':30:00';
        var nv = "svc=" + v.service_id + "&cust=" + v.customer_id + "&emp=" + v.employee_id
                + "&dt=" + v.appt_dt + "&st=" + v.start_time + "&et=" + v.end_time;
        var cb =
        {
            success:onSuccess = function(o){
                if(o.responseText !== undefined){
                    var ctrl = document.getElementById(o.argument.ctrl);
                    if(ctrl && o.responseText.match(/^new=\d*$/))
                        ctrl.appt_id = o.responseText.substring("new=".length);
                    if(!ctrl.appt_id) alert("Create data error.");
                }
            },
            failure:onFailure = function(o){
                 alert("Create operation failed.");
            },
            argument: { ctrl: v.id }
        };
        YAHOO.util.Connect.asyncRequest('POST', './schqry?query=appoint&action=new', cb, nv);
    }catch(e){
        alert("Create error.");
    }
};

function update(player, oDD){
    try{
        var v = player.getEl();
        var dest_id = oDD.getEl().id;
        dest = dest_id.split("_");
        v.employee_id = dest[2];
        v.appt_dt = '<%=dt%>';
        var hr = parseInt(dest[1]);
        hr = hr*2 + 4;
        if(dest[3]=='c' || dest[3]=='d')
            hr += 1;
        var min = "00";
        if(dest[3]=='b' || dest[3]=='d')
            min = "30";
        v.start_time = hr + ':' +min + ":00";
        if(min=='30')
            v.end_time = (hr+1) + ':00:00';
        else
            v.end_time = hr + ':30:00';
        var nv = "sch=" + v.appt_id + "&svc=" + v.service_id + "&cust=" + v.customer_id + "&emp=" + v.employee_id
                + "&dt=" + v.appt_dt + "&st=" + v.start_time + "&et=" + v.end_time;
        var cb =
        {
            success:onSuccess = function(o){
                if(o.responseText !== undefined){
                    var ctrl = document.getElementById(o.argument.ctrl);
                    if(ctrl && o.responseText.match(/^edit=\d*$/)){
                        var sch_id = o.responseText.substring("edit=".length);
                        if(sch_id != ctrl.appt_id) alert("Update data error.");
                    }
                }
            },
            failure:onFailure = function(o){
                 alert("Update operation failed.");
            },
            argument: { ctrl: v.id }
        };
        YAHOO.util.Connect.asyncRequest('POST', './schqry?query=appoint&action=edit', cb, nv);
    }catch(e){
        alert("Update error.");
    }
};

function remove(player){
    try{
        var v = player.getEl();
        var nv = "sch=" + v.appt_id;
        var cb =
        {
            success:onSuccess = function(o){
                if(o.responseText !== undefined){
                    var ctrl = document.getElementById(o.argument.ctrl);
                    if(ctrl && o.responseText.match(/^delete=\d*$/)){
                        var sch_id = o.responseText.substring("delete=".length);
                        if(sch_id != ctrl.appt_id) alert("Delete data error.");
                    }
                }
            },
            failure:onFailure = function(o){
                 alert("Delete operation failed.");
            },
            argument: { ctrl: v.id }
        };
        YAHOO.util.Connect.asyncRequest('POST', './schqry?query=appoint&action=delete', cb, nv);
    }catch(e){
        alert("Delete error.");
    }
};

var slots = [], players = [],
    Event = YAHOO.util.Event, DDM = YAHOO.util.DDM;

Event.onDOMReady(function() {
    // slots
    <%int count=0;
    for(int j=2; j<10; j++){
        for(int i=0; i<list_emp.size() || i<min_col; i++){
            Employee emp = list_emp.size()>i? (Employee)list_emp.get(i) : null;
            if(emp!=null){%>
                slots[<%=count++%>] = new YAHOO.util.DDTarget("emp_<%=j%>_<%=emp.getId()%>_a", "slots");
                slots[<%=count++%>] = new YAHOO.util.DDTarget("emp_<%=j%>_<%=emp.getId()%>_b", "slots");
                <%if(j<9){%>
                slots[<%=count++%>] = new YAHOO.util.DDTarget("emp_<%=j%>_<%=emp.getId()%>_c", "slots");
                slots[<%=count++%>] = new YAHOO.util.DDTarget("emp_<%=j%>_<%=emp.getId()%>_d", "slots");
    <%}}}}%>
    
    // players
    <%for(int i=0; i<list_svc.size(); i++){
    Service svc = (i<list_svc.size()) ? (Service)list_svc.get(i) : null;
    if(svc!=null){%>
        players[<%=i%>] = new YAHOO.example.DDPlayer("svc_<%=svc.getId()%>", "slots");
    <%}}%>

    DDM.mode = 1;

	var div1;
	for(var i=0; i<players.length; i++){
		div1 = document.getElementById(players[i].id);
		div1.originalId = div1.id;
		div1.originalPos = YAHOO.util.Dom.getXY(div1);
	}

    //init
    var pl,target,el;
    <%  for(int k=0; k<list_emp.size(); k++){
        Employee ep = (Employee)list_emp.get(k);
        ArrayList al = (ArrayList)hm_appt.get(new Integer(ep.getId()));
        for(int kk=0; al!=null && kk<al.size(); kk++){
            Appointment appt = (Appointment)al.get(kk);%>
            pl = createPlayer(document.getElementById("svc_<%=appt.getService_id()%>"));
            if(pl){
                el = pl.getEl();
                el.appt_id = <%=appt.getId()%>; 
                el.customer_id = <%=appt.getCustomer_id()%>;
                el.service_id = <%=appt.getService_id()%>;
                el.employee_id = <%=appt.getEmployee_id()%>;
                el.appt_dt = '<%=dt%>';
                el.start_time = '<%=appt.getSt_time()%>';
                el.end_time = '<%=appt.getEt_time()%>';
            }
            target = YAHOO.util.DDM.getDDById('<%=retrieveDDId(appt)%>');<%--("emp_<%=2%>_<%=appt.getEmployee_id()%>_a");--%>
            if(pl && target){
                el = pl.getEl();
                YAHOO.util.DDM.moveToEl(el, target.getEl());
                el.style.width = "70px";
                el.style.height = "17px";
                pl.resizeFrame = true;
                pl.resetTargets();
                pl.slot = target;
                pl.slot.player = pl;     
            }
        <%}
    }%>
});

})();
</script>
    </body>
</HTML>
<%!
    String retrieveDDId(Appointment appt){
        String sid = "";
        if(appt == null)
            return sid;
        sid = "emp_";
        Time st = appt.getSt_time();
        int hr = DateUtil.getHour(st);
        if(hr<8) sid += 2;
        else if(hr>22) sid += 9;
        else sid += (hr-4)/2;
        sid += "_" + appt.getEmployee_id();
        int min = DateUtil.getMinute(st);
        if(hr%2==0){
            if(min<30) sid += "_a";
            else sid += "_b";
        }else{
            if(min<30) sid += "_c";
            else sid += "_d";
        }
        return sid;
    }
%>