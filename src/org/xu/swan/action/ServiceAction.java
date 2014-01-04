package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.bean.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;

public class ServiceAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Service.ID),"");
        String name = StringUtils.defaultString(request.getParameter(Service.NAME),"");
        String cate_id = StringUtils.defaultString(request.getParameter(Service.CATE),"");
        String price = StringUtils.defaultString(request.getParameter(Service.PRICE),"");
        String duration = StringUtils.defaultString(request.getParameter(Service.DURATION),"");
        String taxes = StringUtils.defaultString(request.getParameter(Service.TAXES),"");
        String code = StringUtils.defaultString(request.getParameter(Service.CODE),"");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            Service serv = Service.insertService(name,Integer.parseInt(cate_id),2, new BigDecimal(price), Integer.parseInt(duration), new BigDecimal(taxes), code);
            request.setAttribute("MESSAGE",serv!=null?"service.added":"service.fail");
            request.setAttribute("OBJECT",serv);
            if(serv!=null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            Service serv = Service.updateService(Integer.parseInt(id),name,Integer.parseInt(cate_id),2, new BigDecimal(price), Integer.parseInt(duration), new BigDecimal(taxes),code);
            request.setAttribute("MESSAGE",serv!=null?"service.edited":"service.fail");
            request.setAttribute("OBJECT",serv);
            return mapping.findForward("list");
        }

        return mapping.findForward("default");
    }
}
