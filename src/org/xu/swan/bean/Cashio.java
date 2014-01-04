package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;

public class Cashio {
    public static final String ID = "id";
    public static final String CDT = "created_dt";
    public static final String IN = "cin";
    public static final String OUT = "cout";
    public static final String RECONCILATION_ID = "reconcilation_id";
    public static final String VENDOR = "vendor";
    public static final String DESCRIPTION = "description";

    private int id;
    private Date created_dt;
    private BigDecimal cin;
    private BigDecimal cout;
    private int reconcilationID;
    private String vendor;
    private String description;


    public int getReconcilationID() {
        return reconcilationID;
    }

    public void setReconcilationID(int reconcilationID) {
        this.reconcilationID = reconcilationID;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getCreated_dt() {
        return created_dt;
    }

    public void setCreated_dt(Date created_dt) {
        this.created_dt = created_dt;
    }

    public BigDecimal getCin() {
        return cin;
    }

    public void setCin(BigDecimal cin) {
        this.cin = cin;
    }

    public BigDecimal getCout() {
        return cout;
    }

    public void setCout(BigDecimal cout) {
        this.cout = cout;
    }

    public static Cashio insertCashio(Date cdt, BigDecimal cin, BigDecimal cout){
        Cashio cash = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT cashio (" + CDT + ", " + IN + "," + OUT + ") VALUES (?,?,?)");
            pst.setDate(1,cdt);
            pst.setBigDecimal(2,cin);
            pst.setBigDecimal(3,cout);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cash = new Cashio();
                cash.setCreated_dt(cdt);
                cash.setCin(cin);
                cash.setCout(cout);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    cash.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cash;
    }

    public static Cashio insertCashio2(Date cdt, BigDecimal cin, BigDecimal cout,
                                       int reconcilation_id, String vendor, String description){
        Cashio cash = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "INSERT cashio (" + CDT + ", " + IN + "," + OUT +
                            "," + RECONCILATION_ID + "," + VENDOR + "," + DESCRIPTION +
                            ") VALUES (?,?,?,?,?,?)");
            pst.setDate(1,cdt);
            pst.setBigDecimal(2,cin);
            pst.setBigDecimal(3,cout);
            pst.setInt(4, reconcilation_id);
            pst.setString(5, vendor);
            pst.setString(6, description);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cash = new Cashio();
                cash.setCreated_dt(cdt);
                cash.setCin(cin);
                cash.setCout(cout);
                cash.setReconcilationID(reconcilation_id);
                cash.setVendor(vendor);
                cash.setDescription(description);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    cash.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cash;
    }


    public static Cashio updateCashio(int id, Date cdt, BigDecimal cin, BigDecimal cout){
        Cashio cash = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE cashio SET " + CDT + "=?, " + IN + "=?," + OUT + "=? WHERE " + ID + "=?");
            pst.setDate(1,cdt);
            pst.setBigDecimal(2,cin);
            pst.setBigDecimal(3,cout);
            pst.setInt(4,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cash = new Cashio();
                cash.setId(id);
                cash.setCreated_dt(cdt);
                cash.setCin(cin);
                cash.setCout(cout);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cash;
    }

    public static Cashio updateCashioByRecID(int id, Date cdt, BigDecimal cin, BigDecimal cout, String vendor, String description)
    {
        Cashio cash = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE cashio SET " + CDT + "=?, " + IN + "=?," + OUT + "=?," + VENDOR + "=?," + DESCRIPTION + "=?" + " WHERE " + RECONCILATION_ID + "=?");
            pst.setDate(1,cdt);
            pst.setBigDecimal(2,cin);
            pst.setBigDecimal(3,cout);
            pst.setString(4,vendor);
            pst.setString(5,description);
            pst.setInt(6,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cash = new Cashio();
                cash.setId(id);
                cash.setCreated_dt(cdt);
                cash.setCin(cin);
                cash.setCout(cout);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cash;
    }

    public static Cashio deleteCashio(int id){
        Cashio cash = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM cashio WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cash = new Cashio();
                cash.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cash;
    }

    public static Cashio findById(int id){
        Cashio cash = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + CDT + ", " + IN + "," + OUT + "," + VENDOR + " FROM cashio WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cash = new Cashio();
                cash.setId(rs.getInt(1));
                cash.setCreated_dt(rs.getDate(2));
                cash.setCin(rs.getBigDecimal(3));
                cash.setCout(rs.getBigDecimal(4));
                cash.setVendor(rs.getString(5));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cash;
    }

    public static Cashio findByReconciliationId(int rec_id){
        Cashio cash = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + CDT + ", " + IN + "," + OUT + "," + VENDOR + " FROM cashio WHERE " + RECONCILATION_ID + "=?");
            pst.setInt(1,rec_id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cash = new Cashio();
                cash.setId(rs.getInt(1));
                cash.setCreated_dt(rs.getDate(2));
                cash.setCin(rs.getBigDecimal(3));
                cash.setCout(rs.getBigDecimal(4));
                cash.setVendor(rs.getString(5));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return cash;
    }

    public static ArrayList findAll(){//List<Cashio> findAll(){
        ArrayList list = new ArrayList();//List<Cashio> list = new ArrayList<Cashio>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + CDT + ", " + IN + "," + OUT + " FROM cashio");
            while(rs.next()){
                Cashio cash = new Cashio();
                list.add(cash);
                cash.setId(rs.getInt(1));
                cash.setCreated_dt(rs.getDate(2));
                cash.setCin(rs.getBigDecimal(3));
                cash.setCout(rs.getBigDecimal(4));
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

    public static int countAll(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM cashio");
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
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + CDT + ", " + IN + "," + OUT + " FROM cashio LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                Cashio cash = new Cashio();
                list.add(cash);
                cash.setId(rs.getInt(1));
                cash.setCreated_dt(rs.getDate(2));
                cash.setCin(rs.getBigDecimal(3));
                cash.setCout(rs.getBigDecimal(4));
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

    public static ArrayList findByDate(String start_date, String end_date, int offset, int size){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            int i = 0;
            String query = "SELECT " + ID + "," + CDT + ", " + IN + "," + OUT + " FROM cashio ";
            if(!start_date.equals("") && !end_date.equals(""))
            {
                query = query + "where DATE(created_dt) BETWEEN DATE(?) and DATE(?)";
                i = 2;
            }
            query = query + " LIMIT ?,?" ;
            PreparedStatement pst = dbm.getPreparedStatement(query);
            if(i > 0)
            {
                pst.setString(1,start_date);
                pst.setString(2,end_date);
            }
            pst.setInt(1+i,offset);
            pst.setInt(2+i,size);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Cashio cash = new Cashio();
                list.add(cash);
                cash.setId(rs.getInt(1));
                cash.setCreated_dt(rs.getDate(2));
                cash.setCin(rs.getBigDecimal(3));
                cash.setCout(rs.getBigDecimal(4));
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
