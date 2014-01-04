package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.util.HashMap;
import java.util.Map;
import java.net.URL;
import java.io.*;

public class InvoiceReport implements IReportGenerator {

     String NAME_TRAN;
     Object[] _prop;
     public InvoiceReport(String NAME_TRAN)
     {
        this.NAME_TRAN = NAME_TRAN;
    }

    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
         params.put("NAME_TRAN", NAME_TRAN);

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
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/InvoiceReport.jrxml");

        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "InvoiceReport";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}
