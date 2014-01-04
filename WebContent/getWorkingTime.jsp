<%@ page import="org.xu.swan.bean.WorkingtimeLoc" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.xu.swan.bean.Location" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String dt = StringUtils.defaultString(request.getParameter("dt"), "");
     Calendar cal = new GregorianCalendar();
    if(!dt.equals(""))
        cal.setTime(new Date(dt));
    else{
        cal.setTime(Calendar.getInstance().getTime());
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
    Location loc = Location.GetLocation();
    ArrayList _wtime = (loc != null ? WorkingtimeLoc.findAllByLocationId(loc.getId()) : null);
    WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
    float _from = _wtemp.getH_from().getHours();
    float _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);
%>
<%=_from%>#<%=_to%>