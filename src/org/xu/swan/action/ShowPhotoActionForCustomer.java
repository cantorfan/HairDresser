package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ByteArray;
import org.xu.swan.bean.Customer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Blob;


public class ShowPhotoActionForCustomer extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String id = StringUtils.defaultString(request.getParameter(Customer.ID),"");
        int idCustomer = -1;
        try {
			idCustomer = Integer.parseInt(id);
		}catch(Exception ex){}
        Customer cust = Customer.findById(idCustomer);
        Blob blob = null;
        byte[] imageContent = null;
        try{
            blob = cust.getPicture();
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
}

