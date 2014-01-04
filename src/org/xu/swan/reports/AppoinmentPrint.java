package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import javax.print.attribute.standard.DateTimeAtCompleted;
import java.util.HashMap;
import java.util.Map;
import java.net.URL;
import java.sql.Date;
import java.io.InputStream;


public class AppoinmentPrint implements IReportGenerator {

    public AppoinmentPrint(String START_DATE,String END_DATE, String EMPLOYEE, String SERVICE, String CATEGORY, String COUNT)
    {
        this.START_DATE = START_DATE;
        this.END_DATE = END_DATE;
        this.EMPLOYEE = EMPLOYEE;
        this.SERVICE = SERVICE;
        this.CATEGORY = CATEGORY;
        this.COUNT = COUNT;
    }
    String START_DATE;
    String END_DATE;
    String EMPLOYEE;
    String SERVICE;
    String CATEGORY;
    String COUNT;
    Object[] _prop;

    public String getErrorString() {
        return "";
    }


    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("START_DATE", START_DATE);
        params.put("END_DATE", END_DATE);
        params.put("EMPLOYEE", EMPLOYEE);
        params.put("SERVICE", SERVICE);        
        params.put("CATEGORY", CATEGORY);
        params.put("COUNT", COUNT);
        try
        {
            InputStream is = getClass().getResourceAsStream("/org/xu/reports/Title_report_logo_and_address.jrxml");
            JasperReport CDReport = JasperCompileManager.compileReport(is);
            params.put("Title", CDReport);
        } catch (JRException ex) {
            ex.printStackTrace();
        }
        catch (Exception ex){

        }
        return params;
    }

    public JasperReport getReport() throws JRException {
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/Admin_Appointment_Print.jrxml");
        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "AppointmentPrint";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}