package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.DateUtil;
import org.xu.swan.bean.Appointment;
import org.xu.swan.bean.Ticket;
import org.xu.swan.bean.Reconciliation;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

/**
 * Created by IntelliJ IDEA.
 * User: Paha
 * Date: 11.12.2009
 * Time: 11:05:44
 * To change this template use File | Settings | File Templates.
 */
public class AppointmentAction extends org.apache.struts.action.Action {
        public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Appointment.ID),"");
        String cust_id = StringUtils.defaultString(request.getParameter(Appointment.CUST),"");
        String emp_id = StringUtils.defaultString(request.getParameter(Appointment.EMP),"");
        String serv_id = StringUtils.defaultString(request.getParameter(Appointment.SVC),"");
        String price = StringUtils.defaultString(request.getParameter(Appointment.PRICE),"");
        String location_id = StringUtils.defaultString(request.getParameter(Appointment.LOC),"");
        String category_id = StringUtils.defaultString(request.getParameter(Appointment.CATE),"");
        String appt_date = StringUtils.defaultString(request.getParameter(Appointment.APPDT),"");
        String st_time = StringUtils.defaultString(request.getParameter(Appointment.ST),"");
        String et_time = StringUtils.defaultString(request.getParameter(Appointment.ET),"");
        String comment = StringUtils.defaultString(request.getParameter(Appointment.COMMENT),"");
        Integer loc = 1;

        if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            BigDecimal price_new = new BigDecimal(price);
            Time st = DateUtil.parseSqlTime(st_time);
            Time et = DateUtil.parseSqlTime(et_time);
            Integer state=0;
            Appointment a = Appointment.findById(Integer.parseInt(id));
            if (a!= null){
                loc = a.getLocation_id();
                state = a.getState();
            }
            if (a!= null && a.getState()!=3){
                Ticket t = Ticket.findTicketById(a.getTicket_id());
                if(t != null){
                    ArrayList arr = Reconciliation.findTransByCode(t.getCode_transaction());
                    if(arr != null && arr.size() > 0){
                        Reconciliation r = (Reconciliation)arr.get(0);
                        if(r != null && r.getStatus() != 0){
                            Appointment app = Appointment.updateAppointment(Integer.parseInt(id), loc, Integer.parseInt(cust_id), Integer.parseInt(emp_id), Integer.parseInt(serv_id), Integer.parseInt(category_id), price_new, DateUtil.parseSqlDate(appt_date), st, et, state, comment);
                            request.setAttribute("MESSAGE",app!=null?"appointment.edited":"appointment.fail");
                            request.setAttribute("OBJECT",app);
                            return mapping.findForward("list");
                        }
                    }else{
                        Appointment app = Appointment.updateAppointment(Integer.parseInt(id), loc, Integer.parseInt(cust_id), Integer.parseInt(emp_id), Integer.parseInt(serv_id), Integer.parseInt(category_id), price_new, DateUtil.parseSqlDate(appt_date), st, et, state, comment);
                        request.setAttribute("MESSAGE",app!=null?"appointment.edited":"appointment.fail");
                        request.setAttribute("OBJECT",app);
                        return mapping.findForward("list");
                    }
                }else{
                    Appointment app = Appointment.updateAppointment(Integer.parseInt(id), loc, Integer.parseInt(cust_id), Integer.parseInt(emp_id), Integer.parseInt(serv_id), Integer.parseInt(category_id), price_new, DateUtil.parseSqlDate(appt_date), st, et, state, comment);
                    request.setAttribute("MESSAGE",app!=null?"appointment.edited":"appointment.fail");
                    request.setAttribute("OBJECT",app);
                    return mapping.findForward("list");
                }
            }
            return mapping.findForward("edit");
        }

        return mapping.findForward("default");
    }
}
