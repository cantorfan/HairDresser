package org.xu.swan.db;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public final class DBManager {
    private static final Log Log = LogFactory.getLog(DBManager.class);

    private static String DB_DRIVER;
    private static String DB_URL;
    private static String DB_USER;
    private static String DB_PASSWORD;

    Connection con = null;
    Statement stmt = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    public DBManager() throws Exception {
        try {
            Class.forName(DB_DRIVER);
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (Exception ex) {
            Log.error("SQL ERROR: COULD NOT OPEN CONNECTION : " + ex.getMessage());
            //ex.printStackTrace();
            throw ex;
        }
    }

    public Connection getCon() {
        return con;
    }

    public Statement getStatement() throws Exception {
        stmt = con.createStatement();
        return stmt;
    }

    public PreparedStatement getPreparedStatement(String query) throws Exception {
        pstmt = con.prepareStatement(query);
        return pstmt;
    }

    public ResultSet executeQuery(String query) {
        try {
            stmt = getStatement();
            rs = stmt.executeQuery(query.trim());
        } catch (Exception ex) {
            Log.error("SQL ERROR: COULD NOT EXECUTE QUERY : " + ex.getMessage());
            Log.error(" Query : " + query);
            //ex.printStackTrace();
        }
        return rs;
    }

    public int executeUpdate(String query) {
        int numOfRecs = 0;
        try {
            stmt = getStatement();
            numOfRecs = stmt.executeUpdate(query.trim());
        } catch (Exception ex) {
            Log.error("SQL ERROR: COULD NOT EXECUTE UPDATE : " + ex.getMessage());
            Log.error(" Query : " + query);
            //ex.printStackTrace();
        }
        return numOfRecs;
    }

    public void close() {
        try {
            if (rs != null)
                rs.close();
        } catch (Exception ex) {
            Log.error("SQL ERROR: COULD NOT CLOSE JDBC ResultSet : " + ex.getMessage());
            //ex.printStackTrace();
        }
        try {
            if (stmt != null)
                stmt.close();
        } catch (Exception ex) {
            Log.error("SQL ERROR: COULD NOT CLOSE JDBC Statement : " + ex.getMessage());
            //ex.printStackTrace();
        }
        try {

            if (con != null)
                con.close();
        } catch (Exception ex) {
            Log.error("SQL ERROR: COULD NOT CLOSE JDBC CONNECTION : " + ex.getMessage());
            //ex.printStackTrace();
        }
    }

    public static String getDB_DRIVER() {
        return DB_DRIVER;
    }

    public static void setDB_DRIVER(String db_driver) {
        DB_DRIVER = db_driver;
    }

    public static String getDB_PASSWORD() {
        return DB_PASSWORD;
    }

    public static void setDB_PASSWORD(String db_password) {
        DB_PASSWORD = db_password;
    }

    public static String getDB_URL() {
        return DB_URL;
    }

    public static void setDB_URL(String db_url) {
        DB_URL = db_url;
    }

    public static String getDB_USER() {
        return DB_USER;
    }

    public static void setDB_USER(String db_user) {
        DB_USER = db_user;
    }
}
