package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.util.HashMap;
import java.util.Map;
import java.net.URL;
import java.io.*;

public class TicketReport implements IReportGenerator {

     String NAME_TRAN;
     Object[] _prop;
     public TicketReport(String NAME_TRAN)
     {
        this.NAME_TRAN = NAME_TRAN;
    }

    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
         params.put("NAME_TRAN", NAME_TRAN);
        return params;
    }

    public JasperReport getReport() throws JRException {
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/TicketReport.jrxml");

        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "TicketReport";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}
