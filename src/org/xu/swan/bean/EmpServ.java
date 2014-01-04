package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class EmpServ {
    public static final String ID = "id";
    public static final String SVC = "service_id";
    public static final String EMP = "employee_id";
    public static final String PRICE = "price";
    public static final String DURATION = "duration";
    public static final String TAX = "taxes";
    public static final String COMMISSION = "commission";

    private int id;
    private int service_id;
    private int employee_id;
    private BigDecimal price;
    private int duration;
    private BigDecimal taxes;
    private BigDecimal commission;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getService_id() {
        return service_id;
    }

    public void setService_id(int service_id) {
        this.service_id = service_id;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public BigDecimal getTaxes() {
        return taxes;
    }

    public void setTaxes(BigDecimal taxes) {
        this.taxes = taxes;
    }

    public BigDecimal getCommission() {
        return commission;
    }

    public void setCommission(BigDecimal commission) {
        this.commission = commission;
    }

    public static EmpServ insertEmpServ(int emp,int svc, BigDecimal price, int dura, BigDecimal tax, BigDecimal commission){
        EmpServ es = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT serv_emp (" + EMP + ", " + SVC + ", " + PRICE + ", "
                    + DURATION + ", " + TAX + ", " + COMMISSION + ") VALUES (?,?,?,?,?,?)");
            pst.setInt(1,emp);
            pst.setInt(2,svc);
            pst.setBigDecimal(3,price);
            pst.setInt(4,dura);
            pst.setBigDecimal(5,tax);
            pst.setBigDecimal(6,commission);
            int rows = pst.executeUpdate();
            if(rows>=0){
                es = new EmpServ();
                es.setEmployee_id(emp);
                es.setService_id(svc);
                es.setPrice(price);
                es.setDuration(dura);
                es.setTaxes(tax);
                es.setCommission(commission);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    es.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return es;
    }

    public static EmpServ updateEmpServ(int id, int emp,int svc, BigDecimal price, int dura, BigDecimal tax, BigDecimal commission){
        EmpServ es = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE serv_emp SET " + EMP + "=?, " + SVC + "=?, " + PRICE +"=?, "
                    + DURATION + "=?, " + TAX + "=?, " + COMMISSION + "=? WHERE " + ID + "=?");
            pst.setInt(1,emp);
            pst.setInt(2,svc);
            pst.setBigDecimal(3,price);
            pst.setInt(4,dura);
            pst.setBigDecimal(5,tax);
            pst.setBigDecimal(6,commission);
            pst.setInt(7,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                es = new EmpServ();
                es.setId(id);
                es.setEmployee_id(emp);
                es.setService_id(svc);
                es.setPrice(price);
                es.setDuration(dura);
                es.setTaxes(tax);
                es.setCommission(commission);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return es;
    }

    public static EmpServ deleteEmpServ(int id){
        EmpServ es = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM serv_emp WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                es = new EmpServ();
                es.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return es;
    }

    public static EmpServ findById(int id){
        EmpServ es = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + EMP + ", " + SVC + ", " + PRICE + ", "
                    + DURATION + ", " + TAX + ", " + COMMISSION + " FROM serv_emp WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                es = new EmpServ();
                es.setId(rs.getInt(1));
                es.setEmployee_id(rs.getInt(2));
                es.setService_id(rs.getInt(3));
                es.setPrice(rs.getBigDecimal(4));
                es.setDuration(rs.getInt(5));
                es.setTaxes(rs.getBigDecimal(6));
                es.setCommission(rs.getBigDecimal(7));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return es;
    }
    
    public static EmpServ findByEmployeeIdAndServiceID(int empId,int servId){
        EmpServ es = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + EMP + ", " + SVC + ", " + PRICE + ", "
                    + DURATION + ", " + TAX + ", " + COMMISSION + " FROM serv_emp WHERE " + EMP + "=? AND " + SVC + "=?" );
            pst.setInt(1,empId);
            pst.setInt(2,servId);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                es = new EmpServ();
                es.setId(rs.getInt(1));
                es.setEmployee_id(rs.getInt(2));
                es.setService_id(rs.getInt(3));
                es.setPrice(rs.getBigDecimal(4));
                es.setDuration(rs.getInt(5));
                es.setTaxes(rs.getBigDecimal(6));
                es.setCommission(rs.getBigDecimal(7));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return es;
    }

    public static ArrayList findByEmployeeId(int empId){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + EMP + ", " + SVC + ", " + PRICE + ", "
                    + DURATION + ", " + TAX + ", " + COMMISSION + " FROM serv_emp WHERE "+EMP+"=" + empId + " ORDER BY "+SVC+", "+ID);
            while(rs.next()){
                EmpServ es = new EmpServ();
                list.add(es);
                es.setId(rs.getInt(1));
                es.setEmployee_id(rs.getInt(2));
                es.setService_id(rs.getInt(3));
                es.setPrice(rs.getBigDecimal(4));
                es.setDuration(rs.getInt(5));
                es.setTaxes(rs.getBigDecimal(6));
                es.setCommission(rs.getBigDecimal(7));
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

    public static ArrayList findAll(){//List<EmpServ> findAll(){
        ArrayList list = new ArrayList();//List<EmpServ> list = new ArrayList<EmpServ>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + EMP + ", " + SVC + ", " + PRICE + ", "
                    + DURATION + ", " + TAX + ", " + COMMISSION + " FROM serv_emp ORDER BY "+SVC+", "+ID);
            while(rs.next()){
                EmpServ es = new EmpServ();
                list.add(es);
                es.setId(rs.getInt(1));
                es.setEmployee_id(rs.getInt(2));
                es.setService_id(rs.getInt(3));
                es.setPrice(rs.getBigDecimal(4));
                es.setDuration(rs.getInt(5));
                es.setTaxes(rs.getBigDecimal(6));
                es.setCommission(rs.getBigDecimal(7));
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

    public static ArrayList findAll(int offset, int size){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + EMP + ", " + SVC + ", " + PRICE + ", "
                    + DURATION + ", " + TAX + ", " + COMMISSION + " FROM serv_emp LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                EmpServ es = new EmpServ();
                list.add(es);
                es.setId(rs.getInt(1));
                es.setEmployee_id(rs.getInt(2));
                es.setService_id(rs.getInt(3));
                es.setPrice(rs.getBigDecimal(4));
                es.setDuration(rs.getInt(5));
                es.setTaxes(rs.getBigDecimal(6));
                es.setCommission(rs.getBigDecimal(7));
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
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + EMP + ", " + SVC + " FROM serv_emp");
            while(rs.next()){
                list.put(rs.getString(1),rs.getString(2) + " / " + rs.getString(3));
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
