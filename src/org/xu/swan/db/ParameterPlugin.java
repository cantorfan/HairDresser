package org.xu.swan.db;

import javax.servlet.ServletException;

import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;

public final class ParameterPlugin implements PlugIn {

    protected Logger logger = LogManager.getLogger(getClass());
    private String db_driver = "com.mysql.jdbc.Driver";
    private String db_url = "jdbc:mysql://localhost:3306/salon"; 
    private String db_user = "root";
    private String db_password  = "";

    public String getDb_driver() {
        return db_driver;
    }

    public void setDb_driver(String db_driver) {
        this.db_driver = db_driver;
    }

    public String getDb_url() {
        return db_url;
    }

    public void setDb_url(String db_url) {
        this.db_url = db_url;
    }

    public String getDb_user() {
        return db_user;
    }

    public void setDb_user(String db_user) {
        this.db_user = db_user;
    }

    public String getDb_password() {
        return db_password;
    }

    public void setDb_password(String db_password) {
        this.db_password = db_password;
    }

	public void destroy() {
    }

	public void init(ActionServlet arg0, ModuleConfig arg1)	throws ServletException {
		//ServletContext context = arg0.getServletContext();
		//String db_driver = context.getInitParameter("db_driver");
		//String db_url = context.getInitParameter("db_url");
		//String db_user = context.getInitParameter("db_user");
		//String db_password = context.getInitParameter("db_password");
		
		//setting the database parameters
		DBManager.setDB_DRIVER(db_driver);
		DBManager.setDB_URL(db_url);
		DBManager.setDB_USER(db_user);
		DBManager.setDB_PASSWORD(db_password);
        logger.info("db_url="+db_url);
	}
}
