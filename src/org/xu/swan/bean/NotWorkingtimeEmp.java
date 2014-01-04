package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by IntelliJ IDEA.
 * User: swatch
 * Date: Oct 23, 2008
 * Time: 12:43:13 PM
 * To change this template use File | Settings | File Templates.
 */
public class NotWorkingtimeEmp{
    public static final String ID = "id";
    public static final String EMP = "employee_id";
    public static final String FROM = "hfrom";
    public static final String TO = "hto";
    public static final String COMMENT = "comment";
    public static final String WDATE = "w_date";

    private int id;
    private int employee_id;
    private Time hfrom;
    private Time hto;
    private String comment;
    private Date w_date;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public Time getH_from() {
        return hfrom;
    }

    public void setH_from(Time hfrom) {
        this.hfrom = hfrom;
    }

    public Time getH_to() {
        return hto;
    }

    public void setH_to(Time hto) {
        this.hto = hto;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getW_date() {
        return w_date;
    }

    public void setW_date(Date w_date) {
        this.w_date = w_date;
    }

    public static NotWorkingtimeEmp insertWTEmp(int emp,Time hf, Time ht,String comment, Date w_date){
        NotWorkingtimeEmp ew = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT notworkingtime_emp (" + EMP + ", " + FROM + ", " + TO  + ", " + COMMENT    + ", " + WDATE + ") VALUES (?,?,?,?,?)");
            pst.setInt(1,emp);
            pst.setTime(2,hf);
            pst.setTime(3,ht);
            pst.setString(4, comment);
            pst.setDate(5, w_date);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ew = new NotWorkingtimeEmp();
                ew.setEmployee_id(emp);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setComment(comment);
                ew.setW_date(w_date);
                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    ew.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ew;
    }

    public static NotWorkingtimeEmp updateWTEmp(int id, int emp,Time hf, Time ht,String comment, Date w_date){
        NotWorkingtimeEmp ew = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE notworkingtime_emp SET " + EMP + "=?, " + FROM + "=?, " + TO  + "=?, " + COMMENT +  "=?, " + WDATE  +"=? WHERE " + ID + "=?");
            pst.setInt(1,emp);
            pst.setTime(2,hf);
            pst.setTime(3,ht);
            pst.setString(4, comment);
            pst.setDate(5, w_date);
            pst.setInt(6,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ew = new NotWorkingtimeEmp();
                ew.setId(id);
                ew.setEmployee_id(emp);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setComment(comment);
                ew.setW_date(w_date);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ew;
    }

    public static NotWorkingtimeEmp deleteWTEmp(int id){
        NotWorkingtimeEmp ew = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM notworkingtime_emp WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ew = new NotWorkingtimeEmp();
                ew.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ew;
    }

    public static NotWorkingtimeEmp findById(int id){
        NotWorkingtimeEmp ew = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + EMP + ", " + FROM + ", " + TO + ", " + COMMENT  + ", " + WDATE + " FROM notworkingtime_emp WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                ew = new NotWorkingtimeEmp();
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setComment(rs.getString(5));
                ew.setW_date(rs.getDate(6));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ew;
    }

    public static ArrayList findAllByEmployeeId(int empId){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + EMP + "," + FROM + "," + TO + ", " + COMMENT + ", " + WDATE + " FROM notworkingtime_emp WHERE " + EMP + "=? ORDER by " + WDATE + "," + FROM + "," + TO + " ASC");
            pst.setInt(1,empId);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                NotWorkingtimeEmp ew = new NotWorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setComment(rs.getString(5));
                ew.setW_date(rs.getDate(6));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findByFilterLimit(String filter, String limit){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + EMP + "," + FROM + "," + TO + ", " + COMMENT + ", " + WDATE + " FROM notworkingtime_emp " + filter + " ORDER by " + WDATE + "," + FROM + "," + TO + " ASC " + limit);
//            pst.setInt(1,empId);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                NotWorkingtimeEmp ew = new NotWorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setComment(rs.getString(5));
                ew.setW_date(rs.getDate(6));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return list;
    }

    public static int countByFilter(String filter){
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM notworkingtime_emp " + filter);

            while(rs.next()){
                cnt = rs.getInt(1);
            }
            rs.close();
            st.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cnt;
    }

    public static ArrayList findAllByEmployeeIdAndDate(int empId,Date w_date){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + EMP + "," + FROM + "," + TO + ", " + COMMENT
                    + ", " + WDATE + " FROM notworkingtime_emp WHERE notworkingtime_emp." + EMP + "=?" + " and DATE(notworkingtime_emp."+ WDATE + ")=DATE(?) ORDER by notworkingtime_emp." + FROM + " ASC");
            pst.setInt(1,empId);
            pst.setDate(2,w_date);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                NotWorkingtimeEmp ew = new NotWorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setComment(rs.getString(5));
                ew.setW_date(rs.getDate(6));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findAll(){//List<WorkingtimeEmp> findAll(){
        ArrayList list = new ArrayList();//List<WorkingtimeEmp> list = new ArrayList<WorkingtimeEmp>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + EMP + ", " + FROM + ", " + TO + ", " + COMMENT + ", " + WDATE + " FROM notworkingtime_emp");
            while(rs.next()){
                NotWorkingtimeEmp ew = new NotWorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setComment(rs.getString(5));
                ew.setW_date(rs.getDate(6));
            }
            rs.close();
            st.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return list;
    }
}
