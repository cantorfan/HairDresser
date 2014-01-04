<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="css/schedule1.css" media="all"/>
	<script language="javascript" type="text/javascript" src="script/schedule.js">
	</script>
</head>
<body>
	<input type="hidden" id="locationId" name="locationId" value="1" />
	<table>
		<tr>
			<!-- is needed to compute the position -->
			<td  id="homeTBL" name="homeTBL">
				<div>
					<table>
						<tr>
							<td >
								First Name</td>
							<td>
								<input type="text" id="txtFirstName" name="txtFirstName" size="15" class="wickEnabled" autocomplete="OFF" />
							</td>
						</tr>
						<tr>
							<td>
								Last Name</td>
							<td>
								<input type="text" id="txtLastName" name="txtLastName" size="15" class="wickEnabled" autocomplete="OFF" /></td>
						</tr>
						<tr>
							<td>
								Phone</td>
							<td>
								<input type="text" id="txtPhone" name="txtPhone" size="15" class="wickEnabled" autocomplete="OFF" /></td>
						</tr>
						<tr>
							<td>
								Cell Phone</td>
							<td>
								<input type="text" id="txtCellPhone" name="txtCellPhone" size="15" class="wickEnabled" autocomplete="OFF" /></td>
						</tr>
						<tr>
							<td>
								Email</td>
							<td>
								<input type="text" id="txtEmail" name="txtEmail" size="15" class="wickEnabled" autocomplete="OFF" /></td>
						</tr>
						<tr>
							<td colspan="2">
								<input id="cust_id" name="cust_id" type="hidden" value="">
								<input type="button" value="Clear" onclick="clearCustomerData();"/>
								&nbsp;&nbsp;
								<input type="button" value="Confirm" onclick="saveCustomer();"/>
							</td>
						</tr>
					</table>
					<!-- to correct the customerDIV positioning update the schedule.js: function fillMatchCollection -->
					<div id="customerDIV" style="position:absolute;z-index:5;">
						<table id="smartInputFloater" class="floater" cellpadding="0" cellspacing="0">
							<tr><td id="smartInputFloaterContent" nowrap="nowrap"></td></tr>
						</table>
					</div>
			</td>
		</tr>
	</table>
</body>
</html>