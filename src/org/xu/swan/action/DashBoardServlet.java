package org.xu.swan.action;

import org.apache.commons.lang.StringUtils;
import org.xu.swan.bean.*;

//import org.xu.swan.util.ResourcesManager;
import org.xu.swan.util.ActionUtil;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.print.Doc;
import java.io.IOException;
import java.sql.Timestamp;
import java.sql.Date;
import java.math.BigDecimal;
import java.util.*;

public class DashBoardServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try{
            HttpSession session = request.getSession(true);
            User user_ses = (User) session.getAttribute("user");

//            ResourcesManager resx = new ResourcesManager();
            if (user_ses != null){

                String type = request.getParameter("type");
                if(type.equals("EMPREPORT")){
                    String action = StringUtils.defaultString(request.getParameter("action"),"");
                    String p_start_date =  StringUtils.defaultString(request.getParameter("fromdt"),"");
                    String p_end_date =  StringUtils.defaultString(request.getParameter("todt"),"");
                    String listidemp = StringUtils.defaultString(request.getParameter("listidemp"),"");
                    String listidserv = StringUtils.defaultString(request.getParameter("listidserv"),"");
                    String listidprod = StringUtils.defaultString(request.getParameter("listidprod"),"");
                    String idprod = StringUtils.defaultString(request.getParameter("idprod"),"0");
                    String idserv = StringUtils.defaultString(request.getParameter("idserv"),"0");
                    String taxe = StringUtils.defaultString(request.getParameter("taxe"),"");
                    String[] idservArr = listidserv.split(",");
                    String[] idprodArr = listidprod.split(",");

                    String next_id_serv = "0";
                    String prev_id_serv = "0";
                    String next_id_prod = "0";
                    String prev_id_prod = "0";

                    if (action.equals("getData")){
                        if (idservArr.length>0){
                            idserv = idservArr[0];
                        } else {
                            idserv = "0";
                        }
                        if (idprodArr.length>0){
                            idprod = idprodArr[0];
                        } else {
                            idprod = "0";
                        }
                    } else {

                    }
                    
                    for (int i =0;i<idservArr.length;i++){
                        if (idserv.equals(idservArr[i])){
                            if(i + 1 < idservArr.length)
                                next_id_serv = idservArr[i+1];
                            if (i - 1 >= 0)
                                prev_id_serv = idservArr[i-1];
                        }
                    }
                    for (int i =0;i<idprodArr.length;i++){
                        if (idprod.equals(idprodArr[i])){
                            if(i + 1 < idprodArr.length)
                                next_id_prod = idprodArr[i+1];
                            if (i - 1 >= 0)
                                prev_id_prod = idprodArr[i-1];
                        }
                    }


                    String responcedata = "";
                    responcedata = "<table id=\"emp_report_table\" width=\"957\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"emp_report_table\">" +
                            "<tr>" +
                            "<td colspan=\"45\">" +
                            "<img src=\"../img/emp_report_01.png\" width=\"957\" height=\"16\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"45\">" +
                            "<img src=\"../img/emp_report_02.png\" width=\"957\" height=\"4\" alt=\"\"></td>" +
                            "</tr>";
                    HashMap hmapService = Service.findAllMap();
                    HashMap hmapProduct = Inventory.findAllMap();
//                    HashMap hmapEmployee = new HashMap();
                    if (!listidemp.equals("") && (!idserv.equals("") || (!idprod.equals("")))) {
                    ArrayList erb = EmployeeReportBean.getEmpReport(p_start_date, p_end_date, listidemp, idserv,  idprod, listidserv,  listidprod,  taxe);

                    String fakeSvc = ((hmapService.get(idserv)!=null&&erb.size()>0)?(hmapService.get(idserv)).toString().length()<11?(hmapService.get(idserv)).toString():(hmapService.get(idserv)).toString().substring(0,10):"");
                    String fakeProd = ((hmapProduct.get(idprod)!=null&&erb.size()>0) ? (hmapProduct.get(idprod)).toString().length()<11?(hmapProduct.get(idprod)).toString():(hmapProduct.get(idprod)).toString().substring(0,10):"");
                    String fake_prev_id_serv=(!prev_id_serv.equals("0")&&erb.size()>0)?"<img onclick=\"dataload('2','"+prev_id_serv+"');\" src=\"../img/emp_report_04.png\" width=\"17\" height=\"32\" alt=\"\">":"";
                    String fake_next_id_serv=(!next_id_serv.equals("0")&&erb.size()>0)?"<img onclick=\"dataload('1','"+next_id_serv+"');\" src=\"../img/emp_report_06.png\" width=\"17\" height=\"32\" alt=\"\">":"";
                    String fake_prev_id_prod=(!prev_id_prod.equals("0")&&erb.size()>0)?"<img onclick=\"dataload('4','"+prev_id_prod+"');\" src=\"../img/emp_report_09.png\" width=\"18\" height=\"32\" alt=\"\">":"";
                    String fake_next_id_prod=(!next_id_prod.equals("0")&&erb.size()>0)?"<img onclick=\"dataload('3','"+next_id_prod+"');\" src=\"../img/emp_report_11.png\" width=\"17\" height=\"32\" alt=\"\">":"";
                    responcedata +="<tr>" +
                            "<td colspan=\"2\">" +
                            "<img src=\"../img/emp_report_03.png\" width=\"58\" height=\"32\" alt=\"\"></td>" +
                            "<td colspan=\"2\">" +
                            fake_prev_id_serv +
                            "</td>" +
                            "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                            "<input type='hidden' id='serv_id' name='serv_id' value='"+idserv+"'/>"+
                            fakeSvc+"</td>" +
                            "<td>" +
                            fake_next_id_serv +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_07.png\" width=\"3\" height=\"32\" alt=\"\"></td>" +
                            "<td colspan=\"5\">" +
                            "<img src=\"../img/emp_report_08.png\" width=\"146\" height=\"32\" alt=\"\"></td>" +
                            "<td>" +
                            fake_prev_id_prod +
                            "</td>" +
                            "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                            "<input type='hidden' id='prod_id' name='prod_id' value='"+idprod+"'/>"+
                            fakeProd+"</td>" +
                            "<td>" +
                            fake_next_id_prod +
                            "</td>" +
                            "<td colspan=\"5\">" +
                            "<img src=\"../img/emp_report_12.png\" width=\"137\" height=\"32\" alt=\"\"></td>" +
                            "<td colspan=\"17\" rowspan=\"3\">" +
                            "<img src=\"../img/emp_report_13.png\" width=\"344\" height=\"47\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"28\">" +
                            "<img src=\"../img/emp_report_14.png\" width=\"613\" height=\"3\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"28\">" +
                            "<img src=\"../img/emp_report_15.png\" width=\"613\" height=\"12\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"45\">" +
                            "<img src=\"../img/emp_report_16.png\" width=\"957\" height=\"3\" alt=\"\"></td>" +
                            "</tr>";
                    BigDecimal totalsTaxeSelSvc = new BigDecimal(0);
                    BigDecimal totalsTotalSelSvc = new BigDecimal(0);
                    BigDecimal totalsTaxeAllEmpSvc = new BigDecimal(0);
                    BigDecimal totalsTotalAllEmpSvc = new BigDecimal(0);

                    BigDecimal totalsTaxeSelProd = new BigDecimal(0);
                    BigDecimal totalsTotalSelProd = new BigDecimal(0);
                    BigDecimal totalsTaxeAllEmpProd = new BigDecimal(0);
                    BigDecimal totalsTotalAllEmpProd = new BigDecimal(0);

                    BigDecimal totalsSubTotalSvcProd = new BigDecimal(0);
                    BigDecimal totalsTaxeSvcProd = new BigDecimal(0);
                    BigDecimal totalsTotalSvcProd = new BigDecimal(0);

                    BigDecimal totalsPercentAllSvc = new BigDecimal(0);
                    BigDecimal totalsPercentAllProd = new BigDecimal(0);
                    BigDecimal totalsSalary = new BigDecimal(0);

                    BigDecimal totalsPercentAllEmpSvc = new BigDecimal(0);
                    BigDecimal totalsPercentAllEmpProd = new BigDecimal(0);

                    for (int i=0; i<erb.size(); i++){
                        EmployeeReportBean empRep = (EmployeeReportBean) erb.get(i);
                        String emplName = "";
                        if ((empRep!=null)&&(empRep.getEmpname()!=null))
                            emplName = empRep.getEmpname().toString().length()<7?empRep.getEmpname().toString():empRep.getEmpname().toString().substring(0,7);
                    responcedata += "<tr>" +
                            "<th>" +
                            emplName +
                            "</th>" +
                            "<td colspan=\"2\">" +
                            "<img src=\"../img/emp_report_18.png\" width=\"5\" height=\"21\" alt=\"\"></td>" +
                            "<td class=\"small\" colspan=\"2\">" +
                            empRep.getSvc_percent().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_20.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td>" +
                            empRep.getSvcsvc_tax().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_22.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td colspan=\"2\">" +
                            empRep.getSvc_total().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_24.png\" width=\"3\" height=\"21\" alt=\"\"></td>" +
                            "<td>" +
                            empRep.getSvc_totaltax().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_26.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td style=\"padding-right:10px\" colspan=\"2\">" +
                            empRep.getSvc_totaltotal().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_28.png\" width=\"12\" height=\"21\" alt=\"\"></td>" +
                            "<td class=\"small\" colspan=\"2\">" +
                            empRep.getProd_percent().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_30.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td>" +
                            empRep.getProdprod_tax().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_32.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td colspan=\"2\">" +
                            empRep.getProd_total().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_34.png\" width=\"4\" height=\"21\" alt=\"\"></td>" +
                            "<td>" +
                            empRep.getProd_totaltax().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_36.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td style=\"padding-right:10px\" colspan=\"2\">" +
                            empRep.getProd_totaltotal().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_38.png\" width=\"10\" height=\"21\" alt=\"\"></td>" +
                            "<td  class=\"small\" colspan=\"2\">" +
                            empRep.getSvc_prod_subtotal().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_40.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td  class=\"small\">" +
                                    empRep.getSvc_prod_taxe().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_42.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td style=\"padding-right:10px\" class=\"small\" colspan=\"2\">" +
                            empRep.getSvc_prod_total().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_44.png\" width=\"10\" height=\"21\" alt=\"\"></td>" +
                            "<td colspan=\"2\">" +
                            empRep.getCommission_svc().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_46.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td>" +
                            empRep.getCommission_prod().setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_48.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                            "<td style=\"padding-right:10px\" colspan=\"2\">" +
                             (empRep.getCommission_svc().add( empRep.getCommission_prod())).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_50.png\" width=\"5\" height=\"21\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"45\">" +
                            "<img src=\"../img/emp_report_51.png\" width=\"957\" height=\"2\" alt=\"\"></td>" +
                            "</tr>";

                            totalsTaxeSelSvc = totalsTaxeSelSvc.add(empRep.getSvcsvc_tax());
                            totalsTotalSelSvc = totalsTotalSelSvc.add(empRep.getSvc_total());
                            totalsTaxeAllEmpSvc = totalsTaxeAllEmpSvc.add(empRep.getSvc_totaltax());
                            totalsTotalAllEmpSvc = totalsTotalAllEmpSvc.add(empRep.getSvc_totaltotal());

                            totalsTaxeSelProd = totalsTaxeSelProd.add(empRep.getProdprod_tax());
                            totalsTotalSelProd = totalsTotalSelProd.add(empRep.getProd_total());
                            totalsTaxeAllEmpProd = totalsTaxeAllEmpProd.add(empRep.getProd_totaltax());
                            totalsTotalAllEmpProd = totalsTotalAllEmpProd.add(empRep.getProd_totaltotal());

                            totalsSubTotalSvcProd = totalsSubTotalSvcProd.add(empRep.getSvc_prod_subtotal());
                            totalsTaxeSvcProd = totalsTaxeSvcProd.add(empRep.getSvc_prod_taxe());
                            totalsTotalSvcProd = totalsTotalSvcProd.add(empRep.getSvc_prod_total());

                            totalsPercentAllSvc = totalsPercentAllSvc.add(empRep.getCommission_svc());
                            totalsPercentAllProd = totalsPercentAllProd.add(empRep.getCommission_prod());

                            totalsSalary = totalsSalary.add(empRep.getCommission_svc().add(empRep.getCommission_prod()));
                    }
                        if (totalsTotalAllEmpSvc.doubleValue()!= 0){
                            totalsPercentAllEmpSvc = new BigDecimal((totalsTotalSelSvc.multiply(new BigDecimal(100))).doubleValue() / totalsTotalAllEmpSvc.doubleValue());
                        }
                        if (totalsTotalAllEmpProd.doubleValue()!= 0){
                            totalsPercentAllEmpProd = new BigDecimal((totalsTotalSelProd.multiply(new BigDecimal(100))).doubleValue() / totalsTotalAllEmpProd.doubleValue());    
                        }

                    responcedata +="<tr>" +
                            "<td colspan=\"3\">" +
                            "<img src=\"../img/emp_report_54.png\" width=\"59\" height=\"22\" alt=\"\"></td>" +
                            "<td class=\"small\" colspan=\"2\">" +
                            totalsPercentAllEmpSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_56.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsTaxeSelSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_58.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td colspan=\"2\">" +
                            totalsTotalSelSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_60.png\" width=\"3\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsTaxeAllEmpSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_62.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsTotalAllEmpSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td colspan=\"2\">" +
                            "<img src=\"../img/emp_report_64.png\" width=\"23\" height=\"22\" alt=\"\"></td>" +
                            "<td class=\"small\" colspan=\"2\">" +
                            totalsPercentAllEmpProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_66.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsTaxeSelProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_68.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td colspan=\"2\">" +
                            totalsTotalSelProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_70.png\" width=\"4\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsTaxeAllEmpProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_72.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsTotalAllEmpProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td colspan=\"3\">" +
                            "<img src=\"../img/emp_report_74.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                            "<td class=\"small\">" +
                            totalsSubTotalSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_76.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td class=\"small\">" +
                            totalsTaxeSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_78.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td class=\"small\">" +
                            totalsTotalSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td colspan=\"3\">" +
                            "<img src=\"../img/emp_report_80.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsPercentAllSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_82.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsPercentAllProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/emp_report_84.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                            "<td>" +
                            totalsSalary.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td colspan=\"2\">" +
                            "<img src=\"../img/emp_report_86.png\" width=\"16\" height=\"22\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"45\">" +
                            "<img src=\"../img/emp_report_87.png\" width=\"957\" height=\"5\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"54\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"16\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"66\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"12\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"18\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"15\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"65\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"38\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"36\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"34\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"44\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"51\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"68\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"5\" height=\"1\" alt=\"\"></td>" +
                            "</tr>" +
                            "</table>";
                    }else {
                        responcedata ="<table id=\"emp_report_table\" width=\"957\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">" +
                                "                    <input type=\"hidden\" value=\"0\" id=\"prod_id\" name=\"prod_id\"/>" +
                                "                <input type=\"hidden\" value=\"0\" id=\"serv_id\" name=\"serv_id\"/>" +
                                "<tr>" +
                                "<td colspan=\"45\">" +
                                "<img src=\"../img/emp_report_01.png\" width=\"957\" height=\"16\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"45\">" +
                                "<img src=\"../img/emp_report_02.png\" width=\"957\" height=\"4\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_03.png\" width=\"58\" height=\"32\" alt=\"\"></td>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_04.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                                "        </td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_06.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_07.png\" width=\"3\" height=\"32\" alt=\"\"></td>" +
                                "<td colspan=\"5\">" +
                                "<img src=\"../img/emp_report_08.png\" width=\"146\" height=\"32\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_09.png\" width=\"18\" height=\"32\" alt=\"\"></td>" +
                                "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                                "        </td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_11.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                "<td colspan=\"5\">" +
                                "<img src=\"../img/emp_report_12.png\" width=\"137\" height=\"32\" alt=\"\"></td>" +
                                "<td colspan=\"17\" rowspan=\"3\">" +
                                "<img src=\"../img/emp_report_13.png\" width=\"344\" height=\"47\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"28\">" +
                                "<img src=\"../img/emp_report_14.png\" width=\"613\" height=\"3\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"28\">" +
                                "<img src=\"../img/emp_report_15.png\" width=\"613\" height=\"12\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"45\">" +
                                "<img src=\"../img/emp_report_16.png\" width=\"957\" height=\"3\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"3\">" +
                                "<img src=\"../img/emp_report_54.png\" width=\"59\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_55.png\" width=\"33\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_56.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_57.png\" width=\"39\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_58.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_59.png\" width=\"58\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_60.png\" width=\"3\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_61.png\" width=\"66\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_62.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_63.png\" width=\"55\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_64.png\" width=\"23\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_65.png\" width=\"33\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_66.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_67.png\" width=\"39\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_68.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_69.png\" width=\"58\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_70.png\" width=\"4\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_71.png\" width=\"65\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_72.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_73.png\" width=\"55\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"3\">" +
                                "<img src=\"../img/emp_report_74.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_75.png\" width=\"38\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_76.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_77.png\" width=\"36\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_78.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_79.png\" width=\"34\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"3\">" +
                                "<img src=\"../img/emp_report_80.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_81.png\" width=\"44\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_82.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_83.png\" width=\"51\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_84.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/emp_report_85.png\" width=\"68\" height=\"22\" alt=\"\"></td>" +
                                "<td colspan=\"2\">" +
                                "<img src=\"../img/emp_report_86.png\" width=\"16\" height=\"22\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"45\">" +
                                "<img src=\"../img/emp_report_87.png\" width=\"957\" height=\"5\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"54\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"1\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"16\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"3\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"66\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"12\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"18\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"15\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"65\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"38\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"36\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"34\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"44\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"51\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"68\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                "<td>" +
                                "<img src=\"../img/spacer.gif\" width=\"5\" height=\"1\" alt=\"\"></td>" +
                                "</tr>" +
                                "</table>";
                    }
                           response.getOutputStream().print(responcedata);

                } else if(type.equals("EMPREPORT2"))
                {
                   
                    String action = StringUtils.defaultString(request.getParameter("action"),"");
                    String p_start_date =  StringUtils.defaultString(request.getParameter("fromdt"),"");
                    String p_end_date =  StringUtils.defaultString(request.getParameter("todt"),"");
                    String listidemp = StringUtils.defaultString(request.getParameter("listidemp"),"");
                    String listidserv = StringUtils.defaultString(request.getParameter("listidserv"),"");
                    String listidprod = StringUtils.defaultString(request.getParameter("listidprod"),"");
                    String idprod = StringUtils.defaultString(request.getParameter("idprod"),"0");
                    String idserv = StringUtils.defaultString(request.getParameter("idserv"),"0");
                    String taxe = StringUtils.defaultString(request.getParameter("taxe"),"");
                        String responcedata = "";
                        responcedata = "<table id=\"emp_report_table\" width=\"957\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"emp_report_table\">" +
                                "<tr>" +
                                "<td colspan=\"45\">" +
                                "<img src=\"../img/emp_report_01.png\" width=\"957\" height=\"16\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td colspan=\"45\">" +
                                "<img src=\"../img/emp_report_02.png\" width=\"957\" height=\"4\" alt=\"\"></td>" +
                                "</tr>";
                        HashMap mapService = Service.findAllMapByCode();
                        HashMap mapProduct = Inventory.findAllMap();
                        HashMap mapEmployee = Employee.findAllMapWithDeleted();
                        String filter = " where ";
                        String date_stmt = "";
                        boolean bFlag = false;
                        if(!p_start_date.equals("") && !p_end_date.equals(""))
                        {
                            date_stmt = "(DATE(created_dt) BETWEEN DATE('" + p_start_date + "') AND DATE('" + p_end_date + "')) ";
                            bFlag = true;
                        }
                        else
                        {
                            if(!p_start_date.equals("") && p_end_date.equals(""))
                            {
                                date_stmt = "(DATE(created_dt) >= DATE('" + p_start_date + "')) ";
                                bFlag = true;
                            }
                            else
                            {
                                if(p_start_date.equals("") && !p_end_date.equals(""))
                                {
                                    date_stmt = "(DATE(created_dt) <= DATE('" + p_end_date + "')) ";
                                    bFlag = true;
                                }
                            }
                        }
                        filter += date_stmt;
                        if(bFlag)
                                filter += " AND ";
                        filter += "status=0";
                        ArrayList listTrans = Reconciliation.findByFilter(filter);

                        String filter2 = " where ";
                        boolean bFlag2 = false;
                        if(!listidemp.equals("")&&!listidemp.equals("all"))
                        {
                            if(bFlag2)
                            filter2 += " AND ";
                            filter2 += "employee_id in ("+listidemp+")";
                            bFlag2 = true;
                        }
                        if(!listidserv.equals("")&&!listidserv.equals("all"))
                        {
                            if(bFlag2)
                            filter2 += " AND ";
                            filter2 += "service_id in ("+listidserv+")";
                            bFlag2 = true;
                        }
                        if(!listidprod.equals("")&&!listidprod.equals("all"))
                        {
                            if(bFlag2)
                                filter2 += " AND ";
                                filter2 += "product_id in ("+listidprod+")";
                                bFlag2 = true;
                        }
                        HashMap hmapService = new HashMap();
                        HashMap hmapProduct = new HashMap();
                        HashMap hmapEmployee = new HashMap();
                        int countServices = 0;
                        int countProducts = 0;
                        int idFirstService = 0;
                        int idFirstProduct = 0;
                        if (listTrans.size()>0){
                            for (int i=0; i<listTrans.size();i++){
                                Reconciliation r = (Reconciliation)listTrans.get(i);
                                String filter3="";
                                if (bFlag2)
                                    filter3 += " AND ";
                                filter3 = filter2 + filter3 + "code_transaction ='"+r.getCode_transaction()+"' AND location_id='"+r.getId_location()+"'";
                                ArrayList listTickets = Ticket.findTicketByFilter(filter3);
                                for (int j=0;j<listTickets.size();j++){
                                    Ticket t = (Ticket)listTickets.get(j);
                                    if (!listidemp.equals(""))
                                        hmapEmployee.put(t.getEmployee_id(),mapEmployee.get(String.valueOf(t.getEmployee_id())));
                                    if (t.getService_id()!=0 && !listidserv.equals("")){
                                        hmapService.put(t.getService_id(),mapService.get(String.valueOf(t.getService_id())));
//                                        if (hmapService.size()==1){
                                            idFirstService = t.getService_id();
//                                        }
                                    } else if (t.getProduct_id()!=0 && !listidprod.equals("")){
                                        hmapProduct.put(t.getProduct_id(),mapProduct.get(String.valueOf(t.getProduct_id())));
//                                        if (hmapProduct.size()==1){
                                            idFirstProduct=t.getProduct_id();
//                                        }
                                    }
                                }
                            }
                            if (action.equals("getData")){
                                idserv= String.valueOf(idFirstService);
                                idprod = String.valueOf(idFirstProduct);
                            } else if (action.equals("getNextSvc")){
                                Set entries_svc = hmapService.entrySet();
                                Iterator it_svc = entries_svc.iterator();
                                while (it_svc.hasNext()) {
                                  Map.Entry entry_svc = (Map.Entry) it_svc.next();
//                                      System.out.println(entry.getKey() + "-->" + entry.getValue());
                                    if (idserv.equals(String.valueOf(entry_svc.getKey()))){
                                        if (it_svc.hasNext()){
                                            entry_svc = (Map.Entry) it_svc.next();
                                            idserv = String.valueOf(entry_svc.getKey());
                                        } else {
//                                            Set entries_svc2 = hmapService.entrySet();
//                                            Iterator it_svc2 = entries_svc2.iterator();
//                                            if (it_svc2.hasNext()) {
//                                                Map.Entry entry_svc2 = (Map.Entry) it_svc2.next();
//                                                idserv = String.valueOf(entry_svc2.getKey());
//                                            }
                                        }
                                    }
                                }
                            } else if (action.equals("getPrevSvc")){
                                Set entries_svc = hmapService.entrySet();
                                Iterator it_svc = entries_svc.iterator();
                                String tmp = idserv;
                                while (it_svc.hasNext()) {
                                  Map.Entry entry_svc = (Map.Entry) it_svc.next();
//                                      System.out.println(entry.getKey() + "-->" + entry.getValue());
                                    if (idserv.equals(String.valueOf(entry_svc.getKey()))){
                                        idserv = tmp;
                                        break;
                                    } else
                                        tmp = String.valueOf(entry_svc.getKey());
                                }
                            }else if (action.equals("getNextProd")){
                                Set entries_prod = hmapProduct.entrySet();
                                Iterator it_prod = entries_prod.iterator();
                                while (it_prod.hasNext()) {
                                  Map.Entry entry_prod = (Map.Entry) it_prod.next();
//                                      System.out.println(entry.getKey() + "-->" + entry.getValue());
                                    if (idprod.equals(String.valueOf(entry_prod.getKey()))){
                                        if (it_prod.hasNext()){
                                            entry_prod = (Map.Entry) it_prod.next();
                                            idprod = String.valueOf(entry_prod.getKey());
                                        } else {
//                                            Set entries_prod2 = hmapProduct.entrySet();
//                                            Iterator it_prod2 = entries_prod2.iterator();
//                                            if (it_prod2.hasNext()) {
//                                                Map.Entry entry_prod2 = (Map.Entry) it_prod2.next();
//                                                idprod = String.valueOf(entry_prod2.getKey());
//                                            }
                                        }
                                    }
                                }
                            } else if (action.equals("getPrevProd")){
                                Set entries_prod = hmapProduct.entrySet();
                                Iterator it_prod = entries_prod.iterator();
                                String tmp = idprod;
                                while (it_prod.hasNext()) {
                                  Map.Entry entry_prod = (Map.Entry) it_prod.next();
//                                      System.out.println(entry.getKey() + "-->" + entry.getValue());
                                    if (idprod.equals(String.valueOf(entry_prod.getKey()))){
                                        idprod = tmp;
                                        break;
                                    } else
                                    tmp = String.valueOf(entry_prod.getKey());
                                }
                            }
                            String fakeSvc = (hmapService.get(Integer.parseInt(idserv))!=null?(hmapService.get(Integer.parseInt(idserv))).toString().length()<11?(hmapService.get(Integer.parseInt(idserv))).toString():(hmapService.get(Integer.parseInt(idserv))).toString().substring(0,10):"");
                            String fakeProd = (hmapProduct.get(Integer.parseInt(idprod))!=null ? (hmapProduct.get(Integer.parseInt(idprod))).toString().length()<11?(hmapProduct.get(Integer.parseInt(idprod))).toString():(hmapProduct.get(Integer.parseInt(idprod))).toString().substring(0,10):"");
                            responcedata +="<tr>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_03.png\" width=\"58\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img onclick=\"dataload('2');\" src=\"../img/emp_report_04.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                                    "<input type='hidden' id='serv_id' name='serv_id' value='"+idserv+"'/>"+
                                    fakeSvc+"</td>" +
                                    "<td>" +
                                    "<img onclick=\"dataload('1');\" src=\"../img/emp_report_06.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_07.png\" width=\"3\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\">" +
                                    "<img src=\"../img/emp_report_08.png\" width=\"146\" height=\"32\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img onclick=\"dataload('4');\" src=\"../img/emp_report_09.png\" width=\"18\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                                    "<input type='hidden' id='prod_id' name='prod_id' value='"+idprod+"'/>"+
                                    fakeProd+"</td>" + 
                                    "<td>" +
                                    "<img onclick=\"dataload('3');\" src=\"../img/emp_report_11.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\">" +
                                    "<img src=\"../img/emp_report_12.png\" width=\"137\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"17\" rowspan=\"3\">" +
                                    "<img src=\"../img/emp_report_13.png\" width=\"344\" height=\"47\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"28\">" +
                                    "<img src=\"../img/emp_report_14.png\" width=\"613\" height=\"3\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"28\">" +
                                    "<img src=\"../img/emp_report_15.png\" width=\"613\" height=\"12\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"45\">" +
                                    "<img src=\"../img/emp_report_16.png\" width=\"957\" height=\"3\" alt=\"\"></td>" +
                                    "</tr>";
                                    int totalQtySelSvc = 0;
                                    int totalQtySelProd = 0;
                                    BigDecimal totalsTaxeSelSvc = BigDecimal.ZERO;
                                    BigDecimal totalsTotalSelSvc = BigDecimal.ZERO;
                                    BigDecimal totalsPercentAllEmpSvc = BigDecimal.ZERO;
                                    BigDecimal totalsTaxeAllEmpSvc = BigDecimal.ZERO;
                                    BigDecimal totalsTotalAllEmpSvc = BigDecimal.ZERO;
                                    BigDecimal totalsTaxeSelProd = BigDecimal.ZERO;
                                    BigDecimal totalsTotalSelProd = BigDecimal.ZERO;
                                    BigDecimal totalsPercentAllEmpProd = BigDecimal.ZERO;
                                    BigDecimal totalsTaxeAllEmpProd = BigDecimal.ZERO;
                                    BigDecimal totalsTotalAllEmpProd = BigDecimal.ZERO;
                                    BigDecimal totalsSubTotalSvcProd = BigDecimal.ZERO;
                                    BigDecimal totalsTaxeSvcProd = BigDecimal.ZERO;
                                    BigDecimal totalsTotalSvcProd = BigDecimal.ZERO;
                                    BigDecimal totalsPercentAllSvc = BigDecimal.ZERO;
                                    BigDecimal totalsPercentAllProd = BigDecimal.ZERO;
                                    BigDecimal totalsPercentTotal = BigDecimal.ZERO;
                                    BigDecimal totalsSalary = BigDecimal.ZERO;

                                    BigDecimal taxeSelSvc = BigDecimal.ZERO;
                                    BigDecimal totalSelSvc = BigDecimal.ZERO;
                                    BigDecimal percentAllEmpSvc = BigDecimal.ZERO;
                                    BigDecimal taxeAllEmpSvc = BigDecimal.ZERO;
                                    BigDecimal totalAllEmpSvc = BigDecimal.ZERO;
                                    BigDecimal taxeSelProd = BigDecimal.ZERO;
                                    BigDecimal totalSelProd = BigDecimal.ZERO;
                                    BigDecimal percentAllEmpProd = BigDecimal.ZERO;
                                    BigDecimal taxeAllEmpProd = BigDecimal.ZERO;
                                    BigDecimal totalAllEmpProd = BigDecimal.ZERO;
                                    BigDecimal subTotalSvcProd = BigDecimal.ZERO;
                                    BigDecimal taxeSvcProd = BigDecimal.ZERO;
                                    BigDecimal totalSvcProd = BigDecimal.ZERO;
                                    BigDecimal percentAllSvc = BigDecimal.ZERO;
                                    BigDecimal percentAllProd = BigDecimal.ZERO;
                                    BigDecimal percentTotal = BigDecimal.ZERO;
                                    BigDecimal salary = BigDecimal.ZERO;
                                    int qtySelSvc=0;
                                    int qtyAllSvc=0;
                                    int qtySelProd=0;
                                    int qtyAllProd=0;
                                    Set entries_emp = hmapEmployee.entrySet();
                                    Iterator it_emp = entries_emp.iterator();
                                    while (it_emp.hasNext()) {
                                      Map.Entry entry_emp = (Map.Entry) it_emp.next();
//                                      System.out.println(entry.getKey() + "-->" + entry.getValue());
                                        qtySelSvc=0;
                                        qtyAllSvc=0;
                                        qtySelProd=0;
                                        qtyAllProd=0;
                                        taxeSelSvc = BigDecimal.ZERO;
                                        totalSelSvc = BigDecimal.ZERO;
                                        percentAllEmpSvc = BigDecimal.ZERO;
                                        taxeAllEmpSvc = BigDecimal.ZERO;
                                        totalAllEmpSvc = BigDecimal.ZERO;
                                        taxeSelProd = BigDecimal.ZERO;
                                        totalSelProd = BigDecimal.ZERO;
                                        percentAllEmpProd = BigDecimal.ZERO;
                                        taxeAllEmpProd = BigDecimal.ZERO;
                                        totalAllEmpProd = BigDecimal.ZERO;
                                        subTotalSvcProd = BigDecimal.ZERO;
                                        taxeSvcProd = BigDecimal.ZERO;
                                        totalSvcProd = BigDecimal.ZERO;
                                        percentAllSvc = BigDecimal.ZERO;
                                        percentAllProd = BigDecimal.ZERO;
                                        percentTotal = BigDecimal.ZERO;
                                        salary = BigDecimal.ZERO;
                                        Employee e = Employee.findById(Integer.parseInt(String.valueOf(entry_emp.getKey())));

                                        for (int m1=0; m1<listTrans.size(); m1++){
                                            Reconciliation rr = (Reconciliation)listTrans.get(m1);
                                            String filter4="";
                                            if (bFlag2)
                                                filter4 += " AND ";
                                            filter4 = filter2 + filter4 + "code_transaction ='"+rr.getCode_transaction()+"' AND location_id='"+rr.getId_location()+"' AND employee_id='"+entry_emp.getKey()+"'";
                                            ArrayList listtt = Ticket.findTicketByFilter(filter4);
                                            for (int m2 = 0; m2<listtt.size(); m2++){
                                                Ticket tt = (Ticket)listtt.get(m2);
                                                if (tt!=null && tt.getStatus()!=4){
                                                    if (tt.getService_id()!=0 && !listidserv.equals("")){
                                                        if (idserv.equals(String.valueOf(tt.getService_id()))){
                                                                qtySelSvc = qtySelSvc+tt.getQty();
                                                                if (taxe.equals("true"))
                                                                    taxeSelSvc = taxeSelSvc.add(tt.getTaxe());
                                                                totalSelSvc = totalSelSvc.add(tt.getPrice().multiply(new BigDecimal(tt.getQty())).multiply(new BigDecimal(1.0 - tt.getDiscount()/100.0f)));
                                                        }
                                                        if (taxe.equals("true")){
                                                            taxeAllEmpSvc = taxeAllEmpSvc.add(tt.getTaxe());
                                                        }
                                                        totalAllEmpSvc = totalAllEmpSvc.add(tt.getPrice().multiply(new BigDecimal(tt.getQty())).multiply(new BigDecimal(1.0 - tt.getDiscount()/100.0f)));

//                                                        if (e!=null){
//                                                            EmpServ es = EmpServ.findByEmployeeIdAndServiceID(tt.getService_id(), e.getId());
//                                                            if (es!=null && es.getCommission()!=null){
//                                                                Double dtmp = new Double(((totalAllEmpSvc.add(taxeAllEmpSvc)).multiply(es.getCommission())).doubleValue());
//                                                                percentAllSvc = new BigDecimal(dtmp.doubleValue()/100);
//                                                            }else{
//                                                                Double dtmp2 = new Double(((totalAllEmpSvc.add(taxeAllEmpSvc)).multiply(e.getCommission())).doubleValue());
//                                                                percentAllSvc = new BigDecimal(dtmp2.doubleValue()/100);
//                                                            }
//                                                        }
                                                    }
                                                    if (tt.getProduct_id()!=0 && !listidprod.equals("")){
                                                        if (idprod.equals(String.valueOf(tt.getProduct_id()))) {
                                                                qtySelProd = qtySelProd + tt.getQty();
                                                                if (taxe.equals("true"))
                                                                    taxeSelProd = taxeSelProd.add(tt.getTaxe());
                                                                totalSelProd = totalSelProd.add(tt.getPrice().multiply(new BigDecimal(tt.getQty())).multiply(new BigDecimal(1.0 - tt.getDiscount()/100.0f)));
                                                        }
                                                        if (taxe.equals("true")){
                                                            taxeAllEmpProd = taxeAllEmpProd.add(tt.getTaxe());
                                                        }
                                                        totalAllEmpProd = tt.getPrice().multiply(new BigDecimal(tt.getQty())).multiply(new BigDecimal(1.0 - tt.getDiscount()/100.0f));
                                                    }
                                                }
                                            }  //
                                        }
                                        subTotalSvcProd = totalAllEmpSvc.add(totalAllEmpProd);
                                        taxeSvcProd = taxeAllEmpSvc.add(taxeAllEmpProd);
                                        totalSvcProd = subTotalSvcProd.add(taxeSvcProd);
                                        totalQtySelProd = totalQtySelProd + qtySelProd;
                                        totalQtySelSvc = totalQtySelSvc + qtySelSvc;
                                        totalsTaxeSelSvc = totalsTaxeSelSvc.add(taxeSelSvc);
                                        totalsTotalSelSvc = totalsTotalSelSvc.add(totalSelSvc);
                                        totalsTaxeAllEmpSvc = totalsTaxeAllEmpSvc.add(taxeAllEmpSvc);
                                        totalsTotalAllEmpSvc = totalsTotalAllEmpSvc.add(totalAllEmpSvc);
                                        totalsTaxeSelProd = totalsTaxeSelProd.add(taxeSelProd);
                                        totalsTotalSelProd = totalsTotalSelProd.add(totalSelProd);
                                        totalsTaxeAllEmpProd = totalsTaxeAllEmpProd.add(taxeAllEmpProd);
                                        totalsTotalAllEmpProd = totalsTotalAllEmpProd.add(totalAllEmpProd);
                                        totalsSubTotalSvcProd = totalsSubTotalSvcProd.add(subTotalSvcProd);
                                        totalsTaxeSvcProd = totalsTaxeSvcProd.add(taxeSvcProd);
                                        totalsTotalSvcProd = totalsTotalSvcProd.add(totalSvcProd);
                                        totalsPercentTotal = totalsPercentTotal.add(percentTotal);
//                                        if (e!=null){
//                                            BigDecimal comm = e.getCommission();
//                                            if (comm == null) {
//                                                comm = BigDecimal.ZERO;
//                                            }
//                                            comm = comm.divide(new BigDecimal(100));
//                                            salary = subTotalSvcProd.multiply(comm);
//                                            comm = null;
//                                        }

                                        Double d = new Double((totalSelSvc.add(taxeSelSvc).multiply(new BigDecimal(100))).doubleValue());
                                        Double dd = new Double((totalAllEmpSvc.add(taxeAllEmpSvc)).doubleValue());
                                        if (dd != 0)  {
                                            percentAllEmpSvc = new BigDecimal(d.doubleValue()/dd.doubleValue());
                                        }
                                        else {
                                            percentAllEmpSvc = new BigDecimal("0");
                                        }
                                        d = new Double((totalsTotalSelSvc.add(totalsTaxeSelSvc).multiply(new BigDecimal(100))).doubleValue());
                                        dd = new Double((totalsTotalAllEmpSvc.add(totalsTaxeAllEmpSvc)).doubleValue());
                                        if (dd != 0)  {
                                            totalsPercentAllEmpSvc = new BigDecimal(d.doubleValue()/dd.doubleValue());
                                        }
                                        else {
                                            totalsPercentAllEmpSvc = new BigDecimal("0");
                                        }
                                        //============= percents=============//
                                        d = new Double((totalSelProd.add(taxeSelProd).multiply(new BigDecimal(100))).doubleValue());
                                        dd = new Double((totalAllEmpProd.add(taxeAllEmpProd)).doubleValue());
                                        if (dd != 0)  {
                                            percentAllEmpProd = new BigDecimal(d.doubleValue()/dd.doubleValue());
                                        }
                                        else {
                                            percentAllEmpProd = new BigDecimal("0");
                                        }
                                        d = new Double((totalsTotalSelProd.add(totalsTaxeSelProd).multiply(new BigDecimal(100))).doubleValue());
                                        dd = new Double((totalsTotalAllEmpProd.add(totalsTaxeAllEmpProd)).doubleValue());
                                        if (dd != 0)  {
                                            totalsPercentAllEmpProd = new BigDecimal(d.doubleValue()/dd.doubleValue());
                                        }
                                        else {
                                            totalsPercentAllEmpProd = new BigDecimal("0");
                                        }
                                        d = new Double(((totalAllEmpSvc.add(taxeAllEmpSvc)).multiply((e!=null && e.getCommission()!=null)?e.getCommission():new BigDecimal(0))).doubleValue());
//                                        dd = new Double(totalSvcProd.doubleValue());
//                                        if (dd != 0)  {
                                            percentAllSvc = new BigDecimal(d.doubleValue()/100);
//                                        }
//                                        else {
//                                            percentAllSvc = new BigDecimal("0");
//                                        }
//                                        d = new Double((totalsTotalAllEmpSvc.add(totalsTaxeAllEmpSvc).multiply(new BigDecimal(100))).doubleValue());
//                                        dd = new Double(totalsTotalSvcProd.doubleValue());
//                                        if (dd != 0)  {
//                                            totalsPercentAllSvc = new BigDecimal(d.doubleValue()/dd.doubleValue());
//                                        }
//                                        else {
                                            totalsPercentAllSvc = totalsPercentAllSvc.add(percentAllSvc);
//                                        }
                                        d = new Double(((totalAllEmpProd.add(taxeAllEmpProd)).multiply(new BigDecimal((e!=null && StringUtils.isNotEmpty(e.getSalary()))?e.getSalary():"0"))).doubleValue());
//                                        dd = new Double(totalSvcProd.doubleValue());
//                                        if (dd != 0)  {
                                            percentAllProd = new BigDecimal(d.doubleValue()/100);
//                                        }
//                                        else {
//                                            percentAllProd = new BigDecimal("0");
//                                        }
//                                        d = new Double((totalsTotalAllEmpProd.add(totalsTaxeAllEmpProd).multiply(new BigDecimal(100))).doubleValue());
//                                        dd = new Double(totalsTotalSvcProd.doubleValue());
//                                        if (dd != 0)  {
//                                            totalsPercentAllProd = new BigDecimal(d.doubleValue()/dd.doubleValue());
//                                        }
//                                        else {
                                            totalsPercentAllProd = totalsPercentAllProd.add(percentAllProd);
//                                        }
                                        salary = percentAllSvc.add(percentAllProd);
                                        totalsSalary = totalsSalary.add(salary);
                                        d = null;
                                        String emplName = "";
                                        if ((entry_emp!=null)&&(entry_emp.getValue()!=null))            {
                                            emplName = entry_emp.getValue().toString().length()<7?entry_emp.getValue().toString():entry_emp.getValue().toString().substring(0,7);

                                        responcedata += "<tr>" +
                                                "<th>" +
                                                emplName+
                                                "</th>" +
                                                "<td colspan=\"2\">" +
                                                "<img src=\"../img/emp_report_18.png\" width=\"5\" height=\"21\" alt=\"\"></td>" +
                                                "<td class=\"small\" colspan=\"2\">" +
                                                percentAllEmpSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_20.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td>" +
                                                taxeSelSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_22.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td colspan=\"2\">" +
                                                totalSelSvc.add(taxeSelSvc).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_24.png\" width=\"3\" height=\"21\" alt=\"\"></td>" +
                                                "<td>" +
                                                taxeAllEmpSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_26.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td colspan=\"2\">" +
                                                totalAllEmpSvc.add(taxeAllEmpSvc).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_28.png\" width=\"12\" height=\"21\" alt=\"\"></td>" +
                                                "<td class=\"small\" colspan=\"2\">" +
                                                percentAllEmpProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_30.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td>" +
                                                taxeSelProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_32.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td colspan=\"2\">" +
                                                totalSelProd.add(taxeSelProd).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_34.png\" width=\"4\" height=\"21\" alt=\"\"></td>" +
                                                "<td>" +
                                                taxeAllEmpProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_36.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td colspan=\"2\">" +
                                                totalAllEmpProd.add(taxeAllEmpProd).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_38.png\" width=\"10\" height=\"21\" alt=\"\"></td>" +
                                                "<td  class=\"small\" colspan=\"2\">" +
                                                subTotalSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_40.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td  class=\"small\">" +
                                                        taxeSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_42.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td  class=\"small\" colspan=\"2\">" +
                                                totalSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_44.png\" width=\"10\" height=\"21\" alt=\"\"></td>" +
                                                "<td colspan=\"2\">" +
                                                percentAllSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_46.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td>" +
                                                percentAllProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_48.png\" width=\"2\" height=\"21\" alt=\"\"></td>" +
                                                "<td colspan=\"2\">" +
                                                salary.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                                "</td>" +
                                                "<td>" +
                                                "<img src=\"../img/emp_report_50.png\" width=\"5\" height=\"21\" alt=\"\"></td>" +
                                                "</tr>" +
                                                "<tr>" +
                                                "<td colspan=\"45\">" +
                                                "<img src=\"../img/emp_report_51.png\" width=\"957\" height=\"2\" alt=\"\"></td>" +
                                                "</tr>";
                                                percentAllEmpProd = percentAllProd = percentAllEmpSvc = percentAllSvc = percentTotal = null;
                                            }
                                    }
                            responcedata +="<tr>" +
                                    "<td colspan=\"3\">" +
                                    "<img src=\"../img/emp_report_54.png\" width=\"59\" height=\"22\" alt=\"\"></td>" +
                                    "<td class=\"small\" colspan=\"2\">" +
                                    totalsPercentAllEmpSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_56.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsTaxeSelSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_58.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    totalsTotalSelSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_60.png\" width=\"3\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsTaxeAllEmpSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_62.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsTotalAllEmpSvc.add(totalsTaxeAllEmpSvc).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_64.png\" width=\"23\" height=\"22\" alt=\"\"></td>" +
                                    "<td class=\"small\" colspan=\"2\">" +
                                    totalsPercentAllEmpProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_66.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsTaxeSelProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_68.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    totalsTotalSelProd.add(totalsTaxeSelProd).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_70.png\" width=\"4\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsTaxeAllEmpProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_72.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsTotalAllEmpProd.add(totalsTaxeAllEmpProd).setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td colspan=\"3\">" +
                                    "<img src=\"../img/emp_report_74.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                                    "<td class=\"small\">" +
                                    totalsSubTotalSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_76.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td class=\"small\">" +
                                    totalsTaxeSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_78.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td class=\"small\">" +
                                    totalsTotalSvcProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td colspan=\"3\">" +
                                    "<img src=\"../img/emp_report_80.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsPercentAllSvc.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_82.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsPercentAllProd.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_84.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    totalsSalary.setScale(2, BigDecimal.ROUND_HALF_DOWN) +
                                    "</td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_86.png\" width=\"16\" height=\"22\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"45\">" +
                                    "<img src=\"../img/emp_report_87.png\" width=\"957\" height=\"5\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"54\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"1\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"16\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"3\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"66\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"12\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"18\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"15\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"65\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"38\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"36\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"34\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"44\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"51\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"68\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"5\" height=\"1\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "</table>";
                                   totalsPercentAllEmpProd = totalsPercentAllProd = totalsPercentAllEmpSvc = totalsPercentAllSvc = totalsPercentTotal = null;
                        } else {
                            responcedata ="<table id=\"emp_report_table\" width=\"957\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">" +
                                    "                    <input type=\"hidden\" value=\"0\" id=\"prod_id\" name=\"prod_id\"/>" +
                                    "                <input type=\"hidden\" value=\"0\" id=\"serv_id\" name=\"serv_id\"/>" +
                                    "<tr>" +
                                    "<td colspan=\"45\">" +
                                    "<img src=\"../img/emp_report_01.png\" width=\"957\" height=\"16\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"45\">" +
                                    "<img src=\"../img/emp_report_02.png\" width=\"957\" height=\"4\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_03.png\" width=\"58\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_04.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                                    "        </td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_06.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_07.png\" width=\"3\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\">" +
                                    "<img src=\"../img/emp_report_08.png\" width=\"146\" height=\"32\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_09.png\" width=\"18\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\" style=\"text-align:center;font-size:10pt;background-color:white;\">" +
                                    "        </td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_11.png\" width=\"17\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"5\">" +
                                    "<img src=\"../img/emp_report_12.png\" width=\"137\" height=\"32\" alt=\"\"></td>" +
                                    "<td colspan=\"17\" rowspan=\"3\">" +
                                    "<img src=\"../img/emp_report_13.png\" width=\"344\" height=\"47\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"28\">" +
                                    "<img src=\"../img/emp_report_14.png\" width=\"613\" height=\"3\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"28\">" +
                                    "<img src=\"../img/emp_report_15.png\" width=\"613\" height=\"12\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"45\">" +
                                    "<img src=\"../img/emp_report_16.png\" width=\"957\" height=\"3\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"3\">" +
                                    "<img src=\"../img/emp_report_54.png\" width=\"59\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_55.png\" width=\"33\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_56.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_57.png\" width=\"39\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_58.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_59.png\" width=\"58\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_60.png\" width=\"3\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_61.png\" width=\"66\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_62.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_63.png\" width=\"55\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_64.png\" width=\"23\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_65.png\" width=\"33\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_66.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_67.png\" width=\"39\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_68.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_69.png\" width=\"58\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_70.png\" width=\"4\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_71.png\" width=\"65\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_72.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_73.png\" width=\"55\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"3\">" +
                                    "<img src=\"../img/emp_report_74.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_75.png\" width=\"38\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_76.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_77.png\" width=\"36\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_78.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_79.png\" width=\"34\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"3\">" +
                                    "<img src=\"../img/emp_report_80.png\" width=\"30\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_81.png\" width=\"44\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_82.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_83.png\" width=\"51\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_84.png\" width=\"2\" height=\"22\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/emp_report_85.png\" width=\"68\" height=\"22\" alt=\"\"></td>" +
                                    "<td colspan=\"2\">" +
                                    "<img src=\"../img/emp_report_86.png\" width=\"16\" height=\"22\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td colspan=\"45\">" +
                                    "<img src=\"../img/emp_report_87.png\" width=\"957\" height=\"5\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"54\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"1\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"16\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"3\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"66\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"12\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"18\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"15\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"39\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"41\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"17\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"4\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"65\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"55\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"38\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"36\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"34\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"10\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"9\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"44\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"51\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"2\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"68\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"11\" height=\"1\" alt=\"\"></td>" +
                                    "<td>" +
                                    "<img src=\"../img/spacer.gif\" width=\"5\" height=\"1\" alt=\"\"></td>" +
                                    "</tr>" +
                                    "</table>";
                        }                    
                        response.getOutputStream().print(responcedata);
//                        return;
                    hmapService = hmapProduct = hmapEmployee = null;

                }
                else if(type.equals("FINREPORT"))
                {
                    String strType = request.getParameter("type_per");
                    String returnTable = "";
                    ArrayList arrFR = null;
                    BigDecimal total_amex = BigDecimal.ZERO;
                    BigDecimal total_visa = BigDecimal.ZERO;
                    BigDecimal total_mastercard = BigDecimal.ZERO;
                    BigDecimal total_giftcard = BigDecimal.ZERO;
                    BigDecimal total_giftcard_buy = BigDecimal.ZERO;
                    BigDecimal total_payin = BigDecimal.ZERO;
                    BigDecimal total_payout = BigDecimal.ZERO;
                    BigDecimal total_refund = BigDecimal.ZERO;
                    BigDecimal total_cashe = BigDecimal.ZERO;
                    BigDecimal total_check = BigDecimal.ZERO;
                    BigDecimal total_total = BigDecimal.ZERO;
                    BigDecimal total = BigDecimal.ZERO;

                    if(strType.equals("day"))
                    {
                        arrFR = FinancialReport.findByDay();
                    }
                    else if(strType.equals("week"))
                    {
                        arrFR = FinancialReport.findByWeek();
                    }
                    else if(strType.equals("mounth"))
                    {
                        arrFR = FinancialReport.findByMounth();
                    }
                    for(int i = 0; i < arrFR.size(); i++)
                    {
                        FinancialReport fr = (FinancialReport)arrFR.get(i);
                        total_amex = total_amex.add(fr.getAmex());
                        total_visa = total_visa.add(fr.getVisa());
                        total_mastercard = total_mastercard.add(fr.getMastercard());                        
                        total_giftcard = total_giftcard.add(fr.getGiftcard());
                        total_giftcard_buy = total_giftcard_buy.add(fr.getGiftcard_buy());
                        total_payin = total_payin.add(fr.getPay_in());
                        total_payout = total_payout.add(fr.getPay_out());
                        total_refund = total_refund.add(fr.getRefund());
                        total_cashe = total_cashe.add(fr.getCashe());
                        total_check = total_check.add(fr.getCheque());
                        total = fr.getCashe().add(fr.getMastercard()).add(fr.getVisa()).add(fr.getAmex()).add(fr.getCheque());
                        total_total = total_total.add(total);
                        returnTable = returnTable + "<tr>" +
                                "<td colspan=\"29\">" +
                                "<img src=\"../img/fin_report_new_02.jpg\" width=\"973\" height=\"2\" alt=\"\"></td>" +
                                "</tr>" +
                                "<tr>" +
                                "<td style=\"text-align: left;\"><b>" +
                                    fr.getIden() +
                                "</b></td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_04.jpg\" width=\"3\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\">" +
                                    fr.getCashe().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_06.jpg\" width=\"1\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\">" +
                                    fr.getMastercard().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_08.jpg\" width=\"1\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\">" +
                                    fr.getVisa().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_10.jpg\" width=\"1\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\">" +
                                    fr.getAmex().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_12.jpg\" width=\"1\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\">" +
                                    fr.getCheque().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_14.jpg\" width=\"3\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\">" +
                                    total.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    fr.getTotal().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_16.jpg\" width=\"2\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\" >" +
                                   fr.getGiftcard_buy().setScale(2,BigDecimal.ROUND_HALF_DOWN) + 
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_18.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                                "<td class=\"val\" colspan=\"2\">" +
                                    fr.getGiftcard().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_20.jpg\" width=\"20\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\" colspan=\"2\">" +
                                "<div style=\"position: relative; display: block; width: 31px; left: 0px; top: -6px;margin-right: 0px; padding: 0; text-align: left;\">"+
                                    "<div style=\"position: absolute; text-align: center; left: -1px; font-size:9pt; width: 47px;\">"+
                                        fr.getPay_in().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                    "</div>" +
                                "</div>" +
                                "</td>" +
                                "<td> <img src=\"../img/fin_report_new_22.jpg\" width=\"1\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\" colspan=\"2\">" +
                                "<div style=\"padding: 0pt; position: relative; display: block; width: 31px; left: 0px; top: -6px; margin-right: 0px; text-align: center;\">"+
                                    "<div style=\"position: absolute;text-align: center;  left: -1px; font-size:9pt; width: 47px;\">"+
                                        fr.getPay_out().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                    "</div>" +
                                "</div>" +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_24.jpg\" width=\"15\" height=\"31\" alt=\"\"></td>" +
                                "<td class=\"val\" colspan=\"3\">" +
                                "<div style=\"padding: 0pt; position: relative; display: block; width: 31px; left: 0px; top: -6px; margin-right: 0px; text-align: center;\">"+
                                    "<div style=\"position: absolute; left: -1px; font-size:9pt; width: 47px;\">"+
                                        fr.getRefund().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                    "</div>" +
                                "</div>" +
                                "</td>" +
                                "<td>" +
                                "<img src=\"../img/fin_report_new_26.jpg\" width=\"4\" height=\"31\" alt=\"\"></td>" +
                                "</tr>";
                    }
//                        returnTable = returnTable + "<tr>" +
//                                "<td colspan=\"27\">" +
//                                "<img src=\"../img/finreport4_02.jpg\" width=\"947\" height=\"5\" alt=\"\"></td>" +
//                                "</tr>" +
//                                "<tr>" +
//                                "<th style=\"text-align: left;\">" +
//                                    fr.getIden() +
//                                "</th>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_04.jpg\" width=\"4\" height=\"29\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    fr.getCashe().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_06.jpg\" width=\"3\" height=\"29\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    fr.getMastercard().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_08.jpg\" width=\"3\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\">" +
//                                fr.getVisa().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_10.jpg\" width=\"3\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\">" +
//                                fr.getAmex().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_12.jpg\" width=\"3\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\">" +
//                                fr.getCheque().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_14.jpg\" width=\"4\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\">" +
//                                fr.getGiftcard().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_16.jpg\" width=\"5\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\" colspan=\"2\">" +
//                                fr.getTotal().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_18.jpg\" width=\"20\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\" colspan=\"2\">" +
//                            "<div style=\"position: relative; display: block; width: 31px; left: 0px; top: -6px;margin-right: 0px; padding: 0; text-align: left;\">"+
//                                "<div style=\"position: absolute; text-align: center; left: -1px; font-size:9pt; width: 47px;\">"+
//                                    fr.getPay_in().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</div>" +
//                            "</div>" +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_20.jpg\" width=\"3\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\" colspan=\"2\">" +
//                            "<div style=\"padding: 0pt; position: relative; display: block; width: 31px; left: 0px; top: -6px; margin-right: 0px; text-align: center;\">"+
//                                "<div style=\"position: absolute;text-align: center;  left: -1px; font-size:9pt; width: 47px;\">"+
//                                    fr.getPay_out().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</div>" +
//                            "</div>" +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_22.jpg\" width=\"17\" height=\"29\" alt=\"\"></td>" +
//                            "<td class=\"val\" colspan=\"3\">" +
//                            "<div style=\"padding: 0pt; position: relative; display: block; width: 31px; left: 0px; top: -6px; margin-right: 0px; text-align: center;\">"+
//                                "<div style=\"position: absolute; left: -1px; font-size:9pt; width: 47px;\">"+
//                                    fr.getRefund().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</div>" +
//                            "</div>" +
//                            "</td>" +
//                                "<td>" +
//                                "<img src=\"../img/finreport4_24.jpg\" width=\"4\" height=\"29\" alt=\"\"></td>" +
//                                "</tr>";
//                    }
//                        returnTable = returnTable + "<tr>" +
//                            "<th style=\"text-align: left;\">" +
//                                fr.getIden() +
//                            "</th>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_26.png\" width=\"3\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\">" +
//                                fr.getCashe().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_28.png\" width=\"2\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\">" +
//                                fr.getMastercard().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_30.png\" width=\"2\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\">" +
//                                fr.getVisa().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_32.png\" width=\"2\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\">" +
//                                fr.getAmex().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_34.png\" width=\"2\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\">" +
//                                fr.getCheque().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_36.png\" width=\"1\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\">" +
//                                fr.getGiftcard().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_38.png\" width=\"3\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\" colspan=\"2\">" +
//                                fr.getTotal().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_40.png\" width=\"16\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\" colspan=\"2\">" +
//                            "<div style=\"position: relative; display: block; width: 31px; left: 0px; top: -6px;margin-right: 0px; padding: 0; text-align: left;\">"+
//                                "<div style=\"position: absolute; text-align: center; left: -1px; width: 47px;\">"+
//                                    fr.getPay_in().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</div>" +
//                            "</div>" +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_42.png\" width=\"2\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\" colspan=\"2\">" +
//                            "<div style=\"padding: 0pt; position: relative; display: block; width: 31px; left: 0px; top: -6px; margin-right: 0px; text-align: center;\">"+
//                                "<div style=\"position: absolute;text-align: center;  left: -1px; width: 47px;\">"+
//                                    fr.getPay_out().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</div>" +
//                            "</div>" +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_44.png\" width=\"13\" height=\"24\" alt=\"\">" +"</td>" +
//                            "<td class=\"val\" colspan=\"3\">" +
//                            "<div style=\"padding: 0pt; position: relative; display: block; width: 31px; left: 0px; top: -6px; margin-right: 0px; text-align: center;\">"+
//                                "<div style=\"position: absolute; left: -1px; width: 47px;\">"+
//                                    fr.getRefund().setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</div>" +
//                            "</div>" +
//                            "</td>" +
//                            "<td>" +
//                                "<img src=\"../img/fin_report_46.png\" width=\"3\" height=\"24\" alt=\"\">" + "</td>" +
//                            "</tr>";

                    returnTable = returnTable + "<tr>" +
                            "<td colspan=\"29\">" +
                            "<img src=\"../img/fin_report_new_29.jpg\" width=\"973\" height=\"5\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_30.jpg\" width=\"68\" height=\"28\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_31.jpg\" width=\"3\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_cashe.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_33.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_35.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_visa.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_37.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_amex.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_39.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_check.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_41.jpg\" width=\"3\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                 total_total.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_43.jpg\" width=\"2\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                              total_giftcard_buy.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_45.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_giftcard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td colspan=\"3\">" +
                            "<img src=\"../img/fin_report_new_47.jpg\" width=\"34\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                            "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
                                "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
                                    total_payin.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</div>" +
                            "</div>" +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_49.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                             "<div style=\"position: relative; display: block; width: 31px; left: -2px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
                                "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
                                    total_payout.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</div>" +
                            "</div>" +
                            "</td>" +
                            "<td colspan=\"3\">" +
                            "<img src=\"../img/fin_report_new_51.jpg\" width=\"27\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                             "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
                                "<div style=\"position: absolute;text-align: center; font-size:9pt; width: 47px;\">" +
                                    total_refund.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</div>" +
                            "</div>" +
                            "</td>" +
                            "<td colspan=\"2\">" +
                            "<img src=\"../img/fin_report_new_53.jpg\" width=\"10\" height=\"28\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"29\">" +
                            "<img src=\"../img/fin_report_new_54.jpg\" width=\"973\" height=\"5\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"68\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"86\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"83\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"84\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"86\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"75\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"8\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"20\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"54\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"50\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"15\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"47\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
                            "</tr>";
                    
//                    returnTable = returnTable + "<tr>" +
//                            "<td colspan=\"27\">" +
//                            "<img src=\"../img/finreport4_27.jpg\" width=\"947\" height=\"6\" alt=\"\"></td>" +
//                            "</tr>" +
//                         "<tr>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_28.jpg\" width=\"100\" height=\"27\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_29.jpg\" width=\"4\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_cashe.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_31.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_33.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_visa.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_35.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_amex.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_37.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_check.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_39.jpg\" width=\"4\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_giftcard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_41.jpg\" width=\"5\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                     total_total.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td colspan=\"3\">" +
//                            "<img src=\"../img/finreport4_43.jpg\" width=\"40\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
//                                        total_payin.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_45.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                 "<div style=\"position: relative; display: block; width: 31px; left: -2px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
//                                        total_payout.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                            "<td colspan=\"3\">" +
//                            "<img src=\"../img/finreport4_47.jpg\" width=\"31\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                 "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute;text-align: center; font-size:9pt; width: 47px;\">" +
//                                        total_refund.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                            "<td colspan=\"2\">" +
//                            "<img src=\"../img/finreport4_49.png\" width=\"12\" height=\"27\" alt=\"\"></td>" +
//                            "</tr>"+
//                            "<tr>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"100\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"89\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"88\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"88\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"89\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"88\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"5\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"73\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"11\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"20\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"9\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"49\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"46\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"7\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"17\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"7\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"41\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"8\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
//                            "</tr>" +
//                            "<tr>" +
//                            "<td colspan=\"27\">" +
//                            "<img src=\"../img/finreport4_50.gif\" width=\"947\" height=\"4\" alt=\"\"></td>" +
//                            "</tr>";
//                    returnTable = returnTable + "<tr>" +
//                                "<td colspan=\"27\">" +
//                                    "<img src=\"../img/fin_report_47.png\" width=\"757\" height=\"2\" alt=\"\">" +"</td>" +
//                            "</tr>" +
//                            "<tr>" +
//                                "<td colspan=\"27\">" +
//                                    "<img src=\"../img/fin_report_49.png\" width=\"757\" height=\"4\" alt=\"\">" +"</td>" +
//                            "</tr>" +
//                            "<tr>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_50.png\" width=\"80\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_51.png\" width=\"3\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                    total_cashe.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_53.png\" width=\"2\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                    total_mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_55.png\" width=\"2\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                    total_visa.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_57.png\" width=\"2\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                    total_amex.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_59.png\" width=\"2\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                    total_check.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_61.png\" width=\"1\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                    total_giftcard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_63.png\" width=\"3\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                     total_total.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                                "<td colspan=\"3\">" +
//                                    "<img src=\"../img/fin_report_65.png\" width=\"30\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute; text-align: center; width: 47px; \">" +
//                                        total_payin.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                                "<td>" +
//                                    "<img src=\"../img/fin_report_67.png\" width=\"2\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                 "<div style=\"position: relative; display: block; width: 31px; left: -2px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute; text-align: center; width: 47px; \">" +
//                                        total_payout.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                                "<td colspan=\"3\">" +
//                                    "<img src=\"../img/fin_report_69.png\" width=\"27\" height=\"21\" alt=\"\">" +"</td>" +
//                                "<td class=\"val\">" +
//                                 "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute;text-align: center; width: 47px;\">" +
//                                        total_refund.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                                "<td colspan=\"2\">" +
//                                    "<img src=\"../img/fin_report_71.png\" width=\"10\" height=\"21\" alt=\"\">" +"</td>" +
//                            "</tr>" +
//                            "<tr>" +
//                                "<td colspan=\"27\">" +
//                                    "<img src=\"../img/fin_report_72.png\" width=\"757\" height=\"4\" alt=\"\">" +"</td>" +
//                            "</tr>";
                    response.getOutputStream().print(returnTable);
                } else if (type.equals("FINTOTAL")){
                    String fromdt =  StringUtils.defaultString(request.getParameter("fromdt"),"");
                    String todt =  StringUtils.defaultString(request.getParameter("todt"),"");

                    BigDecimal total_amex = BigDecimal.ZERO;
                    BigDecimal total_visa = BigDecimal.ZERO;
                    BigDecimal total_mastercard = BigDecimal.ZERO;
                    BigDecimal total_giftcard = BigDecimal.ZERO;
                    BigDecimal total_giftcard_buy = BigDecimal.ZERO;
                    BigDecimal total_payin = BigDecimal.ZERO;
                    BigDecimal total_payout = BigDecimal.ZERO;
                    BigDecimal total_refund = BigDecimal.ZERO;
                    BigDecimal total_cashe = BigDecimal.ZERO;
                    BigDecimal total_check = BigDecimal.ZERO;
                    BigDecimal total_total = BigDecimal.ZERO;
                    String returnTable = "";

//                    ArrayList fr_total = FinancialReport.findFromToDate(fromdt, todt);

                    FinancialReport fr = FinancialReport.findFromToDate(fromdt, todt);
                    if (fr!= null){
//                        FinancialReport fr = (FinancialReport) fr_total.get(i);
                        total_amex = fr.getAmex();
                        total_visa = fr.getVisa();
                        total_mastercard = fr.getMastercard();
                        total_giftcard = fr.getGiftcard();
                        total_giftcard_buy = fr.getGiftcard_buy();
//                        total_giftcard_buy = new BigDecimal(0.0);
                        total_payin = fr.getPay_in();
                        total_payout = fr.getPay_out();
                        total_refund = fr.getRefund();
                        total_cashe = fr.getCashe();
                        total_check = fr.getCheque();
                        total_total = fr.getCashe().add(fr.getMastercard()).add(fr.getVisa()).add(fr.getAmex()).add(fr.getCheque());
                    }
                    returnTable = "<table id=\"fin_report_table\" width=\"973\" height=\"56\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"+
                            "<tr>" +
                            "<td colspan=\"29\">" +
                            "<img src=\"../img/fin_report_new_01.jpg\" width=\"973\" height=\"26\" alt=\"\"></td>" +
                            "</tr>"+
                            "<tr>" +
                                "<td colspan=\"29\">" +
                                "<img src=\"../img/fin_report_new_02.jpg\" width=\"973\" height=\"2\" alt=\"\"></td>" +
                                "</tr>" +
                            "<tr>" +
                            "<td colspan=\"29\">" +
                            "<img src=\"../img/fin_report_new_29.jpg\" width=\"973\" height=\"5\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_30.jpg\" width=\"68\" height=\"28\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_31.jpg\" width=\"3\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_cashe.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_33.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_35.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_visa.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_37.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_amex.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_39.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_check.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_41.jpg\" width=\"3\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                 total_total.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_43.jpg\" width=\"2\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_giftcard_buy.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_45.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                                total_giftcard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                            "</td>" +
                            "<td colspan=\"3\">" +
                            "<img src=\"../img/fin_report_new_47.jpg\" width=\"34\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                            "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
                                "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
                                    total_payin.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</div>" +
                            "</div>" +
                            "</td>" +
                            "<td>" +
                            "<img src=\"../img/fin_report_new_49.jpg\" width=\"1\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                             "<div style=\"position: relative; display: block; width: 31px; left: -2px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
                                "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
                                    total_payout.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</div>" +
                            "</div>" +
                            "</td>" +
                            "<td colspan=\"3\">" +
                            "<img src=\"../img/fin_report_new_51.jpg\" width=\"27\" height=\"28\" alt=\"\"></td>" +
                            "<td class=\"val\">" +
                             "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
                                "<div style=\"position: absolute;text-align: center; font-size:9pt; width: 47px;\">" +
                                    total_refund.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
                                "</div>" +
                            "</div>" +
                            "</td>" +
                            "<td colspan=\"2\">" +
                            "<img src=\"../img/fin_report_new_53.jpg\" width=\"10\" height=\"28\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td colspan=\"29\">" +
                            "<img src=\"../img/fin_report_new_54.jpg\" width=\"973\" height=\"5\" alt=\"\"></td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"68\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"86\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"83\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"84\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"2\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"86\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"75\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"8\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"20\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"54\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"1\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"50\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"15\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"47\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"6\" height=\"0\" alt=\"\"></td>" +
                            "<td>" +
                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
                            "</tr></table>";
//                    returnTable = "<table id=\"fin_report_table\" width=\"947\" height=\"56\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>" +
//                            "<td colspan=\"27\">" +
//                            "<img src=\"../img/finreport4_01.jpg\" width=\"947\" height=\"24\" alt=\"\"></td>" +
//                            "</tr>"+
//                            "<tr>" +
//                                "<td colspan=\"27\">" +
//                                "<img src=\"../img/finreport4_02.jpg\" width=\"947\" height=\"5\" alt=\"\"></td>" +
//                                "</tr>" +
//                            "<tr><td>" +
//                            "<img src=\"../img/finreport4_28.jpg\" width=\"100\" height=\"27\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_29.jpg\" width=\"4\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_cashe.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_31.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_mastercard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_33.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_visa.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_35.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_amex.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_37.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_check.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_39.jpg\" width=\"4\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                    total_giftcard.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_41.jpg\" width=\"5\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                     total_total.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                "</td>" +
//                            "<td colspan=\"3\">" +
//                            "<img src=\"../img/finreport4_43.jpg\" width=\"40\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
//                                        total_payin.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                            "<td>" +
//                            "<img src=\"../img/finreport4_45.jpg\" width=\"3\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                 "<div style=\"position: relative; display: block; width: 31px; left: -2px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute; text-align: center; font-size:9pt; width: 47px; \">" +
//                                        total_payout.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                            "<td colspan=\"3\">" +
//                            "<img src=\"../img/finreport4_47.jpg\" width=\"31\" height=\"27\" alt=\"\"></td>" +
//                                "<td class=\"val\">" +
//                                 "<div style=\"position: relative; display: block; width: 31px; left: -6px; top: -6px;margin-right: 0px; padding: 0; text-align: left\">" +
//                                    "<div style=\"position: absolute;text-align: center; font-size:9pt; width: 47px;\">" +
//                                        total_refund.setScale(2,BigDecimal.ROUND_HALF_DOWN) +
//                                    "</div>" +
//                                "</div>" +
//                                "</td>" +
//                            "<td colspan=\"2\">" +
//                            "<img src=\"../img/finreport4_49.png\" width=\"12\" height=\"27\" alt=\"\"></td></tr>"+
//                            "<tr>" +
//                            "<td colspan=\"27\">" +
//                            "<img src=\"../img/finreport4_50.gif\" width=\"947\" height=\"4\" alt=\"\"></td>" +
//                            "</tr>"+
//                            "<tr>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"100\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"85\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"89\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"88\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"88\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"89\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"88\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"5\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"73\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"11\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"20\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"9\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"49\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"3\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"46\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"7\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"17\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"7\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"41\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"8\" height=\"0\" alt=\"\"></td>" +
//                            "<td>" +
//                            "<img src=\"../img/spacer.gif\" width=\"4\" height=\"0\" alt=\"\"></td>" +
//                            "</tr></table>"
//                            ;
                    response.getOutputStream().print(returnTable);
                }  else if (type.equals("CALCVALUES")){
                    String fromdt =  StringUtils.defaultString(request.getParameter("fromdt"),"");
                    String todt =  StringUtils.defaultString(request.getParameter("todt"),"");
                    ArrayList listEmployee = Employee.findWorkingEmp(fromdt, todt, (User)request.getSession().getAttribute("user"));
                    ArrayList listService= Service.findBuyingSvc(fromdt, todt);
                    ArrayList listProduct = Inventory.findBuyingProd(fromdt, todt);
                    String returnDiv = "";
                    returnDiv = "<div id=\"divEmp\" style=\"display:none; position:absolute; margin-left: 405px; \" >\n" +
                            "                <table height=\"100\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"155\" id=\"Table_dropdown\">\n" +
                            "                    <tr>\n" +
                            "                        <td rowspan=\"3\">\n" +
                            "                            <img height=\"104\" width=\"15\" alt=\"\" src=\"../img/dd_dropdown_01.png\"/></td>\n" +
                            "                        <td>\n" +
                            "                            <img height=\"2\" width=\"155\" alt=\"\" src=\"../img/dd_dropdown_02.png\"/></td>\n" +
                            "                    </tr>\n" +
                            "                    <tr>\n" +
                            "                        <td>\n" +
                            "                            <!--img src=\"img/dd_dropdown_03.png\" width=\"275\" height=\"265\" alt=\"\"-->\n" +
                            "                            <div id=\"checkEmployee\" style=\"text-align:left; background: transparent url(../img/dd_dropdown_03.png) repeat scroll 0% 0%; overflow: auto; -moz-background-clip: border; -moz-background-origin: padding; -moz-background-inline-policy: continuous; width: 155px; height: 100px;\">\n";
                            String le = "";
                            String id = "";
                            String name = "";
                            String nameCut = "";
                            for (int i=0; i<listEmployee.size();i++) {
                                Employee emp = (Employee)listEmployee.get(i);
                                id =  String.valueOf(emp.getId());
                                if (i == 0){
                                    le = id;
                                }
                                else {
                                    le = le + "," + id;
                                }
                                name = emp.getFname() + " " + emp.getLname();
                                nameCut = name.length()<13?name:name.substring(0,12);
                                returnDiv = returnDiv +"<input id=\""+id+"\" onclick=\"emp_chb(this);\" type=\"checkbox\" style=\"border:0; height: 10px;  margin-right: 3px;\" title=\""+name+"\"/>"+nameCut+"<br/>\n";
                            }
                            returnDiv = returnDiv +"                                <input type=\"hidden\" name=\"listEmpl\" id=\"listEmpl\" value=\""+le+"\">\n" +
                            "                            </div>\n" +
                            "                        </td>\n" +
                            "                    </tr>\n" +
                            "                    <tr>\n" +
                            "                        <td>\n" +
                            "                            <img height=\"2\" width=\"155\" alt=\"\" src=\"../img/dd_dropdown_04.png\"/></td>\n" +
                            "                    </tr>\n" +
                            "                </table>\n" +
                            "            </div>\n" +
                            "            <div id=\"divSvc\" style=\"display:none; position:absolute;  margin-left: 580px; \" >\n" +
                            "                <table height=\"100\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"140\" id=\"Table_dropdown2\">\n" +
                            "                    <tr>\n" +
                            "                        <td rowspan=\"3\">\n" +
                            "                            <img height=\"104\" width=\"15\" alt=\"\" src=\"../img/dd_dropdown_01.png\"/></td>\n" +
                            "                        <td>\n" +
                            "                            <img height=\"2\" width=\"140\" alt=\"\" src=\"../img/dd_dropdown_02.png\"/></td>\n" +
                            "                    </tr>\n" +
                            "                    <tr>\n" +
                            "                        <td>\n" +
                            "                            <!--img src=\"img/dd_dropdown_03.png\" width=\"275\" height=\"265\" alt=\"\"-->\n" +
                            "                            <div id=\"checkService\" style=\"text-align:left; background: transparent url(../img/dd_dropdown_03.png) repeat scroll 0% 0%; overflow: auto; -moz-background-clip: border; -moz-background-origin: padding; -moz-background-inline-policy: continuous; width: 140px; height: 100px;\">\n";
                            String ls = "";
                            for (int i=0; i<listService.size();i++) {
                                Service svc = (Service)listService.get(i);
                                id = String.valueOf(svc.getId());
                                if (i == 0){
                                    ls = id;
                                }
                                else {
                                    ls = ls + "," + id;
                                }
                                name = svc.getName();
                                nameCut = name.length()<13?name:name.substring(0,12);
                                returnDiv = returnDiv +"<input id=\""+id+"\" type=\"checkbox\" onclick=\"serv_chb(this);\" style=\"border:0; height: 10px;  margin-right: 3px;\" title=\""+name+"\"/>"+nameCut+"<br/>\n";
                            }
                            returnDiv = returnDiv +"                            </div>\n" +
                            "                            <input type=\"hidden\" name=\"listServ\" id=\"listServ\" value=\""+ls+"\">\n" +
                            "                        </td>\n" +
                            "                    </tr>\n" +
                            "                    <tr>\n" +
                            "                        <td>\n" +
                            "                            <img height=\"2\" width=\"140\" alt=\"\" src=\"../img/dd_dropdown_04.png\"/></td>\n" +
                            "                    </tr>\n" +
                            "                </table>\n" +
                            "            </div>\n" +
                            "            <div id=\"divProd\" style=\"display:none; position:absolute; margin-left: 737px; \" >\n" +
                            "                <table height=\"100\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"140\" id=\"Table_dropdown3\">\n" +
                            "                    <tr>\n" +
                            "                        <td rowspan=\"3\">\n" +
                            "                            <img height=\"104\" width=\"15\" alt=\"\" src=\"../img/dd_dropdown_01.png\"/></td>\n" +
                            "                        <td>\n" +
                            "                            <img height=\"2\" width=\"140\" alt=\"\" src=\"../img/dd_dropdown_02.png\"/></td>\n" +
                            "                    </tr>\n" +
                            "                    <tr>\n" +
                            "                        <td>\n" +
                            "                            <!--img src=\"img/dd_dropdown_03.png\" width=\"275\" height=\"265\" alt=\"\"-->\n" +
                            "                            <div id=\"checkProduct\" style=\"text-align:left; background: transparent url(../img/dd_dropdown_03.png) repeat scroll 0% 0%; overflow: auto; -moz-background-clip: border; -moz-background-origin: padding; -moz-background-inline-policy: continuous; width: 140px; height: 100px;\">\n";
                            String lp = "";
                            for (int i=0; i<listProduct.size();i++) {
                                Inventory prod = (Inventory)listProduct.get(i);
                                id = String.valueOf(prod.getId());
                                if (i == 0){
                                    lp = id;
                                }
                                else {
                                    lp = lp + "," + id;
                                }
                                name = prod.getName();
                                nameCut = name.length()<13?name:name.substring(0,12);
                                returnDiv = returnDiv +"<input id=\""+id+"\" type=\"checkbox\" onclick=\"prod_chb(this);\" style=\"border:0; height: 10px;  margin-right: 3px;\" title=\""+name+"\"/>"+nameCut+"<br/>";
                            }
                            returnDiv = returnDiv +"                            </div>\n" +
                            "                            <input type=\"hidden\" name=\"listProd\" id=\"listProd\" value=\""+lp+"\">\n" +
                            "                        </td>\n" +
                            "                    </tr>\n" +
                            "                    <tr>\n" +
                            "                        <td>\n" +
                            "                            <img height=\"2\" width=\"140\" alt=\"\" src=\"../img/dd_dropdown_04.png\"/></td>\n" +
                            "                    </tr>\n" +
                            "                </table>\n" +
                            "            </div>";
                    response.getOutputStream().print(returnDiv);
                }
            }  else {
                    response.setContentType("text/html");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("REDIRECT:../error.jsp?ec=1");
                }
        }catch(Exception e){
            response.getOutputStream().print(
                        e.toString() + "" + " Please refresh this Page!_"
                    );
            e.printStackTrace();
        }
    }
}