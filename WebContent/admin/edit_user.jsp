<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="java.util.Set"%>
<%@page import="com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array"%>
<%@page import="org.xu.swan.bean.Employee"%>
<%@page import="org.xu.swan.bean.IP"%>
<%@page import="com.sun.org.apache.bcel.internal.generic.LADD"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Role" %>
<%@ page import="org.xu.swan.util.ResourcesManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Iterator" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-html" prefix="html" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
<%
    User user_ses = (User) session.getAttribute("user");
    if (user_ses == null){
        response.sendRedirect("../error.jsp?ec=1");
        return;
    }
    if (user_ses.getPermission() != Role.R_ADMIN){
        response.sendRedirect("../error.jsp?ec=2");
        return;
    }
    ResourcesManager resx = new ResourcesManager();
    User u = null;
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.ACT_ADD);
    String id = StringUtils.defaultString(request.getParameter(User.ID), ActionUtil.EMPTY);
    if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT) && StringUtils.isNotEmpty(id))
        u = User.findById(Integer.parseInt(id));
    else
        u = (User) request.getAttribute("OBJECT");
    String title = "";
    if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
        title = "Add";
    } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
        title = "Edit";
    }
    
    //load ips
    ArrayList<User> users = User.findAll();
  	//merge ips
  	boolean isAll = false;
  	
  	List<String> userIps = new ArrayList<String>();
 	if(u!=null && u.getIps()!=null && u.getIps().trim().length()>0){
		userIps.addAll(Arrays.asList(u.getIps().split(",")));
		if(userIps.contains("*"))
			isAll = true;
	}
  	
  	HashSet<IP> ips = new HashSet<IP>();
  	for(int i=0; i<users.size(); i++){
		String ipstr = users.get(i).getIps();
		if(ipstr!=null && ipstr.trim().length()>0){
			String[] ipstrs = ipstr.split(",");
			for(int j=0; j<ipstrs.length; j++){
				
				IP ip = new IP(ipstrs[j], false);
				ips.add(ip);
				
				if(userIps.contains(ipstrs[j]))
					ip.setChecked(true);
				
			}
		}
  	}
  	
    //load employees
    ArrayList<Employee> employees = Employee.findAll();
    if(u!=null && u.getEmployees()!=null && u.getEmployees().trim().length()>0){
    	List<String> empIds = Arrays.asList(u.getEmployees().split(","));
    	
    	for(int i=0; i<employees.size(); i++){
    		Employee emp = employees.get(i);
    		String empId = emp.getId()+"";
    		if(empIds.contains(empId)){
    			emp.setChecked(true);
    		}else
    			emp.setChecked(false);
    	}
    }
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Add or edit User</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
		<LINK href="../css/style.css" type=text/css rel=stylesheet>
        <script type="text/javascript" src="../Js/formvalidate.js"></script>
        <script src="../Js/menu.js" type="text/javascript"></script>
        <script src="../plugins/jQuery v1.7.2.js" type="text/javascript"></script>
        <script type="text/javascript" charset="utf-8">
		
		$(document).ready(function(){
			//employee list select all
			var select_all_flag = false;
			$("#select_all").click(function(){
				if(select_all_flag){
					$(".select_name").attr("checked", true);
					$("#select_all").attr("checked", true);
					select_all_flag = false;
				}else{
					$("#select_all").removeAttr("checked");
					$(".select_name").removeAttr("checked");
					select_all_flag = true;
				}
			});
			
			//add new record
			$("#add_new_record").click(function(){
				var newRecord =  $(".add_new_ip_input");
				var value = newRecord.val();
				if(value){
					$("#unlimited").after("<p><input class='ip_checkbox_option' type='checkbox' checked='checked' name='IPOption' value='"+value+"'/>"+value+"</p>");
					$(".add_new_ip_input").val("");
				}
			});
		});
		
	</script>
    <style type="text/css">	
		.clearfix:after{content: "020";  display: block; height: 0;clear: both; visibility: hidden;   }
		.clearfix { zoom: 1; }
		.formbox{float:left; margin-bottom:20px; width:100%;}
		.leftbox, .centerbox, .rightbox{width:320px; float:left;}
		.rightbox{height:300px; margin-left:15px;}
		.rightbox .listtable{height:280px; border:solid 1px #ccc; overflow-x: scroll;padding:5px 10px; }
		.rightbox table{width:100%; border-bottom:1px solid #aaa; border-left: 1px solid #aaa;}
		.listtable{border-bottom:1px solid #aaa; border-left: 1px solid #aaa; }
		.listtable table th{border-right:1px solid #aaa; border-top: 1px solid #aaa; background:#ddd; padding:4px;}
		.listtable table td{border-right:1px solid #aaa; border-top: 1px solid #aaa; cursor: pointer; padding:4px;}
		.listtable table tr:hover{background: #f9f9f9;}
		.listtable td, .listtable tr, .listtable th{text-align:center;}
		
		.centerbox .ip_list{border:1px solid #ccc;padding: 5px; }
		#user_history_ip{border:1px solid #ccc; padding: 10px; overflow-y: scroll;}
		.ip_checkbox_option{position:relative; top:7px; margin-right:8px;}
		.add_new_ip > p{margin-top: 10px; margin-left:15px; font-weight:600;}
		#add_new_ip_box{margin-left:20px;}
		.add_new_ip_input{margin-left:10px;}
		#add_new_record{margin-left:150px;margin-top:10px;margin-bottom:10px;}

    
    </style>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
        <table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
			<tr valign="top">
                <%
                    String activePage = "Admin";
                    String rootPath = "../";
                %>
                <%@ include file="../top_page.jsp" %>
			</tr>
			<tr>
				<td height="47" colspan="3">
                     <%@ include file="../menu_main.jsp" %>
				</td>
			</tr>
            <%@ include file="menu.jsp"%>
		</table>
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
                    <div id="container">
                    	<img class="rightcorner" src="../images/page_right.jpg" alt=""/>
                    	<img class="leftcorner" src="../images/page_left.jpg" alt=""/>
                        <div class="padder">
                            <!-- main content begins here -->
                            <div class="heading">
                                <h1><%=title%> User</h1> <!-- note: I would do headings like this: Add location, Editing location "Name" -->
                            </div>
                            <div class="validation"><%=resx.getREQMESSAGE()%></div>
                            <form id="userform" name="userform" method="post" action="./user.do?action=<%=action%>" onsubmit="javascript: return formvalidate(this);">
                            	<!-- start formbox -->
	                            <div class="formbox clearfix">
	                            	<div class="leftbox"><!-- leftbox -->
			                            <input name="id" type="hidden" value="<%=(u!=null?String.valueOf(u.getId()):"")%>" />
			                            <div class="field">
			                                <label for="fname">First Name <%=resx.getVALIDATOR()%></label>
			                                <input valid="text" id="fname" name="fname" type="text" maxlength="30" value="<%=(u!=null?u.getFname():"")%>" />
			                            </div>
			
			                            <div class="field">
			                                <label for="lname">Last Name <%=resx.getVALIDATOR()%></label>
			                                <input valid="text" id="lname" name="lname" type="text" maxlength="30" value="<%=(u!=null?u.getLname():"")%>" />
			                            </div>
			
			                            <div class="field">
			                                <label for="user">Username <%=resx.getVALIDATOR()%></label>
			                                <input valid="text" id="user" name="user" type="text" maxlength="30" value="<%=(u!=null?u.getUser():"")%>" />
			                            </div>
			
			                            <div class="field">
			                                <label for="pwd">Password <%=resx.getVALIDATOR()%></label>
			                                <input valid="text" id="pwd" name="pwd" type="password" maxlength="30" value="<%=(u!=null?u.getPwd():"")%>" />
			                            </div>
			
			                            <div class="field">
			                                <label for="email">Email</label>
			                                <input id="email" name="email" type="text" maxlength="30" value="<%=(u!=null?u.getEmail():"")%>" />
			                            </div>
			
			                            <div class="field">
			                                <label for="send_email">Send email</label>
			                                <input id="send_email" name="send_email" type="checkbox" <%if(u!=null && u.getSend_email()==1){%>checked="true"<%}%> />
			                            </div>
			
			                            <div class="field" style="width:">
			                                <label for="email">Permission <%=resx.getVALIDATOR()%></label>
			                                <select style="width:150px" valid="select" name="permission">
			                                    <option value="<%=Role.R_ADMIN%>" <%=(u!=null && u.getPermission()==Role.R_ADMIN?"selected":"")%>><%=Role.S_ADMIN%></option>
			                                    <option value="<%=Role.R_RECEP%>" <%=(u!=null && u.getPermission()==Role.R_RECEP?"selected":"")%>><%=Role.S_RECEP%></option>
			                                    <option value="<%=Role.R_EMP%>" <%=(u!=null && u.getPermission()==Role.R_EMP?"selected":"")%>><%=Role.S_EMP%></option>
			                                    <option value="<%=Role.R_VIEW%>" <%=(u!=null && u.getPermission()==Role.R_VIEW?"selected":"")%>><%=Role.S_VIEW%></option>
			                                    <option value="<%=Role.R_SHD_CHK%>" <%=(u!=null && u.getPermission()==Role.R_SHD_CHK?"selected":"")%>><%=Role.S_SHD_CHK%></option>
			                                </select>
			                            </div>
		                            </div><!-- end leftbox -->
		                            <!-- start center box -->
		                            <div class="centerbox">
		                            	<p>Selected IP</p>
		                            	<div class="ip_list">
		                            		<div id="user_history_ip">
												<!-- 
												<input class="ip_checkbox_option" type='checkbox' name='IPOption' value="*"/>*<br/>
												<input class="ip_checkbox_option" type='checkbox' name='IPOption' value="192.168.1.1"/>192.168.1.1<br/>
												<input class="ip_checkbox_option" type='checkbox' name='IPOption' value="192.168.1.2"/>192.168.1.2<br/>
												<input class="ip_checkbox_option" type='checkbox' name='IPOption' value="192.168.1.3"/>192.168.1.3<br/>
												 -->
												<p id="unlimited"><input class='ip_checkbox_option' type='checkbox' <%if(isAll){%>checked="checked"<%}%> name='IPOption' value="*" />* (unlimited ip if selected)</p>
												
												<%
												
												Iterator<IP> itr = ips.iterator();
												 while(itr.hasNext()){
													 IP ip = itr.next();
													 if("*".equals(ip.getIP()))
														 continue;
												%>
												<p><input class='ip_checkbox_option' type='checkbox' <%if(ip.isChecked()){%>checked="checked"<%}%> name='IPOption' value="<%=ip.getIP() %>" /><%=ip.getIP() %></p>
												
												<%
												 }
												 %>
												 
											</div>
											<div class="add_new_ip">
												<p>Add New IP</p>
												<div id="add_new_ip_box">
													IP:<input class="add_new_ip_input" type='text' name='newIP' size="30" maxlength="15"/><br/>
												</div>
												<input class="add_btn" type="button" id="add_new_record" value="Add New Record"/>
											</div>
		                            	</div>
		                            </div><!-- end centerbox -->
		                            <!-- start right box -->
		                            <div class="rightbox">
		                            	<div class="employeeListbox">
											<p class="listTitle">Employee List</p>
											<div class="listtable">
												<table cellpadding="0" cellspacing="0" id="employeeList" border="0">
													<thead>
														<tr>
															<th><input type="checkbox" value="" name="select_all" id="select_all" class="select_all"/></th>
															<th class="id">ID</th>
															<th class="name">Name</th>
														</tr>
													</thead>
													<tbody class="employee_list_body">
														<!-- <tr>
															<td><input type="checkbox" value="" class="select_name" name="empOption"/></td>
															<td class="id">22</td>
															<td class="name">11</td>
														</tr>
														 -->
														 <%
													 	for(int i=0; i<employees.size(); i++){
													 		Employee emp = employees.get(i);
													 	%>
													 	<tr>
															<td><input type="checkbox" value="<%=emp.getId()%>" class="select_name" <%if(emp.isChecked()){%>checked="checked"<%}%>  name="empOption"/></td>
															<td class="id"><%=emp.getId() %></td>
															<td class="name"><%=emp.getFname()+" " + emp.getLname() %></td>
														</tr>
													 	<%
													 	}
														 %>
												 	</tbody>
												 </table>
											</div>
										</div>
		                            </div><!-- end right box -->
	                            </div><!-- end formbox -->
	                            
	                            <div id="error_message" name="error_message" class="error">
	                                <%=resx.getREQERROR()%>
	                            </div>
	                             <div>
	                                 <table align="left" class="submit">
	                                 	<tr></tr>
	                                     <tr>
	                                         <td>
	                                             <input name="submit" type="submit" class="button_small" value="Save" />
	                                         </td>
	                                         <td>
	                                         	<input name="back" type="button" class="button_small" value="back" onclick="window.history.back();" />
	                                         </td>
	                                     </tr>
	                                 </table>
	                             </div>
							</form>
                            <!-- main content ends here -->
                        </div>
                    </div>
				</td>
			</tr>
        <%@ include file="../copyright.jsp" %>
		</table>
	</body>
</html>
