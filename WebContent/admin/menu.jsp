<tr>
    <td colspan="2">

         <div <%--id="header"--%>>
            <!-- begin navigation -->
            <ul id="menu">
                <li class="m">
                    <a href="./admin.jsp">Dashboard</a>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_location.jsp">Locations</a>
                    <ul class="dd">
                        <%--<li><a href="./edit_location.jsp">Add location</a></li>--%>
                        <li><a href="./list_location.jsp">Manage locations</a></li>

                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_customer.jsp">Customers</a>
                    <ul class="dd">
                        <li><a href="./edit_customer.jsp?action=add">Add customer</a></li>
                        <li><a href="./list_customer.jsp">Manage customers</a></li>

                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_employee.jsp">Employees</a>
                    <ul class="dd">
                        <li><a href="./edit_employee.jsp?action=add">Add employee</a></li>
                        <li><a href="./list_employee.jsp">Manage employees</a></li>
                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_category.jsp">Categories</a>
                    <ul class="dd">
                        <li><a href="./edit_category.jsp?action=add">Add category</a></li>
                        <li><a href="./list_category.jsp">Manage categories</a></li>

                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_service.jsp">Services</a>
                    <ul class="dd">
                        <li><a href="./edit_service.jsp?action=add">Add service</a></li>
                        <li><a href="./list_service.jsp">Manage services</a></li>

                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_appointment.jsp">Appointments</a>
                    <ul class="dd">
                        <%--<li><a href="./edit_appointment.jsp?action=add">Add appointment</a></li>--%>
                        <li><a href="./list_appointment.jsp">Manage appointments</a></li>
                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_inventory.jsp">Product</a>
                    <ul class="dd">
                        <li><a href="./edit_inventory.jsp?action=add">Add product</a></li>
                        <li><a href="./list_inventory.jsp">Manage products</a></li>
                        <li><a href="./edit_vendor.jsp?action=add">Add vendor</a></li>
                        <li><a href="./list_vendor.jsp">Manage vendor</a></li>
                        <li><a href="./edit_brand.jsp?action=add">Add brand</a></li>
                        <li><a href="./list_brand.jsp">Manage brand</a></li>
                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="#">Giftcard</a>
                    <ul class="dd">
                        <li><a href="./list_giftcard.jsp">View giftcard</a></li>
                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="#">Accounting</a>
                    <ul class="dd">
                        <li><a href="./list_cashio.jsp">Manage cash in/out</a></li>
                        <li><a href="./list_closingday.jsp">Closing day view</a></li>
                        <li><a href="./list_transaction.jsp">Transactions</a></li>
                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_user.jsp">Users</a>
                    <ul class="dd">
                        <li><a href="./edit_user.jsp?action=add">Add user</a></li>
                        <li><a href="./list_user.jsp">Manage users</a></li>
                        <li><a href="./loginConfig.do">Manage IP</a></li>
                        <li><a href="./LoginEmpConfig.jsp">Manage Emp Access</a></li>

                    </ul>
                </li>
                <li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">
                    <a href="./list_emailtemplate.jsp">Email Template</a>
                    <ul class="dd">
                        <li><a href="./edit_emailtemplate.jsp?action=add">Add Template</a></li>
                        <li><a href="./list_emailtemplate.jsp">Manage Templates</a></li>

                    </ul>
                </li>
                <%--<li class="m">--%>
                    <%--<a href="./audittrail.jsp?tb=<%=Transaction.TABLE%>">Audit trail</a>--%>
                <%--</li>--%>
                <%--<li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">--%>
                    <%--<a href="./list_empserv.jsp">Employee Svc</a>--%>
                    <%--<ul class="dd">--%>
                        <%--<li><a href="./edit_empserv.jsp?action=add">Add employee svc</a></li>--%>
                        <%--<li><a href="./list_empserv.jsp">Manage employee svc</a></li>--%>
                    <%--</ul>--%>
                <%--</li>--%>
                <%--<li class="m" onmouseover="Menu.Show(this)" onmouseout="Menu.Hide(this)">--%>
                    <%--<a href="#">Reports</a>--%>
                    <%--<ul class="dd">--%>
                        <%--<li><a href="../report?query=employee">Employees</a></li>--%>
                        <%--<li><a href="../report?query=customer">Customers</a></li>--%>
                        <%--<li><a href="./appointments_report.jsp">Appointments</a></li>--%>
                        <%--<li><a href="./salaries_and_statistic.jsp">Salaries and statistic</a></li>--%>
                        <%--<li><a href="./edit_cashio.jsp?action=add">Add cash in/out</a></li>--%>
                        <%--<li><a href="./list_invoice.jsp">Gross sales</a></li>--%>
                        <%--//<li><a href="#">Inventory</a></li>--%>
                        <%--//<li><a href="#">Transactions</a></li>--%>
                        <%--//<li><a href="#">Cash in/out</a></li>--%>
                    <%--</ul>--%>
                <%--</li>--%>
                <%--<li class="m"/><li class="m"/><li class="m"/><li class="m"/><li class="m"/><li class="m"/><li class="m"/>--%>
                <%--<li class="m">--%>
                    <%--<a href="../index.jsp">Sign Out</a>--%>
                <%--</li>--%>
            </ul>
            <!-- end navigation -->
        </div>
    </td>
</tr>