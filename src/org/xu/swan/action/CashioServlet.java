package org.xu.swan.action;

import org.xu.swan.bean.Cashio;
import org.xu.swan.bean.Reconciliation;
import org.xu.swan.bean.User;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;
import org.apache.poi.util.StringUtil;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.Timestamp;
import java.sql.Date;
import java.math.BigDecimal;

public class CashioServlet extends HttpServlet {
    protected Logger logger = LogManager.getLogger(getClass());
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("Action");
                HttpSession session = request.getSession(true);
        User user_ses = (User) session.getAttribute("user");
        if(action.equals("ADD")){
            String paymentMethod = StringUtils.defaultString(request.getParameter("payment_method"), "");
            String vendor = StringUtils.defaultString(request.getParameter("vendor"), "");
            String description = StringUtils.defaultString(request.getParameter("description"), "");
            String transNum = StringUtils.defaultString(request.getParameter("transactionNumber"), "");
            String giftcard_pay = StringUtils.defaultString(request.getParameter("giftcard_pay"), "");
            boolean isPayIn = StringUtils.defaultString(request.getParameter("pay_direction"), "").equals("in");
            BigDecimal totalIn = new BigDecimal("0");
            BigDecimal totalOut = new BigDecimal("0");
            if(isPayIn)
                totalIn = new BigDecimal(StringUtils.defaultString(request.getParameter("total"), "0"));
            else
                totalOut = new BigDecimal(StringUtils.defaultString(request.getParameter("total"), "0"));
            Date _date = new Date(Timestamp.valueOf(request.getParameter("date")).getTime());
//            logger.info("Start insertTransaction_ (CashIO) User="+user_ses.getFname() + " " + user_ses.getLname());
            Reconciliation r = Reconciliation.insertTransaction_(0, 1, transNum, 0,
                    isPayIn ? totalIn : totalOut, new BigDecimal(0), isPayIn ? totalIn : totalOut, paymentMethod,
                    isPayIn ? 5 : 3, _date,
                    paymentMethod.equals("amex") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                    paymentMethod.equals("visa") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                    paymentMethod.equals("mastercard") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                    paymentMethod.equals("check") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                    paymentMethod.equals("cash") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                    new BigDecimal(0),
                    new BigDecimal(0),giftcard_pay
                    );
//            logger.info("End insertTransaction_ (CashIO) User="+user_ses.getFname() + " " + user_ses.getLname());
            Cashio.insertCashio2(_date, totalIn, totalOut, r!=null?r.getId():0, vendor, description);
            totalIn = totalOut = null;
            _date = null;
        }
        else
            if(action.equals("EDIT"))
            {
                String paymentMethod = StringUtils.defaultString(request.getParameter("payment_method"), "");
                String vendor = StringUtils.defaultString(request.getParameter("vendor"), "");
                String description = StringUtils.defaultString(request.getParameter("description"), "");
                String transNum = StringUtils.defaultString(request.getParameter("transactionNumber"), "");
                String giftcard_pay = StringUtils.defaultString(request.getParameter("giftcard_pay"), "");
                int ID = Integer.parseInt(request.getParameter("id"));

                boolean isPayIn = request.getParameter("pay_direction").equals("in");
                BigDecimal totalIn = new BigDecimal("0");
                BigDecimal totalOut = new BigDecimal("0");
                if(isPayIn)
                    totalIn = new BigDecimal(request.getParameter("total"));
                else
                    totalOut = new BigDecimal(request.getParameter("total"));
                Date _date = new Date(Timestamp.valueOf(request.getParameter("date")).getTime());

                Reconciliation r = Reconciliation.updateTransaction( 0, ID, 1, transNum, 0,
                        isPayIn ? totalIn : totalOut, new BigDecimal(0), isPayIn ? totalIn : totalOut, paymentMethod,
                        isPayIn ? 5 : 3, _date,
                        paymentMethod.equals("amex") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                        paymentMethod.equals("visa") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                        paymentMethod.equals("mastercard") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                        paymentMethod.equals("check") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                        paymentMethod.equals("cash") ? (isPayIn ? totalIn : totalOut) : new BigDecimal(0),
                        new BigDecimal(0),
                        new BigDecimal(0),giftcard_pay
                        );

                Cashio.updateCashioByRecID(r!=null?r.getId():0, _date, totalIn, totalOut, vendor, description);
                totalIn = totalOut = null;
                _date = null;
            }            
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
