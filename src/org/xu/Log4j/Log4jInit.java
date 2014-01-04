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
        prp.put("log4j.rootLogger", "INFO, logfile");
        prp.put("log4j.appender.logfile", "org.apache.log4j.RollingFileAppender");
        prp.put("log4j.appender.logfile.File", "${catalina.home}/MaHairLog/MaHairLog_"+i.toString()+".log");
        prp.put("log4j.appender.logfile.MaxFileSize", "20480KB");
        prp.put("log4j.appender.logfile.layout", "org.apache.log4j.PatternLayout");
        prp.put("log4j.appender.logfile.layout.ConversionPattern", "%d %p [%c] - <%m>%n");

        PropertyConfigurator.configure(prp);

    }

    public void contextDestroyed(ServletContextEvent event) {}

}
