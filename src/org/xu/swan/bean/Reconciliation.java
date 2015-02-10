package org.xu.swan.bean;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.ActionUtil;

public class Reconciliation {
    public static final String TABLE = "reconciliation";

    public static final String ID = "id";
    public static final String LOC = "id_location";
    public static final String CODE_TRANS = "code_transaction";
    public static final String CUST = "id_customer";
    public static final String S_TOTAL = "sub_total";
    public static final String TAXE = "taxe";
    public static final String TOTAL = "total";
    public static final String PAYM = "payment";
    public static final String STATUS = "status";
    public static final String CDT = "created_dt";
    public static final String AMEX = "amex";
    public static final String VISA = "visa";
    public static final String MASTECARD = "mastercard";
    public static final String CHEQUE = "cheque";
    public static final String CASHE = "cashe";
    public static final String GIFTCARD = "giftcard";
    public static final String CHANGE = "chg";
    public static final String GIFTCARD_PAY = "giftcard_pay";

    private int id;
    private int id_location;
    private String code_transaction;
    private int id_customer;
    private BigDecimal sub_total;
    private BigDecimal taxe;
    private BigDecimal total;
    private String payment;
    private int status;
    private Date created_dt;
    private BigDecimal amex;
    private BigDecimal visa;
    private BigDecimal mastercard;
    private BigDecimal cheque;
    private BigDecimal cashe;
    private BigDecimal giftcard;
    private BigDecimal change;
    private String giftcard_pay;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId_location() {
        return id_location;
    }

    public void setId_location(int id_location) {
        this.id_location = id_location;
    }

    public String getCode_transaction() {
        return code_transaction;
    }

    public void setCode_transaction(String code_transaction) {
        this.code_transaction = code_transaction;
    }

    public int getId_customer() {
        return id_customer;
    }

    public void setId_customer(int id_customer) {
        this.id_customer = id_customer;
    }

    public BigDecimal getSub_total() {
        return sub_total;
    }

    public void setSub_total(BigDecimal sub_total) {
        this.sub_total = sub_total;
    }

    public BigDecimal getTaxe() {
        return taxe;
    }

    public void setTaxe(BigDecimal taxe) {
        this.taxe = taxe;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getCreated_dt() {
        return created_dt;
    }

    public void setCreated_dt(Date created_dt) {
        this.created_dt = created_dt;
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

    public BigDecimal getCashe() {
        return cashe;
    }

    public void setCashe(BigDecimal cashe) {
        this.cashe = cashe;
    }

    public BigDecimal getGiftcard() {
        return giftcard;
    }

    public void setGiftcard(BigDecimal giftcard) {
        this.giftcard = giftcard;
    }

    public BigDecimal getChange() {
        return change;
    }

    public void setChange(BigDecimal change) {
        this.change = change;
    }

    public String getGiftcard_pay() {
        return giftcard_pay;
    }

    public void setGiftcard_pay(String giftcard_pay) {
        this.giftcard_pay = giftcard_pay;
    }
    //    public static Reconciliation insertTransaction1(int user, int loc, int cust, String payment,
//                                                 BigDecimal price, BigDecimal discount, String code, Date cdt, String num, BigDecimal t, BigDecimal rmd, BigDecimal change, String note, BigDecimal amex, BigDecimal visa, BigDecimal mastercard, BigDecimal cheque, BigDecimal cashe, BigDecimal giftcard) {
//        if (loc < 1 && cust < 1)
//            return null;
//        List<TransactionCust> list = TransactionCust.findTransByLocCust(loc, cust);
//        if (list.size() == 0)
//            return null;
//        String transCode = TransactionCodeGenerator.next();
//        Reconciliation retTrans = null;
//        for (TransactionCust trans : list) {
//            retTrans = insertTransaction(user, loc, cust, trans.getEmployee_id(), trans.getService_id(), trans.getProduct_id(), trans.getProd_qty(), payment,
//                                                 price, discount, transCode, cdt, num, t, rmd, change, note, amex, visa, mastercard, cheque, cashe, giftcard);
//            TransactionCust.deleteTransaction(user, trans.getId());
//        }
//        return retTrans;
//    }

    public static Reconciliation insertTransaction(int user, int loc, String code, int cust, BigDecimal s_total, BigDecimal taxe, BigDecimal total, String paym, int status, Date created_dt, BigDecimal amex, BigDecimal visa, BigDecimal mastercard, BigDecimal cheque, BigDecimal cashe, BigDecimal giftCard, BigDecimal change, String giftcard_pay) {
        if (loc < 1 && code.equals(""))
            return null;
        Reconciliation retTrans = null;
        ArrayList list = Ticket.findTicketByLocCodeTrans(loc, code);
        if (list.size() == 0)
            return null;
//        String transCode = TransactionCodeGenerator.next();
        for (int i = 0; i < list.size(); i++) {
            Ticket ticket = (Ticket)list.get(i);
            if (!ticket.getGiftcard().equals("-1")){
                if (ticket.getStatus() == 0)
                    Giftcard.insertGiftcard(ticket.getGiftcard(), ticket.getPrice(), "",ticket.getPrice(), created_dt,cust);
                if (ticket.getStatus() == 1){
                    Giftcard gc = Giftcard.findByCode(ticket.getGiftcard());
                    BigDecimal amount = gc.getAmount().add(ticket.getPrice());
                    Giftcard.updateGiftcard(ticket.getGiftcard(), amount);
                }
            }
        }
        retTrans = insertTransaction_(user, loc, code, cust, s_total, taxe, total, paym, status, created_dt, amex, visa, mastercard, cheque, cashe, giftCard, change, giftcard_pay);
        return retTrans;
    }

    public static Reconciliation insertTransaction_(int user, int loc, String code, int cust, BigDecimal s_total, BigDecimal taxe, BigDecimal total, String paym, int status, Date created_dt, BigDecimal amex, BigDecimal visa, BigDecimal mastercard, BigDecimal cheque, BigDecimal cashe, BigDecimal giftCard, BigDecimal change, String giftcard_pay) {
        Reconciliation tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "INSERT reconciliation (" + LOC + "," + CODE_TRANS + "," + CUST + "," + S_TOTAL + "," + TAXE + "," + TOTAL + "," + PAYM + "," + STATUS + "," + CDT + ","+ AMEX + "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + CHANGE + "," + GIFTCARD_PAY + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setString(2, code);
            pst.setInt(3, cust);
            pst.setBigDecimal(4, s_total);
            pst.setBigDecimal(5, taxe);
            pst.setBigDecimal(6, total);
            pst.setString(7, paym);
            pst.setInt(8, status);
            pst.setDate(9, created_dt);
            pst.setBigDecimal(10, amex);
            pst.setBigDecimal(11, visa);
            pst.setBigDecimal(12, mastercard);
            pst.setBigDecimal(13, cheque);
            pst.setBigDecimal(14, cashe);
            pst.setBigDecimal(15, giftCard);
            pst.setBigDecimal(16, change);
            pst.setString(17, giftcard_pay);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Reconciliation();
                tran.setId_location(loc);
                tran.setCode_transaction(code);
                tran.setId_customer(cust);
                tran.setSub_total(s_total);
                tran.setTaxe(taxe);
                tran.setTotal(total);
                tran.setPayment(paym);
                tran.setStatus(status);
                tran.setCreated_dt(created_dt);
                tran.setAmex(amex);
                tran.setVisa(visa);
                tran.setMastercard(mastercard);
                tran.setCheque(cheque);
                tran.setCashe(cashe);
                tran.setGiftcard(giftCard);
                tran.setChange(change);
                tran.setGiftcard_pay(giftcard_pay);
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next())
                    tran.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }

        if (tran != null)
            Trail.log(user, TABLE, ActionUtil.ACT_ADD, tran.getId(), sql);
        return tran;
    }

    public static Reconciliation updateTransaction(int user, int id, int loc, String code, int cust, BigDecimal s_total, BigDecimal taxe, BigDecimal total, String paym, int status, Date created_dt, BigDecimal amex, BigDecimal visa, BigDecimal mastercard, BigDecimal cheque, BigDecimal cashe, BigDecimal giftCard, BigDecimal change, String giftcard_pay) {
        Reconciliation tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "UPDATE reconciliation SET " + LOC + "=?," + CODE_TRANS + "=?," + CUST + "=?," + S_TOTAL + "=?," + TAXE + "=?," + TOTAL + "=?," + PAYM + "=?," + STATUS + "=?," + CDT + "=?," + AMEX + "=?," + VISA + "=?," + MASTECARD + "=?," + CHEQUE + "=?," + CASHE + "=?," + GIFTCARD + "=?," + CHANGE + "=?," + GIFTCARD_PAY + "=? WHERE " + ID + "=?";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setString(2, code);
            pst.setInt(3, cust);
            pst.setBigDecimal(4, s_total);
            pst.setBigDecimal(5, taxe);
            pst.setBigDecimal(6, total);
            pst.setString(7, paym);
            pst.setInt(8, status);
            pst.setDate(9, created_dt);
            pst.setBigDecimal(10, amex);
            pst.setBigDecimal(11, visa);
            pst.setBigDecimal(12, mastercard);
            pst.setBigDecimal(13, cheque);
            pst.setBigDecimal(14, cashe);
            pst.setBigDecimal(15, giftCard);
            pst.setBigDecimal(16, change);
            pst.setString(17, giftcard_pay);
            pst.setInt(18, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Reconciliation();
                tran.setId(id);
                tran.setId_location(loc);
                tran.setCode_transaction(code);
                tran.setId_customer(cust);
                tran.setSub_total(s_total);
                tran.setTaxe(taxe);
                tran.setTotal(total);
                tran.setPayment(paym);
                tran.setStatus(status);
                tran.setCreated_dt(created_dt);
                tran.setAmex(amex);
                tran.setVisa(visa);
                tran.setMastercard(mastercard);
                tran.setCheque(cheque);
                tran.setCashe(cashe);
                tran.setGiftcard(giftCard);
                tran.setChange(change);
                tran.setGiftcard_pay(giftcard_pay);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }

        if (tran != null)
            Trail.log(user, TABLE, ActionUtil.ACT_EDIT, tran.getId(), sql);
        return tran;
    }

    public static Reconciliation deleteTransaction(int user, int id) {
        Reconciliation tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "UPDATE reconciliation SET " + STATUS + "=1 WHERE " + ID + "=?";
            //PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM transaction WHERE " + ID + "=?");
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Reconciliation();
                tran.setId(id);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }

        if (tran != null)
            Trail.log(user, TABLE, ActionUtil.ACT_DEL, tran.getId(), sql);
        return tran;
    }

    public static ArrayList findAll() {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," +  LOC + "," + CODE_TRANS + "," + CUST + "," + S_TOTAL + "," + TAXE + "," + TOTAL + "," + PAYM + "," + STATUS + ","  + AMEX + "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + CHANGE +  "," + CDT + "," + GIFTCARD_PAY + " FROM reconciliation WHERE 1 !=" + STATUS);
            while (rs.next()) {
                Reconciliation tran = new Reconciliation();
                list.add(tran);
                tran.setId(rs.getInt(1));
                tran.setId_location(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setId_customer(rs.getInt(4));
                tran.setSub_total(rs.getBigDecimal(5));
                tran.setTaxe(rs.getBigDecimal(6));
                tran.setTotal(rs.getBigDecimal(7));
                tran.setPayment(rs.getString(8));
                tran.setStatus(rs.getInt(9));
                tran.setAmex(rs.getBigDecimal(10));
                tran.setVisa(rs.getBigDecimal(11));
                tran.setMastercard(rs.getBigDecimal(12));
                tran.setCheque(rs.getBigDecimal(13));
                tran.setCashe(rs.getBigDecimal(14));
                tran.setGiftcard(rs.getBigDecimal(15));
                tran.setChange(rs.getBigDecimal(16));
                tran.setCreated_dt(rs.getDate(17));
                tran.setGiftcard_pay(rs.getString(18));
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

    public static ArrayList findByFilter(String filter) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            String strQuery;
            strQuery = "SELECT " + ID + "," +  LOC + "," + CODE_TRANS + "," + CUST + "," + S_TOTAL + "," + TAXE + "," + TOTAL + "," + PAYM + "," + STATUS + ","  + AMEX + "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + CHANGE +  "," + CDT + "," + GIFTCARD_PAY + " FROM reconciliation " + filter;
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Reconciliation tran = new Reconciliation();
                list.add(tran);
                tran.setId(rs.getInt(1));
                tran.setId_location(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setId_customer(rs.getInt(4));
                tran.setSub_total(rs.getBigDecimal(5));
                tran.setTaxe(rs.getBigDecimal(6));
                tran.setTotal(rs.getBigDecimal(7));
                tran.setPayment(rs.getString(8));
                tran.setStatus(rs.getInt(9));
                tran.setAmex(rs.getBigDecimal(10));
                tran.setVisa(rs.getBigDecimal(11));
                tran.setMastercard(rs.getBigDecimal(12));
                tran.setCheque(rs.getBigDecimal(13));
                tran.setCashe(rs.getBigDecimal(14));
                tran.setGiftcard(rs.getBigDecimal(15));
                tran.setChange(rs.getBigDecimal(16));
                tran.setCreated_dt(rs.getDate(17));
                tran.setGiftcard_pay(rs.getString(18));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static Reconciliation findById(int id) {
        Reconciliation tran = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT "  + ID + "," +  LOC + "," + CODE_TRANS + "," + CUST + "," + S_TOTAL + "," + TAXE + "," + TOTAL + "," + PAYM + "," + STATUS + "," + CDT + ","  + AMEX + "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + CHANGE + "," + GIFTCARD_PAY + "  FROM reconciliation WHERE " + ID + "=? AND 1!=" + STATUS);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                tran = new Reconciliation();
                tran.setId(rs.getInt(1));
                tran.setId_location(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setId_customer(rs.getInt(4));
                tran.setSub_total(rs.getBigDecimal(5));
                tran.setTaxe(rs.getBigDecimal(6));
                tran.setTotal(rs.getBigDecimal(7));
                tran.setPayment(rs.getString(8));
                tran.setStatus(rs.getInt(9));
                tran.setCreated_dt(rs.getDate(10));
                tran.setAmex(rs.getBigDecimal(11));
                tran.setVisa(rs.getBigDecimal(12));
                tran.setMastercard(rs.getBigDecimal(13));
                tran.setCheque(rs.getBigDecimal(14));
                tran.setCashe(rs.getBigDecimal(15));
                tran.setGiftcard(rs.getBigDecimal(16));
                tran.setChange(rs.getBigDecimal(17));
                tran.setGiftcard_pay(rs.getString(18));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return tran;
    }

    public static Reconciliation findTransByCodeOne(String code_trans) {
        Reconciliation tran = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT "  + ID + "," +  LOC + "," + CODE_TRANS + "," + CUST + "," + S_TOTAL + "," + TAXE + "," + TOTAL + "," + PAYM + "," + STATUS + "," + CDT + ","  + AMEX + "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + CHANGE + "," + GIFTCARD_PAY + "  FROM reconciliation WHERE " + CODE_TRANS + "=? ");
            pst.setString(1, code_trans);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                tran = new Reconciliation();
                tran.setId(rs.getInt(1));
                tran.setId_location(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setId_customer(rs.getInt(4));
                tran.setSub_total(rs.getBigDecimal(5));
                tran.setTaxe(rs.getBigDecimal(6));
                tran.setTotal(rs.getBigDecimal(7));
                tran.setPayment(rs.getString(8));
                tran.setStatus(rs.getInt(9));
                tran.setCreated_dt(rs.getDate(10));
                tran.setAmex(rs.getBigDecimal(11));
                tran.setVisa(rs.getBigDecimal(12));
                tran.setMastercard(rs.getBigDecimal(13));
                tran.setCheque(rs.getBigDecimal(14));
                tran.setCashe(rs.getBigDecimal(15));
                tran.setGiftcard(rs.getBigDecimal(16));
                tran.setChange(rs.getBigDecimal(17));
                tran.setGiftcard_pay(rs.getString(18));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return tran;
    }


    public static ArrayList findTransByLocDate(int loc, Date dt) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT "   + ID + "," +  LOC + "," + CODE_TRANS + "," + CUST + "," + S_TOTAL + "," + TAXE + "," + TOTAL + "," + PAYM + "," + STATUS + "," + CDT + "," + AMEX + "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + CHANGE + "," + GIFTCARD_PAY + " FROM reconciliation WHERE " + LOC + "=? AND DATE(" + CDT + ")=DATE(?) AND 1!=" + STATUS);
            pst.setInt(1, loc);
            pst.setDate(2, dt);
//            System.out.print(pst);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Reconciliation tran = new Reconciliation();
                tran.setId(rs.getInt(1));
                tran.setId_location(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setId_customer(rs.getInt(4));
                tran.setSub_total(rs.getBigDecimal(5));
                tran.setTaxe(rs.getBigDecimal(6));
                tran.setTotal(rs.getBigDecimal(7));
                tran.setPayment(rs.getString(8));
                tran.setStatus(rs.getInt(9));
                tran.setCreated_dt(rs.getDate(10));
                tran.setAmex(rs.getBigDecimal(11));
                tran.setVisa(rs.getBigDecimal(12));
                tran.setMastercard(rs.getBigDecimal(13));
                tran.setCheque(rs.getBigDecimal(14));
                tran.setCashe(rs.getBigDecimal(15));
                tran.setGiftcard(rs.getBigDecimal(16));
                tran.setChange(rs.getBigDecimal(17));
                tran.setGiftcard_pay(rs.getString(18));

                list.add(tran);
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findTransByCode(String code) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
                        PreparedStatement pst = dbm.getPreparedStatement(
                    "SELECT "  + ID + "," +  LOC + "," + CODE_TRANS +
                    "," + CUST + "," + S_TOTAL + "," + TAXE + "," + TOTAL +
                    "," + PAYM + "," + STATUS + "," + CDT + ","  + AMEX +
                    "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE +
                    "," + GIFTCARD + "," + CHANGE + "," + GIFTCARD_PAY + "  FROM reconciliation WHERE " + CODE_TRANS + "=?");
            pst.setString(1, code);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Reconciliation tran = new Reconciliation();
                tran.setId(rs.getInt(1));
                tran.setId_location(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setId_customer(rs.getInt(4));
                tran.setSub_total(rs.getBigDecimal(5));
                tran.setTaxe(rs.getBigDecimal(6));
                tran.setTotal(rs.getBigDecimal(7));
                tran.setPayment(rs.getString(8));
                tran.setStatus(rs.getInt(9));
                tran.setCreated_dt(rs.getDate(10));
                tran.setAmex(rs.getBigDecimal(11));
                tran.setVisa(rs.getBigDecimal(12));
                tran.setMastercard(rs.getBigDecimal(13));
                tran.setCheque(rs.getBigDecimal(14));
                tran.setCashe(rs.getBigDecimal(15));
                tran.setGiftcard(rs.getBigDecimal(16));
                tran.setChange(rs.getBigDecimal(17));
                tran.setGiftcard_pay(rs.getString(18));

                list.add(tran);
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }
}