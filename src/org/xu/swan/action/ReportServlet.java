package org.xu.swan.action;

import net.sf.jasperreports.engine.*;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.xu.swan.bean.*;
import org.xu.swan.bean.Service;
import org.xu.swan.db.DBManager;
import org.xu.swan.reports.*;
import org.xu.swan.reports.InvoiceReport;
import org.xu.swan.util.DateUtil;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: Paha
 * Date: 18.03.2009
 * Time: 18:46:19
 * To change this template use File | Settings | File Templates.
 */
public class ReportServlet extends HttpServlet {

    protected Logger logger = LogManager.getLogger(getClass());

    public void init() {
        System.out.println("ReportServlet initialized.");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doPost(request, response);
    }

    private String HOST = "localhost";// "inmarsoft.com";

//    private void SendReport(String to, String from, String subject, IReportGenerator generate)
//    {
//        return;
//    }
    private void SendReport(String to, String from, String subject, IReportGenerator generate)
    {
        String host = HOST;
        boolean debug = false;
        boolean returnValue = false;
        // Устанавливаем свойиства и получаем Сессию по умолчанию
        Properties props = new Properties();
        props.put("mail.smtp.host", host);


        Session session = Session.getDefaultInstance(props, null);
        session.setDebug(debug);

       props = null;
        MimeMessage msg = null;
        try {
            // Создаем сообщение
            msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            InternetAddress[] address = {new InternetAddress(to)};
            msg.setRecipients(Message.RecipientType.TO, address);
            msg.setSubject(subject);
            msg.setSentDate(Calendar.getInstance().getTime());

            // создаем и заполняем первую часть сообщения
            MimeBodyPart mbp1 = new MimeBodyPart();
            mbp1.setText("");

            MimeBodyPart mbp1File = new MimeBodyPart();

            mbp1File.setFileName(generate.getName());
            mbp1File.attachFile(generate.getName() + ".pdf");

            // Создаем Multipart и добавляем в него ранее созданные части
            Multipart mp = new MimeMultipart();
            mp.addBodyPart(mbp1);
            mp.addBodyPart(mbp1File);

            // Добавляем Multipart в сообщение
            msg.setContent(mp);

            Logs.log(0,"to:"+to+";from:"+from+";subject:"+subject+";SendEmail;");
            // Посылаем сообщение
            Transport.send(msg);


        }
        catch (MessagingException mex)
        {
            Logs.log(0,"to:"+to+";from:"+from+";subject:"+subject+";ex:"+mex.getMessage()+";stack:"+ Arrays.toString(mex.getStackTrace()));
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
//    public void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws IOException, ServletException {
//        return;
//    }
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(true);
        User user_ses = (User) session.getAttribute("user");
        String query = StringUtils.defaultString(request.getParameter("query"), "");
        DBManager dbManager = null;
        logger.info("ReportServlet" + query);
        try{
            dbManager = new DBManager();
            if(query.equalsIgnoreCase("employee")){
                ReportGenerator.Generate(new EmployeeReport(),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("customer")){
                ReportGenerator.Generate(new CustomerReport(),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("app")){
                String FROM_DATE = StringUtils.defaultString(request.getParameter("startdate"),"");
                String TO_DATE = StringUtils.defaultString(request.getParameter("enddate"),"");
                ReportGenerator.Generate(new AppointmentReport(FROM_DATE, TO_DATE),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("invoice"))
            {
                //if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    String NAME_TRAN = StringUtils.defaultString(request.getParameter("varNameTran"),"");
                    ReportGenerator.Generate(new InvoiceReport(NAME_TRAN),response,dbManager);
               // }
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("invoiceemail"))
            {
                if (user_ses.getPermission() != Role.R_SHD_CHK) {
                    String NAME_TRAN = StringUtils.defaultString(request.getParameter("varNameTran"),"");
                    String EMAIL_CLIENT_1 = StringUtils.defaultString(request.getParameter("email_1"),"");
                    String EMAIL_CLIENT_2 = StringUtils.defaultString(request.getParameter("email_2"),"");
                    if(!EMAIL_CLIENT_1.equals("") || !EMAIL_CLIENT_2.equals(""))
                    {
                        String from = "noreply@isalon2you-soft.com";//"Salon_manager";
                        String subject = "Invoice";
                        IReportGenerator generate = new InvoiceReport(NAME_TRAN);
                        JasperReport jasperReport = generate.getReport();
                        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, generate.getParameters(), dbManager.getCon());
                        JasperExportManager.exportReportToPdfFile(jasperPrint, generate.getName() + ".pdf");

                        String strMessage = "";
                        if(!EMAIL_CLIENT_1.equals(""))
                        {
                            SendReport(EMAIL_CLIENT_1,from,subject, generate);
                            strMessage = "Email has been sent for email 1.";
                        }
                        if(!EMAIL_CLIENT_2.equals(""))
                        {
                            SendReport(EMAIL_CLIENT_2,from,subject, generate);
                            strMessage = strMessage + "  Email has been sent for email 2.";
                        }
                        response.getOutputStream().print(strMessage);
                    }
                }
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("closingdetails"))
            {
                String CUR_DATE = StringUtils.defaultString(request.getParameter("varCurDate"),"");
                Date _d = DateUtil.parseSqlDate(CUR_DATE);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                String date = sdf.format(_d);

                ReportGenerator.Generate(new NewClosingDetailsReport(date),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("closingdetailsemail"))
            {
                String CUR_DATE = StringUtils.defaultString(request.getParameter("varCurDate"),"");
                String from = "noreply@isalon2you-soft.com";
                String subject = "Closing detail";
                IReportGenerator generate = new NewClosingDetailsReport(CUR_DATE);
                JasperReport jasperReport = generate.getReport();
                JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, generate.getParameters(), dbManager.getCon());
                JasperExportManager.exportReportToPdfFile(jasperPrint, generate.getName() + ".pdf");

                ArrayList arrlUser = User.findAll();
                if(arrlUser.size() > 0)
                {
                    for(int i = 0; i < arrlUser.size(); i++)
                    {
                        User user = (User)arrlUser.get(i);
                        if (user != null && user.getPermission() == Role.R_ADMIN && user.getSend_email() == 1 && !user.getEmail().equals(""))
                            SendReport(user.getEmail(),from,subject, generate);
                    }
                }
                else
                    Logs.log(0,"Send Closing detail; 0 activ user;");
                response.getOutputStream().print("Email has been sent.");
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("salaries_and_statistic"))
            {
                String EMPLOYEE_ID = StringUtils.defaultString(request.getParameter("varEmployee_id"),"0");
                String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
                String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");

                ReportGenerator.Generate(new SalariesAndStatisicReport(p_start_date, p_end_date, Integer.parseInt(EMPLOYEE_ID)),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("appointment_print"))
            {
                String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
                String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");
                String p_category = StringUtils.defaultString(request.getParameter("category"), "allcategories");
                String p_service = StringUtils.defaultString(request.getParameter("service"), "allservices");
                String p_employee = StringUtils.defaultString(request.getParameter("employee"), "allemployees");
                String p_count = StringUtils.defaultString(request.getParameter("report_count"), "0");

                ReportGenerator.Generate(new AppoinmentPrint(p_start_date,p_end_date,p_employee,p_service,p_category,p_count),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("transaction_print"))
            {
                String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
                String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");

                ReportGenerator.Generate(new TransactionPrint(p_start_date,p_end_date),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }
            else if(query.equalsIgnoreCase("dashboard_report"))
            {
                HashMap services = Service.findAllMap();
                HashMap products = Inventory.findAllMap();

                String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
                String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");
                String p_service_id = StringUtils.defaultString(request.getParameter("p_service_id"), "");
                String p_product_id = StringUtils.defaultString(request.getParameter("p_product_id"), "");
                String flag = StringUtils.defaultString(request.getParameter("flag"), "");
                String type = StringUtils.defaultString(request.getParameter("type"), "");
                String service_name = "";
                String product_name = "";
                if(services.get(String.valueOf(p_service_id))!=null)
                   service_name = (String) services.get(String.valueOf(p_service_id));
                if(products.get(String.valueOf(p_product_id))!=null)
                    product_name = (String) products.get(String.valueOf(p_product_id));
                ReportGenerator.Generate(new DashboardReport(p_start_date,p_end_date,p_service_id,p_product_id,service_name,product_name,flag,type),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }else if(query.equalsIgnoreCase("dashboard_report_all"))
            {
                String CUR_DATE = Calendar.getInstance().getTime().toString();
                String p_start_date = StringUtils.defaultString(request.getParameter("startdate"), "");
                String p_end_date = StringUtils.defaultString(request.getParameter("enddate"), "");
                String emp_id_list = StringUtils.defaultString(request.getParameter("emp_id_list"), "0");
                ReportGenerator.Generate(new DashboardReport_all(p_start_date,p_end_date,emp_id_list),response,dbManager);
                if (dbManager != null) dbManager.close();
                dbManager = null;
                return;
            }

        }catch(Exception ex){
            logger.error("ReportServletError " + query + ex.getMessage());
            response.getWriter().write("ReportServlet" + ex.getMessage());//ex.printStackTrace();
        }finally {
            if (dbManager != null)
                dbManager.close();
            dbManager = null;
        }

//        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
}
