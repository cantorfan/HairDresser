package org.xu.swan.bean;

import org.xu.swan.db.DBManager;
import org.xu.swan.util.DateUtil;
import org.apache.commons.lang.StringUtils;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class Employee {
    public static final String ID = "id";
    public static final String FNAME = "fname";
    public static final String LNAME = "lname";
    public static final String LOGIN = "login_id";
    public static final String SCH = "schedule";
    public static final String COMM = "commission";
    public static final String LOC = "location_id";
    public static final String PIC = "picture";
    /*public static final String FROM = "hfrom";
    public static final String TO = "hto";*/
    public static final String SSEC = "s_security";
    public static final String EMAIL = "email";
    public static final String SALARY = "salary";
    public static final String COMMENT = "comment";
    public static final String ONEDAY = "oneday";
    public static final String MALE_FEMALE = "male_female";
    public static final String DESCRIPTION = "description";
    public static final String ADDRESS = "address";
    public static final String CITY = "city";
    public static final String POSTCODE = "postcode";
    public static final String HOMEPHONE = "homephone";
    public static final String CELLPHONE = "cellphone";
    public static final String HIREDATE = "hiredate";
    public static final String TERMDATE = "termdate";

    private int id;
    private String fname;
    private String lname;
    private int login_id;
    private String schedule;
    private BigDecimal commission;
    private int location_id;
    private Blob picture;
    /*private Time hfrom;
    private Time hto;*/
    private String s_security;
    private String email;
    private String salary;
    private String comment;
    private boolean oneday = false;
    private int male_female;
    private String description;
    private String address;
    private String city;
    private String postcode;
    private String homephone;
    private String cellphone;
    private Date hiredate;
    private Date termdate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getLname() {
        return lname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public int getLogin_id() {
        return login_id;
    }

    public void setLogin_id(int login_id) {
        this.login_id = login_id;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getSchedule() {
        return safeConvert(schedule);
    }

    public void setSchedule(String schedule) {
        this.schedule = safeConvert(schedule);
    }

    public char[] getSafeSchedule(){
        return safeConvert(schedule).toCharArray();
    }

    public void setSafeSchedule(char[] schedule) {
        this.schedule = safeConvert(new String(schedule));
    }

    public static String safeConvert(String safe){
        if(StringUtils.isEmpty(safe))
            safe  = "0000000";
        safe = safe.replaceAll("\\D","0");
        safe  = StringUtils.rightPad(safe ,7,"0");
        if(safe.length()!=7)
            safe = "0000000";
        return safe;
    }

    public BigDecimal getCommission() {
        return commission;
    }

    public void setCommission(BigDecimal commission) {
        this.commission = commission;
    }

    public int getLocation_id() {
        return location_id;
    }

    public void setLocation_id(int location_id) {
        this.location_id = location_id;
    }

    public Blob getPicture() {
        if (this.picture == null)
            return null;
        else
            return this.picture;
    }

    public void setPicture(Blob picture) {
        this.picture = picture;
    }

    /*public Time getH_from() {
        return hfrom;
    }

    public void setH_from(Time hfrom) {
        this.hfrom = hfrom;
    }

    public Time getH_to() {
        return hto;
    }

    public void setH_to(Time hto) {
        this.hto = hto;
    }*/

    public String getS_security() {
        return s_security;
    }

    public void setS_security(String s_security) {
        this.s_security = s_security;
    }
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    public String getSalary() {
        return salary;
    }

    public void setSalary(String salary) {
        this.salary = salary;
    }

    public boolean getOneday() {
        return oneday;
    }

    public void setOneday(boolean oneday) {
        this.oneday = oneday;
    }

    public int getMale_female() {
        return male_female;
    }

    public void setMale_female(int male_female) {
        this.male_female = male_female;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getHomephone() {
        return homephone;
    }

    public void setHomephone(String homephone) {
        this.homephone = homephone;
    }

    public String getCellphone() {
        return cellphone;
    }

    public void setCellphone(String cellphone) {
        this.cellphone = cellphone;
    }

    public Date getHiredate() {
        return hiredate;
    }

    public void setHiredate(Date hiredate) {
        this.hiredate = hiredate;
    }

    public Date getTermdate() {
        return termdate;
    }

    public void setTermdate(Date termdate) {
        this.termdate = termdate;
    }

    public static Employee insertEmployee(String fname,String lname, int login, String sch, BigDecimal comm, int loc, Blob pict, /*Time hf, Time ht, */String s_security, String email, String salary, String comment, boolean oneday, int male_female, String description, String address, String city, String postcode, String homephone, String cellphone, Date hiredate, Date termdate){
        Employee emp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT employee (" + FNAME + ", " + LNAME + ", " + LOGIN + ", "
                    + SCH + ", " + COMM + "," + LOC +  "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT + "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
            pst.setString(1,fname);
            pst.setString(2,lname);
            pst.setInt(3,login);
            pst.setString(4,sch);
            pst.setBigDecimal(5,comm);
            pst.setInt(6, loc);
            pst.setBlob(7,pict);
            pst.setString(8, s_security);
            pst.setString(9, email);
            pst.setString(10, salary);
            pst.setString(11, comment);
            pst.setBoolean(12, oneday);
            pst.setInt(13, male_female);
            pst.setString(14, description);
            pst.setString(15, address);
            pst.setString(16, city);
            pst.setString(17, postcode);
            pst.setString(18, homephone);
            pst.setString(19, cellphone);
            pst.setDate(20, hiredate);
            pst.setDate(21, termdate);
            int rows = pst.executeUpdate();
            if(rows>=0){
                emp = new Employee();
                emp.setFname(fname);
                emp.setLname(lname);
                emp.setLogin_id(login);
                emp.setSchedule(sch);
                emp.setCommission(comm);
                emp.setLocation_id(loc);
                emp.setPicture(pict);
                /*emp.setH_from(hf);
                emp.setH_to(ht);*/
                emp.setS_security(s_security);
                emp.setEmail(email);
                emp.setSalary(salary);
                emp.setComment(comment);
                emp.setOneday(oneday);
                emp.setMale_female(male_female);
                emp.setDescription(description);
                emp.setAddress(address);
                emp.setCity(city);
                emp.setPostcode(postcode);
                emp.setHomephone(homephone);
                emp.setCellphone(cellphone);
                emp.setHiredate(hiredate);
                emp.setTermdate(termdate);
                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    emp.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return emp;
    }

    public static Employee updateEmployee(int id, String fname,String lname, int login, String sch, BigDecimal comm, int loc, Blob pict, /*Time hf, Time ht, */String s_security, String email, String salary, String comment, boolean oneday, int male_female, String description, String address, String city, String postcode, String homephone, String cellphone, Date hiredate, Date termdate){
        Employee emp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE employee SET " + FNAME + "=?, " + LNAME + "=?, " + LOGIN +"=?, "
                    + SCH + "=?, " + COMM + "=?," + LOC +  "=?," + PIC +  "=?," + SSEC +  "=?," + EMAIL +  "=?," + SALARY + "=?," + COMMENT + "=?," + ONEDAY + "=?," + MALE_FEMALE + "=?," + DESCRIPTION + "=?," + ADDRESS + "=?," + CITY + "=?," + POSTCODE + "=?," + HOMEPHONE + "=?," + CELLPHONE + "=?," + HIREDATE + "=?," + TERMDATE + "=? WHERE " + ID + "=?");
            pst.setString(1,fname);
            pst.setString(2,lname);
            pst.setInt(3,login);
            pst.setString(4,sch);
            pst.setBigDecimal(5,comm);
            pst.setInt(6,loc);
            pst.setBlob(7,pict);
            /*pst.setTime(8,hf);
            pst.setTime(9,ht);*/
            pst.setString(8, s_security);
            pst.setString(9, email);
            pst.setString(10, salary);
            pst.setString(11, comment);
            pst.setBoolean(12, oneday);
            pst.setInt(13,male_female);
            pst.setString(14,description);
            pst.setString(15, address);
            pst.setString(16, city);
            pst.setString(17, postcode);
            pst.setString(18, homephone);
            pst.setString(19, cellphone);
            pst.setDate(20, hiredate);
            pst.setDate(21, termdate);
            pst.setInt(22,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                emp = new Employee();
                emp.setId(id);
                emp.setFname(fname);
                emp.setLname(lname);
                emp.setLogin_id(login);
                emp.setSchedule(sch);
                emp.setCommission(comm);
                emp.setLocation_id(loc);
                emp.setPicture(pict);
                /*emp.setH_from(hf);
                emp.setH_to(ht);*/
                emp.setS_security(s_security);
                emp.setEmail(email);
                emp.setSalary(salary);
                emp.setComment(comment);
                emp.setOneday(oneday);
                emp.setMale_female(male_female);
                emp.setDescription(description);
                emp.setAddress(address);
                emp.setCity(city);
                emp.setPostcode(postcode);
                emp.setHomephone(homephone);
                emp.setCellphone(cellphone);
                emp.setHiredate(hiredate);
                emp.setTermdate(termdate);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return emp;
    }

    public static Employee deleteEmployee(int id){
        Employee emp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE employee SET deleted=1, delete_date=CURDATE() WHERE " + ID + "=?");//("DELETE FROM employee WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                emp = new Employee();
                emp.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return emp;
    }

    public static Employee findById(int id){
        Employee emp = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC +  "," + PIC +  "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT + "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                emp = new Employee();
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return emp;
    }

    public static ArrayList findAll(){//List<Employee> findAll(){
        ArrayList list = new ArrayList();//List<Employee> list = new ArrayList<Employee>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT + "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee WHERE delete_date is null");
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
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

        public static ArrayList findByFilter(String filter){//List<Employee> findAll(){
        ArrayList list = new ArrayList();//List<Employee> list = new ArrayList<Employee>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee" +
                    " WHERE delete_date is null AND " + filter);
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
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
            ResultSet rs = st.executeQuery("SELECT count(*) FROM employee WHERE delete_date is null AND " + filter);
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

    public static ArrayList findAllByLoc(int loc){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT + "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee WHERE " + LOC + "=? AND delete_date is null ORDER BY " + FNAME + "" );
            pst.setInt(1,loc);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
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

    
    public static ArrayList findAllByLocAndDate(int loc,int day, int page_num, Date date){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee WHERE " + LOC + "=?"+
                    " and (SUBSTRING(schedule,?,1))=1 and (delete_date>DATE(?) OR delete_date is null) "+
                    " LIMIT "+page_num*8+",8");
            pst.setInt(1,loc);
            pst.setInt(2,day);
            pst.setDate(3, date);
            //System.out.println("pst = " + pst);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
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

    public static ArrayList findAllByLocAndDate(int loc,int day, int page_num){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee WHERE delete_date is null AND " + LOC + "=?"+
                    " and (SUBSTRING(schedule,?,1))=1"+
                    " LIMIT "+page_num*8+",8");
            pst.setInt(1,loc);
            pst.setInt(2,day);
            //System.out.println("pst = " + pst);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
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

    public static ArrayList findAllByLocAndDayAndDate(int loc,int day, int page_num, Date date){
            ArrayList list = new ArrayList();
            DBManager dbm = null;
            try{
                dbm = new DBManager();
                String query = "SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                        + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM ("+
                        "SELECT * FROM employee WHERE (delete_date>DATE(?) OR delete_date is null) AND " + LOC + "=?"+
                        " and (SUBSTRING(schedule,?,1))=1 \n" +
                    "union \n" +
                        "select emp.* from `employee` emp \n" +
                        "left join `workingtime_emp` wor on wor.`employee_id` = emp.`id`\n" +
                        "where emp.deleted=0 and emp."+ LOC + "= ? and wor.type = 1 and wor.`work_date` = DATE(?) \n"+
                    "union\n" +
                        "select e.* from employee e\n" +
                        "inner join appointment a on e.`id`=a.`employee_id`\n" +
                        "where a.`appt_date`=DATE(?)\n" +
                    ") as empp  LIMIT "+page_num*8+",8";
                PreparedStatement pst = dbm.getPreparedStatement(query);
                pst.setDate(1,date);
                pst.setInt(2,loc);
                pst.setInt(3,day);
                pst.setInt(4,loc);
                pst.setDate(5,date);
                pst.setDate(6,date);
                //System.out.println("pst = " + pst);
                ResultSet rs = pst.executeQuery();
                while(rs.next()){
                    Employee emp = new Employee();
                    list.add(emp);
                    emp.setId(rs.getInt(1));
                    emp.setFname(rs.getString(2));
                    emp.setLname(rs.getString(3));
                    emp.setLogin_id(rs.getInt(4));
                    emp.setSchedule(rs.getString(5));
                    emp.setCommission(rs.getBigDecimal(6));
                    emp.setLocation_id(rs.getInt(7));
                    emp.setPicture(rs.getBlob(8));
                    /*emp.setH_from(rs.getTime(9));
                    emp.setH_to(rs.getTime(10));*/
                    emp.setS_security(rs.getString(9));
                    emp.setEmail(rs.getString(10));
                    emp.setSalary(rs.getString(11));
                    emp.setComment(rs.getString(12));
                    emp.setOneday(rs.getBoolean(13));
                    emp.setMale_female(rs.getInt(14));
                    emp.setDescription(rs.getString(15));
                    emp.setAddress(rs.getString(16));
                    emp.setCity(rs.getString(17));
                    emp.setPostcode(rs.getString(18));
                    emp.setHomephone(rs.getString(19));
                    emp.setCellphone(rs.getString(20));
                    emp.setHiredate(rs.getDate(21));
                    emp.setTermdate(rs.getDate(22));
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

    public static HashMap findMapAllByLoc(int loc){
        HashMap hm = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee WHERE delete_date is null AND " + LOC + "=?");
            pst.setInt(1,loc);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Employee emp = new Employee();
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15) );
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));

                hm.put(new Integer(rs.getInt(1)),emp);
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

    public static ArrayList findAvaiableByLoc(int loc, Date dt, int pageNum){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            //System.out.println("findAvaiableByLoc "+pageNum);
            int day = DateUtil.getDayOfWeek(dt);
            dbm = new DBManager();
//            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
//                    + SCH + "," + COMM + "," + LOC +  "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + " FROM employee WHERE (delete_date>DATE(?) OR delete_date is null) AND " + LOC + "=? AND MID(" + SCH + "," + day + ",1)='1' LIMIT "+pageNum*8+",8");
            String query = "SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC + "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM ("+
                    "SELECT * FROM employee WHERE (delete_date>DATE(?) OR delete_date is null) AND " + LOC + "=? and (SUBSTRING(schedule,?,1))=1 \n" +
                "union \n" +
                    "select emp.* from `employee` emp \n" +
                    "left join `workingtime_emp` wor on wor.`employee_id` = emp.`id`\n" +
                    "where emp.deleted=0 and emp."+ LOC + "= ? and wor.type = 1 and wor.`work_date` = DATE(?) \n"+
                "union\n" +
                    "select e.* from employee e\n" +
                    "inner join appointment a on e.`id`=a.`employee_id`\n" +
                    "where a.`appt_date`=DATE(?)\n" +
                ") as empp  LIMIT "+pageNum*8+",8";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setDate(1,dt);
            pst.setInt(2,loc);
            pst.setInt(3,day);
            pst.setInt(4,loc);
            pst.setDate(5,dt);
            pst.setDate(6,dt);
            //System.out.println(pst.toString());
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
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


    public static ArrayList findAll(int offset, int size){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + "," + LNAME + "," + LOGIN + ","
                    + SCH + "," + COMM + "," + LOC +  "," + PIC + "," + SSEC + "," + EMAIL + "," + SALARY + "," + COMMENT +  "," + ONEDAY + "," + MALE_FEMALE + "," + DESCRIPTION + "," + ADDRESS + "," + CITY + "," + POSTCODE + "," + HOMEPHONE + "," + CELLPHONE + "," + HIREDATE + "," + TERMDATE + " FROM employee WHERE delete_date is null LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
                emp.setLogin_id(rs.getInt(4));
                emp.setSchedule(rs.getString(5));
                emp.setCommission(rs.getBigDecimal(6));
                emp.setLocation_id(rs.getInt(7));
                emp.setPicture(rs.getBlob(8));
                /*emp.setH_from(rs.getTime(9));
                emp.setH_to(rs.getTime(10));*/
                emp.setS_security(rs.getString(9));
                emp.setEmail(rs.getString(10));
                emp.setSalary(rs.getString(11));
                emp.setComment(rs.getString(12));
                emp.setOneday(rs.getBoolean(13));
                emp.setMale_female(rs.getInt(14));
                emp.setDescription(rs.getString(15));
                emp.setAddress(rs.getString(16));
                emp.setCity(rs.getString(17));
                emp.setPostcode(rs.getString(18));
                emp.setHomephone(rs.getString(19));
                emp.setCellphone(rs.getString(20));
                emp.setHiredate(rs.getDate(21));
                emp.setTermdate(rs.getDate(22));
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

    public static HashMap findAllMap(){
        HashMap list = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + FNAME + ", " + LNAME + " FROM employee WHERE delete_date is null ORDER BY CONCAT("+FNAME+",' ',"+LNAME+")");
            while(rs.next()){
                list.put(rs.getString(1), rs.getString(2) + " " + rs.getString(3));
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

    public static ArrayList findAllWithDeletedArrOrderByName(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + FNAME + ", " + LNAME + " FROM employee ORDER BY CONCAT("+FNAME+",' ',"+LNAME+")");
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

    public static ArrayList findWorkingEmp(String from_date, String to_date){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT emp.`id`, emp.`fname`, emp.`lname` from `reconciliation` rec\n" +
                    "join `ticket` tic on tic.`code_transaction` = rec.`code_transaction`\n" +
                    "join `employee` emp on emp.`id` = tic.`employee_id`\n" +
                    "where rec.status <> 1 and DATE(rec.`created_dt`) BETWEEN DATE('"+from_date+"') AND DATE('"+to_date+"')\n" +
                    "group by emp.`id` ORDER BY CONCAT(emp."+FNAME+",' ',emp."+LNAME+")");
            while(rs.next()){
                Employee emp = new Employee();
                list.add(emp);
                emp.setId(rs.getInt(1));
                emp.setFname(rs.getString(2));
                emp.setLname(rs.getString(3));
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

    public static HashMap findAllMapWithDeleted(){
        HashMap list = new HashMap();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + FNAME + ", " + LNAME + " FROM employee");
            while(rs.next()){
                list.put(rs.getString(1), rs.getString(2) + " " + rs.getString(3));
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
