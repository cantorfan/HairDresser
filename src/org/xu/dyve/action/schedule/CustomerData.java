///Copyright Dynamic Ventures, Inc. All rights reserved.
///
///http://www.dyve.com 
///http://www.dynamicventures.com
///
///This source code is offered by Dynamic Ventures, Inc. to its clients for non-exclusive use and is protected by copyright law and international treaties.
///

package org.xu.dyve.action.schedule;

import org.xu.swan.bean.*;
import org.xu.swan.db.DBManager;
import org.xu.swan.util.DateUtil;
import org.xu.swan.util.ResourcesManager;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang.StringUtils;


public class CustomerData extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(true);
        User user_ses = (User) session.getAttribute("user");
        ResourcesManager resx = new ResourcesManager();
        if (user_ses != null){
//            if (user_ses.getPermission() == Role.R_ADMIN){
//            }else{
        int idAppointment = -1;

        try {
            idAppointment = Integer.parseInt(request.getParameter("idappointment").replace("appoint_", ""));
        }
        catch (Exception ex) {
        }

        String responseXML = "";
        if (request.getParameter("HEADERCLICK") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
            int idEmployee = -1;
            try {
                idEmployee = Integer.parseInt(request.getParameter("idemployee"));
            } catch (Exception ex) {
            }
            response.sendRedirect("./admin/time_employee.jsp?action=time&id=" + idEmployee);
            return;
            }
        }
        if (request.getParameter("DBLCLICK") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
            Appointment ap = Appointment.findById(idAppointment);
            Customer cust = Customer.findById(ap.getCustomer_id());
            StringBuilder sb = new StringBuilder();
            sb.append("<?xml version=\"1.0\"?><root><customer");
            sb.append(" ID=\"").append(ap.getCustomer_id()).append('"');
            sb.append(" FNAME=\"").append(cust.getFname()).append('"');
            sb.append(" LNAME=\"").append(cust.getLname()).append('"');
            sb.append(" PHONE=\"").append(cust.getPhone()).append('"');
            sb.append(" CELLPHONE=\"").append(cust.getCell_phone()).append('"');
            sb.append(" EMAIL=\"").append(cust.getEmail()).append('"');
            //sb.append(" REQ=\"").append(cust.getReq()).append('"');
            sb.append(" REQ=\"").append(ap.getRequest()).append('"');
            sb.append(" EMP=\"").append(cust.getEmployee_id()).append('"');
            sb.append(" COMMENT=\"").append(ap.getComment()).append('"');
            sb.append(" CUSTCOMM=\"").append(cust.getComment()).append('"');
            sb.append(" REM=\"").append(cust.getRem()).append('"');
            sb.append(" REMDAYS=\"").append(cust.getRemdays()).append('"');
            sb.append(" APP_ID=\"").append(ap.getId()).append('"');
            sb.append(" EMP_ID=\"").append(cust.getEmployee_id()).append('"');
            sb.append("/></root>");
            responseXML = sb.toString();
            }
        } else if (request.getParameter("FAST") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
            ArrayList list = Customer.findByFilter(Customer.FNAME + "='" + Customer.WALKIN + "'");
            int customerId = 0;
            if (list.size() == 0) {
                int locationId = 0;
                try {
                    locationId = Integer.parseInt(request.getParameter("locationId"));
                } catch (Exception ex)
                {
                    ex.printStackTrace();
                }
                try {
//                    System.out.println("WALKIN");
                    customerId = Customer.insertCustomer(Customer.WALKIN, "", "", "", "", "", locationId, false, false, 0, "", 0, "", 0, "", "", "", "", null,null,0).getId();
                } catch (Exception ex)
                {
                    ex.printStackTrace();
                }
            } else {
                customerId = ((Customer) list.get(0)).getId();
            }
            responseXML = "<?xml version=\"1.0\"?><root><customer ID=\"" + customerId + "\" FNAME=\"" + Customer.WALKIN + "\"/></root>";
            }
        }

        if (request.getParameter("search") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
            String searchString = request.getParameter("search");
            int criteria = 0;

            try {
                criteria = Integer.parseInt(request.getParameter("type"));
            }
            catch (Exception ex) {
            }

            responseXML = getCustomerListXML(criteria, searchString);
            }
        }
        if (request.getParameter("UPDATE") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = getPhone(request.getParameter("phone"));
            String cellPhone = getPhone(request.getParameter("cellPhone"));
            String email = request.getParameter("email");
            String cust_comm = request.getParameter("custcomm");
            String cust_id = request.getParameter("cust_id");
            String comment = request.getParameter("comment");
            Boolean reminder = false;
            int reminderDays = 0;
            int idLocation = -1;
            int emp_id = 0;
            int pageNum = -1;
            Time st = null;
            Time et = null;
            int employee_id = 0;
            java.util.Date currentDate = null;
            try {
                idLocation = Integer.parseInt(request.getParameter("idlocation"));
            } catch (Exception ex) {
            }
            try {
                emp_id = Integer.parseInt(request.getParameter("empid"));
            } catch (Exception ex) {
            }
            try {
                currentDate = (new SimpleDateFormat("yyyy/MM/dd")).parse(request.getParameter("dateutc"));
            } catch (Exception ex) {
            }
            try {
                pageNum = Integer.parseInt(request.getParameter("pageNum"));
            } catch (Exception ex) {
            }
            Boolean req = false;
            int locationId = 0;
            try {
                locationId = Integer.parseInt(request.getParameter("locationId"));
            } catch (Exception ex) {/*System.out.println("error");*/}
            try {
                reminderDays = Integer.parseInt(request.getParameter("remdays"));
            }
            catch (Exception ex) {
            }
            if (request.getParameter("rem") != null && request.getParameter("rem").equals("true"))
                reminder = true;

            try {
                idAppointment = Integer.parseInt(request.getParameter("app_id").replace("appoint_", ""));
            } catch (Exception ex) {
            }
            if (idAppointment != -1) {
                Appointment ap = Appointment.findById(idAppointment);
                if (ap != null) {
                    ap.setComment(comment);
                    if (request.getParameter("req").equals("true"))
                        req = true;
                    Appointment a = Appointment.updateAppointment(ap.getId(), ap.getEmployee_id(), ap.getPrice(),
                            ap.getApp_dt(), ap.getSt_time(), ap.getEt_time(), ap.getComment(), req);
                    st = ap.getSt_time();
                    et = ap.getEt_time();
                    employee_id = ap.getEmployee_id();
                }
            }
            int customerId = 0;
            try {
                int custId = 0;
                try {
                    custId = Integer.parseInt(cust_id);
                } catch (Exception ex) {
                }
                customerId = Customer.updateCustomerFromQuickSchedule(custId, firstName, lastName, email, phone, cellPhone, "", locationId, req, reminder, reminderDays, cust_comm, emp_id, "", 0, "", "", "", "", null, null, 0).getId();
            }
            catch (Exception ex) {
            }

            responseXML = ScheduleManager.eventsArrayIfUpdate(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, employee_id, null, null, 0);
            //System.out.println(responseXML);
            }
        }
        if (request.getParameter("UPDATE_POPUP") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = getPhone(request.getParameter("phone"));
            String cellPhone = getPhone(request.getParameter("cellPhone"));
            String email = request.getParameter("email");
            String cust_id = request.getParameter("cust_id");
            String work_phone_ext = request.getParameter("work_phone_ext");
            String male_female = request.getParameter("male_female");
            String address = request.getParameter("address");
            String country = request.getParameter("country");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String zip_code = request.getParameter("zip_code");
            String b_date = StringUtils.defaultString(request.getParameter("b_date"), "");
            Boolean reminder = false;
            int reminderDays = 0;
            int emp_id = 0;

            try {
                emp_id = Integer.parseInt(request.getParameter("empid"));
            } catch (Exception ex) {
            }
            Boolean req = false;
            int locationId = 0;
            try {
                locationId = Integer.parseInt(request.getParameter("locationId"));
            } catch (Exception ex) {}
            int sex = 0;
            if(male_female.equals("male"))
                sex = 1;
            else if(male_female.equals("female"))
                sex = 2;
            DateFormat formatter ;
            Date dDate = Calendar.getInstance().getTime();
            formatter = new SimpleDateFormat("yyyy/MM/dd");
                try {
                    dDate = b_date.equals("")?null:(Date)formatter.parse(b_date);
                } catch (ParseException e) {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
                java.sql.Date sqlDate = dDate!=null?new java.sql.Date(dDate.getTime()):null;
            Customer customer = new Customer();
            try {
                int custId = 0;
                try {
                    custId = Integer.parseInt(cust_id);
                } catch (Exception ex) {
                }
                int countryId = 0;
                try {
                    countryId = Integer.parseInt(country);
                } catch (Exception ex) {
                }
                customer = Customer.updateCustomerFromQuickSchedulePopup(custId, firstName, lastName, email, phone, cellPhone,locationId, emp_id, work_phone_ext, sex, address, city, state, zip_code, sqlDate,countryId);
            }
            catch (Exception ex) {
            }
            responseXML = "<customer ID=\"" + customer.getId() + "\" " +
                    "FirstName=\"" + customer.getFname() + "\" " +
                    "LastName=\"" + customer.getLname() + "\" " +
                    "Phone=\"" + customer.getPhone() + "\" " +
                    "CellPhone=\"" + customer.getCell_phone() + "\" " +
                    "Email=\"" + customer.getEmail() + "\" />";
//            responseXML = ScheduleManager.eventsArrayIfUpdate(idLocation, DateUtil.toSqlDate(currentDate), pageNum, st, et, employee_id, null, null, 0);
            //System.out.println(responseXML);
            }
        }
        if (request.getParameter("SAVEEMPWT") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){

            String comment = request.getParameter("comment");
            java.util.Date startBreak = null;
            java.util.Date endBreak = null;
            java.util.Date currentDate = null;
            int employeeId = 0;
            try {
                currentDate = (new SimpleDateFormat("yyyy/MM/dd")).parse(request.getParameter("w_date"));
            } catch (Exception ex) {
            }
            try {
                startBreak = (new SimpleDateFormat("HH:mm")).parse(request.getParameter("bfrom"));
            } catch (Exception ex) {
            }
            try {
                endBreak = (new SimpleDateFormat("HH:mm")).parse(request.getParameter("bto"));
            } catch (Exception ex) {
            }
            try {
                employeeId = Integer.parseInt(request.getParameter("employeeId"));
            }
            catch (Exception ex) {
            }
            try {
                NotWorkingtimeEmp.insertWTEmp(employeeId, DateUtil.toSqlTime(startBreak), DateUtil.toSqlTime(endBreak), comment, DateUtil.toSqlDate(currentDate));
            } catch (Exception ex) {
            }
            responseXML = "<?xml version=\"1.0\"?><root><employee ID=\"" + employeeId + "\"/></root>";
            }
        }

        if (request.getParameter("SAVE") != null) {
            if (user_ses.getPermission() != Role.R_VIEW && user_ses.getPermission() != Role.R_SHD_CHK){
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = getPhone(request.getParameter("phone"));
            String cellPhone = getPhone(request.getParameter("cellPhone"));
            String email = request.getParameter("email");
            String cust_comm = request.getParameter("custcomm");
            Boolean req = false;
            Boolean reminder = false;
            int emp_id = 0;
            int locationId = 0;
            try {
                locationId = Integer.parseInt(request.getParameter("locationId"));
            }
            catch (Exception ex) {
            }
            try {
                emp_id = Integer.parseInt(request.getParameter("empid"));
            } catch (Exception ex) {
            }
            int reminderDays = 0;
            try {
                reminderDays = Integer.parseInt(request.getParameter("remdays"));
            }
            catch (Exception ex) {
            }
            if (request.getParameter("rem") != null && request.getParameter("rem").equals("true"))
                reminder = true;
            if (request.getParameter("req").equals("true"))
                req = true;
            int customerId = 0;
            try {
//                System.out.println("2 " + req.toString());
                customerId = Customer.insertCustomer(firstName, lastName, email, phone, cellPhone, "", locationId, req, reminder, reminderDays, cust_comm, emp_id, "", 0, "", "", "", "", null, null,0).getId();
            } catch (Exception ex) {
            }
            responseXML = "<?xml version=\"1.0\"?><root><customer ID=\"" + customerId + "\"/></root>";
        }
        }
        if (request.getParameter("getCustomer") != null) {
        	Customer customer = Customer.findById(Integer.parseInt(request.getParameter("getCustomer")));
        	String json = "{\"id\": \""+customer.getId()+"\", \"email\": \""+customer.getEmail()+"\"}";
        	 PrintWriter out = response.getWriter();
             out.write(json);
             out.close();
             return;
        }
        
        if (responseXML.length() == 0) {
            // System.out.println("lalala4");
            responseXML = "<?xml version=\"1.0\"?><root/>";
        }
        response.setHeader("content-type", "text/xml");
        PrintWriter out = response.getWriter();
        out.write(responseXML);
        out.close();
//        }
        } else {
            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("REDIRECT:error.jsp?ec=1");
        }
    }

    private String getPhone(final String phone) {
        String in = phone;
        if (in == null || in.length() == 0)
            return "";
        if (in.startsWith("1-"))
            in = in.replaceFirst("1-", "");
        in = in.replace("(", "");
        in = in.replace(")", "");
        in = in.replace("-", "");
        in = in.replace(" ", "");
        StringBuffer sb = new StringBuffer(15);
        try {
            sb.append("1-(");
            sb.append(in.substring(0, 3));
            sb.append(")");
            sb.append(in.substring(3, 6));
            sb.append("-");
            sb.append(in.substring(6, in.length()));
            if (sb.length() > 20)
                sb.delete(20, sb.length() - 1);
        } catch (Exception e) {
        }
        return sb.toString();
    }

    private String getCustomerListXML(int criteria, String searchString) {
        StringBuilder responseXML = new StringBuilder();
        responseXML.append("<?xml version=\"1.0\"?><root>");

        ArrayList<Customer> customerList = searchCustomers(criteria, searchString);

        for (int i = 0; i < customerList.size(); i++) {
            responseXML.append("<customer ID=\"" + customerList.get(i).getId() + "\" " +
                    "FirstName=\"" + customerList.get(i).getFname() + "\" " +
                    "LastName=\"" + customerList.get(i).getLname() + "\" " +
                    "Phone=\"" + customerList.get(i).getPhone() + "\" " +
                    "CellPhone=\"" + customerList.get(i).getCell_phone() + "\" " +
                    "Email=\"" + customerList.get(i).getEmail() + "\" " +
                    "Rem=\"" + customerList.get(i).getRem() + "\" " +
                    "RemDays=\"" + customerList.get(i).getRemdays() + "\" " +
                    "Comment=\"" + customerList.get(i).getComment() + "\" " +
                    "EmpId=\"" + customerList.get(i).getEmployee_id() + "\" " +
                    "Req=\"" + customerList.get(i).getReq() + "\"/>");
        }

        responseXML.append("</root>");
        return responseXML.toString();
    }

    private ArrayList<Customer> searchCustomers(int criteria, String searchString) {
        ArrayList<Customer> customerList = new ArrayList<Customer>();
        String searchColumn = "id";
        String oper = " = " + searchString;
        switch (criteria) {
            case 1:
                searchColumn = "LOWER(fname)";
                oper = " LIKE LOWER('%" + searchString + "%')";
                break;

            case 2:
                searchColumn = "LOWER(lname)";
                oper = " LIKE LOWER('%" + searchString + "%')";
                break;

            case 3:
                searchColumn = "REPLACE(LOWER(phone),'-','')";
                oper = " LIKE REPLACE(LOWER('%" + searchString + "%'),'-','')";
                break;

            case 4:
                searchColumn = "REPLACE(LOWER(cell_phone),'-','')";
                oper = " LIKE REPLACE(LOWER('%" + searchString + "%'),'-','')";
                break;

            case 5:
                searchColumn = "LOWER(email)";
                oper = " LIKE LOWER('%" + searchString + "%')";
                break;
            case 7:
                searchColumn = "LOWER(fname)";
                oper = " LIKE LOWER('%" + searchString + "%')";
                break;

            case 8:
                searchColumn = "LOWER(lname)";
                oper = " LIKE LOWER('%" + searchString + "%')";
                break;

            case 9:
                searchColumn = "REPLACE(LOWER(phone),'-','')";
                oper = " LIKE REPLACE(LOWER('%" + searchString + "%'),'-','')";
                break;

            case 10:
                searchColumn = "REPLACE(LOWER(cell_phone),'-','')";
                oper = " LIKE REPLACE(LOWER('%" + searchString + "%'),'-','')";
                break;

            case 11:
                searchColumn = "LOWER(email)";
                oper = " LIKE LOWER('%" + searchString + "%')";
                break;
        }

        DBManager dbManager = null;

        try {
            dbManager = new DBManager();
            Statement st = dbManager.getStatement();
            ResultSet rs = st.executeQuery("SELECT id, fname, lname, phone, cell_phone, email, req, reminder, remdays, comment, employee_id FROM customer WHERE " +
                    searchColumn + oper + " ORDER BY fname, lname");
            while (rs.next()) {
                Customer cust = new Customer();

                cust.setId(rs.getInt(1));
                cust.setFname(rs.getString(2));
                cust.setLname(rs.getString(3));
                cust.setPhone(rs.getString(4));
                cust.setCell_phone(rs.getString(5));
                cust.setEmail(rs.getString(6));
                cust.setReq(rs.getBoolean(7));
                cust.setRem(rs.getBoolean(8));
                cust.setRemdays(rs.getInt(9));
                cust.setComment(rs.getString(10));
                cust.setEmployee_id(rs.getInt(11));

                customerList.add(cust);
            }
            rs.close();
            st.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            if (dbManager != null) {
                dbManager.close();
            }
        }

        return customerList;
    }
}