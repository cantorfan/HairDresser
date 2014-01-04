package org.xu.swan.reports;

import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

import java.util.Map;
import java.util.HashMap;
import java.io.InputStream;


public class DashboardReport_all implements IReportGenerator {
    protected Logger logger = LogManager.getLogger(getClass());
    public DashboardReport_all(String START_DATE,String END_DATE,String EMP_ID_LIST)
    {
        this.START_DATE = START_DATE;
        this.END_DATE = END_DATE;
        this.EMP_ID_LIST = EMP_ID_LIST;
    }
    String START_DATE;
    String END_DATE;
    String EMP_ID_LIST;
    Object[] _prop;


    public Map<String, Object> getParameters() {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("START_DATE", START_DATE);
        params.put("END_DATE", END_DATE);
        params.put("EMP_ID_LIST", EMP_ID_LIST);
        try
        {
            InputStream is;
            JasperReport CDReport;

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_miscellaneous_report.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("misc", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_giftcards_report.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("giftcards", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_revenue_report_1.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("revenue_1", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_revenue_report_2.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("revenue_2", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_revenue_report.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("revenue", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_byEmployee_report_3.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("byEmployee_3", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_byEmployee_report_2.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("byEmployee_2", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_byEmployee_report_1.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("byEmployee_1", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_byEmployee_report.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("byEmployee", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_byEmployee_report_all.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("byEmployeeAll", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_Summary_report_3.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Summary_3", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_Summary_report_2.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Summary_2", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_Summary_report_1.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Summary_1", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/Dashboard_Summary_report.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Summary", CDReport);
        } catch (JRException ex) {
            logger.error("DashboardReport_all getParametersError JRException " + ex.getMessage());
            ex.printStackTrace();
        }
        catch (Exception ex){
            logger.error("DashboardReport_all getParametersError Exception " + ex.getMessage());
        }
        return params;

    }

    public JasperReport getReport() throws JRException {
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/DashboardReportAll.jrxml");
        return JasperCompileManager.compileReport(is);
    }

    public String getName() {
        return "DashboardReport_all";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}
