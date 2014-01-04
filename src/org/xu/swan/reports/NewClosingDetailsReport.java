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

public class NewClosingDetailsReport implements IReportGenerator {

    public NewClosingDetailsReport(String CUR_DATE)
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
            InputStream is;
            JasperReport CDReport;

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_srCashDrawerReport.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page1CashDrawerReport", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_DailyRevenuTop.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page1DailyRevenuTopReport", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_DaylyRevenuBody.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page1DailyRevenuBodyReport", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page1", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page2.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page2", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page3_DailyPaidOUT.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page3_DailyPaidOUT", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page3_DailyPaidIN.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page3_DailyPaidIN", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page3.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page3", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page4.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page4", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page_refund.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("pageRefund", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page_giftcard.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("pageGiftCard", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page5_service_analysis.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page5Service", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page5_service_analysis_pie.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page5ServicePie", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page5_product_analysis.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page5Product", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page5_product_analysis_pie.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page5ProductPie", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_DailyRevenuTop.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page5TopTotal", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page5.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page5", CDReport);

            is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page6.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Page6", CDReport);
            
            is = getClass().getResourceAsStream("/org/xu/reports/Title_report_logo_and_address.jrxml");
            CDReport = JasperCompileManager.compileReport(is);
            params.put("Title", CDReport);

        } catch (JRException ex) {
            ex.printStackTrace();
        }
        catch (Exception ex){

        }
        return params;
    }

    public JasperReport getReport() throws JRException {
        InputStream is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReportAll.jrxml");
        //InputStream is = getClass().getResourceAsStream("/org/xu/reports/NewClosingDetailsReport_page5.jrxml");
        return JasperCompileManager.compileReport(is);
    }

    public String getName()
    {
        return "NewClosingDetailsReport";
    }

    public void setProperties(Object[] prop) {
        _prop = prop;
    }
}