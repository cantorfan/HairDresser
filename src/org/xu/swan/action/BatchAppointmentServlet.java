package org.xu.swan.action;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

import javax.mail.Session;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.xu.swan.bean.Appointment;
import org.xu.swan.bean.Customer;
import org.xu.swan.bean.EmailTemplate;
import org.xu.swan.bean.Employee;
import org.xu.swan.bean.Service;
import org.xu.swan.bean.User;
import org.xu.swan.util.SendMailHelper;

/**
 * Servlet implementation class BatchAppointment
 */
public class BatchAppointmentServlet extends HttpServlet {
	private static Logger log = Logger.getLogger(BatchAppointmentServlet.class);
	private static final long serialVersionUID = 1L;
    private static String WEEKLY="weekly";
    private static String MONTHLY =  "monthly";
    private static String REMOVE =  "remove";
    private static String SEND_MAIL = "send_batch_appointment_email";
	
    public BatchAppointmentServlet() {
        super();
    }

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		log.debug("BatchAppointment Servlet......");
		
		HttpSession session = request.getSession();
		User user_ses = (User) session.getAttribute("user");
		if(user_ses==null){
			response.sendRedirect("./error.jsp?ec=1");
	        return ;
		}else{
			String action = StringUtils.defaultString(request.getParameter("action"), "");
			if(action.equals(WEEKLY)){
				batchWeekly(request, response);
			}else if(action.equals(MONTHLY)){
				batchMonthly(request, response);
			}else if(action.equals(REMOVE)){
				removeBatchAppointment(request, response);
			}else if(action.equals(SEND_MAIL)){
				sendBatchMail(request, response);
			}
		}
	}
	
	/**
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	private void batchWeekly(HttpServletRequest request, HttpServletResponse response) throws IOException{
		
		String appointmentID = StringUtils.defaultString(request.getParameter("appointmentID"), "");
		String endtime = StringUtils.defaultString(request.getParameter("endTime"), "");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		appointmentID = appointmentID.replace("appoint_", "");
		
		try {
			Appointment appointment = Appointment.findById(Integer.parseInt(appointmentID));
			
			Calendar fromTime = Calendar.getInstance();
			Calendar toTime = Calendar.getInstance();
		
			toTime.setTime(sdf.parse(endtime));
			
			String batchID = null;
			if(appointment.getBatchId()!=null && "".equals(appointment.getBatchId())==false)
				batchID = appointment.getBatchId();
			else 
				batchID = fromTime.getTimeInMillis() + "" + new Random().nextInt(999);
			
			boolean exist = false;
			fromTime.add(Calendar.DAY_OF_WEEK, 7);
			while (toTime.after(fromTime)) {
				Appointment ap = (Appointment) appointment.clone();
				ap.setId(0);
				ap.setApp_dt(new java.sql.Date(fromTime.getTimeInMillis()));
				ap.setBatchId(batchID);
				
				@SuppressWarnings("unchecked")
				ArrayList<Appointment> existApsp = Appointment.
						findByFilter(" where "+Appointment.APPDT+"='"+ap.getApp_dt()+
								"' and "+Appointment.ST+"='"+ap.getSt_time()+
								"' and "+Appointment.CUST+"="+ap.getCustomer_id()+
								" and "+Appointment.SVC+"="+ap.getService_id()+
								" and "+Appointment.ET+"='"+ap.getEt_time()+"'");
				if(existApsp.size()>0){
					exist = true;
					continue;
				}
				Appointment.insert(ap);
				fromTime.add(Calendar.DAY_OF_WEEK, 7);
			}
			
			if(!exist)
				Appointment.updateBatchAppointment(appointment.getId(), batchID);
			
			response.getWriter().write("{\"status\": true, \"message\": \"success\", \"batchId\":\""+batchID+"\", \"customerId\":\""+appointment.getCustomer_id()+"\"}");
		} catch (ParseException e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
		}
	}
	
	/**
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	private void batchMonthly(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String appointmentID = StringUtils.defaultString(request.getParameter("appointmentID"), "");
		String endtime = StringUtils.defaultString(request.getParameter("endTime"), "");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		
		appointmentID = appointmentID.replace("appoint_", "");
		
		try {
			Appointment appointment = Appointment.findById(Integer.parseInt(appointmentID));
			
			Calendar fromTime = Calendar.getInstance();
			Calendar toTime = Calendar.getInstance();
		
			toTime.setTime(sdf.parse(endtime));
			
			String batchID = null;
			if(appointment.getBatchId()!=null && "".equals(appointment.getBatchId())==false)
				batchID = appointment.getBatchId();
			else 
				batchID = fromTime.getTimeInMillis() + "" + new Random().nextInt(999);
			
			boolean exist = false;
			fromTime.add(Calendar.MONTH, 1);
			while (toTime.after(fromTime)) {
				Appointment ap = (Appointment) appointment.clone();
				ap.setId(0);
				ap.setApp_dt(new java.sql.Date(fromTime.getTimeInMillis()));
				ap.setBatchId(batchID);
				
				@SuppressWarnings("unchecked")
				ArrayList<Appointment> existApsp = Appointment.
						findByFilter(" where "+Appointment.APPDT+"='"+ap.getApp_dt()+
								"' and "+Appointment.ST+"='"+ap.getSt_time()+
								"' and "+Appointment.CUST+"="+ap.getCustomer_id()+
								" and "+Appointment.SVC+"="+ap.getService_id()+
								" and "+Appointment.ET+"='"+ap.getEt_time()+"'");
				if(existApsp.size()>0){
					exist = true;
					continue;
				}
				Appointment.insert(ap);
				fromTime.add(Calendar.MONTH, 1);
			}
			
			if(!exist)
				Appointment.updateBatchAppointment(appointment.getId(), batchID);
			
			response.getWriter().write("{\"status\": true, \"message\": \"success\", \"batchId\":\""+batchID+"\", \"customerId\":\""+appointment.getCustomer_id()+"\"}");
		} catch (ParseException e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
		}
	}
	
	/**
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	private void removeBatchAppointment(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String appointmentID = StringUtils.defaultString(request.getParameter("appointmentID"), "");

		appointmentID = appointmentID.replace("appoint_", "");
		
		Appointment appointment = Appointment.findById(Integer.parseInt(appointmentID));
		
		try {
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
			Appointment.removeBatchAppointment(appointment.getBatchId(), sdf1.format(new Date()));
			response.getWriter().write("{\"status\": true, \"message\": \"success\"}");
		} catch (Exception e) {
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
			e.printStackTrace();
		}
	}

	private void sendBatchMail(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		try {
			String customerId = StringUtils.defaultString(request.getParameter("customerId"), "");
			String batchId = StringUtils.defaultString(request.getParameter("batchId"), "");
			String email = StringUtils.defaultString(request.getParameter("email"), "");
			
			EmailTemplate template = EmailTemplate.findByType(103);  //
			String text = template.getText();
			
			Customer customer = Customer.findById(Integer.parseInt(customerId));
			
			ArrayList<Appointment> apps = Appointment.findByBatchId(batchId);
			
			if(apps.size()>0){
				String time = "";
				String date = "";
				SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm:ss");
				for (int index = 0; index<apps.size(); index++) {
					Appointment app = apps.get(index);
					
					if("".equals(time))
						time = sdfTime.format(app.getSt_time());
					
					date += sdfDate.format(app.getApp_dt())+" "+time;
					if((index+1)<apps.size())
						date +=", ";
					
				}
				
				Employee emp  = Employee.findById(apps.get(0).getEmployee_id());
				String employeeName = emp.getFname()+" "+emp.getLname() + ", ";
				
				Service service = Service.findById(apps.get(0).getService_id());
				
				text = text.replace("{customerName}", customer.getFname()+" "+customer.getLname());
				text = text.replace("{operator}", employeeName);
				text = text.replace("{service}", service.getName());
				text = text.replace("{dateTime}", date);
				
				boolean result = SendMailHelper.send(text, "Appointment Confirmation Email", email);

				response.getWriter().write("{\"status\": true, \"message\": \"success\"}");
			}
		} catch (Exception e) {
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
			e.printStackTrace();
		}
	}
	
}
