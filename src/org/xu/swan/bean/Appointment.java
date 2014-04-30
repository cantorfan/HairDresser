package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.dashboard.*;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class Appointment {
    public static final String ID = "id";
    public static final String CUST = "customer_id";
    public static final String EMP = "employee_id";
    public static final String LOC = "location_id";
    public static final String SVC = "service_id";
    public static final String TICKET = "ticket_id";    
    public static final String CATE = "category_id";
    public static final String PRICE = "price";
    public static final String APPDT = "appt_date";
    public static final String ST = "st_time";
    public static final String ET = "et_time";
    public static final String STATE = "state";
    public static final String COMMENT = "comment";
    public static final String REQUEST = "request";

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



    public static Appointment insertAppointment(int loc,int cust,int emp,int svc,int cate, BigDecimal price, Date dt, Time st, Time et,int state, String comment, Boolean req){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT INTO appointment (" + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + ","  + COMMENT  + "," + REQUEST + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
            pst.setInt(1,loc);
            pst.setInt(2,cust);
            pst.setInt(3,emp);
            pst.setInt(4,svc);
            pst.setInt(5,cate);
            pst.setBigDecimal(6,price);
            pst.setDate(7,dt);
            pst.setTime(8,st);
            pst.setTime(9,et);
            pst.setInt(10,state);
            pst.setString(11,comment);
            pst.setBoolean(12,req);

            int rows = pst.executeUpdate();
            if(rows>=0){
                appt = new Appointment();
                appt.setLocation_id(loc);
                appt.setCustomer_id(cust);
                appt.setEmployee_id(emp);
                appt.setService_id(svc);
                appt.setCategory_id(cate);
                appt.setPrice(price);
                appt.setApp_dt(dt);
                appt.setSt_time(st);
                appt.setEt_time(et);
                appt.setState(state);
                appt.setComment(comment);
                appt.setRequest(req);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    appt.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

    public static Appointment updateAppointment(int id, int loc,int cust,int emp,int svc,int cate, BigDecimal price, Date dt, Time st, Time et, int newState, String comment){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE appointment SET " + LOC + "=?,"  + CUST + "=?,"  + EMP + "=?," + SVC + "=?,"
                + CATE + "=?,"  + PRICE + "=?,"  + APPDT + "=?,"  + ST + "=?," + ET + "=?,"+ STATE + "=?,"+ COMMENT + "=? WHERE " + ID + "=?");
            pst.setInt(1,loc);
            pst.setInt(2,cust);
            pst.setInt(3,emp);
            pst.setInt(4,svc);
            pst.setInt(5,cate);
            pst.setBigDecimal(6,price);
            pst.setDate(7,dt);
            pst.setTime(8,st);
            pst.setTime(9,et);
            pst.setInt(10, newState);
            pst.setString(11, comment);
            pst.setInt(12,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                appt = new Appointment();
                appt.setId(id);
                appt.setLocation_id(loc);
                appt.setCustomer_id(cust);
                appt.setEmployee_id(emp);
                appt.setService_id(svc);
                appt.setCategory_id(cate);
                appt.setPrice(price);
                appt.setApp_dt(dt);
                appt.setSt_time(st);
                appt.setEt_time(et);
                appt.setState(newState);
                appt.setComment(comment);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

    public static Appointment updateAddTicketID(int id, int ticket){
        DBManager dbm = null;
        boolean bComplete = true;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE appointment SET " + TICKET + "=? WHERE " + ID + "=?");
            pst.setInt(1,ticket);
            pst.setInt(2,id);
            int rows = pst.executeUpdate();
            pst.close();
        }catch(Exception e){
            bComplete = false;
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        if(bComplete)
            return findById(id);
        return null;
    }

    public static void updateChangeStatusDelCust(int id_cust){
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE appointment SET " + STATE + "=0 WHERE " + CUST + "=? AND STATE = 1");
            pst.setInt(1,id_cust);
            int rows = pst.executeUpdate();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
    }

    public static Appointment updateAppointmentByCustDate(int cust,Date dt,int newState){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE appointment SET " + STATE +
                    "=? WHERE appointment." + CUST + "=? AND DATE(appointment." + APPDT + ")=DATE(?)");
            pst.setInt(1, newState);
            pst.setInt(2,cust);
            pst.setDate(3,dt);
            int rows = pst.executeUpdate();
            if(rows>=0){
                appt = new Appointment();
                appt.setCustomer_id(cust);
                appt.setApp_dt(dt);
                appt.setState(newState);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

    public static Appointment updateAppointmentByIdState(int id,int newState){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE appointment SET " + STATE +
                    "=? WHERE appointment." + ID + "=? ");
            pst.setInt(1, newState);
            pst.setInt(2,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                appt = new Appointment();
                appt.setState(newState);
            }
            pst.close();
        }catch(Exception e)
        {
            appt = null;
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

    public static Appointment updateAppointment(int id, int emp, BigDecimal price, Date dt, Time st, Time et, String comment){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE appointment SET " + EMP + "=?," + PRICE + "=?,"
                    + APPDT + "=?,"  + ST + "=?," + ET + "=?," + COMMENT + "=? WHERE " + ID + "=?");
            pst.setInt(1,emp);
            pst.setBigDecimal(2,price);
            pst.setDate(3,dt);
            pst.setTime(4,st);
            pst.setTime(5,et);
            pst.setString(6, comment);
            pst.setInt(7,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                appt = new Appointment();
                appt.setId(id);
                appt.setEmployee_id(emp);
                appt.setPrice(price);
                appt.setApp_dt(dt);
                appt.setSt_time(st);
                appt.setEt_time(et);
                appt.setComment(comment);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

        public static Appointment updateAppointment(int id, int emp, BigDecimal price, Date dt, Time st, Time et, String comment, Boolean req){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE appointment SET " + EMP + "=?," + PRICE + "=?,"
                    + APPDT + "=?,"  + ST + "=?," + ET + "=?," + COMMENT + "=?, " + REQUEST + "=? WHERE " + ID + "=?");
            pst.setInt(1,emp);
            pst.setBigDecimal(2,price);
            pst.setDate(3,dt);
            pst.setTime(4,st);
            pst.setTime(5,et);
            pst.setString(6, comment);
            pst.setBoolean(7, req);
            pst.setInt(8,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                appt = new Appointment();
                appt.setId(id);
                appt.setEmployee_id(emp);
                appt.setPrice(price);
                appt.setApp_dt(dt);
                appt.setSt_time(st);
                appt.setEt_time(et);
                appt.setComment(comment);
                appt.setRequest(req);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

    public static ArrayList getChartData(Date from, Date to){
        ArrayList m = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("select count(*) as 'count', " +
                    "appt_date as 'date' from `appointment` where appt_date BETWEEN DATE(?) AND DATE(?) group by appt_date order by appt_date");
            pst.setDate(1, from);
            pst.setDate(2, to);
            //System.out.println("ChartDataQuery: " + pst);
            ResultSet rs = pst.executeQuery();

            while(rs.next()){
                ChartData cd = new ChartData();
                cd.setDate(rs.getDate("date"));
                cd.setCount(rs.getInt("count"));
                m.add(cd);
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return m;
    }

    public static Appointment deleteAppointment(int id){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM appointment WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                appt = new Appointment();
                appt.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

    public static ArrayList findAll(){//List<Appointment> findAll(){
        ArrayList list = new ArrayList();//List<Appointment> list = new ArrayList<Appointment>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + ","+ COMMENT +" FROM appointment");
            while(rs.next()){
                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
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
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + ","+ COMMENT + ","+ TICKET +" FROM appointment "
             + filter );

            while(rs.next()){
                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setTicket_id(rs.getInt(13));
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

    public static ArrayList findAllNotPaidApptbyDate(String dt){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT app." + ID + ",app."  + LOC + ",app."  + CUST + ",app."  + EMP + ",app." + SVC + ",app."
                + CATE + ",app."  + PRICE + ",app."  + APPDT + ",app."  + ST + ",app."  + ET + ",app."+ STATE + ",app."+ COMMENT + ",app."+ TICKET + ",app."+ REQUEST +" FROM appointment app"
             + " left join ticket tic on tic.id = app.ticket_id left join reconciliation rec on rec.code_transaction = tic.code_transaction WHERE  DATE(app.appt_date)=DATE('" + dt + "') and ( app.ticket_id=0 or rec.status = 2)"  );

            while(rs.next()){
                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setTicket_id(rs.getInt(13));
                appt.setRequest(rs.getBoolean(14));
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
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM appointment " + filter );

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
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + ","+ COMMENT +" FROM appointment LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
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
            ResultSet rs = st.executeQuery("SELECT count(*) as cnt FROM appointment"); //TODO FOUND_ROWS()
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

    public static Appointment findById(int id){
        Appointment appt = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE +  ","+ COMMENT + "," + REQUEST + "," + TICKET + " FROM appointment WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                appt = new Appointment();
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
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
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return appt;
    }

    public static ArrayList findByCustId(int cust_id){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + ","+ COMMENT +","+REQUEST+" FROM appointment WHERE " + CUST + "=" + cust_id +" ORDER BY " + APPDT + "," + ST + "," + ET + " ASC"); //TODO FOUND_ROWS()
            while(rs.next()){
                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setRequest(rs.getBoolean(13));
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

    public static ArrayList findAllByEmployeeId(int emp){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + ","+ COMMENT +" FROM appointment WHERE " + EMP + "=" + emp); //TODO FOUND_ROWS()
            while(rs.next()){
                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
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

    public static HashMap findByEmployeeId(int location_id, int emp){
         HashMap hm = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + ","+ COMMENT +" FROM appointment WHERE " + LOC + "="+ location_id +" AND " + EMP + "=" + emp); //TODO FOUND_ROWS()
            while(rs.next()){
                Integer eid = new Integer(rs.getInt(4));
                                ArrayList list = (ArrayList)hm.get(eid);
                                if(list == null)
                                    list = new ArrayList();

                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));

                list.add(appt);
                hm.put(eid,list);
            }
            rs.close();
            st.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return hm;
    }

    public static ArrayList findAllByTicketId(int ticket_id){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE + "," + COMMENT + "," + REQUEST + "," + TICKET + " FROM appointment WHERE " + TICKET + "=" + ticket_id);
            while(rs.next()){
                Appointment appt = new Appointment();
                list.add(appt);
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
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

    public static HashMap findApptByLocDate(int loc, Date dt, int pageNum){
        HashMap hm = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();

            PreparedStatement pst1 = dbm.getPreparedStatement("drop table if exists temp;");
            int i = pst1.executeUpdate();

            PreparedStatement pst2 = dbm.getPreparedStatement("CREATE TEMPORARY TABLE temp (id int(4) default 0 not null) Engine=MEMORY;");
            int i1 = pst2.executeUpdate();

            PreparedStatement pst3 = dbm.getPreparedStatement("INSERT INTO temp (id) SELECT " + ID + " FROM employee WHERE " + LOC + "="+ loc +
                    " and (SUBSTRING(schedule,?,1))=1 AND (delete_date>DATE(?) OR delete_date is null) \n" +
                    "union \n" +
                        "select emp.id from `employee` emp \n" +
                        "left join `workingtime_emp` wor on wor.`employee_id` = emp.`id`\n" +
                        "where emp.deleted=0 and emp."+ LOC + "="+ loc +" and wor.type = 1 and wor.`work_date` = DATE(?) \n"+
                    "union\n" +
                        "select e.id from employee e\n" +
                        "inner join appointment a on e.`id`=a.`employee_id`\n" +
                        "where a.`appt_date`=DATE(?)\n" +
                    " LIMIT "+pageNum*8+",8");
            int date = dt.getDay();
            if (date == 0) date = 7;
            pst3.setInt(1,date);
            pst3.setDate(2, dt);
            pst3.setDate(3, dt);
            pst3.setDate(4, dt);
            int i2 = pst3.executeUpdate();


            PreparedStatement pst = dbm.getPreparedStatement("SELECT appointment." + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE+  ","+ COMMENT + "," + TICKET + "," + REQUEST+ " FROM appointment inner JOIN temp ON temp.id=appointment.employee_id WHERE appointment." + LOC + "=? AND DATE(appointment." + APPDT + ")=DATE(?) ORDER BY (et_time - st_time) DESC ");
            pst.setInt(1,loc);
            pst.setDate(2,dt);
            //System.out.println("pst" + pst);

            ResultSet rs = pst.executeQuery();

            while(rs.next()){
                Integer eid = new Integer(rs.getInt(4));
                ArrayList list = (ArrayList)hm.get(eid);
                if(list == null)
                    list = new ArrayList();

                Appointment appt = new Appointment();
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setTicket_id(rs.getInt(13));
                appt.setRequest(rs.getBoolean(14));

                list.add(appt);
                hm.put(eid,list);
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return hm;
    }

    public static HashMap findAroundAppt(int loc, Date dt, Time st, Time et, int emp_id){
        HashMap hm = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
//            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ","  + LOC + ","  + CUST + ","  + EMP + "," + SVC + ","
//                + CATE + ","  + PRICE + ","  + APPDT + ","  + ST + ","  + ET + ","+ STATE+  ","+ COMMENT + "," + TICKET + "," + REQUEST+ " FROM appointment WHERE " + LOC + "=? AND DATE(" + APPDT + ")=DATE(?) AND "+EMP + "=? AND (("+ST+"<'"+st+"' AND "+ET+">'"+st+"') OR ("+ST+"<'"+st+"' AND "+ST+">'"+et+"') OR ("+ST+">'"+st+"' AND "+ST+"<'"+et+"') OR ("+ST+"='"+st+"') OR ("+ET+"='"+et+"'))");
            PreparedStatement pst = dbm.getPreparedStatement("select app." + ID + ",app."  + LOC + ",app."  + CUST + ",app."  + EMP + ",app." + SVC + ",app."
                + CATE + ",app."  + PRICE + ",app."  + APPDT + ",app."  + ST + ",app."  + ET + ",app."+ STATE+  ",app."+ COMMENT + ",app." + TICKET + ",app." + REQUEST+ " from `appointment` app " +
                    "left join (select MIN(app2.`st_time`) as 'Smin', MAX(app2.`et_time`) as 'Smax' from `appointment` app2 where " +
                    "app2.`location_id` = ? " +
                    "and DATE(app2.`appt_date`)=DATE(?) " +
                    "and app2.`employee_id`=? " +
                    "and (NOT(app2.`et_time` < '"+st+"' OR  app2.`st_time`> '"+et+"'))) sld on true " +
                    "where " +
                    "app.`location_id` = ? " +
                    "and DATE(app.`appt_date`)=DATE(?) " +
                    "and app.`employee_id`=? " +
                    "and NOT(app.`et_time` < sld.`Smin` OR  app.`st_time`> sld.`Smax`)");
            pst.setInt(1,loc);
            pst.setDate(2,dt);
            pst.setInt(3,emp_id);
            pst.setInt(4,loc);
            pst.setDate(5,dt);
            pst.setInt(6,emp_id);

            ResultSet rs = pst.executeQuery();

            while(rs.next()){
                Integer eid = new Integer(rs.getInt(4));
                ArrayList list = (ArrayList)hm.get(eid);
                if(list == null)
                    list = new ArrayList();

                Appointment appt = new Appointment();
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setTicket_id(rs.getInt(13));
                appt.setRequest(rs.getBoolean(14));

                list.add(appt);
                hm.put(eid,list);
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return hm;
    }

    public static HashMap findAroundApptFlag(int loc, Date dt, int cust_id){
        HashMap hm = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("select app." + ID + ",app."  + LOC + ",app."  + CUST + ",app."  + EMP + ",app." + SVC + ",app."
                + CATE + ",app."  + PRICE + ",app."  + APPDT + ",app."  + ST + ",app."  + ET + ",app."+ STATE+  ",app."+ COMMENT + ",app." + TICKET + ",app." + REQUEST+ " from `appointment` app " +
                    "left join (select MIN(app2.`st_time`) as 'Smin', MAX(app2.`et_time`) as 'Smax' from `appointment` app2 where " +
                    "app2.`location_id` = ? " +
                    "and DATE(app2.`appt_date`)=DATE(?) " +
                    "and app2.`employee_id`=? " +
                    "and (NOT(app2.`et_time` < ? OR  app2.`st_time`> ?))) sld on true " +
                    "where " +
                    "app.`location_id` = ? " +
                    "and DATE(app.`appt_date`)=DATE(?) " +
                    "and app.`employee_id`=? " +
                    "and NOT(app.`et_time` < sld.`Smin` OR  app.`st_time`> sld.`Smax`)");

            String filter = "where customer_id="+cust_id+" and DATE(appt_date)=DATE('"+dt+"')";
            ArrayList ListApp = Appointment.findByFilter(filter);
            ResultSet rs = null;
            for (int i=0; i<ListApp.size(); i++){
                Appointment app = (Appointment)ListApp.get(i);

            pst.setInt(1,app.getLocation_id());
            pst.setDate(2,dt);
            pst.setInt(3,app.getEmployee_id());
            pst.setTime(4,app.getSt_time());
            pst.setTime(5,app.getEt_time());
            pst.setInt(6,app.getLocation_id());
            pst.setDate(7,dt);
            pst.setInt(8,app.getEmployee_id());

            rs = pst.executeQuery();

            while(rs.next()){
                Integer eid = new Integer(rs.getInt(4));
                ArrayList list = (ArrayList)hm.get(eid);
                if(list == null)
                    list = new ArrayList();

                Appointment appt = new Appointment();
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setTicket_id(rs.getInt(13));
                appt.setRequest(rs.getBoolean(14));

                list.add(appt);
                hm.put(eid,list);
            }
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return hm;
    }
    public static HashMap findAroundEmp(int loc, Date dt, int cust_id){
        HashMap hm = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("select app." + ID + ",app."  + LOC + ",app."  + CUST + ",app."  + EMP + ",app." + SVC + ",app."
                + CATE + ",app."  + PRICE + ",app."  + APPDT + ",app."  + ST + ",app."  + ET + ",app."+ STATE+  ",app."+ COMMENT + ",app." + TICKET + ",app." + REQUEST+ " from `appointment` app " +
                    " where " +
                    "app.`location_id` = ? " +
                    "and DATE(app.`appt_date`)=DATE(?) " +
                    "and app.`employee_id`=? ");


            String filter = "where customer_id="+cust_id+" and DATE(appt_date)=DATE('"+dt+"') group by employee_id";
            ArrayList ListApp = Appointment.findByFilter(filter);
            ResultSet rs = null;
            for (int i=0; i<ListApp.size(); i++){
                Appointment app = (Appointment)ListApp.get(i);

            pst.setInt(1,app.getLocation_id());
            pst.setDate(2,dt);
            pst.setInt(3,app.getEmployee_id());

            rs = pst.executeQuery();

            while(rs.next()){
                Integer eid = new Integer(rs.getInt(4));
                ArrayList list = (ArrayList)hm.get(eid);
                if(list == null)
                    list = new ArrayList();

                Appointment appt = new Appointment();
                appt.setId(rs.getInt(1));
                appt.setLocation_id(rs.getInt(2));
                appt.setCustomer_id(rs.getInt(3));
                appt.setEmployee_id(rs.getInt(4));
                appt.setService_id(rs.getInt(5));
                appt.setCategory_id(rs.getInt(6));
                appt.setPrice(rs.getBigDecimal(7));
                appt.setApp_dt(rs.getDate(8));
                appt.setSt_time(rs.getTime(9));
                appt.setEt_time(rs.getTime(10));
                appt.setState(rs.getInt(11));
                appt.setComment(rs.getString(12));
                appt.setTicket_id(rs.getInt(13));
                appt.setRequest(rs.getBoolean(14));

                list.add(appt);
                hm.put(eid,list);
            }
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return hm;
    }

}
