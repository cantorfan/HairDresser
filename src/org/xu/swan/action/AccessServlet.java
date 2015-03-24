package org.xu.swan.action;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.xu.swan.bean.Location;
import org.xu.swan.bean.Role;
import org.xu.swan.bean.User;

public class AccessServlet  extends HttpServlet {
    protected Logger logger = LogManager.getLogger(getClass());
    public void init() {
    
        logger.info("AccessServlet initialized.");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
    	
        HttpSession session = request.getSession(true);
        String query = StringUtils.defaultString(request.getParameter("query"), "");

        String UserIP;
        String fIP = request.getHeader("HTTP_X_FORWARDED_FOR"); //IP-����� ������� ���
                                                   //����������� ����� ����������� ������
        if (fIP != null)
        {
            UserIP = fIP;
        }
        else //��������� IP-����� �������
        {
            UserIP = request.getRemoteAddr();
        }
        
        logger.debug("fIP:"+fIP+", UserIP:"+UserIP);
        
        try{
            if(query.equalsIgnoreCase("login")){
                String u = StringUtils.defaultString(request.getParameter("user"), "");
                String p = StringUtils.defaultString(request.getParameter("pwd"), "");
                String ip = request.getRemoteAddr();
                User user = User.findUser(u,p);
                Location loc = Location.findById(1);
                
                logger.debug("u:"+u+", p:"+p+", ip:"+ip+", user: "+user);
                
                if(user==null) {
                	logger.debug("111111");
                    logger.info("Error login. login/pass not foung. login/pass='"+u+"/"+p+"' IP: "+UserIP); 
                    session.setAttribute("loginErrorMessage", "Error login. login/pass not foung. ");
                    response.sendRedirect("index.jsp");
                    return;
                }
                
                String ips = user.getIps();
                boolean isExistIP=false;// 
                if(StringUtils.isEmpty(ips)){
                	logger.debug("222222");
                	isExistIP = true;
                }else{
                	if(ips.indexOf("*")!=-1){
                		logger.debug("3333333");
                		isExistIP = true;
                	}else if(ips.indexOf(ip)!=-1){
                		logger.debug("444444");
                		isExistIP = true;
                	}
                	
                }
                if(!isExistIP){
                	logger.debug("555555");
                	 String eror = "Error login. IP nonexistence: "+UserIP;
                     logger.info(eror); 
                     session.setAttribute("loginErrorMessage", eror);
                     response.sendRedirect("index.jsp");
                     return;
                }
                
                if(loc==null) {
                	logger.debug("666666");
                    String eror = "Error login. Location Not Found IP: "+UserIP;
                    logger.info(eror); 
                    session.setAttribute("loginErrorMessage", eror);
                    response.sendRedirect("index.jsp");
                    return;
                }
                logger.info("Success login. login='"+u+"' IP: "+UserIP);                                    
                session.setMaxInactiveInterval(3600);
                request.getSession(true).setAttribute("user", user);
                request.getSession(true).setAttribute("location", loc);
                request.getSession(true).setAttribute("ipuser", UserIP);
                
                Set<Integer> empPermission = new HashSet<Integer>();
                String employees = user.getEmployees();
      	  		if(employees!=null && "".equals(employees)==false){
      	  			String[] emps = employees.split(",");
      	  			for (String emp : emps) {
      	  				empPermission.add(Integer.parseInt(emp));
      	  			}
      	  		}
	          	  
                request.getSession(true).setAttribute("ipuser", UserIP);
                request.getSession(true).setAttribute("empPermission", empPermission);
//                String timezone = Location.getTimezoneForLocation(1);
//                TimeZone asd = TimeZone.getTimeZone(timezone);
//                TimeZone.setDefault(asd);
                if(user.getPermission()==Role.R_ADMIN)
                    response.sendRedirect("./admin/admin.jsp");
                else if(user.getPermission()== Role.R_RECEP)
                    response.sendRedirect("checkout.do");
                else
                    response.sendRedirect("schedule.do");
                return;
            }
            else if(query.equalsIgnoreCase("logout")){
//                session.removeAttribute("user");
                session.invalidate();
                response.sendRedirect("index.jsp");
                return;
            }
            else if(query.equalsIgnoreCase("recoveryPwd")){
                String email = StringUtils.defaultString(request.getParameter("email"), "");
                if (StringUtils.isEmpty(email)) {
                    response.sendRedirect("index.jsp");
                    return;
                }
                String newPwd = User.changePwdByEmail(email);
                response.sendRedirect("index.jsp");
                return;
            }else if(query.equalsIgnoreCase("permission")){
            	@SuppressWarnings("unchecked")
				Set<Integer> empPermission  = (Set<Integer>) request.getSession(true).getAttribute("empPermission");
            	Integer employeeId = Integer.parseInt(request.getParameter("employeeId"));
            	if(empPermission.contains(employeeId)){
            		response.getWriter().write("{\"status\":true}");
            	}else {
            		response.getWriter().write("{\"status\":false, \"message\":\"not permission\"}");
            	}
            }
        }catch(Exception ex){
            response.getWriter().write(ex.getMessage());//ex.printStackTrace();
        }

//        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
}
