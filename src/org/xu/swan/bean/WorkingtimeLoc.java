package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;

public class WorkingtimeLoc {
    public static final String ID = "id";
    public static final String LOC = "location_id";
    public static final String FROM = "hfrom";
    public static final String TO = "hto";
    public static final String DAY = "daynumber";
    public static final String COMMENT = "comment";

    private int id;
    private int location_id;
    private Time hfrom;
    private Time hto;
    private int day;
    private String comment;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getLocation_id() {
        return location_id;
    }

    public void setLocation_id(int location_id) {
        this.location_id = location_id;
    }

    public Time getH_from() {
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
    }

    public int getDay() {
        return day;
    }

    public void setDay(int day) {
        this.day = day;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public static WorkingtimeLoc insertWTLoc(int loc, Time hf, Time ht, int day, String comment) {
        WorkingtimeLoc ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT workingtime_loc (" + LOC + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT + ") VALUES (?,?,?,?,?)");
            pst.setInt(1, loc);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setInt(4, day);
            pst.setString(5, comment);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeLoc();
                ew.setLocation_id(loc);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setDay(day);
                ew.setComment(comment);
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next())
                    ew.setId(rs.getInt(1));
                rs.close();
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return ew;
    }

    public static WorkingtimeLoc updateWTLoc(int id, int loc, Time hf, Time ht, int day, String comment) {
        WorkingtimeLoc ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE workingtime_loc SET " + LOC + "=?, " + FROM + "=?, " + TO + "=?, " + DAY + "=?, " + COMMENT + "=? WHERE " + ID + "=?");
            pst.setInt(1, loc);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setInt(4, day);
            pst.setString(5, comment);
            pst.setInt(6, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeLoc();
                ew.setId(id);
                ew.setLocation_id(loc);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setDay(day);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return ew;
    }

    public static WorkingtimeLoc updateByLoc_idAndDay(int loc, Time hf, Time ht, int day, String comment) {
        WorkingtimeLoc ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE workingtime_loc SET " + LOC + "=?, " + FROM + "=?, " + TO + "=?, " + DAY + "=?, " + COMMENT + "=? WHERE " + LOC + "=? and " + DAY + "=?");
            pst.setInt(1, loc);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setInt(4, day);
            pst.setString(5, comment);
            pst.setInt(6, loc);
            pst.setInt(7, day);

            int rows = pst.executeUpdate();
            if (rows > 0) {
                ew = new WorkingtimeLoc();
                ew.setLocation_id(loc);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setDay(day);
                ew.setComment(comment);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return ew;
    }

    public static WorkingtimeLoc deleteWTLoc(int id) {
        WorkingtimeLoc ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM workingtime_loc WHERE " + ID + "=?");
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeLoc();
                ew.setId(id);
            }
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return ew;
    }

    public static WorkingtimeLoc findById(int id) {
        WorkingtimeLoc ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT + " FROM workingtime_loc WHERE " + ID + "=?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                ew = new WorkingtimeLoc();
                ew.setId(rs.getInt(1));
                ew.setLocation_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
                ew.setComment(rs.getString(6));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return ew;
    }

    public static WorkingtimeLoc findByLocIdAndDay(int loc_id, int day) {
        WorkingtimeLoc ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT + " FROM workingtime_loc WHERE " + LOC + "=? AND " + DAY + "=?");
            pst.setInt(1, loc_id);
            pst.setInt(2, day);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                ew = new WorkingtimeLoc();
                ew.setId(rs.getInt(1));
                ew.setLocation_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
                ew.setComment(rs.getString(6));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return ew;
    }

    public static ArrayList findAllByLocationId(int locId) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + FROM + "," + TO + ", " + DAY + ", " + COMMENT + " FROM workingtime_loc WHERE " + LOC + "=? ORDER by workingtime_loc." + DAY + " ASC");
            pst.setInt(1, locId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                WorkingtimeLoc ew = new WorkingtimeLoc();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setLocation_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
                ew.setComment(rs.getString(6));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findAllByLocationIdAndDay(int locId, int day) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + LOC + "," + FROM + "," + TO + ", " + DAY + ", " + COMMENT +
                    " FROM workingtime_loc WHERE workingtime_loc." + LOC + "=?" + " and workingtime_loc." + DAY + "=? ORDER by workingtime_loc." + FROM + " ASC");
            pst.setInt(1, locId);
            pst.setInt(2, day);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                WorkingtimeLoc ew = new WorkingtimeLoc();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setLocation_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
                ew.setComment(rs.getString(6));
            }
            rs.close();
            pst.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (dbm != null)
                dbm.close();
        }
        return list;
    }

    public static ArrayList findAll() {//List<WorkingtimeLoc> findAll(){
        ArrayList list = new ArrayList();//List<WorkingtimeLoc> list = new ArrayList<WorkingtimeLoc>();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + LOC + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT +" FROM workingtime_loc");
            while (rs.next()) {
                WorkingtimeLoc ew = new WorkingtimeLoc();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setLocation_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
                ew.setComment(rs.getString(6));
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