package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.Date;
import java.sql.Time;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class EmailTemplate {
    public static final String ID = "id";
    public static final String LOC = "location_id";
    public static final String TYPE = "type";
    public static final String TEXT = "text";
    public static final String DESCR = "description";

    private int id;
    private int location_id;
    private int type;
    private String text;
    private String description;

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

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public static EmailTemplate insertTemplate(int loc,int type, String text,String description){
        EmailTemplate etp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT INTO emailstemplate (" + LOC + ","  + TYPE + ","  + TEXT + "," + DESCR + ") VALUES (?,?,?,?)");
            pst.setInt(1,loc);
            pst.setInt(2,type);
            pst.setString(3,text);
            pst.setString(4,description);

            int rows = pst.executeUpdate();
            if(rows>=0){
                etp = new EmailTemplate();
                etp.setLocation_id(loc);
                etp.setType(type);
                etp.setText(text);
                etp.setDescription(description);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    etp.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return etp;
    }

     public static EmailTemplate updateTemplate(int id, int loc,int type, String text,String description){
        EmailTemplate etp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE emailstemplate SET " + LOC + "=?,"  + TYPE + "=?,"  + TEXT+ "=?," + DESCR + "=? WHERE " + ID + "=?");
            pst.setInt(1,loc);
            pst.setInt(2,type);
            pst.setString(3,text);
            pst.setString(4,description);
            pst.setInt(5,id);

            int rows = pst.executeUpdate();
            if(rows>=0){
                etp = new EmailTemplate();
                etp.setId(id);
                etp.setLocation_id(loc);
                etp.setType(type);
                etp.setText(text);
                etp.setDescription(description);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return etp;
    }

    public static EmailTemplate deleteTemplate(int id){
        EmailTemplate etp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM emailstemplate WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                etp = new EmailTemplate();
                etp.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return etp;
    }

       public static EmailTemplate findById(int id){
        EmailTemplate etp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + LOC + ","  + TYPE + ","  + TEXT + "," + DESCR + " FROM emailstemplate WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                etp = new EmailTemplate();
                etp.setId(rs.getInt(1));
                etp.setLocation_id(rs.getInt(2));
                etp.setType(rs.getInt(3));
                etp.setText(rs.getString(4));
                etp.setDescription(rs.getString(5));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return etp;
    }


    public static EmailTemplate findByType(int type){
        EmailTemplate etp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + LOC + ","  + TYPE + ","  + TEXT + "," + DESCR + " FROM emailstemplate WHERE " + TYPE + "=?");
            pst.setInt(1,type);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                etp = new EmailTemplate();
                etp.setId(rs.getInt(1));
                etp.setLocation_id(rs.getInt(2));
                etp.setType(rs.getInt(3));
                etp.setText(rs.getString(4));
                etp.setDescription(rs.getString(5));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return etp;
    }
       public static ArrayList findAll(){
        ArrayList rez = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + LOC + ","  + TYPE + ","  + TEXT + "," + DESCR + " FROM emailstemplate ");
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                EmailTemplate etp = new EmailTemplate();
                etp.setId(rs.getInt(1));
                etp.setLocation_id(rs.getInt(2));
                etp.setType(rs.getInt(3));
                etp.setText(rs.getString(4));
                etp.setDescription(rs.getString(5));
                rez.add(etp);
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return rez;
    }
}
