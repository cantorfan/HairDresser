package org.xu.swan.action;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.bean.Location;
import org.xu.swan.bean.Employee;
import org.xu.swan.bean.WorkingtimeLoc;
import org.xu.swan.util.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.rowset.serial.SerialBlob;
import javax.imageio.ImageIO;
import java.math.BigDecimal;
import java.io.File;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.awt.image.BufferedImage;
import java.text.SimpleDateFormat;
import java.util.TimeZone;


public class LocationAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession();
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), "");
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

        String id = "";
        String name = "";
        String addr = "";
        String city = "";
        String state = "";
        String zip = "";
        String country = "";
        String telephone = "";
        String fax = "";
        String email = "";
        String cur = "";
        String tax = "";
        String facebook = "";
        String twitter = "";
        String blog = "";
        String timezone = "";

        String ext = "";

//        String comment = StringUtils.defaultString(request.getParameter(WorkingtimeLoc.COMMENT),"");
        File dir;
        SerialBlob blob = null;
        Boolean was_file_received = false;
        String req_content_type = request.getContentType();
        if (req_content_type == null) req_content_type = "";
        if (req_content_type.indexOf("multipart/form-data") != -1)
        {
            MultipartParser mp = new MultipartParser(request, 10 * 1024 * 1024); // 10MB size limit
            Part part;
            FilePart filePart;
            String contType = "";
            while ((part = mp.readNextPart()) != null)
            {
                String nameP = part.getName();
                if (part.isParam())
                {
                    ParamPart paramPart = (ParamPart) part;
                    String value = paramPart.getStringValue("utf-8");
                    int index = 0;
                    if (paramPart.getName().equals("idloc"))
                        id = value;
                    if (paramPart.getName().equals("name"))
                        name = value;
                    if (paramPart.getName().equals("address"))
                        addr = value;
                    if (paramPart.getName().equals("currency"))
                        cur = value;
                    if (paramPart.getName().equals("taxes"))
                        tax = value;
                    if (paramPart.getName().equals("fmon"))
                        startMon = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("tmon"))
                        endMon = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("ftue"))
                        startTue = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("ttue"))
                        endTue = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("fwen"))
                        startWen = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("twen"))
                        endWen = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("fthu"))
                        startThu = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("tthu"))
                        endThu = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("ffri"))
                        startFri = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("tfri"))
                        endFri = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("fsat"))
                        startSat = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("tsat"))
                        endSat = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("fsun"))
                        startSun = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("tsun"))
                        endSun = (new SimpleDateFormat("HH:mm")).parse(value);
                    if (paramPart.getName().equals("cmon"))
                        cmon = value;
                    if (paramPart.getName().equals("ctue"))
                        ctue = value;
                    if (paramPart.getName().equals("cwen"))
                        cwen = value;
                    if (paramPart.getName().equals("cthu"))
                        cthu = value;
                    if (paramPart.getName().equals("cfri"))
                        cfri = value;
                    if (paramPart.getName().equals("csat"))
                        csat = value;
                    if (paramPart.getName().equals("csun"))
                        csun = value;
                    if (paramPart.getName().equals("A2city"))
                        city = value;
                    if (paramPart.getName().equals("A2state"))
                        state = value;
                    if (paramPart.getName().equals("A2zip"))
                        zip = value;
                    if (paramPart.getName().equals("A2country"))
                        country = value;
                    if (paramPart.getName().equals("A2telephone"))
                        telephone = value;
                    if (paramPart.getName().equals("A2fax"))
                        fax = value;
                    if (paramPart.getName().equals("A2email"))
                        email = value;
                    if (paramPart.getName().equals("facebook"))
                        facebook = value;
                    if (paramPart.getName().equals("twitter"))
                        twitter = value;
                    if (paramPart.getName().equals("blog"))
                        blog = value;
                    if (paramPart.getName().equals("timezone"))
                        timezone = value;
                }
                else
                    if (part.isFile())
                    {
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
        BigDecimal taxes = new BigDecimal(0);
        if(!tax.equals(""))
            taxes = new BigDecimal(Float.parseFloat(tax));
        if(blob != null && blob.length() == 0)
            blob = null;
//        String addr2 = "city:"+city+";state:"+state+";zip:"+zip+";country:"+country+";telephone:"+telephone+";fax:"+fax+";email:"+email;
        String addr2 = "";
        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){

            Location loc = Location.insertLocation(name,addr,cur,taxes,addr2,blob, timezone);
            WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startMon), DateUtil.toSqlTime(endMon), 1, cmon);
            WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startTue), DateUtil.toSqlTime(endTue), 2, ctue);
            WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startWen), DateUtil.toSqlTime(endWen), 3, cwen);
            WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startThu), DateUtil.toSqlTime(endThu), 4, cthu);
            WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startFri), DateUtil.toSqlTime(endFri), 5, cfri);
            WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startSat), DateUtil.toSqlTime(endSat), 6, csat);
            WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startSun), DateUtil.toSqlTime(endSun), 7, csun);

            request.setAttribute("MESSAGE",loc!=null?"location.added":"location.fail");
            request.setAttribute("OBJECT",loc);
            if(loc!=null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){

            Location loc = Location.updateLocation(Integer.parseInt(id), name,addr,cur,taxes,addr2,blob, country, state, city, zip, telephone, fax, email, facebook, twitter, blog, timezone);
            if (WorkingtimeLoc.updateByLoc_idAndDay(loc.getId(), DateUtil.toSqlTime(startMon), DateUtil.toSqlTime(endMon), 1, cmon) == null)
                WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startMon), DateUtil.toSqlTime(endMon), 1, cmon);
            if (WorkingtimeLoc.updateByLoc_idAndDay(loc.getId(), DateUtil.toSqlTime(startTue), DateUtil.toSqlTime(endTue), 2, ctue) == null)
                WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startTue), DateUtil.toSqlTime(endTue), 2, ctue);
            if (WorkingtimeLoc.updateByLoc_idAndDay(loc.getId(), DateUtil.toSqlTime(startWen), DateUtil.toSqlTime(endWen), 3, cwen) == null)
                WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startWen), DateUtil.toSqlTime(endWen), 3, cwen);
            if (WorkingtimeLoc.updateByLoc_idAndDay(loc.getId(), DateUtil.toSqlTime(startThu), DateUtil.toSqlTime(endThu), 4, cthu) == null)
                WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startThu), DateUtil.toSqlTime(endThu), 4, cthu);
            if (WorkingtimeLoc.updateByLoc_idAndDay(loc.getId(), DateUtil.toSqlTime(startFri), DateUtil.toSqlTime(endFri), 5, cfri) == null)
                WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startFri), DateUtil.toSqlTime(endFri), 5, cfri);
            if (WorkingtimeLoc.updateByLoc_idAndDay(loc.getId(), DateUtil.toSqlTime(startSat), DateUtil.toSqlTime(endSat), 6, csat) == null)
                WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startSat), DateUtil.toSqlTime(endSat), 6, csat);
            if (WorkingtimeLoc.updateByLoc_idAndDay(loc.getId(), DateUtil.toSqlTime(startSun), DateUtil.toSqlTime(endSun), 7, csun) == null)
                WorkingtimeLoc.insertWTLoc(loc.getId(), DateUtil.toSqlTime(startSun), DateUtil.toSqlTime(endSun), 7, csun);
            Location loc2 = Location.findById(1);
            request.setAttribute("MESSAGE",loc!=null?"location.edited":"location.fail");
            request.setAttribute("OBJECT",loc);
            request.getSession(true).removeAttribute("location");
            request.getSession(true).setAttribute("location", loc2);
//            TimeZone asd = TimeZone.getTimeZone(timezone);
//            TimeZone.setDefault(asd);
            return mapping.findForward("list");
        }

        return mapping.findForward("default");
    }
        public static String getCurrentDirectory() throws IOException {
        File dir1 = new File(".");
        return dir1.getCanonicalPath();
    }
}
