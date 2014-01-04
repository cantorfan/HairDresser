package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.bean.Category;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CategoryAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Category.ID),"");
        String name = StringUtils.defaultString(request.getParameter(Category.NAME),"");
        String details = StringUtils.defaultString(request.getParameter(Category.DETAILS),"");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            Category cate = Category.insertCategory(name,details);
            request.setAttribute("MESSAGE",cate!=null?"category.added":"category.fail");
            request.setAttribute("OBJECT",cate);
            if(cate!=null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            Category cate = Category.updateCategory(Integer.parseInt(id),name,details);
            request.setAttribute("MESSAGE",cate!=null?"category.edited":"category.fail");
            request.setAttribute("OBJECT",cate);
            return mapping.findForward("list");
        }

        return mapping.findForward("default");
    }
}
