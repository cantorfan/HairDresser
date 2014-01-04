package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.util.ByteArray;
import org.xu.swan.util.FilePart;
import org.xu.swan.bean.Employee;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.rowset.serial.SerialBlob;
import javax.sql.rowset.serial.SerialException;
import javax.imageio.ImageIO;
import java.sql.Blob;
import java.sql.SQLException;
import java.awt.image.BufferedImage;
import java.awt.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.File;
import java.io.ByteArrayOutputStream;


public class ShowPhotoAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
//        HttpSession session = request.getSession();
        String id = StringUtils.defaultString(request.getParameter(Employee.ID),"");
        int idEmployee = -1;
        try {
			idEmployee = Integer.parseInt(id);
		}catch(Exception ex){}
        Employee emp = Employee.findById(idEmployee);
        Blob blob = null;
        byte[] imageContent = null;
        try{
            if (emp != null){
                if (emp.getPicture()!=null && emp.getPicture().length()!=0){
                    blob = emp.getPicture();
                } else {
                    blob = getDefaultImage(emp.getMale_female());
                }
            }
        }catch (Exception ex){}
        try {
           imageContent = ByteArray.toByteArray(blob);
        } catch (NullPointerException ex){}
        try {
            response.setContentType("image/jpg");
            response.getOutputStream().write(imageContent);
        } catch (NullPointerException e){}
        return null;
    }

    private Blob getDefaultImage(int sex) throws Exception{
        String ext = "jpg";
        SerialBlob blob = null;
        String dirrectory = "";
        if (sex == 1){
            dirrectory = "/org/xu/images/male.jpg";
        } else if (sex == 2){
            dirrectory = "/org/xu/images/female.jpg";
        } else {
            dirrectory = "/org/xu/images/noimage.jpg";
        }
        InputStream is = getClass().getResourceAsStream(dirrectory);

//        File dir = new File(dirrectory);
//        dir.mkdirs();
        try {
            BufferedImage pict = ImageIO.read(is);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            ImageIO.write(pict, ext, out);
            blob = new SerialBlob(out.toByteArray());
        } catch (IOException ex) {
            blob = null;
        }
        catch (NullPointerException ex) {
            blob = null;
        }
        return blob;
    }

    public static String getCurrDir() throws IOException {
        File dir1 = new File(".");
        return dir1.getCanonicalPath();
    }

}
