package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class Brand {
    public static final String ID = "id";
    public static final String NAME = "name";
    public static final String VENDOR = "vendor_id";

    private int id;
    private String name;
    private int vendor_id;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String Name) {
        this.name = Name;
    }

    public int getVendor_id() {
        return vendor_id;
    }

    public void setVendor_id(int vendor_id) {
        this.vendor_id = vendor_id;
    }

    public static Brand insertBrand(String name, int vendor_id) {
        Brand cBrand = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT brand (" + NAME + ", " + VENDOR + ") VALUES (?,?)");
            pst.setString(1, name);
            pst.setInt(2, vendor_id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cBrand = new Brand();
                cBrand.setName(name);
                cBrand.setVendor_id(vendor_id);

                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next())
                    cBrand.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cBrand;
    }

    public static Brand updateBrand(int id, String name, int vendor_id)
    {
        Brand cBrand = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE brand SET " + NAME + "=?, " + VENDOR + "=? WHERE " + ID + "=?");
            pst.setString(1, name);
            pst.setInt(2, vendor_id);
            pst.setInt(3, id);

            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cBrand = new Brand();
                cBrand.setId(id);
                cBrand.setName(name);
                cBrand.setVendor_id(vendor_id);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cBrand;
    }

    public static Brand deleteBrand(int id) {
        Brand cBrand = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM brand WHERE " + ID + "=?");
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cBrand = new Brand();
                cBrand.setId(id);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cBrand;
    }

    public static Brand findById(int id) {
        Brand cBrand = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + NAME + "," + VENDOR + " FROM brand WHERE " + ID + "=?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                cBrand = new Brand();
                cBrand.setId(rs.getInt(1));
                cBrand.setName(rs.getString(2));
                cBrand.setVendor_id(rs.getInt(3));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cBrand;
    }

    public static ArrayList findAll()
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + VENDOR + " FROM brand ORDER BY " + NAME + "");
            while (rs.next()) {
                Brand cBrand = new Brand();
                list.add(cBrand);
                cBrand.setId(rs.getInt(1));
                cBrand.setName(rs.getString(2));
                cBrand.setVendor_id(rs.getInt(3));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findAll(int offset, int size) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + VENDOR + " FROM brand LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while (rs.next()) {
                Brand cBrand = new Brand();
                list.add(cBrand);
                cBrand.setId(rs.getInt(1));
                cBrand.setName(rs.getString(2));
                cBrand.setVendor_id(rs.getInt(3));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static int countAll(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) as cnt FROM brand"); //TODO FOUND_ROWS()
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

    public static ArrayList findByFilter(String filter) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + VENDOR + " FROM brand WHERE " + filter);
            while (rs.next()) {
                Brand cBrand = new Brand();
                list.add(cBrand);
                cBrand.setId(rs.getInt(1));
                cBrand.setName(rs.getString(2));
                cBrand.setVendor_id(rs.getInt(3));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static int countByFilter(String filter) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM brand WHERE " + filter);
            while(rs.next()){
                cnt = rs.getInt(1);
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cnt;
    }

    public static HashMap findAllMap() {
        HashMap list = new HashMap();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ", " + NAME + " FROM brand");
            while (rs.next()) {
                list.put(rs.getString(1), rs.getString(2));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }
}
