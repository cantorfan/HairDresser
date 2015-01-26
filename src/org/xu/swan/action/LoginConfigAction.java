package org.xu.swan.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.xu.swan.bean.User;
import org.xu.swan.util.ActionUtil;

public class LoginConfigAction extends org.apache.struts.action.Action{
	private Logger log = Logger.getLogger(LoginConfigAction.class);
	
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
				log.debug(ips);
				if(ips!=null){
					if(ips.indexOf("*")!=-1)
						ips = "*";
					else
						ips = ips.replaceAll("\\,+", ",").replaceAll("^\\,", "").replace("\\,$", "");
				}
				
				log.debug(ips);
				User.updateUser(intID, user.getFname(), user.getLname(), user.getUser(), user.getPwd(), user.getEmail(), user.getPermission(), user.getSend_email(), ips);
				
				out.write("success");
				out.close();
			} catch (IOException e) { 
				e.printStackTrace();
			}
			
			return null;
		}else if(action.equals("load")){ //Deprecated
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
		}else if(action.equals("load_all")){
			List<User> users = User.findAll();
			String id=request.getParameter("id");
			
			/*
			 {
			 	"checked" : ["192.168.1.1", "192.168.12.2"],
			 	"unchecked" : ["192.168.1.11","192.168.2.13"]
			 }
			 */
			 
			String checked = "";
			
			String ipsJson = "{";
			Set<String> unchecks = new HashSet<String>();
			for(int i=0; i<users.size(); i++){
				User user = users.get(i);
				if(Integer.parseInt(id) == user.getId()){
					checked = user.getIps() == null? "" : user.getIps();
				}else{
					String ips = user.getIps();
					if(ips!=null && ips.length()>0){
						//unchecked+=ips+",";
						unchecks.addAll(Arrays.asList(ips.split(",")));
					}
				}
			}
			
			if(checked.length()>0){
				checked = checked.replace(",", "\",\"");
				checked = "[\"" + checked + "\"]";
				
				ipsJson += "\"checked\":"+checked+",";
			}else{
				ipsJson += "\"checked\":[],";
			}
			
			if(unchecks.size() > 0){
				
				String tmp = "";
				Iterator<String> itr = unchecks.iterator();
				while (itr.hasNext()) {
					tmp+="\""+itr.next()+"\"";
					if(itr.hasNext())
						tmp+=",";
				}
				
				tmp = "["+tmp+"]";
				
				ipsJson += "\"unchecked\":"+tmp;
				
			}else{
				ipsJson += "\"unchecked\":[]";
			}
			
			ipsJson += "}";
			
			log.debug(ipsJson);
			try {
				
				PrintWriter out=response.getWriter();
				out.write(ipsJson);
				out.close(); 
			} catch (IOException e) { 
				e.printStackTrace();
			}
			
			
		}
		
		//init load users
		ArrayList arrlUser = User.findAll();
		
		request.setAttribute("users", arrlUser);
		return mapping.findForward("init");
	}
	
}
