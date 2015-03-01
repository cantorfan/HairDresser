package org.xu.dyve.action.schedule;

import java.io.IOException;
import java.io.StringReader;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.util.StringUtil;
import org.xu.swan.bean.Appointment;
import org.xu.swan.bean.Customer;
import org.xu.swan.bean.EmailTemplate;
import org.xu.swan.bean.EmpServ;
import org.xu.swan.bean.Employee;
import org.xu.swan.bean.Inbox;
import org.xu.swan.bean.InboxPublicBean;
import org.xu.swan.bean.Location;
import org.xu.swan.bean.Reconciliation;
import org.xu.swan.bean.Role;
import org.xu.swan.bean.Service;
import org.xu.swan.bean.Ticket;
import org.xu.swan.bean.User;
import org.xu.swan.bean.WorkingtimeLoc;
import org.xu.swan.util.DateUtil;
import org.xu.swan.util.Html2Text;
import org.xu.swan.util.ResourcesManager;
import org.xu.swan.util.SendMailHelper;

public class ScheduleManager extends HttpServlet {

	private static Logger log = Logger.getLogger(ScheduleManager.class);
    public static HashMap<String, int[]> scheduleArray = new HashMap<String, int[]>();
    public static HashMap<String, int[]> scheduleArrayRemainingOnSameCell = new HashMap<String, int[]>();
    public static HashMap<String, String[]> scheduleArrayLeftOcuppied = new HashMap<String, String[]>();
    public static HashMap<String, Integer> employeeListOrder = new HashMap<String, Integer>();
    public static HashMap<String, int[]> maxWidthPerCell = new HashMap<String, int[]>();

    private static String browser = "Microsoft Internet Explorer";

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doPost(request, response);
    }

    @SuppressWarnings("static-access")
	public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(true);
//        if (session != null){
//            response.setContentType("text/html");
//            response.setCharacterEncoding("UTF-8");
//            response.getWriter().write("REDIRECT:index.jsp");
//            return;
//        }
        User user_ses = (User) session.getAttribute("user");
        ResourcesManager resx = new ResourcesManager();
//        response.getWriter().write("<script language='javascript'>alert('kjhghjkl;');</script>");
//        request.setAttribute("MESSAGE","asdsadsadsad");

       
        try
        {
        	if (user_ses != null){
//              if (user_ses.getPermission() == Role.R_ADMIN){
//              }else{

          if (request.getParameter("optype") != null) {
              String operation = request.getParameter("optype");
              int idLocation = -1;
              int idAppointment = -1;
              int idNewEmployee = -1;
              int idCustomer = -1;
              int idService = -1;
              int state = -1;
              int pageNum = -1;
              String underEND = "0";
              String comment = "";
              String reason = "";
              boolean edit = false;
              boolean added = false;
              boolean delete = false;
              boolean delcust = false;
              //int idEditCustomer = -1;
              BigDecimal servicePrice = new BigDecimal(-1);
              int idCategory = -1;
              java.util.Date currentDate = null;
              java.util.Date startDate = null;
              java.util.Date endDate = null;
              Time st = null;
              Time et = null;
              Time st_old = null;
              Time et_old = null;
              int emp_old = 0;
              int employee_id = 0;
              int customer_id = 0;
              int app_new_id = 0;

              if(request.getParameter("idlocation") != null)
                  idLocation = Integer.parseInt(request.getParameter("idlocation"));


                  browser = request.getParameter("browser");
    

                  if(request.getParameter("dateutc") != null)
                  currentDate = (new SimpleDateFormat("yyyy/MM/dd")).parse(request.getParameter("dateutc"));

                  if(request.getParameter("pageNum") != null)
                  pageNum = Integer.parseInt(request.getParameter("pageNum"));


                  if(request.getParameter("underEND") != null)
                  underEND = String.valueOf(request.getParameter("underEND"));
             

                  if(request.getParameter("start") != null && !request.getParameter("start").contains("NaN"))
                  startDate = (new SimpleDateFormat("yyyy/MM/dd HH:mm")).parse(request.getParameter("start"));


                  if(request.getParameter("end") != null && !request.getParameter("start").contains("NaN"))
                  endDate = (new SimpleDateFormat("yyyy/MM/dd HH:mm")).parse(request.getParameter("end"));


                  if(request.getParameter("idnewemployee") != null)
                  idNewEmployee = Integer.parseInt(request.getParameter("idnewemployee"));


                  if(request.getParameter("idcustomer") != null)
                  idCustomer = Integer.parseInt(request.getParameter("idcustomer"));


                  if(request.getParameter("idservice") != null)
                  idService = Integer.parseInt(request.getParameter("idservice"));

              comment = request.getParameter("comment");
              reason = request.getParameter("delParam");
              //idEditCustomer = Integer.parseInt(request.getParameter("cust_id"));
//  				servicePrice = new BigDecimal(Integer.parseInt(request.getParameter("serviceprice")));
//  				idCategory = Integer.parseInt(request.getParameter("idcategory"));

              if(request.getParameter("idappointment") != null)
                  idAppointment = Integer.parseInt(request.getParameter("idappointment").replace("appoint_", ""));

              if(request.getParameter("state") != null)
                  state = Integer.parseInt(request.getParameter("state"));


              if (operation.equals("REZ") && startDate != null && endDate != null && idAppointment != -1) {
                  if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
                  Appointment ap = Appointment.findById(idAppointment);
                      if (ap != null){
                  Time tmp_t = DateUtil.toSqlTime(startDate);
                  Time t_old = ap.getSt_time();
                  Time t_new = new Time(DateUtil.getHour(tmp_t),DateUtil.getMinute(tmp_t),DateUtil.getSecond(tmp_t));
                  boolean bb = t_new.before(t_old);
                  if (bb){
                      st = t_new;
                      Calendar cal3 = Calendar.getInstance();
                      cal3.setTime(endDate);
                      cal3.add(Calendar.MINUTE,-360);
                      java.util.Date maxTime1 = cal3.getTime();
                      if (DateUtil.toSqlDate(startDate).before(maxTime1)){
                          startDate = maxTime1;
                      }

                  }else {
                      st = t_old;
                  }
                  tmp_t = DateUtil.toSqlTime(endDate);
                  t_old = ap.getEt_time();
                  t_new = new Time(DateUtil.getHour(tmp_t),DateUtil.getMinute(tmp_t),DateUtil.getSecond(tmp_t));
                  bb = t_new.before(t_old);
                  if (bb){
                      et = t_old;
                  }else {
                      et = t_new;
                      Calendar cal2 = Calendar.getInstance();
                      cal2.setTime(startDate);
                      cal2.add(Calendar.MINUTE,360);
                      java.util.Date maxTime = cal2.getTime();
                      if (DateUtil.toSqlDate(endDate).after(maxTime)){
                          endDate = maxTime;
                      }
                  }
                  ap.setSt_time(DateUtil.toSqlTime(startDate));
                      if (startDate.equals(endDate)){
                         Calendar cal = Calendar.getInstance();
                         cal.setTime(endDate);
                         cal.add(Calendar.MINUTE,15);
                         java.util.Date newDate = cal.getTime();

                         ap.setEt_time(DateUtil.toSqlTime(newDate));
                      }else {
                          ap.setEt_time(DateUtil.toSqlTime(endDate));
                      }
                      if (ap!= null && ap.getState()!=3){
                          Ticket t = Ticket.findTicketById(ap.getTicket_id());
                          if(t != null){
                              ArrayList arr = Reconciliation.findTransByCode(t.getCode_transaction());
                              if(arr != null && arr.size() > 0){
                                  Reconciliation r = (Reconciliation)arr.get(0);
                                  if(r != null && r.getStatus() != 0){
                                      Appointment.updateAppointment(ap.getId(), ap.getEmployee_id(), ap.getPrice(),
                                              ap.getApp_dt(), ap.getSt_time(), ap.getEt_time(), ap.getComment());
                                  }
                              }else {
                                  Appointment.updateAppointment(ap.getId(), ap.getEmployee_id(), ap.getPrice(),
                                          ap.getApp_dt(), ap.getSt_time(), ap.getEt_time(), ap.getComment());
                              }
                          }else {
                              Appointment.updateAppointment(ap.getId(), ap.getEmployee_id(), ap.getPrice(),
                                      ap.getApp_dt(), ap.getSt_time(), ap.getEt_time(), ap.getComment());
                          }
                      }

//                      st = ap.getSt_time();
//                      et = ap.getEt_time();
                      employee_id = ap.getEmployee_id();
                      edit = true;
                  } else {
                          operation = "REFRESHALL";
                      }
                  }
              }
              if(operation.equals("do_later_send_mail")){//.x.m.
            	  log.debug("do_later_send_mail");
            	  
            	  String appointmentIdStr = request.getParameter("appointment_id");
            	  appointmentIdStr = appointmentIdStr.replace("appoint_", "");
            	  int appointmentId = Integer.parseInt(appointmentIdStr);
            	  
            	  Appointment appointment = Appointment.findById(appointmentId);
            	  if(appointment==null){
            		  response.getWriter().write("appointment not found!");
            		  return ;
            	  }
            	  
            	  try {
            		  Appointment.updateChangeSendMailStatus(appointmentId, 1, false);
                	  //Appointment.updateChangeSendMailStatus(appointmentId, 2, false);
                	  response.getWriter().write("true");
            	  } catch (Exception e) {
            		  	response.getWriter().write(e.getMessage());
            		  	e.printStackTrace();
						log.error(e.getMessage(), e);
            	  }
            	  return ;
              }
              if(operation.equals("can_not_send_mail")){//.x.m.
            	  log.debug("can_not_send_mail");
            	  
            	  String appointmentIdStr = request.getParameter("appointment_id");
            	  appointmentIdStr = appointmentIdStr.replace("appoint_", "");
            	  int appointmentId = Integer.parseInt(appointmentIdStr);
            	  
            	  Appointment appointment = Appointment.findById(appointmentId);
            	  if(appointment==null){
            		  response.getWriter().write("appointment not found!");
            		  return ;
            	  }
            	  
            	  try {
            		  Appointment.updateChangeSendMailStatus(appointmentId, 1, true);
                	  //Appointment.updateChangeSendMailStatus(appointmentId, 2, false);
                	  response.getWriter().write("true");
            	  } catch (Exception e) {
            		  	response.getWriter().write(e.getMessage());
            		  	e.printStackTrace();
						log.error(e.getMessage(), e);
            	  }
            	  return ;
              }
              if(operation.equals("send_email_comfirmation")){ //.x.m.
            	  
            	  //Init email content
            	  int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            	  int customerId = Integer.parseInt(request.getParameter("customerId"));
            	  String email = request.getParameter("email");
            	  //Employee employee = Employee.findById(employeeId);
            	  Customer customer = Customer.findById(customerId);
            	  List<Appointment> appointments = Appointment.findByCustIdAndMailStatus(customerId, false);
            	  
            	  User user = (User) session.getAttribute("user");
            	  if(customer==null || email.trim().length()==0 ){
            		  response.getWriter().write("failure : email is null!");
            		  return ;
            	  }
            	  
            	  try {
            		  EmailTemplate emailTemplate = EmailTemplate.findByType(2);  // type:2 --> Appointment Confirmation Email
	            	  String content = emailTemplate.getText();
            		  
	            	  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	            	  SimpleDateFormat timeSdf = new SimpleDateFormat("HH:mm:ss");
	            	  
	            	  String date = null;
                	  String time = null;
                	  String employeeName = "";
                	  String serviceItem = "";
	            	  for(int i=0; i<appointments.size(); i++){

	            		  Appointment appointment = appointments.get(i);
	            		  
		            	  Service service = Service.findById(appointment.getService_id());
		            	  Employee employee = Employee.findById(appointment.getEmployee_id());
		            	  
		            	  if(employeeName.indexOf(employee.getFname()+" "+employee.getLname()) == -1)
		            		  employeeName += employee.getFname()+" "+employee.getLname() + ", ";
		            	  
		            	  
		            	  serviceItem += service.getName();
		            	  if((i+1)<appointments.size())
		            		  serviceItem +=",  ";
		            	  
		            	  if(date==null){
		            		  date = sdf.format(appointment.getApp_dt());
		            	  }
		            	  if(time==null){
		            		  time = timeSdf.format(appointment.getSt_time());
		            	  }
	            	  }
	            	  
	            	  if(employeeName.length() > 0)
	            		  employeeName = employeeName.substring(0, employeeName.length() -2);
	            	  
	            	  content = content.replace("{customerName}", customer.getFname()+" "+customer.getLname());
	            	  content = content.replace("{operator}", employeeName);
	            	  content = content.replace("{service}", serviceItem);
	            	  content = content.replace("{dateTime}", date+" "+time);
	            	  
	            	  /*
	            	  String rows = "";
	            	  for(int i=0; i<appointments.size(); i++){

	            		  Appointment appointment = appointments.get(i);
	            		  
		            	  Service service = Service.findById(appointment.getService_id());
		            	  Employee employee = Employee.findById(appointment.getEmployee_id());
		            	  
		            	  rows +="<tr>";
		            	  rows +="<td>"+employee.getFname()+" "+employee.getLname()+"</td>";
		            	  rows +="<td>"+service.getName()+"</td>";
		            	  
		            	  String date = null;
		            	  String time = null;
		            	  if(date==null){
		            		  date = sdf.format(appointment.getApp_dt());
		            	  }
		            	  if(time==null){
		            		  time = timeSdf.format(appointment.getSt_time());
		            	  }
		            	  rows +="<td>"+date+" "+time+"</td>";
		            	  rows +="</tr>";
	            	  }
	            	  content = content.replaceAll("\\$.+\\$", rows);
	            	  content = content.replace("{customerName}", customer.getFname()+" "+customer.getLname());
	            	  */
	            	  
	            	  
	            	  
	            	  log.debug("appointment confirmation email to:"+email+", content:"+content);
	            	  
	            	  customer.updateCustomer(customer.getId(), customer.getFname(), customer.getLname(), email,
	            			  customer.getPhone(), customer.getCell_phone(), customer.getType(), customer.getLocation_id(), 
	            			  customer.getReq(), customer.getRem(), customer.getRemdays(), customer.getComment(), customer.getEmployee_id(),
	            			  customer.getWork_phone_ext(), customer.getMale_female(), customer.getAddress(), customer.getCity(), 
	            			  customer.getState(), customer.getZip_code(), customer.getPicture(), customer.getDate_of_birth(), customer.getCountry());
	            	  
	            	  //send email
//	            	  Boolean result = SendMailHelper.sendHTML(content, "Appointment Confirmation Email", email);
	            	  Boolean result = SendMailHelper.send(content, "Appointment Confirmation Email", email);
	            	  
	            	  for(int i=0; i<appointments.size()&&result; i++){
	            		  Appointment appointment = appointments.get(i);
		            	  try {
		            		  Appointment.updateChangeSendMailStatus(appointment.getId(), 1, true);
		            	  } catch (Exception e) {
		            		  	response.getWriter().write(e.getMessage()+", appointment ID:"+appointment.getId());
		            		  	e.printStackTrace();
								log.error(e.getMessage(), e);
								return;
		            	  }
	            	  }
	            	  
	            	  response.getWriter().write(result.toString());
            	  } catch (Exception e) {
            		  e.printStackTrace();
            		  response.getWriter().write(e.getMessage());
            	  }
            	  return ;
              }
              
        	  if(operation.equals("canceled_send_email")){
            	  try {  //.x.m.
	            	  log.debug("canceled_send_email:111111");
	            	  String appId = request.getParameter("appointmentID");
	            	  Appointment ap = Appointment.findById(Integer.parseInt(appId.replace("appoint_", "")));
	            	  if(ap!=null){
	            		  log.debug("canceled_send_email:222222");
	            		  Customer customer = Customer.findById(ap.getCustomer_id());
	                      if(customer!=null){ //send cancel mail
	                    	  log.debug("canceled_send_email:333333");
	                          SimpleDateFormat dateSdf = new SimpleDateFormat("yyyy-MM-dd");
	                          SimpleDateFormat timeSdf = new SimpleDateFormat(" HH:mm:ss");
	                          String date = dateSdf.format(ap.getApp_dt());
	                          String time = timeSdf.format(ap.getSt_time());
	                          String dateTime = date+time;
	                          
	                          EmailTemplate cancelMailTemplate = EmailTemplate.findByType(101);
	                          
	                		  //String text = "Dear {customer}, The Appointment at: {2015-09-09} {11:11:11} has been canceled!";
	                          String text = cancelMailTemplate.getText().replace("{customerName}", customer.getLname());
	                          text = text.replace("{dataTime}", dateTime);
	                          
	                          log.debug("canceled_send_email to :"+customer.getEmail()+", content"+text);
	                    	  SendMailHelper.send(text, "Appointment Canceled", customer.getEmail());
	                      }
	                      log.debug("canceled_send_email:444444");
	                	  response.getWriter().write("send mail successed!");
	            	  }else{
	            		  log.debug("canceled_send_email:55555");
	            		  response.getWriter().write("send mail failure, appointment not found!");
	            	  }
            	  } catch (Exception e) {
            		  log.debug("canceled_send_email:66666");
            		  response.getWriter().write("send mail failure: "+e.getMessage());
            		  e.printStackTrace();
            	  }
            	  return ;
              }
        	  
              if (operation.equals("DEL") && idAppointment != -1) {
                  if (user_ses.getPermission() != Role.R_VIEW  && user_ses.getPermission() != Role.R_SHD_CHK){
                  int newState = 0;
                  Appointment ap = Appointment.findById(idAppointment);
                  if (ap != null){
                      st = ap.getSt_time();
                      et = ap.getEt_time();
                      employee_id = ap.getEmployee_id();
                      if (reason.equals("delok")) {
//                      if (ap!= null && ap.getTicket_id() != 0)
//                          Ticket.deleteTicket(user_ses.getId(), ap.getTicket_id());
	                      if (ap != null){
	                              Ticket tt = Ticket.findTicketById(ap.getTicket_id());
	                              if (tt != null){
	                              response.setContentType("text/html");
	                              response.setCharacterEncoding("UTF-8");
	                              response.getWriter().write("SAYALERT:Operation is not allowed. Please delete the saved Transaction for this Appointment");
	                              return;
	                          }else {
	                              Appointment.deleteAppointment(ap.getId());
	                              delete = true;
	                          }
	                      }
	                  } else if (reason.equals("delcust") || reason.equals("delcancel")) {
                          Ticket tt = Ticket.findTicketById(ap.getTicket_id());
                          if (tt!=null){
                              response.setContentType("text/html");
                              response.setCharacterEncoding("UTF-8");
                              response.getWriter().write("SAYALERT:Operation is not allowed. Please delete the saved Transaction for this Appointment");
                              return;
                          }else {
                              if (reason.equals("delcust")) newState = 2;
                              else newState = 4;
                              Appointment.updateAppointmentByIdState(idAppointment, newState);
                              Appointment.updateAddTicketID(idAppointment, 0);
                              delcust = true;
                              if (ap!= null && ap.getTicket_id() != 0)
                                  Ticket.deleteTicket(user_ses.getId(), ap.getTicket_id());
                          }
	                  } 
                  } else {
                          operation = "REFRESHALL";
                      }
                  }
              }

              if (operation.equals("FLAG") && idAppointment != -1 && state != -1) {
                  if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
                  int newState = Integer.parseInt(request.getParameter("state"));
                  System.out.println("idAppointment in  FLAG:" + idAppointment);
                  Appointment ap = Appointment.findById(idAppointment);
                  Customer customer = Customer.findById(ap.getCustomer_id());
                  if (customer.getFname().equalsIgnoreCase(Customer.WALKIN)){
                      Appointment.updateAppointmentByIdState(idAppointment, newState);
                      customer_id = 0;
                      employee_id = ap.getEmployee_id();
                  }
                  else{
                      Appointment.updateAppointmentByCustDate(customer.getId(), DateUtil.toSqlDate(currentDate), newState);
                      customer_id = ap.getCustomer_id();
                  }
                  st = ap.getSt_time();
                  et = ap.getEt_time();

                  edit = true;
              }
              }

              if (operation.equals("MOV") && startDate != null && endDate != null && idNewEmployee != -1) {
                  if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
                  if (idNewEmployee > 0) {
                      Appointment ap = Appointment.findById(idAppointment);
                      
                      if (ap != null){
                      if(ap.getState() == 3)
                    	  return;
                      st_old = ap.getSt_time();
                      et_old = ap.getEt_time();
                      emp_old = ap.getEmployee_id();
                      ap.setSt_time(DateUtil.toSqlTime(startDate));
                      ap.setEt_time(DateUtil.toSqlTime(endDate));
                      ap.setEmployee_id(idNewEmployee);
                      if (ap!=null && ap.getTicket_id()!=0)
                          Ticket.updateTicketSetEmpId(ap.getTicket_id(),idNewEmployee);
                      if (ap!= null && ap.getState()!=3){
                          Ticket t = Ticket.findTicketById(ap.getTicket_id());
                          if(t != null){
                              ArrayList arr = Reconciliation.findTransByCode(t.getCode_transaction());
                              if(arr != null && arr.size() > 0){
                                  Reconciliation r = (Reconciliation)arr.get(0);
                                  if(r != null && r.getStatus() != 0){
                                      Appointment.updateAppointment(ap.getId(), ap.getEmployee_id(), ap.getPrice(),
                                              ap.getApp_dt(), ap.getSt_time(), ap.getEt_time(), ap.getComment());
                                  }
                              }else{
                                  Appointment.updateAppointment(ap.getId(), ap.getEmployee_id(), ap.getPrice(),
                                          ap.getApp_dt(), ap.getSt_time(), ap.getEt_time(), ap.getComment());
                              }
                          }else {
                              Appointment.updateAppointment(ap.getId(), ap.getEmployee_id(), ap.getPrice(),
                                      ap.getApp_dt(), ap.getSt_time(), ap.getEt_time(), ap.getComment());
                          }
                      }

                      st = ap.getSt_time();
                      et = ap.getEt_time();
                      employee_id = ap.getEmployee_id();
                      edit = true;
                      }else{
                          operation = "REFRESHALL";
                      }
                  }
                  }
              }

              /*   if(operation.equals("SHOW") && idEditCustomer != -1 && idService != -1)
                          {
                              Appointment ap = new Appointment();
                              ap.setSt_time(DateUtil.toSqlTime(startDate));
                              ap.setEmployee_id(idNewEmployee);

                              EmpServ servLink = null;
                              try {
                                  servLink = EmpServ.findByEmployeeIdAndServiceID(idNewEmployee, idService);

                              }
                              catch(Exception ex){
                              }

                              Service serv = null;
                              try {
                                  serv = Service.findById(idService);
                                  GregorianCalendar calendar = new GregorianCalendar();
                                  calendar.setTime(startDate);
                                  calendar.add(GregorianCalendar.MINUTE, servLink.getDuration());
                                  endDate = calendar.getTime();
                              }
                              catch(Exception ex){
                              }

                              //!!!every employee mast have a price for every service defined in service table!!!
                              if(servLink != null && serv != null) {
                                  ap.setEt_time(DateUtil.toSqlTime(endDate));
                                  Appointment.insertAppointment(idLocation, idCustomer, idNewEmployee, idService, serv.getCategory_id(), servLink.getPrice(),DateUtil.toSqlDate(currentDate), ap.getSt_time(), ap.getEt_time(),0, comment);
                              }

                          }
              */
              if (operation.equals("NEW") && startDate != null && endDate != null && idNewEmployee != -1 && idService != -1)
              {
                  if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
                  try {
                      idCustomer = Integer.parseInt(request.getParameter("idcustomer"));
                  } catch (Exception ex) {
                  }

                  Appointment ap = new Appointment();
                  ap.setSt_time(DateUtil.toSqlTime(startDate));
                  ap.setEmployee_id(idNewEmployee);

//                  EmpServ servLink = null;
                  BigDecimal price = BigDecimal.ZERO;
                  int duration = 15;
                  Boolean find = false;

                      EmpServ servLink = EmpServ.findByEmployeeIdAndServiceID(idNewEmployee, idService);
                      if (servLink == null)
                      {
                          Service servLinks = Service.findById(idService);
                          if (servLinks != null){
                              duration = servLinks.getDuration();
                              if (duration > 360) duration = 360;
                              price = servLinks.getPrice();
                              find = true;
                          }
                      }else {
                          duration = servLink.getDuration();
                          if (duration > 360) duration = 360;
                          price = servLink.getPrice();
                          find = true;
                      }

                  if (duration < 15) duration = 15;
                  Service serv = null;

                      serv = Service.findById(idService);
                      GregorianCalendar calendar = new GregorianCalendar();
                      calendar.setTime(startDate);
                      if (underEND.equals("1")){
                          calendar.add(GregorianCalendar.MINUTE, 15);
                      } else if (underEND.equals("0")){
//                          calendar.add(GregorianCalendar.MINUTE, 30); //always create appoinmetn with duration 30min
                          calendar.add(GregorianCalendar.MINUTE, duration); //create appointment with some duration
                      }
                      endDate = calendar.getTime();
                      ap.setEt_time(DateUtil.toSqlTime(endDate));

                  //!!!every employee mast have a price for every service defined in service table!!!
                  Boolean req = false;
                  if (find && serv != null) {
//                      System.out.println("appointment 1");
                  String rq = request.getParameter("req");
                  String reshedule = request.getParameter("reshedule");
                  String id_booking = request.getParameter("idb");
                  if ((rq != null)&&(rq.equals("true")))
                      req = true;
//                  System.out.println("appointment 1 " + req);
                  Appointment ap_new = Appointment.insertAppointment(idLocation, idCustomer, idNewEmployee, idService, serv.getCategory_id(), price, DateUtil.toSqlDate(currentDate), ap.getSt_time(), ap.getEt_time(), 0, comment, req);
                      Inbox ii = Inbox.findById(Integer.parseInt(id_booking));
                      if (ap_new!= null && reshedule.equals("1") && ii!=null && ii.getCustomer_id()==idCustomer){
                          InboxPublicBean ipb_old = InboxPublicBean.getBookingById(Integer.parseInt(id_booking));
                          Inbox i = Inbox.updateAfterReschedule(Integer.parseInt(id_booking), ap_new.getApp_dt(), ap_new.getSt_time(), ap_new.getService_id(), ap_new.getEmployee_id(),ap_new.getId());
                          if (i!= null){
                              InboxPublicBean ipb_new = InboxPublicBean.getBookingById(i.getId());
                              boolean send = sendEmail(ipb_old, ipb_new, 3);
                          }
                      }
                      st = ap_new.getSt_time();
                      et = ap_new.getEt_time();
                      employee_id = ap_new.getEmployee_id();
                      app_new_id = ap_new.getId();
                      added = true;
                  }
                  }
              }



              scheduleArrayLeftOcuppied.clear();
              employeeListOrder.clear();
              maxWidthPerCell.clear();
              scheduleArray.clear();
              scheduleArrayRemainingOnSameCell.clear();
              employeeListOrder.clear();


                  initScheduleArray(idLocation, DateUtil.toSqlDate(currentDate), pageNum);


              try {
                  initEmployeeListForDay(idLocation, DateUtil.toSqlDate(currentDate), pageNum);
              }
              catch (Exception ex) {
                  System.out.println("error5 initEmployeeListForDay");
              }
              response.setContentType("text/html");
              response.setCharacterEncoding("UTF-8");

              if (operation.equals("MOV") || operation.equals("REZ")){
                  response.getWriter().write(generateAroundEventsArray(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, employee_id, st_old, et_old, emp_old));
              }
              else if (operation.equals("NEW")){
                  if (added)
                  response.getWriter().write(generateAroundEventsArray(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, employee_id, st_old, et_old, emp_old));
              }
              else if (operation.equals("FLAG")){
                  if (customer_id == 0){
                      response.getWriter().write(generateAroundEventsArray(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, employee_id, st_old, et_old, emp_old));
                  }
                  else {
                      response.getWriter().write(generateAroundEventsArrayFlag(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, customer_id));
                  }
              }
              else if (operation.equals("DEL")){
                  if (delete)
                          response.getWriter().write("DELETEAPP^appoint_"+idAppointment+"^"+generateAroundEventsArray(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, employee_id, st_old, et_old, emp_old));
//                      response.getWriter().write("DELETEAPP:appoint_"+idAppointment);
                  if (delcust)
                      response.getWriter().write(generateAroundEventsArray(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, employee_id, st_old, et_old, emp_old));
//                      response.getWriter().write(generateEventByIdApp(idLocation, DateUtil.toSqlDate(currentDate), pageNum, idAppointment));
              }  else if (operation.equals("REFRESHALL")){
                  response.getWriter().write("REFRESHALL");
              }  else {
                  response.getWriter().write(generateEventsArray(idLocation, DateUtil.toSqlDate(currentDate), pageNum));
              }
          }
//          }
          } else {
              response.setContentType("text/html");
              response.setCharacterEncoding("UTF-8");
              response.getWriter().write("REDIRECT:error.jsp?ec=1");
          }
        }
        catch(Exception e)
        {
        	e.printStackTrace();
        }
        
    }

        private boolean sendEmail(InboxPublicBean ipb_old, InboxPublicBean ipb_new, int type)
    {
        boolean rez = false;
//        InboxPublicBean ipb_old = old;
//        InboxPublicBean ipb_new = new;
        
        //.x.m disable send email 
       type = -1;
        
        EmailTemplate etp = EmailTemplate.findByType(type);
        if (ipb_old!= null && ipb_new!=null && etp!=null){

        if (ipb_new.getEmail()!= null && !ipb_new.getEmail().equals("")){
            Location loc = Location.findById(ipb_old.getLocation_id());
            String[] tmp;
            String[] addr2;
            String temp;
            String salonname = "";
            String email = "";
            String telephone = "";
            if (loc != null){
                salonname = loc.getName();
                email = loc.getEmail();
                telephone = loc.getPhone();
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
            String to = ipb_new.getEmail();
            String from = "noreply@isalon2you-soft.com";
//            String from = email;
            String subject = "Book an appointment at "+salonname;
            Locale locale = new Locale("en","US");
            Locale.setDefault(locale);
            SimpleDateFormat sdftime = new SimpleDateFormat("hh:mm a");
            SimpleDateFormat sdfdate = new SimpleDateFormat("EEE, MMM d");
//            String message = action+" Hello, "+ipb.getCust_name()+"!\n" +
//                    "\n" +
//                    "You have an appointment at https://isalon2you-soft.com/online/\n" +
//                    "-------------------\n" +
//                    "Operator: "+ipb.getEmp_name()+"\n" +
//                    "Service: "+ipb.getService()+"\n" +
//                    "Date: "+ipb.getDate()+"\n" +
//                    "Time: "+ipb.getTime()+"\n" +
//                    "Shopping: "+ipb.getProduct()+"\n" +
//                    "-------------------\n" +
//                    "\n" +
//                    "Sincerely, Administration https://isalon2you-soft.com/online/";
            String template = etp.getText();
            String message = template.replace("{customer}",ipb_old.getCust_name()).replace("{old_operator}",ipb_old.getEmp_name()).replace("{old_service}",ipb_old.getService()).replace("{old_date}",sdfdate.format(ipb_old.getDate())).replace("{old_time}",sdftime.format(ipb_old.getTime())).replace("{product}",ipb_old.getProduct()).replace("{new_operator}",ipb_new.getEmp_name()).replace("{new_service}",ipb_new.getService()).replace("{new_date}",sdfdate.format(ipb_new.getDate())).replace("{new_time}",sdftime.format(ipb_new.getTime())).replace("{product}",ipb_new.getProduct()).replace("{salonphone}",telephone).replace("{salonname}",salonname);
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

    public static String eventsArrayIfUpdate(int idLocation, Date currentDate, int pageNum, Time st, Time et, int employee_id, Time st_old, Time et_old, int emp_old) {
        scheduleArrayLeftOcuppied.clear();
        employeeListOrder.clear();
        maxWidthPerCell.clear();
        scheduleArray.clear();
        scheduleArrayRemainingOnSameCell.clear();
        employeeListOrder.clear();

        try {
            initScheduleArray(idLocation, currentDate, pageNum);
        }
        catch (Exception ex) {
        }
        try {
            initEmployeeListForDay(idLocation, currentDate, pageNum);
        }
        catch (Exception ex) {
            System.out.println("error eventsArrayIfUpdate");
        }
        return generateAroundEventsArray(idLocation, currentDate, pageNum, st, et, employee_id, st_old, et_old, emp_old);
    }

    public static String generateEventsArray(int idLocation, Date currentDate, int pageNum) {
        String responseAll = " ";

        SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy HH:mm:ss");
        try {
            HashMap hm = Appointment.findApptByLocDate(idLocation, currentDate, pageNum);
            int index = 1;
            Iterator it = hm.values().iterator();

            Calendar cal = new GregorianCalendar();
            cal.setTime(currentDate);
            int week_day = 0;
            if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
                week_day = 0;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
                week_day = 1;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
                week_day = 2;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
                week_day = 3;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
                week_day = 4;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
                week_day = 5;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
                week_day = 6;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
            int _from = _wtemp.getH_from().getHours();
            int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

            /*int _from = 24;
            int _to = 0;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            for(int i = 0; i < 7; i++)
            {
                WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

                double __from = wtemp.getH_from().getHours();
                _from = (int)(__from < _from ? __from : _from);

                double min = wtemp.getH_to().getMinutes() / 60.0f;
                min = min > 0 ? 1 : 0;
                double __to = wtemp.getH_to().getHours() +  min;
                _to = (int)(__to > _to ? __to : _to);
            }*/

            generateIndexes(idLocation, currentDate, pageNum);

            while (it.hasNext()) {
                ArrayList tempList = (ArrayList) it.next();
                for (int i = 0; i < tempList.size(); i++) {
                    String response = "";
                    try {
                        int width = 100;
                        Appointment temp = (Appointment) tempList.get(i);
//                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
                        int heigth = (endIndex - startIndex) * 22;
                        int maxCells = 1;
                        if (scheduleArray.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (scheduleArray.get("" + temp.getEmployee_id()).length > startIndex + count && scheduleArray.get("" + temp.getEmployee_id())[startIndex + count] > maxCells) {
                                    maxCells = scheduleArray.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                            width = width / maxCells;
                        }

                        if (maxWidthPerCell.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (maxWidthPerCell.get("" + temp.getEmployee_id()).length > startIndex + count && maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] < width) {
                                    width = maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                        }

                        int left = 0;
                        int leftReturn = getLeft(temp, maxCells, width);
                        if (leftReturn >= 0) {
                            left = leftReturn;
                        }
//                        int sdvig = ScheduleShift.getShift(employeeListOrder.get(""+temp.getEmployee_id()), browser);
                        /*if (employeeListOrder.get(""+temp.getEmployee_id()) > 3 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-2;

                        if (employeeListOrder.get(""+temp.getEmployee_id()) > 6 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-1;
*/
//                        if(employeeListOrder.get(""+temp.getEmployee_id()) > 0){
//                            left += employeeListOrder.get(""+temp.getEmployee_id())*100+sdvig;
//                        }
//                        if (employeeListOrder.get("" + temp.getEmployee_id()) == null) System.out.println("employeeListOrder is null");
                        if (employeeListOrder.get("" + temp.getEmployee_id()) != null && employeeListOrder.get("" + temp.getEmployee_id()) > 0) {
                            left += employeeListOrder.get("" + temp.getEmployee_id()) * 100;
                        }

                        Customer cust = null;
                        try {
                            cust = Customer.findById(temp.getCustomer_id());
                        }
                        catch (Exception ex) {
                        }
                        Service serv = null;
                        try {
                            serv = Service.findById(temp.getService_id());
                        }
                        catch (Exception ex) {
                        }

                        SimpleDateFormat formatDt = new SimpleDateFormat("MMMMM d, yyyy");
                        String comment = "";
                        String text = "";
//                        String phone = "";
                        String color = "#FF5B01";
//                        if (cust.getPhone().length() != 0)
//                            phone = cust.getPhone();
//
//                        if (cust.getPhone().length() == 0 && cust.getCell_phone().length() != 0)
//                            phone = cust.getCell_phone();

                        if (temp.getComment() != null && !temp.getComment().equals("")) {
                            comment = "<br><b><font color=#740F85>" + temp.getComment().replaceAll("'","&#39;") + "</font></b>";
//                            comment = temp.getComment();
                            color = "#740F85";
                        }

                        if (temp.getRequest()) {
                            text = "<b style='color:#ea2e44;'>" + (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment /*+ " " + phone*/ + "</b>";
                        } else
                            text = (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment;// + " " + phone;

                        String tooltip = (cust != null ? (cust.getFname().replaceAll("'","&#39;") + (cust.getLname() != null && cust.getLname().length() > 0 ? " " + cust.getLname().replaceAll("'","&#39;") : "")) : "") + " " + comment;// + " " + phone;
                        Html2Text parser = new Html2Text();
                        parser.parse(new StringReader(tooltip));
                        response = response.concat("{");
                        response = response.concat("\"ServerId\":\"appoint_" + temp.getId() + "\",");
                        response = response.concat("\"BarStart\":0,");
                        response = response.concat("\"EventStatus\":" + temp.getState() + ",");
                        response = response.concat("\"ToolTip\":\"" + parser.getText() + "\",");
                        response = response.concat("\"PartStart\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"Box\":true,");
                        response = response.concat("\"Left\":" + left + ",");
                        response = response.concat("\"Tag\":\"\",");
                        //response = response.concat("\"InnerHTML\":\"Event #"+(temp.getId())+"("+temp.getSt_time()+" - "+temp.getEt_time()+")\",");
                        response = response.concat("\"InnerHTML\":\"" + text + "\",");
                        response = response.concat("\"Width\":" + width + ",");
                        response = response.concat("\"ResizeEnabled\":true,");
                        response = response.concat("\"Start\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"RightClickEnabled\":true,");
                        response = response.concat("\"Value\":\"3\",");
                        response = response.concat("\"Height\":" + heigth + ",");
                        response = response.concat("\"End\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"ClickEnabled\":false,");
                        response = response.concat("\"BarColor\":\"" + color + "\",");
                        response = response.concat("\"BarLength\":" + heigth + ",");
                        response = response.concat("\"PartEnd\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"DeleteEnabled\":true,");
                        response = response.concat("\"Text\":\"Event #" + (index++) + "\",");
                        response = response.concat("\"MoveEnabled\":true,");
                        response = response.concat("\"ContextMenu\":null,");

                        response = response.concat("\"idappt\":" + temp.getId() + ",");
                        response = response.concat("\"ide\":" + temp.getEmployee_id() + ",");
                        response = response.concat("\"idc\":" + temp.getCustomer_id() + ",");
                        response = response.concat("\"ids\":" + temp.getService_id() + ",");
                        response = response.concat("\"dt\":\"" + new SimpleDateFormat("yyyy/M/d").format(temp.getApp_dt()) + "\",");

//                        String timezone = Location.getTimezoneForLocation(1);
//                        int tzint = 0;
//                        try{
//                            tzint = Integer.parseInt(timezone);
//                        }catch (Exception e){
//                            e.printStackTrace();
//                            tzint = 0;
//                        }

                        java.util.Date date = Calendar.getInstance().getTime();
                        int curTime = date.getHours() * 60 + date.getMinutes();
//                        int curTime = date.getHours() * 60 + date.getMinutes() - tzint;
                        int schTimt = temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes();
                        java.util.Date schDate = new Date(temp.getApp_dt().getTime());
                        java.util.Date curDate = new Date(date.getTime());
                        Calendar calSql = Calendar.getInstance();
                        Calendar calUtil = Calendar.getInstance();
                        calSql.setTime(schDate);
                        calUtil.setTime(curDate);
                        calSql.set(Calendar.MILLISECOND, 0);
                        calSql.set(Calendar.SECOND, 0);
                        calSql.set(Calendar.MINUTE, 0);
                        calSql.set(Calendar.HOUR, 0);
                        calSql.set(Calendar.AM_PM, 0);
                        calSql.set(Calendar.HOUR_OF_DAY, 0);
                        calUtil.set(Calendar.MILLISECOND, 0);
                        calUtil.set(Calendar.SECOND, 0);
                        calUtil.set(Calendar.MINUTE, 0);
                        calUtil.set(Calendar.HOUR, 0);
                        calUtil.set(Calendar.AM_PM, 0);
                        calUtil.set(Calendar.HOUR_OF_DAY, 0);

                        String bgColor = "";
                        if (temp.getState() == 1) // checked
                        {
                            bgColor = "#C1DEA6";
                        }
                        else if (temp.getState() == 2 || temp.getState() == 4) // notshow / canceled
                        {
                            bgColor = "#F390BC";
                        }
                        else if (temp.getState() == 0)
                        {
                            if (calSql.equals(calUtil))
                            {
                                if (curTime - schTimt > 5) // normal, new
                                    bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                                else
                                    bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                            }
                            else if (calSql.before(calUtil))
                            {
                                bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                            }
                            else if (calSql.after(calUtil))
                                bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                        }
                        else if (temp.getState() == 3)
                        {    //paid
                            bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                        }

                        Ticket t = Ticket.findTicketById(temp.getTicket_id());
                        if(t != null){
                            ArrayList a = Reconciliation.findTransByCode(t.getCode_transaction());
                            if(a != null && a.size() > 0){
                                Reconciliation r = (Reconciliation)a.get(0);
                                if(r != null && r.getStatus() == 0)
                                    bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                            }
                        }

                        if(!bgColor.equals(""))
                            response = response.concat("\"BackgroundColor\":\""+bgColor+"\",");
                        response = response.concat("\"Top\":" + (startIndex * 22) + ",");
                        response = response.concat("\"DayIndex\":0");
                        response = response.concat("},");
                        //System.out.println(response);
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    responseAll = responseAll.concat(response);
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return responseAll.substring(0, responseAll.length() - 1);
    }
    public static String generateAroundEventsArray(int idLocation, Date currentDate, int pageNum, Time st, Time et, int employee_id, Time st_old, Time et_old, int emp_old) {
        String responseAll = " ";

        SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy HH:mm:ss");
        try {
//            Appointment ap = Appointment.findById(idApp);
            HashMap hm = new HashMap();
//            if (ap != null)
            hm = Appointment.findAroundAppt(idLocation, currentDate, st, et, employee_id);
            if (st_old != null && et_old!=null && emp_old != 0){
                hm.putAll(Appointment.findAroundAppt(idLocation, currentDate, st_old, et_old, emp_old));
            }
//            if (app_new_id != 0){
//               Iterator it1 = hm.values().iterator();
//                if (it1.hasNext()){
//                    ArrayList tmpList = (ArrayList) it1.next();
//                    for (int j = 0; j < tmpList.size(); j++) {
//
//                    }
//                }
//            }
            int index = 1;
            Iterator it = hm.values().iterator();

            Calendar cal = new GregorianCalendar();
            cal.setTime(currentDate);
            int week_day = 0;
            if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
                week_day = 0;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
                week_day = 1;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
                week_day = 2;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
                week_day = 3;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
                week_day = 4;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
                week_day = 5;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
                week_day = 6;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
            int _from = _wtemp.getH_from().getHours();
            int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

            /*int _from = 24;
            int _to = 0;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            for(int i = 0; i < 7; i++)
            {
                WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

                double __from = wtemp.getH_from().getHours();
                _from = (int)(__from < _from ? __from : _from);

                double min = wtemp.getH_to().getMinutes() / 60.0f;
                min = min > 0 ? 1 : 0;
                double __to = wtemp.getH_to().getHours() +  min;
                _to = (int)(__to > _to ? __to : _to);
            }*/

            generateIndexes(idLocation, currentDate, pageNum);

            while (it.hasNext()) {
                ArrayList tempList = (ArrayList) it.next();
                for (int i = 0; i < tempList.size(); i++) {
                    String response = "";
                    try {
                        int width = 100;
                        Appointment temp = (Appointment) tempList.get(i);
//                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
                        int heigth = (endIndex - startIndex) * 22;
                        int maxCells = 1;
                        if (scheduleArray.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (scheduleArray.get("" + temp.getEmployee_id()).length > startIndex + count && scheduleArray.get("" + temp.getEmployee_id())[startIndex + count] > maxCells) {
                                    maxCells = scheduleArray.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                            width = width / maxCells;
                        }

                        if (maxWidthPerCell.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (maxWidthPerCell.get("" + temp.getEmployee_id()).length > startIndex + count && maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] < width) {
                                    width = maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                        }

                        int left = 0;
                        int leftReturn = getLeft(temp, maxCells, width);
                        if (leftReturn >= 0) {
                            left = leftReturn;
                        }
//                        int sdvig = ScheduleShift.getShift(employeeListOrder.get(""+temp.getEmployee_id()), browser);
                        /*if (employeeListOrder.get(""+temp.getEmployee_id()) > 3 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-2;

                        if (employeeListOrder.get(""+temp.getEmployee_id()) > 6 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-1;
*/
//                        if(employeeListOrder.get(""+temp.getEmployee_id()) > 0){
//                            left += employeeListOrder.get(""+temp.getEmployee_id())*100+sdvig;
//                        }
//                        if (employeeListOrder.get("" + temp.getEmployee_id()) == null) System.out.println("employeeListOrder is null");
                        if (employeeListOrder.get("" + temp.getEmployee_id()) != null && employeeListOrder.get("" + temp.getEmployee_id()) > 0) {
                            left += employeeListOrder.get("" + temp.getEmployee_id()) * 100;
                        }

                        Customer cust = null;
                        try {
                            cust = Customer.findById(temp.getCustomer_id());
                        }
                        catch (Exception ex) {
                        }
                        Service serv = null;
                        try {
                            serv = Service.findById(temp.getService_id());
                        }
                        catch (Exception ex) {
                        }

                        SimpleDateFormat formatDt = new SimpleDateFormat("MMMMM d, yyyy");
                        String comment = "";
                        String text = "";
//                        String phone = "";
                        String color = "#FF5B01";
//                        if (cust.getPhone().length() != 0)
//                            phone = cust.getPhone();
//
//                        if (cust.getPhone().length() == 0 && cust.getCell_phone().length() != 0)
//                            phone = cust.getCell_phone();

                        if (temp.getComment() != null && !temp.getComment().equals("")) {
                            comment = "<br><b><font color=#740F85>" + temp.getComment().replaceAll("'","&#39;") + "</font></b>";
//                            comment = temp.getComment();
                            color = "#740F85";
                        }

                        if (temp.getRequest()) {
                            text = "<b style='color:#ea2e44;'>" + (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment /*+ " " + phone*/ + "</b>";
                        } else
                            text = (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment;// + " " + phone;

                        String tooltip = (cust != null ? (cust.getFname().replaceAll("'","&#39;") + (cust.getLname() != null && cust.getLname().length() > 0 ? " " + cust.getLname().replaceAll("'","&#39;") : "")) : "") + " " + comment;// + " " + phone;
                        Html2Text parser = new Html2Text();
                        parser.parse(new StringReader(tooltip));

                        response = response.concat("{");
                        response = response.concat("\"ServerId\":\"appoint_" + temp.getId() + "\",");
                        response = response.concat("\"BarStart\":0,");
                        response = response.concat("\"EventStatus\":" + temp.getState() + ",");
                        response = response.concat("\"ToolTip\":\"" + parser.getText() + "\",");
                        response = response.concat("\"PartStart\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"Box\":true,");
                        response = response.concat("\"Left\":" + left + ",");
                        response = response.concat("\"Tag\":\"\",");
                        //response = response.concat("\"InnerHTML\":\"Event #"+(temp.getId())+"("+temp.getSt_time()+" - "+temp.getEt_time()+")\",");
                        response = response.concat("\"InnerHTML\":\"" + text + "\",");
                        response = response.concat("\"Width\":" + width + ",");
                        response = response.concat("\"ResizeEnabled\":true,");
                        response = response.concat("\"Start\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"RightClickEnabled\":true,");
                        response = response.concat("\"Value\":\"3\",");
                        response = response.concat("\"Height\":" + heigth + ",");
                        response = response.concat("\"End\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"ClickEnabled\":false,");
                        response = response.concat("\"BarColor\":\"" + color + "\",");
                        response = response.concat("\"BarLength\":" + heigth + ",");
                        response = response.concat("\"PartEnd\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"DeleteEnabled\":true,");
                        response = response.concat("\"Text\":\"Event #" + (index++) + "\",");
                        response = response.concat("\"MoveEnabled\":true,");
                        response = response.concat("\"ContextMenu\":null,");

                        response = response.concat("\"idappt\":" + temp.getId() + ",");
                        response = response.concat("\"ide\":" + temp.getEmployee_id() + ",");
                        response = response.concat("\"idc\":" + temp.getCustomer_id() + ",");
                        response = response.concat("\"ids\":" + temp.getService_id() + ",");
                        response = response.concat("\"dt\":\"" + new SimpleDateFormat("yyyy/M/d").format(temp.getApp_dt()) + "\",");
//                        String timezone = Location.getTimezoneForLocation(1);
//                        int tzint = 0;
//                        try{
//                            tzint = Integer.parseInt(timezone);
//                        }catch (Exception e){
//                            e.printStackTrace();
//                            tzint = 0;
//                        }
                        java.util.Date date = Calendar.getInstance().getTime();
                        int curTime = date.getHours() * 60 + date.getMinutes();
//                        int curTime = date.getHours() * 60 + date.getMinutes()-tzint;
                        int schTimt = temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes();
                        java.util.Date schDate = new Date(temp.getApp_dt().getTime());
                        java.util.Date curDate = new Date(date.getTime());
                        Calendar calSql = Calendar.getInstance();
                        Calendar calUtil = Calendar.getInstance();
                        calSql.setTime(schDate);
                        calUtil.setTime(curDate);
                        calSql.set(Calendar.MILLISECOND, 0);
                        calSql.set(Calendar.SECOND, 0);
                        calSql.set(Calendar.MINUTE, 0);
                        calSql.set(Calendar.HOUR, 0);
                        calSql.set(Calendar.AM_PM, 0);
                        calSql.set(Calendar.HOUR_OF_DAY, 0);
                        calUtil.set(Calendar.MILLISECOND, 0);
                        calUtil.set(Calendar.SECOND, 0);
                        calUtil.set(Calendar.MINUTE, 0);
                        calUtil.set(Calendar.HOUR, 0);
                        calUtil.set(Calendar.AM_PM, 0);
                        calUtil.set(Calendar.HOUR_OF_DAY, 0);

                        String bgColor = "";
                        if (temp.getState() == 1) {    // checked
                            bgColor = "#C1DEA6";//response = response.concat("\"BackgroundColor\":\"#C1DEA6\",");
                        } else if (temp.getState() == 2 || temp.getState() == 4) {    // notshow / canceled
                            bgColor = "#F390BC";//response = response.concat("\"BackgroundColor\":\"#F390BC\",");
                        } else if (temp.getState() == 0) {
                            if (calSql.equals(calUtil)) {
                                if (curTime - schTimt > 5) // normal, new
                                    bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                                else
                                    bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                            } else if (calSql.before(calUtil)) {
                                bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                            } else if (calSql.after(calUtil))
                                bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                        } else if (temp.getState() == 3) {    //paid
                            bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                        }

                        Ticket t = Ticket.findTicketById(temp.getTicket_id());
                        if(t != null){
                            ArrayList a = Reconciliation.findTransByCode(t.getCode_transaction());
                            if(a != null && a.size() > 0){
                                Reconciliation r = (Reconciliation)a.get(0);
                                if(r != null && r.getStatus() == 0)
                                    bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                            }
                        }

                        if(!bgColor.equals(""))
                            response = response.concat("\"BackgroundColor\":\""+bgColor+"\",");
                        response = response.concat("\"Top\":" + (startIndex * 22) + ",");
                        response = response.concat("\"DayIndex\":0");
                        response = response.concat("},");
                        //System.out.println(response);
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    responseAll = responseAll.concat(response);
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return responseAll.substring(0, responseAll.length() - 1);
    }

    public static String generateAroundEventsArrayFlag(int idLocation, Date currentDate, int pageNum, Time st, Time et, int customer_id) {
        String responseAll = " ";

        SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy HH:mm:ss");
        try {
//            String filter = "where customer_id="+customer_id+" and DATE(appt_date)=DATE('"+currentDate+"')";
//            ArrayList ListApp = Appointment.findByFilter(filter);
            HashMap hm = new HashMap();
            hm = Appointment.findAroundEmp(idLocation, currentDate, customer_id);
//            for (int i=0; i<ListApp.size(); i++){
//                Appointment app = (Appointment)ListApp.get(i);
//                if (app != null){
//                    HashMap arrmap =Appointment.findAroundAppt(app.getLocation_id(), currentDate, app.getSt_time(), app.getEt_time(), app.getEmployee_id());
//                    hm.putAll(arrmap);
//                }
//            }
////            if (ap != null)
//            hm = Appointment.findAroundAppt(idLocation, currentDate, st, et, employee_id);
//            if (st_old != null && et_old!=null && emp_old != 0){
//                hm.putAll(Appointment.findAroundAppt(idLocation, currentDate, st_old, et_old, emp_old));
//            }
////            if (app_new_id != 0){
//               Iterator it1 = hm.values().iterator();
//                if (it1.hasNext()){
//                    ArrayList tmpList = (ArrayList) it1.next();
//                    for (int j = 0; j < tmpList.size(); j++) {
//
//                    }
//                }
//            }
            int index = 1;
            Iterator it = hm.values().iterator();

            Calendar cal = new GregorianCalendar();
            cal.setTime(currentDate);
            int week_day = 0;
            if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
                week_day = 0;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
                week_day = 1;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
                week_day = 2;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
                week_day = 3;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
                week_day = 4;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
                week_day = 5;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
                week_day = 6;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
            int _from = _wtemp.getH_from().getHours();
            int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

            /*int _from = 24;
            int _to = 0;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            for(int i = 0; i < 7; i++)
            {
                WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

                double __from = wtemp.getH_from().getHours();
                _from = (int)(__from < _from ? __from : _from);

                double min = wtemp.getH_to().getMinutes() / 60.0f;
                min = min > 0 ? 1 : 0;
                double __to = wtemp.getH_to().getHours() +  min;
                _to = (int)(__to > _to ? __to : _to);
            }*/

            generateIndexes(idLocation, currentDate, pageNum);

            while (it.hasNext()) {
                ArrayList tempList = (ArrayList) it.next();
                for (int i = 0; i < tempList.size(); i++) {
                    String response = "";
                    try {
                        int width = 100;
                        Appointment temp = (Appointment) tempList.get(i);
//                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
                        int heigth = (endIndex - startIndex) * 22;
                        int maxCells = 1;
                        if (scheduleArray.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (scheduleArray.get("" + temp.getEmployee_id()).length > startIndex + count && scheduleArray.get("" + temp.getEmployee_id())[startIndex + count] > maxCells) {
                                    maxCells = scheduleArray.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                            width = width / maxCells;
                        }

                        if (maxWidthPerCell.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (maxWidthPerCell.get("" + temp.getEmployee_id()).length > startIndex + count && maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] < width) {
                                    width = maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                        }

                        int left = 0;
                        int leftReturn = getLeft(temp, maxCells, width);
                        if (leftReturn >= 0) {
                            left = leftReturn;
                        }
//                        int sdvig = ScheduleShift.getShift(employeeListOrder.get(""+temp.getEmployee_id()), browser);
                        /*if (employeeListOrder.get(""+temp.getEmployee_id()) > 3 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-2;

                        if (employeeListOrder.get(""+temp.getEmployee_id()) > 6 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-1;
*/
//                        if(employeeListOrder.get(""+temp.getEmployee_id()) > 0){
//                            left += employeeListOrder.get(""+temp.getEmployee_id())*100+sdvig;
//                        }
//                        if (employeeListOrder.get("" + temp.getEmployee_id()) == null) System.out.println("employeeListOrder is null");
                        if (employeeListOrder.get("" + temp.getEmployee_id()) != null && employeeListOrder.get("" + temp.getEmployee_id()) > 0) {
                            left += employeeListOrder.get("" + temp.getEmployee_id()) * 100;
                        }

                        Customer cust = null;
                        try {
                            cust = Customer.findById(temp.getCustomer_id());
                        }
                        catch (Exception ex) {
                        }
                        Service serv = null;
                        try {
                            serv = Service.findById(temp.getService_id());
                        }
                        catch (Exception ex) {
                        }

                        SimpleDateFormat formatDt = new SimpleDateFormat("MMMMM d, yyyy");
                        String comment = "";
                        String text = "";
//                        String phone = "";
                        String color = "#FF5B01";
//                        if (cust.getPhone().length() != 0)
//                            phone = cust.getPhone();
//
//                        if (cust.getPhone().length() == 0 && cust.getCell_phone().length() != 0)
//                            phone = cust.getCell_phone();

                        if (temp.getComment() != null && !temp.getComment().equals("")) {
                            comment = "<br><b><font color=#740F85>" + temp.getComment().replaceAll("'","&#39;") + "</font></b>";
//                            comment = temp.getComment();
                            color = "#740F85";
                        }

                        if (temp.getRequest()) {
                            text = "<b style='color:#ea2e44;'>" + (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment /*+ " " + phone*/ + "</b>";
                        } else
                            text = (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment;// + " " + phone;

                        String tooltip = (cust != null ? (cust.getFname().replaceAll("'","&#39;") + (cust.getLname() != null && cust.getLname().length() > 0 ? " " + cust.getLname().replaceAll("'","&#39;") : "")) : "") + " " + comment;// + " " + phone;
                        Html2Text parser = new Html2Text();
                        parser.parse(new StringReader(tooltip));

                        response = response.concat("{");
                        response = response.concat("\"ServerId\":\"appoint_" + temp.getId() + "\",");
                        response = response.concat("\"BarStart\":0,");
                        response = response.concat("\"EventStatus\":" + temp.getState() + ",");
                        response = response.concat("\"ToolTip\":\"" + parser.getText() + "\",");
                        response = response.concat("\"PartStart\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"Box\":true,");
                        response = response.concat("\"Left\":" + left + ",");
                        response = response.concat("\"Tag\":\"\",");
                        //response = response.concat("\"InnerHTML\":\"Event #"+(temp.getId())+"("+temp.getSt_time()+" - "+temp.getEt_time()+")\",");
                        response = response.concat("\"InnerHTML\":\"" + text + "\",");
                        response = response.concat("\"Width\":" + width + ",");
                        response = response.concat("\"ResizeEnabled\":true,");
                        response = response.concat("\"Start\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"RightClickEnabled\":true,");
                        response = response.concat("\"Value\":\"3\",");
                        response = response.concat("\"Height\":" + heigth + ",");
                        response = response.concat("\"End\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"ClickEnabled\":false,");
                        response = response.concat("\"BarColor\":\"" + color + "\",");
                        response = response.concat("\"BarLength\":" + heigth + ",");
                        response = response.concat("\"PartEnd\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"DeleteEnabled\":true,");
                        response = response.concat("\"Text\":\"Event #" + (index++) + "\",");
                        response = response.concat("\"MoveEnabled\":true,");
                        response = response.concat("\"ContextMenu\":null,");

                        response = response.concat("\"idappt\":" + temp.getId() + ",");
                        response = response.concat("\"ide\":" + temp.getEmployee_id() + ",");
                        response = response.concat("\"idc\":" + temp.getCustomer_id() + ",");
                        response = response.concat("\"ids\":" + temp.getService_id() + ",");
                        response = response.concat("\"dt\":\"" + new SimpleDateFormat("yyyy/M/d").format(temp.getApp_dt()) + "\",");
//                        String timezone = Location.getTimezoneForLocation(1);
//                        int tzint = 0;
//                        try{
//                            tzint = Integer.parseInt(timezone);
//                        }catch (Exception e){
//                            e.printStackTrace();
//                            tzint = 0;
//                        }
                        java.util.Date date = Calendar.getInstance().getTime();
                        int curTime = date.getHours() * 60 + date.getMinutes();
//                        int curTime = date.getHours() * 60 + date.getMinutes()-tzint;
                        int schTimt = temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes();
                        java.util.Date schDate = new Date(temp.getApp_dt().getTime());
                        java.util.Date curDate = new Date(date.getTime());
                        Calendar calSql = Calendar.getInstance();
                        Calendar calUtil = Calendar.getInstance();
                        calSql.setTime(schDate);
                        calUtil.setTime(curDate);
                        calSql.set(Calendar.MILLISECOND, 0);
                        calSql.set(Calendar.SECOND, 0);
                        calSql.set(Calendar.MINUTE, 0);
                        calSql.set(Calendar.HOUR, 0);
                        calSql.set(Calendar.AM_PM, 0);
                        calSql.set(Calendar.HOUR_OF_DAY, 0);
                        calUtil.set(Calendar.MILLISECOND, 0);
                        calUtil.set(Calendar.SECOND, 0);
                        calUtil.set(Calendar.MINUTE, 0);
                        calUtil.set(Calendar.HOUR, 0);
                        calUtil.set(Calendar.AM_PM, 0);
                        calUtil.set(Calendar.HOUR_OF_DAY, 0);

                        String bgColor = "";
                        if (temp.getState() == 1) {    // checked
                            bgColor = "#C1DEA6";//response = response.concat("\"BackgroundColor\":\"#C1DEA6\",");
                        } else if (temp.getState() == 2 || temp.getState() == 4) {    // notshow / canceled
                            bgColor = "#F390BC";//response = response.concat("\"BackgroundColor\":\"#F390BC\",");
                        } else if (temp.getState() == 0) {
                            if (calSql.equals(calUtil)) {
                                if (curTime - schTimt > 5) // normal, new
                                    bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                                else
                                    bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                            } else if (calSql.before(calUtil)) {
                                bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                            } else if (calSql.after(calUtil))
                                bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                        } else if (temp.getState() == 3) {    //paid
                            bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                        }

                        Ticket t = Ticket.findTicketById(temp.getTicket_id());
                        if(t != null){
                            ArrayList a = Reconciliation.findTransByCode(t.getCode_transaction());
                            if(a != null && a.size() > 0){
                                Reconciliation r = (Reconciliation)a.get(0);
                                if(r != null && r.getStatus() == 0)
                                    bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                            }
                        }

                        if(!bgColor.equals(""))
                            response = response.concat("\"BackgroundColor\":\""+bgColor+"\",");
                        response = response.concat("\"Top\":" + (startIndex * 22) + ",");
                        response = response.concat("\"DayIndex\":0");
                        response = response.concat("},");
                        //System.out.println(response);
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    responseAll = responseAll.concat(response);
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return responseAll.substring(0, responseAll.length() - 1);
    }

    public static String generateEventByIdApp(int idLocation, Date currentDate, int pageNum, int app_id) {
        String responseAll = " ";

        SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy HH:mm:ss");
        try {
            Appointment ap = Appointment.findById(app_id);
            ArrayList list = new ArrayList();
            HashMap hm = new HashMap();
            if (ap != null){
                list.add(ap);
                hm.put(ap.getEmployee_id(), list);
            }
            int index = 1;
            Iterator it = hm.values().iterator();

            Calendar cal = new GregorianCalendar();
            cal.setTime(currentDate);
            int week_day = 0;
            if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
                week_day = 0;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
                week_day = 1;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
                week_day = 2;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
                week_day = 3;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
                week_day = 4;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
                week_day = 5;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
                week_day = 6;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
            int _from = _wtemp.getH_from().getHours();
            int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

            /*int _from = 24;
            int _to = 0;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            for(int i = 0; i < 7; i++)
            {
                WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

                double __from = wtemp.getH_from().getHours();
                _from = (int)(__from < _from ? __from : _from);

                double min = wtemp.getH_to().getMinutes() / 60.0f;
                min = min > 0 ? 1 : 0;
                double __to = wtemp.getH_to().getHours() +  min;
                _to = (int)(__to > _to ? __to : _to);
            }*/

            generateIndexes(idLocation, currentDate, pageNum);

            while (it.hasNext()) {
                ArrayList tempList = (ArrayList) it.next();
                for (int i = 0; i < tempList.size(); i++) {
                    String response = "";
                    try {
                        int width = 100;
                        Appointment temp = (Appointment) tempList.get(i);
//                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
                        int heigth = (endIndex - startIndex) * 22;
                        int maxCells = 1;
                        if (scheduleArray.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (scheduleArray.get("" + temp.getEmployee_id())[startIndex + count] > maxCells) {
                                    maxCells = scheduleArray.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                            width = width / maxCells;
                        }

                        if (maxWidthPerCell.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] < width) {
                                    width = maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                        }

                        int left = 0;
                        int leftReturn = getLeft(temp, maxCells, width);
                        if (leftReturn >= 0) {
                            left = leftReturn;
                        }
//                        int sdvig = ScheduleShift.getShift(employeeListOrder.get(""+temp.getEmployee_id()), browser);
                        /*if (employeeListOrder.get(""+temp.getEmployee_id()) > 3 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-2;

                        if (employeeListOrder.get(""+temp.getEmployee_id()) > 6 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-1;
*/
//                        if(employeeListOrder.get(""+temp.getEmployee_id()) > 0){
//                            left += employeeListOrder.get(""+temp.getEmployee_id())*100+sdvig;
//                        }
//                        if (employeeListOrder.get("" + temp.getEmployee_id()) == null) System.out.println("employeeListOrder is null");
                        if (employeeListOrder.get("" + temp.getEmployee_id()) != null && employeeListOrder.get("" + temp.getEmployee_id()) > 0) {
                            left += employeeListOrder.get("" + temp.getEmployee_id()) * 100;
                        }

                        Customer cust = null;
                        try {
                            cust = Customer.findById(temp.getCustomer_id());
                        }
                        catch (Exception ex) {
                        }
                        Service serv = null;
                        try {
                            serv = Service.findById(temp.getService_id());
                        }
                        catch (Exception ex) {
                        }

                        SimpleDateFormat formatDt = new SimpleDateFormat("MMMMM d, yyyy");
                        String comment = "";
                        String text = "";
//                        String phone = "";
                        String color = "#FF5B01";
//                        if (cust.getPhone().length() != 0)
//                            phone = cust.getPhone();
//
//                        if (cust.getPhone().length() == 0 && cust.getCell_phone().length() != 0)
//                            phone = cust.getCell_phone();

                        if (temp.getComment() != null && !temp.getComment().equals("")) {
                            comment = "<br><b><font color=#740F85>" + temp.getComment().replaceAll("'","&#39;") + "</font></b>";
//                            comment = temp.getComment();
                            color = "#740F85";
                        }

                        if (temp.getRequest()) {
                            text = "<b style='color:#ea2e44;'>" + (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment /*+ " " + phone*/ + "</b>";
                        } else
                            text = (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment;// + " " + phone;

                        String tooltip = (cust != null ? (cust.getFname().replaceAll("'","&#39;") + (cust.getLname() != null && cust.getLname().length() > 0 ? " " + cust.getLname().replaceAll("'","&#39;") : "")) : "") + " " + comment;// + " " + phone;
                        Html2Text parser = new Html2Text();
                        parser.parse(new StringReader(tooltip));

                        response = response.concat("{");
                        response = response.concat("\"ServerId\":\"appoint_" + temp.getId() + "\",");
                        response = response.concat("\"BarStart\":0,");
                        response = response.concat("\"EventStatus\":" + temp.getState() + ",");
                        response = response.concat("\"ToolTip\":\"" + parser.getText() + "\",");
                        response = response.concat("\"PartStart\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"Box\":true,");
                        response = response.concat("\"Left\":" + left + ",");
                        response = response.concat("\"Tag\":\"\",");
                        //response = response.concat("\"InnerHTML\":\"Event #"+(temp.getId())+"("+temp.getSt_time()+" - "+temp.getEt_time()+")\",");
                        response = response.concat("\"InnerHTML\":\"" + text + "\",");
                        response = response.concat("\"Width\":" + width + ",");
                        response = response.concat("\"ResizeEnabled\":true,");
                        response = response.concat("\"Start\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"RightClickEnabled\":true,");
                        response = response.concat("\"Value\":\"3\",");
                        response = response.concat("\"Height\":" + heigth + ",");
                        response = response.concat("\"End\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"ClickEnabled\":false,");
                        response = response.concat("\"BarColor\":\"" + color + "\",");
                        response = response.concat("\"BarLength\":" + heigth + ",");
                        response = response.concat("\"PartEnd\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"DeleteEnabled\":true,");
                        response = response.concat("\"Text\":\"Event #" + (index++) + "\",");
                        response = response.concat("\"MoveEnabled\":true,");
                        response = response.concat("\"ContextMenu\":null,");

                        response = response.concat("\"idappt\":" + temp.getId() + ",");
                        response = response.concat("\"ide\":" + temp.getEmployee_id() + ",");
                        response = response.concat("\"idc\":" + temp.getCustomer_id() + ",");
                        response = response.concat("\"ids\":" + temp.getService_id() + ",");
                        response = response.concat("\"dt\":\"" + new SimpleDateFormat("yyyy/M/d").format(temp.getApp_dt()) + "\",");
//                        String timezone = Location.getTimezoneForLocation(1);
//                        int tzint = 0;
//                        try{
//                            tzint = Integer.parseInt(timezone);
//                        }catch (Exception e){
//                            e.printStackTrace();
//                            tzint = 0;
//                        }
                        java.util.Date date = Calendar.getInstance().getTime();
                        int curTime = date.getHours() * 60 + date.getMinutes();
//                        int curTime = date.getHours() * 60 + date.getMinutes()-tzint;
                        int schTimt = temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes();
                        java.util.Date schDate = new Date(temp.getApp_dt().getTime());
                        java.util.Date curDate = new Date(date.getTime());
                        Calendar calSql = Calendar.getInstance();
                        Calendar calUtil = Calendar.getInstance();
                        calSql.setTime(schDate);
                        calUtil.setTime(curDate);
                        calSql.set(Calendar.MILLISECOND, 0);
                        calSql.set(Calendar.SECOND, 0);
                        calSql.set(Calendar.MINUTE, 0);
                        calSql.set(Calendar.HOUR, 0);
                        calSql.set(Calendar.AM_PM, 0);
                        calSql.set(Calendar.HOUR_OF_DAY, 0);
                        calUtil.set(Calendar.MILLISECOND, 0);
                        calUtil.set(Calendar.SECOND, 0);
                        calUtil.set(Calendar.MINUTE, 0);
                        calUtil.set(Calendar.HOUR, 0);
                        calUtil.set(Calendar.AM_PM, 0);
                        calUtil.set(Calendar.HOUR_OF_DAY, 0);

                        String bgColor = "";
                        if (temp.getState() == 1) {    // checked
                            bgColor = "#C1DEA6";//response = response.concat("\"BackgroundColor\":\"#C1DEA6\",");
                        } else if (temp.getState() == 2 || temp.getState() == 4) {    // notshow / canceled
                            bgColor = "#F390BC";//response = response.concat("\"BackgroundColor\":\"#F390BC\",");
                        } else if (temp.getState() == 0) {
                            if (calSql.equals(calUtil)) {
                                if (curTime - schTimt > 5) // normal, new
                                    bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                                else
                                    bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                            } else if (calSql.before(calUtil)) {
                                bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                            } else if (calSql.after(calUtil))
                                bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                        } else if (temp.getState() == 3) {    //paid
                            bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                        }

                        Ticket t = Ticket.findTicketById(temp.getTicket_id());
                        if(t != null){
                            ArrayList a = Reconciliation.findTransByCode(t.getCode_transaction());
                            if(a != null && a.size() > 0){
                                Reconciliation r = (Reconciliation)a.get(0);
                                if(r != null && r.getStatus() == 0)
                                    bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                            }
                        }

                        if(!bgColor.equals(""))
                            response = response.concat("\"BackgroundColor\":\""+bgColor+"\",");
                        response = response.concat("\"Top\":" + (startIndex * 22) + ",");
                        response = response.concat("\"DayIndex\":0");
                        response = response.concat("},");
                        //System.out.println(response);
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    responseAll = responseAll.concat(response);
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return responseAll.substring(0, responseAll.length() - 1);
    }

    public static String generateEmployeeEventsArray(int idLocation, Date currentDate, int pageNum, int employee_id) {
        String responseAll = " ";

        SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy HH:mm:ss");
        try {
            HashMap hm = new HashMap();
            hm = Appointment.findByEmployeeId(employee_id, idLocation);
            int index = 1;
            Iterator it = hm.values().iterator();

            Calendar cal = new GregorianCalendar();
            cal.setTime(currentDate);
            int week_day = 0;
            if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
                week_day = 0;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
                week_day = 1;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
                week_day = 2;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
                week_day = 3;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
                week_day = 4;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
                week_day = 5;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
                week_day = 6;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
            int _from = _wtemp.getH_from().getHours();
            int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

            /*int _from = 24;
            int _to = 0;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            for(int i = 0; i < 7; i++)
            {
                WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

                double __from = wtemp.getH_from().getHours();
                _from = (int)(__from < _from ? __from : _from);

                double min = wtemp.getH_to().getMinutes() / 60.0f;
                min = min > 0 ? 1 : 0;
                double __to = wtemp.getH_to().getHours() +  min;
                _to = (int)(__to > _to ? __to : _to);
            }*/

            generateIndexes(idLocation, currentDate, pageNum);

            while (it.hasNext()) {
                ArrayList tempList = (ArrayList) it.next();
                for (int i = 0; i < tempList.size(); i++) {
                    String response = "";
                    try {
                        int width = 100;
                        Appointment temp = (Appointment) tempList.get(i);
//                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
                        int heigth = (endIndex - startIndex) * 22;
                        int maxCells = 1;
                        if (scheduleArray.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (scheduleArray.get("" + temp.getEmployee_id())[startIndex + count] > maxCells) {
                                    maxCells = scheduleArray.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                            width = width / maxCells;
                        }

                        if (maxWidthPerCell.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] < width) {
                                    width = maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                        }

                        int left = 0;
                        int leftReturn = getLeft(temp, maxCells, width);
                        if (leftReturn >= 0) {
                            left = leftReturn;
                        }
//                        int sdvig = ScheduleShift.getShift(employeeListOrder.get(""+temp.getEmployee_id()), browser);
                        /*if (employeeListOrder.get(""+temp.getEmployee_id()) > 3 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-2;

                        if (employeeListOrder.get(""+temp.getEmployee_id()) > 6 && browser.equals("Microsoft Internet Explorer"))
                            sdvig = employeeListOrder.get(""+temp.getEmployee_id())-1;
*/
//                        if(employeeListOrder.get(""+temp.getEmployee_id()) > 0){
//                            left += employeeListOrder.get(""+temp.getEmployee_id())*100+sdvig;
//                        }
//                        if (employeeListOrder.get("" + temp.getEmployee_id()) == null) System.out.println("employeeListOrder is null");
                        if (employeeListOrder.get("" + temp.getEmployee_id()) != null && employeeListOrder.get("" + temp.getEmployee_id()) > 0) {
                            left += employeeListOrder.get("" + temp.getEmployee_id()) * 100;
                        }

                        Customer cust = null;
                        try {
                            cust = Customer.findById(temp.getCustomer_id());
                        }
                        catch (Exception ex) {
                        }
                        Service serv = null;
                        try {
                            serv = Service.findById(temp.getService_id());
                        }
                        catch (Exception ex) {
                        }

                        SimpleDateFormat formatDt = new SimpleDateFormat("MMMMM d, yyyy");
                        String comment = "";
                        String text = "";
//                        String phone = "";
                        String color = "#FF5B01";
//                        if (cust.getPhone().length() != 0)
//                            phone = cust.getPhone();
//
//                        if (cust.getPhone().length() == 0 && cust.getCell_phone().length() != 0)
//                            phone = cust.getCell_phone();

                        if (temp.getComment() != null && !temp.getComment().equals("")) {
                            comment = "<br><b><font color=#740F85>" + temp.getComment().replaceAll("'","&#39;") + "</font></b>";
//                            comment = temp.getComment();
                            color = "#740F85";
                        }

                        if (temp.getRequest()) {
                            text = "<b style='color:#ea2e44;'>" + (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment /*+ " " + phone*/ + "</b>";
                        } else
                            text = (cust != null ? ("" + cust.getFname().replaceAll("'","&#39;") + " " + cust.getLname().replaceAll("'","&#39;")) : "") + (serv != null ? (" - " + serv.getName()) : "") + comment;// + " " + phone;

                        String tooltip = (cust != null ? (cust.getFname().replaceAll("'","&#39;") + (cust.getLname() != null && cust.getLname().length() > 0 ? " " + cust.getLname().replaceAll("'","&#39;") : "")) : "") + " " + comment;// + " " + phone;
                        Html2Text parser = new Html2Text();
                        parser.parse(new StringReader(tooltip));

                        response = response.concat("{");
                        response = response.concat("\"ServerId\":\"appoint_" + temp.getId() + "\",");
                        response = response.concat("\"BarStart\":0,");
                        response = response.concat("\"EventStatus\":" + temp.getState() + ",");
                        response = response.concat("\"ToolTip\":\"" + parser.getText() + "\",");
                        response = response.concat("\"PartStart\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"Box\":true,");
                        response = response.concat("\"Left\":" + left + ",");
                        response = response.concat("\"Tag\":\"\",");
                        //response = response.concat("\"InnerHTML\":\"Event #"+(temp.getId())+"("+temp.getSt_time()+" - "+temp.getEt_time()+")\",");
                        response = response.concat("\"InnerHTML\":\"" + text + "\",");
                        response = response.concat("\"Width\":" + width + ",");
                        response = response.concat("\"ResizeEnabled\":true,");
                        response = response.concat("\"Start\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getSt_time() + " +0000\",");
                        response = response.concat("\"RightClickEnabled\":true,");
                        response = response.concat("\"Value\":\"3\",");
                        response = response.concat("\"Height\":" + heigth + ",");
                        response = response.concat("\"End\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"ClickEnabled\":false,");
                        response = response.concat("\"BarColor\":\"" + color + "\",");
                        response = response.concat("\"BarLength\":" + heigth + ",");
                        response = response.concat("\"PartEnd\":\"" + formatDt.format(temp.getApp_dt()) + " " + temp.getEt_time() + " +0000\",");
                        response = response.concat("\"DeleteEnabled\":true,");
                        response = response.concat("\"Text\":\"Event #" + (index++) + "\",");
                        response = response.concat("\"MoveEnabled\":true,");
                        response = response.concat("\"ContextMenu\":null,");

                        response = response.concat("\"idappt\":" + temp.getId() + ",");
                        response = response.concat("\"ide\":" + temp.getEmployee_id() + ",");
                        response = response.concat("\"idc\":" + temp.getCustomer_id() + ",");
                        response = response.concat("\"ids\":" + temp.getService_id() + ",");
                        response = response.concat("\"dt\":\"" + new SimpleDateFormat("yyyy/M/d").format(temp.getApp_dt()) + "\",");
//                        String timezone = Location.getTimezoneForLocation(1);
//                        int tzint = 0;
//                        try{
//                            tzint = Integer.parseInt(timezone);
//                        }catch (Exception e){
//                            e.printStackTrace();
//                            tzint = 0;
//                        }
                        java.util.Date date = Calendar.getInstance().getTime();
                        int curTime = date.getHours() * 60 + date.getMinutes();
//                        int curTime = date.getHours() * 60 + date.getMinutes()-tzint;
                        int schTimt = temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes();
                        java.util.Date schDate = new Date(temp.getApp_dt().getTime());
                        java.util.Date curDate = new Date(date.getTime());
                        Calendar calSql = Calendar.getInstance();
                        Calendar calUtil = Calendar.getInstance();
                        calSql.setTime(schDate);
                        calUtil.setTime(curDate);
                        calSql.set(Calendar.MILLISECOND, 0);
                        calSql.set(Calendar.SECOND, 0);
                        calSql.set(Calendar.MINUTE, 0);
                        calSql.set(Calendar.HOUR, 0);
                        calSql.set(Calendar.AM_PM, 0);
                        calSql.set(Calendar.HOUR_OF_DAY, 0);
                        calUtil.set(Calendar.MILLISECOND, 0);
                        calUtil.set(Calendar.SECOND, 0);
                        calUtil.set(Calendar.MINUTE, 0);
                        calUtil.set(Calendar.HOUR, 0);
                        calUtil.set(Calendar.AM_PM, 0);
                        calUtil.set(Calendar.HOUR_OF_DAY, 0);

                        String bgColor = "";
                        if (temp.getState() == 1) {    // checked
                            bgColor = "#C1DEA6";//response = response.concat("\"BackgroundColor\":\"#C1DEA6\",");
                        } else if (temp.getState() == 2 || temp.getState() == 4) {    // notshow / canceled
                            bgColor = "#F390BC";//response = response.concat("\"BackgroundColor\":\"#F390BC\",");
                        } else if (temp.getState() == 0) {
                            if (calSql.equals(calUtil)) {
                                if (curTime - schTimt > 5) // normal, new
                                    bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                                else
                                    bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                            } else if (calSql.before(calUtil)) {
                                bgColor = "#FFF57A";//response = response.concat("\"BackgroundColor\":\"#FFF57A\",");
                            } else if (calSql.after(calUtil))
                                bgColor = "#FFFFFF";//response = response.concat("\"BackgroundColor\":\"#FFFFFF\",");
                        } else if (temp.getState() == 3) {    //paid
                            bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                        }

                        Ticket t = Ticket.findTicketById(temp.getTicket_id());
                        if(t != null){
                            ArrayList a = Reconciliation.findTransByCode(t.getCode_transaction());
                            if(a != null && a.size() > 0){
                                Reconciliation r = (Reconciliation)a.get(0);
                                if(r != null && r.getStatus() == 0)
                                    bgColor = "#acadb1";//response = response.concat("\"BackgroundColor\":\"#acadb1\",");
                            }
                        }

                        if(!bgColor.equals(""))
                            response = response.concat("\"BackgroundColor\":\""+bgColor+"\",");
                        response = response.concat("\"Top\":" + (startIndex * 22) + ",");
                        response = response.concat("\"DayIndex\":0");
                        response = response.concat("},");
                        //System.out.println(response);
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    responseAll = responseAll.concat(response);
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return responseAll.substring(0, responseAll.length() - 1);
    }

    public static void generateIndexes(int idLocation, Date currentDate, int pageNum) {
        String responseAll = " ";
        SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy HH:mm:ss");
        try {
            HashMap hm = Appointment.findApptByLocDate(idLocation, currentDate, pageNum);
            int index = 1;

            Calendar cal = new GregorianCalendar();
            cal.setTime(currentDate);
            int week_day = 0;
            if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
                week_day = 0;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
                week_day = 1;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
                week_day = 2;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
                week_day = 3;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
                week_day = 4;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
                week_day = 5;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
                week_day = 6;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
            int _from = _wtemp.getH_from().getHours();
            int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

            /*int _from = 24;
            int _to = 0;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            for(int i = 0; i < 7; i++)
            {
                WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

                double __from = wtemp.getH_from().getHours();
                _from = (int)(__from < _from ? __from : _from);

                double min = wtemp.getH_to().getMinutes() / 60.0f;
                min = min > 0 ? 1 : 0;
                double __to = wtemp.getH_to().getHours() +  min;
                _to = (int)(__to > _to ? __to : _to);
            }   */

            Iterator it = hm.values().iterator();
            while (it.hasNext()) {
                ArrayList tempList = (ArrayList) it.next();
                for (int i = 0; i < tempList.size(); i++) {
                    String response = "";
                    try {
                        int width = 100;
                        Appointment temp = (Appointment) tempList.get(i);
//                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
                        int heigth = (endIndex - startIndex) * 20;
                        int maxCells = 1;
                        if (scheduleArray.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (scheduleArray.get("" + temp.getEmployee_id())[startIndex + count] > maxCells) {
                                    maxCells = scheduleArray.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }
                            width = width / maxCells;
                        }

                        if (maxWidthPerCell.containsKey("" + temp.getEmployee_id())) {
                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] < width) {
                                    width = maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count];
                                }
                            }

                            for (int count = 0; count < (endIndex - startIndex); count++) {
                                if (maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] > width) {
                                    maxWidthPerCell.get("" + temp.getEmployee_id())[startIndex + count] = width;
                                }
                            }
                        }
                    }
                    catch (Exception ex) {
                    }
                }
            }
        }
        catch (Exception ex) {
        }
    }

    public static void initScheduleArray(int idLocation, Date currentDate, int pageNum) {

        try {
            HashMap hm = Appointment.findApptByLocDate(idLocation, currentDate, pageNum);
            Iterator it = hm.values().iterator();

            Calendar cal = new GregorianCalendar();
            cal.setTime(currentDate);
            int week_day = 0;
            if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
                week_day = 0;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
                week_day = 1;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
                week_day = 2;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
                week_day = 3;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
                week_day = 4;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
                week_day = 5;
            else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
                week_day = 6;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
            int _from = _wtemp.getH_from().getHours();
            int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);
            
            /*int _from = 24;
            int _to = 0;
            ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(idLocation);
            for(int i = 0; i < 7; i++)
            {
                WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

                double __from = wtemp.getH_from().getHours();
                _from = (int)(__from < _from ? __from : _from);

                double min = wtemp.getH_to().getMinutes() / 60.0f;
                min = min > 0 ? 1 : 0;
                double __to = wtemp.getH_to().getHours() +  min;
                _to = (int)(__to > _to ? __to : _to);
            }*/

            while (it.hasNext()) {
                ArrayList appList = (ArrayList) it.next();
                for (int count = 0; count < appList.size(); count++) {
                    Appointment temp = (Appointment) appList.get(count);
                    if (!scheduleArray.containsKey("" + temp.getEmployee_id())) {
                        int[] tempArr = new int[/*44*/(_to-_from)*4 ]; // vogue
                        for (int j = 0; j < /*44*/(_to-_from)*4; j++) {   // vogue
                            tempArr[j] = 0;
                        }
                        scheduleArray.put("" + temp.getEmployee_id(), tempArr);

                        int[] tempArr2 = new int[/*44*/(_to-_from)*4]; // vogue
                        for (int j = 0; j < /*44*/(_to-_from)*4; j++) { // vogue
                            tempArr2[j] = 0;
                        }

                        scheduleArrayRemainingOnSameCell.put("" + temp.getEmployee_id(), tempArr2);

                        String[] tempArrX = new String[/*44*/(_to-_from)*4]; // vogue
                        for (int j = 0; j < /*44*/(_to-_from)*4; j++) { // vogue
                            tempArrX[j] = "";
                        }

                        scheduleArrayLeftOcuppied.put("" + temp.getEmployee_id(), tempArrX);

                        int[] tempArrZ = new int[/*44*/(_to-_from)*4]; // vogue
                        for (int j = 0; j < /*44*/(_to-_from)*4; j++) { // vogue
                            tempArrZ[j] = 100;
                        }

                        maxWidthPerCell.put("" + temp.getEmployee_id(), tempArrZ);
                    }

                    try {
//                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
                        int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
                        int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
                        int rowspan = (endIndex - startIndex);
                        int[] tempArr3 = scheduleArray.get("" + temp.getEmployee_id());
                        for (int j = 0; j < rowspan; j++) {
                        	if(tempArr3.length > startIndex + j)
                        		tempArr3[startIndex + j] += 1;
                        }
                        scheduleArray.put("" + temp.getEmployee_id(), tempArr3);
                    }
                    catch (Exception ex) {
                        System.out.println("Exception: " + ex.getMessage());
                        ex.printStackTrace();
                    }
                }
            }
        }
        catch (Exception ex) {
            System.out.println("Exception: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public static void initEmployeeListForDay(int locatinoId, Date currentDate, int pageNum) {
        try {
            /*int day = currentDate.getDay();
            if(day==0)
                day=day+7;*/

            ArrayList empList = Employee.findAvaiableByLoc(locatinoId, currentDate, pageNum);//findAllByLocAndDate(locatinoId,day,pageNum);//
            //System.out.println("empList.size= " + empList.size());
            for (int i = 0; i < empList.size(); i++) {
                employeeListOrder.put("" + ((Employee) empList.get(i)).getId(), i);
            }
        }
        catch (Exception ex) {
            System.out.println("error initEmployeeListForDay");
        }
    }

    public static int getLeft(Appointment temp, int maxCells, int width) {
        Calendar cal = new GregorianCalendar();
        cal.setTime(temp.getApp_dt());
        int week_day = 0;
        if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY)
            week_day = 0;
        else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY)
            week_day = 1;
        else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY)
            week_day = 2;
        else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY)
            week_day = 3;
        else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY)
            week_day = 4;
        else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY)
            week_day = 5;
        else if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY)
            week_day = 6;
        ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(1); // TODO must be location id
        WorkingtimeLoc _wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(week_day) : new WorkingtimeLoc());
        int _from = _wtemp.getH_from().getHours();
        int _to = _wtemp.getH_to().getHours() +  (_wtemp.getH_to().getMinutes() / 60.0f > 0 ? 1 : 0);

        /*int _from = 24;
        int _to = 0;
        ArrayList _wtime = WorkingtimeLoc.findAllByLocationId(1); //TODO: must be location id
        for(int i = 0; i < 7; i++)
        {
            WorkingtimeLoc wtemp = ((_wtime != null)&& (_wtime.size() != 0)? (WorkingtimeLoc)_wtime.get(i) : new WorkingtimeLoc());

            double __from = wtemp.getH_from().getHours();
            _from = (int)(__from < _from ? __from : _from);

            double min = wtemp.getH_to().getMinutes() / 60.0f;
            min = min > 0 ? 1 : 0;
            double __to = wtemp.getH_to().getHours() +  min;
            _to = (int)(__to > _to ? __to : _to);
        }*/

        if (scheduleArrayLeftOcuppied.containsKey("" + temp.getEmployee_id())) {
//            int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - 36;
//            int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - 36;
            int startIndex = (temp.getSt_time().getHours() * 60 + temp.getSt_time().getMinutes()) / 15 - _from*4;//32; // for esalonsoft/vogue
            int endIndex = (temp.getEt_time().getHours() * 60 + temp.getEt_time().getMinutes()) / 15 - _from*4;//32;   // for esalonsoft/vogue
            int leftIndex = -1;
            String[] scheduleArrayRemaining = scheduleArrayLeftOcuppied.get("" + temp.getEmployee_id());
            boolean isOverLayed = false;


            for (int j = 0; j < maxCells; j++) {
                boolean hasFoundLeftIndex = true;
                for (int count = 0; count < (endIndex - startIndex); count++) {
                    if (scheduleArrayRemaining[startIndex + count].length() > j && scheduleArrayRemaining[startIndex + count].charAt(j) == '1') {
                        hasFoundLeftIndex = false;
                    }
                }

                if (hasFoundLeftIndex) {
                    leftIndex = j;
                    break;
                }
            }

            if (leftIndex == -1) {
                leftIndex = maxCells - 1;
            }

            int[] maxWidthRemaining = maxWidthPerCell.get("" + temp.getEmployee_id());
            for (int count = 0; count < (endIndex - startIndex); count++) {
                if (maxWidthRemaining[startIndex + count] > width) {
                    isOverLayed = true;
                }
            }

            for (int count = 0; count < (endIndex - startIndex); count++) {
                String tempString = scheduleArrayRemaining[startIndex + count];
                if (tempString.length() <= leftIndex) {
                    for (int countS = tempString.length(); countS < leftIndex; countS++) {
                        tempString = tempString.concat("0");
                    }
                    tempString = tempString.concat("1");
                } else {
                    char[] tempCharArray = tempString.toCharArray();
                    tempCharArray[leftIndex] = '1';
                    tempString = String.copyValueOf(tempCharArray);
                }
                scheduleArrayRemaining[startIndex + count] = tempString;
            }

            scheduleArrayLeftOcuppied.put("" + temp.getEmployee_id(), scheduleArrayRemaining);

            int widthFactor = 100 / maxCells;
            if (leftIndex == maxCells - 1 && isOverLayed) {
                width = widthFactor;
            }

            return leftIndex * width;
        }
        return -1;
    }
}
