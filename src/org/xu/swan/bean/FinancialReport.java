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

public class FinancialReport {

    public static final String VISA = "visa";
    public static final String MASTECARD = "mastercard";
    public static final String AMEX = "amex";
    public static final String CHEQUE = "cheque";
    public static final String CASHE = "cashe";
    public static final String GIFTCARD = "giftcard";
    public static final String GIFTCARD_BUY = "giftcard_buy";
    public static final String CDT = "created_dt";
    public static final String REFUND = "refund";
    public static final String PAYIN = "pay_in";
    public static final String PAYOUT = "pay_out";
    public static final String TOTAL = "total";
    public static final String IDEN = "IDEN";

    private BigDecimal visa;
    private BigDecimal mastercard;
    private BigDecimal amex;
    private BigDecimal cheque;
    private BigDecimal cashe;
    private BigDecimal giftcard;
    private BigDecimal giftcard_buy;
    private BigDecimal refund;
    private BigDecimal pay_in;
    private BigDecimal pay_out;
    private BigDecimal total;
    private String iden;

    public String getIden() {
        return iden;
    }

    public void setIden(String iden) {
        this.iden = iden;
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

    public BigDecimal getPay_in() {
        return pay_in;
    }

    public void setPay_in(BigDecimal pay_in) {
        this.pay_in = pay_in;
    }

    public BigDecimal getPay_out() {
        return pay_out;
    }

    public void setPay_out(BigDecimal pay_out) {
        this.pay_out = pay_out;
    }

    public BigDecimal getRefund() {
        return refund;
    }

    public void setRefund(BigDecimal refund) {
        this.refund = refund;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public BigDecimal getGiftcard_buy() {
        return giftcard_buy;
    }

    public void setGiftcard_buy(BigDecimal giftcard_buy) {
        this.giftcard_buy = giftcard_buy;
    }

    public static FinancialReport findFromToDate(String from_date, String to_date){
        FinancialReport fr = new FinancialReport();
        DBManager dbm = null;
        try
        {
            dbm = new DBManager();
            String strQuery;
            //strQuery = "SELECT " + VISA + "," + MASTECARD + "," + AMEX + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + PAYIN + "," + PAYOUT + "," + CDT + " FROM reconciliation ";
            strQuery = " select\n" +
                    "COALESCE(list_data.visa, 0) as 'visa',\n" +
                    "COALESCE(list_data.mastercard, 0) as 'mastercard',\n" +
                    "COALESCE(list_data.amex, 0) as 'amex',\n" +
                    "COALESCE(list_data.cashe, 0) as 'cashe',\n" +
                    "COALESCE(list_data.cheque, 0) as 'cheque',\n" +
                    "COALESCE(list_data.giftcard, 0) as 'giftcard',\n" +
                    "COALESCE(list_data.refund, 0) as 'refund',\n" +
                    "COALESCE(list_data.pay_in, 0) as 'pay_in',\n" +
                    "COALESCE(list_data.pay_out, 0) as 'pay_out',\n" +
                    "COALESCE(list_data.total, 0) as 'total',\n" +
                    "'111' as 'fake',\n" +
                    "COALESCE(list_gc.giftcard_buy, 0) as 'giftcard_buy'\n" +
                    "from \n" +
                    " (select\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.visa,\n" +
                    "            res.visa\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'visa',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.mastercard,\n" +
                    "            res.mastercard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'mastercard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.amex,\n" +
                    "            res.amex\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'amex',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -(res.cashe-res.chg),\n" +
                    "            res.cashe-res.chg\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cashe',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.cheque,\n" +
                    "            res.cheque\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cheque',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.giftcard,\n" +
                    "            res.giftcard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'giftcard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 4,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'refund',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 5,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_in',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_out',\n" +
                    "sum(if(res.`status` = 0 and res.`giftcard` = 0,\n" +
                    "         res.`total`,\n" +
                    "         0\n" +
                    ")) as 'total',\n" +
                    "'111' as 'fake'\n"+
                    "FROM reconciliation res\n" +
                    "where res.`status`<>1 and (DATE(res.`created_dt`) BETWEEN DATE('"+from_date+"') and DATE('"+to_date+"'))\n" +
                    ") list_data\n"+
                    "left join (\n" +
                    "select sum(tic.`price`) as giftcard_buy, '111' as 'fake' \n" +
                    "from `reconciliation` rec\n" +
                    "join `ticket` tic on rec.`code_transaction`=tic.`code_transaction`\n" +
                    "where (rec.`status`=0 or rec.`status`=2) and tic.`giftcard`<>'-1' and DATE(rec.`created_dt`) BETWEEN DATE('"+from_date+"')\n" +
                    "AND DATE('"+to_date+"')\n" +
                    ") list_gc\n" +
                    "on list_gc.`fake`=list_data.`fake`";


            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
//            while (rs.next())
//            {
//                FinancialReport fr= new FinancialReport();
//                list.add(fr);
            if (rs.next()){
                fr.setVisa(rs.getBigDecimal(1));
                fr.setMastercard(rs.getBigDecimal(2));
                fr.setAmex(rs.getBigDecimal(3));
                fr.setCashe(rs.getBigDecimal(4));
                fr.setCheque(rs.getBigDecimal(5));
                fr.setGiftcard(rs.getBigDecimal(6));
                fr.setRefund(rs.getBigDecimal(7));
                fr.setPay_in(rs.getBigDecimal(8));
                fr.setPay_out(rs.getBigDecimal(9));
                fr.setTotal(rs.getBigDecimal(10));
                fr.setIden(rs.getString(11));
                fr.setGiftcard_buy(rs.getBigDecimal(12));
            }
            rs.close();
            pst.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (dbm != null)
                dbm.close();
        }
        return fr;
    }

    public static ArrayList findByDay()
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try
        {
            dbm = new DBManager();
            String strQuery;
            //strQuery = "SELECT " + VISA + "," + MASTECARD + "," + AMEX + "," + CHEQUE + "," + CASHE + "," + GIFTCARD + "," + PAYIN + "," + PAYOUT + "," + CDT + " FROM reconciliation ";
            strQuery = " select\n" +
                    "COALESCE(list_data.visa, 0) as 'visa',\n" +
                    "COALESCE(list_data.mastercard, 0) as 'mastercard',\n" +
                    "COALESCE(list_data.amex, 0) as 'amex',\n" +
                    "COALESCE(list_data.cashe, 0) as 'cashe',\n" +
                    "COALESCE(list_data.cheque, 0) as 'cheque',\n" +
                    "COALESCE(list_data.giftcard, 0) as 'giftcard',\n" +
                    "COALESCE(list_data.refund, 0) as 'refund',\n" +
                    "COALESCE(list_data.pay_in, 0) as 'pay_in',\n" +
                    "COALESCE(list_data.pay_out, 0) as 'pay_out',\n" +
                    "COALESCE(list_data.total, 0) as 'total',\n" +
                    "COALESCE(DATE(list_date.date), '') as 'iden',\n" +
                    "COALESCE(list_gc.giftcard_buy, 0) as 'giftcard_buy'\n" +
                    "from (\n" +
                    "select NOW() as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -1 DAY)  as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -2 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -3 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -4 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -5 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -6 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -7 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -8 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -9 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -10 DAY) as 'date'\n" +
                    "UNION\n" +
                    "select DATE_ADD(NOW(), INTERVAL -11 DAY) as 'date'\n" +
                    ") list_date\n" +
                    "left join (select\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.visa,\n" +
                    "            res.visa\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'visa',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.mastercard,\n" +
                    "            res.mastercard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'mastercard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.amex,\n" +
                    "            res.amex\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'amex',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.cashe,\n" +
                    "            res.cashe\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cashe',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.cheque,\n" +
                    "            res.cheque\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cheque',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.giftcard,\n" +
                    "            res.giftcard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'giftcard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 4,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'refund',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 5,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_in',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_out',\n" +
                    "sum(if(res.`status` = 0 and res.`giftcard` = 0,\n" +
                    "         res.`total`,\n" +
                    "         0\n" +
                    ")) as 'total',\n" +
                    "DATE(res.`created_dt`) as 'iden'\n" +
                    "FROM reconciliation res\n" +
                    "where res.`status`<>1 and (DATE(res.`created_dt`) BETWEEN (DATE_ADD(NOW(), INTERVAL -12 DAY)) and NOW())\n" +
                    "group by EXTRACT(DAY FROM DATE(res.`created_dt`))) list_data on DATE(list_data.iden) = DATE(list_date.date)\n" +
                    "left join (select sum(gc.`startamount`) as giftcard_buy, gc.created as created from `giftcard` gc where DATE(gc.`created`) BETWEEN (DATE_ADD(NOW(), INTERVAL -12 DAY)) and NOW() group by EXTRACT(DAY FROM DATE(gc.`created`)) ) list_gc on DATE(list_gc.created)=DATE(list_date.`date`) \n"+
                    "order by DATE(list_date.date) desc ";
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
            while (rs.next())
            {
                FinancialReport fr= new FinancialReport();
                list.add(fr);
                fr.setVisa(rs.getBigDecimal(1));
                fr.setMastercard(rs.getBigDecimal(2));
                fr.setAmex(rs.getBigDecimal(3));
                fr.setCashe(rs.getBigDecimal(4));
                fr.setCheque(rs.getBigDecimal(5));                
                fr.setGiftcard(rs.getBigDecimal(6));
                fr.setRefund(rs.getBigDecimal(7));
                fr.setPay_in(rs.getBigDecimal(8));
                fr.setPay_out(rs.getBigDecimal(9));
                fr.setTotal(rs.getBigDecimal(10));
                fr.setIden(rs.getString(11));
                fr.setGiftcard_buy(rs.getBigDecimal(12));
            }
            rs.close();
            pst.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findByWeek()
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try
        {
            dbm = new DBManager();
            String strQuery;
            strQuery = "select\n" +
                    "COALESCE(list_data.visa, 0) as 'visa',\n" +
                    "COALESCE(list_data.mastercard, 0) as 'mastercard',\n" +
                    "COALESCE(list_data.amex, 0) as 'amex',\n" +
                    "COALESCE(list_data.cashe, 0) as 'cashe',\n" +
                    "COALESCE(list_data.cheque, 0) as 'cheque',\n" +
                    "COALESCE(list_data.giftcard, 0) as 'giftcard',\n" +
                    "COALESCE(list_data.refund, 0) as 'refund',\n" +
                    "COALESCE(list_data.pay_in, 0) as 'pay_in',\n" +
                    "COALESCE(list_data.pay_out, 0) as 'pay_out',\n" +
                    "COALESCE(list_data.total, 0) as 'total',\n" +
                    "COALESCE(list_date.date1, '') as 'iden',\n" +
                    "COALESCE(list_gc.giftcard_buy, 0) as 'giftcard_buy'\n" +
                    "from (\n" +
                    "select WEEKOFYEAR(NOW()) as 'date', CONCAT('Week ', WEEKOFYEAR(NOW())) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -1 WEEK))  as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -1 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -2 WEEK)) as 'date', CONCAT('Week ',  WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -2 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -3 WEEK)) as 'date', CONCAT('Week ',  WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -3 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -4 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -4 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -5 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -5 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -6 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -6 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -7 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -7 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -8 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -8 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -9 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -9 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -10 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -10 WEEK))) as 'date1'\n" +
                    "UNION\n" +
                    "select WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -11 WEEK)) as 'date', CONCAT('Week ', WEEKOFYEAR(DATE_ADD(NOW(), INTERVAL -11 WEEK))) as 'date1'\n" +
                    ") list_date\n" +
                    "left join (select\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.visa,\n" +
                    "            res.visa\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'visa',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.mastercard,\n" +
                    "            res.mastercard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'mastercard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.amex,\n" +
                    "            res.amex\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'amex',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.cashe,\n" +
                    "            res.cashe\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cashe',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.cheque,\n" +
                    "            res.cheque\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cheque',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.giftcard,\n" +
                    "            res.giftcard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'giftcard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 4,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'refund',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 5,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_in',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_out',\n" +
                    "sum(if(res.`status` = 0 and res.`giftcard` = 0,\n" +
                    "         res.`total`,\n" +
                    "         0\n" +
                    ")) as 'total',\n" +
                    "WEEKOFYEAR(DATE(res.`created_dt`)) as 'iden'\n" +
                    "FROM reconciliation res\n" +
                    "where res.`status`<>1 and (DATE(res.`created_dt`) BETWEEN (DATE_ADD(NOW(), INTERVAL -14 WEEK)) and NOW())\n" +
                    "group by WEEKOFYEAR(DATE(res.`created_dt`))) list_data on list_data.iden = list_date.date\n" +
                    "left join (select sum(gc.`startamount`) as giftcard_buy, gc.created as created from `giftcard` gc where DATE(gc.`created`) BETWEEN (DATE_ADD(NOW(), INTERVAL -14 WEEK)) and NOW() group by WEEKOFYEAR(DATE(gc.`created`)) ) list_gc on WEEKOFYEAR(DATE(list_gc.`created`))=list_date.`date` \n"+
                    "order by list_date.date desc ";
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
            while (rs.next())
            {
                FinancialReport fr= new FinancialReport();
                list.add(fr);
                fr.setVisa(rs.getBigDecimal(1));
                fr.setMastercard(rs.getBigDecimal(2));
                fr.setAmex(rs.getBigDecimal(3));
                fr.setCashe(rs.getBigDecimal(4));
                fr.setCheque(rs.getBigDecimal(5));                
                fr.setGiftcard(rs.getBigDecimal(6));
                fr.setRefund(rs.getBigDecimal(7));
                fr.setPay_in(rs.getBigDecimal(8));
                fr.setPay_out(rs.getBigDecimal(9));
                fr.setTotal(rs.getBigDecimal(10));
                fr.setIden(rs.getString(11));
                fr.setGiftcard_buy(rs.getBigDecimal(12));
            }
            rs.close();
            pst.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findByMounth()
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try
        {
            dbm = new DBManager();
            String strQuery;
            strQuery = "select\n" +
                    "COALESCE(list_data.visa, 0) as 'visa',\n" +
                    "COALESCE(list_data.mastercard, 0) as 'mastercard',\n" +
                    "COALESCE(list_data.amex, 0) as 'amex',\n" +
                    "COALESCE(list_data.cashe, 0) as 'cashe',\n" +
                    "COALESCE(list_data.cheque, 0) as 'cheque',\n" +
                    "COALESCE(list_data.giftcard, 0) as 'giftcard',\n" +
                    "COALESCE(list_data.refund, 0) as 'refund',\n" +
                    "COALESCE(list_data.pay_in, 0) as 'pay_in',\n" +
                    "COALESCE(list_data.pay_out, 0) as 'pay_out',\n" +
                    "COALESCE(list_data.total, 0) as 'total',\n" +
                    "if(list_date.date = 1, 'January',\n" +
                    "if(list_date.date = 2, 'February',\n" +
                    "if(list_date.date = 3, 'March',\n" +
                    "if(list_date.date = 4, 'April',\n" +
                    "if(list_date.date = 5, 'May',\n" +
                    "if(list_date.date = 6, 'June',\n" +
                    "if(list_date.date = 7, 'July',\n" +
                    "if(list_date.date = 8, 'August',\n" +
                    "if(list_date.date = 9, 'September',\n" +
                    "if(list_date.date = 10, 'October',\n" +
                    "if(list_date.date = 11, 'November',\n" +
                    "if(list_date.date = 12, 'December', '')))))))))))) as 'iden',\n" +
                    "COALESCE(list_gc.giftcard_buy, 0) as 'giftcard_buy'\n" +
                    "from (\n" +
                    "select EXTRACT(MONTH FROM NOW()) as 'date', EXTRACT(YEAR_MONTH FROM NOW()) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -1 MONTH))   as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -1 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -2 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -2 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -3 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -3 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -4 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -4 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -5 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -5 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -6 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -6 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -7 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -7 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -8 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -8 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -9 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -9 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -10 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -10 MONTH)) as 'year'\n" +
                    "UNION\n" +
                    "select EXTRACT(MONTH FROM DATE_ADD(NOW(), INTERVAL -11 MONTH))  as 'date', EXTRACT(YEAR_MONTH FROM DATE_ADD(NOW(), INTERVAL -11 MONTH)) as 'year'\n" +
                    ") list_date\n" +
                    "left join (select\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.visa,\n" +
                    "            res.visa\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'visa',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.mastercard,\n" +
                    "            res.mastercard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'mastercard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.amex,\n" +
                    "            res.amex\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'amex',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.cashe,\n" +
                    "            res.cashe\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cashe',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.cheque,\n" +
                    "            res.cheque\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'cheque',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3 or res.`status` = 4,\n" +
                    "            -res.giftcard,\n" +
                    "            res.giftcard\n" +
                    "        ),\n" +
                    "        0\n" +
                    "  )) as 'giftcard',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 4,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'refund',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 5,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_in',\n" +
                    "sum(if(res.`status` <> 2 and res.`status` <> 6,\n" +
                    "    if(res.`status` = 3,\n" +
                    "            res.`total`,\n" +
                    "            0\n" +
                    "        ),\n" +
                    "        0\n" +
                    ")) as 'pay_out',\n" +
                    "sum(if(res.`status` = 0 and res.`giftcard` = 0,\n" +
                    "         res.`total`,\n" +
                    "         0\n" +
                    ")) as 'total',\n" +
                    "EXTRACT(MONTH FROM DATE(res.`created_dt`)) as 'iden'\n" +
                    "FROM reconciliation res\n" +
//                    "where res.`status`<>1 and (DATE(res.`created_dt`) BETWEEN (DATE_ADD(NOW(), INTERVAL -12 MONTH)) and NOW())\n" +
                    "where res.`status`<>1 and (DATE(res.`created_dt`) BETWEEN (LAST_DAY(NOW()) + INTERVAL 1 DAY - INTERVAL 12 MONTH) and (DATE_ADD(LAST_DAY(NOW()), INTERVAL 1 DAY)))\n" +
                    "group by EXTRACT(MONTH FROM DATE(res.`created_dt`))) list_data on list_data.iden = list_date.date\n" +
//                    "left join (select sum(gc.`startamount`) as giftcard_buy, gc.created as created from `giftcard` gc where DATE(gc.`created`) BETWEEN (DATE_ADD(NOW(), INTERVAL -12 MONTH)) and NOW() group by EXTRACT(MONTH FROM DATE(gc.`created`)) ) list_gc on EXTRACT(MONTH FROM DATE(list_gc.`created`))=list_date.`date` \n"+
                    "left join (select sum(gc.`startamount`) as giftcard_buy, gc.created as created from `giftcard` gc where DATE(gc.`created`) BETWEEN (LAST_DAY(NOW()) + INTERVAL 1 DAY - INTERVAL 12 MONTH) and (DATE_ADD(LAST_DAY(NOW()), INTERVAL 1 DAY)) group by EXTRACT(MONTH FROM DATE(gc.`created`)) ) list_gc on EXTRACT(MONTH FROM DATE(list_gc.`created`))=list_date.`date` \n"+
                    "order by list_date.year desc";
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
            while (rs.next())
            {
                FinancialReport fr= new FinancialReport();
                list.add(fr);
                fr.setVisa(rs.getBigDecimal(1));
                fr.setMastercard(rs.getBigDecimal(2));
                fr.setAmex(rs.getBigDecimal(3));
                fr.setCashe(rs.getBigDecimal(4));
                fr.setCheque(rs.getBigDecimal(5));                
                fr.setGiftcard(rs.getBigDecimal(6));
                fr.setRefund(rs.getBigDecimal(7));
                fr.setPay_in(rs.getBigDecimal(8));
                fr.setPay_out(rs.getBigDecimal(9));
                fr.setTotal(rs.getBigDecimal(10));
                fr.setIden(rs.getString(11));
                fr.setGiftcard_buy(rs.getBigDecimal(12));
            }
            rs.close();
            pst.close();
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }
}