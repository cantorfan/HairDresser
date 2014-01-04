<div align="center">
<div style="width:647px; height: 237px; background: url(img/rop_bg.png);">
<br />
<table width="580" height="165" border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td colspan="2" align=center>
			<!--img src="img/rop_01.png" width="154" height="57" alt=""-->
            <%=request.getParameter("dt")%>
        </td>
		<td colspan="3">
			<img src="img/rop_02.png" width="401" height="57" alt=""></td>
		<td>
			<a href="#" onclick="Modalbox.hide();"><img src="img/rop_03.png" width="25" height="57" alt="" border="0"></a>
        </td>
	</tr>
	<tr>
		<td colspan="6">
			<img src="img/rop_04.png" width="580" height="30" alt=""></td>
	</tr>
	<tr>
		<td>
			<!--img src="img/rop_05.png" width="33" height="36" alt=""-->
			<input type="radio" class="styled7" name="report" id="print_report" checked="checked"/>
        </td>
		<td colspan="2">
			<img src="img/rop_06.png" width="184" height="36" alt=""></td>
		<td rowspan="2">
			<!--img src="img/rop_07.png" width="175" height="77" alt=""-->
			<!--input type="image" src="img/rop_07.png" /-->
        </td>
		<td colspan="2" rowspan="2">
			<!--img src="img/rop_08.png" width="188" height="77" alt=""-->
			<input type="image" src="img/rop_08.png" onclick="send_report()"/>
        </td>
	</tr>
	<tr>
		<td>
			<!--img src="img/rop_09.png" width="33" height="41" alt=""-->
			<input type="radio" class="styled7" name="report" id="email_report"/>
        </td>
		<td colspan="2">
			<img src="img/rop_10.png" width="184" height="41" alt=""></td>
	</tr>
	<tr>
		<td>
			<img src="img/spacer.gif" width="33" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="121" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="63" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="175" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="163" height="1" alt=""></td>
		<td>
			<img src="img/spacer.gif" width="25" height="1" alt=""></td>
	</tr>
</table>
</div>
</div>
<script>
	Custom7.init();
</script>
