<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%
    //session.setMaxInactiveInterval(60*180);

    User u = (User) session.getAttribute("user");
    if (u == null) {
        request.setAttribute("error", "Your must login or session expired.");
        pageContext.forward("/index.jsp");
    } else {
        String r = request.getParameter("role");
        if (StringUtils.isNotEmpty(r)) {//Ignore permissions if empty
            int role = -1;
            if (r.compareToIgnoreCase(Role.S_ADMIN) == 0) role = Role.R_ADMIN;
            if (r.compareToIgnoreCase(Role.S_RECEP) == 0) role = Role.R_RECEP;
            if (r.compareToIgnoreCase(Role.S_EMP) == 0) role = Role.R_EMP;
            if (r.compareToIgnoreCase(Role.S_SHD_CHK) == 0) role = Role.R_SHD_CHK;

            int real_role = u.getPermission();

            if ( real_role != role && real_role != Role.R_ADMIN)
                pageContext.forward("/index.jsp");
        }
    }
%>