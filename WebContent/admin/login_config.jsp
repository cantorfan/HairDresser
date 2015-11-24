<%@ page language="java" contentType="text/html; charset=UTF-8" import="org.xu.swan.bean.User, java.util.List" 
    pageEncoding="UTF-8"%>
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login Config</title>
<LINK href="../css/style.css" type=text/css rel=stylesheet>
<script src="../Js/menu.js" type="text/javascript"></script>
<script src="../plugins/jQuery v1.7.2.js" type="text/javascript"></script>
</head>
<body>
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
		<% List<User> users = (List<User>)request.getAttribute("users");  %>
		<div id="usr_config">
			<div id="usr_config_box">
				<div class="user_box">
					<p>User Name</p>
					<select id="select_usr" name="myselect2" multiple="multiple">
						<!-- <option value="id">username</option> -->
						<% 
							if(users!=null){
								for(int i=0; i<users.size(); i++){
									User user = users.get(i);
						%>
						<option value="<%=user.getId()%>"><%=user.getUser()%></option>
						<%
								}
							}
						%>	
					</select>
				</div><!-- end left -->
				<!-- <div><input id="load_history_ip_btn" type="button" value="Load History IP"/></div> -->
				<div class="center_box">
					<p>Selected IP</p>
					<div id="user_history_ip">
						<!-- 
						<input id="selected_ip" type="hidden" value="" />
						<input class="ip_checkbox_option" type='checkbox' name='IPOption1' value="192.168.1.1"/>192.168.1.1<br/>
						 
						 -->
					</div>
				</div><!-- end center box -->
				<div class="right_box">
					<p>Add New IP</p>
					<div id="add_new_ip_box">
						<input type="hidden" id="new_ip_hidden" name="new_ips" value=""/>
						IP:<input class="add_new_ip" type='text' name='newIP' size="30" maxlength="15"/><br/>
					</div>
					<input class="add_btn" type="button" id="add_new_record" value="Add New Record"/>
				</div><!-- end left box -->
				<div style="clear: both;"></div>
				<div class="save_box"><input type="button" id="save_btn" value="Save" name="save"/></div>
				<%@ include file="../copyright.jsp" %>  
			</div>
		</div>
</body>

<style type="text/css">
	#usr_config{
		margin-top:15px;
		text-align: center;
		margin:0px auto;
		width:100%;height:500px;
		
	}
	#usr_config_box{
		text-align: left;
		margin:0px auto; background:white;
		border-radius:10px;
		margin-top:10px;
		width:1040px; height:580px;
		
	}
	#select_usr{width:150px;height:350px;margin-top:15px;}
	.user_box{padding:40px 10px 0px 40px; float:left;}	
	#load_history_ip_btn{margin-top:200px; margin-left:25px; margin-right:25px; float:left;}
	.center_box, .right_box{float:left; margin-left:50px; width:240px; padding:40px 10px 0px 40px;}
	.center_box{margin-left:100px;/*25px;*/padding-left:0px;}
	#user_history_ip, .add_new_ip_box{height:350px; overflow-y: auto; border:1px solid #ddd; padding:0px 0px 5px 5px; margin-top:15px;}
	.ip_checkbox_option{position:relative; top:6px;margin-right:6px;}
	.add_new_ip{margin-top:15px; margin-left:5px;}
	#add_new_record{margin-top:20px; margin-left:100px;}
	.save_box{width:960px; height:40px; text-align:center;margin-top:20px;}
</style>
<script type="text/javascript">

	$(document).ready(function(){
		
		//load checkbox
		$("#select_usr").live("change", function(){
			var myid = $(this).val()+"";
			$.ajax({
				type: "GET",
				url: "loginConfig.do",

				data: {'action': "load_all", 'id':myid, date:new Date()},
				dataType: "text",
				success: function(data){
					var htmlstr="<input id='selected_ip' type='hidden' value='' />"
					var jsonData = $.parseJSON(data);
					
					if(jsonData.checked.length == 0 && jsonData.unchecked.length==0){
						htmlstr+="<p class='unlimited'><input class='ip_checkbox_option' type='checkbox' name='IPOption1' value='*'/>*  (unlimited ip if selected)</p>";
					}else{
						
						if(jsonData.checked.length>0){
							if(jsonData.checked[0]=="*"){
								htmlstr+="<p class='unlimited'><input class='ip_checkbox_option' type='checkbox' checked='checked' name='IPOption1' value='*'/>*  (unlimited ip if selected)</p>";
							}else
								htmlstr+="<p class='unlimited'><input class='ip_checkbox_option' type='checkbox' name='IPOption1' value='*'/>*  (unlimited ip if selected)</p>";
							for(var i=0; i<jsonData.checked.length; i++){
								if(jsonData.checked[i] == "*")
									continue;
								htmlstr+="<p><input class='ip_checkbox_option' type='checkbox' checked='checked' name='IPOption1' value='"+jsonData.checked[i]+"'/>"+jsonData.checked[i]+"</p>";
							}
						}else{
							htmlstr+="<p class='unlimited'><input class='ip_checkbox_option' type='checkbox' name='IPOption1' value='*'/>*  (unlimited ip if selected)</p>";
						}
						
						if(jsonData.unchecked.length>0){
							for(var i=0; i<jsonData.unchecked.length; i++){
								if(jsonData.unchecked[i] == "*")
									continue;
								htmlstr+="<p><input class='ip_checkbox_option' type='checkbox' name='IPOption1' value='"+jsonData.unchecked[i]+"'/>"+jsonData.unchecked[i]+"</p>";
							}
						}	
					}
					
					$("#user_history_ip").html(htmlstr); 
				}
			});	
			
		});		
		
		$("#add_new_record").click(function(){
			var value = $(".add_new_ip").val();
			if(value){
				$(".unlimited").after("<p><input class='ip_checkbox_option' type='checkbox' checked='checked' name='IPOption1' value='"+value+"'/>"+value+"</p>");
				$(".add_new_ip").val("");
			}
		});
		
		$("#save_btn").click(function(){
			
			var selectIPHidden = $("#selected_ip");
			
			//set selected IPs in hidden value
			var selected = "";
			var selectedIPs=$(".ip_checkbox_option");
			for(var i=0; i<selectedIPs.length; i++){
				if(selectedIPs[i].checked){
					var value = selectedIPs[i].value;
					
					if((i+1)<selectedIPs.length){
						selected+=value+",";
					}else
						selected+=value;
				}
			}
			selectIPHidden.val(selected); 

			
			//get value and submit
			var userId = $("#select_usr").val()+"";
			
			var  ips = selectIPHidden.val();
			ips = $.trim(ips);
			
			if(ips && ips.charAt(ips.length-1)==',')
				ips = ips.substring(0, ips.length-1);
			
			$.ajax({
				type: "GET",
				url: "loginConfig.do",
				data: {'action': "submit", 'id': userId, date:new Date(), "ips": ips},
				dataType: "text",
				success: function(data){
					alert(data);
					window.location="loginConfig.do";
				}
			});	
			
			
			
		});
		
	});
	
</script>
</html>