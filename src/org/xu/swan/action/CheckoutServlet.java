package org.xu.swan.action;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;
import org.jfree.util.Log;
import org.xu.swan.bean.*;
import org.xu.swan.util.DateUtil;
import org.xu.swan.util.SendMailHelper;
import org.xu.swan.util.SwanGuid;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.db.DBManager;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class CheckoutServlet extends HttpServlet {
    protected Logger logger = LogManager.getLogger(getClass());
    public void init() {
        System.out.println("CheckoutServlet initialized.");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doPost(request, response);
    }

    private Date ConvertStringToDate(String sDate)
    {
        try{
            DateFormat formatter ;
            Date dDate ;
            formatter = new SimpleDateFormat("yyyy/MM/dd");
            dDate = (Date)formatter.parse(sDate);
            formatter = null;
            return dDate;
        }catch(Exception ex)
        {}
        return null;
    }

    private String CreateMessageCloseDay(Date dOpen, Date dCurent)
    {
        try
        {
            Calendar cOpen = Calendar.getInstance();
            cOpen.setTime(dOpen);

            Calendar cCurent = Calendar.getInstance();
            cCurent.setTime(dCurent);

            int difDay = cCurent.get(Calendar.DAY_OF_YEAR) - cOpen.get(Calendar.DAY_OF_YEAR);

            cCurent.add(Calendar.DAY_OF_MONTH, -difDay);
            String month_of_year = "";
            switch (cCurent.get(Calendar.MONTH))
            {
                case Calendar.JANUARY:
                    month_of_year = "JANUARY";
                         break;
                case Calendar.FEBRUARY:
                    month_of_year = "FEBRUARY";
                         break;
                case Calendar.MARCH:
                    month_of_year = "MARCH";
                         break;
                case Calendar.APRIL:
                    month_of_year = "APRIL";
                         break;
                case Calendar.MAY:
                    month_of_year = "MAY";
                         break;
                case Calendar.JUNE:
                    month_of_year = "JUNE";
                         break;
                case Calendar.JULY:
                    month_of_year = "JULY";
                         break;
                case Calendar.AUGUST:
                    month_of_year = "AUGUST";
                         break;
                case Calendar.SEPTEMBER:
                    month_of_year = "SEPTEMBER";
                         break;
                case Calendar.OCTOBER:
                    month_of_year = "OCTOBER";
                         break;
                case Calendar.NOVEMBER:
                    month_of_year = "NOVEMBER";
                         break;
                case Calendar.DECEMBER:
                    month_of_year = "DECEMBER";
                         break;
            }
            return "Day " + cCurent.get(Calendar.DAY_OF_MONTH) + " " + month_of_year + " " + cCurent.get(Calendar.YEAR) +" have not been closed, please close it before opening a new day";
        }
        catch(Exception ex)
        {
            return "Exception";    
        }
    }

    private void recalcTransaction(int id_trans){
        Reconciliation rec = Reconciliation.findById(id_trans);
        ArrayList listTicket = Ticket.findTicketByLocCodeTrans(rec.getId_location(), rec.getCode_transaction());
        BigDecimal total = new BigDecimal(0);
        BigDecimal sub_total = new BigDecimal(0);
        BigDecimal taxe = new BigDecimal(0);
        for (int i = 0; i<listTicket.size(); i++){
            Ticket tck = (Ticket) listTicket.get(i);
            sub_total = (tck.getPrice().multiply(new BigDecimal(tck.getQty()))).multiply( new BigDecimal(1).subtract(new BigDecimal(tck.getDiscount()).divide(new BigDecimal(100))));
//            sub_total = sub_total.add(tck.getPrice());
            taxe = taxe.add(tck.getTaxe().multiply(new BigDecimal(tck.getQty())));
        }
        total = sub_total.add(taxe);
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = null;
            pst = dbm.getPreparedStatement("UPDATE reconciliation SET sub_total=?, taxe=?, total=? WHERE id=?");
            pst.setBigDecimal(1, sub_total);
            pst.setBigDecimal(2, taxe);
            pst.setBigDecimal(3, total);
            pst.setInt(4, id_trans);
            pst.executeUpdate();
        } catch (Exception e){

        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(true);
        User user_ses = (User) session.getAttribute("user");
        if (user_ses != null){
            String action = StringUtils.defaultString(request.getParameter("action"), "");
            if(action.equals("updateTransactionValues")){
                if (user_ses.getPermission() != Role.R_SHD_CHK){
//                    logger.info("Start updateTransactionValues. User="+user_ses.getFname() + " " + user_ses.getLname());
                    DBManager dbm = null;
                    try{
                        int id = Integer.parseInt(request.getParameter("id"));
                        int qty = Integer.parseInt(request.getParameter("qty"));
                        int discount = Integer.parseInt(request.getParameter("discount"));
                        float price = Float.parseFloat(request.getParameter("price"));
                        float subtotal = Float.parseFloat(request.getParameter("subtotal"));
                        float taxe = Float.parseFloat(request.getParameter("taxe"));
                        float total = Float.parseFloat(request.getParameter("total"));
                        String actionRec = StringUtils.defaultString(request.getParameter("actionRec"), "");
                        dbm = new DBManager();
                        PreparedStatement pst = null;
                        pst = dbm.getPreparedStatement("UPDATE ticket SET qty=?, discount=?, price=? WHERE id=?");
                        pst.setInt(1, qty);
                        pst.setInt(2, discount);
                        pst.setFloat(3, price);
                        pst.setInt(4, id);
                        pst.executeUpdate();

                        Ticket t = Ticket.findTicketById(id);

                        if (actionRec.equals("add")){
                            if(t!= null && t.getProduct_id() != 0){
                                pst = dbm.getPreparedStatement("UPDATE inventory SET qty=qty-? WHERE id=?");
                                pst.setInt(1, qty);
                                pst.setInt(2, t.getProduct_id());
                                pst.executeUpdate();
                            }
                        }

                        String codeTrans = t.getCode_transaction();
                        pst = dbm.getPreparedStatement("UPDATE reconciliation SET sub_total=?, taxe=?, total=? WHERE code_transaction=?");
                        pst.setFloat(1, subtotal);
                        pst.setFloat(2, taxe);
                        pst.setFloat(3, total);
                        pst.setString(4, codeTrans);
                        pst.executeUpdate();
                    }catch(Exception e){
                        response.getOutputStream().print(e.toString());
                        e.printStackTrace();
                        logger.info("Error. Stop updateTransactionValues. User="+user_ses.getFname() + " " + user_ses.getLname() + "===Error:"+e.toString());
                    } finally {
                        if(dbm!=null)
                            dbm.close();
                    }
                    dbm = null;
//                    logger.info("End updateTransactionValues. User="+user_ses.getFname() + " " + user_ses.getLname());
                }
            }else if(action.equals("updateTicketsStatus")){
                if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    String tickets = request.getParameter("ticketIDs");
                    int status = Integer.parseInt(request.getParameter("status"));
                    String[] t = tickets.split(" ");
                    for(int i = 0; i < t.length; i++){
                        if(!t[i].trim().equals("")){
                            DBManager dbm = null;
                            try{
                                int id = Integer.parseInt(t[i].trim());
                                dbm = new DBManager();
                                PreparedStatement pst = null;
                                pst = dbm.getPreparedStatement("UPDATE ticket SET status=? WHERE id=?");
                                pst.setInt(1, status);
                                pst.setInt(2, id);
                                pst.executeUpdate();
                                Ticket _t = Ticket.findTicketById(id);
                                if(_t.getProduct_id() != 0) {
                                    pst = dbm.getPreparedStatement("UPDATE inventory SET qty=qty+? WHERE id=?");
                                    pst.setInt(1, _t.getQty());
                                    pst.setInt(2, _t.getProduct_id());
                                    pst.executeUpdate();
                                }
                            }catch(Exception e){
                                response.getOutputStream().print(e.toString());
                                e.printStackTrace();
                            } finally {
                                if(dbm!=null)
                                    dbm.close();
                            }
                            dbm=null;
                        }
                    }
                }
            }else if(action.equals("updateTicketAndTransValues")){
                if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    int id = Integer.parseInt(StringUtils.defaultString(request.getParameter("id"), "0"));
                    if (id != 0){
                        int disc = Integer.parseInt(StringUtils.defaultString(request.getParameter("discount"), "0"));
                        BigDecimal price = new BigDecimal(StringUtils.defaultString(request.getParameter("price"), "0.0"));
                        BigDecimal taxe_real = new BigDecimal(StringUtils.defaultString(request.getParameter("taxe_real"), "0.0"));
                        int qty = Integer.parseInt(StringUtils.defaultString(request.getParameter("qty"), "0"));
                        Ticket tick = Ticket.updateTicketValues(id, disc, price, qty, taxe_real);
                        if (tick == null){
                            response.getOutputStream().print("Checout Servlet: 'Error on updateTicketValue:'");
                        } else {
                        DBManager dbm = null;
                        try{
                            float subtotal = Float.parseFloat(StringUtils.defaultString(request.getParameter("subtotal"), "0"));
                            float taxe = Float.parseFloat(StringUtils.defaultString(request.getParameter("taxe"), "0"));
                            float total = Float.parseFloat(StringUtils.defaultString(request.getParameter("total"), "0"));
                            dbm = new DBManager();
                            PreparedStatement pst = null;
                            Ticket t = Ticket.findTicketById(id);
                            String codeTrans = t.getCode_transaction();
                            pst = dbm.getPreparedStatement("UPDATE reconciliation SET sub_total=?, taxe=?, total=? WHERE code_transaction=?");
                            pst.setFloat(1, subtotal);
                            pst.setFloat(2, taxe);
                            pst.setFloat(3, total);
                            pst.setString(4, codeTrans);
                            pst.executeUpdate();
                        }catch(Exception e){
                            response.getOutputStream().print(e.toString());
                            e.printStackTrace();;
                        } finally {
                            if(dbm!=null)
                                dbm.close();
                        }
                        }
                    }
                }
            }else if(action.equals("updateTicketsStatusByAppID"))
            {
                if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    String app_id = request.getParameter("AppID");
                    String code_trans = StringUtils.defaultString(request.getParameter("ct"), "0");
                    if(!code_trans.equals("0"))
                    try{
                        int id = Integer.parseInt(app_id);
                        Appointment app = Appointment.findById(id);
                        Customer cust = Customer.findById(app.getCustomer_id());
                        BigDecimal ap_price = BigDecimal.ZERO;
                        BigDecimal ap_tax = BigDecimal.ZERO;
                        Ticket tc = null;
                        if (app != null){
                            tc = Ticket.findTicketById(app.getTicket_id());

                            if(cust != null && cust.getFname().toUpperCase().equals(Customer.WALKIN))
                            {
                                if (app.getTicket_id()==0 || tc == null){
                                    EmpServ servLink = EmpServ.findByEmployeeIdAndServiceID(app.getEmployee_id(), app.getService_id());
                                    if (servLink == null)
                                    {
                                        Service servLinks = Service.findById(app.getService_id());
                                        if (servLinks != null){
                                            ap_price = servLinks.getPrice();
                                            ap_tax = servLinks.getTaxes();
                                        }
                                    }else
                                    {
                                        ap_price = servLink.getPrice();
                                        ap_tax = servLink.getTaxes();
                                    }

                                    BigDecimal taxe = ap_price.multiply(ap_tax).divide(new BigDecimal(100));
                                    BigDecimal total = ap_price.add(taxe);
//                                    logger.info("Start insertTicket. (walkin) User="+user_ses.getFname() + " " + user_ses.getLname());
                                    Ticket tic = Ticket.insertTicket(0, 1, code_trans, app.getEmployee_id(), 0, app.getService_id(), 1, 0, ap_price, taxe, 2,"-1");
//                                    logger.info("End insertTicket. (walkin) User="+user_ses.getFname() + " " + user_ses.getLname());
                                    Appointment.updateAddTicketID(app.getId(), tic.getId());
//                                    logger.info("Start insertTransaction_. (walkin) User="+user_ses.getFname() + " " + user_ses.getLname());
                                    Reconciliation.insertTransaction_(0,1,code_trans,app.getCustomer_id(),ap_price,taxe,total,"",2,app.getApp_dt(),BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,"");
//                                    logger.info("End insertTransaction_. (walkin) User="+user_ses.getFname() + " " + user_ses.getLname());
                                }
                            }else{
                                ArrayList arrAppFilt = Appointment.findByFilter("where customer_id = "+ app.getCustomer_id()+" and DATE(appt_date) = DATE('" + app.getApp_dt() + "')");
                                BigDecimal s_total = BigDecimal.ZERO;
                                BigDecimal taxe = BigDecimal.ZERO;
                                ArrayList arrApp = new ArrayList();
                                String code_saved_trans = "-1";
                                for (int i = 0; i < arrAppFilt.size(); i++){
                                    Appointment app_temp = (Appointment)arrAppFilt.get(i);
                                    Ticket tick_temp = Ticket.findTicketById(app_temp.getTicket_id());
                                    if (app_temp.getTicket_id() != 0 && tick_temp != null){
                                        ArrayList recList_temp = Reconciliation.findTransByCode(tick_temp.getCode_transaction());
                                        for (int j = 0; j < recList_temp.size(); j++){
                                            Reconciliation rc_temp = (Reconciliation)recList_temp.get(j);
                                            if (rc_temp.getStatus() == 2){
                                                code_saved_trans = rc_temp.getCode_transaction();
                                            }
                                        }
                                    } else {
                                        arrApp.add(app_temp);
                                    }
                                }
                                if (tc!= null){
                                    //redirect
                                } else {
                                    if (!code_saved_trans.equals("-1")){
                                        code_trans = code_saved_trans;
                                    }
                                    for(int i = 0; i < arrApp.size(); i++)
                                    {
                                        Appointment iApp = (Appointment)arrApp.get(i);
                                        EmpServ servLink = EmpServ.findByEmployeeIdAndServiceID(iApp.getEmployee_id(), iApp.getService_id());
                                        tc = Ticket.findTicketById(iApp.getTicket_id());
                                        if (iApp.getTicket_id()==0 || tc == null){
                                            if (servLink == null)
                                            {
                                                Service servLinks = Service.findById(iApp.getService_id());
                                                if (servLinks != null){
                                                    ap_price = servLinks.getPrice();
                                                    ap_tax = servLinks.getTaxes();
                                                }
                                            }else
                                            {
                                                ap_price = servLink.getPrice();
                                                ap_tax = servLink.getTaxes();
                                            }

                                            s_total = s_total.add(ap_price);
                                            taxe = taxe.add(ap_price.multiply(ap_tax).divide(new BigDecimal(100)));
//                                            logger.info("Start insertTicket. User="+user_ses.getFname() + " " + user_ses.getLname());
                                            Ticket tic = Ticket.insertTicket(0, 1, code_trans, iApp.getEmployee_id(), 0, iApp.getService_id(), 1, 0, ap_price, ap_price.multiply(ap_tax).divide(new BigDecimal(100)), 2,"-1");
//                                            logger.info("End insertTicket. User="+user_ses.getFname() + " " + user_ses.getLname());
                                            Appointment.updateAddTicketID(iApp.getId(), tic.getId());
                                        }
                                    }
                                    arrApp = null;
                                    BigDecimal total = s_total.add(taxe);
                                    if (code_saved_trans.equals("-1")){
//                                    logger.info("Start insertTransaction_. User="+user_ses.getFname() + " " + user_ses.getLname());
                                    Reconciliation.insertTransaction_(0,1,code_trans,app.getCustomer_id(),s_total,taxe,total,"",2,app.getApp_dt(),BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO,"");
//                                    logger.info("End insertTransaction_. User="+user_ses.getFname() + " " + user_ses.getLname());
                                    }
                            }
                            }
                    }
                    }catch(Exception e){
                        response.getOutputStream().print(e.toString());
                        e.printStackTrace();
                    }
                }
            }else if(action.equals("updateRefundPayment")){
                if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    String reconID = request.getParameter("reconID");
                    String payment = request.getParameter("paym");
                    DBManager dbm = null;
                    try {
                        dbm = new DBManager();
                        PreparedStatement pst = null;
                        pst = dbm.getPreparedStatement("UPDATE reconciliation SET payment=? WHERE id=?");
                        pst.setString(1, payment);
                        pst.setString(2, reconID);
                        pst.executeUpdate();
                    }catch(Exception e){
                        response.getOutputStream().print(e.toString());
                        e.printStackTrace();
                    } finally {
                        if(dbm!=null)
                            dbm.close();
                    }
                    dbm = null;
                }
            }else if(action.equals("checkProductQty")){
                if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    int qty = Integer.parseInt(request.getParameter("qty"));
                    Ticket t = Ticket.findTicketById(id);
                    if(t.getProduct_id() != 0){
                        Inventory i = Inventory.findById(t.getProduct_id());
                        if(i != null && i.getQty() < qty)
                            response.getOutputStream().print(Integer.toString(i.getQty()));

                    }
                    return;
                }
            }else if(action.equals("deleteTransaction")){
                if (user_ses.getPermission() != Role.R_SHD_CHK){
                    String login = request.getParameter("log");
                    String password = request.getParameter("pwd");
                    int id = Integer.parseInt(request.getParameter("id"));
                    User us = User.findUser(login,password);
                    if (us == null){
                        response.getOutputStream().print("Login or password is incorrect.");
                    } else
                    if (us.getPermission() == Role.R_ADMIN)
                    {
                        Reconciliation rec = Reconciliation.findById(id);
                        boolean bCompleteUpdateAppointment = true;
                        if ((rec.getStatus() == 2)||(rec.getStatus() == 6)||(rec.getStatus() == 0))
                        {
                            bCompleteUpdateAppointment = false;
                            ArrayList listTicket = Ticket.findTicketByLocCodeTrans(rec.getId_location(), rec.getCode_transaction());
                            ArrayList listApp = new ArrayList();
                            if (listTicket.size()==0){
                                bCompleteUpdateAppointment = true;    
                            }else{
                                for (int i = 0; i<listTicket.size();i++)
                                {
                                    Ticket t = (Ticket)listTicket.get(i);
                                    if (t!=null && t.getProduct_id()!=0){
                                        Inventory inv = Inventory.findById(t.getProduct_id());
                                        if (inv!=null){
                                            int new_count = inv.getQty()+t.getQty();
                                            Inventory.updateInventoryQty(t.getProduct_id(),new_count);
                                        }
                                    }
                                    listApp = Appointment.findByFilter("where ticket_id="+t.getId());
                                    if (listApp.size()>0){
                                        for (int j = 0; j<listApp.size(); j++)
                                        {
                                            Appointment a = (Appointment)listApp.get(j);
                                            if(Appointment.updateAppointmentByIdState(a.getId(), 0) != null)
                                                if(Appointment.updateAddTicketID(a.getId(),0) != null)
                                                    bCompleteUpdateAppointment = true;
                                        }
                                    }else {
                                        bCompleteUpdateAppointment = true;
                                    }
                                }
                            }
                            if (bCompleteUpdateAppointment){
                                BigDecimal gc_am, gc_tot = new BigDecimal(0.0);
                                String gc_num = "";
                                gc_am = rec.getGiftcard();
                                if (gc_am.compareTo(new BigDecimal(0)) !=0){
                                    gc_num = rec.getGiftcard_pay();
                                    Giftcard gg = Giftcard.findByCode(gc_num);
                                    if (gg!=null){
                                        gc_tot = gg.getAmount();
                                        gc_tot = gc_tot.add(gc_am);
                                        Giftcard g = Giftcard.updateGiftcard(gc_num, gc_tot);
                                    }
                                }
                            }
                            listApp = null;
                        }else if (rec.getStatus() == 4){
                            bCompleteUpdateAppointment = false;
                            ArrayList listTick = new ArrayList();
                            listTick = Ticket.findTicketByFilter(" where refundtrans_id="+id);
                            for (int i = 0; i<listTick.size();i++){
                                Ticket t = (Ticket)listTick.get(i);
                                if (t != null){
                                    Ticket.updateTicketStatusRefund(t.getId(),0,0);
                                }
                            }
                            bCompleteUpdateAppointment = true;
                        }
                        if(bCompleteUpdateAppointment){
                            Reconciliation.deleteTransaction(user_ses.getId(),id);
                        }
                    }
                    else
                        response.getOutputStream().print("User " + us.getUser() + " dont have permissions to delete transactions.");
                }
                }else if(action.equals("deleteTransactionfromAdmin")){
                if (user_ses.getPermission() != Role.R_SHD_CHK){

                    int id = Integer.parseInt(request.getParameter("id"));

                        Reconciliation rec = Reconciliation.findById(id);
                        boolean bCompleteUpdateAppointment = true;
                        if ((rec.getStatus() == 2)||(rec.getStatus() == 6)||(rec.getStatus() == 0))
                        {
                            bCompleteUpdateAppointment = false;
                            ArrayList listTicket = Ticket.findTicketByLocCodeTrans(rec.getId_location(), rec.getCode_transaction());
                            ArrayList listApp = new ArrayList();
                            for (int i = 0; i<listTicket.size();i++)
                            {
                                Ticket t = (Ticket)listTicket.get(i);
                                if (t!=null && t.getProduct_id()!=0){
                                    Inventory inv = Inventory.findById(t.getProduct_id());
                                    if (inv!=null){
                                        int new_count = inv.getQty()+t.getQty();
                                        Inventory.updateInventoryQty(t.getProduct_id(),new_count);
                                    }
                                }
                                listApp = Appointment.findByFilter("where ticket_id="+t.getId());
                                if (listApp.size()>0){
                                    for (int j = 0; j<listApp.size(); j++)
                                    {
                                        Appointment a = (Appointment)listApp.get(j);
                                        if(Appointment.updateAppointmentByIdState(a.getId(), 0) != null)
                                            if(Appointment.updateAddTicketID(a.getId(),0) != null)
                                                bCompleteUpdateAppointment = true;
                                    }
                                }else {
                                    bCompleteUpdateAppointment = true;
                                }
                            }
                            listApp = null;
                        }
                        if(bCompleteUpdateAppointment)
                            Reconciliation.deleteTransaction(user_ses.getId(),id);
                }
            }else if(action.equals("checkOpenPrevDay")){
                if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    String sDate = request.getParameter("date");
                    CashDrawing cdrwLO = CashDrawing.findByLastDate(sDate, 0);//ищем последний открытый день
                    if(cdrwLO != null)//если есть хотябы один открытый день в базе
                    {
                        Date dCurDate = ConvertStringToDate(sDate);
                        CashDrawing cdrw = CashDrawing.findByDate(1, DateUtil.parseSqlDate(cdrwLO.getDate().toString()));//������ ������ ����� �������� ���
                        if(cdrw != null)
                        {
                            if(cdrw.getOpenClose() != 2)//если последний открытый день, не закрыт
                            {
                                response.getOutputStream().print(CreateMessageCloseDay(cdrwLO.getDate(), dCurDate));
                            }//иначе открываем день
                        }
                        else//в базе нет закрытых дней
                        {
                            response.getOutputStream().print(CreateMessageCloseDay(cdrwLO.getDate(), dCurDate));
                        }
                    }//если в базе нет открытых дней то даем открыть день
                }
            }else if(action.equals("removeTicket")){
                if (user_ses.getPermission() != Role.R_SHD_CHK){
//                    logger.info("Start removeTicket. User="+user_ses.getFname() + " " + user_ses.getLname());
                    String remove_id = request.getParameter("remove_id");
                    int delTick_id = Integer.parseInt(remove_id);

                    Ticket tck = Ticket.findTicketById(delTick_id);
                    if (tck!=null && tck.getProduct_id()!=0){
                        Reconciliation r = Reconciliation.findTransByCodeOne(tck.getCode_transaction());
                        if (r!=null&&((r.getStatus() == 2)||(r.getStatus() == 6)||(r.getStatus() == 0))){
                            Inventory inv = Inventory.findById(tck.getProduct_id());
                            if (inv!=null){
                                int new_count = inv.getQty()+tck.getQty();
                                Inventory.updateInventoryQty(tck.getProduct_id(),new_count);
                            }
                        }
                    }

                    String gc = tck.getGiftcard();
                    if (!gc.equals("-1")) {
                        Giftcard.deleteGiftcard(gc);
                    }
                    Ticket.deleteTicket(0, delTick_id);
                    ArrayList listApp = Appointment.findAllByTicketId(delTick_id);
                    for (int i=0; i<listApp.size(); i++){
                        Appointment a = (Appointment) listApp.get(i);
                        Appointment.updateAddTicketID(a.getId(), 0);
                        Appointment.updateAppointmentByIdState(a.getId(), 0);
                    }
//                    logger.info("End removeTicket. User="+user_ses.getFname() + " " + user_ses.getLname());
                }
            }else if(action.equals("send_checkout_email")){
            	logger.debug("send_checkout_email");
            	try {
            		
	            	String customerId = request.getParameter("customerId");
	            	String email = request.getParameter("email");
	            	String transactionCode = request.getParameter("transactionCode");
	            	String locationId = request.getParameter("location");
	            	
	            	Log.debug("send check out email parameters, customer:"+customerId+", email:"+email+", transactionCode:"+transactionCode+", locationId:"+locationId);
	            	
	            	if(customerId==null||customerId.trim().length()==0){
	            		response.getWriter().write("semd mail failure : customer id is null!");
	            		return ;
	            	}
	            	
	            	Customer customer = Customer.findById(Integer.parseInt(customerId));
	            	if(customer == null){
	            		response.getWriter().write("semd mail failure : customer not found!");
	            		return ;
	            	}
	            	
	            	List<Ticket> tickets = Ticket.findTicketByLocCodeTrans(Integer.parseInt(locationId), transactionCode);
	            	Integer serviceId = null;
	            	Integer productId = null;
	            	String giftcard = "-1";
	            	for(int i=0; i<tickets.size(); i++){
	            		Ticket ticket = tickets.get(i);
	            		if(ticket.getService_id()!=0)
	            			serviceId = ticket.getService_id();
	            		if(ticket.getProduct_id()!=0)
	            			productId = ticket.getProduct_id();
	            		if("-1".equals(ticket.getGiftcard())==false)
	            			giftcard = ticket.getGiftcard();
	            	}
	            	
	            	Service service = null;
	            	Inventory inventory = null;
	            	if(serviceId!=null)
	            		service = Service.findById(serviceId);
	            	if(productId!=null)
	            		inventory = Inventory.findById(productId);
	            	
	            	EmailTemplate emailtemplate = EmailTemplate.findByType(102);
	            	
	            	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	            	String text = emailtemplate.getText();
	            	text = text.replace("{customerName}", customer.getLname());
	            	text = text.replace("{service}", service!=null?service.getName():"None");
	            	text = text.replace("{product}", inventory!=null?inventory.getName():"None");
	            	text = text.replace("{giftcard}", "-1".equals(giftcard)?"None":giftcard);
	            	text = text.replace("{dateTime}", sdf.format(new Date()));

	            	Log.debug("send check out email to"+email+", content:"+text);
	            	
	            	SendMailHelper.send(text, "Check Out Notification", email);
	            	
	            	
	            	response.getWriter().write("send mail successed!");
	            	
            	} catch (Exception e) {
            		response.getWriter().write(e.getMessage());
					Log.error(e.getMessage(),e);
				}
            	return ;
            }
            else {
                if (user_ses.getPermission() != Role.R_SHD_CHK) {

                String query = StringUtils.defaultString(request.getParameter("query"), "");
                DBManager dbm = null;
                try{
                    User u = ActionUtil.getUser(request);
                    if(query.equalsIgnoreCase("service")){
                        String type = StringUtils.defaultString(request.getParameter("type"), "");

                        String emp = StringUtils.defaultString(request.getParameter("emp"),"");
                        String svc = StringUtils.defaultString(request.getParameter("svc"),"");
                        String prod = StringUtils.defaultString(request.getParameter("prod"),"");

                        StringBuffer sb = new StringBuffer();
                        BigDecimal price = null;
                        BigDecimal tax = null;
                        String sql = "";
                        dbm = new DBManager();
                        PreparedStatement pst = null;
                        if(type.equalsIgnoreCase("svc")){
                            sql = "SELECT * FROM serv_emp WHERE employee_id=? AND service_id=?";
                            pst = dbm.getPreparedStatement(sql);
                            pst.setString(1,emp);
                            pst.setString(2,svc);
                            ResultSet rs = pst.executeQuery();
                            if(rs.next()){
                                price = rs.getBigDecimal(EmpServ.PRICE);
                                tax = rs.getBigDecimal(EmpServ.TAX);
                            }
                            rs.close();
                        }else if(type.equalsIgnoreCase("prod")){
                            sql = "SELECT * FROM inventory WHERE id=?";
                            pst = dbm.getPreparedStatement(sql);
                            pst.setString(1,prod);
                            ResultSet rs = pst.executeQuery();
                            if(rs.next()){
                                price = rs.getBigDecimal(Inventory.SALE);
                                tax = rs.getBigDecimal(EmpServ.TAX);
                            }
                            rs.close();
                        }
                        sb.append("price=").append(price).append("&&tax=").append(tax);
                        response.getWriter().write(sb.toString());
                        sb=null;
                        return;
                    }else if(query.equalsIgnoreCase("trans")){
                        action = StringUtils.defaultString(request.getParameter("action"), "");

                        String id = StringUtils.defaultString(request.getParameter(Transaction.ID),"");
                        String cust = StringUtils.defaultString(request.getParameter(Transaction.CUST),"0");
                        String emp = StringUtils.defaultString(request.getParameter(Transaction.EMP),"");
                        String loc = StringUtils.defaultString(request.getParameter(Transaction.LOC),"");
                        String svc = StringUtils.defaultString(request.getParameter(Transaction.SVC),"0");
                        String prod = StringUtils.defaultString(request.getParameter(Transaction.PROD),"0");
                        String qty = StringUtils.defaultString(request.getParameter(Transaction.PQTY),"0");
                        String price = StringUtils.defaultString(request.getParameter(Transaction.PRICE),"");
                        String method = StringUtils.defaultString(request.getParameter(Transaction.PAYMENT),"");
                        String discount = StringUtils.defaultString(request.getParameter(Transaction.DISCOUNT),"100");
                        String code = StringUtils.defaultString(request.getParameter(Transaction.CODE),"");
                        String dt = StringUtils.defaultString(request.getParameter(Transaction.CDT),"");
                        String sn = StringUtils.defaultString(request.getParameter(Transaction.SN),"");
                        String t = StringUtils.defaultString(request.getParameter(Transaction.TAX),"0");
                        String remainder = StringUtils.defaultString(request.getParameter(Transaction.RMD),"0");
                        String change = StringUtils.defaultString(request.getParameter(Transaction.EX_CHANGE),"0"); //TODO tag
                        String amex = StringUtils.defaultString(request.getParameter(Transaction.AMEX),"0");
                        String visa = StringUtils.defaultString(request.getParameter(Transaction.VISA),"0");
                        String mastercard = StringUtils.defaultString(request.getParameter(Transaction.MASTECARD),"0");
                        String cheque = StringUtils.defaultString(request.getParameter(Transaction.CHEQUE),"0");
                        String cashe = StringUtils.defaultString(request.getParameter(Transaction.CASHE),"0");
                        String giftcard = StringUtils.defaultString(request.getParameter(Transaction.GIFTCARD),"0");
                        if(StringUtils.isEmpty(cust))   cust = "0";
                        if(StringUtils.isEmpty(svc))   svc = "0";
                        if(StringUtils.isEmpty(prod))   prod = "0";

                        if(action.equalsIgnoreCase("new")){
                            BigDecimal dec = new BigDecimal(Float.parseFloat(price));
                            BigDecimal disc = new BigDecimal(Float.parseFloat(discount));
                            BigDecimal tax = new BigDecimal(Float.parseFloat(t));
                            BigDecimal rmd = new BigDecimal(Float.parseFloat(remainder));
                            BigDecimal ch = new BigDecimal(Float.parseFloat(change));
                            BigDecimal am = new BigDecimal(Float.parseFloat(amex));
                            BigDecimal vi = new BigDecimal(Float.parseFloat(visa));
                            BigDecimal ma = new BigDecimal(Float.parseFloat(mastercard));
                            BigDecimal chq = new BigDecimal(Float.parseFloat(cheque));
                            BigDecimal ca = new BigDecimal(Float.parseFloat(cashe));
                            BigDecimal gc = new BigDecimal(Float.parseFloat(giftcard));

                            Transaction trans = Transaction.insertTransaction((u!=null?u.getId():0), Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp),Integer.parseInt(svc),
                                Integer.parseInt(prod), Integer.parseInt(qty),method, dec,disc, code, DateUtil.parseSqlDate(dt),sn,tax, rmd, ch, "", am, vi, ma, chq, ca, gc);
                            response.getWriter().write("new=" + trans.getId());
                            dec= disc = tax = rmd = ch = am = vi = ma = chq = ca = gc = null;
                            return;
                        }
                        else if(action.equalsIgnoreCase("edit")){
                            BigDecimal dec = new BigDecimal(Float.parseFloat(price));
                            BigDecimal disc = new BigDecimal(Float.parseFloat(discount));
                            BigDecimal tax = new BigDecimal(Float.parseFloat(t));
                            BigDecimal rmd = new BigDecimal(Float.parseFloat(remainder));
                            BigDecimal ch = new BigDecimal(Float.parseFloat(change));

                            Transaction trans = Transaction.updateTransaction((u!=null?u.getId():0),Integer.parseInt(id),Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp),Integer.parseInt(svc),
                                Integer.parseInt(prod), Integer.parseInt(qty),method, dec,disc, code, DateUtil.parseSqlDate(dt),sn, tax, rmd, ch);
                            response.getWriter().write("edit=" + trans.getId());
                            dec= disc = tax = rmd = ch = null;
                            return;
                        }
                        else if(action.equalsIgnoreCase("delete")){
                            Transaction tran = Transaction.deleteTransaction((u!=null?u.getId():0),Integer.parseInt(id));
                            response.getWriter().write("del=" + tran.getId());
                            return;
                        }
                    }else if(query.equalsIgnoreCase("code")){
                        response.getWriter().write(new SwanGuid().toString());
                        return;
                    }else if(query.equalsIgnoreCase("balance")){
                        String sn = StringUtils.defaultString(request.getParameter("sn"),"");
                        Giftcard gCard = Giftcard.findByCode(sn);
                        response.getWriter().write(gCard!=null ? "$" + gCard.getAmount() : "N/A");
                        return;
                    }else if(query.equalsIgnoreCase("giftcard")){
                        String code = StringUtils.defaultString(request.getParameter(Giftcard.CODE),"");
                        String cdt = StringUtils.defaultString(request.getParameter(Giftcard.CDT),"");
                        String dec = StringUtils.defaultString(request.getParameter(Giftcard.AMOUNT),"0");
                        String payment = StringUtils.defaultString(request.getParameter(Giftcard.PAYMENT),"0");
                        String get = StringUtils.defaultString(request.getParameter("get"),"0");
                        String dt = StringUtils.defaultString(request.getParameter("cdt"),"");
                        String id_employee = StringUtils.defaultString(request.getParameter("id_employee"),"0");
                        if (dt.equals(""))
                            dt = DateUtil.getDate().toString();

                        Giftcard card = null;
                        BigDecimal amount = new BigDecimal(Float.parseFloat(dec));
                        BigDecimal startamount = amount;
                        if (get.equals("1")){
                            card = Giftcard.findByCode(code);
                        }else
                            if(StringUtils.isEmpty(cdt))
                                card = Giftcard.insertGiftcard(code, amount, payment, startamount, DateUtil.parseSqlDate(dt),Integer.parseInt(id_employee));
                            else
                                card = Giftcard.updateGiftcard(code, amount);
                        if (card != null){
                            response.getWriter().write(card.getCode() + "~~" + card.getAmount());
                        } else response.getWriter().write(code + "~~NotFound");
                        amount = null;
                        return;
                    }else if(query.equalsIgnoreCase("cashio")){
                        String cust = StringUtils.defaultString(request.getParameter("cust"),"0");
                        String emp = StringUtils.defaultString(request.getParameter("emp"),"0");
                        String loc = StringUtils.defaultString(request.getParameter("loc"),"1");
                        String dt = StringUtils.defaultString(request.getParameter("cdt"),"");
                        String cin = StringUtils.defaultString(request.getParameter("cin"),"");
                        String cout = StringUtils.defaultString(request.getParameter("cout"),"");
                        String notes1 = StringUtils.defaultString(request.getParameter("notes1"),"");
                        String notes2 = StringUtils.defaultString(request.getParameter("notes2"),"");
                        String pid1 = StringUtils.defaultString(request.getParameter("pid1"),"0");
                        String pid2 = StringUtils.defaultString(request.getParameter("pid2"),"0");

                        BigDecimal price = null;
                        int prod = 0;
                        String notes = "";
                        if(StringUtils.isNotEmpty(cin))  {
                            price = new BigDecimal(Float.parseFloat(cin));
                            prod = Integer.parseInt(pid1);
                            notes = notes1;
                            Transaction trans = Transaction.insertTransaction((u!=null?u.getId():0),Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp), 0,prod, 0, "cashin",
                                 price,new BigDecimal(0), "", DateUtil.parseSqlDate(dt),"",new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), notes, new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), new BigDecimal(0));
                        }
                        else if(StringUtils.isNotEmpty(cout))  {
                            price = new BigDecimal(-Float.parseFloat(cout));//paid out
                            prod = Integer.parseInt(pid2);
                            notes = notes2;
                            Transaction trans = Transaction.insertTransaction((u!=null?u.getId():0),Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp), 0,prod, 0, "cashout",
                                 price,new BigDecimal(0), "", DateUtil.parseSqlDate(dt),"",new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), notes, new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), new BigDecimal(0), new BigDecimal(0));
                        }
                        else {
                            response.sendRedirect("./cashinout.jsp?dt="+dt);
                            price = null;
                            return;
                        }
                        price = null;
        //                Transaction trans = Transaction.insertTransaction((u!=null?u.getId():0),Integer.parseInt(loc),Integer.parseInt(cust),Integer.parseInt(emp), 0,prod, 0, "cashin",
        //                     price,new BigDecimal(0), "", DateUtil.parseSqlDate(dt),"",new BigDecimal(0), new BigDecimal(0), new BigDecimal(0));
        //                Cashio cashio = Cashio.insertCashio(DateUtil.parseSqlDate(dt),)
                            response.sendRedirect("./cashinout.jsp?dt="+dt);
                        return;
                    }
                }catch(Exception e){
                    e.printStackTrace();
                } finally {
                    if(dbm!=null)
                        dbm.close();
                }
                dbm = null;
    //            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
            }
        }
    }
}
