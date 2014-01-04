package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class Inventory {
    public static final String ID = "id";
    public static final String NAME = "name";
    public static final String VENDOR = "vendor_id";
    public static final String BRAND = "brand_id";
    public static final String COST = "cost_price";
    public static final String SALE = "sale_price";
    public static final String CATE = "category_id";
    public static final String TAX = "taxes";
    public static final String QTY = "qty";
    public static final String SKU = "sku";//stock keeping unit
    public static final String UPC = "upc";
    public static final String DESCRIPTION = "description";

    private int id;
    private String name;
    private int vendor_id;
    private int brand_id;
    private BigDecimal cost_price;
    private BigDecimal sale_price;
    private int category_id;
    private BigDecimal taxes;
    private int qty;
    private String sku;
    private String upc;
    private String description;

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

    public int getVendor() {
        return vendor_id;
    }

    public int getBrand() {
        return brand_id;
    }

    public void setVendor(int vendor_id) {
        this.vendor_id = vendor_id;
    }

    public void setBrand(int brand_id) {
        this.brand_id = brand_id;
    }

    public BigDecimal getCost_price() {
        return cost_price;
    }

    public void setCost_price(BigDecimal cost_price) {
        this.cost_price = cost_price;
    }

    public BigDecimal getSale_price() {
        return sale_price;
    }

    public void setSale_price(BigDecimal sale_price) {
        this.sale_price = sale_price;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public BigDecimal getTaxes() {
        return taxes;
    }

    public void setTaxes(BigDecimal taxes) {
        this.taxes = taxes;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getUpc() {
        return upc;
    }

    public void setUpc(String upc) {
        this.upc = upc;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public static Inventory insertInventory(String name,int vendor,int brand,BigDecimal cost, BigDecimal sale, int cate, BigDecimal tax, int qty, String sku, String upc, String description){
        Inventory inv = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT inventory (" + NAME + ", " + VENDOR + ", " + BRAND + ", " + COST + ", " + SALE + ", "
                     + CATE + ", " + TAX + ", " + QTY + "," + SKU + "," + UPC + "," + DESCRIPTION + ") VALUES (?,?,?,?,?,?,?,?,?,?,?)");
            pst.setString(1,name);
            pst.setInt(2,vendor);
            pst.setInt(3,brand);
            pst.setBigDecimal(4,cost);
            pst.setBigDecimal(5,sale);
            pst.setInt(6,cate);
            pst.setBigDecimal(7,tax);
            pst.setInt(8,qty);
            pst.setString(9, sku);
            pst.setString(10, upc);
            pst.setString(11, description);
            int rows = pst.executeUpdate();
            if(rows>=0){
                inv = new Inventory();
                inv.setName(name);
                inv.setVendor(vendor);
                inv.setBrand(brand);
                inv.setCost_price(cost);
                inv.setSale_price(sale);
                inv.setCategory_id(cate);
                inv.setTaxes(tax);
                inv.setQty(qty);
                inv.setSku(sku);
                inv.setUpc(upc);
                inv.setDescription(description);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    inv.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inv;
    }

    public static Inventory updateInventory(int id, String name,int vendor,int brand, BigDecimal cost, BigDecimal sale, int cate, BigDecimal tax, int qty, String sku, String upc, String description){
        Inventory inv = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE inventory SET " + NAME + "=?, " + VENDOR + "=?, " + BRAND + "=?, " + COST + "=?, " + SALE + "=?, "
                 + CATE + "=?, " + TAX + "=?, " + QTY + "=?," + SKU + "=?," + UPC +"=?," + DESCRIPTION +"=? WHERE " + ID + "=?");
            pst.setString(1,name);
            pst.setInt(2,vendor);
            pst.setInt(3,brand);
            pst.setBigDecimal(4,cost);
            pst.setBigDecimal(5,sale);
            pst.setInt(6,cate);
            pst.setBigDecimal(7,tax);
            pst.setInt(8,qty);
            pst.setString(9,sku);
            pst.setString(10,upc);
            pst.setString(11,description);
            pst.setInt(12,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                inv = new Inventory();
                inv.setId(id);
                inv.setName(name);
                inv.setVendor(vendor);
                inv.setBrand(brand);
                inv.setCost_price(cost);
                inv.setSale_price(sale);
                inv.setCategory_id(cate);
                inv.setTaxes(tax);
                inv.setQty(qty);
                inv.setSku(sku);
                inv.setUpc(upc);
                inv.setDescription(description);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inv;
    }
    public static Inventory updateInventoryQty(int id, int qty){
        Inventory inv = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE inventory SET " + QTY + "=? WHERE " + ID + "=?");
            pst.setInt(1,qty);
            pst.setInt(2,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                inv = new Inventory();
                inv.setId(id);
                inv.setQty(qty);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inv;
    }

    public static Inventory deleteInventory(int id){
        Inventory inv = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM inventory WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                inv = new Inventory();
                inv.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inv;
    }

    public static Inventory findById(int id){
        Inventory inv = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + NAME + ", " + VENDOR + ", " + BRAND + ", " + COST + ", " + SALE + ", "
                     + CATE + ", " + TAX + ", "+ QTY + "," + SKU + "," + UPC + "," + DESCRIPTION + " FROM inventory WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                inv = new Inventory();
                inv.setId(rs.getInt(1));
                inv.setName(rs.getString(2));
                inv.setVendor(rs.getInt(3));
                inv.setBrand(rs.getInt(4));
                inv.setCost_price(rs.getBigDecimal(5));
                inv.setSale_price(rs.getBigDecimal(6));
                inv.setCategory_id(rs.getInt(7));
                inv.setTaxes(rs.getBigDecimal(8));
                inv.setQty(rs.getInt(9));
                inv.setSku(rs.getString(10));
                inv.setUpc(rs.getString(11));
                inv.setDescription(rs.getString(12));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return inv;
    }

    public static ArrayList findAll(){//List<Inventory> findAll(){
        ArrayList list = new ArrayList();//List<Inventory> list = new ArrayList<Inventory>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + VENDOR + ", " + BRAND + ", " + COST + ", " + SALE + ", "
                     + CATE + ", " + TAX + ", "+ QTY + "," + SKU + "," + UPC + "," + DESCRIPTION + " FROM inventory");
            while(rs.next()){
                Inventory inv = new Inventory();
                list.add(inv);
                inv.setId(rs.getInt(1));
                inv.setName(rs.getString(2));
                inv.setVendor(rs.getInt(3));
                inv.setBrand(rs.getInt(4));
                inv.setCost_price(rs.getBigDecimal(5));
                inv.setSale_price(rs.getBigDecimal(6));
                inv.setCategory_id(rs.getInt(7));
                inv.setTaxes(rs.getBigDecimal(8));
                inv.setQty(rs.getInt(9));
                inv.setSku(rs.getString(10));
                inv.setUpc(rs.getString(11));
                inv.setDescription(rs.getString(12));
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
            ResultSet rs = st.executeQuery("SELECT count(*) FROM inventory");
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
            ResultSet rs = st.executeQuery("SELECT inv." + ID + ", inv." + NAME + ", inv." + VENDOR + ", inv." + BRAND + ", inv." + COST + ", inv." + SALE + ", inv."
                     + CATE + ", inv." + TAX + ", inv."+ QTY + ", inv." + SKU +  ", inv." + UPC + ", inv." + DESCRIPTION + " FROM inventory inv LEFT JOIN brand br on inv." + BRAND + " = br.id ORDER BY br.name,inv." + NAME + " LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                Inventory inv = new Inventory();
                list.add(inv);
                inv.setId(rs.getInt(1));
                inv.setName(rs.getString(2));
                inv.setVendor(rs.getInt(3));
                inv.setBrand(rs.getInt(4));
                inv.setCost_price(rs.getBigDecimal(5));
                inv.setSale_price(rs.getBigDecimal(6));
                inv.setCategory_id(rs.getInt(7));
                inv.setTaxes(rs.getBigDecimal(8));
                inv.setQty(rs.getInt(9));
                inv.setSku(rs.getString(10));
                inv.setUpc(rs.getString(11));
                inv.setDescription(rs.getString(12));
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

    public static ArrayList findByFilter(String filter){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ", " + NAME + ", " + VENDOR + ", " + BRAND + ", " + COST + ", " + SALE + ", "
                     + CATE + ", " + TAX + ", "+ QTY + ", " + SKU +  ", " + UPC + ", " + DESCRIPTION + " FROM inventory " + filter);
            while(rs.next()){
                Inventory inv = new Inventory();
                list.add(inv);
                inv.setId(rs.getInt(1));
                inv.setName(rs.getString(2));
                inv.setVendor(rs.getInt(3));
                inv.setBrand(rs.getInt(4));
                inv.setCost_price(rs.getBigDecimal(5));
                inv.setSale_price(rs.getBigDecimal(6));
                inv.setCategory_id(rs.getInt(7));
                inv.setTaxes(rs.getBigDecimal(8));
                inv.setQty(rs.getInt(9));
                inv.setSku(rs.getString(10));
                inv.setUpc(rs.getString(11));
                inv.setDescription(rs.getString(12));
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
    ArrayList list = new ArrayList();
    DBManager dbm = null;
        int cnt = 0;
    try{
        dbm = new DBManager();
        Statement st = dbm.getStatement();
        ResultSet rs = st.executeQuery("SELECT count(*) FROM inventory " + filter);
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
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + " FROM inventory");
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

    public static ArrayList findAllArrOrderByName(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + " FROM inventory ORDER BY "+NAME);
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

    public static ArrayList findBuyingProd(String from_date, String to_date){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("select prod.`id`, prod.`name` from `reconciliation` rec\n" +
                    "join `ticket` tic on tic.`code_transaction` = rec.`code_transaction`\n" +
                    "join `inventory` prod on prod.`id` = tic.`product_id`\n" +
                    "where rec.status <> 1 and DATE(rec.`created_dt`) BETWEEN DATE('"+from_date+"') AND DATE('"+to_date+"')\n" +
                    "group by prod.`id`  ORDER BY prod."+NAME);
            while(rs.next()){
                Inventory inv = new Inventory();
                list.add(inv);
                inv.setId(rs.getInt(1));
                inv.setName(rs.getString(2));
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
