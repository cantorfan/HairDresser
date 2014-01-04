package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import javax.mail.internet.MimeMessage;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMultipart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Transport;
import javax.mail.MessagingException;
import java.sql.*;
import java.sql.Date;
import java.util.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class Customer {
    public static final String ID = "id";
    public static final String FNAME = "fname";
    public static final String LNAME = "lname";
    public static final String EMAIL = "email";
    public static final String PHONE = "phone";
    public static final String CELL = "cell_phone";
    public static final String TYPE = "type";
    public static final String LOC = "location_id";
    public static final String REQ = "req";
    public static final String REM = "reminder";
    public static final String REMDAYS = "remdays";
    public static final String COMMENT = "comment";
    public static final String EMPLOYEE = "employee_id";
    public static final String WORK_PHONE_EXT = "work_phone_ext";
    public static final String MALE_FEMALE = "male_female";
    public static final String ADDRESS = "address";
    public static final String CITY = "city";
    public static final String STATE = "state";
    public static final String ZIP_CODE = "zip_code";
    public static final String PICTURE = "picture";
    public static final String WALKIN = "WALKIN";
    public static final String DateOfBirth = "date_of_birth";
    public static final String LOGIN = "login";
    public static final String PASSWORD = "pwd";
    public static final String COUNTRY = "country";

    private int id;
    private String fname;
    private String lname;
    private String email;
    private String phone;
    private String cell_phone;
    private String type;
    private int location_id;
    private Boolean req;
    private Boolean rem;
    private int remdays;
    private String comment;
    private int employee_id;
    private String work_phone_ext;
    private int male_female;
    private String address;
    private String city;
    private String state;
    private String zip_code;
    private Blob picture;
    private Date date_of_birth;
    private String login;
    private String password;
    private int country;

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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCell_phone() {
        return cell_phone;
    }

    public void setCell_phone(String cell_phone) {
        this.cell_phone = cell_phone;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getLocation_id() {
        return location_id;
    }

    public void setLocation_id(int location_id) {
        this.location_id = location_id;
    }

    public Boolean getReq() {
        return req;
    }

    public void setReq(Boolean req) {
        this.req = req;
    }

    public Boolean getRem() {
        return rem;
    }

    public void setRem(Boolean rem) {
        this.rem = rem;
    }

    public int getRemdays() {
        return remdays;
    }

    public void setRemdays(int remdays) {
        this.remdays = remdays;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public Blob getPicture()
    {
        if (this.picture == null)
            return null;
        else
            return this.picture;
    }

    public void setPicture(Blob picture) {
        this.picture = picture;
    }


    public String getWork_phone_ext() {
        return work_phone_ext;
    }

    public String getAddress() {
        return address;
    }

    public String getCity() {
        return city;
    }

    public String getState() {
        return state;
    }

    public String getZip_code() {
        return zip_code;
    }


    public void setWork_phone_ext(String work_phone_ext) {
        this.work_phone_ext = work_phone_ext;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setZip_code(String zip_code) {
        this.zip_code = zip_code;
    }

    public int getMale_female() {
        return male_female;
    }

    public void setMale_female(int male_female) {
        this.male_female = male_female;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getCountry() {
        return country;
    }

    public void setCountry(int country) {
        this.country = country;
    }

    public Date getDate_of_birth()
    {
//        DateFormat formatter ;
//        java.util.Date dDate ;
//        formatter = new SimpleDateFormat("yyyy/MM/dd");
//        dDate = (java.util.Date)formatter.format();//parse(date_of_birth);
        return date_of_birth;
    }

    public void setDate_of_birth(Date date_of_birth) {
        this.date_of_birth = date_of_birth;
    }

    private static Random random = new Random();
    private static int mtRand(int min, int max){


        int range = max-min+1;
        int n = Math.abs(random.nextInt(range))+min;

        return n;
    }


   private static String generateStr(){
       int len = 5;
       String str = "";
       int rnd = 1;
       String c = "";
       for (int i = 0; i<len;i++){
//           rnd = mtRand(0,1);
//           if (rnd == 0){
//               c = String.valueOf(Character.toChars(mtRand(48, 57)));
//           }
           if (rnd == 1){
               c = String.valueOf(Character.toChars(mtRand(97, 122)));
           }
           str+=c;
       }
       return str;
   }

    private static void sendEmail(Customer cust)
    {
        EmailTemplate etp = EmailTemplate.findByType(0);
        if (etp!=null){
            Location loc = Location.findById(etp.getLocation_id());
            String[] tmp;
            String[] addr2;
            String temp;
            String salonname = "";
            String email = "";
            String telephone = "";
            if (loc != null){
                salonname = loc.getName();
                telephone = loc.getPhone();
                email = loc.getEmail();
                tmp = loc.getAddress2().split(";");
                if (!tmp[0].equals("")){
                    for (int i = 0; i<7; i++){
                        temp = tmp[i];
                        addr2 = temp.split(":");
                        if (addr2.length == 2) {
                            if (addr2[0].equals("telephone")){
                                 telephone = addr2[1];
                            }else if (addr2[0].equals("email")){
                                 email = addr2[1];
                            }
                        }
                    }
                }
            }
            String to = cust.getEmail();
//            String from = email.equals("")?"noreply@isalon2you-soft.com":email;
            String from = "noreply@isalon2you-soft.com";
            String subject = "Registering at "+salonname;
            String message = "";
            if (etp != null){
                String template = etp.getText();
                message = template.replace("{customer}",cust.getFname()+" "+cust.getLname()).replace("{login}",cust.getLogin()).replace("{password}",cust.getPassword()).replace("{salonname}",salonname).replace("{salonphone}",telephone);
            }
            String host = "localhost";
    //        String host = "inmarsoft.com";
            boolean debug = false;
            boolean returnValue = false;
            // ������������� ��������� � �������� ������ �� ���������
            Properties props = new Properties();
            props.put("mail.smtp.host", host);


            javax.mail.Session session = javax.mail.Session.getDefaultInstance(props, null);
            session.setDebug(debug);

           props = null;
            MimeMessage msg = null;
            try {
                // ������� ���������
                msg = new MimeMessage(session);
                msg.setFrom(new InternetAddress(from));
                InternetAddress[] address = {new InternetAddress(to)};
                msg.setRecipients(Message.RecipientType.TO, address);
                msg.setSubject(subject);
                msg.setSentDate(Calendar.getInstance().getTime());

                // ������� � ��������� ������ ����� ���������
                MimeBodyPart mbp1 = new MimeBodyPart();
                mbp1.setText(message);

    //            MimeBodyPart mbp1File = new MimeBodyPart();

    //            mbp1File.setFileName(generate.getName());
    //            mbp1File.attachFile(generate.getName() + ".pdf");

                // ������� Multipart � ��������� � ���� ����� ��������� �����
                Multipart mp = new MimeMultipart();
                mp.addBodyPart(mbp1);
    //            mp.addBodyPart(mbp1File);

                // ��������� Multipart � ���������
                msg.setContent(mp);

    //            Logs.log(0,"to:"+to+";from:"+from+";subject:"+subject+";SendEmail;");
                // �������� ���������
                Transport.send(msg);


            }
            catch (MessagingException mex)
            {
    //            Logs.log(0,"to:"+to+";from:"+from+";subject:"+subject+";ex:"+mex.getMessage()+";stack:"+ Arrays.toString(mex.getStackTrace()));
                mex.printStackTrace();
                Exception ex = null;
                if ((ex = mex.getNextException()) != null) {
                    ex.printStackTrace();
                }
            }
            catch(Exception ex)
            {
                ex.printStackTrace();
            }
            msg = null;
        }
    }

    public static Customer insertCustomer(String fname, String lname, String email, String phone, String cell, String type, int loc_id, Boolean req, Boolean Reminder, int ReminderDays, String comment, int emp_id, String work_phone_ext, int male_female, String address, String city, String state, String zip_code, Blob picture, Date b_date, int country) {
        String login = "";
        String pwd = "";
        if (!email.equals("")){
            login = generateStr();
            pwd = generateStr();
            while (findByLogin(login)!=null){
                login = generateStr();
            }

        }
        Customer cust = null;
        DBManager dbm = null;
        String fname_s = "";
        String lname_s = "";
        if(fname.length() > 0)
            fname_s = fname.substring(0,1).toUpperCase()+fname.substring(1,fname.length()).toLowerCase();
        if(lname.length() > 0)
            lname_s = lname.substring(0,1).toUpperCase()+lname.substring(1,lname.length()).toLowerCase();
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT customer (" + FNAME + ", " + LNAME + ", " + EMAIL + ", " + PHONE + ", " + CELL
                    + ", " + TYPE + ", " + LOC + ", " + REM + ", " + REMDAYS + ", " + REQ + ", " + COMMENT + ", " + EMPLOYEE + ", "
                    + WORK_PHONE_EXT + ", " + MALE_FEMALE +  ", " + ADDRESS + ", " + CITY + ", " + STATE + ", " + ZIP_CODE + ", " + PICTURE + ", "+ DateOfBirth + ", "+ LOGIN + ", "+ PASSWORD + ", "+ COUNTRY + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
            pst.setString(1, fname_s);
            pst.setString(2, lname_s);
            pst.setString(3, email);
            pst.setString(4, phone);
            pst.setString(5, cell);
            pst.setString(6, type);
            pst.setInt(7, loc_id);
            pst.setBoolean(8, Reminder);
            pst.setInt(9, ReminderDays);
            pst.setBoolean(10, req);
            pst.setString(11, comment);
            pst.setInt(12, emp_id);
            pst.setString(13, work_phone_ext);
            pst.setInt(14, male_female);
            pst.setString(15, address);
            pst.setString(16, city);
            pst.setString(17, state);
            pst.setString(18, zip_code);
            pst.setBlob(19, picture);
            pst.setDate(20,b_date);
            pst.setString(21,login);
            pst.setString(22,pwd);
            pst.setInt(23,country);

            int rows = pst.executeUpdate();
            
            if (rows >= 0) {
                cust = new Customer();
                cust.setFname(fname);
                cust.setLname(lname);
                cust.setEmail(email);
                cust.setPhone(phone);
                cust.setCell_phone(cell);
                cust.setType(type);
                cust.setLocation_id(loc_id);
                cust.setReq(req);
                cust.setRem(Reminder);
                cust.setRemdays(ReminderDays);
                cust.setComment(comment);
                cust.setEmployee_id(emp_id);
                cust.setWork_phone_ext(work_phone_ext);
                cust.setMale_female(male_female);
                cust.setAddress(address);
                cust.setCity(city);
                cust.setState(state);
                cust.setZip_code(zip_code);
                cust.setPicture(picture);
                cust.setDate_of_birth(b_date);
                cust.setLogin(login);
                cust.setPassword(pwd);
                cust.setCountry(country);

                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next())
                    cust.setId(rs.getInt(1));
                rs.close();
            }
            if (cust!=null && !cust.getEmail().equals("")){
                sendEmail(cust);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cust;
    }

    public static Customer updateCustomer(int id, String fname, String lname, String email, String phone, String cell, String type, int loc_id, Boolean req, Boolean Reminder, int ReminderDays, String comment, int emp_id, String work_phone_ext, int male_female, String address, String city, String state, String zip_code, Blob picture, Date b_date, int country) {
        Customer cust = null;
        DBManager dbm = null;
        String fname_s = fname.substring(0,1).toUpperCase()+fname.substring(1,fname.length());
        String lname_s = lname.substring(0,1).toUpperCase()+lname.substring(1,lname.length());
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE customer SET " + FNAME + "=?, " + LNAME + "=?, " + EMAIL + "=?, " + PHONE + "=?, "
                    + CELL + "=?," + TYPE + "=?, " + LOC + "=?," + REM + "=?," + REMDAYS + "=?," + REQ + "=?," + COMMENT + "=?,"
                    + EMPLOYEE + "=?," + WORK_PHONE_EXT + "=?," + MALE_FEMALE +  "=?," + ADDRESS + "=?," + CITY + "=?," + STATE + "=?, "+ ZIP_CODE + "=?," + PICTURE + "=?," + DateOfBirth +"=?," + COUNTRY +"=? WHERE " + ID + "=?");
            pst.setString(1, fname_s);
            pst.setString(2, lname_s);
            pst.setString(3, email);
            pst.setString(4, phone);
            pst.setString(5, cell);
            pst.setString(6, type);
            pst.setInt(7, loc_id);
            pst.setBoolean(8, Reminder);
            pst.setInt(9, ReminderDays);
            pst.setBoolean(10, req);
            pst.setString(11, comment);
            pst.setInt(12, emp_id);
            pst.setString(13, work_phone_ext);
            pst.setInt(14, male_female);
            pst.setString(15, address);
            pst.setString(16, city);
            pst.setString(17, state);
            pst.setString(18, zip_code);
            pst.setBlob(19, picture);
            pst.setDate(20,b_date);
            pst.setInt(21, country);
            pst.setInt(22, id);

            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cust = new Customer();
                cust.setId(id);
                cust.setFname(fname);
                cust.setLname(lname);
                cust.setEmail(email);
                cust.setPhone(phone);
                cust.setCell_phone(cell);
                cust.setType(type);
                cust.setLocation_id(loc_id);
                cust.setReq(req);
                cust.setRem(Reminder);
                cust.setRemdays(ReminderDays);
                cust.setComment(comment);
                cust.setEmployee_id(emp_id);
                cust.setWork_phone_ext(work_phone_ext);
                cust.setMale_female(male_female);
//                cust.setAddress(address);
                cust.setCity(city);
                cust.setState(state);
                cust.setZip_code(zip_code);
                cust.setPicture(picture);
                cust.setDate_of_birth(b_date);
                cust.setCountry(country);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cust;
    }
    public static Customer updateCustomerFromQuickSchedulePopup(int id, String fname, String lname, String email, String phone, String cell, int loc_id, int emp_id, String work_phone_ext, int male_female, String address, String city, String state, String zip_code, Date b_date, int country) {
        Customer cust = null;
        DBManager dbm = null;
        String fname_s = fname.substring(0,1).toUpperCase()+fname.substring(1,fname.length());
        String lname_s = lname.substring(0,1).toUpperCase()+lname.substring(1,lname.length());
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE customer SET " + FNAME + "=?, " + LNAME + "=?, " + EMAIL + "=?, " + PHONE + "=?, "
                    + CELL + "=?," + LOC + "=?," + EMPLOYEE + "=?," + WORK_PHONE_EXT + "=?," + MALE_FEMALE +  "=?," + ADDRESS + "=?," + CITY + "=?," + STATE + "=?, "+ ZIP_CODE + "=?," + DateOfBirth +"=?," + COUNTRY +"=? WHERE " + ID + "=?");
            pst.setString(1, fname_s);
            pst.setString(2, lname_s);
            pst.setString(3, email);
            pst.setString(4, phone);
            pst.setString(5, cell);
//            pst.setString(6, type);
            pst.setInt(6, loc_id);
//            pst.setBoolean(8, Reminder);
//            pst.setInt(9, ReminderDays);
//            pst.setBoolean(10, req);
//            pst.setString(11, comment);
            pst.setInt(7, emp_id);
            pst.setString(8, work_phone_ext);
            pst.setInt(9, male_female);
            pst.setString(10, address);
            pst.setString(11, city);
            pst.setString(12, state);
            pst.setString(13, zip_code);
//            pst.setBlob(19, picture);
            pst.setDate(14,b_date);
            pst.setInt(15, country);
            pst.setInt(16, id);

            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cust  = findById(id);
//                cust.setId(id);
//                cust.setFname(fname);
//                cust.setLname(lname);
//                cust.setEmail(email);
//                cust.setPhone(phone);
//                cust.setCell_phone(cell);
//                cust.setType(type);
//                cust.setLocation_id(loc_id);
//                cust.setReq(req);
//                cust.setRem(Reminder);
//                cust.setRemdays(ReminderDays);
//                cust.setComment(comment);
//                cust.setEmployee_id(emp_id);
//                cust.setWork_phone_ext(work_phone_ext);
//                cust.setMale_female(male_female);
//                cust.setAddress(address);
//                cust.setCity(city);
//                cust.setState(state);
//                cust.setZip_code(zip_code);
//                cust.setPicture(picture);
//                cust.setDate_of_birth(b_date);
//                cust.setCountry(country);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cust;
    }

    public static Customer updateCustomerFromQuickSchedule(int id, String fname, String lname, String email, String phone, String cell, String type, int loc_id, Boolean req, Boolean Reminder, int ReminderDays, String comment, int emp_id, String work_phone_ext, int male_female, String address, String city, String state, String zip_code, Blob picture, Date b_date, int country) {
        Customer cust = null;
        DBManager dbm = null;
        String fname_s = fname.substring(0,1).toUpperCase()+fname.substring(1,fname.length());
        String lname_s = lname.substring(0,1).toUpperCase()+lname.substring(1,lname.length());
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE customer SET " + FNAME + "=?, " + LNAME + "=?, " + EMAIL + "=?, " + PHONE + "=?, "
                    + CELL + "=?," + LOC + "=?," + REM + "=?," + REMDAYS + "=?," + REQ + "=?," + COMMENT + "=?,"
                    + EMPLOYEE + "=? WHERE " + ID + "=?");
            pst.setString(1, fname_s);
            pst.setString(2, lname_s);
            pst.setString(3, email);
            pst.setString(4, phone);
            pst.setString(5, cell);
//            pst.setString(6, type);
            pst.setInt(6, loc_id);
            pst.setBoolean(7, Reminder);
            pst.setInt(8, ReminderDays);
            pst.setBoolean(9, req);
            pst.setString(10, comment);
            pst.setInt(11, emp_id);
//            pst.setString(13, work_phone_ext);
//            pst.setInt(14, male_female);
//            pst.setString(15, address);
//            pst.setString(16, city);
//            pst.setString(17, state);
//            pst.setString(18, zip_code);
//            pst.setBlob(19, picture);
//            pst.setDate(20,b_date);
//            pst.setInt(21, country);
            pst.setInt(12, id);

            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cust = findById(id);
//                cust.setId(id);
//                cust.setFname(fname);
//                cust.setLname(lname);
//                cust.setEmail(email);
//                cust.setPhone(phone);
//                cust.setCell_phone(cell);
//                cust.setType(type);
//                cust.setLocation_id(loc_id);
//                cust.setReq(req);
//                cust.setRem(Reminder);
//                cust.setRemdays(ReminderDays);
//                cust.setComment(comment);
//                cust.setEmployee_id(emp_id);
//                cust.setWork_phone_ext(work_phone_ext);
//                cust.setMale_female(male_female);
////                cust.setAddress(address);
//                cust.setCity(city);
//                cust.setState(state);
//                cust.setZip_code(zip_code);
//                cust.setPicture(picture);
//                cust.setDate_of_birth(b_date);
//                cust.setCountry(country);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cust;
    }

    public static Customer deleteCustomer(int id) {
        Customer cust = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM customer WHERE " + ID + "=?");
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                cust = new Customer();
                cust.setId(id);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cust;
    }

    public static Customer findById(int id) {
        Customer cust = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + EMAIL + "," + PHONE + "," + CELL
                    + "," + TYPE + "," + LOC + "," + REQ + "," + REM + "," + REMDAYS + "," + COMMENT + "," + EMPLOYEE + ","
                    + WORK_PHONE_EXT + ", " + MALE_FEMALE +  ", " + ADDRESS + ", " + CITY + ", " + STATE + ", "  + ZIP_CODE + ", " + PICTURE + ", "+ DateOfBirth + ", "+ LOGIN + ", "+ PASSWORD + ", "+ COUNTRY + " FROM customer WHERE " + ID + "=?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                cust = new Customer();
                cust.setId(rs.getInt(1));
                cust.setFname(rs.getString(2));
                cust.setLname(rs.getString(3));
                cust.setEmail(rs.getString(4));
                cust.setPhone(rs.getString(5));
                cust.setCell_phone(rs.getString(6));
                cust.setType(rs.getString(7));
                cust.setLocation_id(rs.getInt(8));
                cust.setReq(rs.getBoolean(9));
                cust.setRem(rs.getBoolean(10));
                cust.setRemdays(rs.getInt(11));
                cust.setComment(rs.getString(12));
                cust.setEmployee_id(rs.getInt(13));
                cust.setWork_phone_ext(rs.getString(14));
                cust.setMale_female(rs.getInt(15));
                cust.setAddress(rs.getString(16));
                cust.setCity(rs.getString(17));
                cust.setState(rs.getString(18));
                cust.setZip_code(rs.getString(19));
                cust.setPicture(rs.getBlob(20));
                cust.setDate_of_birth(rs.getDate(21));
                cust.setLogin(rs.getString(22));
                cust.setPassword(rs.getString(23));
                cust.setCountry(rs.getInt(24));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cust;
    }


    public static Customer findByLogin(String login) {
        Customer cust = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + "," + LNAME + "," + EMAIL + "," + PHONE + "," + CELL
                    + "," + TYPE + "," + LOC + "," + REQ + "," + REM + "," + REMDAYS + "," + COMMENT + "," + EMPLOYEE + ","
                    + WORK_PHONE_EXT + ", " + MALE_FEMALE +  ", " + ADDRESS + ", " + CITY + ", " + STATE + ", "  + ZIP_CODE + ", " + PICTURE + ", "+ DateOfBirth + ", "+ LOGIN + ", "+ PASSWORD + ", "+ COUNTRY + " FROM customer WHERE " + LOGIN + "=?");
            pst.setString(1, login);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                cust = new Customer();
                cust.setId(rs.getInt(1));
                cust.setFname(rs.getString(2));
                cust.setLname(rs.getString(3));
                cust.setEmail(rs.getString(4));
                cust.setPhone(rs.getString(5));
                cust.setCell_phone(rs.getString(6));
                cust.setType(rs.getString(7));
                cust.setLocation_id(rs.getInt(8));
                cust.setReq(rs.getBoolean(9));
                cust.setRem(rs.getBoolean(10));
                cust.setRemdays(rs.getInt(11));
                cust.setComment(rs.getString(12));
                cust.setEmployee_id(rs.getInt(13));
                cust.setWork_phone_ext(rs.getString(14));
                cust.setMale_female(rs.getInt(15));
                cust.setAddress(rs.getString(16));
                cust.setCity(rs.getString(17));
                cust.setState(rs.getString(18));
                cust.setZip_code(rs.getString(19));
                cust.setPicture(rs.getBlob(20));
                cust.setDate_of_birth(rs.getDate(21));
                cust.setLogin(rs.getString(22));
                cust.setPassword(rs.getString(23));
                cust.setCountry(rs.getInt(24));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cust;
    }

    public static ArrayList findAll() {//List<Customer> findAll(){
        ArrayList list = new ArrayList();//List<Customer> list = new ArrayList<Customer>();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + EMAIL + ", " + PHONE + ", " + CELL
                    + ", " + TYPE + ", " + LOC + ", " + REQ + ","
                    + WORK_PHONE_EXT + ", " + MALE_FEMALE +  ", " + ADDRESS + ", " + CITY + ", "  + STATE + ", " + ZIP_CODE + ", " + PICTURE +"," + DateOfBirth +"," + COUNTRY +" FROM customer ORDER BY " + FNAME + "");
            while (rs.next()) {
                Customer cust = new Customer();
                list.add(cust);
                cust.setId(rs.getInt(1));
                cust.setFname(rs.getString(2));
                cust.setLname(rs.getString(3));
                cust.setEmail(rs.getString(4));
                cust.setPhone(rs.getString(5));
                cust.setCell_phone(rs.getString(6));
                cust.setType(rs.getString(7));
                cust.setLocation_id(rs.getInt(8));
                cust.setReq(rs.getBoolean(9));
                cust.setWork_phone_ext(rs.getString(10));
                cust.setMale_female(rs.getInt(11));
                cust.setAddress(rs.getString(12));
                cust.setCity(rs.getString(13));
                cust.setState(rs.getString(14));
                cust.setZip_code(rs.getString(15));
                cust.setPicture(rs.getBlob(16));
                cust.setDate_of_birth(rs.getDate(17));
                cust.setCountry(rs.getInt(18));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findAll(int offset, int size) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + EMAIL + ", " + PHONE + ", " + CELL
                    + ", " + TYPE + ", " + LOC + ", " + REQ + ","
                    + WORK_PHONE_EXT + ", " + MALE_FEMALE +  ", " + ADDRESS + ", " + CITY + ", " + STATE + ", " + ZIP_CODE + ", " + PICTURE + ","+ DateOfBirth +","+ COUNTRY +" FROM customer order by "+ FNAME + ", " + LNAME + " LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while (rs.next()) {
                Customer cust = new Customer();
                list.add(cust);
                cust.setId(rs.getInt(1));
                cust.setFname(rs.getString(2));
                cust.setLname(rs.getString(3));
                cust.setEmail(rs.getString(4));
                cust.setPhone(rs.getString(5));
                cust.setCell_phone(rs.getString(6));
                cust.setType(rs.getString(7));
                cust.setLocation_id(rs.getInt(8));
                cust.setReq(rs.getBoolean(9));
                cust.setWork_phone_ext(rs.getString(10));
                cust.setMale_female(rs.getInt(11));
                cust.setAddress(rs.getString(12));
                cust.setCity(rs.getString(13));
                cust.setState(rs.getString(14));
                cust.setZip_code(rs.getString(15));
                cust.setPicture(rs.getBlob(16));
                cust.setDate_of_birth(rs.getDate(17));
                cust.setCountry(rs.getInt(18));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
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
            ResultSet rs = st.executeQuery("SELECT count(*) as cnt FROM customer"); //TODO FOUND_ROWS()
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

    public static ArrayList findByFilter(String filter) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + EMAIL + ", " + PHONE + ", " + CELL
                    + ", " + TYPE + ", " + LOC + ", " + REQ + ","
                    + WORK_PHONE_EXT + ", " + MALE_FEMALE +  ", " + ADDRESS + ", " + CITY + ", " + STATE + ", " + ZIP_CODE + ", " + PICTURE + ", " + DateOfBirth + ", " + COUNTRY + " FROM customer WHERE " + filter);
            while (rs.next()) {
                Customer cust = new Customer();
                list.add(cust);
                cust.setId(rs.getInt(1));
                cust.setFname(rs.getString(2));
                cust.setLname(rs.getString(3));
                cust.setEmail(rs.getString(4));
                cust.setPhone(rs.getString(5));
                cust.setCell_phone(rs.getString(6));
                cust.setType(rs.getString(7));
                cust.setLocation_id(rs.getInt(8));
                cust.setReq(rs.getBoolean(9));
                cust.setWork_phone_ext(rs.getString(10));
                cust.setMale_female(rs.getInt(11));
                cust.setAddress(rs.getString(12));
                cust.setCity(rs.getString(13));
                cust.setState(rs.getString(14));
                cust.setZip_code(rs.getString(15));
                cust.setPicture(rs.getBlob(16));
                cust.setDate_of_birth(rs.getDate(17));
                cust.setCountry(rs.getInt(18));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static int countByFilter(String filter) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        int cnt = 0;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT count(*) FROM customer WHERE " + filter);
            while(rs.next()){
                cnt = rs.getInt(1);
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return cnt;
    }

    public static HashMap findAllMap() {
        HashMap list = new HashMap();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + ", " + FNAME + ", " + LNAME + " FROM customer");
            while (rs.next()) {
                list.put(rs.getString(1), rs.getString(2) + " " + rs.getString(3));
            }
            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }
}
