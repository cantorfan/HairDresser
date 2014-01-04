package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.bean.Brand;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BrandAction  extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Brand.ID),"");
        String name = StringUtils.defaultString(request.getParameter(Brand.NAME),"");
        String brand_id = StringUtils.defaultString(request.getParameter(Brand.VENDOR),"");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            Brand cBrand = Brand.insertBrand(name, Integer.parseInt(brand_id));
            request.setAttribute("MESSAGE",cBrand!=null?"brand.added":"brand.fail");
            request.setAttribute("OBJECT",cBrand);
            if(cBrand!=null)
                return mapping.findForward("edit");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            Brand cBrand = Brand.updateBrand(Integer.parseInt(id),name, Integer.parseInt(brand_id));
            request.setAttribute("MESSAGE",cBrand!=null?"Brand.edited":"Brand.fail");
            request.setAttribute("OBJECT",cBrand);
            return mapping.findForward("edit");
        }

        return mapping.findForward("default");
    }
}
