package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.dashboard.*;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class AppointmentWithProduct {

    private int id;
    private int customer_id;
    private int employee_id;
    private int location_id;
    private int service_id;
    private int category_id;
    private int ticket_id;
    private BigDecimal price;
    private Date app_dt;
    private Time st_time;
    private Time et_time;
    private int state = 0;
    private String comment;
    private Boolean request = false;
    private String code_transaction;
    private String product_name;

    public Boolean getRequest() {
        return request;
    }

    public void setRequest(Boolean request) {
        this.request = request;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public int getLocation_id() {
        return location_id;
    }

    public void setLocation_id(int location_id) {
        this.location_id = location_id;
    }

    public int getService_id() {
        return service_id;
    }

    public void setService_id(int service_id) {
        this.service_id = service_id;
    }

    public int getTicket_id() {
        return ticket_id;
    }

    public void setTicket_id(int ticket_id) {
        this.ticket_id = ticket_id;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Date getApp_dt() {
        return app_dt;
    }

    public void setApp_dt(Date app_dt) {
        this.app_dt = app_dt;
    }

    public Time getSt_time() {
        return st_time;
    }

    public void setSt_time(Time st_time) {
        this.st_time = st_time;
    }

    public Time getEt_time() {
        return et_time;
    }

    public void setEt_time(Time et_time) {
        this.et_time = et_time;
    }

    public int getState() {
    	return this.state;
    }

    public void setState(int newState) {
    	this.state = newState;
    }

     public String getComment() {
    	return this.comment;
    }

    public void setComment(String comment) {
    	this.comment = comment;
    }

    public String getCode_transaction() {
        return code_transaction;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setCode_transaction(String code_transaction) {
        this.code_transaction = code_transaction;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public static ArrayList findByCustId(int cust_id){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();

            Statement st = dbm.getStatement();
            String query = "select * from (\n" +
                    "    select app.id,\n" +
                    "        app.customer_id,\n" +
                    "        app.employee_id,\n" +
                    "        app.location_id,\n" +
                    "        app.service_id,\n" +
                    "        app.category_id,\n" +
                    "        COALESCE((tic.`price`*tic.`qty`)*(1 - tic.`discount`/100)+tic.`taxe`,app.price) as 'price',\n" +
                    "        app.appt_date,\n" +
                    "        app.st_time,\n" +
                    "        app.et_time,\n" +
                    "        app.state,\n" +
                    "        app.comment,\n" +
                    "        app.request,\n" +
                    "        app.ticket_id,\n" +
                    "        tic.`code_transaction`,\n" +
                    "        COALESCE(if(tic.`service_id` = 0, inv.`name`, null),'') as 'product_name'\n" +
                    "        from appointment app\n" +
                    "        left join `ticket` tic on tic.`id` = app.`ticket_id`\n" +
                    "        left join `inventory` inv on inv.`id` = tic.`product_id`\n" +
                    "        where customer_id = ?\n" +
                    "    UNION\n" +
                    "    select\n" +
                    "        0 as 'id',\n" +
                    "        rec.`id_customer` as 'customer_id',\n" +
                    "        tic.`employee_id` as 'employee_id',\n" +
                    "        1 as 'location_id',\n" +
                    "        0 as 'service_id',\n" +
                    "        0 as 'category_id',\n" +
                    "        (tic.`price`*tic.`qty`)*(1 - tic.`discount`/100)+tic.`taxe`as 'price',\n" +
                    "        rec.`created_dt` as 'appt_date',\n" +
                    "        TIME('00:00:00') as 'st_time',\n" +
                    "        TIME('00:00:00') as 'et_time',\n" +
                    "        1 as 'state',\n" +
                    "        '' as 'comment',\n" +
                    "        0 as 'request',\n" +
                    "        tic.`id` as 'ticket_id',\n" +
                    "        tic.`code_transaction`,\n" +
                    "        inv.`name` as 'product_name'\n" +
                    "    from ticket tic\n" +
                    "    left join `inventory` inv on inv.id = tic.`product_id`\n" +
                    "    left join `reconciliation` rec on rec.`code_transaction` = tic.`code_transaction`\n" +
                    "    where tic.id in\n" +
                    "    (\n" +
                    "      select id from `ticket` where service_id = 0 and code_transaction in\n" +
                    "      (\n" +
                    "          select distinct code_transaction\n" +
                    "          from ticket tic\n" +
                    "              inner join appointment app on app.ticket_id = tic.id and app.customer_id = ?\n" +
                    "          where\n" +
                    "              app.ticket_id is not null\n" +
                    "        )\n" +
                    "    )\n" +
                    "    ) asd\n" +
                    "     order by appt_date, st_time, et_time ASC;";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setInt(1,cust_id);
            pst.setInt(2,cust_id);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                AppointmentWithProduct appt = new AppointmentWithProduct();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setCustomer_id(rs.getInt(2));
                appt.setEmployee_id(rs.getInt(3));
                appt.setLocation_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setRequest(rs.getBoolean(13));
                appt.setTicket_id(rs.getInt(14));
                appt.setCode_transaction(rs.getString(15));
                appt.setProduct_name(rs.getString(16));                
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
