package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.DateUtil;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class Trail {
    public static final String ID = "id";
    public static final String USER = "user_id";
    public static final String TABLE = "table_name";
    public static final String ACTION = "action";
    public static final String ROW = "row_id";
    public static final String NOTES = "notes";
    public static final String CDT = "created";

    private int id;
    private int user_id;
    private String table_name;
    private String action;
    private int row_id;
    private String notes;
    private Date created;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getTable_name() {
        return table_name;
    }

    public void setTable_name(String table_name) {
        this.table_name = table_name;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public int getRow_id() {
        return row_id;
    }

    public void setRow_id(int row_id) {
        this.row_id = row_id;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public static Trail log(int user, String table, String action, int row, String notes){
        Trail trail = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Date cdt = DateUtil.getSqlDate();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT trail (" + USER + ","  + TABLE + ","  + ACTION + "," + ROW + "," + NOTES + "," + CDT + ") VALUES (?,?,?,?,?,?)");
            pst.setInt(1,user);
            pst.setString(2,table);
            pst.setString(3,action);
            pst.setInt(4,row);
            pst.setString(5,notes);
            pst.setDate(6,cdt);
            int rows = pst.executeUpdate();
            if(rows>=0){
                trail = new Trail();
                trail.setUser_id(user);
                trail.setTable_name(table);
                trail.setAction(action);
                trail.setRow_id(row);
                trail.setNotes(notes);
                trail.setCreated(cdt);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    trail.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return trail;
    }

    public static ArrayList findByLocDate(int loc, Date dt, String table){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + USER + ","  + TABLE + ","  + ACTION + "," + ROW + "," + NOTES + "," + CDT + " FROM trail WHERE "
                + USER + " IN (SELECT l.id FROM login l JOIN employee e ON l.id=e.login_id WHERE e.location_id=?) AND DATE(" + CDT + ")=? AND " + TABLE + " LIKE ?");
            pst.setInt(1,loc);
            pst.setDate(2,dt);
            pst.setString(3,table);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Trail trail = new Trail();
                trail.setId(rs.getInt(1));
                trail.setUser_id(rs.getInt(2));
                trail.setTable_name(rs.getString(3));
                trail.setAction(rs.getString(4));
                trail.setRow_id(rs.getInt(5));
                trail.setNotes(rs.getString(6));
                trail.setCreated(rs.getDate(7));
                list.add(trail);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return list;
    }
}
