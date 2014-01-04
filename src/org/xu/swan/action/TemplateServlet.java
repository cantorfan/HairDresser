package org.xu.swan.action;

import org.xu.swan.bean.User;
import org.xu.swan.bean.EmailTemplate;
import org.xu.swan.util.ActionUtil;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import java.io.IOException;
import java.util.ArrayList;

public class TemplateServlet extends HttpServlet {
        public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try{
            HttpSession session = request.getSession(true);
            User user_ses = (User) session.getAttribute("user");

            if (user_ses != null){

                String action = request.getParameter("action");
                if (action.equals("gettemplate")){

                } else if (action.equals("add")){
                    String location_id = StringUtils.defaultString(request.getParameter(EmailTemplate.LOC), "1");
                    String type = StringUtils.defaultString(request.getParameter(EmailTemplate.TYPE), "1");
                    String text = StringUtils.defaultString(request.getParameter(EmailTemplate.TEXT), "");
                    String description = StringUtils.defaultString(request.getParameter(EmailTemplate.DESCR), "");
                    EmailTemplate etp = EmailTemplate.insertTemplate(Integer.parseInt(location_id), Integer.parseInt(type),text, description);
                    if (etp!=null){
                        response.sendRedirect("admin/list_emailtemplate.jsp");
                    } else {
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        response.getOutputStream().print("Error: Failed to add Template.");
                    }
                } else if (action.equals("edit")){
                    String id = request.getParameter("id");
                    String location_id = StringUtils.defaultString(request.getParameter(EmailTemplate.LOC), "1");
                    String type = StringUtils.defaultString(request.getParameter(EmailTemplate.TYPE), "1");
                    String text = StringUtils.defaultString(request.getParameter(EmailTemplate.TEXT), "");
                    String description = StringUtils.defaultString(request.getParameter(EmailTemplate.DESCR), "");
                    EmailTemplate etp = EmailTemplate.updateTemplate(Integer.parseInt(id),Integer.parseInt(location_id), Integer.parseInt(type),text, description);
                    if (etp!= null){
                        response.sendRedirect("admin/list_emailtemplate.jsp");
                    } else {
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        response.getOutputStream().print("Error: Failed to edit Template.");
                    }
                }
//                else if (action.equals("delete")){
//                    String id = request.getParameter("id");
//                    EmailTemplate etp = EmailTemplate.deleteTemplate(Integer.parseInt(id));
//                    if (etp != null){
//                        response.setContentType("text/html");
//                        response.setCharacterEncoding("UTF-8");
//                        response.getOutputStream().print("");
//                    } else {
//                        response.setContentType("text/html");
//                        response.setCharacterEncoding("UTF-8");
//                        response.getOutputStream().print("Error: Failed to delete Template.");
//                    }
//                }
            }  else {
                    response.setContentType("text/html");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("REDIRECT:../error.jsp?ec=1");
                }
        }catch(Exception e){
            response.getOutputStream().print(
                        e.toString() + "" + " Please refresh this Page!"
                    );
            e.printStackTrace();
        }
    }
}
