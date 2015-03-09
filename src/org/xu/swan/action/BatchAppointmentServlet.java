package org.xu.swan.action;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

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
import org.xu.swan.service.MailService;
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
	private static String BATCH_TYPE = "batch_type";
    
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
			}else if(action.equals(BATCH_TYPE)){
				getBatchType(request, response);
			}
		}
	}
	
	private void getBatchType(HttpServletRequest request, HttpServletResponse response) throws IOException{
		try {
			String appointmentID = StringUtils.defaultString(request.getParameter("appointmentID"), "");
			appointmentID = appointmentID.replace("appoint_", "");
			
			Appointment app = Appointment.findById(Integer.parseInt(appointmentID));
			String batchType = app.getBatchType();
			if(batchType==null||batchType.equals(""))
				batchType="";
		
			response.getWriter().write("{\"status\": true, \"batchType\": \""+batchType+"\"}");
			
		} catch (Exception e) {
			response.getWriter().write("{\"status\": false, \"message\": \"end date must be more than from date\"}");
			e.printStackTrace();
		}
	}
	
	/**
	 * @param request
	 * @param response
	 * @throws IOException
	 */
	private void batchWeekly(HttpServletRequest request, HttpServletResponse response) throws IOException{
		
		String appointmentID = StringUtils.defaultString(request.getParameter("appointmentID"), "");
		String fromTime = StringUtils.defaultString(request.getParameter("fromTime"), "");
		String toTime = StringUtils.defaultString(request.getParameter("toTime"), "");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		appointmentID = appointmentID.replace("appoint_", "");
		
		try {
			
			Appointment appointment = Appointment.findById(Integer.parseInt(appointmentID));
			if(appointment.getBatchType()!=null && "".equals(appointment.getBatchType())==false)
			{
				response.getWriter().write("{\"status\": false, \"message\": \"appointment is already exist, type is: "+appointment.getBatchType()+"\"}");
				return ;
			}
			
			Calendar startDate = Calendar.getInstance();
			startDate.setTime(appointment.getApp_dt());
			
			Calendar fromTimeCal = Calendar.getInstance();
			Calendar toTimeCal = Calendar.getInstance();
			
			fromTimeCal.setTime(sdf.parse(fromTime));
			toTimeCal.setTime(sdf.parse(toTime));
			
			if(fromTimeCal.after(toTimeCal)){
				response.getWriter().write("{\"status\": false, \"message\": \"end date must be more than from date\"}");
				return ;
			}
			
			String batchID = System.currentTimeMillis() + "" + new Random().nextInt(999);
			Appointment.updateBatchAppointment(batchID, WEEKLY, appointmentID);
			startDate.add(Calendar.DAY_OF_WEEK, 7);
			
			while (startDate.before(toTimeCal) || startDate.equals(toTimeCal)) {
				
				if(fromTimeCal.before(startDate) || fromTimeCal.equals(startDate)){
					Appointment ap = (Appointment) appointment.clone();
					
					ap.setId(0);
					ap.setApp_dt(new java.sql.Date(startDate.getTimeInMillis()));
					ap.setBatchId(batchID);
					ap.setBatchType(WEEKLY);
					Appointment.insert(ap);
				}
				
				startDate.add(Calendar.DAY_OF_WEEK, 7);
			
			}
			
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
		String fromTime = StringUtils.defaultString(request.getParameter("fromTime"), "");
		String toTime = StringUtils.defaultString(request.getParameter("toTime"), "");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		appointmentID = appointmentID.replace("appoint_", "");
		
		try {
			
			Appointment appointment = Appointment.findById(Integer.parseInt(appointmentID));
			if(appointment.getBatchType()!=null && "".equals(appointment.getBatchType())==false)
			{
				response.getWriter().write("{\"status\": false, \"message\": \"appointment is already exist, type is: "+appointment.getBatchType()+"\"}");
				return ;
			}
			
			Calendar startDate = Calendar.getInstance();
			startDate.setTime(appointment.getApp_dt());
			
			Calendar fromTimeCal = Calendar.getInstance();
			Calendar toTimeCal = Calendar.getInstance();
			
			fromTimeCal.setTime(sdf.parse(fromTime));
			toTimeCal.setTime(sdf.parse(toTime));
			
			if(fromTimeCal.after(toTimeCal)){
				response.getWriter().write("{\"status\": false, \"message\": \"end date must be more than from date\"}");
				return ;
			}
			
			String batchID = System.currentTimeMillis() + "" + new Random().nextInt(999);
			Appointment.updateBatchAppointment(batchID, MONTHLY, appointmentID);
			startDate.add(Calendar.MONTH, 1);
			
			while (startDate.before(toTimeCal) || startDate.equals(toTimeCal)) {
				
				if(fromTimeCal.before(startDate) || fromTimeCal.equals(startDate)){
					Appointment ap = (Appointment) appointment.clone();
					
					ap.setId(0);
					ap.setApp_dt(new java.sql.Date(startDate.getTimeInMillis()));
					ap.setBatchId(batchID);
					ap.setBatchType(MONTHLY);
					Appointment.insert(ap);
				}
				
				startDate.add(Calendar.MONTH, 1);
			
			}
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

			MailService mailService = new MailService();
			boolean result = mailService.sendBatchAppointmentMail(customerId, batchId, email);

			if(result)
				response.getWriter().write("{\"status\": true, \"message\": \"success\"}");
			else
				response.getWriter().write("{\"status\": false, \"message\": \"failure\"}");
			
		} catch (Exception e) {
			response.getWriter().write("{\"status\": false, \"message\": \""+e.getMessage()+"\"}");
			e.printStackTrace();
		}
	}
	
}
