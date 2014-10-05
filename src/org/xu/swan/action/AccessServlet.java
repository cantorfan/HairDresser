package org.xu.swan.action;

import org.apache.commons.lang.StringUtils;
import org.xu.swan.bean.Location;
import org.xu.swan.bean.User;
import org.xu.swan.bean.Role;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import java.io.IOException;
import java.util.TimeZone;

import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;

public class AccessServlet  extends HttpServlet {
    protected Logger logger = LogManager.getLogger(getClass());
    public void init() {
        System.out.println("AccessServlet initialized.");
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

        try{
            if(query.equalsIgnoreCase("login")){
                String u = StringUtils.defaultString(request.getParameter("user"), "");
                String p = StringUtils.defaultString(request.getParameter("pwd"), "");
                String ip = request.getRemoteAddr();
                User user = User.findUser(u,p);
                Location loc = Location.findById(1);
                if(user==null) {
                    logger.info("Error login. login/pass not foung. login/pass='"+u+"/"+p+"' IP: "+UserIP);                    
                    response.sendRedirect("index.jsp");
                    return;
                }
                
                String ips = user.getIps();
                boolean isExistIP=false;// 
                if(StringUtils.isEmpty(ips)){
                	isExistIP = true;
                }else{
                	
                	if(ips.indexOf("*")!=-1){
                		isExistIP = true;
                	}else if(ips.indexOf(ip)!=-1){
                		isExistIP = true;
                	}
                	
                }
                if(!isExistIP){
                	 logger.info("Error login. IP nonexistence: "+UserIP);
                     response.sendRedirect("index.jsp");
                     return;
                }
                
                if(loc==null) {
                    logger.info("Error login. Location Not Found IP: "+UserIP);
                    response.sendRedirect("index.jsp");
                    return;
                }
                logger.info("Success login. login='"+u+"' IP: "+UserIP);                                    
                session.setMaxInactiveInterval(3600);
                request.getSession(true).setAttribute("user", user);
                request.getSession(true).setAttribute("location", loc);
                request.getSession(true).setAttribute("ipuser", UserIP);
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
            }
        }catch(Exception ex){
            response.getWriter().write(ex.getMessage());//ex.printStackTrace();
        }

//        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
}
