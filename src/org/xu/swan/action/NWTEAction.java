package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.DateUtil;
import org.xu.swan.bean.User;
import org.xu.swan.bean.NotWorkingtimeEmp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Time;
import java.sql.Date;
import java.text.SimpleDateFormat;

public class NWTEAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(NotWorkingtimeEmp.ID),"");
        String emp = StringUtils.defaultString(request.getParameter(NotWorkingtimeEmp.EMP),"");
        String date = StringUtils.defaultString(request.getParameter(NotWorkingtimeEmp.WDATE),"");
        String from = StringUtils.defaultString(request.getParameter(NotWorkingtimeEmp.FROM),"");
        String to = StringUtils.defaultString(request.getParameter(NotWorkingtimeEmp.TO),"");
        String comment = StringUtils.defaultString(request.getParameter(NotWorkingtimeEmp.COMMENT),"");

        int emp2 = Integer.parseInt(emp);
        Date date2 = DateUtil.toSqlDate((new SimpleDateFormat("yyyy/MM/dd")).parse(date));
        Time from2 = Time.valueOf(from);
        Time to2 = Time.valueOf(to);
//        String comment2 = StringUtils.defaultString(request.getParameter(NotWorkingtimeEmp.COMMENT),"");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            NotWorkingtimeEmp nwte = NotWorkingtimeEmp.insertWTEmp(emp2, from2, to2, comment, date2);
//            NotWorkingtimeEmp nwte = NotWorkingtimeEmp.insertWTEmp(Integer.parseInt(emp), Time.valueOf(from), Time.valueOf(to), comment, Date.valueOf(date));
            request.setAttribute("MESSAGE",nwte!=null?"nwte.added":"nwte.fail");
            request.setAttribute("OBJECT",nwte);
            if(nwte!=null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            int id2 = Integer.parseInt(id);
            NotWorkingtimeEmp nwte = NotWorkingtimeEmp.updateWTEmp(id2, emp2, from2, to2, comment, date2);
//            NotWorkingtimeEmp nwte = NotWorkingtimeEmp.updateWTEmp(Integer.parseInt(id), Integer.parseInt(emp), Time.valueOf(from), Time.valueOf(to), comment, Date.valueOf(date));
            request.setAttribute("MESSAGE",nwte!=null?"nwte.edited":"nwte.fail");
            request.setAttribute("OBJECT",nwte);
            return mapping.findForward("edit");
        }

        return mapping.findForward("default");
    }
}