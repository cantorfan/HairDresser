package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.bean.Appointment;
import org.xu.swan.bean.Ticket;
import org.xu.swan.bean.Reconciliation;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.DateUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;

public class ScheduleAction  extends org.apache.struts.action.Action{
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response) throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");
        
        String id = StringUtils.defaultString(request.getParameter(Appointment.ID),"");
        String cust = StringUtils.defaultString(request.getParameter(Appointment.CUST),"");
        String emp = StringUtils.defaultString(request.getParameter(Appointment.EMP),"");
        String loc = StringUtils.defaultString(request.getParameter(Appointment.LOC),"");
        String svc = StringUtils.defaultString(request.getParameter(Appointment.SVC),"");
        String cate = StringUtils.defaultString(request.getParameter(Appointment.CATE),"");
        String price = StringUtils.defaultString(request.getParameter(Appointment.PRICE),"");
        String appdt = StringUtils.defaultString(request.getParameter(Appointment.APPDT),"");
        String st = StringUtils.defaultString(request.getParameter(Appointment.ST),"");
        String et = StringUtils.defaultString(request.getParameter(Appointment.ET),"");
        String comment = StringUtils.defaultString(request.getParameter(Appointment.COMMENT),"");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            BigDecimal dec = new BigDecimal(Float.parseFloat(price));
//            System.out.println("appointment 2");
            Appointment es = Appointment.insertAppointment(Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp),Integer.parseInt(svc),
                Integer.parseInt(cate),dec, DateUtil.parseSqlDate(appdt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),0,comment, false);
            request.setAttribute("MESSAGE",es!=null?"appointment.added":"appointment.fail");
            request.setAttribute("OBJECT",es);

            if(emp!=null)
                return mapping.findForward("edit");
            else
                return mapping.findForward("add");            
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            BigDecimal dec = new BigDecimal(Float.parseFloat(price));
            Appointment a = Appointment.findById(Integer.parseInt(id));
            if (a!= null && a.getState()!=3){
                Ticket t = Ticket.findTicketById(a.getTicket_id());
                if(t != null){
                    ArrayList arr = Reconciliation.findTransByCode(t.getCode_transaction());
                    if(arr != null && arr.size() > 0){
                        Reconciliation r = (Reconciliation)arr.get(0);
                        if(r != null && r.getStatus() != 0){
                            Appointment es = Appointment.updateAppointment(Integer.parseInt(id),Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp),Integer.parseInt(svc),
                                Integer.parseInt(cate),dec, DateUtil.parseSqlDate(appdt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),0,comment);
                            request.setAttribute("MESSAGE",es!=null?"appointment.edited":"appointment.fail");
                            request.setAttribute("OBJECT",es);
                            return mapping.findForward("edit");
                        }
                    }else{
                        Appointment es = Appointment.updateAppointment(Integer.parseInt(id),Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp),Integer.parseInt(svc),
                            Integer.parseInt(cate),dec, DateUtil.parseSqlDate(appdt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),0,comment);
                        request.setAttribute("MESSAGE",es!=null?"appointment.edited":"appointment.fail");
                        request.setAttribute("OBJECT",es);
                        return mapping.findForward("edit");
                    }
                }else{
                    Appointment es = Appointment.updateAppointment(Integer.parseInt(id),Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp),Integer.parseInt(svc),
                        Integer.parseInt(cate),dec, DateUtil.parseSqlDate(appdt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),0,comment);
                    request.setAttribute("MESSAGE",es!=null?"appointment.edited":"appointment.fail");
                    request.setAttribute("OBJECT",es);
                    return mapping.findForward("edit");
                }
            }
            return mapping.findForward("edit");
        }

        return mapping.findForward("default");
    }
}
