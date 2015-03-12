package org.xu.swan.action;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.xu.swan.bean.Employee;
import org.xu.swan.bean.User;

public class LoginEmpConfigServlet extends HttpServlet{
	private Logger log = Logger.getLogger(LoginEmpConfigServlet.class);
	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String action = request.getParameter("action");
		if("load_all".equals(action)){
			loadAll(request, response);
			
		}else if("update".equals(action)){
			update(request, response);
		}else if("load_all_user".equals(action)){
			loadAllUser(request, response);
		}
		
	}

	private void loadAllUser(HttpServletRequest request, HttpServletResponse response){
		log.debug("LoginEmpConfigServlet loadAllUser....");
		try {
			
			ArrayList<User> users = User.findAll();
			String json = "";
			for (int i=0; i<users.size(); i++) {
				User user = users.get(i);
				json += "{\"id\": "+user.getId()+", \"fname\":\""+user.getFname()+"\", \"lname\":\""+user.getLname()+"\"}";
				if((i+1)<users.size()){
					json+=",";
				}
			}
			response.getWriter().write("["+json+"]");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void update(HttpServletRequest request, HttpServletResponse response) {
		log.debug("LoginEmpConfigServlet update....");
		String empids = request.getParameter("employee_ids");
		String id = request.getParameter("id");
		try {
			User user = User.findById(Integer.parseInt(id));
			
			log.debug("user id:"+id+", empids:"+empids);
			if(empids!=null && "".equals(empids)==false)
				if(empids.charAt(empids.length()-1)!=-1){
					empids = empids.substring(0, empids.length()-1);
				}
			Boolean result = User.updateEmployees(user.getId(), empids);
			response.getWriter().write(result.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void loadAll(HttpServletRequest request,
			HttpServletResponse response) {
		
		log.debug("LoginEmpConfigServlet loadAll....");
		
		String id = request.getParameter("id");
		try {
			User user = User.findById(Integer.parseInt(id));
			
			ArrayList<Employee> emps = Employee.findAll();
			if(user.getEmployees()!=null){
				String[] userEmps = user.getEmployees().split(",");
				for (int i = 0; i < userEmps.length; i++) {
					for (int j = 0; j < emps.size(); j++) {
						Employee e = emps.get(j);
						if(Integer.parseInt(userEmps[i])==e.getId()){
							e.setChecked(true);
						}
					}
				}
			}
			
			String json = "";
			for (int i=0; i<emps.size(); i++) {
				Employee emp = emps.get(i);
				json += "{\"id\": "+emp.getId()+", \"fname\":\""+emp.getFname()+"\", \"lname\":\""+emp.getLname()+"\", \"checked\":"+emp.isChecked()+"}";
				if((i+1)<emps.size()){
					json+=",";
				}
			}
			response.getWriter().write("["+json+"]");
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	
	
}
