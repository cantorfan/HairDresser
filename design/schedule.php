<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link type="text/css" rel="stylesheet" href="css/default.css">
<style>
</style>

<link rel="stylesheet" type="text/css" media="all" href="./jscalendar/calendar-hd.css" title="hd" />
<script type="text/javascript" src="./jscalendar/calendar.js"></script>
<script type="text/javascript" src="./jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="./jscalendar/calendar-setup.js"></script>

</head>
<body>
<table border=0 cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan="3" height="100">
			<!--page header-->
			page header
		</td>
	</tr>
	<tr>
		<td colspan="3" id="page_separator">
			<!--separator-->
			separator
		</td>
	</tr>
</table>
<table border=0 cellspacing="0" cellpadding="0" align=center>
	<tr>
		<td width="200" valign=top style="padding: 5px" align=center>		
			<!--left column-->
			Address<br />
			Phone<br />
			<br />
			<div id="calendar-container">
			<script type="text/javascript">
				function dateChanged(calendar) {
					//  In order to determine if a date was clicked you can use the dateClicked property of the calendar:
				    if (calendar.dateClicked) {
				        // OK, a date was clicked, redirect to /yyyy/mm/dd/index.php
				        var y = calendar.date.getFullYear();
				        var m = calendar.date.getMonth(); // integer, 0..11
				        var d = calendar.date.getDate(); // integer, 1..31
				        // redirect...
				        //window.location = "./schedule.jsp?dt=" + y + "/" + (1 + m) + "/" + d;
				    }
				};
				Calendar.setup(
				    {
				        date : "01/01/01",//"<%=dt%>",
				        flat : "calendar-container", // ID of the parent element
				        showOthers: true, 
				        flatCallback : dateChanged // our callback function
				    }
				);
			</script>
			</div>
			<br />
			<!--form-->
			<table class="form">
				<tr>
					<th valign="center"><img width="51" height="14" src="./img/form_first_name.png" /></th>
					<td>
						<input type="text" class="input_text"/>
					</td>
				</tr>
				<tr>
					<th><img width="51" height="14" src="./img/form_last_name.png" /></th>
					<td>
						<input type="text" class="input_text"/>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 6px;"><img width="51" height="14" src="./img/form_phone.png" /></th>
					<td>
						<input type="text" class="input_text"/>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_cell_phone.png" /></th>
					<td>
						<input type="text" class="input_text"/>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_email.png" /></th>
					<td>
						<input type="text" class="input_text"/>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_request.png" /></th>
					<td align=left>
						<script>
						<!--
							// custom checkbox attributes
							var check_id = "check";
							var is_checked = false;
							
							// custom checkbox code
							var default_css_class = "input_checkbox";
							var default_input_value = "";
							if(is_checked){
								default_css_class = "input_checkbox_checked";
								default_input_value = " checked=\"checked\" ";
							}
							document.write('<div class="'+default_css_class+'" onclick="javascript:getElementById(\''+check_id+'\').checked = !getElementById(\''+check_id+'\').checked; if(!getElementById(\''+check_id+'\').checked) this.className=\'input_checkbox\'; else this.className=\'input_checkbox_checked\';">');
							document.write('<input '+ default_input_value+' style="display:none" type="checkbox" name="'+check_id+'" id="'+check_id+'" />');
							document.write('</div>');
						-->
						</script>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_comment.png" /></th>
					<td>
						<textarea class="input_textarea" scroll=none></textarea>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 0px;"><img width="51" height="28" src="./img/form_customer_comment.png" /></th>
					<td>
						<textarea class="input_textarea" scroll=none></textarea>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_reminder.png" /></th>
					<td align=left>
						<script>
						<!--
							// custom checkbox attributes
							var check_id = "check";
							var is_checked = false;
							
							// custom checkbox code
							var default_css_class = "input_checkbox";
							var default_input_value = "";
							if(is_checked){
								default_css_class = "input_checkbox_checked";
								default_input_value = " checked=\"checked\" ";
							}
							document.write('<div class="'+default_css_class+'" onclick="javascript:getElementById(\''+check_id+'\').checked = !getElementById(\''+check_id+'\').checked; if(!getElementById(\''+check_id+'\').checked) this.className=\'input_checkbox\'; else this.className=\'input_checkbox_checked\';">');
							document.write('<input '+ default_input_value+' style="display:none" type="checkbox" name="'+check_id+'" id="'+check_id+'" />');
							document.write('</div>');
						-->
						</script>
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: 0px;"><img width="51" height="14" src="./img/form_days.png" /></th>
					<td>
						<input type="text" class="input_text"/>
					</td>
				</tr>
				<tr>
					<td colspan=2 align=center>
						<input type="image" src="img/button_fast_appointment.png" width="87" height="25"/>
						<input type="image" src="img/button_history.png" width="86" height="26"/>
					</td>
				</tr>
				<tr>
					<td colspan=2>
						<input type="image" src="img/button_clear.png" width="55" height="26"/>
						<input type="image" src="img/button_insert.png" width="55" height="26"/>
						<input type="image" src="img/button_update.png" width="55" height="26"/>
					</td>
				</tr>
			</table>
			<!--end of form-->
			<img src="img/legend.png" width="173" height="169" />
		</td>
		<td id="schedule_column">
			<!--center column-->
			<table width="785" cellspacing="0" cellpadding="0">
				<!--schedule header-->
				<tr id="schedule_header_control">
					<td id="left_arrow_control"><img src="img/schedule_left_arrow.png" /></td>
					<!--names control-->
					<?for($i = 0; $i < 8; $i++){?>
						<td class="names_control">
							<img src="img/names_frame.png" class="frame" />
							<img src="img/photo.png" class="photo" />
							<div class="name">linda</div>
						</td>
					<?}?>
					<!-- end of names control-->
					<td id="right_arrow_control"><img src="img/schedule_right_arrow.png" /></td>
				</tr>
				<!--schedule comments-->
				<tr id="schedule_comments_control">
					<td class="header_left">
						comments
					</td>
					<?for($i = 0; $i < 8; $i++){?>
						<td>&nbsp;</td>
					<?}?>
					<td class="header_right">
						comments
					</td>
				</tr>
				<!--end of schedule comments-->
				<!--time table-->
				<tr class="time_table1">
					<td rowspan=44 class="time_column">
					<?
						echo "<div class=time_row_first><img src=\"img/time_column/10.png\" /></div>";
						for($i = 10.5; $i<21; $i += 0.5){
							echo "<div class=time_row><img src=\"img/time_column/{$i}.png\" /></div>";
						}
					?>
					</td>
					<?for($i = 0; $i < 8; $i++){?>
					<td id="<?echo "time_row_0_{$i}";?>">&nbsp;</td>
					<?}?>
					<td rowspan=44  class="time_column"><?
						echo "<div class=time_row_first><img src=\"img/time_column/10.png\" /></div>";
						for($i = 10.5; $i<21; $i += 0.5){
							echo "<div class=time_row><img src=\"img/time_column/{$i}.png\" /></div>";
						}
					?></td>
				</tr>
				<?for($i = 0; $i < 43; $i++){?>
				<tr class="time_table<?echo $i%2;?>">
					<?for($j = 0; $j < 8; $j++){?>
					<td id="<?echo "time_row_{$j}_{$i}";?>">&nbsp;</td>
					<?}?>
				</tr>
				<!--end of time table-->
				<?}?>
				<!--schedule footer-->
				<tr id="schedule_footer_control">
					<td class="footer_left"><img src="img/schedule_footer_left_arrow.png" /></td>
					<?for($i = 0; $i < 8; $i++){?>
						<td>linda</td>
					<?}?>
					<td class="footer_right"><img src="img/schedule_footer_right_arrow.png" /></td>
				</tr>
				<!--end of schedule footer-->
				
			</table>
		</td>
		<td width="200" valign=top style="padding-left: 10px; padding-top: 5px; padding-right: 10px;">
			<!--right column-->
			<!--business hours-->
			<span class="business_hours">business hours</span>
			<table cellspacing="0" cellpadding=0 width="100%" class="business_hours">
				<tr>
					<th>mon.</th>
					<th>tues.</th>
					<th>wed.</th>
					<th>thurs.</th>
					<th>friday</th>
					<th>sat.</th>
					<th>sun.</th>
				</tr>
				<tr>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
				</tr>
				<tr>
					<th>to</th>
					<th>to</th>
					<th>to</th>
					<th>to</th>
					<th>to</th>
					<th>to</th>
					<th>to</th>
				</tr>
				<tr>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
					<td><input type="text" class="business_hours_input" maxlength="3"/></td>
				</tr>
			</table>
			<!--end of business hours-->
			<!-- works -->
			<table cellspacing="0" cellpadding="0" class="services">
				<tr>
					<th>cutting men</th>
				</tr>
				<tr>
					<td>
						<div class="services_unit">
							<div class="name">A/S/D</div>
							<div class="cost"><sup>$</sup>35</div>
						</div>
						<div class="services_unit">
							<div class="name">A/S/D</div>
							<div class="cost"><sup>$</sup>35</div>
						</div>
						<div class="services_unit">
							<div class="name">A/S/D</div>
							<div class="cost"><sup>$</sup>35</div>
						</div>
					</td>
				</tr>
			</table>	
			<!-- end of works -->			
		</td>
	</tr>
</table>
</body>
</html>
