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

public class ClosingDetailsReport implements IReportGenerator {

    public ClosingDetailsReport(String CUR_DATE)
    {
        this.CUR_DATE = CUR_DATE;
    }
    String CUR_DATE;
    Object[] _prop;

    public String getErrorString() {
        return "";
    }


    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("CUR_DATE", CUR_DATE);
        try
        {
            InputStream is = getClass().getResourceAsStream("/org/xu/reports/ClosingDetailsReport_open_cash.jrxml");
            JasperReport CDReport = JasperCompileManager.compileReport(is);
            params.put("OpenCashSubReport", CDReport);

            InputStream is2 = getClass().getResourceAsStream("/org/xu/reports/ClosingDetailsReport_cash_drawing.jrxml");
            JasperReport CDReport2 = JasperCompileManager.compileReport(is2);
            params.put("CashDrawingSubReport", CDReport2);

            InputStream is3 = getClass().getResourceAsStream("/org/xu/reports/ClosingDetailsReport_rec.jrxml");
            JasperReport CDReport3 = JasperCompileManager.compileReport(is3);
            params.put("RecSubReport", CDReport3);
        } catch (JRException ex) {
            ex.printStackTrace();
        }
        catch (Exception ex){

        }
        return params;
    }

    public JasperReport getReport() throws JRException {
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/ClosingDetailsReport.jrxml");
        return JasperCompileManager.compileReport(is);
    }

    public String getName()
    {
        return "ClosingDetailsReport";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}