package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.bean.Employee;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.bean.EmpServ;
import org.xu.swan.bean.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;

public class EmpServAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(EmpServ.ID),"");
        String emp = StringUtils.defaultString(request.getParameter(EmpServ.EMP),"");
        String svc = StringUtils.defaultString(request.getParameter(EmpServ.SVC),"");
        String price = StringUtils.defaultString(request.getParameter(EmpServ.PRICE),"");
        String dura = StringUtils.defaultString(request.getParameter(EmpServ.DURATION),"");
        String tax = StringUtils.defaultString(request.getParameter(EmpServ.TAX),"");
        String commissionServ = StringUtils.defaultString(request.getParameter(EmpServ.COMMISSION),"");
        String actionall = StringUtils.defaultString(request.getParameter("actionall"),"");
        ArrayList list_service = Service.findAll();

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            if (actionall.equals("1")){
                for (int i = 0; i<list_service.size(); i++){
                    Service serv = (Service)list_service.get(i);
                    EmpServ es = null;
                    Employee empl = null;
                    BigDecimal commis = new BigDecimal(0.0);
                    if (StringUtils.isNotEmpty(emp)) {
                        int emp_id = Integer.parseInt(emp);
                        es = EmpServ.findByEmployeeIdAndServiceID(emp_id,serv.getId());
                        empl = Employee.findById(emp_id);
                        if (empl!=null)
                            commis = empl.getCommission();
                    }
                    if (es == null){
                        es = EmpServ.insertEmpServ(Integer.parseInt(emp),serv.getId(),serv.getPrice(),serv.getDuration(),serv.getTaxes(), commis);
                        request.setAttribute("MESSAGE",es!=null?"empserv.added":"empserv.fail");
                        request.setAttribute("OBJECT",es);
                    }
                }
            }else {
                BigDecimal pay = new BigDecimal(Float.parseFloat(price));
                BigDecimal taxes = new BigDecimal(Float.parseFloat(tax));
                BigDecimal comServ = new BigDecimal(Float.parseFloat(commissionServ));
                Service srv = Service.findById(Integer.parseInt(svc));
                Employee emp2 = Employee.findById(Integer.parseInt(emp));
                if (emp2==null || srv==null) return mapping.findForward("add");
                if (price.equals("-1")) {
                    pay = srv.getPrice();
                }
                if (tax.equals("-1")) {
                    taxes = srv.getTaxes();
                }
                if (commissionServ.equals("-1")) {
                    comServ = emp2.getCommission();
                }
                if (dura.equals("-1")) {
                    dura = Integer.toString(srv.getDuration());
                }
                EmpServ es = EmpServ.findByEmployeeIdAndServiceID(emp2.getId(),Integer.parseInt(svc));
                if (es == null){
                    es = EmpServ.insertEmpServ(Integer.parseInt(emp),Integer.parseInt(svc),pay,Integer.parseInt(dura),taxes, comServ);
                    request.setAttribute("MESSAGE",es!=null?"empserv.added":"empserv.fail");
                    request.setAttribute("OBJECT",es);
                }else{
                    es = EmpServ.updateEmpServ(es.getId(),es.getEmployee_id(),es.getService_id(),pay,Integer.parseInt(dura),taxes, comServ);
                    request.setAttribute("MESSAGE",es!=null?"empserv.added":"empserv.fail");
                    request.setAttribute("OBJECT",es);
                }
            }
            if(emp!=null)
                return mapping.findForward("add");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            BigDecimal pay = new BigDecimal(Float.parseFloat(price));
            BigDecimal taxes = new BigDecimal(Float.parseFloat(tax));
            BigDecimal comServ = new BigDecimal(Float.parseFloat(commissionServ));
            EmpServ es = EmpServ.updateEmpServ(Integer.parseInt(id),Integer.parseInt(emp),Integer.parseInt(svc),pay,Integer.parseInt(dura),taxes, comServ);
            request.setAttribute("MESSAGE",es!=null?"empserv.edited":"empserv.fail");
            request.setAttribute("OBJECT",es);
            return mapping.findForward("add");
        }
        else if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)){
                if (actionall.equals("2")){
                for (int i = 0; i<list_service.size(); i++){
                    Service serv = (Service)list_service.get(i);
                    EmpServ es = null;
                    if (StringUtils.isNotEmpty(emp)) {
                        es = EmpServ.findByEmployeeIdAndServiceID(Integer.parseInt(emp),serv.getId());
                    }
                    if (es != null){
                        int id_es = es.getId();
                        es = EmpServ.deleteEmpServ(id_es);
                        request.setAttribute("MESSAGE",es!=null?"empserv.deleted":"empserv.fail");
                        request.setAttribute("OBJECT",es);
                    }
                }
            }else {
            EmpServ e = EmpServ.findByEmployeeIdAndServiceID(Integer.parseInt(emp), Integer.parseInt(svc));
            EmpServ es = EmpServ.deleteEmpServ(e.getId());
            request.setAttribute("MESSAGE",es!=null?"empserv.deleted":"empserv.fail");
            request.setAttribute("OBJECT",es);
//            return mapping.findForward("delete");
            }
        }
        return mapping.findForward("default");
    }
}
