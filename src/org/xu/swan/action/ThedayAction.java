package org.xu.swan.action;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.bean.Theday;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.DateUtil;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

public class ThedayAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Theday.ID),"");
        String loc = StringUtils.defaultString(request.getParameter(/*Theday.LOC*/"loc"),"1");
        String dt = StringUtils.defaultString(request.getParameter(/*Theday.CDT*/"dt"),"");
        String begin = StringUtils.defaultString(request.getParameter(Theday.BEGIN),"0");
        String cash = StringUtils.defaultString(request.getParameter(/*Theday.CASH*/"cash"),"0");
        String card = StringUtils.defaultString(request.getParameter(/*Theday.CARD*/"card"), "0");
        String cheque = StringUtils.defaultString(request.getParameter(/*Theday.CHQ*/"cheque"),"0");
        String end = StringUtils.defaultString(request.getParameter(/*Theday.CEND*/"subdrawer"), "0");
        String drawer = StringUtils.defaultString(request.getParameter(/*Theday.CDRW*/"actualdrawer"), "0");
        String adj = StringUtils.defaultString(request.getParameter(/*Theday.ADJ*/"adjustment"), "0");
        String pie = StringUtils.defaultString(request.getParameter(/*Theday.PIE*/"pitinenv"), "0");
        String amex = StringUtils.defaultString(request.getParameter(/*Theday.AMEX*/"amex"), "0");
        String mastercard = StringUtils.defaultString(request.getParameter(/*Theday.MASTERCARD*/"mastercard"), "0");
        String visa = StringUtils.defaultString(request.getParameter(/*Theday.VISA*/"visa"), "0");
        String creditcard = StringUtils.defaultString(request.getParameter(/*Theday.CREDITCARD*/"creditcard"), "0");
        String cashin = StringUtils.defaultString(request.getParameter(/*Theday.CASHIN*/"cashin"), "0");
        String cashout = StringUtils.defaultString(request.getParameter(/*Theday.CASHOUT*/"cashout"), "0");
        String totalcash = StringUtils.defaultString(request.getParameter(/*Theday.TOTALCASH*/"totalcash"), "0");
        String endoftheday = StringUtils.defaultString(request.getParameter(/*Theday.ENDOFTHEDAY*/"endoftheday"), "0");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            BigDecimal begin_p = BigDecimal.valueOf(Float.parseFloat(begin));
            BigDecimal cash_p = BigDecimal.valueOf(Float.parseFloat(cash));
            BigDecimal card_p = BigDecimal.valueOf(Float.parseFloat(card));
            BigDecimal cheque_p = BigDecimal.valueOf(Float.parseFloat(cheque));
            BigDecimal end_p = BigDecimal.valueOf(Float.parseFloat(end));
            BigDecimal drawer_p = BigDecimal.valueOf(Float.parseFloat(drawer));
            Theday day = Theday.insertTheday(DateUtil.parseSqlDate(dt),cash_p, cheque_p,card_p,begin_p,end_p,drawer_p,Integer.parseInt(loc));
            request.setAttribute("MESSAGE",day!=null?"Theday.added":"Theday.fail");
            request.setAttribute("OBJECT",day);
            if(day!=null)
                return mapping.findForward("chk");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            BigDecimal begin_p = BigDecimal.valueOf(Float.parseFloat(begin));
            BigDecimal cash_p = BigDecimal.valueOf(Float.parseFloat(cash));
            BigDecimal card_p = BigDecimal.valueOf(Float.parseFloat(card));
            BigDecimal cheque_p = BigDecimal.valueOf(Float.parseFloat(cheque));
            BigDecimal end_p = BigDecimal.valueOf(Float.parseFloat(end));
            BigDecimal drawer_p = BigDecimal.valueOf(Float.parseFloat(drawer));
            BigDecimal adj_p = BigDecimal.valueOf(Float.parseFloat(adj));
            BigDecimal pie_p = BigDecimal.valueOf(Float.parseFloat(pie));
            BigDecimal amex_p = BigDecimal.valueOf(Float.parseFloat(amex));
            BigDecimal mastercard_p = BigDecimal.valueOf(Float.parseFloat(mastercard));
            BigDecimal visa_p = BigDecimal.valueOf(Float.parseFloat(visa));
            BigDecimal creditcard_p = BigDecimal.valueOf(Float.parseFloat(creditcard));
            BigDecimal cashin_p = BigDecimal.valueOf(Float.parseFloat(cashin));
            BigDecimal cashout_p = BigDecimal.valueOf(Float.parseFloat(cashout));
            BigDecimal totalcash_p = BigDecimal.valueOf(Float.parseFloat(totalcash));
            BigDecimal endoftheday_p = BigDecimal.valueOf(Float.parseFloat(endoftheday));
            Integer loc_p = Integer.valueOf(loc);
            Integer id_p = Integer.valueOf(id);
            Theday day = Theday.updateTheday(id_p,DateUtil.parseSqlDate(dt),cash_p, cheque_p,card_p,begin_p,end_p,drawer_p,loc_p, adj_p, pie_p, amex_p, mastercard_p, visa_p, creditcard_p, cashin_p, cashout_p, totalcash_p, endoftheday_p);
            request.setAttribute("MESSAGE",day!=null?"Theday.edited":"Theday.fail");
            request.setAttribute("OBJECT",day);
            return mapping.findForward("chk");
        }

        return mapping.findForward("default");
    }
}
