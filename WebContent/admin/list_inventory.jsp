<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.xu.swan.util.ActionUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.xu.swan.bean.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user_ses = (User) session.getAttribute("user");
    if (user_ses == null){
        response.sendRedirect("../error.jsp?ec=1");
        return;
    }
    if (user_ses.getPermission() != Role.R_ADMIN){
        response.sendRedirect("../error.jsp?ec=2");
        return;
    }
    String action = StringUtils.defaultString(request.getParameter(ActionUtil.ACTION), ActionUtil.EMPTY);
    String id = StringUtils.defaultString(request.getParameter(Inventory.ID), ActionUtil.EMPTY);
    String prod_name = StringUtils.defaultString(request.getParameter("prod_name"), "");
    String cost = StringUtils.defaultString(request.getParameter("cost"), "");
    String retail = StringUtils.defaultString(request.getParameter("retail"), "");
    String taxe = StringUtils.defaultString(request.getParameter("taxe"), "");
    String qty = StringUtils.defaultString(request.getParameter("qty"), "");
    String sku = StringUtils.defaultString(request.getParameter("sku"), "");
    String barcodes = StringUtils.defaultString(request.getParameter("barcodes"), "");

    if (action.equalsIgnoreCase(ActionUtil.ACT_DEL)) {
        Inventory.deleteInventory(Integer.parseInt(id));
    }

    String pg = StringUtils.defaultString(request.getParameter(ActionUtil.PAGE), "0");
    int pg_num = 0;
    int offset = 0;
    if(StringUtils.isNumeric(pg)){
        pg_num = Integer.parseInt(pg);
        offset = ActionUtil.PAGE_ITEMS * pg_num;
    }
//    ArrayList list = Inventory.findAll(offset,ActionUtil.PAGE_ITEMS);

//    int count = Inventory.countAll();
    String cost_price = cost.equals("") ? "" : (Inventory.COST + " = '" +  cost + "' AND ");
    String sale_price = retail.equals("") ? "" : (Inventory.SALE + " = '" +  retail + "' AND ");
    String taxes = taxe.equals("") ? "" : (Inventory.TAX + " = '" +  taxe + "' AND ");
    String quant = qty.equals("") ? "" : (Inventory.QTY + " = '" +  qty + "' AND ");
    String filter =
                    "name LIKE '%" + prod_name + "%' AND " +
                    cost_price +
                    sale_price +
                    taxes +
                    quant +
                    "sku LIKE '%" + sku + "%' AND " +
                    "upc LIKE '%" + barcodes + "%' " ;
    ArrayList list = Inventory.findByFilter(" WHERE " + filter + "LIMIT " + offset + ", " + ActionUtil.PAGE_ITEMS);
    int count = Inventory.countByFilter(" WHERE " + filter);


    HashMap categories = Category.findAllMap();
    HashMap vendors = Vendor.findAllMap();
    HashMap brands = Brand.findAllMap();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Manage Inventory</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
        <LINK href="../css/style.css" type=text/css rel=stylesheet>
		<script type="text/JavaScript">
    <!--
        // navigation controller
    var Menu = { }

    Menu.Show = function(li)
    {
     li.className += " show";
    }

    Menu.Hide = function(li)
    {
     li.className = li.className.replace(" show", "");
    }

    function MM_swapImgRestore() { //v3.0
        var i,x,a = document.MM_sr;
        for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
    }

    function MM_preloadImages() { //v3.0
        var d = document;
        if (d.images) {
            if (!d.MM_p) d.MM_p = new Array();
            var i,j = d.MM_p.length,a = MM_preloadImages.arguments;
            for (i = 0; i < a.length; i++)
                if (a[i].indexOf("#") != 0) {
                    d.MM_p[j] = new Image;
                    d.MM_p[j++].src = a[i];
                }
        }
    }

    function MM_findObj(n, d) { //v4.01
        var p,i,x;
        if (!d) d = document;
        if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
            d = parent.frames[n.substring(p + 1)].document;
            n = n.substring(0, p);
        }
        if (!(x = d[n]) && d.all) x = d.all[n];
        for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
        if (!x && d.getElementById) x = d.getElementById(n);
        return x;
    }

    function MM_swapImage() { //v3.0
        var i,j = 0,x,a = MM_swapImage.arguments;
        document.MM_sr = new Array;
        for (i = 0; i < (a.length - 2); i += 3)
            if ((x = MM_findObj(a[i])) != null) {
                document.MM_sr[j++] = x;
                if (!x.oSrc) x.oSrc = x.src;
                x.src = a[i + 2];
            }
    }
    function ExportToExel()
    {
        window.location.href="../exporttoexcel?action=exporttoexcelinventory";
    }
    //-->
		</script>
	</head>
	<body onload="MM_preloadImages('../images/ADMIN red.gif','../images/home red.gif','../images/checkout red.gif','../images/schedule red.gif')">
		<table width="1040" border="0" cellpadding="0" cellspacing="0" bgcolor="#000000">
			<tr valign="top">
                <%
                    String activePage = "Admin";
                    String rootPath = "../";
                %>
                <%@ include file="../top_page.jsp" %>
			</tr>
			<tr>
				<td height="47" background="../images/ADMIN_03.gif" colspan="3">
                     <%@ include file="../menu_main.jsp" %>
				</td>
			</tr>
            <%@ include file="menu.jsp"%>
		</table>
		<table width="1040" height="432" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="vertical-align:top">
            <div id="container">
                <img class="rightcorner" src="../images/page_right.jpg" alt="">
                <img class="leftcorner" src="../images/page_left.jpg" alt="">
                <div class="padder">
                    <!-- main content begins here -->
                    <div class="heading">
                        <h1>Manage Inventory <a>(<%=count%> records)</a></h1>
                    </div>
                    <table class="data">
                    <tr>
                        <th class="name" style="text-align:center;" title="Product name">Product Name</th>
                        <th class="vendor" style="text-align:center;" title="Vendor">Vendor</th>
                        <th class="vendor" style="text-align:center;" title="Vendor">Product Brand</th>
                        <th class="money" style="text-align:center;" title="Cost price">Cost of goods</th>
                        <th class="money" style="text-align:center;" title="Retail price">Retail Price</th>
                        <th class="category" style="text-align:center;" title="Category">Category</th>
                        <th class="money" style="text-align:center;" title="Tax amount">Taxes</th>
                        <th class="quantity" style="text-align:center;" title="Quantity">Quantity</th>
                        <th class="sku" style="text-align:center;" title="SKU">SKU</th>
                        <th class="sku" style="text-align:center;" title="UPC">Bar code</th>
                        <th style="width:80px;">
                            <table  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <a href="#"><IMG onclick="ExportToExel();" height="32" alt="Export to Excel" title="Export to Excel" src="../img/exporttoexcel.png" width="32" longDesc="../img/exporttoexcel.png"></a>
                                    </td>
                                    <td style="padding-top: 12px;">
                                        Export
                                    </td>
                                </tr>
                            </table>

                        </th>
                    </tr>
                        <form action="./list_inventory.jsp" method="post" name="inv_form" id="inv_form">
                            <TR class="filter">
                                <TD style="width:150px;">
                                    <input style="width:140px;" type="text" id="prod_name" name="prod_name" value="<%=prod_name%>"/>
                                </TD>
                                <TD style="width:100px;">
                                </TD>
                                <TD style="width:100px;">
                                </TD>
                                <TD style="width:50px;">
                                    <input style="width:40px;" type="text" id="cost" name="cost" value="<%=cost%>"/>
                                </TD>
                                <TD style="width:50px;">
                                    <input style="width:40px;" type="text" id="retail" name="retail" value="<%=retail%>"/>
                                </TD>
                                <TD style="width:90px;">
                                </TD>
                                <TD style="width:50px;">
                                    <input style="width:40px;" type="text" id="taxe" name="taxe" value="<%=taxe%>"/>
                                </TD>
                                <TD style="width:50px;">
                                    <input style="width:40px;" type="text" id="qty" name="qty" value="<%=qty%>"/>
                                </TD>
                                <TD style="width:80px;">
                                    <input style="width:70px;" type="text" id="sku" name="sku" value="<%=sku%>"/>
                                </TD>
                                <TD style="width:80px;">
                                    <input style="width:70px;" type="text" id="barcodes" name="barcodes" value="<%=barcodes%>"/>
                                </TD>
                                <td class="submit">
                                    <input class="button_small" type="submit" value="Search" />
                                </td>
                            </TR>
                        </form>
                    <%for(int i=0; i<list.size(); i++){
                        Inventory inv = (Inventory)list.get(i);%>
                    <TR <%if(i%2 != 0) out.print("class=\"alt\"");%>>
                        <TD>
                            <%=inv.getName()%>
                        </TD>
                        <TD>
                            <%=vendors.get(String.valueOf(inv.getVendor()))%>
                        </TD>
                        <TD>
                            <%=brands.get(String.valueOf(inv.getBrand()))%>
                        </TD>
                        <TD>
                            <%=inv.getCost_price().setScale(2, BigDecimal.ROUND_HALF_DOWN)%>
                        </TD>
                        <TD>
                            <%=inv.getSale_price().setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                        </TD>
                        <TD>
                            <%=categories.get(String.valueOf(inv.getCategory_id()))%>
                        </TD>
                        <TD>
                            <%=inv.getTaxes().setScale(2,BigDecimal.ROUND_HALF_DOWN)%>
                        </TD>
                        <TD>
                            <%=inv.getQty()%>
                        </TD>
                        <TD>
                            <%=inv.getSku()%>
                        </TD>
                        <TD>
                            <%=inv.getUpc()%>
                        </TD>
                        <TD>
                            <%--<a href="./edit_inventory.jsp?action=add"><IMG height="16" alt="Add" src="../images/add.png" width="16" longDesc="../images/add.png"></a>--%>
                            <a href="./edit_inventory.jsp?action=edit&id=<%=inv.getId()%>"><IMG height="16" title="Edit" alt="Edit" src="../images/edit.png" width="16" longDesc="../images/edit.png"></a>
                            <a href="#" onclick="if (confirm('Are you sure to delete?')) window.location.href = './list_inventory.jsp?action=delete&id=<%=inv.getId()%>&<%=ActionUtil.PAGE%>=<%=pg_num%>'"><IMG title="Delete" height="16" alt="Delete" src="../images/delete.png" width="16" longDesc="../images/delete.png"></a>
                        </TD>
                    </TR><%}%>
                    </table>
                     <%if(list.size() >= ActionUtil.PAGE_ITEMS){%>
                     <table>
                     <tr><td><a href="./list_inventory.jsp?<%=ActionUtil.PAGE%>=<%=pg_num + 1%>">Next &gt;&gt;</a></td></tr>
                     </table>
                     <%}%>
                </div>
            </div>
            </td>
			</tr>
            <%@ include file="../copyright.jsp" %>
		</table>
	</body>
</html>