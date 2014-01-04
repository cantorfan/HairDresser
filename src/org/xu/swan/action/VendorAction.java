package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.bean.Vendor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VendorAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Vendor.ID),"");
        String name = StringUtils.defaultString(request.getParameter(Vendor.NAME),"");
        String address = StringUtils.defaultString(request.getParameter(Vendor.ADDRESS),"");
        String city = StringUtils.defaultString(request.getParameter(Vendor.CITY),"");
        String zip = StringUtils.defaultString(request.getParameter(Vendor.ZIP),"");
        String country = StringUtils.defaultString(request.getParameter(Vendor.COUNTRY),"");
        String phone_number = StringUtils.defaultString(request.getParameter(Vendor.PHONE_NUMBER),"");
        String email_address = StringUtils.defaultString(request.getParameter(Vendor.EMAIL_ADDRESS),"");
        String contact_name = StringUtils.defaultString(request.getParameter(Vendor.CONTACT_NAME),"");
        String ph_num_contact = StringUtils.defaultString(request.getParameter(Vendor.PH_NUM_CONTACT),"");
        String website = StringUtils.defaultString(request.getParameter(Vendor.WEBSITE),"");
        String state = StringUtils.defaultString(request.getParameter(Vendor.STATE),"");


        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            Vendor ven = Vendor.insertVendor(name,address,city,zip,country,phone_number,email_address, contact_name, ph_num_contact, website, state);
            request.setAttribute("MESSAGE",ven!=null?"vendor.added":"vendor.fail");
            request.setAttribute("OBJECT",ven);
            if(ven!=null)
                return mapping.findForward("list");
            else
                return mapping.findForward("add");
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            Vendor ven = Vendor.updateVendor(Integer.parseInt(id),name,address,city,zip,country,phone_number,email_address, contact_name, ph_num_contact, website, state);
            request.setAttribute("MESSAGE",ven!=null?"vendor.edited":"vendor.fail");
            request.setAttribute("OBJECT",ven);
            return mapping.findForward("list");
        }

        return mapping.findForward("default");
    }
}
