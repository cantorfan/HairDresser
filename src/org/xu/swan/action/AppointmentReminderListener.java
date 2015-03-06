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
import org.xu.swan.service.MailService;
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
				
				MailService mail = new MailService();
				mail.sendMailRemindeAppointment();
				
			}	
		}, 10*1000, step);
    }
    
}
