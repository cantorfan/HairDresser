package org.xu.dyve.action.schedule;

import org.xu.swan.bean.Employee;
import org.xu.swan.bean.NotWorkingtimeEmp;
import org.xu.swan.bean.WorkingtimeEmp;
import org.xu.swan.bean.WorkingtimeLoc;
import org.xu.swan.util.DateUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.sql.Time;

public class ScheduleServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (request.getParameter("optype") != null) {
            String operation = request.getParameter("optype");

            int idLocation = Integer.parseInt(request.getParameter("idlocation"));
            int pageNum = Integer.parseInt(request.getParameter("pageNum"));
            Date calendarDate = null;

            try {
                calendarDate = (new SimpleDateFormat("yyyy/MM/dd")).parse(request.getParameter("calendar"));
            } catch (Exception ex) {

            }
            int day = calendarDate.getDay();
            if (day == 0)
                day = day + 7;

            if (operation.equals("EMPLIST") && calendarDate != null && idLocation != -1) {
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(this.getEmployees(idLocation, day, pageNum, calendarDate));
            }
        }
    }

    private String getEmployees(int locationId, int dayOfWeek, int pageNum, Date calendarDate) {
        StringBuilder employeeJsObjects = new StringBuilder();

        ArrayList<Employee> employeeList = (ArrayList<Employee>) Employee.findAllByLocAndDayAndDate(locationId, dayOfWeek, pageNum, new java.sql.Date(calendarDate.getTime()));
        //System.out.println("employeeList.size= " + employeeList.size());
        int columnWidthPercent;
        int count = employeeList.size();
        if (count > 0)
            columnWidthPercent = 100 / 8;//count;
        else
            columnWidthPercent = 100;
        Calendar cal = new GregorianCalendar();
        cal.setTime(calendarDate);
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
        ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(locationId);
        WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
        int _from = _wtemp.getH_from().getHours();
        int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

        /*int _from = 24;
        int _to = 0;

        ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(locationId);
        for(int i = 0; i < 7; i++)
        {
            WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

            double __from = wtemp.getH_from().getHours();
            _from = (int)(__from < _from ? __from : _from);

            double min = wtemp.getH_to().getMinutes() / 60.0f;
            min = min > 0 ? 1 : 0;
            double __to = wtemp.getH_to().getHours() +  min;
            _to = (int)(__to > _to ? __to : _to);
        }*/

        for (int i = 0; i < count; i++) {
            Employee emp = employeeList.get(i);
            ArrayList<NotWorkingtimeEmp> NWTEmpList = (ArrayList<NotWorkingtimeEmp>) NotWorkingtimeEmp.findAllByEmployeeIdAndDate(emp.getId(), DateUtil.toSqlDate(calendarDate));
            ArrayList<WorkingtimeEmp> wtimeList = (ArrayList<WorkingtimeEmp>) WorkingtimeEmp.findByEmpIdAndDate(emp.getId(), DateUtil.toSqlDate(calendarDate));
            int from = 0;
            int to = 0;
            Time H_from = null;
            Time H_to = null;
            String coment = "";
            NotWorkingtimeEmp NWTEnew = null;
            if (emp.getOneday() && wtimeList.size()>0){
                from = (wtimeList.get(0).getH_from().getHours() - /*8*/ _from) * 4 + wtimeList.get(0).getH_from().getMinutes() / 15;
                to = (wtimeList.get(0).getH_to().getHours() - /*8*/ _from) * 4 + wtimeList.get(0).getH_to().getMinutes() / 15;
//                coment = wtimeList.get(0).getComment().replaceAll("'","&#39;");
                H_from = wtimeList.get(0).getH_from();
                H_to = wtimeList.get(0).getH_to();
                if (wtimeList.size()>1){
                    for (int k=1; k < wtimeList.size(); k++){
                        if (H_to.before(wtimeList.get(k).getH_from())){
                            NWTEnew = new NotWorkingtimeEmp();
                            NWTEnew.setH_from(H_to);
                            NWTEnew.setH_to(wtimeList.get(k).getH_from());
                            NWTEnew.setComment("");
                            NWTEnew.setW_date(DateUtil.toSqlDate(calendarDate));
                            NWTEnew.setEmployee_id(emp.getId());
                            NWTEmpList.add(NWTEnew);
                        }
//                        if (wtimeList.get(k).getH_from().before(H_from)){
//                            H_from = wtimeList.get(k).getH_from();
//                        }
//                        if (wtimeList.get(k).getH_to().after(H_to)){
//                            H_to = wtimeList.get(k).getH_to();
//                        }
                          H_to = wtimeList.get(k).getH_to();
                    }
                    from = (H_from.getHours() - /*8*/ _from) * 4 + H_from.getMinutes() / 15;
                    to = (H_to.getHours() - /*8*/ _from) * 4 + H_to.getMinutes() / 15;
                }
            } else {
                WorkingtimeEmp wtime = WorkingtimeEmp.findByEmpIdAndDay(emp.getId(), dayOfWeek);
//            from = (wtime.getH_from().getHours() - 9) * 4 + wtime.getH_from().getMinutes() / 15;
//            to = (wtime.getH_to().getHours() - 9) * 4 + wtime.getH_to().getMinutes() / 15;
                from = (wtime.getH_from().getHours() - /*8*/ _from) * 4 + wtime.getH_from().getMinutes() / 15; // for esalonsoft/vogue
                to = (wtime.getH_to().getHours() - /*8*/ _from) * 4 + wtime.getH_to().getMinutes() / 15;       // for esalonsoft/vogue
                if (wtime != null && wtime.getComment() != null){
                    coment = wtime.getComment().replaceAll("'","&#39;");
                }
            }

            String image;
            List nwtf = new ArrayList();
            List nwtt = new ArrayList();
            List nwtc = new ArrayList();
            for (int j = 0; j < NWTEmpList.size(); j++) {
//                nwtf.add(j, (NWTEmpList.get(j).getH_from().getHours() - 9) * 4 + NWTEmpList.get(j).getH_from().getMinutes() / 15);
//                nwtt.add(j, (NWTEmpList.get(j).getH_to().getHours() - 9) * 4 + NWTEmpList.get(j).getH_to().getMinutes() / 15);
                nwtf.add(j, (NWTEmpList.get(j).getH_from().getHours() - /*8*/ _from) * 4 + NWTEmpList.get(j).getH_from().getMinutes() / 15); // for esalonsoft/vogue
                nwtt.add(j, (NWTEmpList.get(j).getH_to().getHours() - /*8*/ _from) * 4 + NWTEmpList.get(j).getH_to().getMinutes() / 15);     // for esalonsoft/vogue
                nwtc.add(j, NWTEmpList.get(j).getComment());
            }

//            if (emp.getPicture() != null) {
                image = "<IMG height='20' width = '20' alt='Photo' src= './admin/ShowPhoto.do?id=" + (emp != null ? String.valueOf(emp.getId()) : "") + "'><br>";
//            } else image = "<br>";
            String name = emp.getFname().replaceAll("'","&#39;");
            if (emp.getLname() != null && emp.getLname().length() > 0)
                name += " " + emp.getLname().replaceAll("'","&#39;").substring(0,1);
//            name = "<a href=#>" + name + "</a>";
            employeeJsObjects.append("" +
                    "{" +
                    "\"Width\":\"" + columnWidthPercent + "\"," +
                    "\"ToolTip\":\"" + emp.getLname() + " " + emp.getFname() + "\"," +
                    "\"Comment\":\"" + coment + "\"," +
                    "\"EmpId\":\"" + emp.getId() + "\"," +
                    "\"EmpComment\":\"" + coment + "\"," +
                    "\"Name\":\"" + name + "\"," +
                    "\"HFrom\":\"" + from + "\"," +
                    "\"HTo\":\"" + to + "\"," +
                    "\"NWTF\":\"" + nwtf + "\"," +                                                                  ///NotWorkingTimeFrom
                    "\"NWTT\":\"" + nwtt + "\"," +                                                                  ///NotWorkingTimeTo
                    "\"NWTC\":\"" + nwtc + "\"," +                                                                  ///NotWorkingTimeTo
                    "\"InnerHTML\":\"" + image + name + "\"," +
                    "\"Date\":\"September 1, 2008 10:00:00 +0000\"," +
                    "\"Value\":\"" + emp.getId() + "\"," +
                    "\"BackColor\":\"#ECE9D8\"" +
                    "}"
            );
            if (i != 7) {
                employeeJsObjects.append(",");
            }
        }

        if (count < 8) {
            employeeJsObjects.append("" +
                    "{" +
                    "\"Width\":\"" + columnWidthPercent * (8 - count) + "\"," +
                    "\"ToolTip\":\"" + "" + "\"," +
                    "\"Comment\":\"" + "" + "\"," +
                    "\"EmpId\":\"" + "" + "\"," +
                    "\"EmpComment\":\"" + "" + "\"," +
                    "\"Name\":\"" + "" + "\"," +
                    "\"HFrom\":\"" + 0 + "\"," +
                    "\"HTo\":\"" + 0 + "\"," +
                    "\"NWTF\":\"" + "[]" + "\"," +                                                                  ///NotWorkingTimeFrom
                    "\"NWTT\":\"" + "[]" + "\"," +                                                                  ///NotWorkingTimeTo
                    "\"NWTC\":\"" + "[]" + "\"," +                                                                  ///NotWorkingTimeTo
                    "\"InnerHTML\":\"" + "" + "\"," +
                    "\"Date\":\"September 1, 2008 10:00:00 +0000\"," +
                    "\"Value\":\"" + 0 + "\"," +
                    "\"BackColor\":\"#ACB9B8\"" +
                    "}"
            );
        }
        return employeeJsObjects.toString();
    }
}
