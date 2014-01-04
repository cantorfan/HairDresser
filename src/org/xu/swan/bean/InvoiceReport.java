package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class InvoiceReport {
    public static final String FL_NAME_E = "flNameEmp";
    public static final String CODE_TRANSACTION = "code_transaction";
    public static final String QTY = "qty";
    public static final String PRICE = "price";
    public static final String TAXE = "taxe";
    public static final String NAME_SERV = "name";
    public static final String DISCOUNT = "discount";
    public static final String TOTALPRICE = "TotalPrice";

    private String flNameEmp;
    private String code_transaction;
    private int qty;
    private BigDecimal price;
    private BigDecimal taxe;
    private String name;
    private BigDecimal  discount;
    private BigDecimal TotalPrice;

    public String getFlNameEmp() {
        return flNameEmp;
    }

    public String getCode_transaction() {
        return code_transaction;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public BigDecimal getTaxe() {
        return taxe;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public BigDecimal getTotalPrice() {
        return TotalPrice;
    }

    public int getQty() {
        return qty;
    }

    public String getName() {
        return name;
    }

    public void setFlNameEmp(String flNameEmp) {
        this.flNameEmp = flNameEmp;
    }

    public void setCode_transaction(String code_transaction) {
        this.code_transaction = code_transaction;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public void setTaxe(BigDecimal taxe) {
        this.taxe = taxe;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        TotalPrice = totalPrice;
    }

    public static ArrayList findToEmployAndDate(String cur_date, int id_employ, int interval, int offset, int count)
    {
        ArrayList list = new ArrayList();//List<Inventory> list = new ArrayList<Inventory>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();            
            String query =" SELECT  COALESCE(CONCAT(em.`fname`,\" \",em.`lname`), \"\") as 'flNameEmp',\n" +
                    "res.`code_transaction`,\n" +
                    "CONVERT(tic.`qty`, SIGNED) as 'qty' , tic.`price`, tic.`taxe`,\n" +
                    "COALESCE(inv.`name`, ser.`name`) as 'name',\n" +
                    "tic.`discount`,CONVERT((tic.`price` - tic.`price`*(tic.`discount`/100)), DECIMAL(10,3)) as 'TotalPrice'\n" +
                    "FROM reconciliation res\n" +
                    "left join `ticket` tic on tic.`code_transaction` = res.`code_transaction`\n" +
                    "left join `employee`em on em.`id` = tic.`employee_id`\n" +
                    "left join inventory inv on inv.id = tic.`product_id`\n" +
                    "left join service ser on ser.id = tic.service_id\n" +
                    "left join location loc on loc.`id` = em.`location_id`\n" +
                    "where ISNULL(tic.`id`)  = 0 and\n" +
                    "res.id_location=1 AND res.status != 1 AND DATE(res.Created_dt) between  (DATE_ADD(DATE(?), INTERVAL -? DAY)) and DATE(?)\n";
                    if(id_employ != 0)
                        query = query + "and em.id = ? \n";
                    query = query + "order by flNameEmp \n" +
                    "LIMIT ?,?";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setString(1,cur_date);
            pst.setInt(2,interval);
            pst.setString(3,cur_date);
            if(id_employ != 0)
            {
                pst.setInt(4,id_employ);
                pst.setInt(5,offset);
                pst.setInt(6,count);
            }
            else
            {
                pst.setInt(4,offset);
                pst.setInt(5,count);                
            }
            ResultSet rs = pst.executeQuery();

            while(rs.next()){
                InvoiceReport invRep = new InvoiceReport();
                list.add(invRep);
                invRep.setFlNameEmp(rs.getString(1));
                invRep.setCode_transaction(rs.getString(2));
                invRep.setQty(rs.getInt(3));
                invRep.setPrice(rs.getBigDecimal(4));
                invRep.setTaxe(rs.getBigDecimal(5));
                invRep.setName(rs.getString(6));
                invRep.setDiscount(rs.getBigDecimal(7));
                invRep.setTotalPrice(rs.getBigDecimal(8));
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
