package org.xu.swan.action;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.xu.swan.bean.Employee;
import org.xu.swan.bean.WorkingtimeEmp;
import org.xu.swan.util.*;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.rowset.serial.SerialBlob;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;


public class EmployeeAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession();
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), "");
        String id = "";
        String fname = "";
        String lname = "";
        String login = "";
        String s_security = "";
        String email = "";
        String salary = "";
        String comment = "";
        boolean oneday = false;
        String comm = "";
        String loc = "1";
        String sch_val;
        String sch = "";
        String ext = "";
        String fmon = "";
        String tmon = "";
        String ftue = "";
        String ttue = "";
        String fwen = "";
        String twen = "";
        String fthu = "";
        String tthu = "";
        String ffri = "";
        String tfri = "";
        String fsat = "";
        String tsat = "";
        String fsun = "";
        String tsun = "";
        String cmon = "";
        String ctue = "";
        String cwen = "";
        String cthu = "";
        String cfri = "";
        String csat = "";
        String csun = "";
        String male_female = "";
        String description = "";
        String address = "";
        String city = "";
        String postcode = "";
        String homephone = "";
        String cellphone = "";
        String hiredatestr = "";
        String termdatestr = "";
        File dir;
        java.util.Date startMon = null;
        java.util.Date endMon = null;
        java.util.Date startTue = null;
        java.util.Date endTue = null;
        java.util.Date startWen = null;
        java.util.Date endWen = null;
        java.util.Date startThu = null;
        java.util.Date endThu = null;
        java.util.Date startFri = null;
        java.util.Date endFri = null;
        java.util.Date startSat = null;
        java.util.Date endSat = null;
        java.util.Date startSun = null;
        java.util.Date endSun = null;
        String h_from;
        String h_to;
        SerialBlob blob = null;
        char[] buff = new char[7];
        Boolean was_file_received = false;
        String req_content_type = request.getContentType();
        if (req_content_type == null) req_content_type = "";
        if (req_content_type.indexOf("multipart/form-data") != -1) {
            MultipartParser mp = new MultipartParser(request, 10 * 1024 * 1024); // 10MB size limit
            Part part;
            FilePart filePart;
            String contType = "";
            while ((part = mp.readNextPart()) != null) {
                String name = part.getName();
                if (part.isParam()) {
                    ParamPart paramPart = (ParamPart) part;
                    String value = paramPart.getStringValue("utf-8");
                    int index = 0;
                    if (paramPart.getName().equals("fname")) fname = value;
                    if (paramPart.getName().equals("lname")) lname = value;
                    if (paramPart.getName().equals("id")) id = value;
                    if (paramPart.getName().equals("login_id")) login = value;
                    if (paramPart.getName().equals("fmon")) fmon = value;
                    if (paramPart.getName().equals("tmon")) tmon = value;
                    if (paramPart.getName().equals("ftue")) ftue = value;
                    if (paramPart.getName().equals("ttue")) ttue = value;
                    if (paramPart.getName().equals("fwen")) fwen = value;
                    if (paramPart.getName().equals("twen")) twen = value;
                    if (paramPart.getName().equals("fthu")) fthu = value;
                    if (paramPart.getName().equals("tthu")) tthu = value;
                    if (paramPart.getName().equals("ffri")) ffri = value;
                    if (paramPart.getName().equals("tfri")) tfri = value;
                    if (paramPart.getName().equals("fsat")) fsat = value;
                    if (paramPart.getName().equals("tsat")) tsat = value;
                    if (paramPart.getName().equals("fsun")) fsun = value;
                    if (paramPart.getName().equals("tsun")) tsun = value;
                    if (paramPart.getName().equals("cmon")) cmon = value;
                    if (paramPart.getName().equals("ctue")) ctue = value;
                    if (paramPart.getName().equals("cwen")) cwen = value;
                    if (paramPart.getName().equals("cthu")) cthu = value;
                    if (paramPart.getName().equals("cfri")) cfri = value;
                    if (paramPart.getName().equals("csat")) csat = value;
                    if (paramPart.getName().equals("csun")) csun = value;
                    if (paramPart.getName().equals("email")) email = value;
                    if (paramPart.getName().equals("salary")) salary = value;
                    if (paramPart.getName().equals("comment")) comment = value;
                    if (paramPart.getName().equals("male_female")) male_female = value;
                    if (paramPart.getName().equals("description")) description = value;
                    if (paramPart.getName().equals("address")) address = value;
                    if (paramPart.getName().equals("city")) city = value;
                    if (paramPart.getName().equals("postcode")) postcode = value;
                    if (paramPart.getName().equals("homephone")) homephone = value;
                    if (paramPart.getName().equals("cellphone")) cellphone = value;
                    if (paramPart.getName().equals("hiredate")) hiredatestr = value;
                    if (paramPart.getName().equals("termdate")) termdatestr = value;
                    if (paramPart.getName().equals("checkCustomWorkTime")) {
                        if (value.equals("on")){
                            oneday = true;
                        } else {
                            oneday = false;
                        }
                    }

                    if (paramPart.getName().equals("schedule")) {
                        sch_val = value;
                        index = Integer.parseInt(sch_val.substring(sch_val.length() - 1));
                        buff[index] = '1';
                        sch = Employee.safeConvert(new String(buff));
                    }
                    if (paramPart.getName().equals("commission")) comm = value;
                    //System.out.println(value);
                } else if (part.isFile()) {
                    String dirrectory = getCurrentDirectory();
                    filePart = (FilePart) part;
                    dir = new File(dirrectory);
                    dir.mkdirs();
                    dir = new File(dirrectory + session.getId());
                    long size = filePart.writeTo(dir);
                    was_file_received = true;
                    if (size > 0 && filePart.getFileName().lastIndexOf('.') >= 0)
                        ext = filePart.getFileName().substring(filePart.getFileName().lastIndexOf('.') + 1, filePart.getFileName().length());
                    if (size > 0 && was_file_received) {
                        try {
                            BufferedImage pict = ImageIO.read(dir);
                            ByteArrayOutputStream out = new ByteArrayOutputStream();
                            ImageIO.write(pict, ext, out);
                            blob = new SerialBlob(out.toByteArray());
                        } catch (IOException ex) {
                            blob = null;
                        }
                        catch (NullPointerException ex) {
                            blob = null;
                        }
                    }
                }
            }
        }

        int sex = 0;
        if(male_female.equals("male"))
            sex = 1;
        else if(male_female.equals("female"))
            sex = 2;
        BigDecimal com;
        DateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
        Date hire = hiredatestr.equals("")?null:(Date)formatter.parse(hiredatestr);
        Date term = termdatestr.equals("")?null:(Date)formatter.parse(termdatestr);
        java.sql.Date hiredate = hire!=null?new java.sql.Date(hire.getTime()):null;
        java.sql.Date termdate = term!=null?new java.sql.Date(term.getTime()):null;
        if (action.equalsIgnoreCase(ActionUtil.ACT_ADD)) {
            try {
                com = new BigDecimal(Float.parseFloat(comm));
            } catch (java.lang.NumberFormatException ex) {
                com = null;
            }
            try {
                startMon = (new SimpleDateFormat("HH:mm")).parse(fmon);
                endMon = (new SimpleDateFormat("HH:mm")).parse(tmon);
                startTue = (new SimpleDateFormat("HH:mm")).parse(ftue);
                endTue = (new SimpleDateFormat("HH:mm")).parse(ttue);
                startWen = (new SimpleDateFormat("HH:mm")).parse(fwen);
                endWen = (new SimpleDateFormat("HH:mm")).parse(twen);
                startThu = (new SimpleDateFormat("HH:mm")).parse(fthu);
                endThu = (new SimpleDateFormat("HH:mm")).parse(tthu);
                startFri = (new SimpleDateFormat("HH:mm")).parse(ffri);
                endFri = (new SimpleDateFormat("HH:mm")).parse(tfri);
                startSat = (new SimpleDateFormat("HH:mm")).parse(fsat);
                endSat = (new SimpleDateFormat("HH:mm")).parse(tsat);
                startSun = (new SimpleDateFormat("HH:mm")).parse(fsun);
                endSun = (new SimpleDateFormat("HH:mm")).parse(tsun);
            } catch (Exception ex) {
            }

            Employee emp = Employee.insertEmployee(fname, lname, Integer.parseInt(login), sch, com, Integer.parseInt(loc), blob,/*DateUtil.toSqlTime(startTime),DateUtil.toSqlTime(endTime),*/ s_security, email, salary, comment, oneday, sex, description, address, city, postcode, homephone, cellphone, hiredate, termdate);
            WorkingtimeEmp.insertWTEmp(emp.getId(), DateUtil.toSqlTime(startMon), DateUtil.toSqlTime(endMon), 1);
            WorkingtimeEmp.insertWTEmp(emp.getId(), DateUtil.toSqlTime(startTue), DateUtil.toSqlTime(endTue), 2);
            WorkingtimeEmp.insertWTEmp(emp.getId(), DateUtil.toSqlTime(startWen), DateUtil.toSqlTime(endWen), 3);
            WorkingtimeEmp.insertWTEmp(emp.getId(), DateUtil.toSqlTime(startThu), DateUtil.toSqlTime(endThu), 4);
            WorkingtimeEmp.insertWTEmp(emp.getId(), DateUtil.toSqlTime(startFri), DateUtil.toSqlTime(endFri), 5);
            WorkingtimeEmp.insertWTEmp(emp.getId(), DateUtil.toSqlTime(startSat), DateUtil.toSqlTime(endSat), 6);
            WorkingtimeEmp.insertWTEmp(emp.getId(), DateUtil.toSqlTime(startSun), DateUtil.toSqlTime(endSun), 7);
            request.setAttribute("MESSAGE", emp != null ? "employee.added" : "employee.fail");
            request.setAttribute("OBJECT", emp);
            if (emp != null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        } else if (action.equalsIgnoreCase(ActionUtil.ACT_EDIT)) {
            try {
                com = new BigDecimal(Float.parseFloat(comm));
            } catch (java.lang.NumberFormatException ex) {
                com = null;
            }
            try {
                startMon = (new SimpleDateFormat("HH:mm")).parse(fmon);
                endMon = (new SimpleDateFormat("HH:mm")).parse(tmon);
                startTue = (new SimpleDateFormat("HH:mm")).parse(ftue);
                endTue = (new SimpleDateFormat("HH:mm")).parse(ttue);
                startWen = (new SimpleDateFormat("HH:mm")).parse(fwen);
                endWen = (new SimpleDateFormat("HH:mm")).parse(twen);
                startThu = (new SimpleDateFormat("HH:mm")).parse(fthu);
                endThu = (new SimpleDateFormat("HH:mm")).parse(tthu);
                startFri = (new SimpleDateFormat("HH:mm")).parse(ffri);
                endFri = (new SimpleDateFormat("HH:mm")).parse(tfri);
                startSat = (new SimpleDateFormat("HH:mm")).parse(fsat);
                endSat = (new SimpleDateFormat("HH:mm")).parse(tsat);
                startSun = (new SimpleDateFormat("HH:mm")).parse(fsun);
                endSun = (new SimpleDateFormat("HH:mm")).parse(tsun);
            } catch (Exception ex) {
            }
            Employee em = Employee.findById(Integer.parseInt(id));
            if (em.getPicture() != null && blob == null)
                blob = new SerialBlob(em.getPicture());
            Employee emp = Employee.updateEmployee(Integer.parseInt(id), fname, lname, Integer.parseInt(login), sch, com, Integer.parseInt(loc), blob,/*DateUtil.toSqlTime(startTime),DateUtil.toSqlTime(endTime), */s_security, email, salary, comment, oneday, sex, description, address, city, postcode, homephone, cellphone, hiredate, termdate);
            WorkingtimeEmp.updateByEmp_idAndDay(emp.getId(), DateUtil.toSqlTime(startMon), DateUtil.toSqlTime(endMon), 1, cmon);
            WorkingtimeEmp.updateByEmp_idAndDay(emp.getId(), DateUtil.toSqlTime(startTue), DateUtil.toSqlTime(endTue), 2, ctue);
            WorkingtimeEmp.updateByEmp_idAndDay(emp.getId(), DateUtil.toSqlTime(startWen), DateUtil.toSqlTime(endWen), 3, cwen);
            WorkingtimeEmp.updateByEmp_idAndDay(emp.getId(), DateUtil.toSqlTime(startThu), DateUtil.toSqlTime(endThu), 4, cthu);
            WorkingtimeEmp.updateByEmp_idAndDay(emp.getId(), DateUtil.toSqlTime(startFri), DateUtil.toSqlTime(endFri), 5, cfri);
            WorkingtimeEmp.updateByEmp_idAndDay(emp.getId(), DateUtil.toSqlTime(startSat), DateUtil.toSqlTime(endSat), 6, csat);
            WorkingtimeEmp.updateByEmp_idAndDay(emp.getId(), DateUtil.toSqlTime(startSun), DateUtil.toSqlTime(endSun), 7, csun);
//            request.setAttribute("MESSAGE", emp != null ? "employee.edited" : "employee.fail");
            request.setAttribute("OBJECT", emp);
            return mapping.findForward("list");
        }
        return mapping.findForward("default");
    }

    public static String getCurrentDirectory() throws IOException {
        File dir1 = new File(".");
        return dir1.getCanonicalPath();
    }
}
