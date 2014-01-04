package org.xu.swan.action;

import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForm;
import org.apache.commons.lang.StringUtils;
import org.xu.swan.util.ActionUtil;
import org.xu.swan.bean.Inventory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.io.PrintWriter;

public class InventoryAction extends org.apache.struts.action.Action {
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws Exception {
        String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION),"");

        String id = StringUtils.defaultString(request.getParameter(Inventory.ID),"");
        String name = StringUtils.defaultString(request.getParameter(Inventory.NAME),"");
        String vendor_id = StringUtils.defaultString(request.getParameter(Inventory.VENDOR),"");
        String brand_id = StringUtils.defaultString(request.getParameter(Inventory.BRAND),"");
        String cost = StringUtils.defaultString(request.getParameter(Inventory.COST),"");
        String sale = StringUtils.defaultString(request.getParameter(Inventory.SALE),"");
        String cate_id = StringUtils.defaultString(request.getParameter(Inventory.CATE),"");
        String tax = StringUtils.defaultString(request.getParameter(Inventory.TAX),"");
        String qty = StringUtils.defaultString(request.getParameter(Inventory.QTY),"");
        String sku = StringUtils.defaultString(request.getParameter(Inventory.SKU),"");
        String upc = StringUtils.defaultString(request.getParameter(Inventory.UPC),"");
        String description = StringUtils.defaultString(request.getParameter(Inventory.DESCRIPTION),"");

        if(action.equalsIgnoreCase(ActionUtil.ACT_ADD)){
            BigDecimal cost_p = BigDecimal.valueOf(Float.parseFloat(cost));
            BigDecimal sale_p = BigDecimal.valueOf(Float.parseFloat(sale));
            BigDecimal taxes = BigDecimal.valueOf(Float.parseFloat(tax));
            Inventory inv = Inventory.insertInventory(name,Integer.parseInt(vendor_id),Integer.parseInt(brand_id),cost_p,sale_p,Integer.parseInt(cate_id),taxes,Integer.parseInt(qty),sku, upc, description);
            request.setAttribute("MESSAGE",inv!=null?"inventory.added":"inventory.fail");
            request.setAttribute("OBJECT",inv);
            if(inv!=null){
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<script type=\"text/JavaScript\">window.location.href='./list_inventory.jsp';alert('1 product has been added.');</script>");
            }
            else{
                return mapping.findForward("add");
            }
        }
        else if(action.equalsIgnoreCase(ActionUtil.ACT_EDIT)){
            BigDecimal cost_p = BigDecimal.valueOf(Float.parseFloat(cost));
            BigDecimal sale_p = BigDecimal.valueOf(Float.parseFloat(sale));
            BigDecimal taxes = BigDecimal.valueOf(Float.parseFloat(tax));
            Inventory inv = Inventory.updateInventory(Integer.parseInt(id),name,Integer.parseInt(vendor_id),Integer.parseInt(brand_id),cost_p,sale_p,Integer.parseInt(cate_id),taxes,Integer.parseInt(qty),sku, upc, description);
            request.setAttribute("MESSAGE",inv!=null?"inventory.edited":"inventory.fail");
            request.setAttribute("OBJECT",inv);
            return mapping.findForward("edit");
        }

        return mapping.findForward("default");
    }
}
