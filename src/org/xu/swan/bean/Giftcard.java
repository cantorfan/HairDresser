package org.xu.swan.bean;

import org.apache.log4j.Logger;
import org.xu.swan.db.DBManager;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.math.BigDecimal;

public class Giftcard {
	private static Logger log = Logger.getLogger(Giftcard.class);
	
    public static final String ID = "id";
    public static final String CODE = "code";
    public static final String CDT = "created";
    public static final String AMOUNT = "amount";
    public static final String STARTAMOUNT = "startamount";
    public static final String PAYMENT = "payment";
    public static final String ID_CUST = "id_customer";

    private int id;
    private String code;
    private Date created;
    private BigDecimal amount;
    private BigDecimal startamount;
    private String payment;
    private int id_customer;


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public BigDecimal getStartamount() {
        return startamount;
    }

    public void setStartamount(BigDecimal startamount) {
        this.startamount = startamount;
    }

    public int getId_customer() {
        return id_customer;
    }

    public void setId_customer(int id_customer) {
        this.id_customer = id_customer;
    }

    public static Giftcard insertGiftcard(String code,BigDecimal amount, String payment, BigDecimal startamount, Date created_dt, int id_customer){
        Giftcard gift = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT giftcard (" + CODE + "," + CDT + "," + AMOUNT + ", " + PAYMENT + ", " + STARTAMOUNT + ", " + ID_CUST + ") VALUES (?,?,?,?,?,?)");
            pst.setString(1,code);
            pst.setDate(2,created_dt);
            pst.setBigDecimal(3,amount);
            pst.setString(4,payment);
            pst.setBigDecimal(5,startamount);
            pst.setInt(6,id_customer);
            int rows = pst.executeUpdate();
            if(rows>=0){
                gift = new Giftcard();
                gift.setCode(code);
                gift.setAmount(amount);
                gift.setPayment(payment);
                gift.setStartamount(startamount);
                gift.setId_customer(id_customer);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    gift.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return gift;
    }

    public static Giftcard updateGiftcard(String code,BigDecimal amount/*, String payment*/){
        Giftcard gift = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE giftcard SET " + AMOUNT + "=? WHERE " + CODE + "=?");
            pst.setBigDecimal(1,amount);
//            pst.setString(2,payment);
            pst.setString(2,code);
            int rows = pst.executeUpdate();
            if(rows>=0){
                gift = new Giftcard();
                gift.setCode(code);
                gift.setAmount(amount);
//                gift.setPayment(payment);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return gift;
    }

    public static Giftcard deleteGiftcard(String code){
        Giftcard gift = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM giftcard WHERE " + CODE + "=?");
            pst.setString(1,code);
            int rows = pst.executeUpdate();
            if(rows>=0){
                gift = new Giftcard();
                gift.setCode(code);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return gift;
    }

    public static Giftcard findByCode(String code){
        Giftcard gift = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + CODE + "," + CDT + ","+ AMOUNT + ", " + PAYMENT + ", " + STARTAMOUNT + ", " + ID_CUST + " FROM giftcard WHERE " + CODE + "=?");
            pst.setString(1,code);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                gift = new Giftcard();
                gift.setCode(rs.getString(1));
                gift.setCreated(rs.getDate(2));
                gift.setAmount(rs.getBigDecimal(3));
                gift.setPayment(rs.getString(4));
                gift.setStartamount(rs.getBigDecimal(5));
                gift.setId_customer(rs.getInt(6));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return gift;
    }

    public static ArrayList findAll(){//List<Giftcard> findAll(){
        ArrayList list = new ArrayList();//List<Giftcard> list = new ArrayList<Giftcard>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + CODE + "," + CDT + ","+ AMOUNT + ", " + PAYMENT + ", " + STARTAMOUNT + ", " + ID_CUST + " FROM giftcard");
            while(rs.next()){
                Giftcard gift = new Giftcard();
                list.add(gift);
                gift.setCode(rs.getString(1));
                gift.setCreated(rs.getDate(2));
                gift.setAmount(rs.getBigDecimal(3));
                gift.setPayment(rs.getString(4));
                gift.setStartamount(rs.getBigDecimal(5));
                gift.setId_customer(rs.getInt(6));
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
            ResultSet rs = st.executeQuery("SELECT " + CODE + "," + CDT + ","+ AMOUNT + ", " + PAYMENT + ", " + STARTAMOUNT + ", " + ID_CUST + " FROM giftcard LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                Giftcard gift = new Giftcard();
                list.add(gift);
                gift.setCode(rs.getString(1));
                gift.setCreated(rs.getDate(2));
                gift.setAmount(rs.getBigDecimal(3));
                gift.setPayment(rs.getString(4));
                gift.setStartamount(rs.getBigDecimal(5));
                gift.setId_customer(rs.getInt(6));
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
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + CODE + " FROM giftcard");
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


    public static int countAll(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM giftcard");
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

    public static ArrayList findByFilter(String filter)
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            String sql = "SELECT " + ID + "," + CODE + ", " + CDT +  ", " + AMOUNT + ", " + PAYMENT + ", " + STARTAMOUNT + ", " + ID_CUST + " FROM giftcard WHERE " + filter;
            log.debug(sql);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Giftcard card = new Giftcard();
                list.add(card);
                card.setId(rs.getInt(1));
                card.setCode(rs.getString(2));
                card.setCreated(rs.getDate(3));
                card.setAmount(rs.getBigDecimal(4));
                card.setPayment(rs.getString(5));
                card.setStartamount(rs.getBigDecimal(6));
                card.setId_customer(rs.getInt(7));
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

    public static ArrayList<Giftcard> findByCustomerName(String name, int from, int to){
    	ArrayList list = new ArrayList();
        DBManager dbm = null;
        if(name!=null)
        	name = name.trim();
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            String sql = "SELECT g." + ID + ", g." + CODE + ", g." + CDT +  ", g." + AMOUNT + ", g."+ PAYMENT + ", g." + STARTAMOUNT + ", g." + ID_CUST 
        			+ " FROM giftcard as g, customer as c "
        			+ "WHERE g." + ID_CUST+"= c.id and (c.fname like '%"+name+"%' or c.lname like '%"+name+"%')"
        			+ " limit "+from +", " +to;
            log.debug(sql);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Giftcard card = new Giftcard();
                list.add(card);
                card.setId(rs.getInt(1));
                card.setCode(rs.getString(2));
                card.setCreated(rs.getDate(3));
                card.setAmount(rs.getBigDecimal(4));
                card.setPayment(rs.getString(5));
                card.setStartamount(rs.getBigDecimal(6));
                card.setId_customer(rs.getInt(7));
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
    
    public static int countByFilter(String filter)
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM giftcard WHERE " + filter);
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
}
