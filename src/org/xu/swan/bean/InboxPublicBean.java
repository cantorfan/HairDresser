package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.DateUtil;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;

public class InboxPublicBean {

    private int id;
    private int location_id;
    private String cust_name;
    private String emp_name; 
    private String phone; 
    private String email; 
    private String service;
    private String product; 
    private Date date;
    private Time time;
    private int state;
    private int cust_id;
    private int emp_id;
    private int svc_id;
    private int deleted;
    private int app_id;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getLocation_id() {
        return location_id;
    }

    public void setLocation_id(int location_id) {
        this.location_id = location_id;
    }

    public String getCust_name() {
        return cust_name;
    }

    public void setCust_name(String cust_name) {
        this.cust_name = cust_name;
    }

    public String getEmp_name() {
        return emp_name;
    }

    public void setEmp_name(String emp_name) {
        this.emp_name = emp_name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public Time getTime() {
        return time;
    }

    public void setTime(Time time) {
        this.time = time;
    }

    public int getCust_id() {
        return cust_id;
    }

    public void setCust_id(int cust_id) {
        this.cust_id = cust_id;
    }

    public int getEmp_id() {
        return emp_id;
    }

    public void setEmp_id(int emp_id) {
        this.emp_id = emp_id;
    }

    public int getSvc_id() {
        return svc_id;
    }

    public void setSvc_id(int svc_id) {
        this.svc_id = svc_id;
    }

    public int getDeleted() {
        return deleted;
    }

    public void setDeleted(int deleted) {
        this.deleted = deleted;
    }

    public int getApp_id() {
        return app_id;
    }

    public void setApp_id(int app_id) {
        this.app_id = app_id;
    }

    public static ArrayList getBookingRecords(String from_date, String to_date, int state){
        String filter = "";
        if (!from_date.equals("") && !to_date.equals("")){
            Date from = DateUtil.parseSqlDate(from_date);
            Date to = DateUtil.parseSqlDate(to_date);
            filter = "where DATE(bk.`date`) BETWEEN DATE('"+from+"') and DATE('"+to+"')";
        } else if (!from_date.equals("")){
            Date from = DateUtil.parseSqlDate(from_date);
            filter = "where DATE(bk.`date`) >= DATE('"+from+"')";
        } else if (!to_date.equals("")){
            Date to = DateUtil.parseSqlDate(to_date);
            filter = "where DATE(bk.`date`) <= DATE('"+to+"')";
        }
        if (filter.equals("")){
            if (state != -1) filter+="where bk.`state`="+state;
        }else {
            if (state != -1) filter+=" and bk.`state`="+state;
        }
        ArrayList list = new ArrayList();
                DBManager dbm = null;
        try
        {
            dbm = new DBManager();
            String strQuery = "select bk.id as id, bk.`location_id` as location_id, bk.`customer_id` as customer_id, bk.`employee_id` as employee_id, bk.`service_id` as service_id, CONCAT(cust.`fname`, \" \", cust.`lname`) as cust_name, CONCAT(emp.`fname`, \" \", emp.`lname`) as emp_name, cust.`phone` as phone, cust.`email` as email, serv.`name` as service, inv.`name` as product, bk.`date` as date, bk.`time` as time, bk.state as state, bk.`deleted` as deleted, bk.`appointment_id` as appointment_id  from `booking` bk\n" +
                    "left JOIN `customer` cust on cust.`id`=bk.`customer_id`\n" +
                    "LEFT JOIN `employee` emp on emp.`id`=bk.`employee_id`\n" +
                    "LEFT JOIN `service` serv on serv.id=bk.`service_id`\n" +
                    "LEFT JOIN `inventory` inv on inv.`id`=bk.`product_id`\n" +
                    filter + "\n"+
                    "ORDER BY date ASC, employee_id ASC";
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
            while (rs.next())
            {
                InboxPublicBean ipb= new InboxPublicBean();
                list.add(ipb);

                ipb.setId(rs.getInt("id"));
                ipb.setLocation_id(rs.getInt("location_id"));
                ipb.setCust_name(rs.getString("cust_name")!=null?rs.getString("cust_name"):"not found");
                ipb.setEmp_name(rs.getString("emp_name")!=null?rs.getString("emp_name"):"not found");
                ipb.setPhone(rs.getString("phone")!=null?rs.getString("phone"):"");
                ipb.setEmail(rs.getString("email")!=null?rs.getString("email"):"");
                ipb.setService(rs.getString("service")!=null?rs.getString("service"):"");
                ipb.setProduct(rs.getString("product")!=null?rs.getString("product"):"");
                ipb.setDate(rs.getDate("date"));
                ipb.setState(rs.getInt("state"));
                ipb.setTime(rs.getTime("time"));
                ipb.setCust_id(rs.getInt("customer_id"));
                ipb.setEmp_id(rs.getInt("employee_id"));
                ipb.setSvc_id(rs.getInt("service_id"));
                ipb.setDeleted(rs.getInt("deleted"));
                ipb.setApp_id(rs.getInt("appointment_id"));
            }
            rs.close();
            pst.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }
    public static InboxPublicBean getBookingById(int id){
        String filter = "";
        filter = "where bk.id='"+id+"'";
        DBManager dbm = null;
        InboxPublicBean ipb = null;
        try
        {
            dbm = new DBManager();
            String strQuery = "select bk.id as id, bk.`location_id` as location_id, bk.`customer_id` as customer_id, bk.`employee_id` as employee_id, bk.`service_id` as service_id, CONCAT(cust.`fname`, \" \", cust.`lname`) as cust_name, CONCAT(emp.`fname`, \" \", emp.`lname`) as emp_name, cust.`phone` as phone, cust.`email` as email, serv.`name` as service, inv.`name` as product, bk.`date` as date, bk.`time` as time, bk.state as state,bk.deleted as deleted, bk.appointment_id as appointment_id from `booking` bk\n" +
                    "left JOIN `customer` cust on cust.`id`=bk.`customer_id`\n" +
                    "LEFT JOIN `employee` emp on emp.`id`=bk.`employee_id`\n" +
                    "LEFT JOIN `service` serv on serv.id=bk.`service_id`\n" +
                    "LEFT JOIN `inventory` inv on inv.`id`=bk.`product_id`\n" +
                    filter + "\n"+
                    "ORDER BY date ASC";
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
            while (rs.next())
            {
                ipb= new InboxPublicBean();

                ipb.setId(rs.getInt("id"));
                ipb.setLocation_id(rs.getInt("location_id"));
                ipb.setCust_name(rs.getString("cust_name")!=null?rs.getString("cust_name"):"not found");
                ipb.setEmp_name(rs.getString("emp_name")!=null?rs.getString("emp_name"):"not found");
                ipb.setPhone(rs.getString("phone")!=null?rs.getString("phone"):"");
                ipb.setEmail(rs.getString("email")!=null?rs.getString("email"):"");
                ipb.setService(rs.getString("service")!=null?rs.getString("service"):"");
                ipb.setProduct(rs.getString("product")!=null?rs.getString("product"):"");
                ipb.setDate(rs.getDate("date"));
                ipb.setState(rs.getInt("state"));
                ipb.setTime(rs.getTime("time"));
                ipb.setCust_id(rs.getInt("customer_id"));
                ipb.setEmp_id(rs.getInt("employee_id"));
                ipb.setSvc_id(rs.getInt("service_id"));
                ipb.setDeleted(rs.getInt("deleted"));
                ipb.setApp_id(rs.getInt("appointment_id"));
            }
            rs.close();
            pst.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (dbm != null)
                dbm.close();
        }
        return ipb;
    }

    public static InboxPublicBean deleteBooking(int id){
        InboxPublicBean ipb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
//            PreparedStatement pst = dbm.getPreparedStatement("UPDATE booking SET deleted=1, state=1 WHERE id=?");
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM booking WHERE id=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ipb = new InboxPublicBean();
                ipb.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ipb;
    }

        public static InboxPublicBean updateSetStatusUnread(int id){
        InboxPublicBean ipb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE booking SET state=0 WHERE id=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ipb = new InboxPublicBean();
                ipb.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ipb;
    }
    
    public static InboxPublicBean updateSetStatusRead(int id){
        InboxPublicBean ipb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE booking SET state=1 WHERE id=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ipb = new InboxPublicBean();
                ipb.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ipb;
    }
    public static InboxPublicBean updateSetStatusReadWhenAcept(int id,int appointment_id){
        InboxPublicBean ipb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE booking SET state=1,appointment_id=? WHERE id=?");
            pst.setInt(1,appointment_id);
            pst.setInt(2,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ipb = new InboxPublicBean();
                ipb.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ipb;
    }
}
