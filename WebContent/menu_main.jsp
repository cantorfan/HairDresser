<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%
    String homeOn = activePage.equals("Home") ? "_on" : "";
    String adminOn = activePage.equals("Admin") ? "_on" : "";
    String scheduleOn = activePage.equals("Schedule") ? "_on" : "";
    String checkoutOn = activePage.equals("Checkout") ? "_on" : "";
    String inboxOn = activePage.equals("Inbox") ? "_on" : "";
%>
<div class="navigation">
<ul style="width: 100%">
    <li style="float: left; margin-top: 12px; margin-left: 5px"><a href="<%=rootPath%>index.jsp"><img src="<%=rootPath%>img/signout_button.png" alt="" border="0"/></a></li>
    <li><a href="<%=rootPath%>index.jsp"><img src="<%=rootPath%>img/menu_home<%=homeOn%>.png" alt="" border="0"/></a></li>
    <%
            User sess_user = (User) session.getAttribute("user");
            if (sess_user != null && sess_user.getPermission() == Role.R_ADMIN) {
        %>
    <li><a href="<%=rootPath%>admin/admin.jsp"><img src="<%=rootPath%>img/menu_admin<%=adminOn%>.png" alt="" border="0"/></a></li>
    <%}%>
    <li><a href="<%=rootPath%>schedule.do"><img src="<%=rootPath%>img/menu_schedule<%=scheduleOn%>.png" alt="" border="0"/></a></li>
    <%
    if (sess_user != null && ((sess_user.getPermission() == Role.R_ADMIN) || (sess_user.getPermission() == Role.R_RECEP) || (sess_user.getPermission() == Role.R_SHD_CHK))) {
    %>
    <li><a href="<%=rootPath%>checkout_main.jsp"><img src="<%=rootPath%>img/menu_checkout<%=checkoutOn%>.png" alt="" border="0"/></a></li>
    <%}%>
    <li><a href="<%=rootPath%>inbox.jsp"><img src="<%=rootPath%>img/menu_inbox<%=inboxOn%>.png" alt="" border="0"/></a></li>
    <%
        String __date = StringUtils.defaultString(request.getParameter("dt"), "");
    %>
    <%--<li style="position: relative; float: right; top: -46px; height: 1px">--%>
        <%--<a href="<%=rootPath%>checkout_main.jsp?dt=<%=__date%>"><img src="<%=rootPath%>img/posreconcilation_button.png" alt="" border="0"/></a>--%>
    <%--</li>--%>
</ul>
</div>
