package org.xu.Log4j;

import org.apache.log4j.PropertyConfigurator;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.Properties;
import java.util.UUID;


public class Log4jInit implements ServletContextListener {

    public void contextInitialized(ServletContextEvent event) {

        UUID i = UUID.randomUUID();
        Properties prp = new Properties();
        prp.put("log4j.rootLogger", "DEBUG, logfile, console");
        
        prp.put("log4j.appender.logfile", "org.apache.log4j.RollingFileAppender");
        prp.put("log4j.appender.logfile.File", "${catalina.home}/MaHairLog/MaHairLog_"+i.toString()+".log");
        prp.put("log4j.appender.logfile.MaxFileSize", "20480KB");
        prp.put("log4j.appender.logfile.layout", "org.apache.log4j.PatternLayout");
        prp.put("log4j.appender.logfile.layout.ConversionPattern", "%d %p [%c] - <%m>%n");

        prp.put("log4j.appender.console", "org.apache.log4j.ConsoleAppender");
        prp.put("log4j.appender.console.Target", "System.out");
        prp.put("log4j.appender.console.layout", "org.apache.log4j.PatternLayout");
        prp.put("log4j.appender.console.layout.ConversionPattern", "%d %p [%c] - <%m>%n");

        prp.put("log4j.logger.com.mchange.v2.resourcepool", "ERROR");
        prp.put("log4j.logger.com.mchange.v2", "INFO");
        prp.put("log4j.logger.com.mchange.v2.async", "ERROR");
        prp.put("log4j.logger.com.mchange.v2.c3p0.impl", "ERROR");
        prp.put("log4j.logger.com.mchange.v2.log", "ERROR");
        prp.put("log4j.logger.org.apache.struts.util", "ERROR");
        prp.put("log4j.logger.org.apache.struts.action", "ERROR");
        prp.put("log4j.logger.org.apache.catalina.core", "ERROR");
        prp.put("log4j.logger.org.apache.catalina.session", "ERROR");
        prp.put("log4j.logger.org.apache.commons.beanutils", "ERROR");
        prp.put("log4j.logger.org.apache.commons.digester", "ERROR");
        prp.put("log4j.logger.org.apache.jasper.compiler", "ERROR");
        prp.put("log4j.logger.org.apache.jasper.servlet", "ERROR");
        
        prp.put("log4j.logger.org.xu.swan.action.AccessServlet", "DEBUG");
        prp.put("log4j.logger.org.xu.dyve.action.schedule.ScheduleManager", "DEBUG");
        prp.put("log4j.logger.org.xu.swan.action.AppointmentReminderListener", "DEBUG");
        
        PropertyConfigurator.configure(prp);

    }

    public void contextDestroyed(ServletContextEvent event) {}

}
