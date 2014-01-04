package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.ActionUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.sql.*;
import java.math.BigDecimal;

public class CashDrawing {
    public static final String TABLE = "cash_drawing";
    public static final String ID = "id";
    public static final String EMPLOYEE_ID = "employeeID";
    public static final String DATE = "date";
    public static final String PENNIES = "pennies";
    public static final String NICKELS = "nickels";
    public static final String DIMES = "dimes";
    public static final String QUARTERS = "quarters";
    public static final String HALF_DOLLARS = "half_dollars";
    public static final String DOLLARS = "dollars";
    public static final String SINGLES = "singles";
    public static final String FIVES = "fives";
    public static final String TENS = "tens";
    public static final String TWENTIES = "twenties";
    public static final String FIFTIES = "fifties";
    public static final String HUNDREDS = "hundreds";
    public static final String OPEN_CLOSE = "openClose";
    public static final String LOC = "location_id";
    public static final String AMEX = "amex";
    public static final String VISA = "visa";
    public static final String MASTERCARD = "mastercard";
    public static final String CHEQUE = "cheque";
    public static final String CASH = "cash";
    public static final String GIFT = "gift";
    public static final String CARD_OVER = "card_over";
    public static final String CHEQUE_OVER = "cheque_over";
    public static final String CASH_OVER = "cash_over";
    public static final String GIFT_OVER = "gift_over";
    public static final String CARD_SHORT = "card_short";
    public static final String CHEQUE_SHORT = "cheque_short";
    public static final String CASH_SHORT = "cash_short";
    public static final String GIFT_SHORT = "gift_short";
    public static final String CREDITCARD = "creditcard";
    public static final String USERID = "userID";
    public static final String USERIP = "userIP";

    private int id;
    private int employeeID;
    private Timestamp date;
    private int pennies;
    private int nickels;
    private int dimes;
    private int quarters;
    private int half_dollars;
    private int dollars;
    private int singles;
    private int fives;
    private int tens;
    private int twenties;
    private int fifties;
    private int hundreds;
    private int openClose;
    private int locationID;
    private BigDecimal amex;
    private BigDecimal visa;
    private BigDecimal mastercard;
    private BigDecimal cheque;
    private BigDecimal cash;
    private BigDecimal gift;
    private BigDecimal card_over;
    private BigDecimal cheque_over;
    private BigDecimal cash_over;
    private BigDecimal gift_over;
    private BigDecimal card_short;
    private BigDecimal cheque_short;
    private BigDecimal cash_short;
    private BigDecimal gift_short;
    private BigDecimal creditcard;
    private int userID;
    private String userIP;

    public int getLocationID() {
        return locationID;
    }

    public void setLocationID(int locationID) {
        this.locationID = locationID;
    }

    public int getOpenClose() {
        return openClose;
    }

    public void setOpenClose(int openClose) {
        this.openClose = openClose;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(int employeeID) {
        this.employeeID = employeeID;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public int getPennies() {
        return pennies;
    }

    public void setPennies(int pennies) {
        this.pennies = pennies;
    }

    public int getNickels() {
        return nickels;
    }

    public void setNickels(int nickels) {
        this.nickels = nickels;
    }

    public int getDimes() {
        return dimes;
    }

    public void setDimes(int dimes) {
        this.dimes = dimes;
    }

    public int getQuarters() {
        return quarters;
    }

    public void setQuarters(int quarters) {
        this.quarters = quarters;
    }

    public int getHalf_dollars() {
        return half_dollars;
    }

    public void setHalf_dollars(int half_dollars) {
        this.half_dollars = half_dollars;
    }

    public int getDollars() {
        return dollars;
    }

    public void setDollars(int dollars) {
        this.dollars = dollars;
    }

    public int getSingles() {
        return singles;
    }

    public void setSingles(int singles) {
        this.singles = singles;
    }

    public int getFives() {
        return fives;
    }

    public void setFives(int fives) {
        this.fives = fives;
    }

    public int getTens() {
        return tens;
    }

    public void setTens(int tens) {
        this.tens = tens;
    }

    public int getTwenties() {
        return twenties;
    }

    public void setTwenties(int twenties) {
        this.twenties = twenties;
    }

    public int getFifties() {
        return fifties;
    }

    public void setFifties(int fifties) {
        this.fifties = fifties;
    }

    public int getHundreds() {
        return hundreds;
    }

    public void setHundreds(int hundreds) {
        this.hundreds = hundreds;
    }

    public BigDecimal getAmex() {
        return amex;
    }

    public void setAmex(BigDecimal amex) {
        this.amex = amex;
    }

    public BigDecimal getVisa() {
        return visa;
    }

    public void setVisa(BigDecimal visa) {
        this.visa = visa;
    }

    public BigDecimal getMastercard() {
        return mastercard;
    }

    public void setMastercard(BigDecimal mastercard) {
        this.mastercard = mastercard;
    }

    public BigDecimal getCheque() {
        return cheque;
    }

    public void setCheque(BigDecimal cheque) {
        this.cheque = cheque;
    }

    public BigDecimal getCash() {
        return cash;
    }

    public void setCash(BigDecimal cash) {
        this.cash = cash;
    }

    public BigDecimal getGift() {
        return gift;
    }

    public void setGift(BigDecimal gift) {
        this.gift = gift;
    }

    public BigDecimal getCard_over() {
        return card_over;
    }

    public BigDecimal getCheque_over() {
        return cheque_over;
    }

    public void setCheque_over(BigDecimal cheque_over) {
        this.cheque_over = cheque_over;
    }

    public BigDecimal getCash_over() {
        return cash_over;
    }

    public void setCash_over(BigDecimal cash_over) {
        this.cash_over = cash_over;
    }

    public BigDecimal getGift_over() {
        return gift_over;
    }

    public void setGift_over(BigDecimal gift_over) {
        this.gift_over = gift_over;
    }

    public BigDecimal getCard_short() {
        return card_short;
    }

    public void setCard_short(BigDecimal card_short) {
        this.card_short = card_short;
    }

    public BigDecimal getCheque_short() {
        return cheque_short;
    }

    public void setCheque_short(BigDecimal cheque_short) {
        this.cheque_short = cheque_short;
    }

    public BigDecimal getCash_short() {
        return cash_short;
    }

    public void setCash_short(BigDecimal cash_short) {
        this.cash_short = cash_short;
    }

    public BigDecimal getGift_short() {
        return gift_short;
    }

    public void setGift_short(BigDecimal gift_short) {
        this.gift_short = gift_short;
    }

    public void setCard_over(BigDecimal card_over) {
        this.card_over = card_over;
    }

    public BigDecimal getCreditcard() {
        return creditcard;
    }

    public void setCreditcard(BigDecimal creditcard) {
        this.creditcard = creditcard;
    }

    public int getUserID() {
        return userID;
    }

    public String getUserIP() {
        return userIP;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public void setUserIP(String userIP) {
        this.userIP = userIP;
    }

    public static CashDrawing insertCashDrawing(
            int loc,
            int employeeID,
            Timestamp date,
            int pennies,
            int nickels,
            int dimes,
            int quarters,
            int half_dollars,
            int dollars,
            int singles,
            int fives,
            int tens,
            int twenties,
            int fifties,
            int hundreds,
            int openClose,
            BigDecimal amex,
            BigDecimal visa,
            BigDecimal mastercard,
            BigDecimal cheque,
            BigDecimal cash,
            BigDecimal gift,
            BigDecimal card_over,
            BigDecimal cheque_over,
            BigDecimal cash_over,
            BigDecimal gift_over,
            BigDecimal card_short,
            BigDecimal cheque_short,
            BigDecimal cash_short,
            BigDecimal gift_short,
            BigDecimal creditcard,
            int userID,
            String userIP

    ) {
        CashDrawing cd = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "INSERT cash_drawing (" + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX  + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", " + GIFT + ", "
                    + CARD_OVER + ", " + CASH_OVER + ", " + CHEQUE_OVER + ", " + GIFT_OVER + ", "
                    + CARD_SHORT + ", " + CASH_SHORT + ", " + CHEQUE_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + USERID + ", " + USERIP + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                );
            pst.setInt(1, employeeID);
            pst.setTimestamp(2, date);
            pst.setInt(3, pennies);
            pst.setInt(4, nickels);
            pst.setInt(5, dimes);
            pst.setInt(6, quarters);
            pst.setInt(7, half_dollars);
            pst.setInt(8, dollars);
            pst.setInt(9, singles);
            pst.setInt(10, fives);
            pst.setInt(11, tens);
            pst.setInt(12, twenties);
            pst.setInt(13, fifties);
            pst.setInt(14, hundreds);
            pst.setInt(15, loc); 
            pst.setInt(16, openClose);
            pst.setBigDecimal(17, amex);
            pst.setBigDecimal(18, visa);
            pst.setBigDecimal(19, mastercard);
            pst.setBigDecimal(20, cheque);
            pst.setBigDecimal(21, cash);
            pst.setBigDecimal(22, gift);
            pst.setBigDecimal(23, card_over);
            pst.setBigDecimal(24, cash_over);
            pst.setBigDecimal(25, cheque_over);
            pst.setBigDecimal(26, gift_over);
            pst.setBigDecimal(27, card_short);
            pst.setBigDecimal(28, cash_short);
            pst.setBigDecimal(29, cheque_short);
            pst.setBigDecimal(30, gift_short);
            pst.setBigDecimal(31, creditcard);
            pst.setInt(32, userID);
            pst.setString(33,userIP);

            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cd = new CashDrawing();
                cd.setEmployeeID(employeeID);
                cd.setDate(date);
                cd.setPennies(pennies);
                cd.setNickels(nickels);
                cd.setDimes(dimes);
                cd.setQuarters(quarters);
                cd.setHalf_dollars(half_dollars);
                cd.setDollars(dollars);
                cd.setSingles(singles);
                cd.setFives(fives);
                cd.setTens(tens);
                cd.setTwenties(twenties);
                cd.setFifties(fifties);
                cd.setHundreds(hundreds);
                cd.setLocationID(1);
                cd.setOpenClose(openClose);
                cd.setAmex(amex);
                cd.setVisa(visa);
                cd.setMastercard(mastercard);
                cd.setCheque(cheque);
                cd.setCash(cash);
                cd.setCard_over(card_over);
                cd.setCheque_over(cheque_over);
                cd.setCash_over(cash_over);
                cd.setGift_over(gift_over);
                cd.setCard_short(card_short);
                cd.setCheque_short(cheque_short);
                cd.setCash_short(cash_short);
                cd.setGift_short(gift_short);
                cd.setCreditcard(creditcard);
                cd.setUserID(userID);
                cd.setUserIP(userIP);
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next())
                    cd.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cd;
    }

    public static CashDrawing findByDate(int loc, Date dt){
        CashDrawing cd = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" WHERE " + LOC + "=? AND DATE(" + DATE + ")=DATE(?) ORDER BY " + OPEN_CLOSE + " DESC"
                );
            pst.setInt(1, loc);
            pst.setDate(2, dt);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cd = new CashDrawing();
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cd;
        
    }


    public static CashDrawing findByDateStatus(int loc, Date dt, int status){
        CashDrawing cd = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" WHERE " + LOC + "=? AND DATE(" + DATE + ")=? AND openClose=? ORDER BY " + OPEN_CLOSE + " DESC"
                );
            pst.setInt(1, loc);
            pst.setDate(2, dt);
            pst.setInt(3, status);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cd = new CashDrawing();
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cd;

    }

     public static CashDrawing findByPrevDate(String dt){
        CashDrawing cd = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            String query = "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" WHERE " + LOC + "=1 AND DATE(" + DATE + ") = (DATE_ADD(DATE(?), INTERVAL -1 DAY)) and openClose = 2";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setString(1, dt);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cd = new CashDrawing();
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cd;

    }

    public static CashDrawing findByLastDate(String dt, int type){
        CashDrawing cd = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            String query = "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" \n" +
                    "WHERE " + LOC + "=1 AND \n"+
                    "DATE(date) < DATE(?) \n " +
                    "AND openClose = ? \n " +
                    "order by date desc \n " +
                    "LIMIT 0,1";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setString(1, dt);
            pst.setInt(2,type);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cd = new CashDrawing();
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cd;

    }

    public static CashDrawing findByPrev3CloseDate(String dt){
        CashDrawing cd = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            String query = "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +"\n" +
                    "WHERE " + LOC + "=1 AND \n"+
                    "(DATE(" + DATE + ") = (DATE_ADD(DATE(?), INTERVAL -3 DAY)) and openClose = 2)\n";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setString(1, dt);            
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                cd = new CashDrawing();
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cd;

    }

      public static CashDrawing updateCashDrawing(
            int user,
            int id,
            int loc,
            int employeeID,
            Timestamp date,
            int pennies,
            int nickels,
            int dimes,
            int quarters,
            int half_dollars,
            int dollars,
            int singles,
            int fives,
            int tens,
            int twenties,
            int fifties,
            int hundreds,
            int openClose,
            BigDecimal amex,
            BigDecimal visa,
            BigDecimal mastercard,
            BigDecimal cheque,
            BigDecimal cash,
            BigDecimal gift,
            BigDecimal card_over,
            BigDecimal cheque_over,
            BigDecimal cash_over,
            BigDecimal gift_over,
            BigDecimal card_short,
            BigDecimal cheque_short,
            BigDecimal cash_short,
            BigDecimal gift_short,
            BigDecimal creditcard,
            int userID,
            String userIP

    ) {
        CashDrawing cd = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "UPDATE "+ TABLE +" SET "
                    + LOC + "=?,"
                    + EMPLOYEE_ID + "=?,"
                    + DATE + "=?,"
                    + PENNIES + "=?,"
                    + NICKELS + "=?,"
                    + DIMES + "=?,"
                    + QUARTERS + "=?,"
                    + HALF_DOLLARS + "=?,"
                    + DOLLARS + "=?,"
                    + SINGLES + "=?,"
                    + FIVES + "=?,"
                    + TENS + "=?,"
                    + TWENTIES + "=?,"
                    + FIFTIES + "=?,"
                    + HUNDREDS + "=?," 
                    + OPEN_CLOSE + "=?,"
                    + AMEX + "=?,"
                    + VISA + "=?,"
                    + MASTERCARD + "=?,"
                    + CHEQUE + "=?,"
                    + CASH + "=?,"
                    + GIFT + "=?,"
                    + CARD_OVER + "=?,"
                    + CHEQUE_OVER + "=?,"
                    + CASH_OVER + "=?,"
                    + GIFT_OVER + "=?,"
                    + CARD_SHORT + "=?,"
                    + CHEQUE_SHORT + "=?,"
                    + CASH_SHORT + "=?,"
                    + GIFT_SHORT + "=?, "
                    + CREDITCARD + "=?, "
                    + USERID + "=?, "
                    + USERIP + "=? "
                    +"WHERE " + ID + "=?";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setInt(2, employeeID);
            pst.setTimestamp(3, date);
            pst.setInt(4, pennies);
            pst.setInt(5, nickels);
            pst.setInt(6, dimes);
            pst.setInt(7, quarters);
            pst.setInt(8, half_dollars);
            pst.setInt(9, dollars);
            pst.setInt(10, singles);
            pst.setInt(11, fives);
            pst.setInt(12, tens);
            pst.setInt(13, twenties);
            pst.setInt(14, fifties);
            pst.setInt(15, hundreds);
//            pst.setInt(16, loc); // TODO: location id
            pst.setInt(16, openClose);
            pst.setBigDecimal(17, amex);
            pst.setBigDecimal(18, visa);
            pst.setBigDecimal(19, mastercard);
            pst.setBigDecimal(20, cheque);
            pst.setBigDecimal(21, cash);
            pst.setBigDecimal(22, gift);
            pst.setBigDecimal(23, card_over);
            pst.setBigDecimal(24, cheque_over);
            pst.setBigDecimal(25, cash_over);
            pst.setBigDecimal(26, gift_over);
            pst.setBigDecimal(27, card_short);
            pst.setBigDecimal(28, cheque_short);
            pst.setBigDecimal(29, cash_short);
            pst.setBigDecimal(30, gift_short);
            pst.setBigDecimal(31, creditcard);
            pst.setInt(32, userID);
            pst.setString(33,userIP);
            pst.setInt(34, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cd = new CashDrawing();
                cd.setId(id);
                cd.setEmployeeID(employeeID);
                cd.setDate(date);
                cd.setPennies(pennies);
                cd.setNickels(nickels);
                cd.setDimes(dimes);
                cd.setQuarters(quarters);
                cd.setHalf_dollars(half_dollars);
                cd.setDollars(dollars);
                cd.setSingles(singles);
                cd.setFives(fives);
                cd.setTens(tens);
                cd.setTwenties(twenties);
                cd.setFifties(fifties);
                cd.setHundreds(hundreds);
                cd.setLocationID(loc);
                cd.setOpenClose(openClose);
                cd.setAmex(amex);
                cd.setVisa(visa);
                cd.setMastercard(mastercard);
                cd.setCheque(cheque);
                cd.setCash(cash);
                cd.setGift(gift);
                cd.setCard_over(card_over);
                cd.setCheque_over(cheque_over);
                cd.setCash_over(cash_over);
                cd.setGift_over(gift_over);
                cd.setCard_short(card_short);
                cd.setCheque_short(cheque_short);
                cd.setCash_short(cash_short);
                cd.setGift_short(gift_short);
                cd.setCreditcard(creditcard);
                cd.setUserID(userID);
                cd.setUserIP(userIP);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }

        if (cd != null)
            Trail.log(user, TABLE, ActionUtil.ACT_EDIT, cd.getId(), sql);
        return cd;
    }
    public static ArrayList findByYearMouthDay(int loc, int year, int mouth, int day){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            String strQuery;
            strQuery = "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" WHERE " + LOC + "=? AND openCLOSE = 2 ";
            int numParam = 0;
            if(year > 0)
            {
                strQuery = strQuery + "AND YEAR("+ DATE +") =? ";
            }
            if(mouth > 0)
            {
                strQuery = strQuery + "AND MONTH(" + DATE + ")=?  ";
            }
            if(day > 0)
            {
                strQuery = strQuery + "AND DAY(" + DATE + ") = ? ";
            }
            strQuery = strQuery + " ORDER BY DATE DESC";
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            pst.setInt(1, loc);
            if(year > 0)
                pst.setInt(2, year);
            else
                if(mouth > 0)
                {
                    pst.setInt(2, mouth);
                    if(day > 0)
                        pst.setInt(3, day);
                }
                else
                    if(day > 0)
                        pst.setInt(2, day);
            if(year > 0 && mouth > 0)
                pst.setInt(3, mouth);
            if(year > 0 && mouth > 0 && day > 0)
                pst.setInt(4, day);
            ResultSet rs = pst.executeQuery();
            while(rs.next())
            {
                CashDrawing cd = new CashDrawing();
                list.add(cd);
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
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
    public static ArrayList findAllOrderDate(int loc)
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" WHERE " + LOC + "=? and openCLOSE = 2 ORDER BY DATE DESC"
                );
            pst.setInt(1, loc);
            ResultSet rs = pst.executeQuery();
            while(rs.next())
            {
                CashDrawing cd = new CashDrawing();
                list.add(cd);
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
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

    public static ArrayList findbyFilter(String filter)
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" "+filter);
            ResultSet rs = pst.executeQuery();
            while(rs.next())
            {
                CashDrawing cd = new CashDrawing();
                list.add(cd);
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
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
            ResultSet rs = st.executeQuery("SELECT count(*) FROM " + TABLE + filter );

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
    public static ArrayList findAll(int loc)
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "SELECT " + EMPLOYEE_ID + ", " + DATE + ", " + PENNIES + ", " + NICKELS + ", "
                    + DIMES + ", " + QUARTERS + ", " + HALF_DOLLARS + ", " + DOLLARS + ", " + SINGLES + ", "
                    + FIVES + ", " + TENS + ", " + TWENTIES + ", " + FIFTIES + ", " + HUNDREDS + ", " + LOC + ", "
                    + OPEN_CLOSE + ", " + AMEX + ", " + VISA + ", " + MASTERCARD + ", " + CHEQUE + ", " + CASH + ", "
                    + GIFT + ", " + CARD_OVER + ", " + CHEQUE_OVER + ", " + CASH_OVER + ", " + GIFT_OVER + ", "
                            + CARD_SHORT + ", " + CHEQUE_SHORT + ", " + CASH_SHORT + ", " + GIFT_SHORT + ", " + CREDITCARD + ", " + ID + " FROM "+ TABLE +" WHERE " + LOC + "=? "
                );
            pst.setInt(1, loc);
            ResultSet rs = pst.executeQuery();
            while(rs.next())
            {
                CashDrawing cd = new CashDrawing();
                list.add(cd);
                cd.setEmployeeID(rs.getInt(1));
                cd.setDate(rs.getTimestamp(2));
                cd.setPennies(rs.getInt(3));
                cd.setNickels(rs.getInt(4));
                cd.setDimes(rs.getInt(5));
                cd.setQuarters(rs.getInt(6));
                cd.setHalf_dollars(rs.getInt(7));
                cd.setDollars(rs.getInt(8));
                cd.setSingles(rs.getInt(9));
                cd.setFives(rs.getInt(10));
                cd.setTens(rs.getInt(11));
                cd.setTwenties(rs.getInt(12));
                cd.setFifties(rs.getInt(13));
                cd.setHundreds(rs.getInt(14));
                cd.setLocationID(rs.getInt(15));
                cd.setOpenClose(rs.getInt(16));
                cd.setAmex(rs.getBigDecimal(17));
                cd.setVisa(rs.getBigDecimal(18));
                cd.setMastercard(rs.getBigDecimal(19));
                cd.setCheque(rs.getBigDecimal(20));
                cd.setCash(rs.getBigDecimal(21));
                cd.setGift(rs.getBigDecimal(22));
                cd.setCard_over(rs.getBigDecimal(23));
                cd.setCheque_over(rs.getBigDecimal(24));
                cd.setCash_over(rs.getBigDecimal(25));
                cd.setGift_over(rs.getBigDecimal(26));
                cd.setCard_short(rs.getBigDecimal(27));
                cd.setCheque_short(rs.getBigDecimal(28));
                cd.setCash_short(rs.getBigDecimal(29));
                cd.setGift_short(rs.getBigDecimal(30));
                cd.setCreditcard(rs.getBigDecimal(31));
                cd.setId(rs.getInt(32));
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

}
