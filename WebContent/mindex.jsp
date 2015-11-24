<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<title>Home</title>
</head>
<body>

<table id="loginContent" border='0'>
	<tr>
		<td width="30%"></td>
		<td class="loginform">
			<div class="loginformLayout">
				<span id="error" style="color:red;"></span>
				<form id="login" name="login" method="post" action="login?query=login">
					<div class="right"><input id="IdUserInput"  class="userInput" name="user" type="text" size="35" placeholder="User Name" /></div>
					<div class="right"><input id="IdPwdInput" class="userInput" name="pwd" type="password" size="35" placeholder="Password" /></div>
					<div class="right"><input type="submit" class="loginBtn" value="Log In" /></div>
				</form>
			</div>
		</td>
		<td width="30%"></td>
	</tr>
</table>

</body>
<style type="text/css">
	html,body{width:100%; height:100%; }
	body {margin:0px; background: url("Image/mbg.jpg") no-repeat fixed;}
	table{width:100%; height:100%; }
	td{text-align:center; vertical-align: middle; }
	.loginformLayout{background: rgba(100,100, 100, 0.5); margin:0px; padding-top:10px;}
	.loginform input[type='text'], .loginform input[type='password']{
		margin:10px; padding:8px 14px; 
	}
	.loginform input[type='submit']{
		margin-bottom:15px; padding:5px 25px; background: #0AB501; outline: none; border:none; color:#fff; font-size:16px; cursor: pointer;
	}

</style>
<script type="text/javascript">
	window.onload = function(){
		var errormessage = location.search.substring(1);
		errormessage = decodeURIComponent(errormessage);
		document.getElementById("error").innerHTML=errormessage;
	}
	
</script>
</html>