<%@ page import="org.xu.swan.bean.Location" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%
    User user_ses2 = (User) session.getAttribute("user");
    String fname = "";
    String lname = "";
    if (user_ses2 != null){
        fname = user_ses2.getFname();
        lname = user_ses2.getLname();
    }
    String lctn_facebook = "http://facebook.com/";
    String lctn_twitter = "http://twitter.com/";
    String lctn_blogger = "http://blogger.com/";
    Location lctn = (Location) session.getAttribute("location");
    if (lctn!=null){
        lctn_facebook = !lctn.getFacebook().equals("") ?lctn.getFacebook():lctn_facebook;
        lctn_twitter = !lctn.getTwitter().equals("") ?lctn.getTwitter():lctn_twitter;
        lctn_blogger = !lctn.getBlogger().equals("") ?lctn.getBlogger():lctn_blogger;
    }
%>
</tr>
<style type="text/css">
    .socBtn{
        margin-left: 5px;
    }
</style>
<tr>
    <td style="text-align: left;"><a class="socBtn" href="<%=lctn_facebook%>" target="_blank"><img src="<%=rootPath%>images/facebook.png" /></a><a class="socBtn" href="<%=lctn_twitter%>" target="_blank"><img src="<%=rootPath%>images/twitter.png" /></a><a class="socBtn" href="<%=lctn_blogger%>" target="_blank"><img src="<%=rootPath%>images/blogger.png" /></a></td><td style="text-align: right; font-size: 12px; padding-top: 5px; padding-bottom:5px; padding-right: 10px;"><b><span style="color: white;">Welcome </span><span style="color: orange;"><%=fname%> <%=lname%>!</span></b>&nbsp;&nbsp;&nbsp;<span style="border:1px dotted white;"><a href="http://support.isalon2you.com" style="color: white;text-decoration:none;"><b style="color: white;">Help</b></a></span></td></tr>
</tr>
<tr>
    <td rowspan="2" style="padding-left: 10px;" width="228" height="64"><img alt="iSalon2You" src="<%=rootPath%>images/logo.jpg" /></td>
    <td>
    <!--  
            <iframe src="http://rcm.amazon.com/e/cm?t=sdqnyc-20&o=1&p=48&l=ur1&category=beauty&banner=0Q2M96KTPZ1JX0G12SR2&f=ifr" width="728" height="90" scrolling="no" border="0" marginwidth="0" style="border:none;" frameborder="0"></iframe>
    -->
    </td>
<tr>

<td align="right" style="padding-right: 5px;padding-bottom: 3px;">

    <%--<object width="800" height="80" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">--%>
<%--<param value="<%=rootPath%>Morrocanoil_banner.swf" name="movie"/>--%>
<%--<param value="best" name="quality"/>--%>
<%--<param value="true" name="play"/>--%>
<%--<embed width="800" height="80" play="true" quality="best" type="application/x-shockwave-flash" src="<%=rootPath%>Morrocanoil_banner.swf" pluginspage="http://www.macromedia.com/go/getflashplayer"/>--%>
<%--</object>--%>
<%--<img style="width:800px; height:80px" alt="Morrocanoil" src="<%=rootPath%>images/Morrocanoil_banner.jpg" />--%>
</td>
