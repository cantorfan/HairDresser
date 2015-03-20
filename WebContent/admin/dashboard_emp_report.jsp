<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.xu.swan.bean.Employee" %>
<%@ page import="org.xu.swan.bean.Service" %>
<%@ page import="org.xu.swan.bean.Inventory" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="java.util.*" %>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String dt = sdf.format(Calendar.getInstance().getTime());
    HashMap mapEmployee = Employee.findAllMapWithDeleted();
    HashMap mapService = Service.findAllMapByCode();
    HashMap mapProduct = Inventory.findAllMap();
    ArrayList listEmployee = Employee.findWorkingEmp(dt, dt, (User) session.getAttribute("user"));
    ArrayList listService= Service.findBuyingSvc(dt, dt);
    ArrayList listProduct = Inventory.findBuyingProd(dt, dt);
%>
<script language="javascript" type="text/javascript" src="../Js/includes/prototype.js"></script>
<script type="text/javascript">
    function changeData(){
//        dataload('0','0');

        var fromdt = document.getElementById("startdate").value;
        var todt = document.getElementById("enddate").value;
        new Ajax.Request( '../DashBoard?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                type: "CALCVALUES",
                fromdt: fromdt,
                todt: todt
            },
            onSuccess: function(transport) {
                var response = new String(transport.responseText);
                if (response!=null && response != '') {
                    document.getElementById("calcValues").innerHTML=response;
                }
            }.bind(this),
            onException: function(instance, exception){
                alert('CALCVALUES Error: ' + exception);
            }
        });


    }
    function refresh(){
        dataload('0', '0');

        var fromdt = document.getElementById("startdate").value;
        var todt = document.getElementById("enddate").value;
       new Ajax.Request( '../DashBoard?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                type: "FINTOTAL",
                fromdt: fromdt,
                todt: todt
                },
        onSuccess: function(transport) {
            var response = new String(transport.responseText);
            if (response!=null && response != '') {
                document.getElementById("fin_table").innerHTML=response;
//                    document.getElementById("fin_report_table").height="56";
                document.getElementById("fin_report_backgrnd").style.height="140px";
                document.getElementById("fin_table_botton").style.display="";
            }
        }.bind(this),
            onException: function(instance, exception){
            alert('FINTOTAL Error: ' + exception);
            }
        });
    }
    function dataload(act, id){
//        alert("work!");
//        if (act == 5 && document.getElementById("empckb").checked) return;
//        if (act == 6 && document.getElementById("servckb").checked) return;
//        if (act == 7 && document.getElementById("prodckb").checked) return;
        showDiv("divEmp", false);
        showDiv("divSvc",false);
        showDiv("divProd",false);

        var fromdt = document.getElementById("startdate").value;
        var todt = document.getElementById("enddate").value;
        var idprod = document.getElementById("prod_id").value;
        var idserv = document.getElementById("serv_id").value;
        var listidemp = "";
        if (document.getElementById("empckb").checked){
            listidemp = document.getElementById("listEmpl").value;
        } else{
            var chkEmp = document.getElementById("checkEmployee").getElementsByTagName("input");
            var chk = false;
            for (var i=0; i< chkEmp.length; i++){
                if (chkEmp[i].type == 'checkbox'){

                if (chkEmp[i].checked){
                    if (chk){
                        listidemp = listidemp + "," + chkEmp[i].id;
                    } else {
                        listidemp = listidemp + chkEmp[i].id;
                        chk = true;
                    }
                }
                }
            }
//            listidemp = document.getElementById("selEmp").value;
        }
        var listidserv = "";
        if (document.getElementById("servckb").checked){
            listidserv = document.getElementById("listServ").value;
        } else{
            var chkSvc = document.getElementById("checkService").getElementsByTagName("input");
            var chk2 = false;
            for (var i=0; i< chkSvc.length; i++){
                if (chkSvc[i].type == 'checkbox'){
                    if (chkSvc[i].checked){
                        if (chk2){
                            listidserv = listidserv + "," + chkSvc[i].id;
                        } else {
                            listidserv = listidserv + chkSvc[i].id;
                            chk2 = true;
                        }
                    }
                }
            }
//            listidserv = document.getElementById("selSvc").value;
        }
        var listidprod = "";
        if (document.getElementById("prodckb").checked){
            listidprod = document.getElementById("listProd").value;
        } else{
            var chkPrd = document.getElementById("checkProduct").getElementsByTagName("input");
            var chk3 = false;
            for (var i in chkPrd){
                for (var i=0; i< chkPrd.length; i++){
                    if (chkPrd[i].type == 'checkbox'){
                        if (chk3){
                            listidprod = listidprod + "," + chkPrd[i].id;
                        } else {
                            listidprod = listidprod + chkPrd[i].id;
                            chk3 = true;
                        }
                    }
                }
            }
//            listidprod = document.getElementById("selProd").value;
        }
        var action = "getData";
        switch (act){
            case '0': action = "getData"; break;
            case '1': action = "getNextSvc";
                    idserv = id;
                break;
            case '2': action = "getPrevSvc";
                    idserv = id;
                break;
            case '3': action = "getNextProd";
                    idprod = id;
                break;
            case '4': action = "getPrevProd";
                    idprod = id;
                break;
            case '5': action = "getData"; break;
            case '6': action = "getData"; break;
            case '7': action = "getData"; break;
        }
        var taxe = document.getElementById("taxeckb").checked;
        document.getElementById("div_loader").style.display = "";
        new Ajax.Request( '../DashBoard?rnd=' + Math.random() * 99999, { method: 'get',
            parameters: {
                type: "EMPREPORT",
                action: action,
                fromdt: fromdt,
                todt: todt,
                listidemp: listidemp,
                listidserv: listidserv,
                listidprod: listidprod,
                taxe: taxe,
                idserv: idserv,
                idprod: idprod
                },
        onSuccess: function(transport) {
            var response = new String(transport.responseText);
//            alert(response);
            if (response!=null && response != '') {
                if (response.indexOf("REDIRECT") != -1){
                    var arr = response.split(":");
                    document.location.href = arr[1].toString();

                }else{
                    document.getElementById("emp_report_div").innerHTML=response;
                    document.getElementById("div_loader").style.display = "none";


                }
            }
        }.bind(this),
            onException: function(instance, exception){
            document.getElementById("div_loader").style.display = "none";
            alert('EMPREPORT Error: ' + exception);
            }
        });


    }

    function Print_Report()
    {
        p_start_date = document.getElementById("startdate").value;
        p_end_date = document.getElementById("enddate").value;
        p_service_id=document.getElementById("serv_id").value;
        p_product_id= document.getElementById("prod_id").value;
        flag = document.getElementById("taxeckb").checked;
        type = document.getElementById("selectType").value;

        document.location.href='../report?query=dashboard_report&startdate='+p_start_date+'&enddate='+p_end_date+'&p_service_id='+p_service_id+'&p_product_id='+p_product_id+'&flag='+flag+'&type='+type;
    }

    function Print_Report_all()
    {
        var p_start_date = document.getElementById("startdate").value;
        var p_end_date = document.getElementById("enddate").value;
        var listidemp;
        if (document.getElementById("empckb").checked){
            listidemp = document.getElementById("listEmpl").value;
        } else{
            var chkEmp = document.getElementById("checkEmployee").getElementsByTagName("input");
            var chk = false;
            for (var i=0; i< chkEmp.length; i++){
                if (chkEmp[i].type == 'checkbox'){
                    if (chkEmp[i].checked){
                        if (chk){
                            listidemp = listidemp + "," + chkEmp[i].id;
                        } else {
                            listidemp = listidemp + chkEmp[i].id;
                            chk = true;
                        }
                    }
                }
            }
//            listidemp = document.getElementById("selEmp").value;
        }
        if (listidemp.length > 0){
//        var emp_id_arr = listidemp.split(',');
//        var emp_id = emp_id_arr[0];
        //alert(emp_id_arr[0]);


        document.location.href='../report?query=dashboard_report_all&startdate='+p_start_date+'&enddate='+p_end_date+'&emp_id_list='+listidemp;
        } else {
            alert('ERRROR: Please select a Employee.');
        }
    }

    function empAll_chb(){
        if (document.getElementById("empckb").checked){
            var chkEmp = document.getElementById("checkEmployee").getElementsByTagName("input");
            for (var i=0; i< chkEmp.length; i++){
			if (chkEmp[i].type == 'checkbox'){
                chkEmp[i].checked = false;
            }
            }
        }
    }

    function emp_chb(ckb){
        if (ckb.checked){
            document.getElementById("empckb").checked = false;
        }else{
            var chkEmp = document.getElementById("checkEmployee").getElementsByTagName("input");
            var chk = false;
            for (var i=0; i< chkEmp.length; i++){
                if (chkEmp[i].type == 'checkbox'){
                    if (chkEmp[i].checked){
                        chk = true;
                    }
                }
            }
            if (!chk) document.getElementById("empckb").checked = true;
        }
    }

    function prodAll_chb(){
        if (document.getElementById("prodckb").checked){
            var chkProd = document.getElementById("checkProduct").getElementsByTagName("input");
            for (var i=0; i< chkProd.length; i++){
                if (chkProd[i].type == 'checkbox'){
                    chkProd[i].checked = false;
                }
            }
        }
    }

    function prod_chb(ckb){
        if (ckb.checked){
            document.getElementById("prodckb").checked = false;
        }else{
            var chkProd = document.getElementById("checkProduct").getElementsByTagName("input");
            var chk = false;
            for (var i=0; i< chkProd.length; i++){
                if (chkProd[i].type == 'checkbox'){
                    if (chkProd[i].checked){
                        chk = true;
                    }
                }
            }
            if (!chk) document.getElementById("prodckb").checked = true;
        }
    }

    function servAll_chb(){
        if (document.getElementById("servckb").checked){
            var chkServ = document.getElementById("checkService").getElementsByTagName("input");
            for (var i=0; i< chkServ.length; i++){
                if (chkServ[i].type == 'checkbox'){
                    chkServ[i].checked = false;
                }
            }
        }
    }

    function serv_chb(ckb){
        if (ckb.checked){
            document.getElementById("servckb").checked = false;
        }else{
            var chkServ = document.getElementById("checkService").getElementsByTagName("input");
            var chk = false;
            for (var i=0; i< chkServ.length; i++){
                if (chkServ[i].type == 'checkbox'){
                    if (chkServ[i].checked){
                        chk = true;
                    }
                }
            }
            if (!chk) document.getElementById("servckb").checked = true;
        }
    }

    function showDiv(idDiv, show){
        var div = document.getElementById(idDiv);
        if (div != null){
            if (show){
                if (div.style.display == "none"){
                    div.style.display = "";
                    var listidemp = "";
                    if (!document.getElementById("empckb").checked){
                        var chkEmp = document.getElementById("checkEmployee").getElementsByTagName("input");
                        var chk = false;
                        for (var i in chkEmp){
                            if (chkEmp[i].checked){
                                if (chk){
                                    listidemp = listidemp + "," + chkEmp[i].id;
                                } else {
                                    listidemp = listidemp + chkEmp[i].id;
                                    chk = true;
                                }
                            }
                        }
                    document.getElementById("savelistemp").value = listidemp;
                    }
                    var listidserv = "";
                    if (!document.getElementById("servckb").checked){
                        var chkSvc = document.getElementById("checkService").getElementsByTagName("input");
                        var chk2 = false;
                        for (var i in chkSvc){
                            if (chkSvc[i].checked){
                                if (chk2){
                                    listidserv = listidserv + "," + chkSvc[i].id;
                                } else {
                                    listidserv = listidserv + chkSvc[i].id;
                                    chk2 = true;
                                }
                            }
                        }
                    document.getElementById("savelistsvc").value = listidserv;
                    }
                    var listidprod = "";
                    if (!document.getElementById("prodckb").checked){
                        var chkPrd = document.getElementById("checkProduct").getElementsByTagName("input");
                        var chk3 = false;
                        for (var i in chkPrd){
                            if (chkPrd[i].checked){
                                if (chk3){
                                    listidprod = listidprod + "," + chkPrd[i].id;
                                } else {
                                    listidprod = listidprod + chkPrd[i].id;
                                    chk3 = true;
                                }
                            }
                        }
                    document.getElementById("savelistprod").value = listidprod;
                    }
					/*
                    alert('prod'+document.getElementById("savelistprod").value);
                    alert('svc'+document.getElementById("savelistsvc").value);
                    alert('emp'+document.getElementById("savelistemp").value);
                    */
                } else {
                    var refresh= false;
                    var listidemp = "";
                    if (!document.getElementById("empckb").checked){
                        var chkEmp = document.getElementById("checkEmployee").getElementsByTagName("input");
                        var chk = false;
                        for (var i in chkEmp){
                            if (chkEmp[i].checked){
                                if (chk){
                                    listidemp = listidemp + "," + chkEmp[i].id;
                                } else {
                                    listidemp = listidemp + chkEmp[i].id;
                                    chk = true;
                                }
                            }
                        }
                    if ((document.getElementById("savelistemp").value!='' || listidemp!='') && document.getElementById("savelistemp").value != listidemp){
                        refresh = true;
                    }
                    }
                    var listidserv = "";
                    if (!document.getElementById("servckb").checked && !refresh){
                        var chkSvc = document.getElementById("checkService").getElementsByTagName("input");
                        var chk2 = false;
                        for (var i in chkSvc){
                            if (chkSvc[i].checked){
                                if (chk2){
                                    listidserv = listidserv + "," + chkSvc[i].id;
                                } else {
                                    listidserv = listidserv + chkSvc[i].id;
                                    chk2 = true;
                                }
                            }
                        }
                        if ((document.getElementById("savelistsvc").value!= '' || listidserv!='') && document.getElementById("savelistsvc").value != listidserv){
                            refresh = true;
                        }
                    }
                    var listidprod = "";
                    if (!document.getElementById("prodckb").checked && !refresh){
                        var chkPrd = document.getElementById("checkProduct").getElementsByTagName("input");
                        var chk3 = false;
                        for (var i in chkPrd){
                            if (chkPrd[i].checked){
                                if (chk3){
                                    listidprod = listidprod + "," + chkPrd[i].id;
                                } else {
                                    listidprod = listidprod + chkPrd[i].id;
                                    chk3 = true;
                                }
                            }
                        }
                        if ((document.getElementById("savelistprod").value!= '' || listidprod!='') && document.getElementById("savelistprod").value != listidprod){
                            refresh = true;
                        }
                    }

//                    alert('prod'+document.getElementById("savelistprod").value+"---"+listidprod);
//                    alert('svc'+document.getElementById("savelistsvc").value+"---"+listidserv);
//                    alert('emp'+document.getElementById("savelistemp").value+"---"+listidemp);

                    div.style.display = "none";
                    if (refresh){
                        dataload('0','0');
                    }
                }
            }else {
                div.style.display = "none";
            }
        }
    }
</script>
<div style="height:20px;">

</div>
<div>
<table cellspacing=0 cellpadding=3 style="height:40px;font-size:14pt">
    <tr>
        <td style="font-size: 13pt;">From &nbsp;&nbsp;</td>
        <td><input readonly id="startdate" name="startdate" type="text" value="<%=dt%>" style="background: url(../img/text1.png); width: 75px; height: 22px; padding: 3px 0px 0px 10px; border: 0; font-size:13px;background-repeat:no-repeat;" onchange="changeData();" />&nbsp;</td>
        <td><input id="selDate" name="selDate" type="image" src="../img/cal1.png" ></td>
        <SCRIPT type="text/javascript">
                    Calendar.setup(
                    {
                    inputField  : "startdate",     // ID of the input field
                    button      : "selDate",  // ID of the button
                    showsTime	: false,
                    electric    : false
                    }
                    );
        </SCRIPT>
        <td style="font-size: 13pt;">&nbsp;&nbsp;&nbsp;To&nbsp;&nbsp;</td>
        <td><input readonly id="enddate" name="enddate" type="text" value="<%=dt%>" style="background: url(../img/text1.png); width: 75px; height: 22px; padding: 3px 0px 0px 10px; border: 0; font-size:13px;background-repeat:no-repeat;" onchange="changeData();" />&nbsp;</td>
        <td><input id="selEndDate" name="selEndDate" type="image" src="../img/cal1.png" ></td>
        <SCRIPT type="text/javascript">
                    Calendar.setup(
                    {
                    inputField  : "enddate",     // ID of the input field
                    button      : "selEndDate",  // ID of the button
                    showsTime	: false,
                    electric    : false
                    }
                    );
        </SCRIPT>
        <!---->
        <td>&nbsp;&nbsp;<img src="../img/vline1.png" />&nbsp;&nbsp;</td>
        <td style="font-size: 13pt;">
            Employee
        <%--<select id="selEmp" style="width: 70px; height: 22px;" onchange="dataload('5');">--%>
        <%--<%--%>
            <%--for (int i=0; i<listEmployee.size();i++) {--%>
            <%--%><option value="<%=listEmployee.get(i)%>"><%=mapEmployee.get(listEmployee.get(i))%></option>--%>
            <%--<%--%>
            <%--}--%>
        <%--%>--%>
        <%--</select>--%>
        </td>
        <td>&nbsp;<img style="vertical-align:middle;" src="../img/emp_icon.png" onclick="showDiv('divEmp', true);"/></td>
        <td>&nbsp;&nbsp;<input style="vertical-align:middle; margin-top: 3px; border:0;" id="empckb" name="empckb" type="checkbox" checked onclick="empAll_chb();" <%--onclick="dataload('0','0');"--%> />&nbsp;</td>
        <td style="font-size: 13pt;">All</td>
        <!---->
        <td>&nbsp;&nbsp;<img src="../img/vline1.png" />&nbsp;&nbsp;</td>
        <td style="font-size: 13pt;">
            Service
        <%--<select id="selSvc" style="width: 70px; height: 22px;" onchange="dataload('6');">--%>
        <%--<%--%>
            <%--for (int i=0; i<listService.size();i++) {--%>
            <%--%><option value="<%=listService.get(i)%>"><%=mapService.get(listService.get(i))%></option>--%>
            <%--<%--%>
            <%--}--%>
        <%--%>--%>
        <%--</select>--%>
        </td>
        <td>&nbsp;<img style="vertical-align:middle;" src="../img/serv_icon.png" onclick="showDiv('divSvc', true);"/></td>
        <td>&nbsp;&nbsp;<input style="vertical-align:middle; margin-top: 3px; border:0;" id="servckb" name="servckb" type="checkbox" onclick="servAll_chb();" checked <%--onclick="dataload('0','0');"--%> />&nbsp;</td>
        <td style="font-size: 13pt;">All</td>
        <!---->
        <td>&nbsp;&nbsp;&nbsp;<img style="vertical-align:middle; margin-top: 3px; border:0;" src="../img/vline1.png" />&nbsp;&nbsp;</td>
        <td style="font-size: 13pt;">
            Product
        <%--<select id="selProd" style="width: 70px; height: 22px;" onchange="dataload('7');">--%>
        <%--<%--%>
            <%--for (int i=0; i<listProduct.size();i++) {--%>
            <%--%><option value="<%=listProduct.get(i)%>"><%=mapProduct.get(listProduct.get(i))%></option>--%>
            <%--<%--%>
            <%--}--%>
        <%--%>--%>
        <%--</select>--%>
        </td>
        <td>&nbsp;<img style="vertical-align:middle;" src="../img/prod_icon.png" onclick="showDiv('divProd', true);"/></td>
        <td>&nbsp;&nbsp;<input style="vertical-align:middle; margin-top: 3px; border:0;" id="prodckb" name="prodckb" type="checkbox" onclick="prodAll_chb();" checked <%--onclick="dataload('0','0');"--%> />&nbsp;</td>
        <td style="font-size: 13pt;">All</td>
        <!---->
        <td>&nbsp;&nbsp;<img src="../img/vline1.png" />&nbsp;&nbsp;</td>
        <td><input style="vertical-align:middle; margin-top: 3px; border:0;" id="taxeckb" name="taxeckb" type="checkbox" checked <%--onclick="dataload('0','0');"--%> />&nbsp;</td>
        <td style="font-size: 13pt;">Taxes
        </td>
        <td>&nbsp;&nbsp;<img src="../img/vline1.png" />&nbsp;&nbsp;</td>
        <td><a href="#"><img onclick="refresh();" height="20" width="80" longdesc="../img/refresh_dash.png" src="../img/refresh_dash.png" title="Refresh" alt="Refresh"></a></td>
        <%--<td><button type="button" onclick="refresh();" style="height: 26px; width: 70px; font-size: 10pt;">Refresh</button></td>--%>
    </tr>
</table>
    <div id="calcValues">
            <div id="divEmp" style="display:none; position:absolute; margin-left: 405px; " >
                <table height="100" cellspacing="0" cellpadding="0" border="0" width="155" id="Table_dropdown">
                    <tr>
                        <td rowspan="3">
                            <img height="104" width="15" alt="" src="../img/dd_dropdown_01.png"/></td>
                        <td>
                            <img height="2" width="155" alt="" src="../img/dd_dropdown_02.png"/></td>
                    </tr>
                    <tr>
                        <td>
                            <!--img src="img/dd_dropdown_03.png" width="275" height="265" alt=""-->
                            <div id="checkEmployee" style="text-align:left; background: transparent url(../img/dd_dropdown_03.png) repeat scroll 0% 0%; overflow: auto; -moz-background-clip: border; -moz-background-origin: padding; -moz-background-inline-policy: continuous; width: 155px; height: 100px;">
                                <%
                                    String le = "";
                                    String id = "";
                                    String name = "";
                                    String nameCut = "";
                                    for (int i=0; i<listEmployee.size();i++) {
                                        Employee emp = (Employee)listEmployee.get(i);
                                        id =  String.valueOf(emp.getId());
                                        if (i == 0){
                                            le = id;
                                        }
                                        else {
                                            le = le + "," + id;
                                        }
                                        name = emp.getFname() + " " + emp.getLname();
                                        nameCut = name.length()<13?name:name.substring(0,12);
                                    %>
                                <input id="<%=id%>" onclick="emp_chb(this);" type="checkbox" style="border:0; height: 10px;  margin-right: 3px;" title="<%=name%>"/><%=nameCut%><br/>
                                <%--<option value="<%=listProduct.get(i)%>"><%=mapProduct.get(listProduct.get(i))%></option>--%>
                                    <%
                                    }
                                %>
                                <input type="hidden" name="listEmpl" id="listEmpl" value="<%=le%>">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img height="2" width="155" alt="" src="../img/dd_dropdown_04.png"/></td>
                    </tr>
                </table>
            </div>
            <div id="divSvc" style="display:none; position:absolute;  margin-left: 580px; " >
                <table height="100" cellspacing="0" cellpadding="0" border="0" width="140" id="Table_dropdown2">
                    <tr>
                        <td rowspan="3">
                            <img height="104" width="15" alt="" src="../img/dd_dropdown_01.png"/></td>
                        <td>
                            <img height="2" width="140" alt="" src="../img/dd_dropdown_02.png"/></td>
                    </tr>
                    <tr>
                        <td>
                            <!--img src="img/dd_dropdown_03.png" width="275" height="265" alt=""-->
                            <div id="checkService" style="text-align:left; background: transparent url(../img/dd_dropdown_03.png) repeat scroll 0% 0%; overflow: auto; -moz-background-clip: border; -moz-background-origin: padding; -moz-background-inline-policy: continuous; width: 140px; height: 100px;">
                                <%
                                    String ls = "";
                                    for (int i=0; i<listService.size();i++) {
                                        Service svc = (Service)listService.get(i);
                                        id = String.valueOf(svc.getId());
                                        if (i == 0){
                                            ls = id;
                                        }
                                        else {
                                            ls = ls + "," + id;
                                        }
                                        name = svc.getName();
                                        nameCut = name.length()<13?name:name.substring(0,12);
                                    %>
                                <input id="<%=id%>" type="checkbox" onclick="serv_chb(this);" style="border:0; height: 10px;  margin-right: 3px;" title="<%=name%>"/><%=nameCut%><br/>
                                <%--<option value="<%=listProduct.get(i)%>"><%=mapProduct.get(listProduct.get(i))%></option>--%>
                                    <%
                                    }
                                %>
                            </div>
                            <input type="hidden" name="listServ" id="listServ" value="<%=ls%>">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img height="2" width="140" alt="" src="../img/dd_dropdown_04.png"/></td>
                    </tr>
                </table>
            </div>
            <div id="divProd" style="display:none; position:absolute; margin-left: 737px; " >
                <table height="100" cellspacing="0" cellpadding="0" border="0" width="140" id="Table_dropdown3">
                    <tr>
                        <td rowspan="3">
                            <img height="104" width="15" alt="" src="../img/dd_dropdown_01.png"/></td>
                        <td>
                            <img height="2" width="140" alt="" src="../img/dd_dropdown_02.png"/></td>
                    </tr>
                    <tr>
                        <td>
                            <!--img src="img/dd_dropdown_03.png" width="275" height="265" alt=""-->
                            <div id="checkProduct" style="text-align:left; background: transparent url(../img/dd_dropdown_03.png) repeat scroll 0% 0%; overflow: auto; -moz-background-clip: border; -moz-background-origin: padding; -moz-background-inline-policy: continuous; width: 140px; height: 100px;">
                                <%
                                    String lp = "";
                                    for (int i=0; i<listProduct.size();i++) {
                                        Inventory prod = (Inventory)listProduct.get(i);
                                        id = String.valueOf(prod.getId());
                                        if (i == 0){
                                            lp = id;
                                        }
                                        else {
                                            lp = lp + "," + id;
                                        }
                                        name = prod.getName();
                                        nameCut = name.length()<13?name:name.substring(0,12);
                                    %>
                                <input id="<%=id%>" type="checkbox" onclick="prod_chb(this);" style="border:0; height: 10px;  margin-right: 3px;" title="<%=name%>"/><%=nameCut%><br/>
                                <%--<option value="<%=listProduct.get(i)%>"><%=mapProduct.get(listProduct.get(i))%></option>--%>
                                    <%
                                    }
                                %>
                            </div>
                            <input type="hidden" name="listProd" id="listProd" value="<%=lp%>">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img height="2" width="140" alt="" src="../img/dd_dropdown_04.png"/></td>
                    </tr>
                </table>
            </div>
        </div>

</div>
<input type="hidden" id="savelistprod" name="savelistprod" value=""/>
<input type="hidden" id="savelistemp" name="savelistemp" value=""/>
<input type="hidden" id="savelistsvc" name="savelistsvc" value=""/>
<div>
<table id="Table_01" width="985" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="985px" height="45px" style="background: url(../img/report_bg_01.png) no-repeat; text-align: center; font-size: 16pt">
			<!--img src="img/report_bg_01.png" width="779" height="36" alt=""-->
			EMPLOYEE REPORT
        </td>
	</tr>
	<tr>
		<td width="1000" style="background: url(../img/report_bg_02.png) repeat-y;">
    <div id="emp_report_div">
    <table id="emp_report_table" width="957" border="0" cellpadding="0" cellspacing="0">

                    <input type="hidden" value="0" id="prod_id" name="prod_id"/>
                    <input type="hidden" value="0" id="prev_prod_id" name="prev_prod_id"/>
                    <input type="hidden" value="0" id="next_prod_id" name="next_prod_id"/>

                    <input type="hidden" value="0" id="serv_id" name="serv_id"/>
                    <input type="hidden" value="0" id="prev_serv_id" name="prev_serv_id"/>
                    <input type="hidden" value="0" id="next_serv_id" name="next_serv_id"/>
	<tr>
		<td colspan="45">
			<img src="../img/emp_report_01.png" width="957" height="16" alt=""></td>
	</tr>
	<tr>
		<td colspan="45">
			<img src="../img/emp_report_02.png" width="957" height="4" alt=""></td>
	</tr>
	<tr>
		<td colspan="2">
			<img src="../img/emp_report_03.png" width="58" height="32" alt=""></td>
		<td colspan="2">
			<img src="../img/emp_report_04.png" width="17" height="32" alt=""></td>
		<td colspan="5" style="text-align:center;font-size:10pt;background-color:white;">
		<%--//service	--%>
        </td>
		<td>
			<img src="../img/emp_report_06.png" width="17" height="32" alt=""></td>
		<td>
			<img src="../img/emp_report_07.png" width="3" height="32" alt=""></td>
		<td colspan="5">
			<img src="../img/emp_report_08.png" width="146" height="32" alt=""></td>
		<td>
			<img src="../img/emp_report_09.png" width="18" height="32" alt=""></td>
		<td colspan="5" style="text-align:center;font-size:10pt;background-color:white;">
        <%--//product	--%>
        </td>
		<td>
			<img src="../img/emp_report_11.png" width="17" height="32" alt=""></td>
		<td colspan="5">
			<img src="../img/emp_report_12.png" width="137" height="32" alt=""></td>
		<td colspan="17" rowspan="3">
			<img src="../img/emp_report_13.png" width="344" height="47" alt=""></td>
	</tr>
	<tr>
		<td colspan="28">
			<img src="../img/emp_report_14.png" width="613" height="3" alt=""></td>
	</tr>
	<tr>
		<td colspan="28">
			<img src="../img/emp_report_15.png" width="613" height="12" alt=""></td>
	</tr>
	<tr>
		<td colspan="45">
			<img src="../img/emp_report_16.png" width="957" height="3" alt=""></td>
	</tr>
	<tr>
		<td colspan="3">
			<img src="../img/emp_report_54.png" width="59" height="22" alt=""></td>
		<td colspan="2">
			<img src="../img/emp_report_55.png" width="33" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_56.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_57.png" width="39" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_58.png" width="2" height="22" alt=""></td>
		<td colspan="2">
			<img src="../img/emp_report_59.png" width="58" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_60.png" width="3" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_61.png" width="66" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_62.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_63.png" width="55" height="22" alt=""></td>
		<td colspan="2">
			<img src="../img/emp_report_64.png" width="23" height="22" alt=""></td>
		<td colspan="2">
			<img src="../img/emp_report_65.png" width="33" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_66.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_67.png" width="39" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_68.png" width="2" height="22" alt=""></td>
		<td colspan="2">
			<img src="../img/emp_report_69.png" width="58" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_70.png" width="4" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_71.png" width="65" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_72.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_73.png" width="55" height="22" alt=""></td>
		<td colspan="3">
			<img src="../img/emp_report_74.png" width="30" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_75.png" width="38" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_76.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_77.png" width="36" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_78.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_79.png" width="34" height="22" alt=""></td>
		<td colspan="3">
			<img src="../img/emp_report_80.png" width="30" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_81.png" width="44" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_82.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_83.png" width="51" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_84.png" width="2" height="22" alt=""></td>
		<td>
			<img src="../img/emp_report_85.png" width="68" height="22" alt=""></td>
		<td colspan="2">
			<img src="../img/emp_report_86.png" width="16" height="22" alt=""></td>
	</tr>
	<tr>
		<td colspan="45">
			<img src="../img/emp_report_87.png" width="957" height="5" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="../img/spacer.gif" width="54" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="4" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="1" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="16" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="17" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="39" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="41" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="17" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="3" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="66" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="55" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="11" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="12" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="18" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="15" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="39" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="41" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="17" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="4" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="65" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="55" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="11" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="10" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="9" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="38" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="36" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="34" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="11" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="10" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="9" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="44" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="51" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="2" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="68" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="11" height="1" alt=""></td>
		<td>
			<img src="../img/spacer.gif" width="5" height="1" alt=""></td>
	</tr>
</table>
    </div>
    <div id="div_loader" align="center" style="display:none;"><br/><img src="../img/loader2.gif" alt="loading"><br/><b>Please wait. Loading...</b></div>
    <div style="text-align: right; padding-right: 10px; padding-top: 10px">
        <a href="#"><img onclick="Print_Report_all();" height="20" width="80" longdesc="../img/print_dash.png" src="../img/print_dash.png" title="Refresh" alt="Refresh"></a>

        <%--<input type="button" value="Print" onclick="Print_Report_all();"/>--%>
    </div>
        </td>
	</tr>
	<tr>
		<td>
			<img src="../img/report_bg_03.png" width="985" height="24" alt=""></td>
	</tr>
</table>
<br/>
<hr width="985px" style="height: 1px; color:#000;" />
<script type="text/javascript">
    dataload('0','0');
</script>
</div>