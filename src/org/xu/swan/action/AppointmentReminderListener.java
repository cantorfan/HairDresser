package org.xu.swan.action;

import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;
import org.xu.swan.bean.Appointment;
import org.xu.swan.bean.Customer;
import org.xu.swan.bean.EmailTemplate;
import org.xu.swan.util.SendMailHelper;
import org.xu.swan.util.SendMailHelper.SenderInfo;
import org.xu.swan.util.SendMailHelper.SimpleMailSender;

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
				//get curr date normal appointment
				Date date = new Date();
				//get lt st_time record                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat timeSdf = new SimpleDateFormat("HH:mm:ss");
				SimpleDateFormat fullTimeSdf = new SimpleDateFormat("HH:mm:ss SSS");
				SimpleDateFormat fullSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				Calendar fromDate = Calendar.getInstance();
				fromDate.add(Calendar.HOUR_OF_DAY, 2);
				
				Calendar toDate = (Calendar) fromDate.clone();
				Long dura = step-1000;
				toDate.add(Calendar.MILLISECOND, dura.intValue());
				
//				String fromTime = blank(fromDate.get(Calendar.HOUR_OF_DAY))+":"+blank(fromDate.get(Calendar.MINUTE))+":"+blank(fromDate.get(Calendar.SECOND))+" "+blank(fromDate.get(Calendar.MILLISECOND));
//				String toTime = blank(toDate.get(Calendar.HOUR_OF_DAY))+":"+blank(toDate.get(Calendar.MINUTE))+":"+blank(toDate.get(Calendar.SECOND))+" "+blank(toDate.get(Calendar.MILLISECOND));
				String fromTime = fullTimeSdf.format(fromDate.getTime());
				String toTime = fullTimeSdf.format(toDate.getTime());
				
				
				log.debug("Curr Date:"+sdf.format(fromDate.getTime())+", from time:"+fromTime+", end time:"+toTime);
				
				String filter = " where " + Appointment.APPDT + " = '"+sdf.format(fromDate.getTime())+"' and state=0 and " +Appointment.ST+" between '" + fromTime +"' and '"+toTime+"'";
				List<Appointment> as = Appointment.findByFilter(filter);
				
				EmailTemplate emailTemplate = null;
				if(as!=null&&as.size()>0){
					emailTemplate = EmailTemplate.findByType(100);
				
					//send mail
					for (Appointment appointment : as) {
						
						Customer customer = Customer.findById(appointment.getCustomer_id());
						
						log.debug("send mail to:"+customer.getLname()+", email:"+customer.getEmail());
						
						String content = emailTemplate.getText().replace("{customerName}", customer.getFname());
						content = content.replace("{appointmentTime}", sdf.format(date)+" "+timeSdf.format(appointment.getSt_time()));
						
						SendMailHelper.send(content, "Appointment Reminder", customer.getEmail());
						
					}
				}
			}	
		}, 10*1000, step);
    }
    
    private String blank(int value){
    	if(value>=0 && value<10)
    		return "0"+value;
    	return value+"";
    }
    
}
