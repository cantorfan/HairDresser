package org.xu.swan.reports;

import net.sf.jasperreports.engine.*;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.xu.swan.db.DBManager;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ReportGenerator {
    protected static Logger logger = LogManager.getLogger("ReportGenerator");
    public static String Generate(IReportGenerator generate, HttpServletResponse response, DBManager dbManager) {

        try {
            JasperReport jasperReport = generate.getReport();

            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, generate.getParameters(), dbManager.getCon());
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition","attachment; filename="+generate.getName()+".pdf");            
            JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());
        }
        catch (JRException ex) {
            logger.error("ReportGeneratorError JRException " + generate.getName() + ex.getMessage());
            ex.printStackTrace();
            return ex.getMessage();
        }
        catch (IOException ex){
            logger.error("ReportGeneratorError IOException " + generate.getName() + ex.getMessage());
            ex.printStackTrace();
            return ex.getMessage();
        }
        catch (Exception ex){
//            logger.error("ReportGeneratorError Exception " + generate.getName() + " ex.Message: " + ex.getMessage());
            logger.error("ReportGeneratorError Exception " + generate.getName() + " ex.ToString: " + ex.toString());
            ex.printStackTrace();
            return ex.getMessage();
        }
        finally {
        }
        return "";
    }

}
