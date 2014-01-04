package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class Vendor {
    //vendor name, Vendor Address ,Vendor city, Vendor zip, Vendor country,vendor phone number ,vender email address
    public static final String ID = "id";
    public static final String NAME = "name";
    public static final String ADDRESS = "address";
    public static final String CITY = "city";
    public static final String ZIP = "zip";
    public static final String COUNTRY = "country";
    public static final String PHONE_NUMBER = "phone_number";
    public static final String EMAIL_ADDRESS = "email_address";
    public static final String CONTACT_NAME = "contact_name";
    public static final String PH_NUM_CONTACT = "ph_num_contact";
    public static final String WEBSITE = "website";
    public static final String STATE = "state";

    private int id;
    private String name;
    private String address;
    private String city;
    private String zip;
    private String country;
    private String phone_number;
    private String email_address;
    private String contact_name;
    private String ph_num_contact;
    private String website;
    private String state;

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

    public String getAddress()
    {
        return address;
    }
    public void setAddress(String address)
    {
        this.address = address;
    }

    public String getCity()
    {
        return city;
    }
    public void setCity(String city)
    {
        this.city = city;
    }

    public String getZip()
    {
        return zip;
    }
    public void setZip(String zip)
    {
        this.zip = zip;
    }

    public String getCountry()
    {
        return country;
    }
    public void setCountry(String country)
    {
        this.country = country;
    }

    public String getPhoneNumber()
    {
        return phone_number;
    }
    public void setPhoneNumber(String phone_number)
    {
        this.phone_number = phone_number;
    }

    public String getEmailAddress()
    {
        return email_address;
    }
    public void setEmailAddress(String email_address)
    {
        this.email_address = email_address;
    }

    public String getContact_name() {
        return contact_name;
    }

    public void setContact_name(String contact_name) {
        this.contact_name = contact_name;
    }

    public String getPh_num_contact() {
        return ph_num_contact;
    }

    public void setPh_num_contact(String ph_num_contact) {
        this.ph_num_contact = ph_num_contact;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public static Vendor insertVendor(String name, String address,String city, String zip, String country,String phone_number,String email_address,String contact_name,String ph_num_contact,String website, String state)
    {
        Vendor ven = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT vendor (" + NAME + ", " + ADDRESS + ", " + CITY + ", " + ZIP + ", "
                     + COUNTRY + ", " + PHONE_NUMBER + ", " + EMAIL_ADDRESS +  ", " + CONTACT_NAME +  ", " + PH_NUM_CONTACT +  ", " + WEBSITE + ", " + STATE + ") VALUES (?,?,?,?,?,?,?,?,?,?,?)");
            pst.setString(1,name);
            pst.setString(2,address);
            pst.setString(3,city);
            pst.setString(4,zip);
            pst.setString(5,country);
            pst.setString(6,phone_number);
            pst.setString(7,email_address);
            pst.setString(8,contact_name);
            pst.setString(9,ph_num_contact);
            pst.setString(10,website);
            pst.setString(11,state);
            int rows = pst.executeUpdate();
            if(rows>=0)
            {
                ven = new Vendor();
                ven.setName(name);
                ven.setAddress(address);
                ven.setCity(city);
                ven.setZip(zip);
                ven.setCountry(country);
                ven.setPhoneNumber(phone_number);
                ven.setEmailAddress(email_address);
                ven.setContact_name(contact_name);
                ven.setPh_num_contact(ph_num_contact);
                ven.setWebsite(website);
                ven.setState(state);

                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    ven.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ven;
    }

    public static Vendor updateVendor(int id, String name, String address,String city, String zip, String country,String phone_number,String email_address,String contact_name,String ph_num_contact,String website,String state){
        Vendor ven = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE vendor SET " + NAME + "=?, " + ADDRESS + "=?, " + CITY + "=?, " + ZIP + "=?, "
                 + COUNTRY + "=?, " + PHONE_NUMBER + "=?, " + EMAIL_ADDRESS + "=?, " + CONTACT_NAME + "=?, " + PH_NUM_CONTACT + "=?, " + WEBSITE + "=?, " + STATE + "=? WHERE " + ID + "=?");
            pst.setString(1,name);
            pst.setString(2,address);
            pst.setString(3,city);
            pst.setString(4,zip);
            pst.setString(5,country);
            pst.setString(6,phone_number);
            pst.setString(7,email_address);
            pst.setString(8,contact_name);
            pst.setString(9,ph_num_contact);
            pst.setString(10,website);
            pst.setString(11,state);
            pst.setInt(12,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ven = new Vendor();
                ven.setId(id);
                ven.setName(name);
                ven.setAddress(address);
                ven.setCity(city);
                ven.setZip(zip);
                ven.setCountry(country);
                ven.setPhoneNumber(phone_number);
                ven.setEmailAddress(email_address);
                ven.setContact_name(contact_name);
                ven.setPh_num_contact(ph_num_contact);
                ven.setWebsite(website);
                ven.setState(state);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ven;
    }

    public static Vendor deleteVendor(int id){
        Vendor ven = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM vendor WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                ven = new Vendor();
                ven.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ven;
    }

    public static Vendor findById(int id){
        Vendor ven = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + NAME + ", " + ADDRESS + ", " + CITY + ", " + ZIP + ", "
                     + COUNTRY + ", " + PHONE_NUMBER + ", "+ EMAIL_ADDRESS + ", "+ CONTACT_NAME + ", "+ PH_NUM_CONTACT + ", "+ WEBSITE + ", "+ STATE + " FROM vendor WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                ven = new Vendor();
                ven.setId(rs.getInt(1));
                ven.setName(rs.getString(2));
                ven.setAddress(rs.getString(3));
                ven.setCity(rs.getString(4));
                ven.setZip(rs.getString(5));
                ven.setCountry(rs.getString(6));
                ven.setPhoneNumber(rs.getString(7));
                ven.setEmailAddress(rs.getString(8));
                ven.setContact_name(rs.getString(9));
                ven.setPh_num_contact(rs.getString(10));
                ven.setWebsite(rs.getString(11));
                ven.setState(rs.getString(12));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return ven;
    }

    public static ArrayList findAll(){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + ADDRESS + ", " + CITY + ", " + ZIP + ","
                     + COUNTRY + ", " + PHONE_NUMBER + ", "+ EMAIL_ADDRESS + ", "+ CONTACT_NAME + ", "+ PH_NUM_CONTACT + ", "+ WEBSITE + ", "+ STATE + " FROM vendor");
            while(rs.next()){
                Vendor ven = new Vendor();
                list.add(ven);
                ven.setId(rs.getInt(1));
                ven.setName(rs.getString(2));
                ven.setAddress(rs.getString(3));
                ven.setCity(rs.getString(4));
                ven.setZip(rs.getString(5));
                ven.setCountry(rs.getString(6));
                ven.setPhoneNumber(rs.getString(7));
                ven.setEmailAddress(rs.getString(8));
                ven.setContact_name(rs.getString(9));
                ven.setPh_num_contact(rs.getString(10));
                ven.setWebsite(rs.getString(11));
                ven.setState(rs.getString(12));
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
            ResultSet rs = st.executeQuery("SELECT count(*) FROM vendor");
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
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + NAME + ", " + ADDRESS + ", " + CITY + ", " + ZIP + ","
                + COUNTRY + ", " + PHONE_NUMBER + ", " + EMAIL_ADDRESS + ", " + CONTACT_NAME + ", " + PH_NUM_CONTACT + ", " + WEBSITE + ", " + STATE + " FROM vendor LIMIT " + offset + "," + size);
            while(rs.next()){
                Vendor ven = new Vendor();
                list.add(ven);
                ven.setId(rs.getInt(1));
                ven.setName(rs.getString(2));
                ven.setAddress(rs.getString(3));
                ven.setCity(rs.getString(4));
                ven.setZip(rs.getString(5));
                ven.setCountry(rs.getString(6));
                ven.setPhoneNumber(rs.getString(7));
                ven.setEmailAddress(rs.getString(8));
                ven.setContact_name(rs.getString(9));
                ven.setPh_num_contact(rs.getString(10));
                ven.setWebsite(rs.getString(11));
                ven.setState(rs.getString(12));
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
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + NAME + " FROM vendor");
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
