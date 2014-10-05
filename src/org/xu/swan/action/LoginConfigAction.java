package org.xu.swan.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.xu.swan.bean.User;
import org.xu.swan.util.ActionUtil;

public class LoginConfigAction extends org.apache.struts.action.Action{

	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), "");
		
		if(action.equalsIgnoreCase("submit")){
			
			response.setCharacterEncoding("UTF-8");
			try {
				PrintWriter out=response.getWriter();
				String id=request.getParameter("id");
				if(id.isEmpty()){
					out.write("failure");
					return null;
				}
				
				Integer intID = Integer.parseInt(id);
				User user = User.findById(intID);
				//user.setIps(request.getParameter("ips"));
				String ips = request.getParameter("ips");
				if(ips!=null){
					if(ips.indexOf("*")!=-1)
						ips = "*";
					else
						ips = ips.replaceAll("\\,+", ",").replaceAll("^\\,", "").replace("\\,$", "");
				}
				
				User.updateUser(intID, user.getFname(), user.getLname(), user.getUser(), user.getPwd(), user.getEmail(), user.getPermission(), user.getSend_email(), ips);
				
				out.write("success");
				out.close();
			} catch (IOException e) { 
				e.printStackTrace();
			}
			
			return null;
		}else if(action.equals("load")){
			//load user ip;
			//request.getSession().setAttribute("users", list);
			//String ips = "192.168.1.1,174.64.222.11, 196.172.22.100";
			String id=request.getParameter("id");
			id = StringUtils.defaultString(id, "0");
			User user = User.findById(Integer.parseInt(id));
			String ips=user.getIps() == null? "" : user.getIps();
			
			response.setCharacterEncoding("UTF-8");
			try {
				
				PrintWriter out=response.getWriter();
				out.write(ips);
				out.close(); 
			} catch (IOException e) { 
				e.printStackTrace();
			}
			
			return null;
		}
		
		//init load users
		ArrayList arrlUser = User.findAll();
		
		request.setAttribute("users", arrlUser);
		return mapping.findForward("init");
	}

}
