package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.dashboard.*;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class AppointmentHistory {
    public static final String APPID = "id";
    public static final String APPDT = "date";
    public static final String EMP = "emp_name";
    public static final String SVC = "serv_name";
    public static final String PROD = "prod_name";
    public static final String PRICE = "price";
    public static final String TIME = "time";
    public static final String COMMENT = "comment";
    public static final String CUST_COMMENT = "cust_comment";
    public static final String STATE = "state";
    public static final String TICKETID = "ticket_id";

    private int id;
    private Date app_dt;
    private String employee;
    private String service;
    private String product;
    private BigDecimal price;
    private Time time;
    private String comment;
    private String cust_comment;
    private int state;
    private Boolean request = false;
    private int ticket_id;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getApp_dt() {
        return app_dt;
    }

    public void setApp_dt(Date app_dt) {
        this.app_dt = app_dt;
    }

    public String getEmployee() {
        return employee;
    }

    public void setEmployee(String employee) {
        this.employee = employee;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Time getTime() {
        return time;
    }

    public void setTime(Time time) {
        this.time = time;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getCust_comment() {
        return cust_comment;
    }

    public void setCust_comment(String cust_comment) {
        this.cust_comment = cust_comment;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public Boolean getRequest() {
        return request;
    }

    public void setRequest(Boolean request) {
        this.request = request;
    }

    public int getTicket_id() {
        return ticket_id;
    }

    public void setTicket_id(int ticket_id) {
        this.ticket_id = ticket_id;
    }

    public static ArrayList findHistoryByCustomerId(int cust_id){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();/*
            ResultSet rs = st.executeQuery("select\n" +
                    "      app.`id` as 'id',\n" +
                    "      app.`appt_date` as 'date',\n" +
                    "      COALESCE(if(emp.`id` is NULL, 'none', CONCAT(emp.`fname`, \" \",emp.`lname`)),'') as 'emp_name',\n" +
                    "      COALESCE(if(serv.`id` is NULL, '', serv.`name`),'') as 'serv_name',\n" +
                    "      COALESCE(if(prod.`id` is NULL, if(serv.`id` is NULL, if(tic.`status` = 1, CONCAT('Reload GiftCard# ',tic.`giftcard`), CONCAT('New GiftCard# ',tic.`giftcard`)), ''), prod.`name`),'') as 'prod_name',\n" +
                    "      COALESCE((tic.`price`*tic.`qty`)*(1 - tic.`discount`/100)+tic.`taxe`,app.price) as 'price',\n" +
                    "      app.`st_time` as 'time',\n" +
                    "      app.`comment` as 'comment',\n" +
                    "      cust.`comment` as 'cust_comment',\n" +
                    "      app.`state` as 'state',\n" +
                    "      app.`request` as 'request',\n" +
                    "      app.`ticket_id` as 'ticket_id'" +
                    "\n" +
                    "from `appointment` app\n" +
                    "INNER JOIN `customer` cust on cust.`id` = app.`customer_id`\n" +
                    "LEFT JOIN `employee` emp on emp.`id` = app.`employee_id`\n" +
                    "LEFT JOIN `ticket` tic on tic.`id` = app.`ticket_id`\n" +
                    //"LEFT JOIN `ticket` tic on tic.`code_transaction` = (select t.`code_transaction` from `ticket` t where t.`id` = app.`ticket_id`)\n" +
                    //"LEFT JOIN `service` serv on serv.`id` = tic.`service_id`\n" +
                    "LEFT JOIN `service` serv on serv.`id` = app.`service_id`\n" +
                    "LEFT JOIN `inventory` prod on prod.`id` = tic.`product_id`\n" +
                    "\n" +
                    "where app.`customer_id` = '"+cust_id+"' order by app.`appt_date`");*/
//            ResultSet rs = st.executeQuery("select \n" +
//                    "arr.`id` as 'id',\n" +
//                    "arr.`date` as 'date',\n" +
//                    "arr.`emp_name` as 'emp_name',\n" +
//                    "COALESCE(if(serv.`id` is NULL, '', serv.`name`),'') as 'serv_name',\n" +
//                    "COALESCE(if(prod.`id` is NULL, if(serv.`id` is NULL, if(tick.`status` = 1, CONCAT('Reload GiftCard# ',tick.`giftcard`), CONCAT('New GiftCard# ',tick.`giftcard`)), ''), prod.`name`),'') as 'prod_name',\n" +
//                    "COALESCE((tick.`price`*tick.`qty`)*(1 - tick.`discount`/100)+tick.`taxe`,'') as 'price',\n" +
//                    "arr.`time` as 'time',\n" +
//                    "arr.`comment` as 'comment',\n" +
//                    "arr.`cust_comment` as 'cust_comment',\n" +
//                    "arr.`state` as 'state',\n" +
//                    "arr.`request` as 'request',\n" +
//                    "tick.`id` as 'ticket_id'\n" +
//                    "from `ticket` tick\n" +
//                    "LEFT JOIN `service` serv on serv.`id` = tick.`service_id`\n" +
//                    "LEFT JOIN `inventory` prod on prod.`id` = tick.`product_id`\n" +
//                    "left join (select \n" +
//                    "tkt.`code_transaction` as 'ct', \n" +
//                    "app.`appt_date` as 'date', \n" +
//                    "COALESCE(if(emp.`id` is NULL, 'none', CONCAT(emp.`fname`, \" \",emp.`lname`)),'') as 'emp_name', \n" +
//                    "\n" +
//                    "app.`id` as 'id',\n" +
//                    "app.`st_time` as 'time',\n" +
//                    "app.`comment` as 'comment',\n" +
//                    "cust.`comment` as 'cust_comment',\n" +
//                    "app.`state` as 'state',\n" +
//                    "app.`request` as 'request'\n" +
//                    "from `appointment` app\n" +
//                    "left join `ticket` tkt on tkt.`id` = app.`ticket_id`\n" +
//                    "left join `employee` emp on emp.`id` = app.`employee_id`\n" +
//                    "\n" +
//                    "\n" +
//                    "INNER JOIN `customer` cust on cust.`id` = app.`customer_id`\n" +
//                    "where (app.`customer_id`='"+cust_id+"')\n" +
//                    ")arr on arr.ct = tick.`code_transaction`\n" +
//                    "\n" +
//                    "where tick.`code_transaction` in (select tic.`code_transaction` from `ticket` tic\n" +
//                    "left join `appointment` app on app.`ticket_id` = tic.`id`\n" +
//                    "left join `reconciliation` rec on rec.`code_transaction` = tic.`code_transaction`\n" +
//                    "where (app.`customer_id`='"+cust_id+"')) order by arr.`date`, arr.`time`");
            ResultSet rs = st.executeQuery("select \n" +
                    "app.`id` as 'id',\n" +
                    "app.`appt_date` as 'date',\n" +
                    "COALESCE(if(emp.`id` is NULL, 'none', CONCAT(emp.`fname`, \" \",emp.`lname`)),'') as 'emp_name', \n" +
                    "COALESCE(if(ser.`id` is NULL, '', ser.`name`),'') as 'serv_name',\n" +
                    "'' as 'prod_name',\n" +
                    "COALESCE((tic2.`price`*tic2.`qty`)*(1 - tic2.`discount`/100)+tic2.`taxe`,'') as 'price',\n" +
                    "app.`st_time` as 'time',\n" +
                    "app.`comment` as 'comment',\n" +
                    "app.`comment` as 'cust_comment',\n" +
                    "app.`state` as 'state',\n" +
                    "app.`request` as 'request',\n" +
                    "tic2.`id` as 'ticket_id',\n" +
                    "'' as 'prod_id'\n" +
                    " \n" +
                    "from `appointment` app\n" +
                    "INNER JOIN `ticket` tic on app.`ticket_id` = tic.`id`\n" +
                    "left join `employee` emp on emp.`id` = app.`employee_id`\n" +
                    "left join `ticket` tic2 on tic2.`code_transaction` = tic.`code_transaction` and tic2.`id`<>tic.`id`\n" +
                    "inner join `service` ser on ser.`id` = tic2.`service_id`\n" +
                    "left join `customer` cust on cust.`id` = app.`customer_id`\n" +
                    "where (app.`customer_id`='"+cust_id+"')-- order by app.`appt_date`, app.`st_time`\n" +
                    "union\n" +
                    "select \n" +
                    "app3.`id` as 'id',\n" +
                    "app3.`appt_date` as 'date',\n" +
                    "gg.`emp_name`, \n" +
                    "gg.`serv_name`,\n" +
                    "gg.`prod_name`,\n" +
                    "gg.`price`,\n" +
                    "app3.`st_time` as 'time',\n" +
                    "app3.`comment` as 'comment',\n" +
                    "app3.`comment` as 'cust_comment',\n" +
                    "app3.`state` as 'state',\n" +
                    "app3.`request` as 'request',\n" +
                    "gg.`ticket_id` as 'ticket_id',\n" +
                    "gg.`prod_id` as 'prod_id' \n" +
                    "\n" +
                    "from\n" +
                    "(select \n" +
                    "distinct\n" +
                    "(select app2.`id` from `appointment` app2\n" +
                    "inner join `ticket` tt on tt.`id` = app2.`ticket_id` \n" +
                    "where tt.`code_transaction` = tic.`code_transaction` limit 1) as `app_id`,\n" +
                    "tic2.`id` as 'ticket_id',\n" +
                    "prod.`id` as 'prod_id',\n" +
                    "COALESCE(if(emp.`id` is NULL, 'none', CONCAT(emp.`fname`, \" \",emp.`lname`)),'') as 'emp_name', \n" +
                    "COALESCE(if(ser.`id` is NULL, '', ser.`name`),'') as 'serv_name',\n" +
                    "COALESCE(if(prod.`id` is NULL, if(ser.`id` is NULL, if(tic2.`status` = 1, CONCAT('Reload GiftCard# ',tic2.`giftcard`), CONCAT('New GiftCard# ',tic2.`giftcard`)), ''), prod.`name`),'') as 'prod_name',\n" +
                    "COALESCE((tic2.`price`*tic2.`qty`)*(1 - tic2.`discount`/100)+tic2.`taxe`,'') as 'price'\n" +
                    "\n" +
                    "from `appointment` app\n" +
                    "INNER JOIN `ticket` tic on app.`ticket_id` = tic.`id`\n" +
                    "left join `employee` emp on emp.`id` = app.`employee_id`\n" +
                    "left join `ticket` tic2 on tic2.`code_transaction` = tic.`code_transaction` and tic2.`id`<>tic.`id`\n" +
                    "left join `service` ser on ser.`id` = tic2.`service_id`\n" +
                    "inner join `inventory` prod on prod.`id` = tic2.`product_id`\n" +
                    "left join `customer` cust on cust.`id` = app.`customer_id`\n" +
                    "where (app.`customer_id`='"+cust_id+"')) gg \n" +
                    "inner join `appointment` app3 on app3.`id` = gg.`app_id`");
            while(rs.next()){
                AppointmentHistory appt = new AppointmentHistory();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setApp_dt(rs.getDate(2));
                appt.setEmployee(rs.getString(3));
                appt.setService(rs.getString(4));
                appt.setProduct(rs.getString(5));
                appt.setPrice(rs.getBigDecimal(6));
                appt.setTime(rs.getTime(7));
                appt.setComment(rs.getString(8));
                appt.setCust_comment(rs.getString(9));
                appt.setState(rs.getInt(10));
                appt.setRequest(rs.getBoolean(11));
                appt.setTicket_id(rs.getInt(12));
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

    public static ArrayList findFullHistoryByCustomerId(int cust_id){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("select \n" +
                    "COALESCE(app.`id`, '-1') as 'id',\n" +
                    "COALESCE(app.`appt_date`,rec.`created_dt`, '') as 'date',\n" +
                    "COALESCE(if(emp.`id` is NULL, 'none', CONCAT(emp.`fname`, \" \",emp.`lname`)),'') as 'emp_name', \n" +
                    "COALESCE(if(ser.`id` is NULL, '', ser.`name`),'') as 'serv_name',\n" +
                    "COALESCE(if(prod.`id` is NULL and ser.`id` is NULL, if(tic.`status` = '1' ,CONCAT('Reload Gift Card: #',tic.`giftcard`),CONCAT('New Gift Card: #',tic.`giftcard`)), prod.`name`),'') as 'prod_name',\n" +
                    "COALESCE(if(tic.`status`!=4,(tic.`price`*tic.`qty`)*(1 - tic.`discount`/100)+tic.`taxe`,rec2.`total`),'') as 'price',\n" +
                    "COALESCE(app.`st_time`, '00:00') as 'time',\n" +
                    "COALESCE(app.`comment`, '') as 'comment',\n" +
                    "COALESCE(cust.`comment`, '') as 'cust_comment',\n" +
                    "rec.`status` as 'state',\n" +
                    "COALESCE(app.`request`, '') as 'request',\n" +
                    "tic.`id` as 'ticket_id'\n" +
                    " \n" +
                    "from `ticket` tic\n" +
                    "left JOIN `appointment` app on app.`ticket_id` = tic.`id`\n" +
                    "left join `employee` emp on emp.`id` = tic.`employee_id`\n" +
                    "left join `service` ser on ser.`id` = tic.`service_id`\n" +
                    "left join `inventory` prod on prod.`id` = tic.`product_id`\n" +
                    "left join `customer` cust on cust.`id` = app.`customer_id`\n" +
                    "left join `reconciliation` rec on rec.`code_transaction` = tic.`code_transaction`\n" +
                    "left join `reconciliation` rec2 on rec2.`id` = tic.`refundtrans_id`\n" +
                    "where (rec.`id_customer`='"+cust_id+"')"+
                    "union select\n" +
                    "COALESCE(app.`id`, '-1') as 'id', \n" +
                    "COALESCE(app.`appt_date`, '') as 'date',\n" +
                    "COALESCE(if(emp.`id` is NULL, 'none', CONCAT(emp.`fname`, \" \",emp.`lname`)),'') as 'emp_name',\n" +
                    "COALESCE(if(ser.`id` is NULL, '', ser.`name`),'') as 'serv_name',\n" +
                    "'' as 'prod_name',\n" +
                    "app.`price` as 'price',\n" +
                    "COALESCE(app.`st_time`, '00:00') as 'time',\n" +
                    "COALESCE(app.`comment`, '') as 'comment',\n" +
                    "COALESCE(cust.`comment`, '') as 'cust_comment',\n" +
                    "7 as 'state',\n" +
                    "COALESCE(app.`request`, '') as 'request',\n" +
                    "0 as 'ticket_id'\n" +
                    "from `appointment` app\n" +
                    "left join `employee` emp on emp.`id` = app.`employee_id`\n" +
                    "left join `service` ser on ser.`id` = app.`service_id`\n" +
                    "left join `customer` cust on cust.`id` = app.`customer_id`\n" +
                    "where app.`customer_id`='"+cust_id+"' and app.`ticket_id`=0\n" +
                    "order by date, time");
            while(rs.next()){
                AppointmentHistory appt = new AppointmentHistory();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setApp_dt(rs.getDate(2));
                appt.setEmployee(rs.getString(3));
                appt.setService(rs.getString(4));
                appt.setProduct(rs.getString(5));
                appt.setPrice(rs.getBigDecimal(6));
                appt.setTime(rs.getTime(7));
                appt.setComment(rs.getString(8));
                appt.setCust_comment(rs.getString(9));
                appt.setState(rs.getInt(10));
                appt.setRequest(rs.getBoolean(11));
                appt.setTicket_id(rs.getInt(12));
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