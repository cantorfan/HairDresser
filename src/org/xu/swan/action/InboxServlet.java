package org.xu.swan.action;

import org.xu.swan.bean.*;
import org.xu.swan.util.DateUtil;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMultipart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Transport;
import javax.mail.MessagingException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;
import java.util.Calendar;
import java.util.Locale;
import java.sql.SQLData;
import java.sql.Time;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.math.BigDecimal;

public class InboxServlet extends HttpServlet {

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
                if (action.equals("getinbox")){
                    String responcedata = " <table class='inbox' cellpading='0' cellspacing='0' border='0'> \n" +
                            "<tr style=\"background-color:black\"> <td><img src=\"img/inbox_id.png\" /></td>\n" +
                            "<td><img src=\"img/inbox_client.png\" /></td>\n" +
                            "<td><img src=\"img/inbox_phone.png\" /></td>\n" +
                            "<td><img src=\"img/inbox_email.png\" /></td>\n" +
                            "<td><img src=\"img/inbox_service.png\" /></td>\n" +
                            "<td><img src=\"img/inbox_datetime.png\" /></td>\n" +
                            "<td><img src=\"img/inbox_action.png\" /></td>\n" +
                            "</tr>";
                    String from = request.getParameter("from");
                    String to = request.getParameter("to");
                    String state_req = request.getParameter("state");
                    int state = -1;
                    Date date = null;
                    int emp_id = 0;
                    if (!state_req.equals("all")) state = Integer.parseInt(state_req);
                    ArrayList listInbox = InboxPublicBean.getBookingRecords(from, to, state);
                    for (int i=0; i< listInbox.size(); i++){
                        InboxPublicBean ipb = (InboxPublicBean)listInbox.get(i);
                        String class_style = "";
                        if (ipb.getState()==0) {
                            class_style = "unread";
                        }
                        else if (ipb.getState()==1) {
                            class_style = "read";
                        }
                        String deleted = "";
                        if (ipb.getDeleted()==1){
                            deleted = "&nbsp;&nbsp;&nbsp;</b><span style = 'color:#white;'><b>deleted</b></span>";
                        }
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                        String accept = "";
                        String reshedule = "";
                        if (ipb.getDeleted() != 1){
                            accept = "<a href = \"#\"><img border=\"0\" src=\"img/inbox_acept.png\" onclick=\"action('"+ipb.getCust_id()+"','accept','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a>";
                            reshedule = "<a href = \"#\"><img border=\"0\" src=\"img/inbox_reshedule.png\" onclick=\"action('"+ipb.getCust_id()+"','reshedule','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a>";
                        }
                        if (date!= null && ipb.getDate().compareTo(date)==0){
                            if (emp_id!=0 && ipb.getEmp_id()!=emp_id){
                                responcedata+="<tr style=\"background-color: black; color: white;\">\n" +
                                        "<td style=\"border-bottom: 1px solid #B9BBBD; border-right: 0px none;\">&nbsp</td>\n" +
                                        "<td colspan=\"3\" style=\"border-bottom: 1px solid #B9BBBD; border-right: 0px none; text-align: left; padding-left: 70px;\"><b>"+ipb.getDate()+"&nbsp;&nbsp;&nbsp;</b><span style = 'color:#ff6900;'><b>"+ipb.getEmp_name()+"</b></span>"+deleted+"</td>\n" +
                                        "<td style=\"border-bottom: 1px solid #B9BBBD; border-right: 0px none;\" colspan=\"4\">&nbsp</td>\n" +
                                        "</tr>";
//                                responcedata+="<tr style=\"background-color: black; color: ff6900;\">\n" +
//                                        "<td></td>\n" +
//                                        "<td style=\"border-bottom: 0px none; border-right: 0px none;\"><b>"+ipb.getEmp_name()+"</b></td>\n" +
//                                        "<td colspan=\"5\">\n" +
//                                        "</td>\n" +
//                                        "</tr>";
                            }
                        responcedata+="<tr class=\""+class_style+"\">\n" +
                                "    <td style=\"width:62px\">\n" +
                                ipb.getId() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:211px\">\n" +
                                ipb.getCust_name() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:121px\">\n" +
                                ipb.getPhone() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:121px\">\n" +
                                ipb.getEmail() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:191px\">\n" +
                                ipb.getService() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:121px\">\n" +
                                ipb.getTime() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:220px\">\n" +
                                "<table align=\"center\" id=\"actiontable_"+ipb.getId()+"\" cellspacing=\"0\" border=\"0\" cellpading=\"0\">\n" +
                                "<tr class=\"default\">\n" +
//                                "<td><img src=\"img/inbox_acept.png\" onclick=\"action('accept','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_reshedule.png\" onclick=\"action('reshedule','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_delete.png\" onclick=\"action('delete','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_unread.png\" onclick=\"action('unread','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_read.png\" onclick=\"action('read','"+ipb.getId()+"')\"></td>\n" +
                                "<td> "+accept+"</td>\n" +
                                "<td>"+reshedule+"</td>\n" +
                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_delete.png\" onclick=\"if (confirm('Are you sure want to delete this?')) action('"+ipb.getCust_id()+"','delete','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_unread.png\" onclick=\"action('"+ipb.getCust_id()+"','unread','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_read.png\" onclick=\"action('"+ipb.getCust_id()+"','read','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
                                "</tr> \n" +
                                "</table>" +
                                "<div id=\"loader_"+ipb.getId()+"\" style=\"display:none;\"><img border=\"0\" src=\"img/loader3.gif\"></div>"+
                                "    </td>\n" +
                                "</tr>";
                        }else {
                            responcedata+="<tr style=\"background-color: black; color: white;\">\n" +
                                    "<td style=\"border-bottom: 1px solid #B9BBBD; border-right: 0px none;\">&nbsp</td>\n" +
                                    "<td colspan=\"3\" style=\"border-bottom: 1px solid #B9BBBD; border-right: 0px none; text-align: left; padding-left: 70px;\"><b>"+ipb.getDate()+"&nbsp;&nbsp;&nbsp;</b><span style = 'color:#ff6900;'><b>"+ipb.getEmp_name()+"</b></span>"+deleted+"</td>\n" +
                                    "<td style=\"border-bottom: 1px solid #B9BBBD; border-right: 0px none;\" colspan=\"4\">&nbsp</td>\n" +
                                    "</tr>";
//                            responcedata+="<tr style=\"background-color: black; color: ff6900;\">\n" +
//                                    "<td></td>\n" +
//                                    "<td style=\"border-bottom: 0px none; border-right: 0px none;\"><b>"+ipb.getEmp_name()+"</b></td>\n" +
//                                    "<td colspan=\"5\">\n" +
//                                    "</td>\n" +
//                                    "</tr>";
                            responcedata+="<tr class=\""+class_style+"\">\n" +
                                "    <td style=\"width:62px\">\n" +
                                ipb.getId() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:211px\">\n" +
                                ipb.getCust_name() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:121px\">\n" +
                                ipb.getPhone() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:121px\">\n" +
                                ipb.getEmail() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:191px\">\n" +
                                ipb.getService() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:121px\">\n" +
                                ipb.getTime() +
                                "&nbsp;</td>\n" +
                                "    <td style=\"width:220px\">\n" +
                                "<table align=\"center\" id=\"actiontable_"+ipb.getId()+"\" cellspacing=\"0\" border=\"0\" cellpading=\"0\">\n" +
                                "<tr class = \"default\">\n" +
//                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_acept.png\" onclick=\"action('"+ipb.getCust_id()+"','accept','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
//                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_reshedule.png\" onclick=\"action('"+ipb.getCust_id()+"','reshedule','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
                                    "<td> "+accept+"</td>\n" +
                                    "<td>"+reshedule+"</td>\n" +
                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_delete.png\" onclick=\"if (confirm('Are you sure want to delete this?')) action('"+ipb.getCust_id()+"','delete','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_unread.png\" onclick=\"action('"+ipb.getCust_id()+"','unread','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
                                "<td><a href = \"#\"><img border=\"0\" src=\"img/inbox_read.png\" onclick=\"action('"+ipb.getCust_id()+"','read','"+ipb.getId()+"','"+sdf.format(ipb.getDate())+"')\"></a></td>\n" +
//                                "<td><img src=\"img/inbox_acept.png\" onclick=\"action('accept','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_reshedule.png\" onclick=\"action('reshedule','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_delete.png\" onclick=\"action('delete','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_unread.png\" onclick=\"action('unread','"+ipb.getId()+"')\"></td>\n" +
//                                "<td><img src=\"img/inbox_read.png\" onclick=\"action('read','"+ipb.getId()+"')\"></td>\n" +
                                "</tr>\n" +
                                "</table>" +
                                "<div id=\"loader_"+ipb.getId()+"\" style=\"display:none;\"><img border=\"0\" src=\"img/loader3.gif\"></div>"+
                                "    </td>\n" +
                                "</tr>";
                        }
                        date = ipb.getDate();
                        emp_id = ipb.getEmp_id();
                    }
                    response.setContentType("text/html");
                    response.setCharacterEncoding("UTF-8");
                    response.getOutputStream().print(responcedata);
                } else if (action.equals("accept")){
                    String id = request.getParameter("id");
                    Inbox ipb = Inbox.findById(Integer.parseInt(id));
                    if (ipb!= null){
                        Service serv = Service.findById(ipb.getService_id());
                        Inventory prod = Inventory.findById(ipb.getProduct_id());
//                        BigDecimal price = serv!=null?serv.getPrice():new BigDecimal("0");
                        BigDecimal price = new BigDecimal("0");
                        int duration = 30;
                        EmpServ se = EmpServ.findByEmployeeIdAndServiceID(ipb.getEmployee_id(),serv.getId());
                        if (se != null&&se.getPrice()!=null) {
                            price = se.getPrice();
                            duration = se.getDuration();
                        }else{
                            price = serv.getPrice();
                            duration = serv.getDuration();
                        }
                            Time st = ipb.getTime();
                            Calendar cal3 = Calendar.getInstance();
                            cal3.setTime(st);
                            cal3.add(Calendar.MINUTE,duration>0?duration:30);
                            Time et = new Time(cal3.getTime().getTime());

                        Appointment a = Appointment.insertAppointment(ipb.getLocation_id(),ipb.getCustomer_id(), ipb.getEmployee_id(), ipb.getService_id(), ipb.getProduct_id(), price,ipb.getDate(),st,et,0,"",false);
                        if (a==null){
                            response.setContentType("text/html");
                            response.setCharacterEncoding("UTF-8");
                            response.getOutputStream().print("Error: Failed create appointment.");
                        } else {
                            boolean send = sendEmail(Integer.parseInt(id), 2);
                            InboxPublicBean ipbs = InboxPublicBean.updateSetStatusReadWhenAcept(Integer.parseInt(id),a.getId());
                            if (send){
                                response.setContentType("text/html");
                                response.setCharacterEncoding("UTF-8");
                                response.getOutputStream().print("Email has been send succesfully!");
                            } else {
                                response.setContentType("text/html");
                                response.setCharacterEncoding("UTF-8");
                                response.getOutputStream().print("Failed to send email. Please check email address for this customer.");
                            }
                        }
                    }else {
                            response.setContentType("text/html");
                            response.setCharacterEncoding("UTF-8");
                            response.getOutputStream().print("Error: Failed get booking.");
                        }
                } else if (action.equals("reshedule")){
                    String id = request.getParameter("id");
                    InboxPublicBean ipbs = InboxPublicBean.getBookingById(Integer.parseInt(id));
                    Appointment a = Appointment.findById(ipbs.getApp_id());
                    if (a!=null){
                        Appointment ap = Appointment.deleteAppointment(a.getId());
                        if (ap== null){
                            response.setContentType("text/html");
                            response.setCharacterEncoding("UTF-8");
                            response.getOutputStream().print("Error when deleting records.");
                        }
                    }
//                    ArrayList app = Appointment.findByFilter(" where "+Appointment.ST+"='"+ipbs.getTime()+"' and DATE("+Appointment.APPDT+") = DATE('"+ipbs.getDate()+"') and "+Appointment.CUST+"="+ipbs.getCust_id()+" and "+Appointment.SVC+"="+ipbs.getSvc_id()+" and "+Appointment.EMP+"="+ipbs.getEmp_id());
//                    if (app.size()>0){
//                        Appointment a = (Appointment)app.get(0);
//                        Appointment ap = Appointment.deleteAppointment(a.getId());
//                        if (ap== null){
//                            response.setContentType("text/html");
//                            response.setCharacterEncoding("UTF-8");
//                            response.getOutputStream().print("Error when deleting records.");
//                        }
//                    }
                    InboxPublicBean ipb = InboxPublicBean.updateSetStatusRead(Integer.parseInt(id));
                } else if (action.equals("delete")){
                    String id = request.getParameter("id");
                    InboxPublicBean ipbs = InboxPublicBean.getBookingById(Integer.parseInt(id));
                    InboxPublicBean ipb = InboxPublicBean.deleteBooking(Integer.parseInt(id));
                    if (ipb != null){
                        Appointment a = Appointment.findById(ipbs.getApp_id());
                        if (a!=null){
                            Appointment ap = Appointment.deleteAppointment(a.getId());
                            if (ap== null){
                                response.setContentType("text/html");
                                response.setCharacterEncoding("UTF-8");
                                response.getOutputStream().print("Error when deleting records.");
                            }else{
                                response.setContentType("text/html");
                                response.setCharacterEncoding("UTF-8");
                                response.getOutputStream().print("");                                
                            }
                        }else{
                            response.setContentType("text/html");
                            response.setCharacterEncoding("UTF-8");
                            response.getOutputStream().print("");
                        }
                    } else {
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        response.getOutputStream().print("Error: Failed to delete booking.");
                    }
                } else if (action.equals("unread")){
                    String id = request.getParameter("id");
                    InboxPublicBean ipb = InboxPublicBean.updateSetStatusUnread(Integer.parseInt(id));
                    if (ipb != null){
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        response.getOutputStream().print("");
                    } else {
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        response.getOutputStream().print("Error: Failed to change status. (to unread)");
                    }
                } else if (action.equals("read")){
                    String id = request.getParameter("id");
                    InboxPublicBean ipb = InboxPublicBean.updateSetStatusRead(Integer.parseInt(id));
                    if (ipb != null){
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        response.getOutputStream().print("");
                    } else {
                        response.setContentType("text/html");
                        response.setCharacterEncoding("UTF-8");
                        response.getOutputStream().print("Error: Failed to change status. (to read)");
                    }
                }
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

    private boolean sendEmail(int id_booking, int type)
    {
        boolean rez = false;
        InboxPublicBean ipb = InboxPublicBean.getBookingById(id_booking);
        EmailTemplate etp = EmailTemplate.findByType(type);
        if (ipb!= null && etp!=null){

        if (ipb.getEmail()!= null && !ipb.getEmail().equals("")){
            Location loc = Location.findById(etp.getLocation_id());
            String[] tmp;
            String[] addr2;
            String temp;
            String salonname = "";
            String email = "";
            String telephone = "";
            if (loc != null){
                salonname = loc.getName();
                telephone = loc.getPhone();
                email = loc.getEmail();
                tmp = loc.getAddress2().split(";");
                if (!tmp[0].equals("")){
                    for (int i = 0; i<7; i++){
                        temp = tmp[i];
                        addr2 = temp.split(":");
                        if (addr2.length == 2) {
                            if (addr2[0].equals("telephone")){
                                 telephone = addr2[1];
                            }else if (addr2[0].equals("email")){
                                 email = addr2[1];
                            }
                        }
                    }
                }
            }
            String to = ipb.getEmail();
            String from = "noreply@isalon2you-soft.com";
//            String from = email;
            String subject = "Book an appointment at "+salonname;
            Locale locale = new Locale("en","US");
            Locale.setDefault(locale);
            SimpleDateFormat sdftime = new SimpleDateFormat("hh:mm a");
            SimpleDateFormat sdfdate = new SimpleDateFormat("EEE, MMM d");
//           Appointment Confirmation Email
            String template = etp.getText();
            String message = template.replace("{customer}",ipb.getCust_name()).replace("{operator}",ipb.getEmp_name()).replace("{service}",ipb.getService()).replace("{date}",sdfdate.format(ipb.getDate())).replace("{time}",sdftime.format(ipb.getTime())).replace("{product}",ipb.getProduct()).replace("{salonname}",salonname).replace("{salonphone}",telephone).replace("{day}",sdfdate.format(ipb.getDate()));
            String host = "localhost";
//            String host = "inmarsoft.com";
            boolean debug = false;
            boolean returnValue = false;
            // ������������� ��������� � �������� ������ �� ���������
            Properties props = new Properties();
            props.put("mail.smtp.host", host);


            javax.mail.Session session = javax.mail.Session.getDefaultInstance(props, null);
            session.setDebug(debug);

           props = null;
            MimeMessage msg = null;
            try {
                // ������� ���������
                msg = new MimeMessage(session);
                msg.setFrom(new InternetAddress(from));
                InternetAddress[] address = {new InternetAddress(to)};
                msg.setRecipients(Message.RecipientType.TO, address);
                msg.setSubject(subject);
                msg.setSentDate(Calendar.getInstance().getTime());

                // ������� � ��������� ������ ����� ���������
                MimeBodyPart mbp1 = new MimeBodyPart();
                mbp1.setText(message);

    //            MimeBodyPart mbp1File = new MimeBodyPart();

    //            mbp1File.setFileName(generate.getName());
    //            mbp1File.attachFile(generate.getName() + ".pdf");

                // ������� Multipart � ��������� � ���� ����� ��������� �����
                Multipart mp = new MimeMultipart();
                mp.addBodyPart(mbp1);
    //            mp.addBodyPart(mbp1File);

                // ��������� Multipart � ���������
                msg.setContent(mp);

    //            Logs.log(0,"to:"+to+";from:"+from+";subject:"+subject+";SendEmail;");
                // �������� ���������
                Transport.send(msg);

             rez = true;
            }
            catch (MessagingException mex)
            {
                rez = false;
    //            Logs.log(0,"to:"+to+";from:"+from+";subject:"+subject+";ex:"+mex.getMessage()+";stack:"+ Arrays.toString(mex.getStackTrace()));
                mex.printStackTrace();
                Exception ex = null;
                if ((ex = mex.getNextException()) != null) {
                    ex.printStackTrace();
                }
            }
            catch(Exception ex)
            {
                rez = false;
                ex.printStackTrace();
            }
            msg = null;
        }
    }
        return rez;
    }
}