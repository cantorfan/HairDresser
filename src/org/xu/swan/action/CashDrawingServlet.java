package org.xu.swan.action;

import org.xu.swan.bean.CashDrawing;
import org.xu.swan.bean.Theday;
import org.xu.swan.bean.User;
import org.xu.swan.bean.Role;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.DateUtil;
//import org.xu.swan.util.ResourcesManager;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.math.BigDecimal;

/**
 * Created by IntelliJ IDEA.
 * User: nep
 * Date: 13.05.2009
 * Time: 7:20:09
 * To change this template use File | Settings | File Templates.
 */
public class CashDrawingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            HttpSession session = request.getSession(true);
            User user_ses = (User) session.getAttribute("user");
            String user_ses_ip = (String)session.getAttribute("ipuser");

//            ResourcesManager resx = new ResourcesManager();
            if (user_ses != null){
                User u = ActionUtil.getUser(request);
                int id = Integer.parseInt(request.getParameter("id"));
                int loc = Integer.parseInt(request.getParameter("loc"));
                int employeeID = Integer.parseInt(request.getParameter("employeeID"));
                Timestamp date = Timestamp.valueOf(request.getParameter("date"));
                int pennies = Integer.parseInt(request.getParameter("pennies"));
                int nickels = Integer.parseInt(request.getParameter("nickels"));
                int dimes = Integer.parseInt(request.getParameter("dimes"));
                int quarters = Integer.parseInt(request.getParameter("quarters"));
                int half_dollars = Integer.parseInt(request.getParameter("half_dollars"));
                int dollars = Integer.parseInt(request.getParameter("dollars"));
                int singles = Integer.parseInt(request.getParameter("singles"));
                int fives = Integer.parseInt(request.getParameter("fives"));
                int tens = Integer.parseInt(request.getParameter("tens"));
                int twenties = Integer.parseInt(request.getParameter("twenties"));
                int fifties = Integer.parseInt(request.getParameter("fifties"));
                int hundreds = Integer.parseInt(request.getParameter("hundreds"));
                int openClose = Integer.parseInt(request.getParameter("openClose"));
                BigDecimal amex = new BigDecimal(0);
                BigDecimal visa = new BigDecimal(0);
                BigDecimal mastercard = new BigDecimal(0);
                BigDecimal cheque = new BigDecimal(request.getParameter("cheque"));
                BigDecimal cash = new BigDecimal(request.getParameter("cash"));
                BigDecimal gift = new BigDecimal(request.getParameter("gift"));
                BigDecimal card_over = new BigDecimal(request.getParameter("card_over"));
                BigDecimal cheque_over = new BigDecimal(request.getParameter("cheque_over"));
                BigDecimal cash_over = new BigDecimal(request.getParameter("cash_over"));
                BigDecimal gift_over = new BigDecimal(request.getParameter("gift_over"));
                BigDecimal card_short = new BigDecimal(request.getParameter("card_short"));
                BigDecimal cheque_short = new BigDecimal(request.getParameter("cheque_short"));
                BigDecimal cash_short = new BigDecimal(request.getParameter("cash_short"));
                BigDecimal gift_short = new BigDecimal(request.getParameter("gift_short"));
                BigDecimal creditcard = new BigDecimal(request.getParameter("creditcard"));

                String action = request.getParameter("Action");

                if(action.equals("ADD"))
                { //save day
                    if (user_ses.getPermission() != Role.R_SHD_CHK){
                        if (openClose == 0)
                        {
                            CashDrawing.insertCashDrawing(loc,employeeID,date,pennies,nickels,dimes,quarters,half_dollars,dollars,singles,fives,tens,twenties,fifties,hundreds,openClose,amex,visa,mastercard,cheque,cash,
                                    gift,
                                    card_over,
                                    cheque_over,
                                    cash_over,
                                    gift_over,
                                    card_short,
                                    cheque_short,
                                    cash_short,
                                    gift_short,
                                    creditcard,
                                    user_ses.getId(),
                                    user_ses_ip
                            );

                        }

                        if(openClose == 1)
                        {
                        //update day
                            CashDrawing cd = CashDrawing.findByDate(loc, new Date(date.getTime()));
                            if (cd != null && cd.getOpenClose() != 0)
                            {
                                CashDrawing.updateCashDrawing((u!=null?u.getId():0),id,loc,employeeID,date,pennies,nickels,dimes,quarters,half_dollars,dollars,singles,fives,tens,twenties,fifties,hundreds,openClose,amex,visa,mastercard,cheque,cash,
                                        gift,
                                        card_over,
                                        cheque_over,
                                        cash_over,
                                        gift_over,
                                        card_short,
                                        cheque_short,
                                        cash_short,
                                        gift_short,
                                        creditcard,
                                        user_ses.getId(),
                                        user_ses_ip
                                        );
                            }
                            else
                            {
                                CashDrawing.insertCashDrawing(
                                    loc,
                                    employeeID,
                                    date,
                                    pennies,
                                    nickels,
                                    dimes,
                                    quarters,
                                    half_dollars,
                                    dollars,
                                    singles,
                                    fives,
                                    tens,
                                    twenties,
                                    fifties,
                                    hundreds,
                                    openClose,
                                    amex,
                                    visa,
                                    mastercard,
                                    cheque,
                                    cash,
                                    gift,
                                    card_over,
                                    cheque_over,
                                    cash_over,
                                    gift_over,
                                    card_short,
                                    cheque_short,
                                    cash_short,
                                    gift_short,
                                    creditcard,
                                    user_ses.getId(),
                                    user_ses_ip
                                );
                            }
                        }

                        if(openClose == 2)
                        {
                            //close day
                            CashDrawing cd = CashDrawing.findByDate(loc, new Date(date.getTime()));
                            if (cd != null && cd.getOpenClose() != 0)
                            {
                                CashDrawing.updateCashDrawing(
                                    (u!=null?u.getId():0),
                                    id,
                                    loc,
                                    employeeID,
                                    date,
                                    pennies,
                                    nickels,
                                    dimes,
                                    quarters,
                                    half_dollars,
                                    dollars,
                                    singles,
                                    fives,
                                    tens,
                                    twenties,
                                    fifties,
                                    hundreds,
                                    openClose,
                                    amex,
                                    visa,
                                    mastercard,
                                    cheque,
                                    cash,
                                    gift,
                                    card_over,
                                    cheque_over,
                                    cash_over,
                                    gift_over,
                                    card_short,
                                    cheque_short,
                                    cash_short,
                                    gift_short,
                                    creditcard,
                                    user_ses.getId(),
                                    user_ses_ip
                                );
                            }
                            else
                            {
                                CashDrawing.insertCashDrawing(
                                    loc,
                                    employeeID,
                                    date,
                                    pennies,
                                    nickels,
                                    dimes,
                                    quarters,
                                    half_dollars,
                                    dollars,
                                    singles,
                                    fives,
                                    tens,
                                    twenties,
                                    fifties,
                                    hundreds,
                                    openClose,
                                    amex,
                                    visa,
                                    mastercard,
                                    cheque,
                                    cash,
                                    gift,
                                    card_over,
                                    cheque_over,
                                    cash_over,
                                    gift_over,
                                    card_short,
                                    cheque_short,
                                    cash_short,
                                    gift_short,
                                    creditcard,
                                    user_ses.getId(),
                                    user_ses_ip
                                );
                            }
                        }
                    }
                }
                amex = visa = mastercard = cheque = cash = gift = card_over = cheque_over = gift_over = card_short = cheque_short = cash_short = gift_short = creditcard = null;
                } else {
                    response.setContentType("text/html");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("REDIRECT:error.jsp?ec=1");
                }
        }catch(Exception e){
            response.getOutputStream().print(
                        e.toString() + "\n"
                    );
            e.printStackTrace();
        }


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
           doPost(request, response);
    }
}
