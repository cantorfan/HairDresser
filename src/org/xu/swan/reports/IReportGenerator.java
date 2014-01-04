
package org.xu.swan.reports;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;

import java.util.Map;

public interface IReportGenerator {
    Map<String, Object> getParameters();

    JasperReport getReport() throws JRException;

    String getName();

    void setProperties(Object[] prop);

}
