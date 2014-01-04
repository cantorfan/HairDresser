package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.*;
import java.util.ArrayList;

public class Inbox {
    public static final String ID = "id";
    public static final String LOC = "location_id";
    public static final String CUST = "customer_id";
    public static final String EMP = "employee_id";
    public static final String PROD = "product_id";
    public static final String SERV = "service_id";
    public static final String STATE = "state";
    public static final String TIME = "time";
    public static final String DATE = "date";
    public static final String APP_ID = "appointment_id";
    public static final String DELETED = "deleted";

    private int id;
    private int location_id;
    private int customer_id;
    private int employee_id;
    private int product_id;
    private int service_id;
    private int state;
    private Time time;
    private Date date;
    private int app_id;  // appointment_id
    private int deleted;

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

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getService_id() {
        return service_id;
    }

    public void setService_id(int service_id) {
        this.service_id = service_id;
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

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
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

    public static Inbox findById(int id){
        Inbox inb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST+ "," + EMP + ","
                    + PROD + "," + SERV + "," + STATE+  "," + TIME +  "," + DATE + "," + APP_ID + "," + DELETED + " FROM booking WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                inb = new Inbox();
                inb.setId(rs.getInt(1));
                inb.setLocation_id(rs.getInt(2));
                inb.setCustomer_id(rs.getInt(3));
                inb.setEmployee_id(rs.getInt(4));
                inb.setProduct_id(rs.getInt(5));
                inb.setService_id(rs.getInt(6));
                inb.setState(rs.getInt(7));
                inb.setTime(rs.getTime(8));
                inb.setDate(rs.getDate(9));
                inb.setApp_id(rs.getInt(10));
                inb.setDeleted(rs.getInt(11));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inb;
    }
    public static Inbox findByAppId(int id){
        Inbox inb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST+ "," + EMP + ","
                    + PROD + "," + SERV + "," + STATE+  "," + TIME +  "," + DATE + "," + APP_ID + "," + DELETED + " FROM booking WHERE " + APP_ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                inb = new Inbox();
                inb.setId(rs.getInt(1));
                inb.setLocation_id(rs.getInt(2));
                inb.setCustomer_id(rs.getInt(3));
                inb.setEmployee_id(rs.getInt(4));
                inb.setProduct_id(rs.getInt(5));
                inb.setService_id(rs.getInt(6));
                inb.setState(rs.getInt(7));
                inb.setTime(rs.getTime(8));
                inb.setDate(rs.getDate(9));
                inb.setApp_id(rs.getInt(10));
                inb.setDeleted(rs.getInt(11));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inb;
    }

    public static Inbox updateAfterReschedule(int id, Date date, Time time, int id_serv, int id_emp, int appointment_id){
        Inbox inb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("Update booking set " + EMP + "=?,"
                    + SERV + "=?," + TIME +  "=?," + DATE + "=?," + APP_ID + "=?  WHERE " + ID + "=?");
            pst.setInt(1,id_emp);
            pst.setInt(2,id_serv);
            pst.setTime(3,time);
            pst.setDate(4,date);
            pst.setInt(5,appointment_id);
            pst.setInt(6,id);
            int rows = pst.executeUpdate();
            if(rows>0){
                inb = new Inbox();
                inb.setId(id);
                inb.setEmployee_id(id_emp);
                inb.setService_id(id_serv);
                inb.setTime(time);
                inb.setDate(date);
                inb.setApp_id(appointment_id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inb;
    }
 
    public static Inbox updateStatus(int id,int status){
        Inbox inb = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("Update booking set " + STATE + "=?  WHERE " + ID + "=?");
            pst.setInt(1,status);
            pst.setInt(2,id);
            int rows = pst.executeUpdate();
            if(rows>0){
                inb = new Inbox();
                inb.setId(id);
                inb.setState(status);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inb;
    }

}
