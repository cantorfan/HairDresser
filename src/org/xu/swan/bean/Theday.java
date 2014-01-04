package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.math.BigDecimal;

public class Theday {
    public static final String ID = "id";
    public static final String CDT = "created_dt";
    public static final String CASH = "cash";
    public static final String CHQ = "cheque";
    public static final String CARD = "card";
    public static final String BEGIN = "beginning";
    public static final String CEND = "cash_end";
    public static final String CDRW = "cash_drawer";
    public static final String LOC = "location_id";
    public static final String ADJ = "ajustment";
    public static final String PIE = "putintheenvelop";
    public static final String AMEX = "amex";
    public static final String MASTERCARD = "mastercard";
    public static final String VISA = "visa";
    public static final String CREDITCARD = "creditcard";
    public static final String CASHIN = "cashin";
    public static final String CASHOUT = "cashout";
    public static final String TOTALCASH = "totalcash";
    public static final String ENDOFTHEDAY = "endoftheday";

    private int id;
    private Date created_dt;
    private BigDecimal cash;
    private BigDecimal cheque;
    private BigDecimal card;
    private BigDecimal beginning;
    private BigDecimal cash_end;
    private BigDecimal cash_drawer;
    private BigDecimal adjustment;
    private BigDecimal putinenv;
    private BigDecimal amex;
    private BigDecimal mastercard;
    private BigDecimal visa;
    private BigDecimal creditcard;
    private BigDecimal cashin;
    private BigDecimal cashout;
    private BigDecimal totalcash;
    private BigDecimal endoftheday;
    private int location_id;

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

    public BigDecimal getCash() {
        return cash;
    }

    public void setCash(BigDecimal cash) {
        this.cash = cash;
    }

    public BigDecimal getCheque() {
        return cheque;
    }

    public void setCheque(BigDecimal cheque) {
        this.cheque = cheque;
    }

    public BigDecimal getCard() {
        return card;
    }

    public void setCard(BigDecimal card) {
        this.card = card;
    }

    public BigDecimal getBeginning() {
        return beginning;
    }

    public void setBeginning(BigDecimal beginning) {
        this.beginning = beginning;
    }

    public BigDecimal getCash_end() {
        return cash_end;
    }

    public void setCash_end(BigDecimal cash_end) {
        this.cash_end = cash_end;
    }

    public BigDecimal getCash_drawer() {
        return cash_drawer;
    }

    public void setCash_drawer(BigDecimal cash_drawer) {
        this.cash_drawer = cash_drawer;
    }

    public int getLocation_id() {
        return location_id;
    }

    public void setLocation_id(int location_id) {
        this.location_id = location_id;
    }

    public BigDecimal getAdjustment() {
        return adjustment;
    }

    public void setAdjustment(BigDecimal adjustment) {
        this.adjustment = adjustment;
    }

    public BigDecimal getPutinenv() {
        return putinenv;
    }

    public void setPutinenv(BigDecimal putinenv) {
        this.putinenv = putinenv;
    }

    public BigDecimal getAmex() {
        return amex;
    }

    public void setAmex(BigDecimal amex) {
        this.amex = amex;
    }

    public BigDecimal getMastercard() {
        return mastercard;
    }

    public void setMastercard(BigDecimal mastercard) {
        this.mastercard = mastercard;
    }

    public BigDecimal getVisa() {
        return visa;
    }

    public void setVisa(BigDecimal visa) {
        this.visa = visa;
    }

    public BigDecimal getCreditcard() {
        return creditcard;
    }

    public void setCreditcard(BigDecimal creditcard) {
        this.creditcard = creditcard;
    }

    public BigDecimal getCashin() {
        return cashin;
    }

    public void setCashin(BigDecimal cashin) {
        this.cashin = cashin;
    }

    public BigDecimal getCashout() {
        return cashout;
    }

    public void setCashout(BigDecimal cashout) {
        this.cashout = cashout;
    }

    public BigDecimal getTotalcash() {
        return totalcash;
    }

    public void setTotalcash(BigDecimal totalcash) {
        this.totalcash = totalcash;
    }

    public BigDecimal getEndoftheday() {
        return endoftheday;
    }

    public void setEndoftheday(BigDecimal endoftheday) {
        this.endoftheday = endoftheday;
    }

    public static Theday insertTheday(Date dt, BigDecimal cash, BigDecimal chq, BigDecimal card, BigDecimal begin, BigDecimal end, BigDecimal drawer, int loc){
        Theday day = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT theday (" + CDT + ","  + CASH + "," + CHQ + ","
                     + CARD + "," + BEGIN + "," + CEND + "," + CDRW + "," + LOC + ") VALUES (?,?,?,?,?,?,?,?)");
            pst.setDate(1,dt);
            pst.setBigDecimal(2,cash);
            pst.setBigDecimal(3,chq);
            pst.setBigDecimal(4,card);
            pst.setBigDecimal(5,begin);
            pst.setBigDecimal(6,end);
            pst.setBigDecimal(7,drawer);
            pst.setInt(8, loc);
            int rows = pst.executeUpdate();
            if(rows>=0){
                day = new Theday();
                day.setCreated_dt(dt);
                day.setCash(cash);
                day.setCheque(chq);
                day.setCard(card);
                day.setBeginning(begin);
                day.setCash_end(end);
                day.setCash_drawer(drawer);
                day.setLocation_id(loc);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    day.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return day;
    }

    public static Theday updateTheday(int id, Date dt, BigDecimal cash, BigDecimal chq, BigDecimal card, BigDecimal begin, BigDecimal end, BigDecimal drawer, int loc, BigDecimal adj, BigDecimal pie, BigDecimal amex, BigDecimal mastercard, BigDecimal visa, BigDecimal creditcard, BigDecimal cashin, BigDecimal cashout, BigDecimal totalcash, BigDecimal endoftheday){
        Theday day = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE theday SET " + CDT + "=?,"  + CASH + "=?," + CHQ + "=?,"
                     + CARD + "=?," + BEGIN + "=?," + CEND + "=?," + CDRW + "=?," + LOC + "=?," + ADJ + "=?," + PIE + "=?," + AMEX + "=?," + MASTERCARD + "=?," + VISA + "=?," + CREDITCARD + "=?," + CASHIN + "=?," + CASHOUT + "=?," + TOTALCASH + "=?," + ENDOFTHEDAY + "=?" + " WHERE " + ID + "=?");
            pst.setDate(1,dt);
            pst.setBigDecimal(2,cash);
            pst.setBigDecimal(3,chq);
            pst.setBigDecimal(4,card);
            pst.setBigDecimal(5,begin);
            pst.setBigDecimal(6,end);
            pst.setBigDecimal(7,drawer);
            pst.setInt(8,loc);
            pst.setBigDecimal(9,adj);
            pst.setBigDecimal(10,pie);
            pst.setBigDecimal(11,amex);
            pst.setBigDecimal(12,mastercard);
            pst.setBigDecimal(13,visa);
            pst.setBigDecimal(14,creditcard);
            pst.setBigDecimal(15,cashin);
            pst.setBigDecimal(16,cashout);
            pst.setBigDecimal(17,totalcash);
            pst.setBigDecimal(18,endoftheday);
            pst.setInt(19,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                day = new Theday();
                day.setId(id);
                day.setCreated_dt(dt);
                day.setCash(cash);
                day.setCheque(chq);
                day.setCard(card);
                day.setBeginning(begin);
                day.setCash_end(end);
                day.setCash_drawer(drawer);
                day.setLocation_id(loc);
                day.setAdjustment(adj);
                day.setPutinenv(pie);
                day.setAmex(amex);
                day.setMastercard(mastercard);
                day.setVisa(visa);
                day.setCreditcard(creditcard);
                day.setCashin(cashin);
                day.setCashout(cashout);
                day.setTotalcash(totalcash);
                day.setEndoftheday(endoftheday);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return day;
    }

    public static Theday findByDate(int loc, Date dt){
        Theday day = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + CDT + ","  + CASH + "," + CHQ + ","
                     + CARD + "," + BEGIN + "," + CEND + "," + CDRW + "," + LOC + "," + ADJ + "," + PIE + " FROM theday WHERE " + LOC + "=? AND DATE(" + CDT + ")=?");
            pst.setInt(1, loc);
            pst.setDate(2,dt);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                day = new Theday();
                day.setId(rs.getInt(1));
                day.setCreated_dt(rs.getDate(2));
                day.setCash(rs.getBigDecimal(3));
                day.setCheque(rs.getBigDecimal(4));
                day.setCard(rs.getBigDecimal(5));
                day.setBeginning(rs.getBigDecimal(6));
                day.setCash_end(rs.getBigDecimal(7));
                day.setCash_drawer(rs.getBigDecimal(8));
                day.setLocation_id(rs.getInt(9));
                day.setAdjustment(rs.getBigDecimal(10));
                day.setPutinenv(rs.getBigDecimal(11));
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return day;
    }

    public static Theday findById(int id){
        Theday day = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + CDT + ","  + CASH + "," + CHQ + ","
                     + CARD + "," + BEGIN + "," + CEND + "," + CDRW + "," + LOC + " FROM theday WHERE DATE(" + ID + ")=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                day = new Theday();
                day.setId(rs.getInt(1));
                day.setCreated_dt(rs.getDate(2));
                day.setCash(rs.getBigDecimal(3));
                day.setCheque(rs.getBigDecimal(4));
                day.setCard(rs.getBigDecimal(5));
                day.setBeginning(rs.getBigDecimal(6));
                day.setCash_end(rs.getBigDecimal(7));
                day.setCash_drawer(rs.getBigDecimal(8));
                day.setLocation_id(rs.getInt(9));
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return day;
    }
}
