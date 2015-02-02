package org.xu.swan.action;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;
import org.xu.swan.bean.Appointment;
import org.xu.swan.bean.Customer;
import org.xu.swan.bean.EmailTemplate;
import org.xu.swan.util.SendMailHelper;

/**
 * Application Lifecycle Listener implementation class AppointmentReminderListener
 *
 */
public class AppointmentReminderListener implements ServletContextListener {
	Logger log = Logger.getLogger(AppointmentReminderListener.class);
	private Timer timer = null;
	/**
     * Default constructor. 
     */
    public AppointmentReminderListener() {
        // TODO Auto-generated constructor stub
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent arg0)  { 
         // TODO Auto-generated method stub
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent arg0)  { 
        log.info("AppointmentReminderListener started...");
    	
        timer = new Timer(true);   
       
        final Long step = 10*60*1000L;
		timer.schedule(new TimerTask(){
			public void run() {
				/*load db*/
				
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
						
//						Service service = Service.findById(appointment.getService_id());
						
//						String content = "Service: "+service.getName()+"\n"+ "at ";
					}
					
					for (Integer customerID : mailContents.keySet()) {
						ContentInfo info = mailContents.get(customerID);
						
						Customer customer = Customer.findById(info.appt.getCustomer_id());
						String content = emailTemplate.getText().replace("{customerName}", customer.getFname());
						content = content.replace("{appointmentTime}", info.mailContent);
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
		}, 10*1000, step);
    }
    
    /**
     * @author Think
     *
     */
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
    
}
