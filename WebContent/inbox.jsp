<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user_ses = (User) session.getAttribute("user");        
    if (user_ses == null){
        response.sendRedirect("./error.jsp?ec=1");
        return;
    }
    if ((user_ses.getPermission() != Role.R_ADMIN) && (user_ses.getPermission() != Role.R_RECEP) && (user_ses.getPermission() != Role.R_SHD_CHK)){
        response.sendRedirect("./error.jsp?ec=2");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String dt = sdf.format(new java.util.Date());
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>Inbox Page</title>
    <LINK href="css/hd.css" type=text/css rel=stylesheet>
    <link rel="stylesheet" type="text/css" media="all" href="jscalendar/calendar-hd-admin.css" title="hd" />
    <script type="text/javascript" src="Js/includes/prototype.js"></script>
    <script type="text/javascript" src="jscalendar/calendar.js"></script>
    <script type="text/javascript" src="jscalendar/lang/calendar-en.js"></script>
    <script type="text/javascript" src="jscalendar/calendar-setup.js"></script>
    <script type="text/javascript">
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
          function getInboxRecords(){
               new Ajax.Request( 'inbox?rnd=' + Math.random() * 99999, { method: 'get',
                    parameters: {
                        action: "getinbox",
                        from: document.getElementById("from").value,
                        to: document.getElementById("to").value,
                        state: document.getElementById("state").value
                        },
            onSuccess: function(transport) {
                        var response = new String(transport.responseText);
                        if(response == ''){
                                         alert("Debug: Error getInboxRecords");
                        } else {
                            document.getElementById("inboxDiv").innerHTML=response;
                        }
                    }.bind(this),
                    onException: function(instance, exception){
                        alert('getInboxRecords: ' + exception);
                    }
                });
          }

            function action(cust_id, action, id_book, date){
//                document.getElementById("block-on-center").style.display = "";
                document.getElementById('actiontable_'+id_book).style.display="none";
                document.getElementById('loader_'+id_book).style.display="";
//                var onclick_backup = res.onclick;
//                var src_backup = res.src;
//                res.onclick = '';
//                res.src = 'img/loader3.gif';
               new Ajax.Request( 'inbox?rnd=' + Math.random() * 99999, { method: 'get',
                    parameters: {
                        action: action,
//                        from: document.getElementById("from").value,
//                        to: document.getElementById("to").value,
//                        state: document.getElementById("state").value,
                        id:id_book
                        },
            onSuccess: function(transport) {
                        var response = new String(transport.responseText);

                                if (action == 'reshedule'){
                                    if (response!= ''){
                                        alert(response);
                                        document.getElementById('actiontable_'+id_book).style.display="";
                                        document.getElementById('loader_'+id_book).style.display="none";
                                        getInboxRecords();
                                    } else {
                                        document.location.href = "schedule.do?rshd=1&idc="+cust_id+"&idb="+id_book+"&dt="+date;
                                    }
                                } else {
                                    if (response!= '') alert(response);
                                    document.getElementById('actiontable_'+id_book).style.display="";
                                    document.getElementById('loader_'+id_book).style.display="none";
                                    getInboxRecords();
                                }

                    }.bind(this),
                    onException: function(instance, exception){
                        alert('Change status: ' + exception);
                    }
                });
          }
        function changeData(){
            getInboxRecords();
        }
      </script>
  </head>
  <body class="yui-skin-sam" topmargin="0" onload="MM_preloadImages('images/home red.gif','images/schedule red.gif','images/checkout.gif')">
  <div style="text-align:center">
      <div class="main" style = "width:1088px; text-align:left">
            <table width="100%">
                <tr valign="top">
                    <%
                        String activePage = "Inbox";
                        String rootPath = "";
                    %>
                    <%@ include file="top_page.jsp" %>
                </tr>
		    </table>
            <div style="height: 50px; overflow: hidden">
                <%@ include file="menu_main.jsp" %>
            </div>

          <table align="center" width="1100"  border="0" cellspacing="0" cellpadding="3">
                <tr>
                    <td align=center width="300px" height="25"></td>
                    <td align=center width="305px" height="25"><img src="img/inbox_header.png" /></td>
                    <td width="400px" height="25">
                        <table cellspacing=0 cellpadding=0 style="height:40px;font-size:10pt; font-family:Verdana;">
                            <tr>
                                <td >From &nbsp;</td>
                                <td><input readonly id="from" name="from" type="text" value="" style="background: url(img/text2.png); width: 80px; height: 22px; padding: 3px 0px 0px 10px; border: 0; font-size:9pt; background-repeat:no-repeat;" onchange="changeData();" />&nbsp;</td>
                                <td><input id="selDate" name="selDate" type="image" src="img/cal2.png" ></td>
                                <SCRIPT type="text/javascript">
                                            Calendar.setup(
                                            {
                                            inputField  : "from",     // ID of the input field
                                            button      : "selDate",  // ID of the button
                                            showsTime	: false,
                                            electric    : false
                                            }
                                            );
                                </SCRIPT>
                                <td >&nbsp;&nbsp;To&nbsp;&nbsp;</td>
                                <td><input readonly id="to" name="to" type="text" value="" style="background: url(img/text2.png); width: 80px; height: 22px; padding: 3px 0px 0px 10px; border: 0; font-size:9pt; background-repeat:no-repeat;" onchange="changeData();" />&nbsp;</td>
                                <td><input id="selEndDate" name="selEndDate" type="image" src="img/cal2.png" ></td>
                                <SCRIPT type="text/javascript">
                                            Calendar.setup(
                                            {
                                            inputField  : "to",     // ID of the input field
                                            button      : "selEndDate",  // ID of the button
                                            showsTime	: false,
                                            electric    : false
                                            }
                                            );
                                </SCRIPT>
                                <!---->
                                <td>
                                    &nbsp;Inbox&nbsp;
                                </td>
                                <td>
                                    <select style="width:70px;font-size:9pt; font-family:Verdana; height:22px;" id="state" name="state" onchange="changeData();">
                                    <option value = "all">- All -</option>
                                    <option value = "1">Read</option>
                                    <option value = "0" selected >Unread</option>
                                    </select>
                                </td>
                                </tr>
                            </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                    <%--<table class="rec_header" cellpading=0 cellspacing='0' border=0>--%>
                        <%--<tr>--%>
                            <%--<td><img src="img/inbox_id.png" /></td>--%>
                            <%--<td><img src="img/inbox_client.png" /></td>--%>
                            <%--<td><img src="img/inbox_phone.png" /></td>--%>
                            <%--<td><img src="img/inbox_email.png" /></td>--%>
                            <%--<td><img src="img/inbox_service.png" /></td>--%>
                            <%--<td><img src="img/inbox_datetime.png" /></td>--%>
                            <%--<td><img src="img/inbox_action.png" /></td>--%>
                        <%--</tr>--%>
                    <%--</table>--%>
                    <div id="inboxDiv" name="inboxDiv" style="width:100%; height: 480px; overflow-x: hidden; overflow-y:auto">
                        <%--<table class="inbox" cellpading=0 cellspacing='0' border=0>--%>
                            <%--<tr>--%>
                                <%--<td style="width:62px">--%>

                                <%--</td>--%>
                                <%--<td style="width:211px">--%>

                                <%--</td>--%>
                                <%--<td style="width:121px">--%>

                                <%--</td>--%>
                                <%--<td style="width:121px">--%>

                                <%--</td>--%>
                                <%--<td style="width:191px">--%>

                                <%--</td>--%>
                                <%--<td style="width:121px">--%>

                                <%--</td>--%>
                                <%--<td style="width:220px">--%>

                                <%--</td>--%>
                            <%--</tr>--%>
                        <%--</table>--%>
                    </div>
                    </td>
                </tr>
          </table>
      </div>
      <%--<div id="block-on-center"><img src="../img/loader3.gif" border="0" alt=""></div>--%>
  </div>
  <script type="text/javascript">
      getInboxRecords();
  </script>
  </body>
</html>