package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.TransactionCodeGenerator;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Transaction {
    public static final String TABLE = "transaction";

    public static final String ID = "id";
    public static final String LOC = "location_id";
    public static final String CUST = "customer_id";
    public static final String EMP = "employee_id";
    public static final String SVC = "service_id";
    public static final String PROD = "product_id";
    public static final String PQTY = "prod_qty";
    public static final String PAYMENT = "payment";
    public static final String PRICE = "price";
    public static final String DISCOUNT = "discount";
    public static final String CODE = "code";
    public static final String CDT = "created_dt";
    public static final String SN = "sn";
    public static final String TAX = "tax";
    public static final String RMD = "remainder";
    public static final String CHANGE = "change_f";
    public static final String DEL = "deleted";
    public static final String NOTE = "note";
    public static final String AMEX = "amex";
    public static final String VISA = "visa";
    public static final String MASTECARD = "mastercard";
    public static final String CHEQUE = "cheque";
    public static final String CASHE = "cashe";
    public static final String GIFTCARD = "giftcard";

    public static final String EX_CHANGE = "change";//special tag

    private int id;
    private int location_id;
    private int customer_id;
    private int employee_id;
    private int service_id;
    private int product_id;
    private int prod_qty;
    private String payment;
    private BigDecimal price;
    private BigDecimal discount;
    private String code;
    private String note;
    private Date created_dt;
    private String sn;
    private BigDecimal tax;
    private BigDecimal remainder;
    private BigDecimal change_f;
    private BigDecimal amex;
    private BigDecimal visa;
    private BigDecimal mastercard;
    private BigDecimal cheque;
    private BigDecimal cashe;
    private BigDecimal giftcard;
    private boolean deleted;


    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

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

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public int getService_id() {
        return service_id;
    }

    public void setService_id(int service_id) {
        this.service_id = service_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getProd_qty() {
        return prod_qty;
    }

    public void setProd_qty(int prod_qty) {
        this.prod_qty = prod_qty;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Date getCreated_dt() {
        return created_dt;
    }

    public void setCreated_dt(Date created_dt) {
        this.created_dt = created_dt;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public BigDecimal getTax() {
        return tax;
    }

    public BigDecimal getRemainder() {
        return remainder;
    }

    public void setRemainder(BigDecimal remainder) {
        this.remainder = remainder;
    }

    public BigDecimal getChange_f() {
        return change_f;
    }

    public void setChange_f(BigDecimal change_f) {
        this.change_f = change_f;
    }

    public void setTax(BigDecimal tax) {
        this.tax = tax;
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

    public String getLabel() {//TODO debug code
        String name = "debug";
        for (int i = name.length(); i < 25; i++) {
            name += "&nbsp";
        }
        String temp = "";
        int status = 1;
        if (status == 1) temp = "active&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";
        else temp = "inactive&nbsp&nbsp&nbsp&nbsp";
        String revenue = "99.00";
        return name + temp + revenue;
    }

    public String getDetail() {//TODO debug code
        String name = "debug";
        int status = 1;
        String revenue = "99.00";
        return name + "@" + revenue + "@" + (status == 1 ? "active" : "inactive");
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

    public static Transaction insertTransaction1(int user, int loc, int cust, String payment,
                                                 BigDecimal price, BigDecimal discount, String code, Date cdt, String num, BigDecimal t, BigDecimal rmd, BigDecimal change, String note, BigDecimal amex, BigDecimal visa, BigDecimal mastercard, BigDecimal cheque, BigDecimal cashe, BigDecimal giftcard) {
        if (loc < 1 && cust < 1)
            return null;
        List<TransactionCust> list = TransactionCust.findTransByLocCust(loc, cust);
        if (list.size() == 0)
            return null;
        String transCode = TransactionCodeGenerator.next();
        Transaction retTrans = null;
        for (TransactionCust trans : list) {
            retTrans = insertTransaction(user, loc, cust, trans.getEmployee_id(), trans.getService_id(), trans.getProduct_id(), trans.getProd_qty(), payment,
                                                 price, discount, transCode, cdt, num, t, rmd, change, note, amex, visa, mastercard, cheque, cashe, giftcard);
            TransactionCust.deleteTransaction(user, trans.getId());
        }
        return retTrans;
    }

    public static Transaction insertTransaction(int user, int loc, int cust, int emp, int svc, int prod, int qty, String payment,
                                                BigDecimal price, BigDecimal discount, String code, Date cdt, String num, BigDecimal t, BigDecimal rmd, BigDecimal change, String note, BigDecimal amex, BigDecimal visa, BigDecimal mastercard, BigDecimal cheque, BigDecimal cashe, BigDecimal giftcard) {
        Transaction tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "INSERT transaction (" + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + ","
                    + DISCOUNT + "," + CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + "," + NOTE + "," + AMEX + "," + VISA + "," + MASTECARD + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setInt(2, cust);
            pst.setInt(3, emp);
            pst.setInt(4, svc);
            pst.setInt(5, prod);
            pst.setInt(6, qty);
            pst.setString(7, payment);
            pst.setBigDecimal(8, price);
            pst.setBigDecimal(9, discount);
            pst.setString(10, code);
            pst.setDate(11, cdt);
            pst.setString(12, num);
            pst.setBigDecimal(13, t);
            pst.setBigDecimal(14, rmd);
            pst.setBigDecimal(15, change);
            pst.setString(16, note);
            pst.setBigDecimal(17, amex);
            pst.setBigDecimal(18, visa);
            pst.setBigDecimal(19, mastercard);
            pst.setBigDecimal(20, cheque);
            pst.setBigDecimal(21, cashe);
            pst.setBigDecimal(22, giftcard);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Transaction();
                tran.setLocation_id(loc);
                tran.setCustomer_id(cust);
                tran.setEmployee_id(emp);
                tran.setService_id(svc);
                tran.setProduct_id(prod);
                tran.setProd_qty(qty);
                tran.setPayment(payment);
                tran.setPrice(price);
                tran.setDiscount(discount);
                tran.setCode(code);
                tran.setCreated_dt(cdt);
                tran.setSn(num);
                tran.setTax(t);
                tran.setRemainder(rmd);
                tran.setChange_f(change);
                tran.setNote(note);
                tran.setAmex(amex);
                tran.setVisa(visa);
                tran.setMastercard(mastercard);
                tran.setCheque(cheque);
                tran.setCashe(cashe);
                tran.setGiftcard(giftcard);

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

    public static Transaction updateTransaction(int user, int id, int loc, int cust, int emp, int svc, int prod, int qty,
                                                String payment, BigDecimal price, BigDecimal discount, String code, Date cdt, String num, BigDecimal t, BigDecimal rmd, BigDecimal change) {
        Transaction tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "UPDATE transaction SET " + LOC + "=?," + CUST + "=?," + EMP + "=?," + SVC + "=?," + PROD + "=?," + PQTY + "?," + PAYMENT + "=?,"
                    + PRICE + "=?," + DISCOUNT + "=?," + CODE + "=?," + CDT + "=?," + SN + "=?," + TAX + "=?," + RMD + "=?," + CHANGE + "=? WHERE " + ID + "=?";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setInt(2, cust);
            pst.setInt(3, emp);
            pst.setInt(4, svc);
            pst.setInt(5, prod);
            pst.setInt(6, qty);
            pst.setString(7, payment);
            pst.setBigDecimal(8, price);
            pst.setBigDecimal(9, discount);
            pst.setString(10, code);
            pst.setDate(11, cdt);
            pst.setString(12, num);
            pst.setBigDecimal(13, t);
            pst.setBigDecimal(14, rmd);
            pst.setBigDecimal(15, change);
            pst.setInt(16, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Transaction();
                tran.setId(id);
                tran.setLocation_id(loc);
                tran.setCustomer_id(cust);
                tran.setEmployee_id(emp);
                tran.setService_id(svc);
                tran.setProduct_id(prod);
                tran.setProd_qty(qty);
                tran.setPayment(payment);
                tran.setPrice(price);
                tran.setDiscount(discount);
                tran.setCode(code);
                tran.setCreated_dt(cdt);
                tran.setSn(num);
                tran.setTax(t);
                tran.setRemainder(rmd);
                tran.setChange_f(change);
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

    public static Transaction deleteTransaction(int user, int id) {
        Transaction tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "UPDATE transaction SET " + DEL + "=1 WHERE " + ID + "=?";
            //PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM transaction WHERE " + ID + "=?");
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Transaction();
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

    public static ArrayList findAll() {//List<Transaction> findAll(){
        ArrayList list = new ArrayList();//List<Transaction> list = new ArrayList<Transaction>();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + ","
                    + DISCOUNT + "," + CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + " FROM transaction WHERE 1 !=" + DEL);
            while (rs.next()) {
                Transaction tran = new Transaction();
                list.add(tran);
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));
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
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + "," + DISCOUNT + "," +
                    CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + " FROM transaction  WHERE 1!=" + DEL + " LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while (rs.next()) {
                Transaction tran = new Transaction();
                list.add(tran);
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));
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

    public static Transaction findById(int id) {
        Transaction tran = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + ","
                    + DISCOUNT + "," + CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + " FROM transaction WHERE " + ID + "=? AND 1!=" + DEL);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                tran = new Transaction();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));
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

    public static ArrayList findByCode(String code) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + ","
                    + DISCOUNT + "," + CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + " FROM transaction WHERE " + CODE + "=? AND 1!=" + DEL);
            pst.setString(1, code);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Transaction tran = new Transaction();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));
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

    public static ArrayList findByCustDate(int cust, Date dt) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + ","
                    + DISCOUNT + "," + CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + " FROM transaction WHERE " + CUST + "=? AND DATE(" + CDT + ")=? AND 1!=" + DEL);
            pst.setInt(1, cust);
            pst.setDate(2, dt);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Transaction tran = new Transaction();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));
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

    public static HashMap findMapTransByLocDate(int loc, Date dt) {
        HashMap hm = new HashMap();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + "," + DISCOUNT + "," +
                    CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + " FROM transaction WHERE " + LOC + "=? AND DATE(" + CDT + ")=DATE(?) AND 1!=" + DEL);
            pst.setInt(1, loc);
            pst.setDate(2, dt);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Integer eid = new Integer(rs.getInt(4));
                ArrayList list = (ArrayList) hm.get(eid);
                if (list == null)
                    list = new ArrayList();

                Transaction tran = new Transaction();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProduct_id(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));

                list.add(tran);
                hm.put(eid, list);
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return hm;
    }

    public static ArrayList findTransByLocDate(int loc, Date dt) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + ","
                    + DISCOUNT + "," + CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + "," + NOTE + " FROM transaction WHERE " + LOC + "=? AND DATE(" + CDT + ")=DATE(?) AND 1!=" + DEL);
            pst.setInt(1, loc);
            pst.setDate(2, dt);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Transaction tran = new Transaction();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));
                tran.setNote(rs.getString(17));

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
    public static ArrayList findByFilter(String filter) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + "," + PAYMENT + "," + PRICE + ","
                    + DISCOUNT + "," + CODE + "," + CDT + "," + SN + "," + TAX + "," + RMD + "," + CHANGE + "," + NOTE + " FROM transaction WHERE " + filter);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Transaction tran = new Transaction();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));
                tran.setPayment(rs.getString(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setDiscount(rs.getBigDecimal(10));
                tran.setCode(rs.getString(11));
                tran.setCreated_dt(rs.getDate(12));
                tran.setSn(rs.getString(13));
                tran.setTax(rs.getBigDecimal(14));
                tran.setRemainder(rs.getBigDecimal(15));
                tran.setChange_f(rs.getBigDecimal(16));
                tran.setNote(rs.getString(17));

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
