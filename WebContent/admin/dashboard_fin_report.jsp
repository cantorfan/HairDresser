<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.FinancialReport" %><%
    ArrayList arrFR = FinancialReport.findByDay();
   String s = "";
%>
<script language="javascript" type="text/javascript" src="../Js/includes/prototype.js"></script>
<script type="text/javascript">
    function changeSelect()
    {
       build_table(document.getElementById("selectType").value);
    }

    function build_table(type)
    {
        var strTop = "<table id=\"fin_report\" width=\"973\" height=\"56\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">" +
                            "<tr>" +
                            "<td colspan=\"29\">" +
                            "<img src=\"../img/fin_report_new_01.jpg\" width=\"973\" height=\"26\" alt=\"\"></td>" +
                            "</tr>";
        var strBottom =
                "<tr>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"68\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"86\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"83\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"84\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"86\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"75\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"8\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"20\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"54\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"50\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"15\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"47\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                "<td>" +
                "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
                "</tr></table>";
            new Ajax.Request( '../DashBoard?rnd=' + Math.random() * 99999, { method: 'get',
                        parameters: {
                            type: "FINREPORT",
                            type_per: type
                        },
                        onSuccess: function(transport) {
                            var response = new String(transport.responseText);
                            if(response != '')
                            { 
                                document.getElementById('fin_table').innerHTML = strTop + response + strBottom;
                                document.getElementById("fin_report_backgrnd").style.height="533px";
                                document.getElementById("fin_table_botton").style.display="none";
                            }
                            else
                            {

                            }
                        }.bind(this),
                        onException: function(instance, exception){
                            alert('Error: ' + exception);
                        }
                        });
    }
</script>
<table style="width:100%; padding-left:25px;">
<tr style="width:100%">
<td style="text-align:left">
<span style="font-size: 13pt;">Show Financial Report for the past 12</span>
<select id="selectType" style="height: 24px; font-size:13pt;" onchange="changeSelect();">
    <option value="day">Day</option>
    <option value="week">Week</option>
    <option value="mounth">Month</option>
</select>
</td>
</tr>
</table>
<br />
<br />
<div id="fin_report_backgrnd" style="background: url(../img/report_bg.png); width: 985px; height: 558px;">
    <div style="width: 100%; text-align: center; height: 35px; padding-top: 8px; font-size: 16pt; font-weight: normal">
        
    </div>
    <div style="width:100%; padding-top: 10px;" id="fin_table">
    </div>
    <div id="fin_table_botton" style="display:none;" >
        <img src="../img/report_bg_03.png" width="986" height="24" alt="">
    </div>
    <script type="text/javascript">
        build_table(document.getElementById("selectType").value);
    </script>
</div>