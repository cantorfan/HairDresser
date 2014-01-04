package org.xu.swan.action;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;
import org.xu.swan.bean.*;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.DateUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;

public class CheckoutAction extends org.apache.struts.action.Action {
    protected Logger logger = LogManager.getLogger(getClass());

    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response) throws Exception {
        User u = ActionUtil.getUser(request);
        HttpSession session = request.getSession(true);
        User user_ses = (User) session.getAttribute("user");

        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), "");

        String id = StringUtils.defaultString(request.getParameter(Reconciliation.ID), "");
        String loc = StringUtils.defaultString(request.getParameter(Reconciliation.LOC), "1");
        String code = StringUtils.defaultString(request.getParameter(Reconciliation.CODE_TRANS), "");
        String cust = StringUtils.defaultString(request.getParameter(Reconciliation.CUST), "0");
        String s_total_ = StringUtils.defaultString(request.getParameter(Reconciliation.S_TOTAL), "0");
        String taxe_ = StringUtils.defaultString(request.getParameter(Reconciliation.TAXE), "0");
        String total_ = StringUtils.defaultString(request.getParameter(Reconciliation.TOTAL), "0");
        String paym = StringUtils.defaultString(request.getParameter(Reconciliation.PAYM), "0");
        String status = StringUtils.defaultString(request.getParameter(Reconciliation.STATUS), "0");
        String dt = StringUtils.defaultString(request.getParameter(Reconciliation.CDT), "0");
        String date = StringUtils.defaultString(request.getParameter("dt"), "");
        String change = StringUtils.defaultString(request.getParameter(Reconciliation.CHANGE), "0");
        String amex = StringUtils.defaultString(request.getParameter(Reconciliation.AMEX), "0");
        String visa = StringUtils.defaultString(request.getParameter(Reconciliation.VISA), "0");
        String mastercard = StringUtils.defaultString(request.getParameter(Reconciliation.MASTECARD), "0");
        String cheque = StringUtils.defaultString(request.getParameter(Reconciliation.CHEQUE), "0");
        String cashe = StringUtils.defaultString(request.getParameter(Reconciliation.CASHE), "0");
        String giftcard = StringUtils.defaultString(request.getParameter(Reconciliation.GIFTCARD), "0");
        String giftcard_pay = StringUtils.defaultString(request.getParameter(Reconciliation.GIFTCARD_PAY), "");
        String ticket_id = StringUtils.defaultString(request.getParameter("ticket_id"), "0");

        boolean allow_edit = false;
        CashDrawing cd_open = CashDrawing.findByDateStatus(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), 0);
        CashDrawing cd_close = CashDrawing.findByDateStatus(Integer.parseInt(loc), DateUtil.parseSqlDate(dt), 2);
        if (cd_open!=null && cd_close == null){
            allow_edit = true;
        }


//
//        String svc = StringUtils.defaultString(request.getParameter(Transaction.SVC), "0");
//        String prod = StringUtils.defaultString(request.getParameter(Transaction.PROD), "0");
//        String qty = StringUtils.defaultString(request.getParameter(Transaction.PQTY), "0");
//        String price = StringUtils.defaultString(request.getParameter(Transaction.PRICE), "0");
//        String method = StringUtils.defaultString(request.getParameter(Transaction.PAYMENT), "");
//        String discount = StringUtils.defaultString(request.getParameter(Transaction.DISCOUNT), "100");
//        String code = StringUtils.defaultString(request.getParameter(Transaction.CODE), "");
//        String dt = StringUtils.defaultString(request.getParameter(Transaction.CDT), "");
//        String date = StringUtils.defaultString(request.getParameter("dt"), "");
//        String sn = StringUtils.defaultString(request.getParameter(Transaction.SN), "");
//        String t = StringUtils.defaultString(request.getParameter(Transaction.TAX), "0");
//        String remainder = StringUtils.defaultString(request.getParameter(Transaction.RMD), "0");
//        String change = StringUtils.defaultString(request.getParameter(Transaction.EX_CHANGE), "0"); //TODO tag
//        String amex = StringUtils.defaultString(request.getParameter(Transaction.AMEX), "0");
//        String visa = StringUtils.defaultString(request.getParameter(Transaction.VISA), "0");
//        String mastercard = StringUtils.defaultString(request.getParameter(Transaction.MASTECARD), "0");
//        String cheque = StringUtils.defaultString(request.getParameter(Transaction.CHEQUE), "0");
//        String cashe = StringUtils.defaultString(request.getParameter(Transaction.CASHE), "0");
//        String giftcard = StringUtils.defaultString(request.getParameter(Transaction.GIFTCARD), "0");
//
//        if (StringUtils.isEmpty(cust)) cust = "0";
//        if (StringUtils.isEmpty(svc)) svc = "0";
//        if (StringUtils.isEmpty(prod)) prod = "0";

        if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)) {
            if (user_ses.getPermission() != Role.R_SHD_CHK && allow_edit) {
//            BigDecimal dec = new BigDecimal(Float.parseFloat(price));
            BigDecimal s_total = new BigDecimal(Float.parseFloat(s_total_));
            BigDecimal taxe = new BigDecimal(Float.parseFloat(taxe_));
            BigDecimal total = new BigDecimal(Float.parseFloat(total_));
            BigDecimal ch = new BigDecimal(Float.parseFloat(change));
            BigDecimal am = new BigDecimal(Float.parseFloat(amex));
            BigDecimal vi = new BigDecimal(Float.parseFloat(visa));
            BigDecimal ma = new BigDecimal(Float.parseFloat(mastercard));
            BigDecimal chq = new BigDecimal(Float.parseFloat(cheque));
            BigDecimal ca = new BigDecimal(Float.parseFloat(cashe));
            BigDecimal gc = new BigDecimal(Float.parseFloat(giftcard));
//            logger.info("Start Add Transaction. User="+user_ses.getFname() + " " + user_ses.getLname());
            Reconciliation trans = Reconciliation.insertTransaction((u != null ? u.getId() : 0), Integer.parseInt(loc), code, Integer.parseInt(cust),
                    s_total, taxe, total, paym, Integer.parseInt(status), DateUtil.parseSqlDate(dt), am, vi, ma, chq, ca, gc, ch, giftcard_pay);
                if (status.equals("0")){
                    ArrayList aa = null;
                    aa = Ticket.findTicketByLocCodeTrans(1,trans.getCode_transaction());
                    if (aa!=null){
                        for (int i=0; i<aa.size(); i++){
                            Ticket tt = (Ticket)aa.get(i);
                            ArrayList ap = Appointment.findAllByTicketId(tt.getId());
                            if (ap!=null){
                                for (int j = 0; j<ap.size(); j++){
                                    Appointment app = (Appointment)ap.get(j);
                                    if (app!=null){
                                        Appointment.updateAppointmentByIdState(app.getId(),3);
                                        Inbox inb = Inbox.findByAppId(app.getId());
                                        if (inb!=null){
                                            Inbox.updateStatus(inb.getId(), 5);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            if (status.equals("4")){
                String[] t = ticket_id.split(" ");
                for(int i = 0; i < t.length; i++){
                    if(!t[i].trim().equals("")){
                        int id_t = Integer.parseInt(t[i].trim());
                    Ticket.updateTicketStatusRefund(id_t,4,trans.getId());
                    }
                }
                //refund to giftcard
                ArrayList allTrans =Reconciliation.findTransByCode(code);
                if(allTrans != null)
                {
                	for(int i = 0; i < allTrans.size(); i++)
                	{
                		Reconciliation ttt = (Reconciliation)allTrans.get(i);
                		if(ttt.getStatus() == 0)
                		{
                			//find the pay trans
                			String giftcardNumber = ttt.getGiftcard_pay();
                			Giftcard usingCard = Giftcard.findByCode(giftcardNumber);
                			Giftcard.updateGiftcard(giftcardNumber, usingCard.getAmount().add(ttt.getGiftcard()));
                		}
                	}
                }

                	

            }
//            logger.info("End Add Transaction. User="+user_ses.getFname() + " " + user_ses.getLname());
            request.setAttribute("MESSAGE", trans != null ? "transaction.added" : "transaction.fail");
            request.setAttribute("OBJECT", trans);
            if (trans != null)
                return mapping.findForward("edit");
            else
                return mapping.findForward("add");
        }
        } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)) {
            if (user_ses.getPermission() != Role.R_SHD_CHK && allow_edit){
            BigDecimal s_total = new BigDecimal(Float.parseFloat(s_total_));
            BigDecimal taxe = new BigDecimal(Float.parseFloat(taxe_));
            BigDecimal total = new BigDecimal(Float.parseFloat(total_));
            BigDecimal ch = new BigDecimal(Float.parseFloat(change));
            BigDecimal am = new BigDecimal(Float.parseFloat(amex));
            BigDecimal vi = new BigDecimal(Float.parseFloat(visa));
            BigDecimal ma = new BigDecimal(Float.parseFloat(mastercard));
            BigDecimal chq = new BigDecimal(Float.parseFloat(cheque));
            BigDecimal ca = new BigDecimal(Float.parseFloat(cashe));
            BigDecimal gc = new BigDecimal(Float.parseFloat(giftcard));
            int st = Integer.parseInt(status);
            if (st == 2){
                Reconciliation rec = Reconciliation.findById(Integer.parseInt(id));
                if (rec != null){
                    st = rec.getStatus();
                }
            }
//            logger.info("Start Edit Transaction. User="+user_ses.getFname() + " " + user_ses.getLname());
            Reconciliation trans = Reconciliation.updateTransaction((u != null ? u.getId() : 0), Integer.parseInt(id), Integer.parseInt(loc), code, Integer.parseInt(cust),
                    s_total, taxe, total, paym, st, DateUtil.parseSqlDate(dt), am, vi, ma, chq, ca, gc, ch, giftcard_pay);
            if (status.equals("0")){
                ArrayList ara = null;
                ara = Ticket.findTicketByLocCodeTrans(1,trans.getCode_transaction());
                if (ara!=null){
                    for (int i=0; i<ara.size(); i++){
                        Ticket tt = (Ticket)ara.get(i);
                        ArrayList ap = Appointment.findAllByTicketId(tt.getId());
                        if (ap!=null){
                            for (int j = 0; j<ap.size(); j++){
                                Appointment app = (Appointment)ap.get(j);
                                if (app!=null){
                                    Appointment.updateAppointmentByIdState(app.getId(),3);
                                    Inbox inb = Inbox.findByAppId(app.getId());
                                    if (inb!=null){
                                        Inbox.updateStatus(inb.getId(), 5);
                                    }
                                }
                            }
                        }
                    }
                }
            }
//            logger.info("End Edit Transaction. User="+user_ses.getFname() + " " + user_ses.getLname());
            request.setAttribute("MESSAGE", trans != null ? "transaction.edited" : "transaction.fail");
            request.setAttribute("OBJECT", trans);
            return mapping.findForward("edit");
        }
        } else if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
            if (user_ses.getPermission() != Role.R_SHD_CHK && allow_edit){
//            logger.info("Start Delete Transaction. User="+user_ses.getFname() + " " + user_ses.getLname());
            Reconciliation trans = Reconciliation.deleteTransaction((u != null ? u.getId() : 0), Integer.parseInt(id));
//            logger.info("End Delete Transaction. User="+user_ses.getFname() + " " + user_ses.getLname());
            request.setAttribute("MESSAGE", trans != null ? "transaction.edited" : "transaction.fail");
            ActionForward af = new ActionForward(mapping.findForward("list"));
            af.setPath(af.getPath() + "?dt=" + date);
            return af;//mapping.findForward("list");
            }
        }
        return mapping.findForward("default");
    }
}
