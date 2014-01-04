package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.TransactionCodeGenerator;
import org.apache.log4j.LogManager;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Ticket {
    public static final String TABLE = "ticket";

    public static final String ID = "id";
    public static final String LOC = "location_id";
    public static final String CODE_TRANS = "code_transaction";
    public static final String EMP = "employee_id";
    public static final String PROD = "product_id";
    public static final String SVC = "service_id";
    public static final String QTY = "qty";
    public static final String DISCOUNT = "discount";
    public static final String PRICE = "price";
    public static final String TAXE = "taxe";
//    public static final String AMEX = "amex";
//    public static final String VISA = "visa";
//    public static final String MASTECARD = "mastercard";
//    public static final String CHEQUE = "cheque";
//    public static final String CASHE = "cashe";
//    public static final String GIFTCARD = "giftcard";
//    public static final String CHANGE = "change";
    public static final String STATUS = "status";
    public static final String GIFTCARD = "giftcard";
    public static final String REFTRANS = "refundtrans_id";

    private int id;
    private int location_id;
    private String code_transaction;
    private int employee_id;
    private int product_id;
    private int service_id;
    private int qty;
    private int discount;
    private BigDecimal price;
    private BigDecimal taxe;
    private int status;
    private String giftcard;
    private int refundtrans_id;

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

    public String getCode_transaction() {
        return code_transaction;
    }

    public void setCode_transaction(String code_transaction) {
        this.code_transaction = code_transaction;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getService_id() {
        return service_id;
    }

    public void setService_id(int service_id) {
        this.service_id = service_id;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getTaxe() {
        return taxe;
    }

    public void setTaxe(BigDecimal taxe) {
        this.taxe = taxe;
    }

    public String getGiftcard() {
        return giftcard;
    }

    public void setGiftcard(String giftcard) {
        this.giftcard = giftcard;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getRefundtrans_id() {
        return refundtrans_id;
    }

    public void setRefundtrans_id(int refundtrans_id) {
        this.refundtrans_id = refundtrans_id;
    }

    public static Ticket insertTicket(int user, int loc, String code_trans, int emp, int prod, int svc, int qty, int disc, BigDecimal price,BigDecimal taxe,  int status, String giftcard) {
        Ticket tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "INSERT " + TABLE +" (" + LOC + "," + CODE_TRANS + "," + EMP + "," + PROD + "," + SVC + "," + QTY + "," + DISCOUNT + "," + PRICE + "," + TAXE + ","  + STATUS + ","  + GIFTCARD + ") VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setString(2, code_trans);
            pst.setInt(3, emp);
            pst.setInt(4, prod);
            pst.setInt(5, svc);
            pst.setInt(6, qty);
            pst.setInt(7, disc);
            pst.setBigDecimal(8, price);
            pst.setBigDecimal(9, taxe);
            pst.setInt(10, status);
            pst.setString(11, giftcard);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Ticket();
                tran.setLocation_id(loc);
                tran.setCode_transaction(code_trans);
                tran.setEmployee_id(emp);
                tran.setProduct_id(prod);
                tran.setService_id(svc);
                tran.setQty(qty);
                tran.setDiscount(disc);
                tran.setPrice(price);
                tran.setTaxe(taxe);
                tran.setStatus(status);
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

     public static Ticket updateTicket(int user, int id, int loc, String code_trans, int emp, int prod, int svc, int qty, int disc, BigDecimal price, BigDecimal taxe,  int status,  String giftcard, int refundtrans_id) {
        Ticket tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "UPDATE " + TABLE + " SET " + LOC + "=?," + CODE_TRANS + "=?," + EMP + "=?," + PROD + "=?," + SVC + "=?," + QTY + "=?," + DISCOUNT + "=?," + PRICE + "=?," + TAXE + "=?," + STATUS + "=?," + GIFTCARD + "=?," + REFTRANS + "=? WHERE " + ID + "=?";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setString(2, code_trans);
            pst.setInt(3, emp);
            pst.setInt(4, prod);
            pst.setInt(5, svc);
            pst.setInt(6, qty);
            pst.setInt(7, disc);
            pst.setBigDecimal(8, price);
            pst.setBigDecimal(9, taxe);
            pst.setInt(10, status);
            pst.setString(11, giftcard);
            pst.setInt(12, refundtrans_id);
            pst.setInt(13, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Ticket();
                tran.setId(id);
                tran.setLocation_id(loc);
                tran.setCode_transaction(code_trans);
                tran.setEmployee_id(emp);
                tran.setProduct_id(prod);
                tran.setService_id(svc);
                tran.setQty(qty);
                tran.setDiscount(disc);
                tran.setPrice(price);
                tran.setTaxe(taxe);

                tran.setStatus(status);
                tran.setGiftcard(giftcard);
                tran.setRefundtrans_id(refundtrans_id);
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

    public static Ticket updateTicketCodeTrans(int id, String code_trans) {
        Ticket tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "UPDATE " + TABLE + " SET " + CODE_TRANS + "=? WHERE " + ID + "=?";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setString(1, code_trans);
            pst.setInt(2, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Ticket();
                tran.setId(id);
                tran.setCode_transaction(code_trans);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return tran;
    }

    public static Ticket updateTicketSetEmpId(int idTick, int idEmp){
        Ticket ticket = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE " + TABLE + " SET " + EMP + "=? WHERE " + ID + "=?");
            pst.setInt(1,idEmp);
            pst.setInt(2,idTick);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ticket = new Ticket();
                ticket.setEmployee_id(idEmp);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ticket;
    }

    public static Ticket updateTicketStatusRefund(int idTick, int status, int reftrans_id){
        Ticket ticket = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE " + TABLE + " SET " + STATUS + "=?," + REFTRANS +"=? WHERE " + ID + "=?");
            pst.setInt(1,status);
            pst.setInt(2,reftrans_id);
            pst.setInt(3,idTick);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ticket = new Ticket();
                ticket.setStatus(status);
                ticket.setRefundtrans_id(reftrans_id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ticket;
    }

    public static Ticket updateTicketValues(int id, int discount, BigDecimal price, int qty, BigDecimal taxe){
        Ticket ticket = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE "+TABLE+" SET "+QTY+"=?, "+DISCOUNT+"=?, "+PRICE+"=?, "+TAXE+"=? WHERE "+ID+"=?");
            pst.setInt(1, qty);
            pst.setInt(2, discount);
            pst.setBigDecimal(3, price);
            pst.setBigDecimal(4, taxe);
            pst.setInt(5, id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ticket = new Ticket();
                ticket.setId(id);
                ticket.setQty(qty);
                ticket.setDiscount(discount);
                ticket.setPrice(price);
                ticket.setTaxe(taxe);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ticket;
    }

    public static Ticket deleteTicket(int user, int id) {
        Ticket tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "DELETE FROM " + TABLE + " WHERE " + ID + "=?";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new Ticket();
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

    public static ArrayList findTicketByLocCustomer(int loc, int customerId) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement(
                    "SELECT t." + ID + ",t." + LOC + ",t." + CODE_TRANS + ",t." + EMP + ",t."
                            + PROD + ",t." + SVC + ",t." + QTY + ",t." + DISCOUNT + ",t."
                            + PRICE + ",t."+ TAXE + ",t." + STATUS + ",t." + GIFTCARD + ",t." + REFTRANS + " FROM "
                            + TABLE  + " t right join reconciliation r on t.code_transaction=r.code_transaction "+
                            "WHERE t." + LOC + "=? AND r.id_customer=? AND t.status <> 4");
            pst.setInt(1, loc);
            pst.setInt(2, customerId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Ticket tran = new Ticket();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setProduct_id(rs.getInt(5));
                tran.setService_id(rs.getInt(6));
                tran.setQty(rs.getInt(7));
                tran.setDiscount(rs.getInt(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setTaxe(rs.getBigDecimal(10));
                tran.setStatus(rs.getInt(11));
                tran.setGiftcard(rs.getString(12));
                tran.setRefundtrans_id(rs.getInt(13));

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


    public static ArrayList findTicketByLocCodeTrans(int loc, String code_trans) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CODE_TRANS + "," + EMP + "," + PROD + "," + SVC + "," + QTY + "," + DISCOUNT + "," + PRICE + ","+ TAXE + "," + STATUS + "," + GIFTCARD + "," + REFTRANS + " FROM " + TABLE  + " WHERE " + LOC + "=? AND " + CODE_TRANS + "=? ORDER BY " + STATUS + " DESC");
            pst.setInt(1, loc);
            pst.setString(2, code_trans);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Ticket tran = new Ticket();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setProduct_id(rs.getInt(5));
                tran.setService_id(rs.getInt(6));
                tran.setQty(rs.getInt(7));
                tran.setDiscount(rs.getInt(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setTaxe(rs.getBigDecimal(10));
                tran.setStatus(rs.getInt(11));
                tran.setGiftcard(rs.getString(12));
                tran.setRefundtrans_id(rs.getInt(13));

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

    public static ArrayList findTicketByFilter(String filter) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CODE_TRANS + "," + EMP + "," + PROD + "," + SVC + "," + QTY + "," + DISCOUNT + "," + PRICE + ","+ TAXE + "," + STATUS + "," + GIFTCARD + "," + REFTRANS + " FROM " + TABLE  + filter);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                Ticket tran = new Ticket();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setProduct_id(rs.getInt(5));
                tran.setService_id(rs.getInt(6));
                tran.setQty(rs.getInt(7));
                tran.setDiscount(rs.getInt(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setTaxe(rs.getBigDecimal(10));
                tran.setStatus(rs.getInt(11));
                tran.setGiftcard(rs.getString(12));
                tran.setRefundtrans_id(rs.getInt(13));

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

    public static Ticket findTicketById(int id) {
        Ticket tran = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CODE_TRANS + "," + EMP + "," + PROD + "," + SVC + "," + QTY + "," + DISCOUNT + "," + PRICE + ","+ TAXE + "," + STATUS + "," + GIFTCARD + "," + REFTRANS + " FROM " + TABLE  + " WHERE " + ID + "=? ");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                tran = new Ticket();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCode_transaction(rs.getString(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setProduct_id(rs.getInt(5));
                tran.setService_id(rs.getInt(6));
                tran.setQty(rs.getInt(7));
                tran.setDiscount(rs.getInt(8));
                tran.setPrice(rs.getBigDecimal(9));
                tran.setTaxe(rs.getBigDecimal(10));
                tran.setStatus(rs.getInt(11));
                tran.setGiftcard(rs.getString(12));
                tran.setRefundtrans_id(rs.getInt(13));

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
    public static Ticket findTicketPriceById(int id) {
        Ticket tran = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("select ((tic.`price`*tic.`qty`)*(1 - tic.`discount`/100))+(tic.`taxe`*tic.`qty`) as 'price'\n" +
                    "from `ticket` tic  WHERE tic.id=? ");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                tran = new Ticket();
                tran.setPrice(rs.getBigDecimal(1));
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
}