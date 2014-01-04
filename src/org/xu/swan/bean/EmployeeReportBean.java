package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class EmployeeReportBean {

    public static final String EMP_NAME = "stylist";
    public static final String SVC_SVC_TOTAL = "service_service_total";
    public static final String SVC_SVC_TAX = "service_service_tax";
    public static final String SVC_SVC_QTY = "service_service_qty";
    public static final String PROD_PROD_TAX = "product_product_tax";
    public static final String PROD_PROD_QTY = "product_product_qty";
    public static final String PROD_PROD_TOTAL = "product_product_total";
    public static final String SVC_TOTAL_TOTAL = "ser_total_total";
    public static final String SVC_TOTAL_TAX = "ser_total_tax";
    public static final String PROD_TOTAL_TOTAL = "prod_total_total";
    public static final String PROD_TOTAL_TAXE = "prod_total_tax";
//    public static final String EMP_SALARY = "employee_salary";
    public static final String PROD_COMMISSION = "product_commission";
    public static final String SVC_COMMISSION = "service_commission";  

    private String empname;

    private BigDecimal svc_percent;
    private BigDecimal svcsvc_tax;
    private BigDecimal svc_total;
    private BigDecimal svcsvc_total;
    private BigDecimal svc_totaltax;
    private BigDecimal svc_totaltotal;

    private BigDecimal prod_percent;
    private BigDecimal prodprod_tax;
    private BigDecimal prod_total;
    private BigDecimal prodprod_total;
    private BigDecimal prod_totaltax;
    private BigDecimal prod_totaltotal;

    private BigDecimal svc_prod_subtotal;
    private BigDecimal svc_prod_taxe;
    private BigDecimal svc_prod_total;

    private BigDecimal commission_svc;
    private BigDecimal commission_prod;

    private int svcsvc_qty;
    private int prodprod_qty;
//    private BigDecimal employee_salary;

    public String getEmpname() {
        return empname;
    }

    public void setEmpname(String empname) {
        this.empname = empname;
    }

    public BigDecimal getSvc_percent() {
        return svc_percent;
    }

    public void setSvc_percent(BigDecimal svc_percent) {
        this.svc_percent = svc_percent;
    }

    public BigDecimal getSvcsvc_tax() {
        return svcsvc_tax;
    }

    public void setSvcsvc_tax(BigDecimal svcsvc_tax) {
        this.svcsvc_tax = svcsvc_tax;
    }

    public BigDecimal getSvc_total() {
        return svc_total;
    }

    public void setSvc_total(BigDecimal svc_total) {
        this.svc_total = svc_total;
    }

    public BigDecimal getSvcsvc_total() {
        return svcsvc_total;
    }

    public void setSvcsvc_total(BigDecimal svcsvc_total) {
        this.svcsvc_total = svcsvc_total;
    }

    public BigDecimal getSvc_totaltax() {
        return svc_totaltax;
    }

    public void setSvc_totaltax(BigDecimal svc_totaltax) {
        this.svc_totaltax = svc_totaltax;
    }

    public BigDecimal getSvc_totaltotal() {
        return svc_totaltotal;
    }

    public void setSvc_totaltotal(BigDecimal svc_totaltotal) {
        this.svc_totaltotal = svc_totaltotal;
    }

    public BigDecimal getProd_percent() {
        return prod_percent;
    }

    public void setProd_percent(BigDecimal prod_percent) {
        this.prod_percent = prod_percent;
    }

    public BigDecimal getProdprod_tax() {
        return prodprod_tax;
    }

    public void setProdprod_tax(BigDecimal prodprod_tax) {
        this.prodprod_tax = prodprod_tax;
    }

    public BigDecimal getProd_total() {
        return prod_total;
    }

    public void setProd_total(BigDecimal prod_total) {
        this.prod_total = prod_total;
    }

    public BigDecimal getProdprod_total() {
        return prodprod_total;
    }

    public void setProdprod_total(BigDecimal prodprod_total) {
        this.prodprod_total = prodprod_total;
    }

    public BigDecimal getProd_totaltax() {
        return prod_totaltax;
    }

    public void setProd_totaltax(BigDecimal prod_totaltax) {
        this.prod_totaltax = prod_totaltax;
    }

    public BigDecimal getProd_totaltotal() {
        return prod_totaltotal;
    }

    public void setProd_totaltotal(BigDecimal prod_totaltotal) {
        this.prod_totaltotal = prod_totaltotal;
    }

    public BigDecimal getSvc_prod_subtotal() {
        return svc_prod_subtotal;
    }

    public void setSvc_prod_subtotal(BigDecimal svc_prod_subtotal) {
        this.svc_prod_subtotal = svc_prod_subtotal;
    }

    public BigDecimal getSvc_prod_taxe() {
        return svc_prod_taxe;
    }

    public void setSvc_prod_taxe(BigDecimal svc_prod_taxe) {
        this.svc_prod_taxe = svc_prod_taxe;
    }

    public BigDecimal getSvc_prod_total() {
        return svc_prod_total;
    }

    public void setSvc_prod_total(BigDecimal svc_prod_total) {
        this.svc_prod_total = svc_prod_total;
    }

    public BigDecimal getCommission_svc() {
        return commission_svc;
    }

    public void setCommission_svc(BigDecimal commission_svc) {
        this.commission_svc = commission_svc;
    }

    public BigDecimal getCommission_prod() {
        return commission_prod;
    }

    public void setCommission_prod(BigDecimal commission_prod) {
        this.commission_prod = commission_prod;
    }

    public int getSvcsvc_qty() {
        return svcsvc_qty;
    }

    public void setSvcsvc_qty(int svcsvc_qty) {
        this.svcsvc_qty = svcsvc_qty;
    }

    public int getProdprod_qty() {
        return prodprod_qty;
    }

    public void setProdprod_qty(int prodprod_qty) {
        this.prodprod_qty = prodprod_qty;
    }

//    public BigDecimal getEmployee_salary() {
//        return employee_salary;
//    }
//
//    public void setEmployee_salary(BigDecimal employee_salary) {
//        this.employee_salary = employee_salary;
//    }

    public static ArrayList getEmpReport(String start_date, String end_date, String list_emp_id, String svc_id, String prod_id, String list_svc_id, String list_prod_id, String flag){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try
        {
            dbm = new DBManager();
            String strQuery = "CALL dashboard_emp_report('"+start_date+"','"+end_date+"','"+list_emp_id+"','"+svc_id+"','"+prod_id+"','"+list_svc_id+"','"+list_prod_id+"','"+flag+"');";
            PreparedStatement pst = dbm.getPreparedStatement(strQuery);
            ResultSet rs = pst.executeQuery();
            Double dd = 0.0;
            Double dd2 = 0.0;
            String s = "";
            BigDecimal stt = new BigDecimal(0);
            BigDecimal sttax = new BigDecimal(0);
            BigDecimal sst = new BigDecimal(0);
            BigDecimal sstax = new BigDecimal(0);
            BigDecimal ptt = new BigDecimal(0);
            BigDecimal pttax = new BigDecimal(0);
            BigDecimal ppt = new BigDecimal(0);
            BigDecimal pptax = new BigDecimal(0);
            BigDecimal pc = new BigDecimal(0);
            BigDecimal sc = new BigDecimal(0);
            while (rs.next())
            {
                EmployeeReportBean er= new EmployeeReportBean();
                list.add(er);

                s = rs.getString("stylist")!=null?rs.getString("stylist"):"";
                stt = rs.getBigDecimal("ser_total_total")!=null?rs.getBigDecimal("ser_total_total"):new BigDecimal(0);
                sttax = rs.getBigDecimal("ser_total_tax")!=null?rs.getBigDecimal("ser_total_tax"):new BigDecimal(0);
                sst = rs.getBigDecimal("service_service_total")!=null?rs.getBigDecimal("service_service_total"):new BigDecimal(0);
                sstax = rs.getBigDecimal("service_service_tax")!=null?rs.getBigDecimal("service_service_tax"):new BigDecimal(0);
                ptt = rs.getBigDecimal("prod_total_total")!= null?rs.getBigDecimal("prod_total_total"):new BigDecimal(0);
                pttax = rs.getBigDecimal("prod_total_tax")!= null?rs.getBigDecimal("prod_total_tax"):new BigDecimal(0);
                ppt = rs.getBigDecimal("product_product_total")!= null?rs.getBigDecimal("product_product_total"):new BigDecimal(0);
                pptax = rs.getBigDecimal("product_product_tax")!=null?rs.getBigDecimal("product_product_tax"):new BigDecimal(0);
                pc = rs.getBigDecimal("product_commission")!=null?rs.getBigDecimal("product_commission"):new BigDecimal(0);
                sc = rs.getBigDecimal("service_commission")!=null?rs.getBigDecimal("service_commission"):new BigDecimal(0);

                er.setEmpname(s);
                dd = (stt.add(sttax)).doubleValue();
                if (dd != 0){
                    er.setSvc_percent(new BigDecimal(((sst.add(sstax)).multiply(new BigDecimal(100))).doubleValue() / dd));
                }
                else {
                    er.setSvc_percent(new BigDecimal(0));
                }
                er.setSvcsvc_tax(sstax);
                er.setSvc_total(sst.add(sstax));
                er.setSvc_totaltax(sttax);
                er.setSvc_totaltotal(stt);
                dd2 = (ptt.add(pttax)).doubleValue();
                if (dd2 != 0){
                    er.setProd_percent(new BigDecimal(((ppt.add(pptax)).multiply(new BigDecimal(100))).doubleValue() / dd2));
                }else{
                    er.setProd_percent(new BigDecimal(0));
                }
                er.setProdprod_tax(pptax);
                er.setProd_total(ppt.add(pptax));
                er.setProd_totaltax(pttax);
                er.setProd_totaltotal(ptt);

                er.setSvc_prod_subtotal(stt.add(ptt));
                er.setSvc_prod_taxe(sttax.add(pttax));
                er.setSvc_prod_total((stt.add(sttax)).add((ptt.add(pttax))));

                er.setCommission_prod(pc);
                er.setCommission_svc(sc);

                er.setSvcsvc_qty(rs.getInt("service_service_qty"));
                er.setProdprod_qty(rs.getInt("product_product_qty"));
//                er.setEmployee_salary(rs.getBigDecimal("employee_salary"));
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
