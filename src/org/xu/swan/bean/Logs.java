package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.DateUtil;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class Logs {
    public static final String ID = "id";
    public static final String DATE = "date";
    public static final String EMPLOYEE_ID = "employeeId";
    public static final String DESCRIPTION = "eventDescription";

    private int id;
    private Date date;
    private int employee_id;
    private String desc;


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getDate() {
        return date;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public String getDesc() {
        return desc;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public static void log(int employee_id, String desc){
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Date cdt = DateUtil.getSqlDate();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT logs (" + DATE + ","  + EMPLOYEE_ID + "," + DESCRIPTION + ") VALUES (?,?,?)");
            pst.setDate(1,cdt);
            pst.setInt(2,employee_id);
            pst.setString(3,desc);

            pst.executeUpdate();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
    }
}
