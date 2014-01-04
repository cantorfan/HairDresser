package org.xu.dyve.action.schedule;

import org.xu.swan.bean.Category;
import org.xu.swan.bean.Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.math.BigDecimal;

public class ServiceServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (request.getParameter("optype") == null) {
            String serviceList = this.getServiceList();

            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(serviceList);
        }
    }

    private String getServiceList() {
        StringBuilder serviceJsObjects = new StringBuilder();

        ArrayList<Category> categoryList = (ArrayList<Category>) Category.findAll();
        for (int i = 0; i < categoryList.size(); i++) {
            if(!categoryList.get(i).getDetails().trim().equals("BREAK")){
                ArrayList<Service> serviceList = (ArrayList<Service>) Service.findAllByCategory(categoryList.get(i).getId());
                serviceJsObjects.append("{");
                serviceJsObjects.append("\"Category\":\"").append(categoryList.get(i).getDetails()).append("\"");
                serviceJsObjects.append("}");
                if (serviceList.size() != 0) {
                    serviceJsObjects.append(",");
                }
                for (int j = 0; j < serviceList.size(); j++) {
                    String[] shortNames = serviceList.get(j).getName().split(" ");
                    String shortName = "";
                    if (serviceList.get(j).getName().toLowerCase().equals("break")) {
                        shortName = serviceList.get(j).getCode();
                    } else {
                        shortName = serviceList.get(j).getCode();
                        if (serviceList.get(j).getPrice() != null) {
                            shortName += "  $" + serviceList.get(j).getPrice().setScale(0, BigDecimal.ROUND_HALF_DOWN);
                        }

                        serviceJsObjects.append(
                                "{" +
                                "\"Id\":\"" + serviceList.get(j).getId() + "\"," +
                                "\"Name\":\"" + shortName + "\"," +
                                "\"Price\":\"" + serviceList.get(j).getPrice() + "\"," +
                                "\"ToolTip\":\"" + serviceList.get(j).getName() + "\"," +
                                "\"Type\":\"" + serviceList.get(j).getType_id() + "\"" +
                                "}"
                        );
                        if (serviceList.size() - 1 != j) {
                            serviceJsObjects.append(",");
                        }
                    }
                }
                if (categoryList.size() - 1 != i) {
                    serviceJsObjects.append(",");
                }
            }
        }
        serviceJsObjects.append(",{");
        serviceJsObjects.append("\"Category\":\"").append("BREAK").append("\"");
        serviceJsObjects.append("}");
        serviceJsObjects.append(
                ",{" +
                "\"Id\":\"0\"," +
                "\"Name\":\"break\"," +
                "\"Price\":\"0\"," +
                "\"ToolTip\":\"break\"," +
                "\"Type\":\"0\"" +
                "}"
        );

        /*ArrayList<Service> serviceList = (ArrayList<Service>)Service.findAll();
		
		for(int i=0; i<serviceList.size(); i++)
		{			
			serviceJsObjects.append("" +
					"{" +
						"\"Id\":\""		+ serviceList.get(i).getId() + "\"," +
						"\"Name\":\""	+ serviceList.get(i).getName() + "\"," +
                        "\"ToolTip\":\""	+ serviceList.get(i).getName() + "\"" +
					"}"
			);
			
			if (serviceList.size() - 1 != i) {
				serviceJsObjects.append(",");
			}							
		}*/
        return serviceJsObjects.toString();
    }

}
