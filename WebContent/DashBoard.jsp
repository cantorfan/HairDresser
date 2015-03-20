<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="org.xu.swan.util.DateUtil" %>
<%@ page import="org.xu.swan.db.DBManager" %>
<style>
table {
    border: solid 1px black;
    border-right: 0;
    border-bottom: 0;
    font-size: 90%;
}
table td{
    border-bottom: solid 1px black;
    border-right: solid 1px black;
}

table th{
    border-bottom: solid 1px black;
    border-right: solid 1px black;
    text-align:center;
}

input {
    margin: 0;
    padding: 0;
    line-height: 20px;
    height: auto;
    font-size: 10pt;
    background: 0;
    border: 0;
}

input[type=submit] {
    border: solid 1px black;
}
#brieflist TD{
    text-align: center;
    font-size: 7pt;
    padding: 1px;
}
</style>
<%
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
Calendar cal = new GregorianCalendar();

// statistics
int SMonth = Integer.parseInt(StringUtils.defaultString(request.getParameter("SMonth"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("SMonth"),"0"));
int SDay = Integer.parseInt(StringUtils.defaultString(request.getParameter("SDay"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("SDay"),"0"));
int SYear = Integer.parseInt(StringUtils.defaultString(request.getParameter("SYear"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("SYear"),"0"));
String StatisticsPeriod = StringUtils.defaultString(request.getParameter("StatisticsPeriod"), "Average");

java.sql.Date SDate = null;
String ss;
if(SMonth != 0 && SDay != 0 && SYear != 0) {
    ss = Integer.toString(SYear) + "-" + Integer.toString(SMonth) + "-" + Integer.toString(SDay);
    try{
        SDate = new java.sql.Date(sdf.parse(ss).getTime());
    } catch (ParseException e) {
        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
    }
} else {
    SDate = new java.sql.Date(new java.util.Date().getTime());
    ss = SDate.toString();
}

cal.setTime(SDate);
SMonth = cal.get(Calendar.MONTH) + 1;
SDay = cal.get(Calendar.DATE);
SYear = cal.get(Calendar.YEAR);

HashMap stat = new HashMap(); 

DBManager dbm = null;
try {
    dbm = new DBManager();
    if(StatisticsPeriod.equals("Average")){
        PreparedStatement pst;
        ResultSet rs ;

        pst = dbm.getPreparedStatement("select sum(t.c)/count(*) as average from (SELECT count(*) as c FROM appointment group by appt_date) as t LIMIT 1");
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Number of customers per day", new Integer(rs.getInt("average")));
        }

        pst = dbm.getPreparedStatement("select sum(t.c)/count(*) as average from (SELECT count(*) as c FROM appointment group by employee_id) as t LIMIT 1");
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Number of customers per employee", new Integer(rs.getInt("average")));
        }

        pst = dbm.getPreparedStatement("SELECT sum((TIME_TO_SEC(et_time)-TIME_TO_SEC(st_time))/60)/count(*) as min FROM appointment");
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Average appointment time, min", new Integer(rs.getInt("min")));
        }

        pst = dbm.getPreparedStatement("select sum(t.total)/count(t.total) as val from (select sum(total) as total from reconciliation group by id_customer) as t");
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Average profit for a customer, $", new Integer(rs.getInt("val")));
        }
    }else if(StatisticsPeriod.equals("PerDay")){
        PreparedStatement pst;
        ResultSet rs;

        pst = dbm.getPreparedStatement("select sum(t.c)/count(*) as average from (SELECT count(*) as c FROM appointment WHERE appt_date=(?) group by appt_date) as t LIMIT 1");
        pst.setDate(1, SDate);
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Number of customers per day", new Integer(rs.getInt("average")));
        }

        pst = dbm.getPreparedStatement("select sum(t.c)/count(*) as average from (SELECT count(*) as c FROM appointment WHERE appt_date=(?) group by employee_id) as t LIMIT 1");
        pst.setDate(1, SDate);
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Number of customers per employee", new Integer(rs.getInt("average")));
        }

        pst = dbm.getPreparedStatement("SELECT sum((TIME_TO_SEC(et_time)-TIME_TO_SEC(st_time))/60)/count(*) as min FROM appointment WHERE appt_date=(?)");
        pst.setDate(1, SDate);
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Average appointment time, min", new Integer(rs.getInt("min")));
        }

        pst = dbm.getPreparedStatement("select sum(t.total)/count(t.total) as val from (select sum(total) as total from reconciliation WHERE created_dt=(?) group by id_customer) as t");
        pst.setDate(1, SDate);
        rs = pst.executeQuery();
        while(rs.next()){
            stat.put("Average profit for a customer, $", new Integer(rs.getInt("val")));
        }
    }
} catch(Exception e) {
    e.printStackTrace();
} finally {
    if(dbm!=null)
        dbm.close();
}
    


// charts
boolean Appointments = StringUtils.defaultString(request.getParameter("Appointments"), "").equals("on");
boolean Profit = StringUtils.defaultString(request.getParameter("Profit"), "").equals("on");
boolean Customers = StringUtils.defaultString(request.getParameter("Customers"), "").equals("on");
boolean Services = StringUtils.defaultString(request.getParameter("Services"), "").equals("on");
int CFromMonth = Integer.parseInt(StringUtils.defaultString(request.getParameter("CFromMonth"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("CFromMonth"),"0"));
int CFromDay = Integer.parseInt(StringUtils.defaultString(request.getParameter("CFromDay"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("CFromDay"),"0"));
int CFromYear = Integer.parseInt(StringUtils.defaultString(request.getParameter("CFromYear"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("CFromYear"),"0"));
int CToMonth = Integer.parseInt(StringUtils.defaultString(request.getParameter("CToMonth"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("CToMonth"),"0"));
int CToDay = Integer.parseInt(StringUtils.defaultString(request.getParameter("CToDay"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("CToDay"),"0"));
int CToYear = Integer.parseInt(StringUtils.defaultString(request.getParameter("CToYear"), "0").equals("") ? "0" : StringUtils.defaultString(request.getParameter("CToYear"),"0"));

java.sql.Date dateTo = null;
String CTo;
if(CToMonth != 0 && CToDay != 0 && CToYear != 0) {
    CTo = Integer.toString(CToYear) + "-" + Integer.toString(CToMonth) + "-" + Integer.toString(CToDay);
    try{
        dateTo = new java.sql.Date(sdf.parse(CTo).getTime());
    } catch (ParseException e) {
        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
    }
} else {
    dateTo = new java.sql.Date(new java.util.Date().getTime());
    CTo = dateTo.toString();
}

java.sql.Date dateFrom = null;
String CFrom;
if(CFromMonth != 0 && CFromDay != 0 && CFromYear != 0) {
    CFrom = Integer.toString(CFromYear) + "-" + Integer.toString(CFromMonth) + "-" + Integer.toString(CFromDay);
    try{
        dateFrom = new java.sql.Date(sdf.parse(CFrom).getTime());
    } catch (ParseException e) {
        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
    }
} else {
    long a = 2 * 30 * 24 * 60 * 60 * 1000;
    dateFrom = new java.sql.Date(dateTo.getTime() - a);    
    CFrom = dateFrom.toString();
}

cal.setTime(dateFrom);
CFromMonth = cal.get(Calendar.MONTH) + 1;
CFromDay = cal.get(Calendar.DATE);
CFromYear = cal.get(Calendar.YEAR);

cal.setTime(dateTo);
CToMonth = cal.get(Calendar.MONTH) + 1;
CToDay = cal.get(Calendar.DATE);
CToYear = cal.get(Calendar.YEAR);

// brief list
String _sql=" select concat(e.fname, ' ', e.lname) as name, " +
"      /*working time*/ " +
"      CASE when substr(e.schedule, 1, 1)='1' then (select concat(DATE_FORMAT(hfrom,'%H:%i'), ' ', DATE_FORMAT(hto,'%H:%i')) from workingtime_emp where employee_id=e.id AND daynumber=1 LIMIT 1 ) else '-' end as 'Mon', " +
"      CASE when substr(e.schedule, 2, 1)='1' then (select concat(DATE_FORMAT(hfrom,'%H:%i'), ' ', DATE_FORMAT(hto,'%H:%i')) from workingtime_emp where employee_id=e.id AND daynumber=2 LIMIT 1 ) else '-' end as 'Tue', " +
"      CASE when substr(e.schedule, 3, 1)='1' then (select concat(DATE_FORMAT(hfrom,'%H:%i'), ' ', DATE_FORMAT(hto,'%H:%i')) from workingtime_emp where employee_id=e.id AND daynumber=3 LIMIT 1 ) else '-' end as 'Wed', " +
"      CASE when substr(e.schedule, 4, 1)='1' then (select concat(DATE_FORMAT(hfrom,'%H:%i'), ' ', DATE_FORMAT(hto,'%H:%i')) from workingtime_emp where employee_id=e.id AND daynumber=4 LIMIT 1 ) else '-' end as 'Thu', " +
"      CASE when substr(e.schedule, 5, 1)='1' then (select concat(DATE_FORMAT(hfrom,'%H:%i'), ' ', DATE_FORMAT(hto,'%H:%i')) from workingtime_emp where employee_id=e.id AND daynumber=5 LIMIT 1 ) else '-' end as 'Fri', " +
"      CASE when substr(e.schedule, 6, 1)='1' then (select concat(DATE_FORMAT(hfrom,'%H:%i'), ' ', DATE_FORMAT(hto,'%H:%i')) from workingtime_emp where employee_id=e.id AND daynumber=6 LIMIT 1 ) else '-' end as 'Sat', " +
"      CASE when substr(e.schedule, 7, 1)='1' then (select concat(DATE_FORMAT(hfrom,'%H:%i'), ' ', DATE_FORMAT(hto,'%H:%i')) from workingtime_emp where employee_id=e.id AND daynumber=7 LIMIT 1 ) else '-' end as 'Sun', " +
"      /*predefined vars*/ " +
"      ? as weeknumber, " +
"      ? as yearnumber, " +
"      /*appointments*/ " +
"      CASE when substr(e.schedule, 1, 1)='1' then ( select count(*) from appointment where employee_id=e.`id` AND WEEK(appt_date, 1) = weeknumber AND YEAR(appt_date) = yearnumber AND WEEKDAY(appt_date) = 0 LIMIT 1 ) else '-' end as 'AppMon', " +
"      CASE when substr(e.schedule, 2, 1)='1' then ( select count(*) from appointment where employee_id=e.`id` AND WEEK(appt_date, 1) = weeknumber AND YEAR(appt_date) = yearnumber AND WEEKDAY(appt_date) = 1 LIMIT 1 ) else '-' end as 'AppTue', " +
"      CASE when substr(e.schedule, 3, 1)='1' then ( select count(*) from appointment where employee_id=e.`id` AND WEEK(appt_date, 1) = weeknumber AND YEAR(appt_date) = yearnumber AND WEEKDAY(appt_date) = 2 LIMIT 1 ) else '-' end as 'AppWed', " +
"      CASE when substr(e.schedule, 4, 1)='1' then ( select count(*) from appointment where employee_id=e.`id` AND WEEK(appt_date, 1) = weeknumber AND YEAR(appt_date) = yearnumber AND WEEKDAY(appt_date) = 3 LIMIT 1 ) else '-' end as 'AppThu', " +
"      CASE when substr(e.schedule, 5, 1)='1' then ( select count(*) from appointment where employee_id=e.`id` AND WEEK(appt_date, 1) = weeknumber AND YEAR(appt_date) = yearnumber AND WEEKDAY(appt_date) = 4 LIMIT 1 ) else '-' end as 'AppFri', " +
"      CASE when substr(e.schedule, 6, 1)='1' then ( select count(*) from appointment where employee_id=e.`id` AND WEEK(appt_date, 1) = weeknumber AND YEAR(appt_date) = yearnumber AND WEEKDAY(appt_date) = 5 LIMIT 1 ) else '-' end as 'AppSat', " +
"      CASE when substr(e.schedule, 7, 1)='1' then ( select count(*) from appointment where employee_id=e.`id` AND WEEK(appt_date, 1) = weeknumber AND YEAR(appt_date) = yearnumber AND WEEKDAY(appt_date) = 6 LIMIT 1 ) else '-' end as 'AppSun', " +
"      /*customers*/ " +
"      CASE when substr(e.schedule, 1, 1)='1' then ( select count(*) from customer c inner join appointment a on a.customer_id=c.id where a.employee_id=e.`id` AND WEEK(a.appt_date, 1) = weeknumber AND YEAR(a.appt_date) = yearnumber AND WEEKDAY(a.appt_date) = 0 LIMIT 1 ) else '-' end as 'CustMon', " +
"      CASE when substr(e.schedule, 2, 1)='1' then ( select count(*) from customer c inner join appointment a on a.customer_id=c.id where a.employee_id=e.`id` AND WEEK(a.appt_date, 1) = weeknumber AND YEAR(a.appt_date) = yearnumber AND WEEKDAY(a.appt_date) = 1 LIMIT 1 ) else '-' end as 'CustTue', " +
"      CASE when substr(e.schedule, 3, 1)='1' then ( select count(*) from customer c inner join appointment a on a.customer_id=c.id where a.employee_id=e.`id` AND WEEK(a.appt_date, 1) = weeknumber AND YEAR(a.appt_date) = yearnumber AND WEEKDAY(a.appt_date) = 2 LIMIT 1 ) else '-' end as 'CustWed', " +
"      CASE when substr(e.schedule, 4, 1)='1' then ( select count(*) from customer c inner join appointment a on a.customer_id=c.id where a.employee_id=e.`id` AND WEEK(a.appt_date, 1) = weeknumber AND YEAR(a.appt_date) = yearnumber AND WEEKDAY(a.appt_date) = 3 LIMIT 1 ) else '-' end as 'CustThu', " +
"      CASE when substr(e.schedule, 5, 1)='1' then ( select count(*) from customer c inner join appointment a on a.customer_id=c.id where a.employee_id=e.`id` AND WEEK(a.appt_date, 1) = weeknumber AND YEAR(a.appt_date) = yearnumber AND WEEKDAY(a.appt_date) = 4 LIMIT 1 ) else '-' end as 'CustFri', " +
"      CASE when substr(e.schedule, 6, 1)='1' then ( select count(*) from customer c inner join appointment a on a.customer_id=c.id where a.employee_id=e.`id` AND WEEK(a.appt_date, 1) = weeknumber AND YEAR(a.appt_date) = yearnumber AND WEEKDAY(a.appt_date) = 5 LIMIT 1 ) else '-' end as 'CustSat', " +
"      CASE when substr(e.schedule, 7, 1)='1' then ( select count(*) from customer c inner join appointment a on a.customer_id=c.id where a.employee_id=e.`id` AND WEEK(a.appt_date, 1) = weeknumber AND YEAR(a.appt_date) = yearnumber AND WEEKDAY(a.appt_date) = 6 LIMIT 1 ) else '-' end as 'CustSun' " +
"from employee as e " +
"where e.deleted <> 1";

%>
<form action="admin.jsp" method="GET">
<div style="width: 820px; height: 750px">
    <div style="width: 820px; height: 250px; text-align: left">
        <div style="width: 405px; height: 200px; float:left; overflow-y: scroll; border: solid 1px black; padding: 1px; margin: 3px; ">
        <%
            java.util.Date w = new java.util.Date();
            
            cal.setTime(w);            
            java.sql.Date w1 = new java.sql.Date(cal.getTimeInMillis() - (cal.get(Calendar.DAY_OF_WEEK) - 1) * 24 * 60 *60 * 1000);
            java.sql.Date w2 = new java.sql.Date(cal.getTimeInMillis() + (7 - cal.get(Calendar.DAY_OF_WEEK)) * 24 * 60 *60 * 1000);
        %>
            <div style="text-align:center">Week number: <%=cal.get(Calendar.WEEK_OF_YEAR)%>&nbsp;(from '<%=sdf.format(w1)%>' to '<%=sdf.format(w2)%>')</div>        
                <table id="brieflist" cellspacing=0 cellpadding=2 align=center width="370">
                    <tr>
                        <th colspan=2>Employee</th>
                        <th>Mon</th>
                        <th>Tue</th>
                        <th>Wed</th>
                        <th>Thu</th>
                        <th>Fri</th>
                        <th>Sat</th>
                        <th>Sun</th>
                    </tr>
                <%
                try {
                    dbm = new DBManager();
                    PreparedStatement pst;
                    ResultSet rs;
                
                    pst = dbm.getPreparedStatement(_sql);
                    pst.setInt(1, cal.get(Calendar.WEEK_OF_YEAR));
                    pst.setInt(2, cal.get(Calendar.YEAR));
                    rs = pst.executeQuery();
                    while(rs.next()){
                %>
                    <!--data-->
                    <tr>
                        <td rowspan=3><%=rs.getString("name")%></td>
                        <td>WT</td>
                        <td><%=rs.getString("Mon")%></td>
                        <td><%=rs.getString("Tue")%></td>
                        <td><%=rs.getString("Wed")%></td>
                        <td><%=rs.getString("Thu")%></td>
                        <td><%=rs.getString("Fri")%></td>
                        <td><%=rs.getString("Sat")%></td>
                        <td><%=rs.getString("Sun")%></td>
                    </tr>
                    <tr>
                        <td>App</td>
                        <td><%=rs.getString("AppMon")%></td>
                        <td><%=rs.getString("AppTue")%></td>
                        <td><%=rs.getString("AppWed")%></td>
                        <td><%=rs.getString("AppThu")%></td>
                        <td><%=rs.getString("AppFri")%></td>
                        <td><%=rs.getString("AppSat")%></td>
                        <td><%=rs.getString("AppSun")%></td>
                    </tr>
                    <tr>
                        <td>Cust</td>
                        <td><%=rs.getString("CustMon")%></td>
                        <td><%=rs.getString("CustTue")%></td>
                        <td><%=rs.getString("CustWed")%></td>
                        <td><%=rs.getString("CustThu")%></td>
                        <td><%=rs.getString("CustFri")%></td>
                        <td><%=rs.getString("CustSat")%></td>
                        <td><%=rs.getString("CustSun")%></td>
                    </tr>
                    <!--/data-->
                <%
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    if(dbm!=null)
                        dbm.close();
                }
                %>            
              </table>
        </div>
        <div style="width: 395px; height: 200px; float:right; border: solid 1px black; paddin: 2px; margin: 3px;">
                <div style="width: 375px; height: 100px; overflow-y: scroll;">
                    <table cellspacing=0 cellpadding=2 align=center width="340">
                        <%
                        Iterator statIterator = stat.keySet().iterator();
                        while (statIterator.hasNext()) {
                            String key = (String)statIterator.next();
                            Integer value = (Integer)stat.get(key);
                        %>
                        <tr>
                            <td><%=key%></td>
                            <td><%=value%></td>
                        </tr>
                        <%}%>
                    </table>
                </div>
                <input type="radio" value="Average" name="StatisticsPeriod" id="AverageSP" <%=StatisticsPeriod.equals("Average") ? "checked=\"checked\"" : ""%> />Average<br />
                <input type="radio" value="PerDay" name="StatisticsPeriod" id="PerDaySP" <%=StatisticsPeriod.equals("PerDay") ? "checked=\"checked\"" : ""%> />Per day
                <select name="SMonth" id="SMonth">
                    <option value="1" <%=SMonth == 1 ? "selected" : ""%>>January</option>
                    <option value="2" <%=SMonth == 2 ? "selected" : ""%>>February</option>
                    <option value="3" <%=SMonth == 3 ? "selected" : ""%>>March</option>
                    <option value="4" <%=SMonth == 4 ? "selected" : ""%>>April</option>
                    <option value="5" <%=SMonth == 5 ? "selected" : ""%>>May</option>
                    <option value="6" <%=SMonth == 6 ? "selected" : ""%>>June</option>
                    <option value="7" <%=SMonth == 7 ? "selected" : ""%>>July</option>
                    <option value="8" <%=SMonth == 8 ? "selected" : ""%>>August</option>
                    <option value="9" <%=SMonth == 9 ? "selected" : ""%>>September</option>
                    <option value="10" <%=SMonth == 10 ? "selected" : ""%>>October</option>
                    <option value="11" <%=SMonth == 11 ? "selected" : ""%>>November</option>
                    <option value="12" <%=SMonth == 12 ? "selected" : ""%>>December</option>
                </select>
                <select name="SDay" id="SDay">
                    <option value="1" <%=SDay == 1 ? "selected" : ""%>>1</option>
                    <option value="2" <%=SDay == 2 ? "selected" : ""%>>2</option>
                    <option value="3" <%=SDay == 3 ? "selected" : ""%>>3</option>
                    <option value="4" <%=SDay == 4 ? "selected" : ""%>>4</option>
                    <option value="5" <%=SDay == 5 ? "selected" : ""%>>5</option>
                    <option value="6" <%=SDay == 6 ? "selected" : ""%>>6</option>
                    <option value="7" <%=SDay == 7 ? "selected" : ""%>>7</option>
                    <option value="8" <%=SDay == 8 ? "selected" : ""%>>8</option>
                    <option value="9" <%=SDay == 9 ? "selected" : ""%>>9</option>
                    <option value="10" <%=SDay == 10 ? "selected" : ""%>>10</option>
                    <option value="11" <%=SDay == 11 ? "selected" : ""%>>11</option>
                    <option value="12" <%=SDay == 12 ? "selected" : ""%>>12</option>
                    <option value="13" <%=SDay == 13 ? "selected" : ""%>>13</option>
                    <option value="14" <%=SDay == 14 ? "selected" : ""%>>14</option>
                    <option value="15" <%=SDay == 15 ? "selected" : ""%>>15</option>
                    <option value="16" <%=SDay == 16 ? "selected" : ""%>>16</option>
                    <option value="17" <%=SDay == 17 ? "selected" : ""%>>17</option>
                    <option value="18" <%=SDay == 18 ? "selected" : ""%>>18</option>
                    <option value="19" <%=SDay == 19 ? "selected" : ""%>>19</option>
                    <option value="20" <%=SDay == 20 ? "selected" : ""%>>20</option>
                    <option value="21" <%=SDay == 21 ? "selected" : ""%>>21</option>
                    <option value="22" <%=SDay == 22 ? "selected" : ""%>>22</option>
                    <option value="23" <%=SDay == 23 ? "selected" : ""%>>23</option>
                    <option value="24" <%=SDay == 24 ? "selected" : ""%>>24</option>
                    <option value="25" <%=SDay == 25 ? "selected" : ""%>>25</option>
                    <option value="26" <%=SDay == 26 ? "selected" : ""%>>26</option>
                    <option value="27" <%=SDay == 27 ? "selected" : ""%>>27</option>
                    <option value="28" <%=SDay == 28 ? "selected" : ""%>>28</option>
                    <option value="29" <%=SDay == 29 ? "selected" : ""%>>29</option>
                    <option value="30" <%=SDay == 30 ? "selected" : ""%>>30</option>
                    <option value="31" <%=SDay == 31 ? "selected" : ""%>>31</option>
                </select>
                <select name="SYear" id="SYear">
                    <option value="2007" <%=SYear == 2007 ? "selected" : ""%>>2007</option>
                    <option value="2008" <%=SYear == 2008 ? "selected" : ""%>>2008</option>
                    <option value="2009" <%=SYear == 2009 ? "selected" : ""%>>2009</option>
                    <option value="2010" <%=SYear == 2010 ? "selected" : ""%>>2010</option>
                    <option value="2011" <%=SYear == 2011 ? "selected" : ""%>>2011</option>
                </select>
                <input type="submit" name="Recalc" value="Recalc" />
        </div>
    </div>
    <div style="width: 810px; height: 500px; border: solid 1px black; padding: 2px; margin: 3px;">
                <div style="width: 800px; height: 405px">
                    <div style="width: 605px; height: 405px; float: left;">
                        <img src="../chart?from=<%=CFrom%>&to=<%=CTo%>" width=600 height=400 border=0/>
                    </div>
                    <div style="width: 150px; height: 200px; float: right; overflow: hidden; text-align:left">
                        <input type="checkbox" name="Appointments"/>Appointments<br />
                        <input type="checkbox" name="Profit" />Profit<br />
                        <input type="checkbox" name="Customers" />Customers<br />
                        <input type="checkbox" name="Services" />Services<br />
                    </div>
                </div>
                From:
                <select name="CFromMonth" id="CFromMonth">
                    <option value="1" <%=CFromMonth == 1 ? "selected" : ""%>>January</option>
                    <option value="2" <%=CFromMonth == 2 ? "selected" : ""%>>February</option>
                    <option value="3" <%=CFromMonth == 3 ? "selected" : ""%>>March</option>
                    <option value="4" <%=CFromMonth == 4 ? "selected" : ""%>>April</option>
                    <option value="5" <%=CFromMonth == 5 ? "selected" : ""%>>May</option>
                    <option value="6" <%=CFromMonth == 6 ? "selected" : ""%>>June</option>
                    <option value="7" <%=CFromMonth == 7 ? "selected" : ""%>>July</option>
                    <option value="8" <%=CFromMonth == 8 ? "selected" : ""%>>August</option>
                    <option value="9" <%=CFromMonth == 9 ? "selected" : ""%>>September</option>
                    <option value="10" <%=CFromMonth == 10 ? "selected" : ""%>>October</option>
                    <option value="11" <%=CFromMonth == 11 ? "selected" : ""%>>November</option>
                    <option value="12" <%=CFromMonth == 12 ? "selected" : ""%>>December</option>
                </select>
                <select name="CFromDay" id="CFromDay">
                    <option value="1" <%=CFromDay == 1 ? "selected" : ""%>>1</option>
                    <option value="2" <%=CFromDay == 2 ? "selected" : ""%>>2</option>
                    <option value="3" <%=CFromDay == 3 ? "selected" : ""%>>3</option>
                    <option value="4" <%=CFromDay == 4 ? "selected" : ""%>>4</option>
                    <option value="5" <%=CFromDay == 5 ? "selected" : ""%>>5</option>
                    <option value="6" <%=CFromDay == 6 ? "selected" : ""%>>6</option>
                    <option value="7" <%=CFromDay == 7 ? "selected" : ""%>>7</option>
                    <option value="8" <%=CFromDay == 8 ? "selected" : ""%>>8</option>
                    <option value="9" <%=CFromDay == 9 ? "selected" : ""%>>9</option>
                    <option value="10" <%=CFromDay == 10 ? "selected" : ""%>>10</option>
                    <option value="11" <%=CFromDay == 11 ? "selected" : ""%>>11</option>
                    <option value="12" <%=CFromDay == 12 ? "selected" : ""%>>12</option>
                    <option value="13" <%=CFromDay == 13 ? "selected" : ""%>>13</option>
                    <option value="14" <%=CFromDay == 14 ? "selected" : ""%>>14</option>
                    <option value="15" <%=CFromDay == 15 ? "selected" : ""%>>15</option>
                    <option value="16" <%=CFromDay == 16 ? "selected" : ""%>>16</option>
                    <option value="17" <%=CFromDay == 17 ? "selected" : ""%>>17</option>
                    <option value="18" <%=CFromDay == 18 ? "selected" : ""%>>18</option>
                    <option value="19" <%=CFromDay == 19 ? "selected" : ""%>>19</option>
                    <option value="20" <%=CFromDay == 20 ? "selected" : ""%>>20</option>
                    <option value="21" <%=CFromDay == 21 ? "selected" : ""%>>21</option>
                    <option value="22" <%=CFromDay == 22 ? "selected" : ""%>>22</option>
                    <option value="23" <%=CFromDay == 23 ? "selected" : ""%>>23</option>
                    <option value="24" <%=CFromDay == 24 ? "selected" : ""%>>24</option>
                    <option value="25" <%=CFromDay == 25 ? "selected" : ""%>>25</option>
                    <option value="26" <%=CFromDay == 26 ? "selected" : ""%>>26</option>
                    <option value="27" <%=CFromDay == 27 ? "selected" : ""%>>27</option>
                    <option value="28" <%=CFromDay == 28 ? "selected" : ""%>>28</option>
                    <option value="29" <%=CFromDay == 29 ? "selected" : ""%>>29</option>
                    <option value="30" <%=CFromDay == 30 ? "selected" : ""%>>30</option>
                    <option value="31" <%=CFromDay == 31 ? "selected" : ""%>>31</option>
                </select>
                <select name="CFromYear" id="CFromYear">
                    <option value="2007" <%=CFromYear == 2007 ? "selected" : ""%>>2007</option>
                    <option value="2008" <%=CFromYear == 2008 ? "selected" : ""%>>2008</option>
                    <option value="2009" <%=CFromYear == 2009 ? "selected" : ""%>>2009</option>
                    <option value="2010" <%=CFromYear == 2010 ? "selected" : ""%>>2010</option>
                    <option value="2011" <%=CFromYear == 2011 ? "selected" : ""%>>2011</option>
                </select> <br />
                &nbsp;&nbsp;&nbsp;&nbsp;To:
                <select name="CToMonth" id="CToMonth">
                    <option value="1" <%=CToMonth == 1 ? "selected" : ""%>>January</option>
                    <option value="2" <%=CToMonth == 2 ? "selected" : ""%>>February</option>
                    <option value="3" <%=CToMonth == 3 ? "selected" : ""%>>March</option>
                    <option value="4" <%=CToMonth == 4 ? "selected" : ""%>>April</option>
                    <option value="5" <%=CToMonth == 5 ? "selected" : ""%>>May</option>
                    <option value="6" <%=CToMonth == 6 ? "selected" : ""%>>June</option>
                    <option value="7" <%=CToMonth == 7 ? "selected" : ""%>>July</option>
                    <option value="8" <%=CToMonth == 8 ? "selected" : ""%>>August</option>
                    <option value="9" <%=CToMonth == 9 ? "selected" : ""%>>September</option>
                    <option value="10" <%=CToMonth == 10 ? "selected" : ""%>>October</option>
                    <option value="11" <%=CToMonth == 11 ? "selected" : ""%>>November</option>
                    <option value="12" <%=CToMonth == 12 ? "selected" : ""%>>December</option>
                </select>
                <select name="CToDay" id="CToDay">
                    <option value="1" <%=CToDay == 1 ? "selected" : ""%>>1</option>
                    <option value="2" <%=CToDay == 2 ? "selected" : ""%>>2</option>
                    <option value="3" <%=CToDay == 3 ? "selected" : ""%>>3</option>
                    <option value="4" <%=CToDay == 4 ? "selected" : ""%>>4</option>
                    <option value="5" <%=CToDay == 5 ? "selected" : ""%>>5</option>
                    <option value="6" <%=CToDay == 6 ? "selected" : ""%>>6</option>
                    <option value="7" <%=CToDay == 7 ? "selected" : ""%>>7</option>
                    <option value="8" <%=CToDay == 8 ? "selected" : ""%>>8</option>
                    <option value="9" <%=CToDay == 9 ? "selected" : ""%>>9</option>
                    <option value="10" <%=CToDay == 10 ? "selected" : ""%>>10</option>
                    <option value="11" <%=CToDay == 11 ? "selected" : ""%>>11</option>
                    <option value="12" <%=CToDay == 12 ? "selected" : ""%>>12</option>
                    <option value="13" <%=CToDay == 13 ? "selected" : ""%>>13</option>
                    <option value="14" <%=CToDay == 14 ? "selected" : ""%>>14</option>
                    <option value="15" <%=CToDay == 15 ? "selected" : ""%>>15</option>
                    <option value="16" <%=CToDay == 16 ? "selected" : ""%>>16</option>
                    <option value="17" <%=CToDay == 17 ? "selected" : ""%>>17</option>
                    <option value="18" <%=CToDay == 18 ? "selected" : ""%>>18</option>
                    <option value="19" <%=CToDay == 19 ? "selected" : ""%>>19</option>
                    <option value="20" <%=CToDay == 20 ? "selected" : ""%>>20</option>
                    <option value="21" <%=CToDay == 21 ? "selected" : ""%>>21</option>
                    <option value="22" <%=CToDay == 22 ? "selected" : ""%>>22</option>
                    <option value="23" <%=CToDay == 23 ? "selected" : ""%>>23</option>
                    <option value="24" <%=CToDay == 24 ? "selected" : ""%>>24</option>
                    <option value="25" <%=CToDay == 25 ? "selected" : ""%>>25</option>
                    <option value="26" <%=CToDay == 26 ? "selected" : ""%>>26</option>
                    <option value="27" <%=CToDay == 27 ? "selected" : ""%>>27</option>
                    <option value="28" <%=CToDay == 28 ? "selected" : ""%>>28</option>
                    <option value="29" <%=CToDay == 29 ? "selected" : ""%>>29</option>
                    <option value="30" <%=CToDay == 30 ? "selected" : ""%>>30</option>
                    <option value="31" <%=CToDay == 31 ? "selected" : ""%>>31</option>
                </select>
                <select name="CToYear" id="CToYear">
                    <option value="2007" <%=CToYear == 2007 ? "selected" : ""%>>2007</option>
                    <option value="2008" <%=CToYear == 2008 ? "selected" : ""%>>2008</option>
                    <option value="2009" <%=CToYear == 2009 ? "selected" : ""%>>2009</option>
                    <option value="2010" <%=CToYear == 2010 ? "selected" : ""%>>2010</option>
                    <option value="2011" <%=CToYear == 2011 ? "selected" : ""%>>2011</option>
                </select> <br />
                <input type="submit" name="RedrawCharts" value="Redraw charts">
    </div>
</div>
</form>
