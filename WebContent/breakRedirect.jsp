<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.sql.Time" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>

<%
    String date = StringUtils.defaultString(request.getParameter("date"), "");
    int timeh = Integer.parseInt(StringUtils.defaultString(request.getParameter("timeh"), "0"));
    int timem = Integer.parseInt(StringUtils.defaultString(request.getParameter("timem"), "0"));
    int day = Integer.parseInt(StringUtils.defaultString(request.getParameter("day"), "0"));
    int empId = Integer.parseInt(StringUtils.defaultString(request.getParameter("emp_id"), "0"));

    //out.print(date + " " + time + " " + empId.toString());
    ArrayList list = WorkingtimeEmp.findAllByEmployeeIdAndDay(empId, day);
    WorkingtimeEmp wte = (WorkingtimeEmp)list.get(0);
    Time t = new Time(timeh,timem,0);

    // response.sendRedirect
    if(wte.getH_from().after(t) || wte.getH_to().before(t) || wte.getH_to().equals(t) || wte.getH_from().equals(t)){
        response.sendRedirect("admin/edit_employee.jsp?action=edit&id="+Integer.toString(empId));
            return;
//        out.print("admin/edit_employee.jsp?action=edit&id="+empId.toString());
    }
    else{
        ArrayList l = NotWorkingtimeEmp.findAllByEmployeeId(empId);
        int breakId = -1;
        for(int i = 0; i < l.size(); i++){
            NotWorkingtimeEmp nwe = (NotWorkingtimeEmp)l.get(i);
            if((nwe.getH_from().before(t) && nwe.getH_to().after(t)) || nwe.getH_to().equals(t) || nwe.getH_from().equals(t)){
                breakId = nwe.getId();
                break;
            }
        }
        if(breakId != -1)
//            out.print("admin/edit_emptime.jsp?action=edit&id=" + breakId.toString() + "&employee_id="+empId.toString());
            response.sendRedirect("admin/edit_emptime.jsp?action=edit&id=" + Integer.toString(breakId) + "&employee_id="+Integer.toString(empId));
        return;
    }
%>

