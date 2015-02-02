<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.Writer" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    User user_ses = (User) session.getAttribute("user");
    if (user_ses == null){
        response.sendRedirect("./error.jsp?ec=1");
        return;
    }
//    else if ((user_ses.getPermission() != Role.R_ADMIN) && (user_ses.getPermission() != Role.R_RECEP) && (user_ses.getPermission() != Role.R_EMP)){
//        response.sendRedirect("../index.jsp");
//    }
    ArrayList list_emp = Employee.findAllByLoc(1);

    Location loc = null;
    String id = "1";
    String dt = StringUtils.defaultString(request.getParameter("dt"), "");
    String id_cust = StringUtils.defaultString(request.getParameter("idc"), "");
    String reshedule = StringUtils.defaultString(request.getParameter("rshd"), "0");
    String id_booking = StringUtils.defaultString(request.getParameter("idb"), "0");
    int id_customer = 0;
    Customer cust;
    if(!id_cust.equals(""))
    {
        try{
            id_customer = Integer.parseInt(id_cust);
        }catch(Exception ex)
        {

        }
    }
    cust = Customer.findById(id_customer);
//    if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        loc = Location.findById(Integer.parseInt(id));
//    else
//        loc = (Location)request.getAttribute("OBJECT");

    Calendar cal = new GregorianCalendar();
    if(!dt.equals(""))
        cal.setTime(new Date(dt));        
    else{
        cal.setTime(new Date());
        //dt = (new Date()).toString();
    }
    int week_day = 0;    
    if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
        week_day = 0;
    else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
        week_day = 1;
    else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
        week_day = 2;
    else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
        week_day = 3;
    else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
        week_day = 4;
    else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
        week_day = 5;
    else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
        week_day = 6;
    ArrayList _wtime = (loc != null ? WorkingtimeLoc.findAllByLocationId(loc.getId()) : null);
    WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
    float _from = _wtemp.getH_from().getHours();
    float _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);
    /*double _from = 24.0f;
    double _to = 0.0f;
    for(int i = 0; i < 7; i++)
    {
        WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

        double __from = wtemp.getH_from().getHours();
        _from = __from < _from ? __from : _from;

        double min = wtemp.getH_to().getMinutes() / 60.0f;
        min = min > 0 ? 1 : 0;
        double __to = wtemp.getH_to().getHours() +  min;
        _to = __to > _to ? __to : _to;
    }*/

%>
<html>
<head>
<meta http-equiv = "X-UA-Compatible" content="IE=7" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
    <title>Schedule</title>
	  
	<link rel="stylesheet" type="text/css" media="all" href="./jscalendar/calendar-hd.css" title="hd" />
	<style type="text/css" media="all">
		@import "css/hd.css";
	</style>
    <link rel="stylesheet" type="text/css" href="css/schedule1.css" media="all"/>
    <style type="text/css">@import "./css/modalbox.css";</style>
              <%
                  if (user_ses != null){
                      if(user_ses.getPermission() == Role.R_ADMIN){
                          out.print("<script>var isAdmin = 1;</script>");
                      }else{
                          out.print("<script>var isAdmin = 0;</script>");
                      }
                  }
              %>
    <script type="text/javascript" src="./plugins/jQuery v1.7.2.js"></script>
    <link rel='stylesheet' type='text/css' href='./plugins/popup/popup.css' />
    <script type="text/javascript" src="./plugins/popup/popup.js"></script>
    <script language="javascript" type="text/javascript" src="Js/sendEmail.js"></script>
    <script type="text/javascript" src="./Js/selectworker.js"></script>
    <script type="text/javascript" src="./script/schedule.js"></script>
	<script type="text/javascript" src="./jscalendar/calendar.js"></script>
	<script type="text/javascript" src="./jscalendar/lang/calendar-en.js"></script>
	<script type="text/javascript" src="./jscalendar/calendar-setup.js"></script>

    <script language="javascript" type="text/javascript" src="Js/DyveWeb.js"></script>
    <script language="javascript" type="text/javascript" src="Js/Dyve.js"></script>        
    <script language="javascript" type="text/javascript" src="Js/DyveBubble.js"></script>        
    <script language="javascript" type="text/javascript" src="Js/DyveMenu.js"></script>        
    <script language="javascript" type="text/javascript" src="Js/DyveCalendar.js"></script>

    <script language="javascript" type="text/javascript" src="Js/includes/prototype.js"></script>
    <script language="javascript" type="text/javascript" src="Js/scriptaculous/scriptaculous.js?load=builder,effects"></script>
    <script language="javascript" type="text/javascript" src="Js/includes/modalbox.js"></script>

    <script language="javascript" type="text/javascript" src="Js/CustomerControl.js" ></script>       
    <script language="javascript" type="text/javascript" src="Js/ServiceListControl.js" ></script>
    <script language="javascript" type="text/javascript" src="Js/custom-form-elements.js" ></script>
        <%
        //CashDrawing cd = CashDrawing.findByDate(Integer.parseInt(id), DateUtil.parseSqlDate(dt));
        %>
    <script type="text/javascript">  
        var _from = <%=Double.toString(_from)%>;
        var _to = <%=Double.toString(_to)%>;
        function deleteRow(id){
            if (confirm('Will be removed only Appointment. All tickets attached to this Appointment will not be removed.')){
//                win = window.open('admin/list_appointment.jsp?action=delete&id='+id+'&page=0','win', '');
//                win.close();
                          var xmlRequestService;

               try {
                  xmlRequestService = new XMLHttpRequest();
               }
               catch(e) {
                   try {
                       xmlRequestService = new ActiveXObject("Microsoft.XMLHTTP");
                   } catch(e) { }
               }

                xmlRequestService.onreadystatechange = function() {
                    if (xmlRequestService.readyState ==4 ) {
                        Modalbox.loadContent();
                    }
                };

                xmlRequestService.open("POST", 'admin/list_appointment.jsp?action=delete&id='+id+'&page=0');
                xmlRequestService.setRequestHeader("Accept-Encoding","text/html; charset=utf-8");
                xmlRequestService.send('');
                <%--Modalbox.show('history.jsp?id=' + <%=id%> + '&rnd=' + Math.random() * 99999, {width: 1000});--%>
            }
        }
    </script>
    <script language="javascript" type="text/javascript">
        var isChoice = 0;
        function callYes(){
            if (document.getElementById("win2.delete").checked){
                isChoice = 7;
            }
            else if (document.getElementById("win2.noshow").checked){
                isChoice = 6;
            }else if (document.getElementById("win2.canceled").checked){
                isChoice = 8;
            }
            var e=document.getElementById("event").value;
            mainCalendar.eventDeleteCustom(e);
            hide_bar2();
        }

        function clear_data() {
            document.getElementById('cust_id').value = '';
            clear_data1();
        }

        function clear_data1() {
            document.getElementById('txtFN').value = '';
	        document.getElementById('txtLN').value = '';
	        document.getElementById('txtPh').value = '1-()';
	        document.getElementById('txtCPh').value = '1-()';
	        document.getElementById('txtEm').value = '';
            //document.getElementById('txtR').checked = false;
            checkCheckbox('txtR', false);
            document.getElementById('txtEmp').value = '0';
            document.getElementById('com').value = '';
            document.getElementById('custcom').value = '';
            //document.getElementById('txtRm').checked = false;
            checkCheckbox('txtRm', false);
            document.getElementById('txtRmDays').value = '';
        }

        function hide_bar() {
            document.getElementById("win").style.visibility="hidden";
            clear_data();
        }

        function hide_bar1() {
             document.getElementById("win1").style.visibility="hidden";
             document.getElementById('w_from').value = 0;
             document.getElementById('w_to').value = 0;
             document.getElementById('wt_com').value = '';
        }

        function hide_bar2() {
             document.getElementById("win2").style.visibility="hidden";
        }

        function hide_bar5() {
            document.getElementById("win5").style.visibility="hidden";
            document.getElementById('editcomment').value = '';
        }

</script>

<%
    java.util.List work_time = new ArrayList();
    for(double i = _from; i <= _to; i+=0.25){
        int h = (int)i;
        int m = (int)((i - h)*60);
        String s = (h < 10 ? "0" : "") + Integer.toString(h) + ":" +
                (m < 10 ? "0" : "") + Integer.toString(m) + ":00";
        work_time.add(s);
    }
        /*work_time.add("08:00:00");
        work_time.add("08:15:00");
        work_time.add("08:30:00");
        work_time.add("08:45:00");
        work_time.add("09:00:00");
        work_time.add("09:15:00");
        work_time.add("09:30:00");
        work_time.add("09:45:00");
        work_time.add("10:00:00");
        work_time.add("10:15:00");
        work_time.add("10:30:00");
        work_time.add("10:45:00");
        work_time.add("11:00:00");
        work_time.add("11:15:00");
        work_time.add("11:30:00");
        work_time.add("11:45:00");
        work_time.add("12:00:00");
        work_time.add("12:15:00");
        work_time.add("12:30:00");
        work_time.add("12:45:00");
        work_time.add("13:00:00");
        work_time.add("13:15:00");
        work_time.add("13:30:00");
        work_time.add("13:45:00");
        work_time.add("14:00:00");
        work_time.add("14:15:00");
        work_time.add("14:30:00");
        work_time.add("14:45:00");
        work_time.add("15:00:00");
        work_time.add("15:15:00");
        work_time.add("15:30:00");
        work_time.add("15:45:00");
        work_time.add("16:00:00");
        work_time.add("16:15:00");
        work_time.add("16:30:00");
        work_time.add("16:45:00");
        work_time.add("17:00:00");
        work_time.add("17:15:00");
        work_time.add("17:30:00");
        work_time.add("17:45:00");
        work_time.add("18:00:00");
        work_time.add("18:15:00");
        work_time.add("18:30:00");
        work_time.add("18:45:00");
        work_time.add("19:00:00");
        work_time.add("19:15:00");
        work_time.add("19:30:00");
        work_time.add("19:45:00");
        work_time.add("20:00:00");
        work_time.add("20:15:00");
        work_time.add("20:30:00");
        work_time.add("20:45:00");
        work_time.add("21:00:00");  */
%>
</head>
<body unselectable="on" onselectstart="return false;">
	<div class="main">
        <table width="100%">
            <%
                String activePage = "Schedule";
                String rootPath = "";
            %>
        <%--<tr valign="top">--%>
            <%--<td colspan="3">--%>
                <%--<iframe src="http://rcm.amazon.com/e/cm?t=sdqnyc-20&o=1&p=48&l=ur1&category=beauty&banner=0Q2M96KTPZ1JX0G12SR2&f=ifr" width="728" height="90" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>--%>
            <%--</td>--%>
        <%--</tr>--%>
        <tr valign="top">
            <%@ include file="top_page.jsp" %>
        </tr>
		</table>
         <%@ include file="menu_main.jsp" %>
        <%--<div style = "text-align: right;"><a style="color: white;" href = "./index.jsp"> Sign Out</a> </div>--%>
		<div class="container">
			<div class="left">
                <input id="reshedule" name="reshedule" type="hidden" value="<%=reshedule%>">
                <input id="id_booking" name="id_booking" type="hidden" value="<%=id_booking%>">
                <%--<div id="InfoDiv" style="text-align:center">--%>
                    <%--<br  />--%>
                    <%--<%--%>
                        <%--String l;--%>
                        <%--if(loc!=null){--%>
                            <%--l = loc.getAddress();--%>
                            <%--if (!l.equals("")){--%>
                                <%--String end = l.substring(l.lastIndexOf(" "));--%>
                            <%--String begin = l.substring(1, l.lastIndexOf(" "));--%>
                            <%--out.print("<img src='image?t=" + response.encodeURL(begin) + "&fs=11&c=FFFFFF' />");--%>
                            <%--out.print("<br /><b>");--%>
                            <%--out.print("<img src='image?t=" + response.encodeURL(end) + "&fs=12&c=FFFFFF' />");--%>
                            <%--out.print("</b>");--%>
                            <%--}--%>
                        <%--}--%>

                    <%--%><br  />--%>
                    <%--<br  />--%>
                    <%--<div>Address</div>--%>
                    <%--<textarea disabled rows="4" cols="23"><%=(loc!=null?loc.getAddress():"")%></textarea>--%>
                    <%--<div>Business Hours</div>--%>
                    <%--<textarea disabled rows="7" cols="23"><%=(loc!=null&loc.getBusinesshours()!=null?loc.getBusinesshours():"")%></textarea>--%>
                <%--</div>--%>
                <style>
                    hr {
                        margin: 4px 0px;
                        width: 99%;
                        color: #FFF;
                    }
                </style>				
                <%--<hr style="margin-top: 0;" />--%>
				<div id="CalendarContainer"></div>
				<hr />
                <div id="service_id_0" title="break" unselectable="on" style="-moz-user-select: none;" align=center>
                    <div id="content_service_id_0" class="name" unselectable="on" style="width:93px; height: 29px; background: transparent url(img/break_button.png) no-repeat; -moz-user-select: none;">
                        <span style="visibility: hidden;">break</span>
                    </div>
                    <div class="cost" unselectable="on" style="-moz-user-select: none;" id="content_service_id_0">
                    <div style="background: transparent url(image?t=&amp;fs=12&amp;c=FFFFFF) no-repeat scroll 0px 4px; float: right; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 25px;" id="content_service_id_0">
                        <span style="visibility: hidden;"></span>
                    </div>
                    <div style="background: transparent url(image?t=&amp;fs=10&amp;c=FFFFFF) no-repeat scroll 4px 0px; float: right; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 10px;" id="content_service_id_0">
                        <span style="visibility: hidden;"></span>
                    </div>
                    </div>
                </div>
                <!--div id="ServiceControl" style="position: relative;"></div>
				<div id="ServiceControlClone" style="display:block;"></div-->
				<hr />
				<div id="CustomerContainer"></div>
				<hr />
                <div>
                    <!--table>
                <tr/> <tr/>
				<tr>
					<td align="left" width="40" bgcolor="#66FF33"></td>
                    <td align="left" style="font-family: Tahoma; font-size: 8pt;">Customer Checked In</td>
                </tr>
				<tr>
					<td align="left" width="40" bgcolor="#F67A7A"></td>
					<td align="left" style="font-family: Tahoma; font-size: 8pt;">Cancelled by customer</td>
				</tr>
				<tr>
					<td align="left" width="40" bgcolor="#F7F962"></td>
					<td align="left" style="font-family: Tahoma; font-size: 8pt;">Customer is late</td>
				</tr>
				<tr>
					<td height="15">
                       <table cellspacing="0" cellpadding="0" width="100%" height="100%">
                           <tr>
                               <td align="left" height="100%" width="5" bgcolor="#FF0000"></td>
                               <td align="left" height="100%" width="35" bgcolor="#FFFFFF"></td>
                           </tr>
                       </table>
                    </td>
				    <td align="left" style="font-family: Tahoma; font-size: 8pt;">Appointment with comment</td>
				</tr>
				<tr>
					<td align="left" style="font-family: Tahoma; font-size: 8pt; color: #ea2e44;"><b>Text</b></td>
					<td align="left" style="font-family: Tahoma; font-size: 8pt;">Appointment with request</td>
				</tr>
               <tr/> <tr/>
			</table-->
                    <img src="img/legend.png"/>
                </div>
			</div>

			<div class="center" style="overflow: hidden; position: relative; height: 1500px;" align="center">
				<div style="width:100%;" id="dyveDivScroll">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
			            <tr>
			                <td class="content" valign="top">
			                    <div id="mainCalendar" style="width: 100%; position: relative; line-height: 1;">		                        		                       
			                        <div style="border-left: 1px solid rgb(0, 0, 0); border-right: 1px solid rgb(0, 0, 0);">
			                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
			                                <tr id="schedule_header_control">
                                              <td id="left_arrow_control"><a id="prev" href="#" onclick="MovePrev();"><img src="img/schedule_left_arrow.png" border="0"/></a></td>                                                        
			                                    <td style="background-color: rgb(236, 233, 216);" valign="top" width="100%">
			                                        <div style="position: relative; height: 1px; line-height: 1px; display: block; font-size: 1px; background-color: rgb(0, 0, 0);" ><!-- --></div>
			                                        <table id="mainCalendar_header" style="border-left: 1px solid rgb(0, 0, 0);border-right: 1px solid rgb(0, 0, 0);" border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td></td></tr></table>
			                                    </td>
                                                <td id="right_arrow_control"><a id="next" href="#" onclick="MoveNext();"><img src="img/schedule_right_arrow.png" border="0"/></a></td>
	<!-- 		                                <td><div id="right" class="header" unselectable="on" style="border-top: 1px solid rgb(0, 0, 0); background-color: rgb(236, 233, 216); width: 45px; height: 20px; -moz-user-select: none;"></div></td>  -->
			                                </tr>
                                            <tr id="schedule_comments_control">
                                                <td class="header_left">
                                                    <img src="img/comments_text.png" alt=""/>
                                                </td>
                                                <td>
                                                    <table id="mainCalendar_header_bottom_comment" style="border-left: 1px solid rgb(0, 0, 0);border-right: 1px solid rgb(0, 0, 0);" border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td></td></tr></table>                                                    
                                                </td>
                                                <td class="header_right">
                                                     <img src="img/comments_text.png" alt=""/>
                                                </td>
                                            </tr>
			                            </table>
			                        </div>                                               
			                        
	<!-- 	                        <div id="mainCalendar_scroll" style="border: 1px solid rgb(0, 0, 0); overflow: auto; height: 500px; position: relative; background-color: rgb(236, 233, 216);">
									<div id="mainCalendar_scroll" style="border: 1px solid rgb(0, 0, 0); overflow: hidden; position: relative; background-color: rgb(236, 233, 216);">
	-->

	 		                        <div id="mainCalendar_scroll" style="border: 1px solid rgb(0, 0, 0); overflow: none; position: relative; background-color: rgb(236, 233, 216);">
			                            <div style="padding: 2px; position: absolute; background-color: orange; color: white; font-size: 10px; font-family: Tahoma; display: none;">&nbsp;</div>
			                            <table style="" border="0" cellpadding="0" cellspacing="0">
			                                <tr>
			                                    <td valign="top" style="background: url(img/time_column/background.png);">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="45">
                                                    <tr>
                                                        <td class="time_column">
                                                        <div id="time_column_left"></div>
                                                        <!--
                                                        <%
                                                            double _i = _from;
                                                            if((int)_i < _i) // 10 or 10.5 :)
                                                                out.print("<div class=time_row_first><img alt=\""+Double.toString(_i)+"\" src=\"img/time_column/"+Double.toString(_i)+".png\" /></div>");
                                                            else
                                                                out.print("<div class=time_row_first><img alt=\""+Integer.toString((int)_i)+"\" src=\"img/time_column/"+Integer.toString((int)_i)+".png\" /></div>");
                                                            for(double i = _from + 0.5; i < _to; i += 0.5){                                                 // for esalonsoft/vogue
                                                                if((int)i < i) // 10 or 10.5 :)
                                                                    out.print("<div class=time_row><img alt=\""+Double.toString(i)+"\" src=\"img/time_column/"+Double.toString(i)+".png\" /></div>");
                                                                else
                                                                    out.print("<div class=time_row><img alt=\""+Integer.toString((int)i)+"\" src=\"img/time_column/"+Integer.toString((int)i)+".png\" /></div>");
                                                            }
                                                        %>-->
                                                        </td></tr>
                                                    </table>
			                                    </td>

			                                    <td valign="top" width="100%">
				                                        <table id="mainCalendar_main" style="border-left: 1px solid rgb(0, 0, 0);" border="0" cellpadding="0" cellspacing="0" width="100%">
				                                            <tr id="mainCalendar_events" style="background-color: white;">
				                                                <!-- Events -->
				                                                    <td dpcolumn="" dpcolumndate="August 24, 2008 00:00:00 +0000" style="height: 1px; text-align: left; width: 14%;">

				                                                    </td>
				                                                <!-- End Events -->
				                                            </tr>
				                                        </table>
			                                    </td>

                                                <td valign="top" style="border-left: 1px solid #000; background: url(img/time_column/background.png);">
                                                     <table border="0" cellpadding="0" cellspacing="0" width="45">
                                                     <tr>
                                                         <td class="time_column">
                                                            <div id="time_column_right"></div>
                                                             <!--<%
//                                                            out.print("<div class=time_row_first><img src=\"img/time_column/9.png\" /></div>");
//                                                            for(double i = 9.5; i<20; i += 0.5){
                                                                 _i = _from;
                                                                 if((int)_i < _i) // 10 or 10.5 :)
                                                                     out.print("<div class=time_row_first><img alt=\""+Double.toString(_i)+"\" src=\"img/time_column/"+Double.toString(_i)+".png\" /></div>");
                                                                 else
                                                                     out.print("<div class=time_row_first><img alt=\""+Integer.toString((int)_i)+"\" src=\"img/time_column/"+Integer.toString((int)_i)+".png\" /></div>");
                                                                 for(double i = _from + 0.5; i < _to; i += 0.5){                                                 // for esalonsoft/vogue
                                                                     if((int)i < i) // 10 or 10.5 :)
                                                                         out.print("<div class=time_row><img alt=\""+Double.toString(i)+"\" src=\"img/time_column/"+Double.toString(i)+".png\" /></div>");
                                                                     else
                                                                         out.print("<div class=time_row><img alt=\""+Integer.toString((int)i)+"\" src=\"img/time_column/"+Integer.toString((int)i)+".png\" /></div>");
                                                                 }
                                                             %>-->
                                                         </td></tr>
                                                     </table>
			                                    </td>
			                                </tr>
			                            </table>
			                        </div>

   			                        <%--<div style="border-left: 1px solid rgb(0, 0, 0); border-right: 1px solid rgb(0, 0, 0);">--%>
			                            <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">--%>
			                                <%--<tr>--%>
			                                    <%--<td>--%>
                                                    <%--<div class="header" unselectable="on" id="left2"
                                                    style="border-top: 1px solid rgb(0, 0, 0); background-color:
                                                    rgb(236, 233, 216); width: 45px; height: 40px; -moz-user-select:
                                                    none;"><div style="padding: 2px; text-align: center; font-weight:
                                                    bold;"><a id="prev" href="#" onclick="MovePrev();"><img src="images/LEFTAR.jpg" width="40" height="40" border="0" alt="" class="banner" /></a><!--&nbsp--></div></div></td>--%>

			                                    <%--<td style="background-color: rgb(236, 233, 216);" valign="top" width="100%">--%>
			                                        <%--<div style="position: relative; height: 1px; line-height: 1px; display: block; font-size: 1px; background-color: rgb(0, 0, 0);" ><!-- --></div>--%>
			                                        <%--<!--table id="mainCalendar_header_bottom" style="border-left: 1px solid rgb(0, 0, 0);border-right: 1px solid rgb(0, 0, 0);" border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td></td></tr></table-->--%>
                                                    <%--<!--div id="mainCalendar_header_bottom"></div-->--%>
			                                    <%--</td>--%>
                                                <%--<td>--%>
                                                    <%--<div class="header" unselectable="on" id="right2"--%>
                                                         <%--style="border-top: 1px solid rgb(0, 0, 0);--%>
                                                         <%--background-color: rgb(236, 233, 216); width: 45px; height: 40px;--%>
                                                         <%---moz-user-select: none;">--%>
                                                        <%--<div style="padding: 2px; text-align: center; font-weight: bold;">--%>
                                                            <%--<a id="next" href="#" onclick="MoveNext();">--%>
                                                                <%--<img src="images/RIGHTAR.jpg" width="40" height="40" border="0" alt="" class="banner" />--%>
                                                            <%--</a><!--&nbsp-->--%>
                                                        <%--</div>--%>
                                                    <%--</div></td>--%>
				                                <%--</tr>--%>
                                            <%--<tr>--%>
                                                <%--<td><div class="header" unselectable="on" style="border-top: 1px solid rgb(0, 0, 0); background-color: rgb(0, 0, 0); width: 45px; height: 40px; -moz-user-select: none;"></div></td>--%>
                                                <%--<td style="background-color: rgb(236, 233, 216);" valign="top" width="100%">--%>
                                                    <%--<div style="position: relative; height: 1px; line-height: 1px; display: block; font-size: 1px; background-color: rgb(0, 0, 0);" ><!-- --></div>--%>
                                                <%--</td>--%>
                                                <%--<td><div class="header" unselectable="on" style="border-top: 1px solid rgb(0, 0, 0); background-color: rgb(0, 0, 0); width: 45px; height: 40px; -moz-user-select: none;"></div></td>--%>
                                            <%--</tr>--%>
			                            <%--</table>--%>
			                        <%--</div>--%>
                                    <div>
                                        <!--schedule footer-->
                                        <table cellspacing="0" cellpadding="0" width="100%" >
                                        <tr id="schedule_footer_control">
                                            <td class="footer_left"><a id="prev" href="#" onclick="MovePrev();"><img src="img/schedule_footer_left_arrow.png" border="0" /></a></td>
                                            <td>
                                                <table id="mainCalendar_header_bottom" border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td></td></tr></table>                                                
                                            </td>
                                            <td class="footer_right"><a id="next" href="#" onclick="MoveNext();"><img src="img/schedule_footer_right_arrow.png" border="0"/></a></td>
                                        </tr>
                                        </table>
                                        <!--end of schedule footer-->

                                    </div>
			                    </div>
			                </td>
			            </tr>
			        </table>		        
			        <input type="hidden" id="mainCalendar_select" name="mainCalendar_select" value="" />

			        <div id="mainCalendar_idlocation" ></div>
			        <input type="hidden" id="mainCalendar_datecurrent" value="" />
                    <input type="hidden" id="mainCalendar_pagenum" value="" />
                    <input type="hidden" id="mainCalendar_browser" value="" />
                    <div id="mainCalendar_MainMenu" style="border:1px solid #ACA899;background-color:#FFFFFF;font-size:8pt;display:none;">
				        <span style="font-weight:bold;display:block;background-color:#ECE9D8;padding:2px 20px 2px 10px;border-bottom:1px solid #ACA899;cursor:default;">Event</span>
				        <a onclick="var e = this.parentNode.event || this.parentNode.selection; var command = ''; alert('Opening event (id {0})');; return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">Open</a>
				        <a onclick="var e = this.parentNode.event || this.parentNode.selection; var command = ''; alert('Sending event (id {0})');; return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">Send</a>
				        <a onclick="if (this.parentNode.event) { this.parentNode.event.root.eventMenuClick('Delete', this.parentNode.event, 'CallBack'); } else if (this.parentNode.selection) { this.parentNode.selection.root.timeRangeMenuClick('Delete', this.parentNode.selection, 'CallBack'); } return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;border-top:1px solid #ACA899;">Delete (CallBack)</a>
				        <a onclick="if (this.parentNode.event) { this.parentNode.event.root.eventMenuClick('Delete', this.parentNode.event, 'PostBack'); } else if (this.parentNode.selection) { this.parentNode.selection.root.timeRangeMenuClick('Delete', this.parentNode.selection, 'PostBack'); } return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">Delete (PostBack)</a>
				        <a href="javascript:alert('Going somewhere else (id {0})');" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">NavigateUrl test</a>
			        </div>
		        </div>
			</div>
        <div class="right"> <!--style="overflow: auto; position: relative;" align="center"-->
			<!--business hours-->
            <%
                ArrayList wtime = (loc != null? WorkingtimeLoc.findAllByLocationId(loc.getId()) : null) ;
                String from[] = new String[7];
                String to[] = new String[7];
                for(int i = 0; i < 7; i++)
                {
                    WorkingtimeLoc wtemp = ((wtime != null)&& (wtime.size() != 0)? (WorkingtimeLoc)wtime.get(i) : new WorkingtimeLoc());
                    from[i] = wtemp.getH_from().getHours() + ":"  + (wtemp.getH_from().getMinutes()<10 ? "0" : "") +  wtemp.getH_from().getMinutes();
                    to[i] = wtemp.getH_to().getHours() + ":"  + (wtemp.getH_to().getMinutes()<10 ? "0" : "") +  wtemp.getH_to().getMinutes();
                }
              %>                                   

			<div class="services_header"><img src="image?t=business%20hours&fs=13&c=FF6800" style="clear: right"/></div>
			<br /> 
			<table cellspacing="0" cellpadding=0 width="245" class="business_hours">
				<tr>
					<th align="center">mon.</th>
					<th align="center">tues.</th>
					<th align="center">wed.</th>
					<th align="center">thurs.</th>
					<th align="center">friday</th>
					<th align="center">sat.</th>
					<th align="center">sun.</th>
				</tr>
				<tr>
					<td class="business_hours_input"><%=from[0]%></td>
					<td class="business_hours_input"><%=from[1]%></td>
					<td class="business_hours_input"><%=from[2]%></td>
					<td class="business_hours_input"><%=from[3]%></td>
					<td class="business_hours_input"><%=from[4]%></td>
					<td class="business_hours_input"><%=from[5]%></td>
					<td class="business_hours_input"><%=from[6]%></td>
				</tr>
				<tr>
					<th align="center">to</th>
					<th align="center">to</th>
					<th align="center">to</th>
					<th align="center">to</th>
					<th align="center">to</th>
					<th align="center">to</th>
					<th align="center">to</th>
				</tr>
				<tr>
                    <td class="business_hours_input"><%=to[0]%></td>
                    <td class="business_hours_input"><%=to[1]%></td>
                    <td class="business_hours_input"><%=to[2]%></td>
                    <td class="business_hours_input"><%=to[3]%></td>
                    <td class="business_hours_input"><%=to[4]%></td>
                    <td class="business_hours_input"><%=to[5]%></td>
                    <td class="business_hours_input"><%=to[6]%></td>
				</tr>
			</table>
			<!--end of business hours-->
            <div id="ServiceControl" style="position: relative; display: block; width: 200px; height:1000px"></div>
			<div id="ServiceControlClone" style="display:block;"></div>
        </div>
		</div>
    <div id="win" style="position: absolute;border: 1px solid;width: 250px;height: 370px;visibility: hidden;background-color: #000000; z-index: 4;" align="center">
        <!--table>
                <tr/> <tr/>
				<tr>
					<td align="left" style="font-family: Tahoma; font-size: 8pt;">First Name</td>
                    <td align="left" class="STYLE18"><input type="text" id="txtFN" name="txtFN" size="20"  class="wickEnabled" autocomplete="OFF"/></td>
                </tr>
				<tr>
					<td align="left" class="STYLE20">Last Name</td>
					<td align="left" class="STYLE18"><input type="text" id="txtLN" name="txtLN" size="20" class="wickEnabled" autocomplete="OFF"/></td>
				</tr>
				<tr>
					<td align="left" class="STYLE20">Phone</td>
					<td align="left" class="STYLE18"><input type="text" id="txtPh" name="txtPh" size="20" class="wickEnabled" autocomplete="OFF"/></td>
				</tr>
				<tr>
					<td align="left" class="STYLE20">Cell Phone</td>
				    <td align="left" class="STYLE18"><input type="text" id="txtCPh" name="txtCPh" size="20" class="wickEnabled" autocomplete="OFF"/></td>
				</tr>
				<tr>
					<td align="left" class="STYLE20">Email</td>
					<td align="left" class="STYLE18"><input type="text" id="txtEm" name="txtEm" size="20"  class="wickEnabled" autocomplete="OFF"/></td>
				</tr>
                <tr>
					<td align="left" class="STYLE20">Request</td>
					<td align="left" class="STYLE18"><input type="checkbox" id="txtR" name="txtR" size="20"  class="wickEnabled" autocomplete="OFF"/></td>
				</tr>
                <tr>
                    <td align="left" class="STYLE20">Employee</td>
                    <td align="left" class="STYLE18">
                        <select id="txtEmp" name="txtEmp" class="wickEnabled" autocomplete="OFF" style="width: 100%">
                            <%for(int i = 0; i < list_emp.size(); i++){
                                Employee emp = (Employee)list_emp.get(i);
                            %>
                            <option value="<%=emp.getId()%>"><%=emp.getFname() + " " + emp.getLname()%></option>
                            <%}%>
                        </select>
                    </td>
                </tr>
                <tr>
					<td align="left" class="STYLE20">Comment</td>
					<td align="left" class="STYLE18"><textarea cols="16" rows="3" id="com" name="com" class="wickEnabled" autocomplete="OFF"></textarea></td>
				</tr>
                <tr>
                    <td align="left" class="STYLE20">Customer Comment</td>
                    <td align="left" class="STYLE18"><textarea cols="16" rows="3" id="custcom" name="custcom" class="wickEnabled" autocomplete="OFF"></textarea></td>
                </tr>
                <tr>
                    <td align="left" class="STYLE20">Reminder</td>
                    <td align="left" class="STYLE18"><input type="checkbox" id="txtRm" name="txtRm" size="15" class="wickEnabled" autocomplete="OFF" /></td>
                </tr>
                <tr>
                    <td align="left" class="STYLE20">Days</td>
                    <td align="left" class="STYLE18"><input type="text" id="txtRmDays" name="txtRmDays" size="5" class="wickEnabled" autocomplete="OFF" /></td>
                </tr>
                <tr><td colspan="2"/></tr>
                <tr><td colspan="2"/></tr>
                <tr><td colspan="2"/></tr>
				<tr>
					<td colspan="2" align="center">
                        <input id="cust_id" name="cust_id" type="hidden" value="">
						<input id="dr_start" name="dr_start" type="hidden" value="">
                        <input id="dr_end" name="dr_end" type="hidden" value="">
                        <input id="dr_column" name="dr_column" type="hidden" value="">
                        <input type="button" value="Fast Appointment" onclick="fastApp();"/>
                        <input type="button" value="Cancel" onclick="hide_bar();"/>
                        <input type="button" value="Clear" onclick="clear_data();"/>
                        <input type="button" value="Insert" onclick="saveCust();"/>
                        <input type="button" value="Update" onclick="saveCust();"/>
                    </td>
				</tr>
               <tr/> <tr/>
			</table-->
           <table class="form">
               <tr>
                   <td colspan="2">
                       <div class="hd1">Single appointment only</div>
                   </td>
               </tr>
            <tr>
            <th valign="center"><img width="51" height="14" src="./img/form_first_name.png" /></th>
            	<td>
            		<input type="text"  id="txtFN" name="txtFN" class="input_text wickEnabled" autocomplete="OFF" />
            	</td>
            </tr>
            <tr>
            	<th><img width="51" height="14" src="./img/form_last_name.png" /></th>
            	<td>
            		<input type="text" id="txtLN" name="txtLN" class="input_text wickEnabled" autocomplete="OFF" />
            	</td>
            </tr>
            <tr>
            	<th style="letter-spacing: 6px;"><img width="51" height="14" src="./img/form_phone.png" /></th>
            	<td>
            		<input type="text" id="txtPh" name="txtPh" class="input_text wickEnabled" autocomplete="OFF" value="1-()"/>
            	</td>
            </tr>
            <tr>
            	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_cell_phone.png" /></th>
            	<td>
            		<input type="text" id="txtCPh" name="txtCPh" class="input_text wickEnabled" autocomplete="OFF" value="1-()"/>
            	</td>
            </tr>
            <tr>
            	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_email.png" /></th>
            	<td>
            		<input type="text" id="txtEm" name="txtEm" class="input_text wickEnabled" autocomplete="OFF"/>
            	</td>
            </tr>
           <tr>
              <th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_request.png" /></th>
               <td align=left>
                   <script>
                           document.write(drawCheckbox('txtR', false, 'autocomplete="OFF"'));
                   </script>
               </td>
           </tr>

           <tr style="display:none;">
           <td align="left" class="STYLE20"><img src="./img/form_employees.png" /></td>
           <td align="left" class="STYLE18">
               <select id="txtEmp" name="txtEmp" class="styled wickEnabled" autocomplete="OFF">
                   <%for(int i = 0; i < list_emp.size(); i++){
                       Employee emp = (Employee)list_emp.get(i);
                   %>
                   <option value="<%=emp.getId()%>"><%=emp.getFname() + " " + emp.getLname()%></option>
                   <%}%>
               </select>
           </td>
           </tr>
            <tr>
            	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_comment.png" /></th>
            	<td>
            		<textarea class="input_textarea" scroll=none  id="com" name="com" autocomplete="OFF"></textarea>
            	</td>
            </tr>
            <tr>
            	<th style="letter-spacing: 0px;"><img width="51" height="28" src="./img/form_customer_comment.png" /></th>
            	<td>
            		<textarea class="input_textarea" scroll=none id="custcom" name="custcom" autocomplete="OFF"></textarea>
            	</td>
            </tr>
            <tr style="display:none;">
            	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_reminder.png" /></th>
            	<td align=left>
                <script>
                        document.write(drawCheckbox('txtRm', false, 'autocomplete="OFF"'));
                   </script>
            	</td>
            </tr>
            <tr style="display:none;">
            	<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_days.png" /></th>
            	<td>
            		<input type="text" class="input_text" id="txtRmDays" name="txtRmDays" autocomplete="OFF"/>
            	</td>
            </tr>
           <tr>
               <td colspan=2 align=center>
                   <input id="cust_id" name="cust_id" type="hidden" value="">
                   <input id="dr_start" name="dr_start" type="hidden" value="">
                   <input id="dr_end" name="dr_end" type="hidden" value="">
                   <input id="dr_column" name="dr_column" type="hidden" value="">
                   <input id="underEND" name="underEND" type="hidden" value="0">
               <input id="app_id" name="app_id" type="hidden" value="">
                   <input type="image" src="img/button_fast_appointment.png" onclick="fastApp();" width="87" height="25"/>
                   <!--<input type="image" src="img/button_history.png" width="86" height="26" onclick="showHistory();"/>-->
                   <input type="image" src="img/button_cancel.png" onclick="hide_bar();"/>
               </td>
           </tr>
           <tr>
               <td colspan=2>
                   <input type="image" src="img/button_clear.png" width="55" height="26" onclick="clear_data();"/>
                   <input type="image" src="img/button_insert.png" width="55" height="26" onclick="saveCust();"/>
                   <input type="image" src="img/button_update.png" width="55" height="26" onclick="saveCust();"/>
               </td>
           </tr>
           </table>
        <div id="customerDiv" style="position:absolute;z-index:5;">
				<table id="smartInputFloater" class="floater" cellpadding="0" cellspacing="0">
					<tr><td id="smartInputFloaterContent" nowrap="nowrap"></td></tr>
				</table>
			</div>
		</div>
    <div id="win1" style="position: absolute;border: 1px solid;width: 240px;height: 170px;visibility: hidden;background-color: #000000;z-index: 1000;" align="center">
        <table>
				<tr>
					<td align="left" width="30" style="font-family: Tahoma; font-size: 9pt;">Break from</td>
                    <td>
                        <table>
                            <tr>
                               <td>
                                    <select name="w_from" id="w_from" class="styled">
                                        <%for(int i=0; i<work_time.size(); i++){
                                        %>
                                            <option value="<%=i%>"><%=work_time.get(i)%></option>
                                        <%}%>
                                   </select>
                                   <!--input name="hfrom" id="hfrom" type="text" class="ctrl" style="HEIGHT:15px" size="5"></td>
                               <td>:</td>
                               <td><input name="mfrom" id="mfrom" type="text" class="ctrl" style="HEIGHT:15px" size="5"-->
                               </td>
                           </tr>
                        </table>
                    </td>
                </tr>
				<tr>
					<td align="left" width="30" style="font-family: Tahoma; font-size: 9pt;">Break to</td>
					<td>
                        <table>
                            <tr><td>
                                <select name="w_to" id="w_to" class="styled">
                                        <%for(int j=0; j<work_time.size(); j++){%>
                                            <option value="<%=j%>"><%=work_time.get(j)%></option>
                                        <%}%>
                                     </select>
                                <!--input name="hto" id="hto" type="text" class="ctrl" style="HEIGHT:15px" size="5"></td>
                                 <td>:</td>
                                 <td><input name="mto" id="mto" type="text" class="ctrl" style="HEIGHT:15px" size="5"-->
                                </td>
                            </tr>
                       </table></td>
				</tr>
                <tr>
					<td align="left"  width="30" style="font-family: Tahoma; font-size: 9pt;">Comment</td>
					<td align="left"><textarea class="input_textarea" id="wt_com" name="com"></textarea></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
                        <input type="image" src="img/button_approve.png" onclick="saveWT();"/>
                        <input type="image" src="img/button_cancel.png" onclick="hide_bar1();"/>
                        <%--<input type="button" value="Cancel" onclick="hide_bar1();"/>--%>
                        <%--<input type="button" value="Ok" onclick="saveWT();"/>--%>
                        <input id="emp_id" name="emp_id" type="hidden" value="">
                    </td>
				</tr>
               <tr/> <tr/>
			</table>
		</div>
    <div id="win2" style="position: absolute;border:0;width: 322px;height: 224px;background-image: url(img/win_bg1.png);visibility: hidden;background-color: transparent;z-index: 1000;" align="center">
        <br/>
        <table style="height:190px">
            <tr/>
            <tr/>
            <tr>
                <td align="left" style="font-family: Tahoma; font-size: 8pt;">
                    <!-- .x.m. <input type="radio" name="delete" id="win2.noshow" value="6" class="styled" checked><img src="img/win_customer_no_show_bak.png" alt="" /><br/><br/> -->
                    <input type="radio" name="delete" id="win2.noshow" value="6" class="styled" checked><img src="img/win_customer_no_show.png" alt="" /><br/><br/>
                    <input type="radio" name="delete" id="win2.canceled" value="6" class="styled"><img src="img/win_canceled_by_customer.png" alt="" /><br/><br/>
                    <input type="radio" name="delete" id="win2.delete" value="7" class="styled"><img src="img/win_deleted.png" alt="" /><br/><br/>
                    <input type="hidden" name="event" id="event" value="">
                </td>
            </tr>
            <tr/>
            <tr/>
            <tr>
                <td align="right">
                    <input type="image" src="img/button_approve.png" onclick="callYes();"/>
                    <input type="image" src="img/button_cancel.png" onclick="hide_bar2();"/>
                </td>
            </tr>
            <tr/>
            <tr/>
        </table>
    </div>
    <div id="win3" style="position: absolute;border: 1px solid; width: 140px;height: 60px;visibility: hidden;background-color: #000000;z-index: 1000;" align="center">
         <table>
         <tr/> <tr/>
         <tr>
			<td align="left" style="font-family: Tahoma; font-size: 8pt;">Please, wait...</td>
         </tr>
         <tr>   <td>
              <table align="center"><tr><td>
                <div id="showbar" style="font-size:8pt;padding:1px;border:solid white 1px;visibility:hidden">
                <span id="progress1">&nbsp; &nbsp;</span>
                <span id="progress2">&nbsp; &nbsp;</span>
                <span id="progress3">&nbsp; &nbsp;</span>
                <span id="progress4">&nbsp; &nbsp;</span>
                <span id="progress5">&nbsp; &nbsp;</span>
                <span id="progress6">&nbsp; &nbsp;</span>
                <span id="progress7">&nbsp; &nbsp;</span>
                <!--span id="progress8">&nbsp; &nbsp;</span>
                <span id="progress9">&nbsp; &nbsp;</span-->
                </div>
                </td></tr></table>
              </td>
         </tr>
         <tr>
            <td align="left" id="progress_text" style="font-family: Tahoma; font-size: 8pt;"></td>
         </tr>
       </table>
    </div>
    <div id="win5" style="position: absolute;border: 1px solid;width: 240px;height: 150px;visibility: hidden;background-color: #000000;z-index: 1000;" align="center">
        <table>
				<tr>
					<td align="center" width="30" style="font-family: Tahoma; font-size: 9pt;">Edit comment</td>

                </tr>
            <tr>
                <td>
                    <input type="hidden" name="type_comm" id="type_comm" value="">
                </td>
            </tr>
            <tr>
                <td>
                    <textarea style="width: 200px; height: 80px" name="editcomment" id="editcomment" ></textarea>
                </td>
            </tr>
				<tr>
					<td colspan="2" align="center">
                        <input type="image" src="img/button_approve.png" onclick="fillComm();"/>
                        <input type="image" src="img/button_cancel.png" onclick="hide_bar5();"/>
                    </td>
				</tr>
               
			</table>
		</div>
    </div>
		
	
	<script language="javascript" type="text/javascript" >

    function fillComm(){
        var type = document.getElementById("type_comm").value;
        if (type == '1'){
            document.getElementById("comment").value = document.getElementById("editcomment").value;
        } else if (type == '2'){
            document.getElementById("custcomm").value = document.getElementById("editcomment").value;
        }
        hide_bar5();
    }

        function saveWT(){
           try{
               var employeeId = document.getElementById('emp_id').value;
               var fill		= true;
               var i;
               var j;
               i = document.getElementById('w_from').value;
               j = document.getElementById('w_to').value;
               if (i>=j){
                   alert("\"Break from\" time must be less than \"Break to\" time. Please, insert correct time interval!");
                   document.getElementById('w_from').value = 0;
                   document.getElementById('w_to').value = /*44*/(_to-_from)*4; // vogue
                   fill = false;
                   return;
               }
               if (fill){
                    var bfrom = document.getElementById('w_from').options[document.getElementById('w_from').value].text;//document.getElementById('hfrom').value+":"+fminutes;
                    var bto = document.getElementById('w_to').options[document.getElementById('w_to').value].text;//document.getElementById('hto').value+":"+tminutes;
                    var wt_comment = document.getElementById('wt_com').value.replace(/\"/g," ");
                    var currentDate = new Date(document.getElementById("mainCalendar_datecurrent").value);
                    var newCurrentDate 	= currentDate.getUTCFullYear() + "/" + (currentDate.getUTCMonth() + 1) + "/" + currentDate.getUTCDate()+ " " + currentDate.getUTCHours()+":"+currentDate.getUTCMinutes();
                    var request = getXmlHttpObject();
                    if(request == null){
            			alert('Your browser does not support AJAX!');
            		}
    		        var strURL = null;
    		        strURL = 'customerData?SAVEEMPWT=saveewt&employeeId=' + employeeId +
        							'&bfrom=' + bfrom +
        							'&bto=' + bto +
        							'&comment=' + wt_comment +
                                    '&w_date=' + newCurrentDate;
                    request.open("GET", strURL, true);
			        request.onreadystatechange = function(){
				        if (request.readyState == 4){
                            var req2 = request.responseText;
            				if (request.status == 200){
                                if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                                    var arr = req2.split(":");
//                                alert(arr[2].toString());
                                    document.location.href = arr[1].toString();
                                } else  {

                                document.getElementById('w_from').value = 0;
                                document.getElementById('w_to').value = /*44*/(_to-_from)*4; // vogue
                                document.getElementById('wt_com').value = '';
                                var xmlDoc = request.responseXML;
                                /*if (xmlDoc.getElementsByTagName("alert"))
                                    alert("This employee has appointment at this time!");
                                else{*/
                                    var items = xmlDoc.getElementsByTagName("employee");
                                    if(items.length == 1){
                                        if(items[0].getAttribute("ID") != '0'){
                				    		var currentDate = document.getElementById("mainCalendar_datecurrent").value;
                                            mainCalendar.date = new Date(currentDate);
                                            mainCalendar.date.setMinutes(mainCalendar.date.getTimezoneOffset()*(1));
                                            document.getElementById("win1").style.visibility="hidden";
                                            reinitScheduler(mainCalendar,false);
                						}
            	    				//}
                                }
                            }}
        	            }
                    }
		            request.send('');
                }
           }catch(e){
               alert("Please, fill time correctly!!!");
           }
        }

        function fastApp() {
            try {
                var request = getXmlHttpObject();
                if (request == null) {
                    alert('Your browser does not support AJAX!');
                }
                var req = false;
                req = document.getElementById('txtR').checked;
                var strURL = 'customerData?FAST=fast&locationId=' + document.getElementById('locationId').value;
                request.open("GET", strURL, true);
                request.onreadystatechange = function() {
                    if (request.readyState == 4) {
                    var req2 = request.responseText;
                        if (request.status == 200) {
                            if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                                var arr = req2.split(":");
//                        alert(arr[2].toString());
                                document.location.href = arr[1].toString();
                            } else {

                            var xmlDoc = request.responseXML;

                            var items = xmlDoc.getElementsByTagName("customer");
                            if (items.length == 1)
                            {
                                if (items[0].getAttribute("ID") != '0')
                                {
                                    document.getElementById('cust_id').value = items[0].getAttribute("ID");
                                }
                            }
                            var start = new Date(document.getElementById("dr_start").value);
                            var end = new Date(document.getElementById("dr_end").value);
                            var column = parseInt(document.getElementById("dr_column").value);
                           
                            addApp(start, end, column, req);
                        }}
                    }
                }
                request.send('');

                document.getElementById("win").style.visibility = "hidden";
                document.getElementById('txtFN').value = '';
                document.getElementById('txtLN').value = '';
                document.getElementById('txtPh').value = '';
                document.getElementById('txtCPh').value = '';
                document.getElementById('txtEm').value = '';
                document.getElementById('txtR').checked = false;
                document.getElementById('txtEmp').value = '0';
                document.getElementById('custcom').value = '';
                document.getElementById('txtRm').checked = false;
                document.getElementById('txtRmDays').value = '';
            } catch(error) {
                alert(error);
            }
        }

        function saveCust() {
            try {
                var customerId = document.getElementById('cust_id');
                var request = getXmlHttpObject();
                if (request == null) {
                    alert('Your browser does not support AJAX!');
                }
                var firstName = document.getElementById('txtFN').value;
                var lastName =  document.getElementById('txtLN').value.replace('\'', '\'\'');
                var phone = document.getElementById('txtPh').value;
                var cellPhone = document.getElementById('txtCPh').value;
//                if (firstName.replace(/ /g,"") == ""){
//                    alert("Please enter First Name");
//                    return;
//                }
//                if (lastName.replace(/ /g,"") == ""){
//                    alert("Please enter Last Name");
//                    return;
//                }
//                if (phone.replace("1-(","").replace(")","") == "" && cellPhone.replace("1-(","").replace(")","") == ""){
//                    alert("Please enter Phone or Cell Phone");
//                    return;
//                }
                var currentDate = new Date(document.getElementById("mainCalendar_datecurrent").value);
                var pageNum = document.getElementById("mainCalendar_pagenum").value;
                var newCurrentDate = currentDate.getUTCFullYear() + "/" + (currentDate.getUTCMonth() + 1) + "/" + currentDate.getUTCDate() + " " + currentDate.getUTCHours() + ":" + currentDate.getUTCMinutes();
                var strURL = null;
                var req = false;
                if (document.getElementById('txtFN').value != "") {
                    if (customerId.value != "") {
                        var randomnumber = Math.floor(Math.random() * 11);
                        req = document.getElementById('txtR').checked;
                        strURL = 'customerData?UPDATE=update&firstName=' + firstName +
                                 '&lastName=' + lastName +
                                 '&phone=' + phone +
                                 '&cellPhone=' + cellPhone +
                                 '&email=' + document.getElementById('txtEm').value +
                                 '&req=' + document.getElementById('txtR').checked +
                                 '&locationId=' + document.getElementById('locationId').value +
                                 '&rem=' + document.getElementById('txtRm').checked +
                                 '&remdays=' + document.getElementById('txtRmDays').value +
                                 '&cust_id=' + document.getElementById('cust_id').value +
                                 '&comment=' + document.getElementById('com').value.replace(/\"/g," ") +
                                 '&custcomm=' + document.getElementById('custcom').value.replace(/\"/g," ") +
                                 '&empid=' + document.getElementById('txtEmp').value +
                                 '&app_id=' + document.getElementById('app_id').value +
                                 "&rnd=" + randomnumber +
                                 "&idlocation=" + document.getElementById('locationId').value +
                                 "&dateutc=" + newCurrentDate +
//                                 "&req=" + document.getElementById('txtReq').checked +
                                 "&pageNum=" + pageNum;
                        //alert(strURL);
                    } else {
                        req = document.getElementById('txtR').checked;
                        strURL = 'customerData?SAVE=save&firstName=' + document.getElementById('txtFN').value +
                                 '&lastName=' + document.getElementById('txtLN').value.replace('\'', '\'\'') +
                                 '&phone=' + document.getElementById('txtPh').value +
                                 '&cellPhone=' + document.getElementById('txtCPh').value +
                                 '&email=' + document.getElementById('txtEm').value +
                                 '&req=' + document.getElementById('txtR').checked +
                                 '&locationId=' + document.getElementById('locationId').value +
                                 '&empid=' + document.getElementById('txtEmp').value +
                                 '&custcomm=' + document.getElementById('custcom').value.replace(/\"/g," ") +
                                 '&rem=' + document.getElementById('txtRm').checked +
                                 '&remdays=' + document.getElementById('txtRmDays').value;
                    }
                    request.open("GET", strURL, true);
                    request.onreadystatechange = function() {
                        if (request.readyState == 4) {
                            if (request.status == 200) {
                                var req2 = request.responseText;
                                if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                                    var arr = req2.split(":");
//                                alert(arr[2].toString());
                                    document.location.href = arr[1].toString();
                                } else {
                                if (customerId.value == "") {
                                    var xmlDoc = request.responseXML;

                                    var items = xmlDoc.getElementsByTagName("customer");
                                    if (items.length == 1)
                                    {
                                        if (items[0].getAttribute("ID") != '0')
                                        {
                                            document.getElementById('cust_id').value = items[0].getAttribute("ID");
                                        }
                                    }
                                }
//                                var start = new Date(document.getElementById("dpColumnDate").value);
                                var start = new Date(document.getElementById("dr_start").value);
                                var end = new Date(document.getElementById("dr_end").value);
                                var column = parseInt(document.getElementById("dr_column").value);
                               
                                addApp(start, end, column, req);
                            }}
                        }
                    }
                    request.send('');

                    document.getElementById("win").style.visibility = "hidden";

                    document.getElementById('txtFN').value = '';
                    document.getElementById('txtLN').value = '';
                    document.getElementById('txtPh').value = '';
                    document.getElementById('txtCPh').value = '';
                    document.getElementById('txtEm').value = '';
                    document.getElementById('txtR').checked = false;
                    document.getElementById('txtEmp').value = '0';
                    document.getElementById('custcom').value = '';
                    document.getElementById('txtRm').checked = false;
                    document.getElementById('txtRmDays').value = '';
                } else alert("Please insert customer data!!!");
            } catch(error) {
                alert(error);
            }
        }

        function addApp(start, end, column, req) {
        	var _req = req;
            var idEmployee = column;
            var idCustomer = document.getElementById("cust_id").value;
            var idLocation = document.getElementById("locationId").value;
            var underEND = document.getElementById("underEND").value;
            var currentDate = new Date(document.getElementById("mainCalendar_datecurrent").value);
            var pageNum = document.getElementById("mainCalendar_pagenum").value;
            var comment = document.getElementById("com").value.replace(/\"/g," ");
            var reshedule = document.getElementById("reshedule").value;
            var id_booking = document.getElementById("id_booking").value;
            var start = new Date(start);
            var end = new Date(end);
            var newStartUTC = start.getUTCFullYear() + "/" + (start.getUTCMonth() + 1) + "/" + start.getUTCDate() + " " + start.getUTCHours() + ":" + start.getUTCMinutes();
            var newEndUTC = end.getUTCFullYear() + "/" + (end.getUTCMonth() + 1) + "/" + end.getUTCDate() + " " + end.getUTCHours() + ":" + end.getUTCMinutes();
            var newCurrentDate = currentDate.getUTCFullYear() + "/" + (currentDate.getUTCMonth() + 1) + "/" + currentDate.getUTCDate() + " " + currentDate.getUTCHours() + ":" + currentDate.getUTCMinutes();
            var browser_name = document.getElementById("mainCalendar_browser").value;
            try {
                if (document.getElementById('cloned') && document.getElementById('cloned').firstChild && idCustomer > 0) {
                    var idService = document.getElementById('cloned').firstChild.id.replace("cloned_content_id_service_", "");
                    var xmlRequestAppointment;
                    try {
                        xmlRequestAppointment = new XMLHttpRequest();
                    } catch(e) {
                        try {
                            xmlRequestAppointment = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch(e) {
                        }
                    }
                    xmlRequestAppointment.onreadystatechange = function() {
                    	if (xmlRequestAppointment.readyState == 4) {
                            /*eval('mainCalendar.events = [' + xmlRequestAppointment.responseText + ']');
                             mainCalendar.drawEvents();*/
                            var req2 = xmlRequestAppointment.responseText;
                            if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                                var arr = req2.split(":");
//                                alert(arr[2].toString());
                                document.location.href = arr[1].toString();
                            } else {
//                                drawNewEvents(xmlRequestAppointment.responseText);
                                drawAroundEvents(xmlRequestAppointment.responseText);
                                
//                                drawEvents(xmlRequestAppointment.responseText);
			                  	//TODO: .x.m. send comfirm Email
			                  	//alert(xmlRequestAppointment.responseText);
			                  	//{"ServerId":"appoint_70272","BarStart":0,"EventStatus":0,
			                  	//"ToolTip":"Xm Xm","PartStart":"一月 29, 2015 14:15:00 +0000",
			                  	//"Box":true,"Left":300,"Tag":"","InnerHTML":"Xm Xm - Ombre",
			                  	//"Width":100,"ResizeEnabled":true,"Start":"一月 29, 2015 14:15:00 +0000",
			                  	//"RightClickEnabled":true,"Value":"3","Height":66,"End":"一月 29, 2015 15:00:00 +0000",
			                  	//"ClickEnabled":false,"BarColor":"#FF5B01","BarLength":66,"PartEnd":"一月 29, 2015 15:00:00 +0000",
			                  	//"DeleteEnabled":true,"Text":"Event #1","MoveEnabled":true,"ContextMenu":null,
			                  	//"idappt":70272,"ide":75,"idc":11287,"ids":73,"dt":"2015/1/29","BackgroundColor":"#FFF57A",
			                  	//"Top":374,"DayIndex":0}
			                  	if(xmlRequestAppointment.responseText){
			                  		console.log(xmlRequestAppointment.responseText);
			                  		
			                  		var data = "["+xmlRequestAppointment.responseText+"]"
				                  	
				                    var appointments = jQuery.parseJSON(data);
				                    sendcomfrimEmail(appointments[0].ServerId, idEmployee, idCustomer);
			                  	}
                            }
                        }
                    };
                    
                    xmlRequestAppointment.open("POST", "ScheduleManager?optype=NEW&start=" + newStartUTC + "&end=" + newEndUTC + "&idnewemployee=" + idEmployee + "&idcustomer=" + idCustomer + "&idservice=" + idService + "&idlocation=" + idLocation + "&dateutc=" + newCurrentDate + "&pageNum=" + pageNum + "&comment=" + comment +"&req=" + _req + "&browser=" + browser_name + "&underEND=" + underEND + "&reshedule=" + reshedule + "&idb=" + id_booking);
                    xmlRequestAppointment.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
                    xmlRequestAppointment.send('');
                    document.getElementById('com').value = '';
                    document.getElementById('cust_id').value = '';
                }
            } catch (e) {
            }
        }
        

		
        function InitPageNum(){
            var elm = document.getElementById("mainCalendar_pagenum");
            /*var newDate = new Date(new Date().toDateString());
            document.getElementById("mainCalendar_datecurrent").value = newDate;*/
            if(elm.value.length==0) return 0;
            else return parseInt(elm.value);
        }

        function MoveNext()
        {
            var currentDate = document.getElementById("mainCalendar_datecurrent").value;

            var currentPage = parseInt(document.getElementById("mainCalendar_pagenum").value);
            mainCalendar.date = new Date(currentDate);
            mainCalendar.date.setMinutes(mainCalendar.date.getTimezoneOffset()*(1));

            var nextPage = currentPage + 1;
            document.getElementById("mainCalendar_pagenum").value =  nextPage.toString();
            reinitScheduler(mainCalendar,false);
        }

        function MovePrev()
        {
            var currentDate = document.getElementById("mainCalendar_datecurrent").value;
            var currentPage = parseInt(document.getElementById("mainCalendar_pagenum").value);

            mainCalendar.date = new Date(currentDate);
            mainCalendar.date.setMinutes(mainCalendar.date.getTimezoneOffset()*(1));

            var prevPage = 0;
            if (currentPage !=0)
                prevPage = currentPage - 1;
            document.getElementById("mainCalendar_pagenum").value =  prevPage.toString();
            reinitScheduler(mainCalendar,false);
        }


        function mainCalendar_Init(date) {

            drawTimeColumns();

            var browser_name = navigator.appName;
            document.getElementById("mainCalendar_browser").value = browser_name;
            var c = new DayPilotCalendar.Calendar('mainCalendar');
            //progressAt++;
            progress_update();
            c.allDayHeaderHeight = 22;
			c.allDayEventHeight = 22;
			c.allowEventOverlap = true;
			c.borderColor = '#000000';
			c.clientName = 'mainCalendar';
			c.cellHeight = 22;
			c.cellsPerHour = 4;
			c.columnMarginRight = 0;
			c.cssClass = '';
			c.deleteUrl = 'img/close.png';
			c.days = 1;
			c.durationBarVisible = true;
			c.durationBarWidth = 5;
			c.durationBarImageUrl = '';
			c.eventBorderColor = '#000000';
			c.eventFontFamily = 'Tahoma';
			c.eventFontSize = '8pt';
			c.eventFontColor = '#000000';
			c.eventSelectColor = 'Blue';
			c.headerFontSize = '10pt';
			c.headerFontFamily = 'Tahoma';
			c.headerFontColor = '#000000';
			c.headerHeight = 40;			
			c.headerLevels = 1;
			c.hourHalfBorderColor = '#F3E4B1';			
			
			c.customHourHalfBorderColor = '#EAD098';
			
			c.hourBorderColor = '#EAD098';
			
			c.initScrollPos = '0';
			c.minEnd = 801;
			c.maxStart = 1481;
			c.rtl = false;
			c.selectedColor = '#316AC5';
			c.showToolTip = true;
			c.showAllDayEvents = false;
			c.showHeader = true;
			
			//c.startDate = new Date('June 25, 2008 00:00:00 +0000');
            c.startDate = date;
			c.LocationId = '1';
			c.pageNum = InitPageNum();
            c.uniqueID = 'DayPilotCalendar1';
			c.useEventBoxes = 'Always';
			c.viewType = 'Days';
			c.visibleStart = _from;
			c.widthUnit = 'Percentage';
			c.afterEventRender = function(e, div) {};
			c.afterRender = function(data) {};
			c.eventClickHandling = 'Disabled';
			c.eventClickCustom = function(e) {alert('Event with id ' + e.value() + ' clicked.')};				

			c.eventHoverHandling = 'bubble';
			c.eventSelectHandling = 'Disabled';
			c.eventSelectCustom = function(e) {alert('Event selected.')};
			//c.rightClickHandling = 'ContextMenu';
			c.rightClickHandling = 'Disabled';
			c.rightClickCustom = function(e) {alert('Event with id ' + e.value() + ' clicked.')};
			c.headerClickHandling = 'JavaScript';
			c.headerClickCustom = function(c) {
                if (c.value > 0) {
                    document.location="./admin/time_employee.jsp?action=time&id="+ c.value;
                }
            };
            c.eventDoubleClickHandling = 'JavaScript';
			c.eventDoubleClickCustom = function(e) {
                var xmlRequest;
                xmlRequest = null;
				//var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();

			    try {
			        xmlRequest = new XMLHttpRequest();
			    }
			    catch(e) {
			        try {
			            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
			        } catch(e) { }
			    }

				xmlRequest.onreadystatechange = function() {
					if (xmlRequest.readyState ==4 ) {
						/*eval('c.events = [' + xmlRequest.responseText + ']');
						c.drawEvents();*/
                        drawEvents(xmlRequest.responseText);
                    }
				};
                var randomnumber=Math.floor(Math.random()*11)
				var strURL = 'customerData?DBLCLICK=dblclick'+'&idappointment='+e.div.data.ServerId + "&rnd=" + randomnumber;//+ "&idlocation="+c.LocationId+"&dateutc="+dateUtc + "&pageNum=" + c.pageNum;
                xmlRequest.open("GET", strURL, true);
		        xmlRequest.onreadystatechange = function() {
    				if (xmlRequest.readyState == 4)
                        var req2 = xmlRequest.responseText;

                        if (xmlRequest.status == 200) {
                    if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                        var arr = req2.split(":");
//                            alert(arr[2].toString());
                        document.location.href = arr[1].toString();
                    } else {                       var xmlDoc = xmlRequest.responseXML;

                        items = xmlDoc.getElementsByTagName("customer");
                        if (items.length == 1) {
                            if (items[0].getAttribute("ID") != '0') {
                                document.getElementById('txtFirstName').value = items[0].getAttribute("FNAME");
                                document.getElementById('txtLastName').value = items[0].getAttribute("LNAME");
                                document.getElementById('txtPhone').value = items[0].getAttribute("PHONE");
                                document.getElementById('txtCellPhone').value = items[0].getAttribute("CELLPHONE");
                                document.getElementById('txtEmail').value = items[0].getAttribute("EMAIL");
                                //document.getElementById('txtReq').checked = items[0].getAttribute("REQ").toString() == "true";
                                checkCheckbox('txtReq',items[0].getAttribute("REQ").toString() == "true");
                                //document.getElementById('txtEmployee').value = items[0].getAttribute("EMP_ID");
                                select_setValue('txtEmployee', items[0].getAttribute("EMP_ID"));
                                
                                document.getElementById('comment').value = items[0].getAttribute("COMMENT");
                                document.getElementById('custcomm').value = items[0].getAttribute("CUSTCOMM");
                                //document.getElementById('txtRem').checked = items[0].getAttribute("REM").toString() == "true";
                                checkCheckbox('txtRem',items[0].getAttribute("REM").toString() == "true");
                                document.getElementById('txtRemDays').value = items[0].getAttribute("REMDAYS");

                                document.getElementById('cust_id').value = items[0].getAttribute("ID");
                                document.getElementById('app_id').value = items[0].getAttribute("APP_ID");
                            }
                            else {
                                alert('The customer could not be shown!');
                            }
                        }
                        else {
                            alert('The customer could not be shown!');
                        }
                    }}
    			}
                xmlRequest.send('');
                strURL = "";
            };
            c.eventDeleteHandling = 'JavaScript';
			c.eventDeleteCustom = function(e) 
			{
                var del;
                if (isChoice == 6) del = "delcust";
                else if (isChoice == 7) del = "delok";
                else if (isChoice == 8) del = "delcancel";
                else del = "";
                isChoice = 0;
                var xmlRequest;
				
				var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();
				
			    try {
			        xmlRequest = new XMLHttpRequest();
			    }
			    catch(e) {
			        try {
			            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
			        } catch(e) { }				        
			    }
				
			    var app_id = document.getElementById("app_id").value;
				xmlRequest.onreadystatechange = function() {
					if (xmlRequest.readyState ==4 ) {					
						/*eval('c.events = [' + xmlRequest.responseText + ']');
						c.drawEvents();*/
						
                        var req2 = xmlRequest.responseText;
						
                        if (req2!=null){
                            if (req2.indexOf("REDIRECT") != -1){
                                var arr = req2.split(":");
    //                            alert(arr[2].toString());
                                document.location.href = arr[1].toString();
                            } else if (req2.indexOf("SAYALERT") != -1){
                                var arr = req2.split(":");
                                alert(arr[1].toString());
                            } else if ((req2!=null) && (req2.indexOf("REFRESHALL") != -1)){
                               reinitScheduler_dt(dateUtc,true);
                            } else if (req2.indexOf("DELETEAPP") != -1){
                                var arr = req2.split("^");
								//alert(arr[1].toString());
                                document.getElementById(arr[1].toString()).innerHTML = "";
                                drawAroundEvents(arr[2]);
                            } else{
                            	
                                drawAroundEvents(req2);
                                //.x.m.
								var pop = new popup();
                                jQuery.get("ScheduleManager", {"optype": "canceled_send_email", "appointmentID" : app_id, "timestamp" : new Date().getTime()}, 
    								function(data, textStatus, response){
   										pop.tip({message:response.responseText, "visiable" : false, "type": "warning", "showLocation" : "buttom"});
     								});
                                
                            }
                        }
                    }
				};
                
                xmlRequest.open("POST", "ScheduleManager?optype=DEL&idappointment="+app_id+ "&idlocation="+c.LocationId+"&dateutc="+dateUtc + "&pageNum=" + c.pageNum + "&delParam=" + del + "&browser=" + browser_name);
                xmlRequest.send('');
                document.getElementById("app_id").value = null;
            };
				
			c.eventResizeHandling = 'JavaScript';				
			c.eventResizeCustom = function(e, newStart, newEnd) 
			{ 									
				var xmlRequest;
				var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();
				
				var start 	= new Date(newStart);
				var end 	= new Date(newEnd);
					
				var newStartUTC = start.getUTCFullYear() + "/" + (start.getUTCMonth() + 1) + "/" + start.getUTCDate() + " " + start.getUTCHours()+":"+start.getUTCMinutes();
//                alert("newStartUTC = " + start);
				var newEndUTC 	= end.getUTCFullYear() + "/" + (end.getUTCMonth() + 1) + "/" + end.getUTCDate()+ " " + end.getUTCHours()+":"+end.getUTCMinutes();
				
				//alert(dateUtc + "\n" +start + "\n" +end + "\n" +newStartUTC + "\n" +newEndUTC);
												
			    try {
			        xmlRequest = new XMLHttpRequest();
			    }
			    catch(e) {
			        try {
			            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
			        } catch(e) { }				        
			    }
				
				xmlRequest.onreadystatechange = function() {
					if (xmlRequest.readyState ==4 ) {												
						/*eval("c.events = [" + xmlRequest.responseText + "]");
						c.drawEvents();*/
                        var req2 = xmlRequest.responseText;
                        if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                            var arr = req2.split(":");
//                            alert(arr[2].toString());
                            document.location.href = arr[1].toString();
                        } else if ((req2!=null) && (req2.indexOf("REFRESHALL") != -1)){
                           reinitScheduler_dt(dateUtc,true);
                        } else {
//                            alert("Ahtung 1");
                          drawAroundEvents(xmlRequest.responseText);
//                        alert(e.div.height);
                        }
//                        drawEvents(xmlRequest.responseText);
                    }
				};
															
				xmlRequest.open("POST", "ScheduleManager?optype=REZ&start="+newStartUTC+"&end="+newEndUTC +"&idappointment="+e.div.data.ServerId+ "&idlocation="+c.LocationId+"&dateutc="+dateUtc + "&pageNum=" + c.pageNum + "&browser=" + browser_name);
				xmlRequest.send('');
			};
			c.eventMoveHandling = 'JavaScript';
			c.eventMoveCustom = function(e, newStart, newEnd, oldColumn, newColumn, external) 
			{
				if (newColumn > 0){
                    var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();
				    //.x.m.
                    //alert(newStart);
				    
				    var start 	= new Date(newStart);
				    var end 	= new Date(newEnd);

    				var newStartUTC = start.getUTCFullYear() + "/" + (start.getUTCMonth() + 1) + "/" + start.getUTCDate() + " " + start.getUTCHours()+":"+start.getUTCMinutes();
    				var newEndUTC 	= end.getUTCFullYear() + "/" + (end.getUTCMonth() + 1) + "/" + end.getUTCDate()+ " " + end.getUTCHours()+":"+end.getUTCMinutes();

				    //alert(newStartUTC);
				   
				    
    				var xmlRequest;

	    		    try {
    			        xmlRequest = new XMLHttpRequest();
    			    }
    			    catch(e) {
    			        try {
    			            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
    			        } catch(e) { }
    			    }

                   // alert(browser_name);
    				xmlRequest.onreadystatechange = function() {
    					if (xmlRequest.readyState ==4 ) {
    						/*eval("c.events = [" + xmlRequest.responseText + "]");
    						c.drawEvents();*/
                            var req2 = xmlRequest.responseText;
                            if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                                var arr = req2.split(":");
//                                alert(arr[2].toString());
                                document.location.href = arr[1].toString();
                            } else if ((req2!=null) && (req2.indexOf("REFRESHALL") != -1)){
                               reinitScheduler_dt(dateUtc,true);
                            } else
                                drawAroundEvents(xmlRequest.responseText);
//                             drawEvents(xmlRequest.responseText);
                        }
    				};
			
	    			xmlRequest.open("POST", "ScheduleManager?optype=MOV&start="+newStartUTC+"&end="+newEndUTC +"&idappointment="+e.div.data.ServerId+"&idoldemployee="+oldColumn+"&idnewemployee="+newColumn+ "&idlocation=" + c.LocationId + "&dateutc=" + dateUtc + "&pageNum=" + c.pageNum + "&browser=" + browser_name);
    				xmlRequest.send('');
                }
			};
			
			c.eventChangeStatusHandling = 'JavaScript';
			c.eventChangeStatusCustom = function (img, e, ct) {

//                var xmlRequest2;
//
//                try {
//                    xmlRequest2 = new XMLHttpRequest();
//                }
//                catch(e) {
//                    try {
//                        xmlRequest2 = new ActiveXObject("Microsoft.XMLHTTP");
//                    } catch(e) { }
//                }
//
//                xmlRequest2.onreadystatechange = function() {
//                    if (xmlRequest2.readyState ==4 ) {
//                    }
//                };
//
//				xmlRequest2.open("POST", "./chkqry?action=updateTicketsStatusByAppID&AppID=" + e.div.data.idappt+"&ct=" + ct);
//                xmlRequest2.setRequestHeader("Accept-Encoding", "text/html; charset=utf-8");
//                xmlRequest2.send('');

            new Ajax.Request( './chkqry?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                action: "updateTicketsStatusByAppID",
                AppID: e.div.data.idappt,
                ct: ct
            },
            onSuccess: function(transport) {

                var eventState = "0";

                switch (e.div.data.EventStatus)
                {
                    case 1 :    eventState = "0";
                                break;
                    case 2 :    eventState = "1";
                                break;
                    case 0 :    eventState = "1";
                                break;
                }

                var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();

                new Ajax.Request( './ScheduleManager?rnd=' + Math.random() * 99999, { method: 'get',
                parameters: {
                    optype: "FLAG",
                    idappointment: e.div.data.ServerId,
                    state: eventState,
                    idlocation: c.LocationId,
                    dateutc: dateUtc,
                    pageNum: c.pageNum,
                    browser: browser_name
                },
                onSuccess: function(transport) {
                    var response = new String(transport.responseText);
                    if ((response!=null) && (response.indexOf("REDIRECT") != -1)){
                        var arr = response.split(":");
//                        alert(arr[2].toString());
                        document.location.href = arr[1].toString();
                    } else
                        drawAroundEvents(response);
//                        drawEvents(response);
                }.bind(this),
                onException: function(instance, exception){
                    alert('Error ScheduleManager optype FLAG: ' + exception);
                }
                });
            }.bind(this),
            onException: function(instance, exception){
                alert('Error updateTicketsStatusByAppID: ' + exception);
            }
            });




//				var xmlRequest;
//
//			    try {
//			        xmlRequest = new XMLHttpRequest();
//			    }
//			    catch(e) {
//			        try {
//			            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
//			        } catch(e) { }
//			    }
//
//                xmlRequest.onreadystatechange = function() {
//                    if (xmlRequest.readyState ==4 ) {
//                         drawEvents(xmlRequest.responseText);
//                    }
//                };
//
//				xmlRequest.open("POST", "ScheduleManager?optype=FLAG&idappointment="+e.div.data.ServerId+ "&state=" + eventState +
//                                        "&idlocation=" + c.LocationId + "&dateutc=" + dateUtc + "&pageNum=" + c.pageNum +
//                                        "&browser=" + browser_name);
//                xmlRequest.send('');


			}
				
			c.timeRangeSelectedHandling = 'Disabled';
			c.timeRangeSelectedCustom = function(start, end, column) {alert(start.toGMTString() + '\n' + end.toGMTString());};
			c.timeRangeDoubleClickHandling = 'JavaScript';
			c.timeRangeDoubleClickCustom = function(start, end, column) 
			{
                //emp id - column;
				alert(start.toGMTString() + '\n' + end.toGMTString() + "\n" + column);
			};                       
			c.eventEditHandling = 'Disabled';
			c.eventEditCustom = function(e, newText) {alert('The text of event ' + e.value() + ' was changed to ' + newText + '.');};
			c.stepMs = 900000;
//			c.startMs = 32400000;
//			c.endMs = 72000000;
			c.startMs = _from * 60*60*1000;//28800000; // for esalonsoft/vogue
			c.endMs = _to * 60*60*1000;//68400000;   // for esalonsoft/vogue
			c.AllowSelecting = true;
			c.callbackError = function(result, context) { alert('An exception was thrown in the server-side event handler:\n\n' + result.substring(result.indexOf('$$$')+3)); };
			
			
			

			c.eventsAllDay = [];

            c.events = [];
             
            c.columns = [
//                	{"Width":"33","ToolTip":null,"Name":"Meeting Room A","InnerHTML":"Meeting Room A","Date":"September 1, 2008 00:00:00 +0000","Value":"idemployee","BackColor":"#ECE9D8"},
//                	{"Width":"33","ToolTip":null,"Name":"Meeting Room B","InnerHTML":"Meeting Room B","Date":"September 1, 2008 00:00:00 +0000","Value":"B","BackColor":"#ECE9D8"},
//                	{"Width":"33","ToolTip":null,"Name":"Meeting Room C","InnerHTML":"Meeting Room C","Date":"September 1, 2008 00:00:00 +0000","Value":"C","BackColor":"#ECE9D8"}                	
			];     

			var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();

			var xmlRequestHeader;
				
		    try {
		        xmlRequestHeader = new XMLHttpRequest();
		    }
		    catch(e) {
		        try {
		            xmlRequestHeader = new ActiveXObject("Microsoft.XMLHTTP");
		        } catch(e) { }				        
		    }
						
			xmlRequestHeader.onreadystatechange = function() {
				if (xmlRequestHeader.readyState ==4 ) {
                    var req2 = xmlRequestHeader.responseText;
                    if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                        var arr = req2.split(":");
//                        alert(arr[2].toString());
                        document.location.href = arr[1].toString();
                    } else {

                    eval("c.columns = [" + xmlRequestHeader.responseText + "]");

					for (var i = 0; i<c.columns.length; i++) {
                        c.columns[i].Date = c.startDate;
					}
                    var hfrom = new Array();
                    var hto = new Array();
                    var hc = new Array();

                    var columnColors = "";
                    var columnComment = "";
                    for (var j = 1; j <= /*44*/(_to-_from)*4; j++) { // vogue
					    var lineColor = "";
                        var lineComment = "";
                        lineColor += "[";
                        lineComment += "[";
                        for (var i = 0; i < c.columns.length; i++) {
                            var str_f;
                            var a_f = new Array();
                            var s_f = new Array();
                            str_f = c.columns[i].NWTF;
                            s_f = str_f.split('[');
                            a_f = s_f[1].split(']');
                            if (a_f.length > 0)
                                hfrom = a_f[0].split(',');

                            var str_t;
                            var a_t = new Array();
                            var s_t = new Array();
                            str_t = c.columns[i].NWTT;
                            s_t = str_t.split('[');
                            a_t = s_t[1].split(']');
                            if (a_t.length > 0)
                                hto = a_t[0].split(',');

                            var str_c;
                            var a_c = new Array();
                            var s_c = new Array();
                            str_c = c.columns[i].NWTC;
                            s_c = str_c.split('[');
                            a_c = s_c[1].split(']');
                            if (a_c.length > 0)
                                hc = a_c[0].split(',');

                            if  (j >= parseInt(c.columns[i].HFrom) + 1 && j <= parseInt(c.columns[i].HTo)){
                                var flag = true;
                                var k = 0;
                                for(; k < hfrom.length; k++){
                                    if (j > hfrom[k] && j <= hto[k]) {
                                        flag = false;
                                        break;
                                    }
                                }
                                if (flag) {
                                    lineColor += "\"#E2E3E4\"";
                                } else {
                                    lineColor += "\"#ACACAE\"";
                                    lineComment += "\"" + hc[k] + "\"";
                                }
                            } else {
                                lineColor += "\"#ACACAE\"";
                                if (c.columns[i].Comment != null && c.columns[i].Comment != 'null' && c.columns[i].Comment.length > 0) {
                                    lineComment += "\"" + c.columns[i].Comment + "\"";
                                }
                            }
							if (i != (c.columns.length - 1)) {
                                lineColor += ", ";
                                lineComment += ", ";
                            }
                            a_f.length = 0;
                            s_f.length = 0;
                            hfrom.length = 0;
                            a_t.length = 0;
                            s_t.length = 0;
                            hto.length = 0;
                            a_c.length = 0;
                            s_c.length = 0;
                            hc.length = 0;
                        }
                        lineColor += "]";
                        lineComment += "]";

            			columnColors += lineColor;
                        columnComment += lineComment;
            			if (j != /*44*/(_to-_from)*4) columnColors += ", "; // vogue
                        if (j != /*44*/(_to-_from)*4) columnComment += ", "; // vogue
            	    }

	            	eval("c.colors = [" + columnColors + "]");
                    eval("__colors = [" + columnColors + "]");
                    eval("c.comment = [" + columnComment + "]");
					c.Init();
                }
                }
			};

			xmlRequestHeader.open("POST", 'ScheduleServlet?optype=EMPLIST&idlocation=' + c.LocationId + '&calendar=' + dateUtc + '&pageNum=' + c.pageNum);
			xmlRequestHeader.setRequestHeader("Content-type", "text/html; charset=UTF-8");
			xmlRequestHeader.send('');

			var xmlRequestEvents;
				
			   try {
			      xmlRequestEvents = new XMLHttpRequest();
			   }
			   catch(e) {
			       try {
			           xmlRequestEvents = new ActiveXObject("Microsoft.XMLHTTP");
			       } catch(e) { }				        
			   }
			
			xmlRequestEvents.onreadystatechange = function() {
				if (xmlRequestEvents.readyState ==4 ) {
                    //alert(xmlRequestEvents.responseText);
                    var req2 = xmlRequestEvents.responseText;
                    if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                        var arr = req2.split(":");
//                        alert(arr[2].toString());
                        document.location.href = arr[1].toString();
                    } else{
                        drawEvents(xmlRequestEvents.responseText);
                    }
                    //copy line of employees from the top to bottom                    
                    //var str = c.header.innerHTML;
                    //var elm = document.getElementById("mainCalendar_header_bottom");
                    //var t = document.createElement('div');
                    //t.innerHTML = '<table style="border-left: 1px solid rgb(0, 0, 0);border-right: 1px solid rgb(0, 0, 0);" border="0" cellpadding="0" cellspacing="0" width="100%">' + str + '</table>';
                    //if(elm.childNodes.length > 0)
                    //    elm.removeChild(elm.childNodes[0]);
                    //elm.appendChild(t);
				}
			};

			xmlRequestEvents.open("POST", "ScheduleManager?optype=ALL&idlocation=" + c.LocationId + "&dateutc=" + dateUtc + '&pageNum=' + c.pageNum + "&browser=" + browser_name);
			xmlRequestEvents.setRequestHeader("Accept-Encoding","text/html; charset=utf-8");
			xmlRequestEvents.send('');
            //alert('123');
            c.Init();

            return c;
		}

        function customerControlAdd_Init() {
        	var caControl = new CustomerControl('CustomerAddContainer', '1');
        	caControl.Init();
            return caControl;
        }

        function customerControl_Init() {
            var cControl = new CustomerControl('CustomerContainer', '1');
        	cControl.Init();

            return cControl;
        }
        
        function serviceListControl_Init() {
           var sControl = new ServiceListControl();
           sControl.services = [];

           var xmlRequestService;
				
		   try {
		      xmlRequestService = new XMLHttpRequest();
		   }
		   catch(e) {
		       try {
		           xmlRequestService = new ActiveXObject("Microsoft.XMLHTTP");
		       } catch(e) { }				        
		   }
			
			xmlRequestService.onreadystatechange = function() {
				if (xmlRequestService.readyState ==4 ) {					
					eval("sControl.services = [" + xmlRequestService.responseText + "]");
					sControl.init('ServiceControl');									
				}
			};
				
			xmlRequestService.open("POST", "ServiceServlet");
			xmlRequestService.setRequestHeader("Accept-Encoding","text/html; charset=utf-8");
			xmlRequestService.send('');

            sControl.init('ServiceControl');
            
            return sControl;
        	//return null;        	
        }
         
		var originalOnload = window.onload;
		
		var mainCalendar 		= null;
		var serviceListControl 	= null;		
		var customerControl 	= null;
		var customerAddControl = null;
        
        
        var calendar_switcher = 0;
		function changeDay(calendar) 
		{		          
            //document.location.href = "schedule.do?dt=" + calendar.date.toDateString()+"&idc="+document.getElementById('cust_id').value;      				             				           
			reinitScheduler(calendar,true);
            reinitBreakTime(calendar);
      	};
			               
		//mainCalendar = mainCalendar_Init(new Date(new Date().toUTCString()));
		var newDate = new Date(/*new Date().toDateString()*/<%=dt.equals("")? "new Date().toDateString()" : "'"+dt+"'"%>);
        //alert("newDate = " + newDate);
		newDate.setMinutes(newDate.getTimezoneOffset()*(-1));
		
		var progressEnd = 7; // set to number of progress <span>'s.
		var progressColor = 'blue'; // set to progress bar color
		var progressInterval = 1000; // set to time between updates (milli-seconds)

		var progressAt = 0;//progressEnd;
		var progressTimer;
		function progress_clear() {
		    for (var i = 1; i <= progressEnd; i++) document.getElementById('progress'+i).style.backgroundColor = 'transparent';
            progressAt = 0;
		}
		function progress_update() {
		    document.getElementById('showbar').style.visibility = 'visible';
		    progressAt++;
            if (progressAt >= progressEnd) {
                document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
                obj.style.visibility = "hidden";
                progress_stop();
            }
		    else document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
		    //progressTimer = setTimeout('progress_update()',progressInterval);
		}

        function init_customer()
        {
            <%if(id_customer>0){%>
                document.getElementById('cust_id').value = '<%=cust!=null?cust.getId():0%>';
                document.getElementById('txtFirstName').value = '<%=cust!=null?cust.getFname():""%>';
                document.getElementById('txtLastName').value = '<%=cust!=null?cust.getLname():""%>';
                document.getElementById('txtPhone').value = '<%=cust!=null?cust.getPhone():""%>';
                document.getElementById('txtCellPhone').value = '<%=cust!=null?cust.getCell_phone():""%>';
                document.getElementById('txtEmail').value = '<%=cust!=null?cust.getEmail():""%>';
                document.getElementById('custcomm').value = '<%=cust!=null?cust.getComment():""%>';
            <%}%>
        }
        
		function progress_stop() {
		    /*clearTimeout(progressTimer);  */
		    progress_clear();
		    document.getElementById('showbar').style.visibility = 'hidden';
            init_customer();
		}
        
        if (typeof(Sys) != 'undefined' && Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance && Sys.WebForms.PageRequestManager.getInstance().get_isInAsyncPostBack()) {
			obj = document.getElementById("win3");
            obj.style.top =screen.height/2 + "px";
            obj.style.left = screen.width/2 + "px";

            obj.style.visibility = "visible";
            progress_update();
            Calendar.setup(
      			{
	          		date : new Date(<%=dt.equals("")? "new Date().toDateString()" : "'"+dt+"'"%>),
                    pageNum : 0,
	          		flat : "CalendarContainer", 
	          		flatCallback : changeDay 
      			}
  			);
		   
		   mainCalendar 		= mainCalendar_Init(newDate);
		   serviceListControl 	= serviceListControl_Init();
		   customerControl 		= customerControl_Init();
 
           document.getElementById("mainCalendar_datecurrent").value = newDate.toString();//new Date().toString();
           document.getElementById("mainCalendar_pagenum").value = mainCalendar.pageNum.toString();
        } else {

		    window.onload = function() {
                obj = document.getElementById("win3");
                obj.style.top =screen.height/2 + "px";
                obj.style.left = screen.width/2 + "px";

                obj.style.visibility = "visible";
                progress_update();
                Calendar.setup(
		          	{
	             		date : new Date(<%=dt.equals("")? "new Date().toDateString()" : "'"+dt+"'"%>),
                        pageNum : 0,
	             		flat : "CalendarContainer", 
	             		flatCallback : changeDay 
		          	}
	      		);


                mainCalendar 		= mainCalendar_Init(newDate);
		    	serviceListControl 	= serviceListControl_Init();
		    	customerControl 	= customerControl_Init();
                document.getElementById("mainCalendar_datecurrent").value = newDate.toString();
                document.getElementById("mainCalendar_pagenum").value = mainCalendar.pageNum.toString();
		        if (originalOnload) originalOnload();
             };
        }                                                       
        
		function reinitScheduler(calendar,offset) {
            var d = calendar.date.getDate();
            var m = calendar.date.getMonth()+1;
            var y = calendar.date.getFullYear();
            var _dt = m + "/" + d + "/" + y;
            new Ajax.Request( './getWorkingTime.jsp?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                dt : _dt
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                if(response != ''){
                    a = response.replace(/(^\s+)|(\s+$)/g, "").split("#", 2);
                    _from = parseFloat(a[0].replace(/(^\s+)|(\s+$)/g, ""));
                    _to = parseFloat(a[1].replace(/(^\s+)|(\s+$)/g, ""));
                    //.replace(/(^\s+)|(\s+$)/g, "")
                    //_from = 11.0;
                    //_to = 20.0;
                    var newDate = new Date(calendar.date.toDateString());
                    newDate.setMinutes(newDate.getTimezoneOffset()*(-1));
                    //alert("reinitScheduler.date = " + newDate);
                    obj = document.getElementById("win3");
                    obj.style.top =screen.height/2 + "px";
                    obj.style.left = screen.width/2 + "px";
                    for (var i=1;i<5;i++)
                        document.getElementById('progress'+i).style.backgroundColor = progressColor;
            
                    progressAt = 4;
                    obj.style.visibility = "visible";
                    mainCalendar = mainCalendar_Init(newDate);
                    document.getElementById("mainCalendar_datecurrent").value = newDate.toString();//calendar.date.toString();
                    document.getElementById("mainCalendar_pagenum").value = mainCalendar.pageNum.toString();
                }
                else
                {
                    alert('error');
                }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error until update working time: ' + exception);
            }
            });
   		}

		function reinitScheduler_dt(dateUtc,offset) {

            var xmlRequestEvents;

               try {
                  xmlRequestEvents = new XMLHttpRequest();
               }
               catch(e) {
                   try {
                       xmlRequestEvents = new ActiveXObject("Microsoft.XMLHTTP");
                   } catch(e) { }
               }

            xmlRequestEvents.onreadystatechange = function() {
                if (xmlRequestEvents.readyState ==4 ) {
                    var req2 = xmlRequestEvents.responseText;
                    if ((req2!=null) && (req2.indexOf("REDIRECT") != -1)){
                        var arr = req2.split(":");
//                        alert(arr[2].toString());
                        document.location.href = arr[1].toString();
                    } else{
                        drawEvents(xmlRequestEvents.responseText);
                    }
                }
            };
            var browser_name = document.getElementById("mainCalendar_browser").value;
            var pageNum = document.getElementById("mainCalendar_pagenum").value;
            xmlRequestEvents.open("POST", "ScheduleManager?optype=ALL&idlocation=1" + "&dateutc=" + dateUtc + '&pageNum=' +pageNum + "&browser=" + browser_name);
            xmlRequestEvents.setRequestHeader("Accept-Encoding","text/html; charset=utf-8");
            xmlRequestEvents.send('');

   		}

		function reinitBreakTime(calendar) {
            var d = calendar.date.getDate();
            var m = calendar.date.getMonth()+1;
            var y = calendar.date.getFullYear();
            var _dt = m + "/" + d + "/" + y;
            new Ajax.Request( './getWorkingTime.jsp?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                dt : _dt
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                if(response != ''){
                    var arr = response.replace(/(^\s+)|(\s+$)/g, "").split("#", 2);
                    var break_from = parseFloat(arr[0].replace(/(^\s+)|(\s+$)/g, ""));
                    var break_to = parseFloat(arr[1].replace(/(^\s+)|(\s+$)/g, ""));
//                    var work_time;
//                    var break_from_html = "";
//                    var break_to_html = "";
                    document.getElementById('w_from').options.length=0;
                    document.getElementById('w_to').options.length=0;
                    var j = 0;
                    for(var i = break_from; i <= break_to; i+=0.25){
                        var h = parseInt(i);
                        var m = parseInt((i - h)*60);
                        var s = (h < 10 ? "0" : "") + h + ":" +
                                (m < 10 ? "0" : "") + m + ":00";
                        document.getElementById('w_from').options[j] = new Option(s,j);
                        document.getElementById('w_to').options[j] = new Option(s,j);
//                        break_from_html = break_from_html + "<option value="+ j + ">" + s + "</option>";
                        j++;
                    }
//                    break_to_html = break_from_html;
//                    alert(break_from_html);
//                    alert(document.getElementById('w_from').innerHTML);
//                    alert(document.getElementById('w_to').innerHTML);
//                    document.getElementById('w_from').innerHTML = break_from_html;
//                    document.getElementById('w_to').innerHTML = break_to_html;
//                    alert(document.getElementById('w_from').innerHTML);
//                    alert(document.getElementById('w_to').innerHTML);
                }
                else
                {
                    alert('error on get working time for break');
                }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error until update working time for break: ' + exception);
            }
            });
   		}

		function drawEvents (eventCollection) {

            if (mainCalendar) {
				eval("mainCalendar.events = [" + eventCollection + "]");
				mainCalendar.drawEvents();				
			}
        }

		function drawNewEvents (eventCollectionResponse) {
            var eventCollection2 = [];
            eval("eventCollection2 = [" + eventCollectionResponse + "]");
            if (mainCalendar) {
                mainCalendar.events[mainCalendar.events.length+1] = eventCollection2[0];
				mainCalendar.addNewEvents(eventCollection2);				
			}
        }

		function drawAroundEvents (eventCollectionResponse) {
            var eventCollection1 = [];
            eval("eventCollection1 = [" + eventCollectionResponse + "]");
            if (mainCalendar) {
//				eval("mainCalendar.events = [" + eventCollection1 + "]");
//                alert("Ahtung2");
//                alert(eventCollection1.length);
//                alert(mainCalendar.events.length);
                for (i = 0; i < eventCollection1.length; i++){
                    for (j = 0; j < mainCalendar.events.length; j++){
                        if (mainCalendar.events[j].ServerId == eventCollection1[i].ServerId)
                        {
//                            alert("Ahtung");
                            mainCalendar.events[j] = eventCollection1[i];
//                            alert(eventCollection1[i]);
                            break;
                        }
                    }

                }

				mainCalendar.drawAroundEvents(eventCollectionResponse);
			}
        }

        employees = [
                <%for(int i = 0; i < list_emp.size(); i++) {
                    Employee emp = (Employee)list_emp.get(i);
                %>
                ["<%=emp.getId()%>", "<%=emp.getFname() + " " + emp.getLname()%>"]
                <%
                if (i != list_emp.size() - 1) {
                %>,<%
                }
                }
                %>
        ];

     </script>
     <script>
     </script>

</body>
</html>

