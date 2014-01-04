package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.*;

public class User {
    public static final String TABLE = "login";

    public static final String ID = "id";
    public static final String FNAME = "fname";
    public static final String LNAME = "lname";
    public static final String USER = "user";
    public static final String PWD = "pwd";
    public static final String EMAIL = "email";
    public static final String PERM = "permission";
    public static final String Send_EMAIL = "send_email";

    private int id;
    private String fname;
    private String lname;
    private String user;
    private String pwd;
    private String email;
    private int permission;
    private int send_email;

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

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getPermission() {
        return permission;
    }

    public void setPermission(int permission) {
        this.permission = permission;
    }

    public int getSend_email() {
        return send_email;
    }

    public void setSend_email(int send_email) {
        this.send_email = send_email;
    }

    public static User insertUser(String fname,String lname, String user, String pwd, String email, int perm, int send_email){
        User u = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT login (" + FNAME + ", " + LNAME + ", " + USER + ", " + PWD + ", " + EMAIL
                    + ", "  + PERM + ","+ Send_EMAIL +") VALUES (?,?,?,?,?,?,?)");
            pst.setString(1,fname);
            pst.setString(2,lname);
            pst.setString(3,user);
            pst.setString(4,pwd);
            pst.setString(5,email);
            pst.setInt(6, perm);
            pst.setInt(7, send_email);
            int rows = pst.executeUpdate();
            if(rows>=0){
                u = new User();
                u.setFname(fname);
                u.setLname(lname);
                u.setUser(user);
                u.setPwd(pwd);
                u.setEmail(email);
                u.setPermission(perm);
                u.setSend_email(send_email);
                ResultSet rs = pst.getGeneratedKeys();
                if(rs.next())
                    u.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return u;
    }

    public static User updateUser(int id, String fname,String lname, String user, String pwd, String email, int perm, int send_email){
        User u = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE login SET " + FNAME + "=?, " + LNAME +"=?, " + USER + "=?, "
                    + PWD + "=?, " + EMAIL + "=?,"  + PERM + "=?,"  + Send_EMAIL + "=? WHERE " + ID + "=?");
            pst.setString(1,fname);
            pst.setString(2,lname);
            pst.setString(3,user);
            pst.setString(4,pwd);
            pst.setString(5,email);
            pst.setInt(6, perm);
            pst.setInt(7, send_email);
            pst.setInt(8,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                u = new User();
                u.setId(id);
                u.setFname(fname);
                u.setLname(lname);
                u.setUser(user);
                u.setPwd(pwd);
                u.setEmail(email);
                u.setPermission(perm);
                u.setSend_email(send_email);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return u;
    }

    public static User deleteUser(int id){
        User u = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM login WHERE " + ID + "=?");
            pst.setInt(1,id);
            int rows = pst.executeUpdate();
            if(rows>=0){
                u = new User();
                u.setId(id);
            }
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return u;
    }

    public static User findById(int id){
        User u = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + USER + ", " + PWD + ", " + EMAIL
                    + ", "  + PERM + "," + Send_EMAIL + " FROM login WHERE " + ID + "=?");
            pst.setInt(1,id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                u = new User();
                u.setId(rs.getInt(1));
                u.setFname(rs.getString(2));
                u.setLname(rs.getString(3));
                u.setUser(rs.getString(4));
                u.setPwd(rs.getString(5));
                u.setEmail(rs.getString(6));
                u.setPermission(rs.getInt(7));
                u.setSend_email(rs.getInt(8));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return u;
    }

    public static User findUser(String u, String p){
        User user = null;
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + USER + ", " + PWD + ", " + EMAIL
                    + ", "  + PERM + "," + Send_EMAIL +  " FROM login WHERE " + USER + "=? AND " + PWD + "=?");
            pst.setString(1,u);
            pst.setString(2,p);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                user = new User();
                user.setId(rs.getInt(1));
                user.setFname(rs.getString(2));
                user.setLname(rs.getString(3));
                user.setUser(rs.getString(4));
                user.setPwd(rs.getString(5));
                user.setEmail(rs.getString(6));
                user.setPermission(rs.getInt(7));
                user.setSend_email(rs.getInt(8));
            }
            rs.close();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        return user;
    }

    public static ArrayList findAll(){//List<User> findAll(){
        ArrayList list = new ArrayList();//List<User> list = new ArrayList<User>();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + USER + ", " + PWD + ", " + EMAIL
                    + ", "  + PERM + "," + Send_EMAIL +  " FROM login");
            while(rs.next()){
                User u = new User();
                list.add(u);
                u.setId(rs.getInt(1));
                u.setFname(rs.getString(2));
                u.setLname(rs.getString(3));
                u.setUser(rs.getString(4));
                u.setPwd(rs.getString(5));
                u.setEmail(rs.getString(6));
                u.setPermission(rs.getInt(7));
                u.setSend_email(rs.getInt(8));
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
            ResultSet rs = st.executeQuery("SELECT count(*) FROM login");
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

    public static ArrayList findByFilter(String filter){
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try{
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + USER + ", " + PWD + ", " + EMAIL
                    + ", "  + PERM + "," + Send_EMAIL +   " FROM login WHERE " + filter);
            while(rs.next()){
                User u = new User();
                list.add(u);
                u.setId(rs.getInt(1));
                u.setFname(rs.getString(2));
                u.setLname(rs.getString(3));
                u.setUser(rs.getString(4));
                u.setPwd(rs.getString(5));
                u.setEmail(rs.getString(6));
                u.setPermission(rs.getInt(7));
                u.setSend_email(rs.getInt(8));
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
            ResultSet rs = st.executeQuery("SELECT count(*) FROM login WHERE " + filter);
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
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + FNAME + ", " + LNAME + ", " + USER + ", " + PWD + ", " + EMAIL
                    + ", "  + PERM + "," + Send_EMAIL + " FROM login LIMIT " + offset + "," + size); //TODO FOUND_ROWS()
            while(rs.next()){
                User u = new User();
                list.add(u);
                u.setId(rs.getInt(1));
                u.setFname(rs.getString(2));
                u.setLname(rs.getString(3));
                u.setUser(rs.getString(4));
                u.setPwd(rs.getString(5));
                u.setEmail(rs.getString(6));
                u.setPermission(rs.getInt(7));
                u.setSend_email(rs.getInt(8));
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
            ResultSet rs = st.executeQuery("SELECT " + ID +", " + USER + " FROM login");
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

    public static String generate(int from, int to) {
        String pass  = "";
        Random r     = new Random();
        int cntchars = from + r.nextInt(to - from + 1);

        for (int i = 0; i < cntchars; ++i) {
            char next = 0;
            int range = 10;

            switch(r.nextInt(3)) {
                case 0: {next = '0'; range = 10;} break;
                case 1: {next = 'a'; range = 26;} break;
                case 2: {next = 'A'; range = 26;} break;
            }

            pass += (char)((r.nextInt(range)) + next);
        }

        return pass;
    }

    private static boolean sendEmail(String pwd, String email)
    {
        boolean rez = false;

            if (!email.equals("")){
                String userNames = "";
                List users = findByFilter(" email='"+email+"'");
                for (Object user1 : users) {
                    User u = (User) user1;
                    userNames = userNames + " User: "+u.getUser() + " new password: "+pwd;
                }
                String message = userNames;
                String to = email;
                String from = "noreply@isalon2you-soft.com";
                String subject = "Recovery Password";
                String host = "localhost";
                boolean debug = false;
                boolean returnValue = false;
                Properties props = new Properties();
                props.put("mail.smtp.host", host);


                javax.mail.Session session = javax.mail.Session.getDefaultInstance(props, null);
                session.setDebug(debug);

                props = null;
                MimeMessage msg = null;
                try {
                    msg = new MimeMessage(session);
                    msg.setFrom(new InternetAddress(from));
                    InternetAddress[] address = {new InternetAddress(to)};
                    msg.setRecipients(Message.RecipientType.TO, address);
                    msg.setSubject(subject);
                    msg.setSentDate(Calendar.getInstance().getTime());

                    MimeBodyPart mbp1 = new MimeBodyPart();
                    mbp1.setText(message);

                    Multipart mp = new MimeMultipart();
                    mp.addBodyPart(mbp1);

                    msg.setContent(mp);

                    Transport.send(msg);

                    rez = true;
                }
                catch (MessagingException mex)
                {
                    rez = false;
                    mex.printStackTrace();
                    Exception ex = null;
                    if ((ex = mex.getNextException()) != null) {
                        ex.printStackTrace();
                    }
                }
                catch(Exception ex)
                {
                    rez = false;
                    ex.printStackTrace();
                }
                msg = null;
            }
        return rez;
    }

    public static String changePwdByEmail(String email) {
        DBManager dbm = null;
        String pwd = generate(8, 12);
        try{
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE login SET " + PWD + "=? WHERE " + Send_EMAIL + "=?");
            pst.setString(1, pwd);
            pst.setString(2, email);
            int rows = pst.executeUpdate();
            pst.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            if(dbm!=null)
                dbm.close();
        }
        sendEmail(pwd, email);
        return pwd;
    }
}
