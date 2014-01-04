package org.xu.dyve.action.schedule;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import java.util.ArrayList;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;


import org.xu.swan.bean.Employee;
import org.xu.swan.util.DateUtil;

import com.sun.org.apache.xpath.internal.operations.Mod;

public class EmployeeList extends HttpServlet
{
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException 
	{
        int loc=1;
        int num = 0;
       Date d;
       String date="";
       int day;
			try{
				loc = Integer.parseInt(request.getParameter("locationId"));
				date= request.getParameter("Date");
			    num = Integer.parseInt(request.getParameter("pageNum"));
				
			}
			catch(Exception ex) { }
			
//		d= new Date(date);
		d= Calendar.getInstance().getTime();
		day=d.getDay()	;
		if(day==0)
		{
			day=day+7;
		}
        String responseXML = "";
		responseXML = getEmployeesListXML(loc,day,num, d);
		response.setHeader("content-type", "text/xml");
		PrintWriter out = response.getWriter();
		out.write(responseXML);
		out.close();
	}
	private String getEmployeesListXML(int loc,int day, int page_num, Date date)
	{
		StringBuilder responseXML = new StringBuilder();
		responseXML.append("<?xml version=\"1.0\"?><root>");
		ArrayList<Employee> list = (ArrayList<Employee>)Employee.findAllByLocAndDayAndDate(loc, day, page_num, DateUtil.toSqlDate(date));
        //System.out.println("List.size= " + list.size());
        for(int i=0;i<list.size();i++)
		{
			responseXML.append("<Employee FirstName=\""+ list.get(i).getFname()+
					"\" LastName=\""+list.get(i).getLname()+"\"/>");
		}
		responseXML.append("</root>");
		return responseXML.toString();
	}
	
}
