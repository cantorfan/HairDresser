package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class Category {
    public static final String ID = "id";
    public static final String NAME = "name";
    public static final String DETAILS = "details";

    private int id;
    private String name; 
    private String details;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public static Category insertCategory(String name,String details){
        Category cate = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT category (" + NAME + ", " + DETAILS + ") VALUES (?,?)");
            pst.setString(1,name);
            pst.setString(2,details);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cate = new Category();
                cate.setName(name);
                cate.setDetails(details);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    cate.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cate;
    }

    public static Category updateCategory(int id, String name,String details){
        Category cate = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE category SET " + NAME + "=?, " + DETAILS + "=? WHERE " + ID + "=?");
            pst.setString(1,name);
            pst.setString(2,details);
            pst.setInt(3,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cate = new Category();
                cate.setId(id);
                cate.setName(name);
                cate.setDetails(details);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cate;
    }

    public static Category deleteCategory(int id){
        Category cate = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM category WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cate = new Category();
                cate.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cate;
    }

    public static Category findById(int id){
        Category cate = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + NAME + ", " + DETAILS + " FROM category WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cate = new Category();
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setDetails(rs.getString(3));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cate;
    }

    public static ArrayList findAll(){//List<Category> findAll(){
        ArrayList list = new ArrayList();//List<Category> list = new ArrayList<Category>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + DETAILS + " FROM category");
            while(rs.next()){
                Category cate = new Category();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setDetails(rs.getString(3));
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

    public static ArrayList findByFilter(String filter){//List<Category> findAll(){
        ArrayList list = new ArrayList();//List<Category> list = new ArrayList<Category>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + DETAILS + " FROM category "
                    + " WHERE " + filter);
            while(rs.next()){
                Category cate = new Category();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setDetails(rs.getString(3));
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

    public static int countByFilter(String filter){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM category WHERE " + filter);
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


    public static ArrayList findAll(int offset, int size){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + DETAILS + " FROM category LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                Category cate = new Category();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setDetails(rs.getString(3));
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

    public static HashMap findAllMap(){
        HashMap list = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + DETAILS + " FROM category");
            while(rs.next()){
                list.put(rs.getString(1),rs.getString(2));
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
