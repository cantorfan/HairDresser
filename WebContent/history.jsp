<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
<%
    String id = StringUtils.defaultString(request.getParameter(Customer.ID), ActionUtil.EMPTY);
    Customer cust = Customer.findById(Integer.parseInt(id));
//    ArrayList list = AppointmentWithProduct.findByCustId(cust.getId());
//
//    HashMap employees = Employee.findAllMap();
//    HashMap services = Service.findAllMapByCode();
//    HashMap products = Inventory.findAllMap();
%>

<div style="width: 1214px; height:750px; background: url(img/mb_bg.png) no-repeat;">
    <br />
    <br />
    <table cellspacing="5" cellpadding="0" border="0" style="margin-left: 36px;margin-right: 36px;" width="1109">
        <tr>
            <td valign=top align="left" style="width: 173px"><img src="img/mb_close.png" alt="" onclick="Modalbox.hide();" /></td>
            <td valign=top colspan="2" align="center" style="width: 509px"><img src="img/mb_header.png" alt="" /></td>
            <td valign=top style="width: 173px">&nbsp;</td>
        </tr>
        <tr>
            <td valign=top >&nbsp;</td>
            <td valign=top ><img src="img/mb_clientname.png" alt="" /></td>
            <td valign=top ><div style="width: 253px; height: 26px; background: url(img/mb_clientname_bg.png); overflow: hidden; color: #FFFFFF; padding-left: 10px; font-size: 14pt"><%=cust.getFname() + " " + cust.getLname()%></div></td>
            <td valign=top >&nbsp;</td>
        </tr>
    </table>
    <table cellspacing="0" cellpadding="0" border="0" style="margin-left: 20px;margin-right: 20px;" width="1160">
    </table>
    <div style="margin-left: 20px;overflow-x: auto; overflow-y: auto; width: 1180px; height: 370px">
<div align="center" id="div_loader"><br><img alt="loading" src="img/loader3.gif"><br><span style="color:white; font-size:8pt;"><b>Please wait. Loading...</b></div>
        <div id="cust_history">

        </div>
    </div>
    <img src="img/mb_hr1.png" alt="" style="margin-left: 40px"/>
</div>
<script type="text/javascript">
                    new Ajax.Request( './schqry?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                query: "cust_history",
                id: "<%=id%>"
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                    if(response == '')
                    {
                         alert("Error get Customer history!");
                    }
                    else
                    {
                        if (document.getElementById("div_loader")) document.getElementById("div_loader").style.display = "none";
                        if (document.getElementById("cust_history")) document.getElementById("cust_history").innerHTML = response;
                    }
            }.bind(this),
            onException: function(instance, exception){
                alert('Error openday type pay: ' + exception);
            }
            });
</script>

