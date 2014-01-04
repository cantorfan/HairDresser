package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.util.HashMap;
import java.util.Map;
import java.net.URL;
import java.io.*;

/**
 * Created by IntelliJ IDEA.
 * User: Paha
 * Date: 18.03.2009
 * Time: 17:52:13
 * To change this template use File | Settings | File Templates.
 */

public class EmployeeReport implements IReportGenerator {

        Object[] _prop;

    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        return params;
    }

    public JasperReport getReport() throws JRException {
//        URL path = this.getClass().getClassLoader().getResource("");
//        System.out.println(path);
//        String p = path.toString();
//        p = p.replaceAll("%20"," ");
//         String reportSource = p.substring(6, p.length()-16) + "reports/EmployeeReport.jrxml";
//        System.out.println(p.substring(6, p.length()-16));
//        return JasperCompileManager.compileReport(reportSource);
//        System.out.println(this.getClass().getResource("EmployeeReport.jrxml").toString());

//        try{
//            PrintWriter pw = new PrintWriter(new OutputStreamWriter(new FileOutputStream("c:/path_test.txt"),"Cp866"));
//            pw.print(p);
//            pw.print(reportSource);
//            pw.close();
//        }catch(Exception e){
//
//        }
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/EmployeeReport.jrxml");

        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "EmployeeReport";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}
