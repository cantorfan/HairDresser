package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class SalariesAndStatisticBean
{
    public static final String FL_NAME_E = "flNameEmp";
    public static final String SUM_TOTAL = "sum_total";
    public static final String SUM_TAXE = "sum_taxe";
    public static final String NET_SALE = "net_sale";
    public static final String COMMISSION = "commission";


    private String flNameEmp;
    private BigDecimal sum_total;
    private BigDecimal sum_taxe;
    private BigDecimal net_sale;
    private BigDecimal commission;

    public String getFlNameEmp() {
        return flNameEmp;
    }

    public BigDecimal getSum_total() {
        return sum_total;
    }

    public BigDecimal getSum_taxe() {
        return sum_taxe;
    }

    public BigDecimal getNet_sale() {
        return net_sale;
    }

    public BigDecimal getCommission() {
        return commission;
    }

    public void setFlNameEmp(String flNameEmp) {
        this.flNameEmp = flNameEmp;
    }


    public void setSum_total(BigDecimal sum_total) {
        this.sum_total = sum_total;
    }

    public void setSum_taxe(BigDecimal sum_taxe) {
        this.sum_taxe = sum_taxe;
    }

    public void setNet_sale(BigDecimal net_sale) {
        this.net_sale = net_sale;
    }

    public void setCommission(BigDecimal commission) {
        this.commission = commission;
    }

    public static ArrayList findToEmployAndDate(String start_date, String end_date, int id_employ, int offset, int count)
    {
        ArrayList list = new ArrayList();//List<Inventory> list = new ArrayList<Inventory>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            String query ="select\n" +
                    "COALESCE(CONCAT(em.`fname`,\" \",em.`lname`), \"\") as flNameEmp,\n" +
                    "SUM(if(tic.`status` = 4 or tic.`status` = 3,\n" +
                    "    -(tic.`price`*tic.`qty`)*(1 - tic.`discount`/100),\n" +
                    "    (tic.`price`*tic.`qty`)*(1 - tic.`discount`/100)\n" +
                    "  )) as sum_total,\n" +
                    "SUM(if(rec.status = 3 or rec.status = 4,\n" +
                    "          -rec.taxe,\n" +
                    "          rec.taxe\n" +
                    "       )) as 'sum_taxe',\n" +
                    "SUM(if (rec.status <> 3 and rec.status <> 5,\n" +
                    "            if(rec.status = 4,\n" +
                    "                -(tic.`price`*tic.`qty`)*(1 - tic.`discount`/100),\n" +
                    "                (tic.`price`*tic.`qty`)*(1 - tic.`discount`/100)\n" +
                    "            ),\n" +
                    "            0\n" +
                    "        )\n" +
                    ") as 'net_sale',\n" +
                    "(1 - COALESCE(em.`commission`,0)/100) as commission\n" +
                    "from `ticket` tic\n" +
                    "left join `employee`em on em.`id` = tic.`employee_id`\n" +
                    "left join `reconciliation` rec on rec.`code_transaction` = tic.`code_transaction`\n" +
                    "where rec.`status` not in (2,6) and ";
            if(id_employ > 0)
                query = query + "tic.`employee_id` = ? and\n";
            query = query + "DATE(rec.`created_dt`) BETWEEN DATE(?) and DATE(?)\n" +
            "group by flNameEmp";

            PreparedStatement pst = dbm.getPreparedStatement(query);
            int i = 0;
            if(id_employ > 0)
            {
                pst.setInt(1,id_employ);
                i++;
            }
            pst.setString(1+i,start_date);
            pst.setString(2+i,end_date);
            ResultSet rs = pst.executeQuery();

            while(rs.next()){
                SalariesAndStatisticBean sas = new SalariesAndStatisticBean();
                list.add(sas);
                sas.setFlNameEmp(rs.getString(1));
                sas.setSum_total(rs.getBigDecimal(2));
                sas.setSum_taxe(rs.getBigDecimal(3));
                sas.setNet_sale(rs.getBigDecimal(4));
                sas.setCommission(rs.getBigDecimal(5));
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
