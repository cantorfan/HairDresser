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

/**
 * Created by IntelliJ IDEA.
 * User: Paha
 * Date: 18.03.2009
 * Time: 17:52:13
 * To change this template use File | Settings | File Templates.
 */

public class AppointmentReport implements IReportGenerator {

    public AppointmentReport(String FROM_DATE, String TO_DATE) {
        this.FROM_DATE = FROM_DATE;
        this.TO_DATE = TO_DATE;
    }
    String FROM_DATE;
    String TO_DATE;
    Object[] _prop;

    public String getErrorString() {
        return "";
    }


    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("FROM_DATE", FROM_DATE);
        params.put("TO_DATE", TO_DATE);
        return params;
    }

    public JasperReport getReport() throws JRException {
//        URL path = this.getClass().getClassLoader().getResource("");
//        System.out.println(path);
//        String p = path.toString();
//        p = p.replaceAll("%20"," ");
//        String reportSource = p.substring(6, p.length()-16) + "reports/AppointmentReport.jrxml";
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/AppointmentReport.jrxml");
   //        System.out.println(p.substring(6, p.length()-16));
        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "AppointmentReport";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}