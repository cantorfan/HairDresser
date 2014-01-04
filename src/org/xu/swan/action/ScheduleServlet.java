package org.xu.swan.action;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;
import org.xu.swan.bean.*;
import org.xu.swan.util.DateUtil;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.Html2Text;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.ServletException;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.text.DateFormat;

public class ScheduleServlet extends HttpServlet {
    protected Logger logger = LogManager.getLogger(getClass());

    public void init() {
        System.out.println("ScheduleServlet initialized.");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String query = StringUtils.defaultString(request.getParameter("query"), "");

        try{
            if(query.equalsIgnoreCase("contact")){
                String action = StringUtils.defaultString(request.getParameter("action"), "");
                String cont_id = StringUtils.defaultString(request.getParameter("cont_id"), "");
                String fname = StringUtils.defaultString(request.getParameter("fname"), "");
                String lname = StringUtils.defaultString(request.getParameter("lname"), "");
                String phone = StringUtils.defaultString(request.getParameter("phone"), "");
                String cell = StringUtils.defaultString(request.getParameter("cell"), "");
                String email = StringUtils.defaultString(request.getParameter("email"), "");
                //String req = StringUtils.defaultString(request.getParameter("req"), "");
                Boolean req = false;
//                System.out.println("req = " + request.getParameter("req"));
                if (request.getParameter("req").equals("true"))
                    req = true;
                if(StringUtils.isNotEmpty(action)){
                    String resp = "";
                    if(action.equalsIgnoreCase("new")){
//                        System.out.println("4 "+req.toString());
                        Customer cust = Customer.insertCustomer(fname,lname,email,phone,cell,"",1,req, false, 0, "", 0, "", 0, "", "", "", "", null, null, 0);//TODO location
                        resp = "new=" + cust.getId();
                    }
                    else if(action.equalsIgnoreCase("edit")){
                        Customer cust = Customer.updateCustomer(Integer.parseInt(cont_id),fname,lname,email,phone,cell,"",1,req, false, 0, "", 0, "", 0,"", "", "", "", null, null, 0);
                        resp = "edit=" + cust.getId();
                    }
                    response.getWriter().write(resp);
                }
                else{
                    ArrayList list = null;
                    if(StringUtils.isNotEmpty(fname)){
                        fname = fname.replace("'","");
                        list = Customer.findByFilter(Customer.FNAME + "='" + fname + "'");
                    }
                    if(StringUtils.isNotEmpty(lname)){
                        lname = lname.replace("'","");
                        list = Customer.findByFilter(Customer.LNAME + "='" + lname + "'");
                    }
                    if(StringUtils.isNotEmpty(phone) && phone.matches("(\\w|-)*")){
                        phone = phone.replace("'","");
                        list = Customer.findByFilter(Customer.PHONE + "='" + phone + "'");
                    }
                    if(StringUtils.isNotEmpty(cell) && cell.matches("(\\w|-)*")){
                        cell = cell.replace("'","");
                        list = Customer.findByFilter(Customer.CELL + "='" + cell + "'");
                    }
                    if(StringUtils.isNotEmpty(email)){//TODO  && email.matches("(\\s)*")
                        email = email.replace("'","");
                        list = Customer.findByFilter(Customer.EMAIL + "='" + email + "'");
                    }
                    if(StringUtils.isNotEmpty(req.toString())){
                        //req = req.replace("'","");
                        list = Customer.findByFilter(Customer.REQ + "='" + req + "'");
                    }
                    StringBuffer sb = new StringBuffer();
                    String delim = "$$";//delimiter
                    String separ = ";;";//separator
                    for(int i=0; list!=null && i<list.size(); i++){
                        Customer cust = (Customer)list.get(i);
                        sb.append(cust.getId()).append(delim).append(cust.getFname()).append(delim);
                        sb.append(cust.getLname()).append(delim).append(cust.getPhone()).append(delim);
                        sb.append(cust.getCell_phone()).append(delim).append(cust.getEmail()).append(delim);
                        sb.append(cust.getReq()).append(separ);
                    }
                    response.getWriter().write(sb.toString());
                    sb = null;
                }
                return;
            }
            else if(query.equalsIgnoreCase("appoint")){//TODO parameters
                String action = StringUtils.defaultString(request.getParameter("action"), "");
                String sch_id = StringUtils.defaultString(request.getParameter("appt"), "");
                String svc = StringUtils.defaultString(request.getParameter("svc"), "");
                String emp = StringUtils.defaultString(request.getParameter("emp"), "");
                String cust = StringUtils.defaultString(request.getParameter("cust"), "");
                String dt = StringUtils.defaultString(request.getParameter("dt"), "");
                String st = StringUtils.defaultString(request.getParameter("st"), "");
                String et = StringUtils.defaultString(request.getParameter("et"), "");
                String loc = StringUtils.defaultString((String)request.getSession().getAttribute("location_id"), "1");
                String comment = StringUtils.defaultString(request.getParameter("comment"), "");
                //String num = StringUtils.defaultString((String)request.getSession().getAttribute("page_num"), "0");
                if(action.equalsIgnoreCase("new")){
//                    System.out.println("appointment 3");
                    Appointment appt = Appointment.insertAppointment(Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp),Integer.parseInt(svc),
                            1,new BigDecimal(0), DateUtil.parseSqlDate(dt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),0,comment, false);
                    response.getWriter().write("new=" + appt.getId());
                    return;
                }
                else if(action.equalsIgnoreCase("edit")){
                    Appointment appt = null;
                    Appointment a = Appointment.findById(Integer.parseInt(sch_id));
                    if (a!= null && a.getState()!=3){
                        Ticket t = Ticket.findTicketById(a.getTicket_id());
                        if(t != null){
                            ArrayList arr = Reconciliation.findTransByCode(t.getCode_transaction());
                            if(arr != null && arr.size() > 0){
                                Reconciliation r = (Reconciliation)arr.get(0);
                                if(r != null && r.getStatus() != 0){
                                    appt = Appointment.updateAppointment(Integer.parseInt(sch_id),Integer.parseInt(emp),
                                            new BigDecimal(0), DateUtil.parseSqlDate(dt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),comment);
                                }
                            }else{
                                appt = Appointment.updateAppointment(Integer.parseInt(sch_id),Integer.parseInt(emp),
                                        new BigDecimal(0), DateUtil.parseSqlDate(dt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),comment);
                            }
                        }else{
                            appt = Appointment.updateAppointment(Integer.parseInt(sch_id),Integer.parseInt(emp),
                                    new BigDecimal(0), DateUtil.parseSqlDate(dt),DateUtil.parseSqlTime(st),DateUtil.parseSqlTime(et),comment);
                        }
                    }

                    response.getWriter().write("edit=" + appt!=null?appt.getId():0);
                    return;
                }
                else if(action.equalsIgnoreCase("delete")){
                    Appointment appt = Appointment.deleteAppointment(Integer.parseInt(sch_id));
                    response.getWriter().write("del=" + appt.getId());
                    return;
                }
            }
            else if(query.equalsIgnoreCase("openday"))
            {
                try{
                String type = StringUtils.defaultString(request.getParameter("type"), "");
                String dt = StringUtils.defaultString(request.getParameter("date"), "");
                CashDrawing cd = CashDrawing.findByDateStatus(1, DateUtil.parseSqlDate(dt), 0);
                CashDrawing cd_close = CashDrawing.findByDateStatus(1, DateUtil.parseSqlDate(dt), 2);
                if(cd == null)
                {
                    if(type.equals("pay"))
                        response.getOutputStream().print("You need to open your day in order to process a trasaction");
                    else if(type.equals("check"))
                        response.getOutputStream().print("You need to open your day before checkin a customer");
                    else
                        response.getOutputStream().print("Why?");
                }
                else{
                    if (cd_close!=null){
                        if(type.equals("pay"))
                            response.getOutputStream().print("Day is already closed. You can't process a trasaction.");
                        else if(type.equals("check"))
                            response.getOutputStream().print("Day is already closed. You can't checkin a customer");
                    } else {
                        response.getOutputStream().print("###");
                    }
                }
                }
                catch(Exception ex)
                {
                    response.getOutputStream().print("error");                    
                }
            }
            else if(query.equalsIgnoreCase("cust_history")) {
                try{
                    String id = StringUtils.defaultString(request.getParameter(Customer.ID), "0");
                    int cust_id = Integer.parseInt(id);
                    ArrayList list = AppointmentHistory.findFullHistoryByCustomerId(cust_id);
                    BigDecimal price = BigDecimal.ZERO;
                    String responce_str = "";
                    String state = "";
                    responce_str = "    <table cellpadding=\"0\" style=\"color: black;\" cellspacing=\"0\">\n" +
                            "        <tr width=\"100%\">\n" +
                            "            <td width=\"84\" align=\"center\"><img src=\"img/mb_table_date.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"136\" align=\"center\"><img src=\"img/mb_table_employee.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"96\" align=\"center\"><img src=\"img/mb_table_service.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"136\" align=\"center\"><img src=\"img/mb_table_product.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"94\" align=\"center\"><img src=\"img/mb_table_price.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"94\" align=\"center\"><img src=\"img/mb_table_time.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"172\" align=\"center\" ><img src=\"img/mb_table_comment.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"172\" align=\"center\"><img src=\"img/mb_table_customer_comment.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"62\" align=\"center\"><img src=\"img/mb_table_edit.png\" alt=\"\"/></td>\n" +
//                            "            <td width=\"30\" align=\"center\"><img src=\"img/mb_table_remove.png\" alt=\"\"/></td>\n" +
                            "            <td width=\"94\" align=\"center\"><img src=\"img/mb_table_status.png\" alt=\"\"/></td>\n" +
                            "        </tr>";
                    for (int i = 0; i < list.size(); i++) {
                        AppointmentHistory appt = (AppointmentHistory) list.get(i);
//                            String bg = !appt.getRequest().booleanValue()? "#e2e3e4" : "#FF0000";
                            String bg = "";
                            state = "";
                            price = BigDecimal.ZERO;
//                            switch (appt.getState()){
//                                case 0: state = "Pending"; bg = "white"; break;
//                                case 2: state = "Customer no show"; bg = "#F390BC"; break;
//                                case 4: state = "Canceled by Cust."; bg = "#F390BC"; break;
//                                case 3: state = "Paid"; bg = "#ACADB1"; break;
//                            }
                            switch (appt.getState())
                            {
                                case 0: state = "Paid"; bg = "#c1c2c4"; break; //closed transaction
                                case 1: state = "Deleted"; bg = "#F390BC"; break; //deleted transaction
                                case 2: state = "Pending"; bg = "#9ccf78"; break; //pending (saved) transaction
                                case 3: break; //payout transaction
                                case 4: state = "Refunded"; bg = "#812990"; break; //refunded transaction
                                case 5: break; //payin transaction
                                case 6: state = "Canceled"; bg = "#f172ac"; break; //canceled transaction
                            }
                        Ticket t = Ticket.findTicketById(appt.getTicket_id());
                        String ct = "0";
                        int st = 0;
                        int idt = 0;
                            if(t != null){
                                ct = t.getCode_transaction();
                                ArrayList a = Reconciliation.findTransByCode(ct);
                                if(a != null && a.size() > 0){
                                    Reconciliation r = (Reconciliation)a.get(0);
                                    if(r != null){
                                        st = r.getStatus();
                                        idt = r.getId();
//                                        if (r.getStatus() == 0){
//                                            state = "Paid";
//                                            bg = "#ACADB1";
//                                        }
                                    }
                                }
                            }
//                        price = (appt.getState()==2 || appt.getState()==4)?new BigDecimal(0):appt.getPrice().setScale(2, BigDecimal.ROUND_HALF_DOWN);
                        price = appt.getPrice().setScale(2, BigDecimal.ROUND_HALF_DOWN);
                        Html2Text parserComment = new Html2Text();
                        parserComment.parse(new StringReader(appt.getComment()));
                        responce_str += " <tr width=\"100%\">\n" +
                            " <td align=\"center\" style=\"height:22px; width: 84px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">\n" +
                            DateUtil.formatYmd(appt.getApp_dt()) +
                            " </td>\n" +
                            " <td align=\"center\" style=\"width: 136px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">\n" +
                            appt.getEmployee() +
                            "                        </td>\n" +
                            "                        <td align=\"center\" title=\""+appt.getService()+"\" style=\"font-size: 10px; width: 96px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">\n" +
                            "                            <nobr>"+
                            appt.getService() + "</nobr>\n"+
                            "                        </td>\n" +
                            "                        <td align=\"center\" title=\""+appt.getProduct()+"\" style=\"font-size:10px; width: 128px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">\n" +
                            "                            <nobr>"+
                            appt.getProduct()+
                            "                        </nobr>\n" +
                            "                        </td>\n" +
                            "                        <td align=\"center\" style=\"width: 94px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">$"+
                            price +
                            "                        </td>\n" +
                            "                        <td align=\"center\" style=\"width: 94px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">" +
                            DateUtil.formatTime(appt.getTime())+
                            "                        </td>\n" +
                            "                        <td align=\"center\" title=\""+parserComment.getText()+"\" style=\"width: 172px; background: "+bg+" ; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c; overflow: hidden; height: 22px\">"+
                            appt.getComment().replace("\n", " ").replace("\r", " ").replace("  ", " ")+
                            "                        </td>\n" +
                                    "                        <td align=\"center\" title=\""+appt.getCust_comment()+"\" style=\"width: 172px; background: "+bg+" ; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c; overflow: hidden; height: 22px\">"+
//                                    "                        <td align=\"center\" title=\""+appt.getCust_comment()+"\" style=\"width: 172px; background: "+bg+" url(img/mb_comment_bg.png) no-repeat; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c; overflow: hidden; height: 22px\">"+
                            appt.getCust_comment().replace("\n", " ").replace("\r", " ").replace("  ", " ")+
                            "                        </td>\n" +
                                    "                        <td align=\"center\" style=\"width: 62px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">\n";
                                if (idt!=0){
                                    responce_str += "                            <a href=\"checkout.jsp?dt="+appt.getApp_dt()+"&ct="+ct+"&idc="+id+"&idt="+idt+"&tp=2&st="+st+"\"><img src=\"img/mb_edit_button.png\" alt=\"\" border=\"0\"/></a>\n";
                                }
//                                    "                            <a href=\"admin/edit_appointment.jsp?action=edit&id="+appt.getId()+"\"><img src=\"img/mb_edit_button.png\" alt=\"\" border=\"0\"/></a>\n" +
                                    responce_str += "                        </td>\n" +
//                                    "                        <td align=\"center\" style=\"width: 30px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">\n" +
//                                    "                            <a href=\"#\" onclick=\"deleteRow("+appt.getId()+");\"><img src=\"img/mb_delete_button.png\" alt=\"\" border=\"0\"/></a>\n" +
//                                    "                        </td>\n" +
                                    "                        <td align=\"center\" style=\"font-size: 10px; width: 94px; background: "+bg+"; border-right: solid 1px #b2b4b7; border-bottom: solid 1px #6d6b6c\">\n" +
                                    state +
                                    "                        </td>\n" +
                                    "                    </tr>";
                    }
                    responce_str+="    </table>";
                    response.getOutputStream().print(responce_str);
                }
                catch(Exception ex)
                {
                    response.getOutputStream().print("error get cust_history");
                }
            }
        }catch(Exception ex){
            ex.printStackTrace();
        }
//        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
}
