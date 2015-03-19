package org.xu.swan.action;

import java.util.Arrays;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.bean.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserAction extends org.apache.struts.action.Action {
	private Logger log = Logger.getLogger(UserAction.class);
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(User.ID),"");
        String fname = StringUtils.defaultString(request.getParameter(User.FNAME),"");
        String lname = StringUtils.defaultString(request.getParameter(User.LNAME),"");
        String user = StringUtils.defaultString(request.getParameter(User.USER),"");
        String pwd = StringUtils.defaultString(request.getParameter(User.PWD),"");
        String email = StringUtils.defaultString(request.getParameter(User.EMAIL),"");
        String perm = StringUtils.defaultString(request.getParameter(User.PERM),"");
        String send_email = StringUtils.defaultString(request.getParameter(User.Send_EMAIL),"");
        String[] employeeIds = request.getParameterValues("empOption");
        String[] ipstr = request.getParameterValues("IPOption");
        
        String empids = null;
        String ips = null;
        if(employeeIds!=null){
        	empids = Arrays.toString(employeeIds);
        	empids = empids.replace("[", "").replace("]", "").replace(" ", "");
        }
        if(ipstr!=null){
        	ips =  Arrays.toString(ipstr);
        	ips = ips.replace("[", "").replace("]", "").replace(" ", "");
        }
        log.debug("employeeIds:"+empids);
        log.debug("ips:"+ips);
        
        int iSend_Email = 0;
        if(send_email.equals("on"))
            iSend_Email = 1;

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            User u = User.insertUser(fname,lname,user,pwd,email,Integer.parseInt(perm),iSend_Email, ips, empids);
            request.setAttribute("MESSAGE",u!=null?"user.added":"user.fail");
            request.setAttribute("OBJECT",u);
            if(u!=null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            User u = User.updateUser(Integer.parseInt(id),fname,lname,user,pwd,email,Integer.parseInt(perm),iSend_Email, ips, empids);
            request.setAttribute("MESSAGE",u!=null?"user.edited":"user.fail");
            request.setAttribute("OBJECT",u);
            return mapping.findForward("edit");
        }

        return mapping.findForward("default");
    }
}
