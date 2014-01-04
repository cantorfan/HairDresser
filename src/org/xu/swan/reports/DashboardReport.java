package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.util.HashMap;
import java.util.Map;
import java.io.InputStream;


public class DashboardReport implements IReportGenerator {

    public DashboardReport(String START_DATE,String END_DATE,String p_service_id, String p_product_id, String service_name, String product_name, String flag, String type)
    {
        this.START_DATE = START_DATE;
        this.END_DATE = END_DATE;
        this.p_service_id = p_service_id;
        this.p_product_id = p_product_id;
        this.service_name = service_name;
        this.product_name = product_name;
        this.flag = flag;
        this.type = type;
    }
    String START_DATE;
    String END_DATE;
    String p_service_id;
    String p_product_id;
    String service_name;
    String product_name;
    String flag;
    String type;
    Object[] _prop;

    public String getErrorString() {
        return "";
    }


    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("START_DATE", START_DATE);
        params.put("END_DATE", END_DATE);
        params.put("p_service_id", p_service_id);
        params.put("p_product_id", p_product_id);
        params.put("service_name", service_name);
        params.put("product_name", product_name);
        params.put("flag", flag);
        params.put("type", type);
        try
        {
            InputStream is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_employee_report.jrxml");
            JasperReport CDReport = JasperCompileManager.compileReport(is);
            params.put("Dashboard_employee_report", CDReport);
        } catch (JRException ex) {
            ex.printStackTrace();
        }
        catch (Exception ex){

        }
        try
        {
            InputStream is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_fin_report.jrxml");
            JasperReport CDReport = JasperCompileManager.compileReport(is);
            params.put("Dashboard_fin_report", CDReport);
        } catch (JRException ex) {
            ex.printStackTrace();
        }
        catch (Exception ex){

        }
        return params;
    }

    public JasperReport getReport() throws JRException {
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_report.jrxml");
        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "Dashboard_report";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}