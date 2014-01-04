package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Blob;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

public class Location {
    public static final String ID = "id";
    public static final String NAME = "name";
    public static final String ADDR = "address";
    public static final String ADDR2 = "address2";
//    public static final String BUSHOURS = "businesshours";
    public static final String CUR = "currency";
    public static final String TAX = "taxes";
    public static final String LOGO = "logo";
    public static final String COUNTRY = "country";
    public static final String STATE = "state";
    public static final String CITY = "city";
    public static final String ZIPCODE = "zipcode";
    public static final String PHONE = "phone";
    public static final String FAX = "fax";
    public static final String EMAIL = "email";
    public static final String FACEBOOK = "facebook";
    public static final String TWITTER = "twitter";
    public static final String BLOGGER = "blogger";
    public static final String TIMEZONE = "timezone";

    private int id;
    private String name;
    private String address;
    private String address2;
//    private String businesshours;
    private String currency;
    private String country;
    private String state;
    private String city;
    private String zipcode;
    private String phone;
    private String fax;
    private String email;
    private String facebook;
    private String twitter;
    private String blogger;
    private BigDecimal taxes;
    private Blob logo;
    private String timezone;

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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

//    public String getBusinesshours() {
//        return businesshours;
//    }
//
//    public void setBusinesshours(String businesshours) {
//        this.businesshours = businesshours;
//    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFacebook() {
        return facebook;
    }

    public void setFacebook(String facebook) {
        this.facebook = facebook;
    }

    public String getTwitter() {
        return twitter;
    }

    public void setTwitter(String twitter) {
        this.twitter = twitter;
    }

    public String getBlogger() {
        return blogger;
    }

    public void setBlogger(String blogger) {
        this.blogger = blogger;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public BigDecimal getTaxes() {
        return taxes;
    }

    public void setTaxes(BigDecimal taxes) {
        this.taxes = taxes;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public Blob getLogo() {
        if (this.logo == null)
            return null;
        else
            return this.logo;
    }

    public void setLogo(Blob logo) {
        this.logo = logo;
    }

    public String getTimezone() {
        return timezone;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }

    public static Location insertLocation(String name, String addr, String cur, BigDecimal tax, String addr2,Blob logo, String timezone){
        Location loc = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT location ("+ NAME + ", " + ADDR +", " + CUR + ", " + TAX + ", " + ADDR2 + ", "+ LOGO +", "+ TIMEZONE +") VALUES (?,?,?,?,?,?,?)");
            pst.setString(1,name);
            pst.setString(2,addr);
            pst.setString(3,cur);
            pst.setBigDecimal(4, tax);
            pst.setString(5, addr2);
            pst.setBlob(6, logo);
            pst.setString(7, timezone);
            int rows = pst.executeUpdate();
            if(rows>=0){
                loc = new Location();
                loc.setName(name);
                loc.setAddress(addr);
                loc.setCurrency(cur);
                loc.setTaxes(tax);
                loc.setAddress2(addr2);
                loc.setLogo(logo);
                loc.setTimezone(timezone);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    loc.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return loc;
    }

    public static Location updateLocation(int id, String name, String addr, String cur, BigDecimal tax, String addr2, Blob logo, String country, String state, String city, String zipcode, String phone, String fax, String email, String facebook, String twitter, String blogger, String timezone){
        Location loc = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE location  SET "+ NAME + "=?, " + ADDR +"=?, " + CUR + "=?, " + TAX + "=?," + ADDR2 + "=?,"+LOGO+"=?,"+COUNTRY+"=?,"+STATE+"=?,"+CITY+"=?,"+ZIPCODE+"=?,"+PHONE+"=?,"+FAX+"=?,"+EMAIL+"=?,"+FACEBOOK+"=?,"+TWITTER+"=?,"+BLOGGER+"=?,"+TIMEZONE+"=? WHERE " + ID + "="+id);
            pst.setString(1,name);
            pst.setString(2,addr);
            pst.setString(3,cur);
            pst.setBigDecimal(4, tax);
//            pst.setString(5,bushours);
            pst.setString(5,addr2);
            pst.setBlob(6,logo);
            pst.setString(7,country);
            pst.setString(8,state);
            pst.setString(9,city);
            pst.setString(10,zipcode);
            pst.setString(11,phone);
            pst.setString(12,fax);
            pst.setString(13,email);
            pst.setString(14,facebook);
            pst.setString(15,twitter);
            pst.setString(16,blogger);
            pst.setString(17,timezone);
            int rows = pst.executeUpdate();
            if(rows>=0){
                loc = new Location();
                loc.setId(id);
                loc.setName(name);
                loc.setAddress(addr);
                loc.setCurrency(cur);
                loc.setTaxes(tax);
//                loc.setBusinesshours(bushours);
                loc.setAddress2(addr2);
                loc.setLogo(logo);
                loc.setTimezone(timezone);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return loc;
    }

    public static Location deleteLocation(int id){
        Location loc = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM location WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                loc = new Location();
                loc.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return loc;
    }

    public static Location findById(int id){
        Location loc = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID +", " + NAME + ", " + ADDR +", " + CUR + ", " + TAX + ", " + ADDR2 + ", "+ LOGO +", "+ COUNTRY +", "+ STATE +", "+ CITY +", "+ ZIPCODE +", "+ PHONE +", "+ FAX +", "+ EMAIL +", "+ FACEBOOK +", "+ TWITTER +", "+ BLOGGER +", "+ TIMEZONE +" FROM location WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                loc = new Location();
                loc.setId(rs.getInt(1));
                loc.setName(rs.getString(2));
                loc.setAddress(rs.getString(3));
                loc.setCurrency(rs.getString(4));
                loc.setTaxes(rs.getBigDecimal(5));
                loc.setAddress2(rs.getString(6));
                loc.setLogo(rs.getBlob(7));
                loc.setCountry(rs.getString(8));
                loc.setState(rs.getString(9));
                loc.setCity(rs.getString(10));
                loc.setZipcode(rs.getString(11));
                loc.setPhone(rs.getString(12));
                loc.setFax(rs.getString(13));
                loc.setEmail(rs.getString(14));
                loc.setFacebook(rs.getString(15));
                loc.setTwitter(rs.getString(16));
                loc.setBlogger(rs.getString(17));
                loc.setTimezone(rs.getString(18));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return loc;
    }

    public static Location GetLocation()
    {
        Location loc = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID +", " + NAME + ", " + ADDR +", " + CUR + ", " + TAX + ", " + ADDR2 + ", "+ LOGO +", "+ COUNTRY +", "+ STATE +", "+ CITY +", "+ ZIPCODE +", "+ PHONE +", "+ FAX +", "+ EMAIL +", "+ FACEBOOK +", "+ TWITTER +", "+ BLOGGER +", "+ TIMEZONE +" FROM location limit 0,1 ");
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                loc = new Location();
                loc.setId(rs.getInt(1));
                loc.setName(rs.getString(2));
                loc.setAddress(rs.getString(3));
                loc.setCurrency(rs.getString(4));
                loc.setTaxes(rs.getBigDecimal(5));
                loc.setAddress2(rs.getString(6));
                loc.setLogo(rs.getBlob(7));
                loc.setCountry(rs.getString(8));
                loc.setState(rs.getString(9));
                loc.setCity(rs.getString(10));
                loc.setZipcode(rs.getString(11));
                loc.setPhone(rs.getString(12));
                loc.setFax(rs.getString(13));
                loc.setEmail(rs.getString(14));
                loc.setFacebook(rs.getString(15));
                loc.setTwitter(rs.getString(16));
                loc.setBlogger(rs.getString(17));
                loc.setTimezone(rs.getString(18));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return loc;
    }
    public static ArrayList findAll(){//List<Location> findAll(){
        ArrayList list = new ArrayList();//List<Location> list = new ArrayList<Location>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + ", " + ADDR +", " + CUR + ", " + TAX + ", " + ADDR2 + ", "+ LOGO +", "+ COUNTRY +", "+ STATE +", "+ CITY +", "+ ZIPCODE +", "+ PHONE +", "+ FAX +", "+ EMAIL +", "+ FACEBOOK +", "+ TWITTER +", "+ BLOGGER +", "+ TIMEZONE +" FROM location");
            while(rs.next()){
                Location loc = new Location();
                list.add(loc);
                loc.setId(rs.getInt(1));
                loc.setName(rs.getString(2));
                loc.setAddress(rs.getString(3));
                loc.setCurrency(rs.getString(4));
                loc.setTaxes(rs.getBigDecimal(5));
//                loc.setBusinesshours(rs.getString(6));
                loc.setAddress2(rs.getString(6));
                loc.setLogo(rs.getBlob(7));
                loc.setCountry(rs.getString(8));
                loc.setState(rs.getString(9));
                loc.setCity(rs.getString(10));
                loc.setZipcode(rs.getString(11));
                loc.setPhone(rs.getString(12));
                loc.setFax(rs.getString(13));
                loc.setEmail(rs.getString(14));
                loc.setFacebook(rs.getString(15));
                loc.setTwitter(rs.getString(16));
                loc.setBlogger(rs.getString(17));
                loc.setTimezone(rs.getString(18));
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

//    public static ArrayList findByFilter(String filter){
//        ArrayList list = new ArrayList();
//        DBManager dbm = null;
//        try{
//            dbm = new DBManager();
//            Statement st = dbm.getStatement();
//            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + ", " + ADDR +", " + CUR + ", " + TAX + ", " + ADDR2 + " FROM location WHERE " + filter);
//            while(rs.next()){
//                Location loc = new Location();
//                list.add(loc);
//                loc.setId(rs.getInt(1));
//                loc.setName(rs.getString(2));
//                loc.setAddress(rs.getString(3));
//                loc.setCurrency(rs.getString(4));
//                loc.setTaxes(rs.getBigDecimal(5));
////                loc.setBusinesshours(rs.getString(6));
//                loc.setAddress2(rs.getString(6));
//            }
//            rs.close();
//            st.close();
//        }catch(Exception e){
//            e.printStackTrace();
//        }finally{
//            if(dbm!=null)
//                dbm.close();
//        }
//        return list;
//    }
//
//    public static int countByFilter(String filter){
//        DBManager dbm = null;
//        int cnt = 0;
//        try{
//            dbm = new DBManager();
//            Statement st = dbm.getStatement();
//            ResultSet rs = st.executeQuery("SELECT count(*) FROM location WHERE " + filter);
//            while(rs.next()){
//                cnt = rs.getInt(1);
//            }
//            rs.close();
//            st.close();
//        }catch(Exception e){
//            e.printStackTrace();
//        }finally{
//            if(dbm!=null)
//                dbm.close();
//        }
//        return cnt;
//    }

    public static int countAll(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM location");
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

    public static String getTimezoneForLocation(int idLocation){
        DBManager dbm = null;
        String cnt = "";
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT loc.timezone FROM location loc where loc.id="+idLocation);
            while(rs.next()){
                cnt = rs.getString(1);

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
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + " FROM location");
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
}
