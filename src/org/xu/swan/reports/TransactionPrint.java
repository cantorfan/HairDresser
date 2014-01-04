package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.util.HashMap;
import java.util.Map;
import java.io.InputStream;


public class TransactionPrint implements IReportGenerator {

    public TransactionPrint(String START_DATE,String END_DATE)
    {
        this.START_DATE = START_DATE;
        this.END_DATE = END_DATE;
    }
    String START_DATE;
    String END_DATE;
    Object[] _prop;

    public String getErrorString() {
        return "";
    }


    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("START_DATE", START_DATE);
        params.put("END_DATE", END_DATE);
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
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/Admin_Transaction_Print.jrxml");
        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "TransactionPrint";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}