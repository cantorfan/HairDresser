package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.ActionUtil;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TransactionCust {
    public static final String TABLE = "transaction";

    public static final String ID = "id";
    public static final String CUST = "customer_id";
    public static final String SVC = "service_id";
    public static final String PROD = "product_id";
    public static final String EMP = "employee_id";
    public static final String LOC = "location_id";
    public static final String PQTY = "prod_qty";

    private int id;
    private int customer_id;
    private int service_id;
    private int product_id;
    private int employee_id;
    private int location_id;
    private int prod_qty;

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

    public static TransactionCust insertTransaction(int user, int loc, int cust, int emp, int svc, int prod, int qty) {
        TransactionCust tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "INSERT transaction_cust (" + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + ") VALUES (?,?,?,?,?,?)";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, loc);
            pst.setInt(2, cust);
            pst.setInt(3, emp);
            pst.setInt(4, svc);
            pst.setInt(5, prod);
            pst.setInt(6, qty);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new TransactionCust();
                tran.setLocation_id(loc);
                tran.setCustomer_id(cust);
                tran.setEmployee_id(emp);
                tran.setService_id(svc);
                tran.setProduct_id(prod);
                tran.setProd_qty(qty);

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

    public static TransactionCust deleteTransaction(int user, int id) {
        TransactionCust tran = null;
        DBManager dbm = null;
        String sql = "";
        try {
            dbm = new DBManager();
            sql = "DELETE FROM transaction_cust WHERE " + ID + "=?";
            PreparedStatement pst = dbm.getPreparedStatement(sql);
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                tran = new TransactionCust();
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

    public static List<TransactionCust> findTransByLocCust(int loc, int cust) {
        List<TransactionCust> list = new ArrayList<TransactionCust>();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + CUST + "," + EMP + "," + SVC + "," + PROD + "," + PQTY + " FROM transaction_cust WHERE " + LOC + "=? AND " + CUST + "=?");
            pst.setInt(1, loc);
            pst.setInt(2, cust);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                TransactionCust tran = new TransactionCust();
                tran.setId(rs.getInt(1));
                tran.setLocation_id(rs.getInt(2));
                tran.setCustomer_id(rs.getInt(3));
                tran.setEmployee_id(rs.getInt(4));
                tran.setService_id(rs.getInt(5));
                tran.setProduct_id(rs.getInt(6));
                tran.setProd_qty(rs.getInt(7));

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