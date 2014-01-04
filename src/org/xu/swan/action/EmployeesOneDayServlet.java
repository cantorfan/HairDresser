package org.xu.swan.action;

import org.xu.swan.bean.Cashio;
import org.xu.swan.bean.Reconciliation;
import org.xu.swan.bean.WorkingtimeEmp;
import org.xu.swan.bean.Appointment;
import org.xu.swan.util.DateUtil;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.Timestamp;
import java.sql.Date;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class EmployeesOneDayServlet extends HttpServlet {

    private void returnResponse(HttpServletResponse response, int iID)
    {
        try{
            ArrayList arrWorEmp = WorkingtimeEmp.findAllByEmployeeIdAndType(iID,1);
            String strResponse = "";
            for(int i = 0; i < arrWorEmp.size(); i++)
            {
                WorkingtimeEmp wtemp = (WorkingtimeEmp)arrWorEmp.get(i);
//                strResponse += "<option value='"+wtemp.getId()+"'>"+wtemp.getWork_date()+" "+wtemp.getH_from()+"-"+wtemp.getH_to()+"</option> ";
                if (i>0){
                    strResponse += "%";
                }
                strResponse += wtemp.getId()+"+"+wtemp.getWork_date()+" "+wtemp.getH_from()+"-"+wtemp.getH_to();

            }
            response.getOutputStream().print(strResponse);
        }
        catch(Exception ex)
        {
             ex.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if(action.equals("ADD"))
        {
            String id = request.getParameter("id");
            String fromTime = request.getParameter("fromTime");
            String toTime = request.getParameter("toTime");
            String strDate = request.getParameter("Date");
            try {
                int iIDEmp = Integer.parseInt(id);
                java.util.Date startDay = (new SimpleDateFormat("HH:mm")).parse(fromTime);
                java.util.Date endDay = (new SimpleDateFormat("HH:mm")).parse(toTime);
                java.util.Date dDate = (new SimpleDateFormat("yyyy/MM/dd")).parse(strDate);

                ArrayList wor = WorkingtimeEmp.findByEmployeeIdAndDateTime(iIDEmp, DateUtil.toSqlTime(startDay), DateUtil.toSqlTime(endDay),DateUtil.toSqlDate(dDate));
                if(wor.size() > 0)
                    response.getOutputStream().print("The employee has already been busy at this time");
                else
                    WorkingtimeEmp.insertOneDay(iIDEmp, DateUtil.toSqlTime(startDay), DateUtil.toSqlTime(endDay),DateUtil.toSqlDate(dDate));
                startDay = endDay = dDate = null;

            } catch (Exception ex) {
                ex.printStackTrace();
            }
            //DateUtil.toSqlTime(startMon)
        }
        else if(action.equals("EDIT"))
        {
            String strId = request.getParameter("id");
            String fromTime = request.getParameter("fromTime");
            String toTime = request.getParameter("toTime");
            String strDate = request.getParameter("Date");
            String strIdItem = request.getParameter("idItem");
            try {
                int iIDEmp = Integer.parseInt(strId);
                int iIDItem = Integer.parseInt(strIdItem);
                java.util.Date startDay = (new SimpleDateFormat("HH:mm")).parse(fromTime);
                java.util.Date endDay = (new SimpleDateFormat("HH:mm")).parse(toTime);
                java.util.Date dDate = (new SimpleDateFormat("yyyy/MM/dd")).parse(strDate);

                WorkingtimeEmp.updateOneDay(iIDItem, iIDEmp, DateUtil.toSqlTime(startDay), DateUtil.toSqlTime(endDay),DateUtil.toSqlDate(dDate));
                startDay = endDay = dDate = null;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        else if(action.equals("DEL"))
        {
            String strId = request.getParameter("id");
            String strIdItem = request.getParameter("idItem");
            try {
                int iIDEmp = Integer.parseInt(strId);
                int iIDItem = Integer.parseInt(strIdItem);                

                WorkingtimeEmp.deleteOneDayEmployee(iIDEmp, iIDItem);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        else if(action.equals("REF"))
        {
            String strId = request.getParameter("id");
            try {
                int iID = Integer.parseInt(strId);
                returnResponse(response, iID);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } else if(action.equals("CHECK"))
        {
            String empId = request.getParameter("id");
            String fromTime = request.getParameter("fromTime");
            String toTime = request.getParameter("toTime");
            String strDate = request.getParameter("Date");
            String filter = "";
            filter = " WHERE employee_id='"+empId+"' AND DATE(appt_date)=DATE('"+strDate+"') AND (st_time<'"+fromTime+"' OR et_time>'"+toTime+"') ";
            try {
                ArrayList listApp = Appointment.findByFilter(filter);
                if (listApp.size()>0){
                    response.getOutputStream().print("One day Schedule can not be changed because the employee have already appointment on the regular schedule. Please move the appointment to others employees first, or extend one day schedule time area to include all the area where the appointments already exist.");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
