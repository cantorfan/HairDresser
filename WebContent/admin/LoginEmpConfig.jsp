<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="org.xu.swan.bean.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Schedule Employee Config</title>
<script src="../plugins/jQuery v1.7.2.js" type="text/javascript"></script>
<script src="../Js/menu.js" type="text/javascript"></script>
<LINK href="../css/style.css" type=text/css rel=stylesheet>

<style type="text/css">

	#login_emp_container{width:960px; margin:0px auto; text-align:center; background: #fff;}
	.listTitle{font-size: 18px; font-weight: bold; color:#666; margin: 10px 0px;}
	
	.left_box{width:350px; height:400px; margin-top: 10px; margin-left: 10px; float:left; overflow-y: auto; border: 1px solid #eee;}
	.right_box{width:550px; height:400px; margin-top: 10px; margin-left:20px; float:left; overflow-y: auto; border: 1px solid #eee;}
	
	.listtable{border-bottom:1px solid #aaa; border-left: 1px solid #aaa; margin-left:25px; }
	.listtable th{border-right:1px solid #aaa; border-top: 1px solid #aaa; background:#ddd; padding:8px;}
	.listtable td{text-align:left; border-right:1px solid #aaa; border-top: 1px solid #aaa; cursor: pointer; padding:8px;}
	.listtable tr:hover{background: #f9f9f9;}
	.id{width:100px; text-align:center;}
	.name{width:150px;}

	.right_box .name{width: 300px;}

	#update_btn{background:#3399ff; padding: 10px 30px; border-radius: 4px; color: #fff; text-decoration: none; font-size: 22px; }
	#update_btn:hover{background: #4ba4fe; }
	
	.clearfix:after{
	  content: "020"; 
	  display: block; 
	  height: 0; 
	  clear: both; 
	  visibility: hidden;  
	  }
	
	.clearfix {
	  zoom: 1; 
	 }

	.update_btn_p{width:960px; text-align: center; margin:30px;}

</style>

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
				<td height="47"  colspan="3">
                     <%@ include file="../menu_main.jsp" %>
				</td>
			</tr>
            <%@ include file="menu.jsp"%>
		</table>
<div id="login_emp_container" class="clearfix">
	<div class="left_box">
		<p class="listTitle">User List</p>
		<table cellpadding="0" cellspacing="0" class="listtable" id="userList" border="0">
			<thead>
				<tr>
					<th class="id">ID</th>
					<th class="name">Name</th>
				</tr>
			</thead>
			<tbody class="user_list_body">
			<!-- <tr>
				<td class="id">22</td>
				<td class="name">11</td>
			</tr>
		 -->
		 	</tbody>
		 </table>	
	</div>

	<div class="right_box">
		<p class="listTitle">Employee List</p>
		<table class="listtable" cellpadding="0" cellspacing="0" id="employeeList" border="0">
			<thead>
				<tr>
					<th><input type="checkbox" value="" name="select_all" id="select_all" class="select_all"/></th>
					<th class="id">ID</th>
					<th class="name">Name</th>
				</tr>
			</thead>
			<tbody class="employee_list_body">
			<!-- <tr>
				<td><input type="checkbox" value="" class="select_name" name="select_name"/></td>
				<td class="id">22</td>
				<td class="name">11</td>
			</tr>
		 -->
		 	</tbody>
		 </table>
	</div>
</div>
<div class="update_btn_p"><a href="#" class="update_btn" id="update_btn">update</a></div>
</body>
<script type="text/javascript" charset="utf-8">
	
	var userId = "";
	
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
	
	$.ajax({
		type: "GET",
		url: "loginEmpConfig",
		data: {"time": new Date().getTime(), "action": "load_all_user"},
		dataType: "text",
		success: function(data){
			var jsonData = $.parseJSON(data);
			//user_list_body
			var vhtml = "";
			for(var i=0; i<jsonData.length; i++){
				vhtml += "<tr class=\"user_row\">";
				vhtml += "<td class=\"id\">"+jsonData[i].id+"</td>";
				vhtml += "<td class=\"name\">"+jsonData[i].fname+" "+jsonData[i].lname+"</td>";
				vhtml += "</tr>";
			}
			$(".user_list_body").html(vhtml);
		}
	});
	
	$(".user_row").live("click", function(){
		var id = userId = $(this).find(".id").text();
		
		$.ajax({
			type: "GET",
			url: "loginEmpConfig",
			data: {"time": new Date().getTime(), "action": "load_all", "id": id},
			dataType: "text",
			success: function(data){
				var jsonData = $.parseJSON(data);
				//user_list_body
				var vhtml = "";
				for(var i=0; i<jsonData.length; i++){
					vhtml += "<tr class=\"emp_row\">";
					if(jsonData[i].checked)
						vhtml += "<td><input type=\"checkbox\" checked=\"checked\" class=\"select_name\" name=\"select_name\"/></td>";
					else
						vhtml += "<td><input type=\"checkbox\" class=\"select_name\" name=\"select_name\"/></td>";
					vhtml += "<td class=\"id\">"+jsonData[i].id+"</td>";
					vhtml += "<td class=\"name\">"+jsonData[i].fname+" "+jsonData[i].lname+"</td>";
					vhtml += "</tr>";
				}
				$(".employee_list_body").html(vhtml);
			}
		});	
	});
	
	$("#update_btn").click(function(){
		var ids = "";
		$(".select_name").each(function(){
			if($(this).prop("checked")){
				var id = $(this).parent().siblings(".id").text();
				ids += id+",";
			}
		});
		
		$.ajax({
			type: "GET",
			url: "loginEmpConfig",
			data: {"time": new Date().getTime(), "id": userId, "employee_ids":ids, "action": "update"},
			dataType: "text",
			success: function(data){
				if(data=="true")
					alert("save success!");
				else
					alert("save fail!");
			}
		});		
	});
	
</script>

</html>