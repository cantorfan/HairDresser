package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.*;
import org.xu.swan.bean.Customer;
import org.xu.swan.bean.Employee;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.rowset.serial.SerialBlob;
import javax.imageio.ImageIO;
import java.io.File;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.awt.image.BufferedImage;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CustomerAction  extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession();
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");
        String id = "";
        String fname = "";
        String lname = "";
        String email = "";
        String phone = "";
        String cell = "";
        String type = "";
        String loc_id = "0";
        String work_phone_ext = "";
        String male_female = "";
        String address = "";
        String city = "";
        String state = "";
        String zip_code = "";
        String ext = "";
        String b_date = "";
        String country = "";
        String dt = "";

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
                String name = part.getName();
                if (part.isParam())
                {
                    ParamPart paramPart = (ParamPart) part;
                    String value = paramPart.getStringValue("utf-8");
                    int index = 0;
                    if (paramPart.getName().equals("id"))
                        id = value;
                    if (paramPart.getName().equals("fname"))
                        fname = value;
                    if (paramPart.getName().equals("lname"))
                        lname = value;
                    if (paramPart.getName().equals("email"))
                        email = value;
                    if (paramPart.getName().equals("phone"))
                        phone = value;
                    if (paramPart.getName().equals("cell_phone"))
                        cell = value;
                    if (paramPart.getName().equals("work_phone_ext"))
                        work_phone_ext = value;
                    if (paramPart.getName().equals("male_female"))
                        male_female = value;
                    if (paramPart.getName().equals("address"))
                        address = value;
                    if (paramPart.getName().equals("city"))
                        city = value;
                    if (paramPart.getName().equals("state"))
                        state = value;
                    if (paramPart.getName().equals("zip_code"))
                        zip_code = value;
                    if (paramPart.getName().equals("b_date"))
                        b_date = value;
                    if (paramPart.getName().equals("country"))
                        country = value;
                    if (paramPart.getName().equals("dt"))
                        dt = value;
                    //System.out.println(value);
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

        Boolean req = false;
        if (request.getParameter(Customer.REQ) != null)
            req = true;
        int sex = 0;
        if(male_female.equals("male"))
            sex = 1;
        else if(male_female.equals("female"))
            sex = 2;

        DateFormat formatter ;
        Date dDate ;
        formatter = new SimpleDateFormat("yyyy/MM/dd");
        dDate = b_date.equals("")?null:(Date)formatter.parse(b_date);
        java.sql.Date sqlDate = dDate!=null?new java.sql.Date(dDate.getTime()):null;
        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            Customer cust = Customer.insertCustomer(fname,lname, email,phone, cell, type, Integer.parseInt(loc_id),req, false, 0, "", 0, work_phone_ext, sex, address, city, state, zip_code, blob, sqlDate, Integer.parseInt(country));
            request.setAttribute("MESSAGE",cust!=null?"customer.added":"customer.fail");
            request.setAttribute("OBJECT",cust);
            if(cust!=null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            Customer cust = Customer.updateCustomer(Integer.parseInt(id),fname,lname, email,phone, cell, type, Integer.parseInt(loc_id),req, false, 0, "", 0, work_phone_ext, sex, address, city, state, zip_code, blob, sqlDate, Integer.parseInt(country));
            request.setAttribute("MESSAGE",cust!=null?"customer.edited":"customer.fail");
            request.setAttribute("OBJECT",cust);
            request.setAttribute("id",id);
            request.setAttribute("dt",dt);
            return mapping.findForward("edit");
        }

        return mapping.findForward("default");
    }

    public static String getCurrentDirectory() throws IOException {
        File dir1 = new File(".");
        return dir1.getCanonicalPath();
    }
}
