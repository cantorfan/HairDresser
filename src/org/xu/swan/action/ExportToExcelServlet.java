package org.xu.swan.action;

import org.xu.swan.bean.Cashio;
import org.xu.swan.bean.Reconciliation;
import org.xu.swan.bean.WorkingtimeEmp;
import org.xu.swan.bean.*;
import org.xu.swan.util.DateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.util.Region;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;
import java.io.FileOutputStream;
import java.sql.Timestamp;
import java.sql.Date;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;

public class ExportToExcelServlet extends HttpServlet
{

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if(action.equals("exporttoexcelcustomer"))
        {
            String fname = request.getParameter("fname");
            String lname = request.getParameter("lname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String cellphone = request.getParameter("cellphone");
            HSSFWorkbook wb = null;
            try{
                wb = new HSSFWorkbook();
                HSSFSheet sheet = wb.createSheet("Customers");

                HSSFRow row = sheet.createRow((short) 0);
                HSSFCell cell = row.createCell((short) 0);
                cell.setCellValue("Manage customers");
                sheet.addMergedRegion(new Region(0,(short)0,0,(short)5));

                row = sheet.createRow((short) 1);
                row.createCell((short)0).setCellValue("First Name");
                row.createCell((short)1).setCellValue("Last Name");
                row.createCell((short)2).setCellValue("Email");
                row.createCell((short)3).setCellValue("Phone");
                row.createCell((short)4).setCellValue("Cell Phone");
                row.createCell((short)5).setCellValue("Work phone ext");

                ArrayList list;
                String filter =
                  Customer.FNAME + " LIKE '%" + fname + "%' AND " +
                  Customer.LNAME + " LIKE '%" + lname + "%' AND " +
                  Customer.EMAIL + " LIKE '%" + email + "%' AND " +
                  Customer.PHONE + " LIKE '%" + phone + "%' AND " +
                  Customer.CELL + " LIKE '%" + cellphone + "%' ";
                  list = Customer.findByFilter(filter);
                int current_row = 2;
                for(int i = 0; i<list.size(); i++)
                {
                    Customer cus = (Customer)list.get(i);
                    row = sheet.createRow((short) current_row+i);
                    row.createCell((short)0).setCellValue(cus.getFname());
                    row.createCell((short)1).setCellValue(cus.getLname());
                    row.createCell((short)2).setCellValue(cus.getEmail());
                    row.createCell((short)3).setCellValue(cus.getPhone());
                    row.createCell((short)4).setCellValue(cus.getCell_phone());
                    row.createCell((short)5).setCellValue(cus.getWork_phone_ext());
                }
//                FileOutputStream fileOut = new FileOutputStream("workbook.xls");
//                wb.write(fileOut);
//                fileOut.close();

                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment; filename=workbook.xls");
                wb.write(response.getOutputStream());
            }catch(Exception ex)
            {

            }
            wb = null;
        }
        else
        if(action.equals("exporttoexcelemployees"))
        {
            String fname = request.getParameter("fname");
            String lname = request.getParameter("lname");
            String email = request.getParameter("email");
            String login = request.getParameter("login");
            String schedule = request.getParameter("schedule");
            String p_shedule2 = "";
            HashMap users = User.findAllMap();
            if (!schedule.equals("allshedule"))
            {
                int shedule = Integer.parseInt(schedule);
                for (int i = 1; i<=7; i++)
                {
                    if (i == shedule){
                        p_shedule2 = p_shedule2 + 1;
                    }
                    else p_shedule2 = p_shedule2 + "_";
                }
            }
            HSSFWorkbook wb = null;
            try{
                wb = new HSSFWorkbook();
                HSSFSheet sheet = wb.createSheet("Employees");

                HSSFRow row = sheet.createRow((short) 0);
                HSSFCell cell = row.createCell((short) 0);
                cell.setCellValue("Manage Employees");
                sheet.addMergedRegion(new Region(0,(short)0,0,(short)4));

                row = sheet.createRow((short) 1);
                row.createCell((short)0).setCellValue("First Name");
                row.createCell((short)1).setCellValue("Last Name");
                row.createCell((short)2).setCellValue("Email");
                row.createCell((short)3).setCellValue("Login");
                row.createCell((short)4).setCellValue("Schedule");

                ArrayList list;
                String login_stmt = login.equals("alllogin") ? "" : " login_id='" + login +"' AND ";
                String schedule_stmt = schedule.equals("allshedule") ? "" : " schedule LIKE '" + p_shedule2+ "' AND ";
                String filter =
                  login_stmt +
                  schedule_stmt +
                  Employee.FNAME + " LIKE '%" + fname + "%' AND " +
                  Employee.LNAME + " LIKE '%" + lname + "%' AND " +
                  Employee.EMAIL + " LIKE '%" + email + "%';";
                  //Employee.LOGIN + " LIKE '%" + login_stmt + "%' AND " +
                  //Employee.SCH + " LIKE '%" + schedule_stmt + "%'";
                  list = Employee.findByFilter(filter);
                int current_row = 2;
                for(int i = 0; i<list.size(); i++)
                {
                    Employee emp = (Employee)list.get(i);
                    row = sheet.createRow((short) current_row+i);
                    row.createCell((short)0).setCellValue(emp.getFname());
                    row.createCell((short)1).setCellValue(emp.getLname());
                    row.createCell((short)2).setCellValue(emp.getEmail());
                    if(users.get(String.valueOf(emp.getLogin_id())) != null)
                        row.createCell((short)3).setCellValue(users.get(String.valueOf(emp.getLogin_id())).toString());
                    char[] arrCh = emp.getSchedule().toCharArray();
                    String strSh = "";
                    //MTWTFSS
                    if(arrCh.length == 7)
                    {
                        if(arrCh[0] == '1')
                            strSh = strSh + "M";
                        if(arrCh[1] == '1')
                            strSh = strSh + "T";
                        if(arrCh[2] == '1')
                            strSh = strSh + "W";
                        if(arrCh[3] == '1')
                            strSh = strSh + "T";
                        if(arrCh[4] == '1')
                            strSh = strSh + "F";
                        if(arrCh[5] == '1')
                            strSh = strSh + "S";
                        if(arrCh[6] == '1')
                            strSh = strSh + "S";
                    }

                    row.createCell((short)4).setCellValue(strSh);
                }
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment; filename=employee.xls");
                wb.write(response.getOutputStream());
            }catch(Exception ex)
            {

            }
            wb = null;
        } else if(action.equals("exporttoexcelinventory"))
        {
            HashMap vendor = Vendor.findAllMap();
            HashMap brand = Brand.findAllMap();
            HashMap category = Category.findAllMap();
            HSSFWorkbook wb = null;
            try{
                wb = new HSSFWorkbook();
                HSSFSheet sheet = wb.createSheet("Inventory");

                HSSFRow row = sheet.createRow((short) 0);
                HSSFCell cell = row.createCell((short) 0);
                cell.setCellValue("Manage Inventory");
                sheet.addMergedRegion(new Region(0,(short)0,0,(short)4));

                row = sheet.createRow((short) 1);
                row.createCell((short)0).setCellValue("Product Name");
                row.createCell((short)1).setCellValue("Vendor");
                row.createCell((short)2).setCellValue("Product Brand");
                row.createCell((short)3).setCellValue("Cost of goods");
                row.createCell((short)4).setCellValue("Retail Price");
                row.createCell((short)5).setCellValue("Category");
                row.createCell((short)6).setCellValue("Taxes");
                row.createCell((short)7).setCellValue("Quantity");
                row.createCell((short)8).setCellValue("SKU");
                row.createCell((short)9).setCellValue("Bar code");

                ArrayList list;
                list = Inventory.findAll();
                int current_row = 2;
                for(int i = 0; i<list.size(); i++)
                {
                    Inventory inv = (Inventory)list.get(i);
                    row = sheet.createRow((short) current_row+i);
                    row.createCell((short)0).setCellValue(inv.getName());
                    if(vendor.get(String.valueOf(inv.getVendor())) != null)
                        row.createCell((short)1).setCellValue(vendor.get(String.valueOf(inv.getVendor())).toString());
                    if(brand.get(String.valueOf(inv.getBrand())) != null)
                        row.createCell((short)2).setCellValue(brand.get(String.valueOf(inv.getBrand())).toString());
                    row.createCell((short)3).setCellValue(inv.getCost_price().setScale(2, BigDecimal.ROUND_HALF_DOWN).toString());
                    row.createCell((short)4).setCellValue(inv.getSale_price().setScale(2, BigDecimal.ROUND_HALF_DOWN).toString());
                    if(category.get(String.valueOf(inv.getCategory_id())) != null)
                        row.createCell((short)5).setCellValue(category.get(String.valueOf(inv.getCategory_id())).toString());
                    row.createCell((short)6).setCellValue(inv.getTaxes().setScale(2, BigDecimal.ROUND_HALF_DOWN).toString());
                    row.createCell((short)7).setCellValue(inv.getQty());
                    row.createCell((short)8).setCellValue(inv.getSku());
                    row.createCell((short)9).setCellValue(inv.getUpc());
                }
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment; filename=Inventory.xls");
                wb.write(response.getOutputStream());
            }catch(Exception ex)
            {

            }
            wb = null;
        }
        else
        if(action.equals("exporttoexcelappointment"))
        {
            String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
            String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");
            String p_category = StringUtils.defaultString(request.getParameter("category"), "allcategories");
            String p_service = StringUtils.defaultString(request.getParameter("service"), "allservices");
            String p_employee = StringUtils.defaultString(request.getParameter("employee"), "allemployees");


            String date_stmt = "";
            Boolean bFlag = false;
            if(!p_start_date.equals("") && !p_end_date.equals(""))
            {
                date_stmt = "(DATE(appt_date) BETWEEN DATE('" + p_start_date + "') AND DATE('" + p_end_date + "')) ";
                bFlag = true;
            }
            else
            {
                if(!p_start_date.equals("") && p_end_date.equals(""))
                {
                    date_stmt = "(DATE(appt_date) >= DATE('" + p_start_date + "')) ";
                    bFlag = true;
                }
                else
                {
                    if(p_start_date.equals("") && !p_end_date.equals(""))
                    {
                        date_stmt = "(DATE(appt_date) <= DATE('" + p_end_date + "')) ";
                        bFlag = true;
                    }
                }
            }
            String emp_stmt = "";
            if(!p_employee.equals("allemployees"))
            {
                emp_stmt = (bFlag?" AND ":"") + (Appointment.EMP + " = '" + p_employee + "' ");
                bFlag = true;
            }

            String serv_stmt = "";
            if(!p_service.equals("allservices"))
            {
                serv_stmt = (bFlag?" AND ":"") + (Appointment.SVC + " = '" + p_service + "' ");
                bFlag = true;
            }

            String cat_stmt = "";
            if(!p_category.equals("allcategories"))
            {
                cat_stmt = (bFlag?" AND ":"") + (Appointment.CATE + " = '" +  p_category + "' ");
            }
            String filter =
                    date_stmt +
                    emp_stmt +
                    serv_stmt +
                    cat_stmt;
            if(!filter.equals(""))
                filter = " where " + filter;
            ArrayList list = Appointment.findByFilter(filter);
           HSSFWorkbook wb = null;
            try{
                wb = new HSSFWorkbook();
                HSSFSheet sheet = wb.createSheet("Appointments");

                HSSFRow row = sheet.createRow((short) 0);
                HSSFCell cell = row.createCell((short) 0);
                cell.setCellValue("Manage Appointments");
                sheet.addMergedRegion(new Region(0,(short)0,0,(short)4));

                row = sheet.createRow((short) 1);
                row.createCell((short)0).setCellValue("Customer");
                row.createCell((short)1).setCellValue("Employee");
                row.createCell((short)2).setCellValue("Service");
                row.createCell((short)3).setCellValue("Price");
                row.createCell((short)4).setCellValue("Category Name");

                HashMap customers = Customer.findAllMap();
                HashMap employees = Employee.findAllMap();
                HashMap services = Service.findAllMap();
                HashMap categories = Category.findAllMap();

                int current_row = 2;
                for(int i = 0; i<list.size(); i++)
                {
                    Appointment app = (Appointment)list.get(i);
                    row = sheet.createRow((short) current_row+i);
                    if(customers.get(String.valueOf(app.getCustomer_id())) != null)
                        row.createCell((short)0).setCellValue(customers.get(String.valueOf(app.getCustomer_id())).toString());
                    if(employees.get(String.valueOf(app.getEmployee_id())) != null)
                        row.createCell((short)1).setCellValue(employees.get(String.valueOf(app.getEmployee_id())).toString());
                    if(services.get(String.valueOf(app.getService_id())) != null)
                        row.createCell((short)2).setCellValue(services.get(String.valueOf(app.getService_id())).toString());
                    if(app.getPrice() != null)                    
                        row.createCell((short)3).setCellValue(app.getPrice().toString());
                    if(categories.get(String.valueOf(app.getCategory_id())) != null)
                        row.createCell((short)4).setCellValue(categories.get(String.valueOf(app.getCategory_id())).toString());
                }
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment; filename=appointments.xls");
                wb.write(response.getOutputStream());
            }catch(Exception ex)
            {

            }
            wb = null;
        }
        else
        if(action.equals("exporttoexcelgiftcard"))
        {
            String code = StringUtils.defaultString(request.getParameter("code"), "");
            String p_date = StringUtils.defaultString(request.getParameter("date"), "");
            String amount = StringUtils.defaultString(request.getParameter("amount"), "");
            String startamount = StringUtils.defaultString(request.getParameter("startamount"), "");

            String filter = "";
            boolean flag = false;
            if(!code.equals(""))
            {
                filter = filter + Giftcard.CODE + " LIKE '%" + code + "%' " ;
                flag = true;
            }
            if(!p_date.equals(""))
            {
                if(flag)
                {
                    filter = filter + " and ";
                }
                filter = filter + "DATE(created)= DATE('" + p_date + "') " ;
                flag = true;
            }
            if(!amount.equals(""))
            {
                if(flag)
                {
                    filter = filter + " and ";
                }
                filter = filter + Giftcard.AMOUNT + " = " + amount + " " ;
                flag = true;
            }
            if(!startamount.equals(""))
            {
                if(flag)
                {
                    filter = filter + " and ";
                }
                filter = filter + Giftcard.STARTAMOUNT + " = " + startamount ;
            }

            ArrayList list = null;
            if(!filter.equals("")){
                list = Giftcard.findByFilter(filter);
            }
            else {
                list = Giftcard.findAll();
            }
            HSSFWorkbook wb = null;
            try{
                wb = new HSSFWorkbook();
                HSSFSheet sheet = wb.createSheet("Giftcard");

                HSSFRow row = sheet.createRow((short) 0);
                HSSFCell cell = row.createCell((short) 0);
                cell.setCellValue("View Giftcard");
                sheet.addMergedRegion(new Region(0,(short)0,0,(short)4));

                row = sheet.createRow((short) 1);
                row.createCell((short)0).setCellValue("Code");
                row.createCell((short)1).setCellValue("Created");
                row.createCell((short)2).setCellValue("Amount");
                row.createCell((short)3).setCellValue("Amount Remaining");

                int current_row = 2;
                BigDecimal remainAmntTotal = new BigDecimal(0);
                for(int i = 0; i<list.size(); i++)
                {
                    Giftcard gc = (Giftcard)list.get(i);
                    remainAmntTotal = remainAmntTotal.add(gc.getAmount());
                    row = sheet.createRow((short) current_row+i);
                    row.createCell((short)0).setCellValue(gc.getCode());
                    row.createCell((short)1).setCellValue(gc.getCreated().toString());
                    row.createCell((short)2).setCellValue("$ "+ gc.getStartamount().setScale(2, BigDecimal.ROUND_HALF_DOWN).toString());
                    row.createCell((short)3).setCellValue("$ "+ gc.getAmount().setScale(2, BigDecimal.ROUND_HALF_DOWN).toString());
                }
                row = sheet.createRow((short) current_row+list.size()+1);
                row.createCell((short)3).setCellValue("Amount Remaining total: $ "+ remainAmntTotal.setScale(2, BigDecimal.ROUND_HALF_DOWN).toString());
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment; filename=giftcards.xls");
                wb.write(response.getOutputStream());
            }catch(Exception ex)
            {

            }
            wb = null;
        }
        else
        if(action.equals("exporttoexceltransaction"))
        {
            String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
            String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");

            ArrayList list_trans = new ArrayList();
            String date_stmt = "";
            if(!p_start_date.equals("") && !p_end_date.equals(""))
            {
                date_stmt = "(DATE("+Reconciliation.CDT+") BETWEEN DATE('" + p_start_date + "') AND DATE('" + p_end_date + "')) ";
            }
            else
            {
                if(!p_start_date.equals("") && p_end_date.equals(""))
                {
                    date_stmt = "(DATE("+Reconciliation.CDT+") >= DATE('" + p_start_date + "')) ";
                }
                else
                {
                    if(p_start_date.equals("") && !p_end_date.equals(""))
                    {
                        date_stmt = "(DATE("+Reconciliation.CDT+") <= DATE('" + p_end_date + "')) ";
                    }
                }
            }

            String filter = date_stmt;
            if (!filter.equals(""))
                filter = " where " + filter;
            list_trans = Reconciliation.findByFilter(filter);            
            HSSFWorkbook wb = null;
            try{
                wb = new HSSFWorkbook();
                HSSFSheet sheet = wb.createSheet("Transaction");

                HSSFRow row = sheet.createRow((short) 0);
                HSSFCell cell = row.createCell((short) 0);
                cell.setCellValue("View Transaction");
                sheet.addMergedRegion(new Region(0,(short)0,0,(short)10));
                row = sheet.createRow((short) 1);
                row.createCell((short)0).setCellValue("Date");
                row.createCell((short)1).setCellValue("Trans #");
                row.createCell((short)2).setCellValue("Customer");
                row.createCell((short)3).setCellValue("Employee");
                row.createCell((short)4).setCellValue("Service");
                row.createCell((short)5).setCellValue("Product");
                row.createCell((short)6).setCellValue("QTY");
                row.createCell((short)7).setCellValue("Discount");
                row.createCell((short)8).setCellValue("Price");
                row.createCell((short)9).setCellValue("Payment");

                int current_row = 2;
                HashMap employees = Employee.findAllMap();
                HashMap customers = Customer.findAllMap();
                HashMap services = Service.findAllMap();
                HashMap products = Inventory.findAllMap();
                for(int i=0; i<list_trans.size(); i++)
                {
                    row = sheet.createRow((short) current_row+i);
                    Reconciliation tran = (Reconciliation) list_trans.get(i);
                    String status = "";
                    String date = "";
                    date = tran.getCreated_dt().toString();
                    switch (tran.getStatus())
                    {
                        case 3: status = "PAYOUT"; break;
                        case 5: status = "PAYIN"; break;
                    }

                    if ((tran.getStatus() == 3) || (tran.getStatus() == 5)){
                            row.createCell((short)0).setCellValue(date);
                            row.createCell((short)1).setCellValue(tran.getCode_transaction());
                            row.createCell((short)2).setCellValue(status);
                            row.createCell((short)8).setCellValue(tran.getTotal().setScale(2,BigDecimal.ROUND_HALF_DOWN).toString());
                            row.createCell((short)9).setCellValue(tran.getPayment());
                    }
                    else
                    {
                        ArrayList list_ticket = org.xu.swan.bean.Ticket.findTicketByLocCodeTrans(tran.getId_location(), tran.getCode_transaction());
                        for (int j = 0; j < list_ticket.size(); j++)
                        {
                            Ticket ticket = (Ticket)list_ticket.get(j);
                            row.createCell((short)0).setCellValue(date);
                            row.createCell((short)1).setCellValue(ticket.getCode_transaction());
                            if(customers.get(String.valueOf(tran.getId_customer()))!=null)
                                row.createCell((short)2).setCellValue(customers.get(String.valueOf(tran.getId_customer())).toString());
                            if(employees.get(String.valueOf(ticket.getEmployee_id()))!=null)
                                row.createCell((short)3).setCellValue(employees.get(String.valueOf(ticket.getEmployee_id())).toString());
                            if(services.get(String.valueOf(ticket.getService_id()))!=null)
                                row.createCell((short)4).setCellValue(services.get(String.valueOf(ticket.getService_id())).toString());                                
                            if(products.get(String.valueOf(ticket.getService_id()))!=null)
                                row.createCell((short)5).setCellValue(products.get(String.valueOf(ticket.getService_id())).toString());
                            row.createCell((short)6).setCellValue(ticket.getQty());
                            row.createCell((short)7).setCellValue(ticket.getDiscount() + "%");
                            row.createCell((short)8).setCellValue(ticket.getPrice().setScale(2,BigDecimal.ROUND_HALF_DOWN).toString());
                            row.createCell((short)9).setCellValue(tran.getPayment());
                        }
                    }
                }
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment; filename=transaction.xls");
                wb.write(response.getOutputStream());                
            }catch(Exception ex)
            {

            }
            wb = null;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}