<%@ page import="org.xu.swan.bean.User" %>
<%@ page import="java.security.cert.X509Certificate" %>
<%@ page import="java.util.Enumeration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    boolean bVisiblePage = false;
    if(application.getInitParameter("ssl_authorize").equals("on"))
    {
        if(!request.isSecure())
        {
//            response.sendRedirect("https://gestionsdna.com:443/HairDresser/");
            return;
        }

        X509Certificate cert[];
        cert = (X509Certificate[])request.getAttribute("javax.servlet.request.X509Certificate");
        if(cert != null)
        {
            bVisiblePage = true;
        }
    }
    else
        bVisiblePage = true;
/*    if( request.isSecure() ){
            out.println("request.isSecure");        
    }

    X509Certificate cert[];
    cert = (X509Certificate[])request.getAttribute("javax.servlet.request.X509Certificate");
    if(cert != null)
    {
        out.println(cert);
        out.println(cert[0]);
    }*/
    
    User user_ses = (User) session.getAttribute("user");
    if (user_ses != null){
        session.invalidate();
//        session.removeAttribute("user");
    }
    
    session = request.getSession(true);
	String loginErrorMessage = (String)session.getAttribute("loginErrorMessage");
    
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <title>Home</title>
    <script type="text/javascript" src="./plugins/util.js"></script>
    <script type="text/javascript">
	    if(isMobile()){
	    	window.location.href="./mindex.jsp?<%if(loginErrorMessage!=null){%><%=loginErrorMessage%><%}%>";
	    }
    </script>
    <link href="css/index.css" rel="stylesheet" type="text/css"/>
    
    <script type="text/javascript" src="./plugins/jQuery v1.7.2.js"></script>
    
    <link rel='stylesheet' type='text/css' href='./plugins/popup/popup.css' />
    <script type="text/javascript" src="./plugins/popup/popup.js"></script>
    
    <script type="text/javascript">
    
    function focusChangedUserInput() {
        var str = document.getElementById("IdUserInput").value;
        if (str=="User Name"){
            document.getElementById("IdUserInput").value = "";
            document.getElementById("IdUserInput").style.color = "black";
        } else if(str.trim()==""){
            document.getElementById("IdUserInput").value = "User Name";
            document.getElementById("IdUserInput").style.color = "#b6b2b2";
        }
    }

    function focusChangedPwdInput() {
            var str = document.getElementById("IdPwdInput").value;
            if (str=="Password"){
                document.getElementById("IdPwdInput").value = "";
                document.getElementById("IdPwdInput").type="password"
                document.getElementById("IdPwdInput").style.color = "black";
            } else if(str.trim()==""){
                document.getElementById("IdPwdInput").value = "Password";
                document.getElementById("IdPwdInput").type="text"
                document.getElementById("IdPwdInput").style.color = "#b6b2b2";
            }
        }

    function focusChangedEmailInput() {
            var str = document.getElementById("IdEmaiInput").value;
            if (str=="Email address"){
                document.getElementById("IdEmaiInput").value = "";
                document.getElementById("IdEmaiInput").style.color = "black";
            } else if(str.trim()==""){
                document.getElementById("IdEmaiInput").value = "Email address";
                document.getElementById("IdEmaiInput").style.color = "#b6b2b2";
            }
    }

    function forgotPwd(){
            document.getElementById("loginContent").style.display = "none"
            document.getElementById("forgotContent").style.display = "block"
        }
    function showLogin(){
            document.getElementById("loginContent").style.display = "block"
            document.getElementById("forgotContent").style.display = "none"
        }

    </script>
</head>

<body>
	<%
    if(bVisiblePage)
    {
	%>
    <div class="horizon">
        <div class="text_img content">
            <div class="loginPwdPlace">
                <div  id="loginContent">
                    <form id="login" name="login" method="post" action="login?query=login">
                        <div class="right"><input id="IdUserInput" onfocus="focusChangedUserInput();" onblur="focusChangedUserInput();" class="userInput" name="user" type="text" value="User Name" /></div>
                        <div class="right"><input id="IdPwdInput" class="userInput" onfocus="focusChangedPwdInput();" onblur="focusChangedPwdInput();"  name="pwd" type="text" value="Password" /></div>
                        <div class="right"><input type="submit" class="loginBtn" value="" /></div>
                        <div class="right forgotPwd" onclick="forgotPwd();"><img src="img/login/forgot_pwd.png" alt="forgot You password?"></div>
                        <div class="clear"></div>
                    </form>
                </div>
                <div id="forgotContent" style="display: none;">
                    <form id="recoveryPwd" name="recoveryPwd" method="post" action="login?query=recoveryPwd">
                        <div class="center forgotText">To reset your password, enter the email address, associated with the account.</div>
                        <div class="center" ><input style="margin-left: 30px" id="IdEmaiInput" onfocus="focusChangedEmailInput();" onblur="focusChangedEmailInput();" class="userInput" name="email" type="text" value="Email address" /></div>
                        <div class="left forgotOk" onclick="recoveryPwd.submit();">Ok</div>
                        <div class="right forgotCancel" onclick="showLogin();">Cancel</div>
                        <div class="clear"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <%
    }
	%>
	
	<%
	
	if(loginErrorMessage!=null && loginErrorMessage.trim().length()>0){
	
	%>
		<script type="text/javascript">
			var pop = new popup();
			var options = {"message": "<%=loginErrorMessage%>", "type" : "error", "visiable" : true};
			pop.enter(options);
		
		</script>
	<%
		session.removeAttribute("loginErrorMessage");
	}

	%>
	
</body>
</html>

