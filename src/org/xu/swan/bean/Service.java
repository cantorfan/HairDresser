package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.math.BigDecimal;

public class Service {
    public static final String ID = "id";
    public static final String NAME = "name";
    public static final String CATE = "category_id";
    public static final String TYPE = "type_id";
    public static final String PRICE = "price";
    public static final String DURATION = "duration";
    public static final String TAXES = "taxes";
    public static final String CODE = "code";

    private int id;
    private String name;
    private int category_id;
    private int type_id;
    private BigDecimal price;
    private int duration;
    private BigDecimal taxes;
    private String code;

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

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public int getType_id() {
        return type_id;
    }

    public void setType_id(int type_id) {
        this.type_id = type_id;
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLabel(){//TODO debug code
        String name = "test";
        for(int i=name.length();i<25;i++){
              name +="&nbsp";
        }
        String temp="";
        int status = 1;
        if(status == 1)temp="active&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";
        else temp="inactive&nbsp&nbsp&nbsp&nbsp";
        String revenue = "33.00";
        return name + temp + revenue;
    }

    public String getDetail(){//TODO debug code
        String name = "test";
        int status = 1;
        String revenue = "33.00";
        return name+"@"+revenue+"@"+(status==1?"active":"inactive");
    }

    public static Service insertService(String name, int cate, int type, BigDecimal price, int duration, BigDecimal taxes, String code){
        Service serv = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT service (" + NAME + ", " + CATE + ", " + TYPE +", " + PRICE + ", " + DURATION + ", " + TAXES + ", " + CODE + ") VALUES (?,?,?,?,?,?,?)");
            pst.setString(1,name);
            pst.setInt(2,cate);
            pst.setInt(3,type);
            pst.setBigDecimal(4,price);
            pst.setInt(5,duration);
            pst.setBigDecimal(6,taxes);
            pst.setString(7,code);
            int rows = pst.executeUpdate();
            if(rows>=0){
                serv = new Service();
                serv.setName(name);
                serv.setCategory_id(cate);
                serv.setType_id(type);
//                serv.setCode(code);
                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    serv.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return serv;
    }

    public static Service updateService(int id, String name, int cate, int type, BigDecimal price, int duration, BigDecimal taxes, String code){
        Service serv = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE service SET " + NAME + "=?, " + CATE + "=?, " + TYPE +"=?, " + PRICE + "=?, " + DURATION + "=?, " + TAXES + "=?, " + CODE + "=? WHERE " + ID + "=?");
            pst.setString(1,name);
            pst.setInt(2,cate);
            pst.setInt(3,type);
            pst.setBigDecimal(4,price);
            pst.setInt(5,duration);
            pst.setBigDecimal(6,taxes);
            pst.setString(7,code);
            pst.setInt(8,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                serv = new Service();
                serv.setId(id);
                serv.setName(name);
                serv.setCategory_id(cate);
                serv.setType_id(type);
//                serv.setCode(code);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return serv;
    }

    public static Service deleteService(int id){
        Service cate = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM service WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                cate = new Service();
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

    public static Service findById(int id){
        Service cate = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + NAME + ", " + CATE + ", " + TYPE + ", " + PRICE + ", " + DURATION + ", " + TAXES + ", " + CODE + " FROM service WHERE " + ID + "=? ORDER BY "+ NAME);
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cate = new Service();
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setCategory_id(rs.getInt(3));
                cate.setType_id(rs.getInt(4));
                cate.setPrice(rs.getBigDecimal(5));
                cate.setDuration(rs.getInt(6));
                cate.setTaxes(rs.getBigDecimal(7));
                cate.setCode(rs.getString(8));
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

    public static ArrayList findAll(){//List<Service> findAll(){
        ArrayList list = new ArrayList();//List<Service> list = new ArrayList<Service>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + CATE + ", " + TYPE + ", " + PRICE + ", " + DURATION + ", " + TAXES + ", " + CODE + " FROM service ORDER BY "+ NAME);
            while(rs.next()){
                Service cate = new Service();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setCategory_id(rs.getInt(3));
                cate.setType_id(rs.getInt(4));
                cate.setPrice(rs.getBigDecimal(5));
                cate.setDuration(rs.getInt(6));
                cate.setTaxes(rs.getBigDecimal(7));
                cate.setCode(rs.getString(8));            }
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

    public static ArrayList findAllByCategory(int category_id){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + NAME + ", " + CATE + ", " + TYPE + ", " + PRICE + ", " + DURATION + ", " + TAXES + ", " + CODE + " FROM service WHERE " + CATE + "=? ORDER BY "+ NAME);
            pst.setInt(1,category_id);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Service cate = new Service();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setCategory_id(rs.getInt(3));
                cate.setType_id(rs.getInt(4));
                cate.setPrice(rs.getBigDecimal(5));
                cate.setDuration(rs.getInt(6));
                cate.setTaxes(rs.getBigDecimal(7));
                cate.setCode(rs.getString(8));
            }
            rs.close();
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
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + CATE + ", " + TYPE + ", " + PRICE + ", " + DURATION + ", " + TAXES + ", " + CODE + " FROM service LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                Service cate = new Service();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setCategory_id(rs.getInt(3));
                cate.setType_id(rs.getInt(4));
                cate.setPrice(rs.getBigDecimal(5));
                cate.setDuration(rs.getInt(6));
                cate.setTaxes(rs.getBigDecimal(7));
                cate.setCode(rs.getString(8));
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
            ResultSet rs = st.executeQuery("SELECT count(*) FROM service"); //TODO FOUND_ROWS()
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


    public static ArrayList findByFilter(String filter){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + CATE + ", " + TYPE + ", " + PRICE + ", " + DURATION + ", " + TAXES + ", " + CODE + " FROM service WHERE " + filter); //TODO FOUND_ROWS()
            while(rs.next()){
                Service cate = new Service();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
                cate.setCategory_id(rs.getInt(3));
                cate.setType_id(rs.getInt(4));
                cate.setPrice(rs.getBigDecimal(5));
                cate.setDuration(rs.getInt(6));
                cate.setTaxes(rs.getBigDecimal(7));
                cate.setCode(rs.getString(8));
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
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM service WHERE " + filter); //TODO FOUND_ROWS()
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

    public static HashMap findAllMap(){
        HashMap list = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + " FROM service ORDER BY "+ NAME + " ASC");
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

    public static HashMap findAllMapByCode(){
        HashMap list = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + CODE + " FROM service ORDER BY "+ CODE + " ASC");
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

    public static ArrayList findAllArrOrderByCode(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + CODE + " FROM service ORDER BY "+ CODE + " ASC");
            while(rs.next()){
                list.add(rs.getString(1));
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

    public static ArrayList findBuyingSvc(String from_date, String to_date){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("select serv.`id`, serv.`name` from `reconciliation` rec\n" +
                    "join `ticket` tic on tic.`code_transaction` = rec.`code_transaction`\n" +
                    "join `service` serv on serv.`id` = tic.`service_id`\n" +
                    "where rec.status <> 1 and DATE(rec.`created_dt`) BETWEEN DATE('"+from_date+"') AND DATE('"+to_date+"')\n" +
                    "group by serv.`id` ORDER BY serv."+ NAME + " ASC");
            while(rs.next()){
                Service cate = new Service();
                list.add(cate);
                cate.setId(rs.getInt(1));
                cate.setName(rs.getString(2));
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

    public static ArrayList findAllArray(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + "," + CODE + " FROM service ORDER BY "+ CODE + " ASC");
            while(rs.next()){
                Service s = new Service();
                s.setId(rs.getInt(1));
                s.setName(rs.getString(2));
                s.setCode(rs.getString(3));
                list.add(s);
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
