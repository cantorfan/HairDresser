package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.DateUtil;
import org.xu.swan.bean.Cashio;
import org.xu.swan.bean.User;
import org.xu.swan.bean.Role;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;

public class CashioAction  extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession(true);
        User user_ses = (User) session.getAttribute("user");
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Cashio.ID),"");
        String cdt = StringUtils.defaultString(request.getParameter(Cashio.CDT),"");
        String in = StringUtils.defaultString(request.getParameter(Cashio.IN),"");
        String out = StringUtils.defaultString(request.getParameter(Cashio.OUT),"");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            if (user_ses.getPermission() != Role.R_SHD_CHK) {
                BigDecimal i = BigDecimal.valueOf(Float.parseFloat(in));
                BigDecimal o = BigDecimal.valueOf(Float.parseFloat(out));
                Cashio cash = Cashio.insertCashio(DateUtil.parseSqlDate(cdt), i, o);
                request.setAttribute("MESSAGE",cash!=null?"cashio.added":"cashio.fail");
                request.setAttribute("OBJECT",cash);
                if(cash!=null)
                    return mapping.findForward("list");
                else
                    return mapping.findForward("add");
            }
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            if (user_ses.getPermission() != Role.R_SHD_CHK) {
                BigDecimal i = BigDecimal.valueOf(Float.parseFloat(in));
                BigDecimal o = BigDecimal.valueOf(Float.parseFloat(out));
                Cashio cash = Cashio.updateCashio(Integer.parseInt(id),DateUtil.parseSqlDate(cdt), i, o);
                request.setAttribute("MESSAGE",cash!=null?"cashio.edited":"cashio.fail");
                request.setAttribute("OBJECT",cash);
                return mapping.findForward("list");
            }
        }

        return mapping.findForward("default");
    }
}
