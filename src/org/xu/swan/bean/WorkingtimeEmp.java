package org.xu.swan.bean;

import org.xu.swan.db.DBManager;

import java.sql.*;
import java.util.ArrayList;

public class WorkingtimeEmp {
    public static final String ID = "id";
    public static final String EMP = "employee_id";
    public static final String FROM = "hfrom";
    public static final String TO = "hto";
    public static final String DAY = "daynumber";
    public static final String COMMENT = "comment";
    public static final String WORK_DATE = "work_date";
    public static final String TYPE = "type";

    private int id;
    private int employee_id;
    private Time hfrom;
    private Time hto;
    private int day;
    private String comment;
    private Date work_date;
    private int type_employee;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
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

    public Date getWork_date() {
        return work_date;
    }

    public int getType_employee() {
        return type_employee;
    }

    public void setWork_date(Date work_date) {
        this.work_date = work_date;
    }

    public void setType_employee(int type_employee) {
        this.type_employee = type_employee;
    }

    public static WorkingtimeEmp insertWTEmp(int emp, Time hf, Time ht, int day) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT workingtime_emp (" + EMP + ", " + FROM + ", " + TO + ", " + DAY + ") VALUES (?,?,?,?)");
            pst.setInt(1, emp);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setInt(4, day);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
                ew.setEmployee_id(emp);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setDay(day);
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

    public static WorkingtimeEmp updateWTEmp(int id, int emp, Time hf, Time ht, int day) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE workingtime_emp SET " + EMP + "=?, " + FROM + "=?, " + TO + "=?, " + DAY + "=? WHERE " + ID + "=?");
            pst.setInt(1, emp);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setInt(4, day);
            pst.setInt(5, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
                ew.setId(id);
                ew.setEmployee_id(emp);
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

    public static WorkingtimeEmp updateByEmp_idAndDay(int emp, Time hf, Time ht, int day, String comment) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE workingtime_emp SET " + EMP + "=?, " + FROM + "=?, " + TO + "=?, " + DAY + "=?, " + COMMENT + "=? WHERE " + EMP + "=? and " + DAY + "=?");
            pst.setInt(1, emp);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setInt(4, day);
            pst.setString(5, comment);
            pst.setInt(6, emp);
            pst.setInt(7, day);

            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
                ew.setEmployee_id(emp);
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

    public static WorkingtimeEmp deleteWTEmp(int id) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM workingtime_emp WHERE " + ID + "=?");
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
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

    public static WorkingtimeEmp findById(int id) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + EMP + ", " + FROM + ", " + TO + ", " + DAY + " FROM workingtime_emp WHERE " + ID + "=?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                ew = new WorkingtimeEmp();
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
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

    public static WorkingtimeEmp findByEmpIdAndDay(int emp_id, int day) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + EMP + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT + " FROM workingtime_emp WHERE " + EMP + "=? AND " + DAY + "=?");
            pst.setInt(1, emp_id);
            pst.setInt(2, day);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                ew = new WorkingtimeEmp();
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
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

       public static WorkingtimeEmp findByEmpIdAndDayOrDate(int emp_id, int day, Date date) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            /*String query = "SELECT " + ID + "," + EMP + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT + " FROM workingtime_emp WHERE type=1 and " + EMP + "=? AND " + WORK_DATE + "=? " +
                    "union \n" +*/
            String query ="SELECT " + ID + "," + EMP + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT + " FROM workingtime_emp WHERE " + EMP + "=? AND " + DAY + "=? ;";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setInt(1, emp_id);
            pst.setDate(2, date);
            pst.setInt(3, emp_id);
            pst.setInt(4, day);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                ew = new WorkingtimeEmp();
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
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
      public static ArrayList findByEmpIdAndDate(int emp_id, Date date) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + ", " + EMP + ", " + FROM + ", " + TO + ", " + DAY + ", " + COMMENT + ", " + WORK_DATE + ", " + TYPE + " FROM workingtime_emp WHERE type=1 AND " + EMP + "=? AND " + WORK_DATE + "=? ORDER BY " + FROM + " ASC");
            pst.setInt(1, emp_id);
            pst.setDate(2, date);
            ResultSet rs = pst.executeQuery();
            while(rs.next()){
                WorkingtimeEmp ew = new WorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
                ew.setComment(rs.getString(6));
                ew.setWork_date(rs.getDate(7));
                ew.setType_employee(rs.getInt(8));
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

    public static ArrayList findAllByEmployeeId(int empId) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + EMP + "," + FROM + "," + TO + ", " + DAY + ", " + COMMENT + " FROM workingtime_emp WHERE " + EMP + "=? and type=0 ORDER by workingtime_emp." + DAY + " ASC");
            pst.setInt(1, empId);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                WorkingtimeEmp ew = new WorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
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

    public static ArrayList findAllByEmployeeIdAndDay(int empId, int day) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("SELECT " + ID + "," + EMP + "," + FROM + "," + TO + ", " + DAY +
                    " FROM workingtime_emp WHERE workingtime_emp." + EMP + "=?" + " and workingtime_emp." + DAY + "=? ORDER by workingtime_emp." + FROM + " ASC");
            pst.setInt(1, empId);
            pst.setInt(2, day);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                WorkingtimeEmp ew = new WorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
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

    public static ArrayList findAll() {//List<WorkingtimeEmp> findAll(){
        ArrayList list = new ArrayList();//List<WorkingtimeEmp> list = new ArrayList<WorkingtimeEmp>();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            Statement st = dbm.getStatement();
            ResultSet rs = st.executeQuery("SELECT " + ID + "," + EMP + ", " + FROM + ", " + TO + ", " + DAY + " FROM workingtime_emp");
            while (rs.next()) {
                WorkingtimeEmp ew = new WorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setDay(rs.getInt(5));
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

        public static WorkingtimeEmp insertOneDay(int emp, Time hf, Time ht, Date day) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("INSERT workingtime_emp (" + EMP + ", " + FROM + ", " + TO + ", " + WORK_DATE + ", " + TYPE + ") VALUES (?,?,?,?,?)");
            pst.setInt(1, emp);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setDate(4, day);
            pst.setInt(5, 1);            
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
                ew.setEmployee_id(emp);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setWork_date(day);
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

    public static WorkingtimeEmp updateOneDay(int id, int emp, Time hf, Time ht, Date day) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("UPDATE workingtime_emp SET " + EMP + "=?, " + FROM + "=?, " + TO + "=?, " + WORK_DATE + "=? WHERE " + ID + "=?");
            pst.setInt(1, emp);
            pst.setTime(2, hf);
            pst.setTime(3, ht);
            pst.setDate(4, day);
            pst.setInt(5, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
                ew.setId(id);
                ew.setEmployee_id(emp);
                ew.setH_from(hf);
                ew.setH_to(ht);
                ew.setWork_date(day);
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

    public static WorkingtimeEmp deleteOneDay(int id) {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM workingtime_emp WHERE " + ID + "=?");
            pst.setInt(1, id);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
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

    public static WorkingtimeEmp deleteOneDayEmployee(int idEmp,int id)
    {
        WorkingtimeEmp ew = null;
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            PreparedStatement pst = dbm.getPreparedStatement("DELETE FROM workingtime_emp WHERE " + ID + "=? and " + EMP + "=?;");
            pst.setInt(1, id);
            pst.setInt(2, idEmp);
            int rows = pst.executeUpdate();
            if (rows >= 0) {
                ew = new WorkingtimeEmp();
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

    public static ArrayList findAllByEmployeeIdAndType(int empId, int type) {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            String query = "SELECT " + ID + "," + EMP + "," + FROM + "," + TO + ", " + WORK_DATE +  ", " + DAY +
                    " FROM workingtime_emp WHERE " + EMP + "=?" + " and " + TYPE + "=? ORDER by " + WORK_DATE + "," + FROM + " ASC";

            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setInt(1, empId);
            pst.setInt(2, type);
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                WorkingtimeEmp ew = new WorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setWork_date(rs.getDate(5));
                ew.setDay(rs.getInt(6));
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

    public static ArrayList findByEmployeeIdAndDateTime(int empId, Time hf, Time ht, Date day)
    {
        ArrayList list = new ArrayList();
        DBManager dbm = null;
        try {
            dbm = new DBManager();
            String query = "select " + ID + "," + EMP + "," + FROM + "," + TO + ", " + WORK_DATE +" \n" +
                    "from `workingtime_emp`\n" +
                    "where type = 1 and employee_id = "+ empId +" and \n" +
                     WORK_DATE + " = DATE(?) and \n" +
                    "(((TIME(?)>hfrom and TIME(?)<hto) or (TIME(?)>hfrom and TIME(?)<hto)) or\n" +
                    "(TIME(?) <= hfrom and TIME(?) >= hto))";
            PreparedStatement pst = dbm.getPreparedStatement(query);
            pst.setDate(1, day);
            pst.setTime(2, hf);
            pst.setTime(3, hf);
            pst.setTime(4, ht);
            pst.setTime(5, ht);
            pst.setTime(6, hf);
            pst.setTime(7, ht);

            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                WorkingtimeEmp ew = new WorkingtimeEmp();
                list.add(ew);
                ew.setId(rs.getInt(1));
                ew.setEmployee_id(rs.getInt(2));
                ew.setH_from(rs.getTime(3));
                ew.setH_to(rs.getTime(4));
                ew.setWork_date(rs.getDate(5));
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
}
