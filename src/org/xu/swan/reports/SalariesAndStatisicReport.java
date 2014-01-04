package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;

import java.util.HashMap;
import java.util.Map;
import java.io.InputStream;

public class SalariesAndStatisicReport implements IReportGenerator {

    public SalariesAndStatisicReport(String START_DATE, String END_DATE, int EMPLOYEE_ID)
    {
        this.START_DATE = START_DATE;
        this.END_DATE = END_DATE;
        this.EMPLOYEE_ID = EMPLOYEE_ID;

    }
    String START_DATE, END_DATE;
    long EMPLOYEE_ID;
    Object[] _prop;

    public String getErrorString() {
        return "";
    }


    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("START_DATE", START_DATE);
        params.put("END_DATE", END_DATE);
        params.put("EMPLOYEE_ID", EMPLOYEE_ID);        
        return params;
    }

    public JasperReport getReport() throws JRException
    {
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/SalariesAndStatistic.jrxml");
        return JasperCompileManager.compileReport(is);
    }

    public String getName()
    {
        return "SalariesAndStatisticReport";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}