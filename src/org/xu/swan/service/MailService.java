package org.xu.swan.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.xu.swan.bean.Appointment;
import org.xu.swan.bean.Customer;
import org.xu.swan.bean.EmailTemplate;
import org.xu.swan.bean.Employee;
import org.xu.swan.bean.Location;
import org.xu.swan.bean.Service;
import org.xu.swan.util.SendMailHelper;

public class MailService {
	private Logger log = Logger.getLogger(MailService.class);
	
	public String sendAppointmentConfirmation(int employeeId, int customerId, String email) throws Exception{
		log.debug("Send Appointment Confirmation...");
		
		//Employee employee = Employee.findById(employeeId);
		Customer customer = Customer.findById(customerId);
		List<Appointment> appointments = Appointment.findByCustIdAndMailStatus(customerId, false);

		if(customer==null || email.trim().length()==0 ){
			throw new Exception("failure : email is null!");
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

			int locId = customer.getLocation_id();
			content = this.locationInfo(content, locId);
			
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
			//Boolean result = SendMailHelper.sendHTML(content, "Appointment Confirmation Email", email);
			Boolean result = SendMailHelper.send(content, "Appointment Confirmation Email", email);

			for(int i=0; i<appointments.size()&&result; i++){
				Appointment appointment = appointments.get(i);
				try {
					Appointment.updateChangeSendMailStatus(appointment.getId(), 1, true);
				} catch (Exception e) {
					e.printStackTrace();
					log.error(e.getMessage(), e);
					throw new Exception(e.getMessage()+", appointment ID:"+appointment.getId());
				}
			}

			return result.toString();
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
	}
	
	public String reSendAppointmentConfirmation(int appID, String email) throws Exception{
		log.debug("reSend Appointment Confirmation....");
		
		Appointment appointment = Appointment.findById(appID);
		
		Customer customer = Customer.findById(appointment.getCustomer_id());
		if(customer==null || email.trim().length()==0 ){
			throw new Exception("failure : email is null!");
		}
  	  
		Employee employee = Employee.findById(appointment.getEmployee_id());
		String employeeName = "";
		if(employeeName.indexOf(employee.getFname()+" "+employee.getLname()) == -1)
			employeeName += employee.getFname()+" "+employee.getLname() + ", ";
  	  
  	  
		try {
			EmailTemplate emailTemplate = EmailTemplate.findByType(2);  // type:2 --> Appointment Confirmation Email
			String content = emailTemplate.getText();
  		  
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat timeSdf = new SimpleDateFormat("HH:mm:ss");
      	  
			String date = sdf.format(appointment.getApp_dt());
			String time = timeSdf.format(appointment.getSt_time());
			Service service = Service.findById(appointment.getService_id());
      	  
			String serviceItem = service.getName();
      	  
			content = content.replace("{customerName}", customer.getFname()+" "+customer.getLname());
			content = content.replace("{operator}", employeeName);
			content = content.replace("{service}", serviceItem);
			content = content.replace("{dateTime}", date+" "+time);
      	  
			int locId = customer.getLocation_id();
			content = this.locationInfo(content, locId);
			
			log.debug("appointment confirmation email to:"+email+", content:"+content);
      	  
			//send email
			Boolean result = SendMailHelper.send(content, "Appointment Confirmation Email", email);
      	  
			return result.toString();
		} catch (Exception e) {
			log.debug(e.getMessage(), e);
			throw new Exception(e.getMessage());
		}
	}
	
	public String sendCanceledAppointmentMail(int appointmentId, String email) throws Exception{
		log.debug("Canceled Send Email...");
		try {
			Appointment ap = Appointment.findById(appointmentId);
			if(ap!=null){
				Customer customer = Customer.findById(ap.getCustomer_id());
				if(customer==null || email.trim().length()==0){
					throw new Exception("failure : email is null!");
				}
				
				if(customer!=null){ //send cancel mail
					SimpleDateFormat dateSdf = new SimpleDateFormat("yyyy-MM-dd");
	                SimpleDateFormat timeSdf = new SimpleDateFormat(" HH:mm:ss");
	                String date = dateSdf.format(ap.getApp_dt());
	                String time = timeSdf.format(ap.getSt_time());
	                String dateTime = date+time;
	                
	                EmailTemplate cancelMailTemplate = EmailTemplate.findByType(101);
	                
	                //String text = "Dear {customer}, The Appointment at: {2015-09-09} {11:11:11} has been canceled!";
	                String text = cancelMailTemplate.getText().replace("{customerName}", customer.getLname());
	                text = text.replace("{dataTime}", dateTime);
	                
	                int locId = ap.getLocation_id();
	                text = this.locationInfo(text, locId);
	                
	                SendMailHelper.send(text, "Appointment Canceled", email);
				}
				return "send mail successed!";
			}else{
				return "send mail failure, appointment not found!";
			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
	}
	
	public void sendMailRemindeAppointment(){
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat timeSdf = new SimpleDateFormat("HH:mm:ss");
		
		Calendar fromDate = Calendar.getInstance();
		fromDate.add(Calendar.HOUR_OF_DAY, 3);
		
		String filter = " where "+Appointment.IS_SEND_REMINDER_MAIL+"=false and " + 
				Appointment.APPDT + " = '"+sdf.format(fromDate.getTime())+"' and state=0 and " +
				Appointment.ST+" < '" + timeSdf.format(fromDate.getTime())+"'";
		List<Appointment> as = Appointment.findByFilter(filter);
		
		EmailTemplate emailTemplate = null;
		if(as!=null&&as.size()>0){
			emailTemplate = EmailTemplate.findByType(100);
			Map<Integer, ContentInfo> mailContents = new HashMap<Integer, ContentInfo>();
			//send mail
			for (Appointment appointment : as) {
				
				int customerID = appointment.getCustomer_id();
				String content =  sdf.format(date)+" "+timeSdf.format(appointment.getSt_time());
				
				ContentInfo info = new ContentInfo();
				info.appt = appointment;
				info.mailContent = content;
				
				if(mailContents.get(customerID) == null){
					mailContents.put(customerID, info);
				}
				
				mailContents.get(customerID).appIds.add(appointment.getId());
				
//				Service service = Service.findById(appointment.getService_id());
				
//				String content = "Service: "+service.getName()+"\n"+ "at ";
			}
			
			for (Integer customerID : mailContents.keySet()) {
				ContentInfo info = mailContents.get(customerID);
				
				Customer customer = Customer.findById(info.appt.getCustomer_id());
				String content = emailTemplate.getText().replace("{customerName}", customer.getFname());
				content = content.replace("{appointmentTime}", info.mailContent);
				
				int locId = customer.getLocation_id();
				content = this.locationInfo(content, locId);
				
				boolean result = SendMailHelper.send(content, "Appointment Reminder", customer.getEmail());
				
				log.debug(info);
				log.debug("send reminder email to:"+customer.getEmail()+", content:"+ content);
				if(result)
					for (Integer apptId : info.appIds) {
						Appointment.updateChangeSendMailStatus(apptId, 2, true);
					}
			}
			
		}
	}
	
	private static String WEEKLY="weekly";
    private static String MONTHLY =  "monthly";
	public boolean sendBatchAppointmentMail(String customerId, String batchId, String email) throws Exception{
		try {
		
			EmailTemplate template = EmailTemplate.findByType(103);  //
			String text = template.getText();
			
			Customer customer = Customer.findById(Integer.parseInt(customerId));
			
			ArrayList<Appointment> apps = Appointment.findByBatchId(batchId);
			
			if(apps.size()>0){
				String time = "";
				String from = "";
				String to = "";
				SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
				SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm");
				
				Appointment app = null;
				if(apps.size()>1)
					app = apps.get(1);
				else 
					app = apps.get(0);
				
				time = sdfTime.format(app.getSt_time());
				from = sdfDate.format(app.getApp_dt());
				
				to = sdfDate.format(apps.get(apps.size()-1).getApp_dt());
				
				Calendar cal = Calendar.getInstance();
				cal.setTime(app.getApp_dt());
				
				String[] weeklys = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
				
				String day = "";
				//Dear {customerName}
				//
				//you have booking {service}, at the {day} of every {weekly/monthly} {time}, from {from} - {to}
				//
				//operator:{operator}
				String type = "";
				if(WEEKLY.equals(app.getBatchType())){
					day = weeklys[cal.get(Calendar.DAY_OF_WEEK)-1];
					type = "week";
				}else{
					day = cal.get(Calendar.DAY_OF_MONTH)+" day";
					type = "month"; 
				}
				
				Employee emp  = Employee.findById(apps.get(0).getEmployee_id());
				String employeeName = emp.getFname()+" "+emp.getLname() + ", ";
				
				Service service = Service.findById(apps.get(0).getService_id());
				
				
				text = text.replace("{customerName}", customer.getFname()+" "+customer.getLname());
				text = text.replace("{operator}", employeeName);
				text = text.replace("{service}", service.getName());
				text = text.replace("{weekly/monthly}", type);
				text = text.replace("{time}", time);
				text = text.replace("{from}", from);
				text = text.replace("{to}", to);
				text = text.replace("{day}", day);
				
				int locId = customer.getLocation_id();
				text = this.locationInfo(text, locId);
				
				log.debug("send batch app email \nemail:"+email+"\ncontent:\n"+text);
				
				Boolean result = SendMailHelper.send(text, "Appointment Confirmation Email", email);
				return result;
			}else{
				throw new Exception("Appointment not found!");
			}
			
		} catch (Exception e) {
			log.debug(e.getMessage(), e);
			throw new Exception(e.getMessage());
		}
	}
	
	public boolean sendCheckMail(Customer customer, String email, File file) throws Exception{
		try {
			EmailTemplate emailtemplate = EmailTemplate.findByType(102);
	    	String text = emailtemplate.getText();
	    	
	    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    	text = text.replace("{customerName}", customer.getFname()+" "+customer.getLname());
	    	text = text.replace("{dateTime}", sdf.format(new Date()));
	    	
	    	int locId = customer.getLocation_id();
			text = this.locationInfo(text, locId);
	    	
	    	log.debug("send check out email to: "+email+"\n content:\n"+text);
	    	
	    	return SendMailHelper.sendAttatchment(text, "Check Out Notification", email, file);
		} catch (Exception e) {
			log.debug(e.getMessage(), e);
			throw new Exception(e.getMessage());
		}
	}
	
	public class ContentInfo{
    	public Appointment appt;
    	public String mailContent;
    	public List<Integer> appIds = new ArrayList<Integer>();
		@Override
		public String toString() {
			return "Info [appt=" + appt + ", mailContent=" + mailContent
					+ ", appIds=" + appIds + "]";
		}
    }
	
	/**
	 * @param text			email content
	 * @param locationId	locationId
	 * @return
	 */
	private String locationInfo(String text, int locationId){
		Location loc = Location.findById(locationId);
		
		text = text.replace("{address}", loc.getAddress());
		text = text.replace("{address2}", loc.getAddress2());
		text = text.replace("{blogger}", loc.getBlogger());
		text = text.replace("{city}", loc.getCity());
		text = text.replace("{country}", loc.getCountry());
		text = text.replace("{currency}", loc.getCurrency());
		text = text.replace("{locEmail}", loc.getEmail());
		text = text.replace("{fax}", loc.getFax());
		text = text.replace("{locName}", loc.getName());
		text = text.replace("{phone}", loc.getPhone());
		text = text.replace("{state}", loc.getState());
		text = text.replace("{timezone}", loc.getTimezone());
		text = text.replace("{twitter}", loc.getTwitter());
		
		return text;
	}
	
	
}
