<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 	<head>
    	<script language="javascript" type="text/javascript" src="Js/DyveWeb.js"></script>
        <script language="javascript" type="text/javascript" src="Js/Dyve.js"></script>        
        <script language="javascript" type="text/javascript" src="Js/DyveBubble.js"></script>        
        <script language="javascript" type="text/javascript" src="Js/DyveMenu.js"></script>        
        <script language="javascript" type="text/javascript" src="Js/DyveCalendar.js"></script>

    </head>
    <body>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="content" valign="top">
                    <div id="mainCalendar" style="width: 100%; position: relative; line-height: 1;">
                        
                        
                        <div style="border-left: 1px solid rgb(0, 0, 0); border-right: 1px solid rgb(0, 0, 0);">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td><div class="header" unselectable="on" id="left" style="border-top: 1px solid rgb(0, 0, 0); background-color: rgb(236, 233, 216); width: 45px; height: 64px; -moz-user-select: none;"><div style="padding: 2px; text-align: center; font-weight: bold;">&nbsp</div></div></td>
                                    <td style="background-color: rgb(236, 233, 216);" valign="top" width="100%">
                                        <div style="position: relative; height: 1px; line-height: 1px; display: block; font-size: 1px; background-color: rgb(0, 0, 0);" ><!-- --></div>
                                        <table id="mainCalendar_header" style="border-left: 1px solid rgb(0, 0, 0);border-right: 1px solid rgb(0, 0, 0);" border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td></td></tr></table>
                                    </td>
                                    <td><div id="right" class="header" unselectable="on" style="border-top: 1px solid rgb(0, 0, 0); background-color: rgb(236, 233, 216); width: 15px; height: 64px; -moz-user-select: none;"></div></td>
                                </tr>                                
                            </table>
                        </div>
                        
                        
                        <div id="mainCalendar_scroll" style="border: 1px solid rgb(0, 0, 0); overflow: auto; height: 360px; position: relative; background-color: rgb(236, 233, 216);">
                            <div style="padding: 2px; position: absolute; background-color: orange; color: white; font-size: 10px; font-family: Tahoma; display: none;">&nbsp;</div>
                            <table style="" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top">
                                         <table border="0" cellpadding="0" cellspacing="0" width="45">
                                            <tr style="height: 1px; background-color: white;"><td></td></tr>
                                           	<!-- 
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            12<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            1<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            2<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            3<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            4<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            5<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            6<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            7<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            8<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>                                            
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            9<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            -->
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            10<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>                                            
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            11<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;AM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>             
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            12<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>    
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            1<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            2<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            3<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            4<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            5<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            6<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr> 
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            7 <span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr> 
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            8<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>  
                                            <!-- 
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            9<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>  
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            10<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>  
                                            <tr style="height: 80px;">
                                                <td unselectable="on" class="header" style="-moz-user-select: none; background-color: rgb(236, 233, 216); cursor: default;" valign="bottom">
                                                    <div unselectable="on" style="border-bottom: 1px solid rgb(172, 168, 153); display: block;
                                                        height: 39px; text-align: right;">
                                                        <div unselectable="on" style="padding: 2px; font-family: Tahoma; font-size: 16pt; color: rgb(0, 0, 0);">
                                                            11<span style="font-size: 10px; vertical-align: super;" unselectable="on">&nbsp;PM</span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>  
                                            -->       
                                         </table>
                                    </td>                                    
                                    <td valign="top" width="100%">
                                        <table id="mainCalendar_main" style="border-left: 1px solid rgb(0, 0, 0);" border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr id="mainCalendar_events" style="background-color: white;">                                                
                                                <!-- Events -->
                                                    <td dpcolumn="" dpcolumndate="August 24, 2008 00:00:00 +0000" style="height: 1px; text-align: left; width: 14%;">                                                       
                                                           
                                                    </td>                                                                                                       
                                                <!-- End Events -->                                                
                                            </tr>
                                        
                                        </table>
                                    </td>
                                </tr>    
                            </table>
                        </div>
                                
                        
                    </div>
                </td>
            </tr>
        </table>
        <input type="hidden" id="mainCalendar_select" name="mainCalendar_select" value="" />
        
        <div id="mainCalendar_idlocation" ></div>
        <input type="hidden" id="mainCalendar_datecurrent" value="1" />
		          		 
        <div id="mainCalendar_MainMenu" style="border:1px solid #ACA899;background-color:#FFFFFF;font-size:8pt;display:none;">
	        <span style="font-weight:bold;display:block;background-color:#ECE9D8;padding:2px 20px 2px 10px;border-bottom:1px solid #ACA899;cursor:default;">Event</span>
	        <a onclick="var e = this.parentNode.event || this.parentNode.selection; var command = ''; alert('Opening event (id {0})');; return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">Open</a>
	        <a onclick="var e = this.parentNode.event || this.parentNode.selection; var command = ''; alert('Sending event (id {0})');; return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">Send</a>
	        <a onclick="if (this.parentNode.event) { this.parentNode.event.root.eventMenuClick('Delete', this.parentNode.event, 'CallBack'); } else if (this.parentNode.selection) { this.parentNode.selection.root.timeRangeMenuClick('Delete', this.parentNode.selection, 'CallBack'); } return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;border-top:1px solid #ACA899;">Delete (CallBack)</a>
	        <a onclick="if (this.parentNode.event) { this.parentNode.event.root.eventMenuClick('Delete', this.parentNode.event, 'PostBack'); } else if (this.parentNode.selection) { this.parentNode.selection.root.timeRangeMenuClick('Delete', this.parentNode.selection, 'PostBack'); } return false;" href="#" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">Delete (PostBack)</a>
	        <a href="javascript:alert('Going somewhere else (id {0})');" style="padding:2px 20px 2px 10px;display:block;cursor:pointer;color:#2859AB;text-decoration:none;white-space:nowrap;">NavigateUrl test</a>
        </div>
        
        <script type='text/javascript'>
          /*
            var bubble = new DayPilotBubble.Bubble('ctl00_ContentPlaceHolder1_DayPilotBubble1');
            bubble.uniqueID = 'ctl00$ContentPlaceHolder1$DayPilotBubble1';
            bubble.clientObjectName = 'bubble';
            bubble.showLoadingLabel = true;
            bubble.loadingText = 'Loading...';
            bubble.useShadow = true;
            bubble.showAfter = '500';
            bubble.hideAfter = '500';
            bubble.width = '200px';
            bubble.border = '1px solid #000000';
            bubble.backgroundColor = '#FFFFFF';
            */
        </script>

        <script language="javascript" type="text/javascript" >        	                      
            //var menu = new DayPilotMenu.Menu('mainCalendar_MainMenu');
            //menu.border = '1px solid #ACA899';
			
            function mainCalendar_Init() {
                var c = new DayPilotCalendar.Calendar('mainCalendar');
                c.allDayHeaderHeight = 22;
				c.allDayEventHeight = 18;
				c.allowEventOverlap = true;
				c.borderColor = '#000000';
				c.clientName = 'mainCalendar';
				c.cellHeight = 20;
				c.cellsPerHour = 4;
				c.columnMarginRight = 0;
				c.cssClass = '';
				c.deleteUrl = 'Image/btn_delete.gif';
				c.days = 1;
				c.durationBarVisible = true;
				c.durationBarWidth = 5;
				c.durationBarImageUrl = '';
				c.eventBorderColor = '#000000';
				c.eventFontFamily = 'Tahoma';
				c.eventFontSize = '8pt';
				c.eventFontColor = '#000000';
				c.eventSelectColor = 'Blue';
				c.headerFontSize = '10pt';
				c.headerFontFamily = 'Tahoma';
				c.headerFontColor = '#000000';
				c.headerHeight = 21;
				c.headerLevels = 1;
				c.hourHalfBorderColor = '#F3E4B1';
				c.hourBorderColor = '#EAD098';
				c.initScrollPos = '0';
				c.minEnd = 801;
				c.maxStart = 1481;
				c.rtl = false;
				c.selectedColor = '#316AC5';
				c.showToolTip = true;
				c.showAllDayEvents = false;
				c.showHeader = true;
				
				c.startDate = new Date('June 25, 2008 00:00:00 +0000');;
				c.LocationId = '1';
				c.pageNum = '0';
               c.uniqueID = 'DayPilotCalendar1';
				c.useEventBoxes = 'Always';
				c.viewType = 'Days';
				c.visibleStart = 10;
				c.widthUnit = 'Percentage';
				c.afterEventRender = function(e, div) {};
				c.afterRender = function(data) {};
				c.eventClickHandling = 'Disabled';
				c.eventClickCustom = function(e) {alert('Event with id ' + e.value() + ' clicked.')};				
				c.eventDoubleClickHandling = 'Disabled';
				c.eventDoubleClickCustom = function(e) { };				
				c.eventHoverHandling = 'bubble';
				c.eventSelectHandling = 'Disabled';
				c.eventSelectCustom = function(e) {alert('Event selected.')};
				//c.rightClickHandling = 'ContextMenu';
				c.rightClickHandling = 'Disabled';
				c.rightClickCustom = function(e) {alert('Event with id ' + e.value() + ' clicked.')};
				c.headerClickHandling = 'Disabled';
				c.headerClickCustom = function(c) {alert('Header with id ' + c.value + ' clicked.')};
				
				c.eventDeleteHandling = 'JavaScript';				
				c.eventDeleteCustom = function(e) 
				{															
					if (!confirm('Do you really want to delete ' + e.text() + ' ?')) return;								
																		
					var xmlRequest;
					
					var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();
					
				    try {
				        xmlRequest = new XMLHttpRequest();
				    }
				    catch(e) {
				        try {
				            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
				        } catch(e) { }				        
				    }
						
					xmlRequest.onreadystatechange = function() {
						if (xmlRequest.readyState ==4 ) {
                            alert(xmlRequest.responseText);
							//document.getElementById("mainCalendar_idlocation").innerHTML = "c.events = [" + xmlRequest.responseText + "]";
							eval('c.events = [' + xmlRequest.responseText + ']');
							c.drawEvents();
						}	
					};
					xmlRequest.open("POST", "ScheduleManager?optype=DEL&idappointment="+e.div.data.ServerId+ "&idlocation="+c.LocationId+"&dateutc="+dateUtc + "&pagenum=" + c.pageNum);
					xmlRequest.send(null);					
				};
				
				c.eventResizeHandling = 'JavaScript';				
				c.eventResizeCustom = function(e, newStart, newEnd) 
				{ 									
					var xmlRequest;
					
					var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();
					
					var start 	= new Date(newStart)
					var end 	= new Date(newEnd);
						
					var newStartUTC = start.getUTCFullYear() + "/" + (start.getUTCMonth() + 1) + "/" + start.getUTCDate() + " " + start.getUTCHours()+":"+start.getUTCMinutes();
					var newEndUTC 	= end.getUTCFullYear() + "/" + (end.getUTCMonth() + 1) + "/" + end.getUTCDate()+ " " + end.getUTCHours()+":"+end.getUTCMinutes();
													
				    try {
				        xmlRequest = new XMLHttpRequest();
				    }
				    catch(e) {
				        try {
				            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
				        } catch(e) { }				        
				    }
					
					xmlRequest.onreadystatechange = function() {
						if (xmlRequest.readyState ==4 ) {												
							eval("c.events = [" + xmlRequest.responseText + "]");
							c.drawEvents();
						}	
					};
																
					xmlRequest.open("POST", "ScheduleManager?optype=REZ&start="+newStartUTC+"&end="+newEndUTC +"&idappointment="+e.div.data.ServerId+ "&idlocation="+c.LocationId+"&dateutc="+dateUtc + "&pagenum=" + c.pageNum);
					xmlRequest.send(null);					
				};
				
				c.eventMoveHandling = 'JavaScript';				
				c.eventMoveCustom = function(e, newStart, newEnd, oldColumn, newColumn, external) 
				{
					var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();
					
					var start 	= new Date(newStart);
					var end 	= new Date(newEnd);

					var newStartUTC = start.getUTCFullYear() + "/" + (start.getUTCMonth() + 1) + "/" + start.getUTCDate() + " " + start.getUTCHours()+":"+start.getUTCMinutes();
					var newEndUTC 	= end.getUTCFullYear() + "/" + (end.getUTCMonth() + 1) + "/" + end.getUTCDate()+ " " + end.getUTCHours()+":"+end.getUTCMinutes();

					var xmlRequest;
					
				    try {
				        xmlRequest = new XMLHttpRequest();
				    }
				    catch(e) {
				        try {
				            xmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
				        } catch(e) { }				        
				    }
					
					xmlRequest.onreadystatechange = function() {
						if (xmlRequest.readyState ==4 ) {							
							eval("c.events = [" + xmlRequest.responseText + "]");
							c.drawEvents();
						}	
					};
				
					xmlRequest.open("POST", "ScheduleManager?optype=MOV&start="+newStartUTC+"&end="+newEndUTC +"&idappointment="+e.div.data.ServerId+"&idoldemployee="+oldColumn+"&idnewemployee="+newColumn+ "&idlocation=" + c.LocationId + "&dateutc=" + dateUtc + "&pagenum=" + c.pageNum);
					xmlRequest.send(null);											
				};
				
				c.timeRangeSelectedHandling = 'Disabled';
				c.timeRangeSelectedCustom = function(start, end, column) {alert(start.toGMTString() + '\n' + end.toGMTString());};
				c.timeRangeDoubleClickHandling = 'JavaScript';
				c.timeRangeDoubleClickCustom = function(start, end, column) 
				{
					alert(start.toGMTString() + '\n' + end.toGMTString());
				};
				c.eventEditHandling = 'Disabled';
				c.eventEditCustom = function(e, newText) {alert('The text of event ' + e.value() + ' was changed to ' + newText + '.');};
				c.stepMs = 900000;
				c.startMs = 36000000;
				c.endMs = 75600000;
				c.AllowSelecting = true;
				c.callbackError = function(result, context) { alert('An exception was thrown in the server-side event handler:\n\n' + result.substring(result.indexOf('$$$')+3)); };
				c.colors = [
					["#FFF4BC"],
					["#FFF4BC"],
					["#FFF4BC"],
					["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFFFD5"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],["#FFF4BC"],
					["#FFF4BC"]];
				c.eventsAllDay = [];

                c.events = [                                	
					/*
					{
						"ServerId":"wergsj2",
						"BarStart":0,
						"ToolTip":"Event #3 (9:30 AM - 10:00 AM)",
						"PartStart":"June 25, 2008 10:00:00 +0000",
						"Box":true,
						"Left":0,
						"Tag":"",
						"InnerHTML":"Event #3 (9:30 AM - 10:00 AM)",
						"Width":100,
						"ResizeEnabled":true,
						"Start":"June 25, 2008 10:00:00 +0000",
						"RightClickEnabled":true,
						"Value":"3",
						"Height":40,
						"End":"June 25, 2008 11:00:00 +0000",
						"ClickEnabled":true,
						"BarColor":"Blue",
						"BarLength":40,
						"PartEnd":"June 25, 2008 11:00:00 +0000",
						"DeleteEnabled":true,
						"Text":"Event #3",
						"MoveEnabled":true,
						"ContextMenu":null,
						"BackgroundColor":"#FFFFFF",
						"Top":761,
						"DayIndex":0
					}  
					*/
					    	               
                ];
             
                c.columns = [
//                	{"Width":"33","ToolTip":null,"Name":"Meeting Room A","InnerHTML":"Meeting Room A","Date":"September 1, 2008 00:00:00 +0000","Value":"idemployee","BackColor":"#ECE9D8"},
//                	{"Width":"33","ToolTip":null,"Name":"Meeting Room B","InnerHTML":"Meeting Room B","Date":"September 1, 2008 00:00:00 +0000","Value":"B","BackColor":"#ECE9D8"},
//                	{"Width":"33","ToolTip":null,"Name":"Meeting Room C","InnerHTML":"Meeting Room C","Date":"September 1, 2008 00:00:00 +0000","Value":"C","BackColor":"#ECE9D8"}                	
				];     
				
				
				var dateUtc = c.startDate.getUTCFullYear() + "/" + (c.startDate.getUTCMonth() + 1) + "/" + c.startDate.getUTCDate();
				
				var xmlRequestHeader;
					
			    try {
			        xmlRequestHeader = new XMLHttpRequest();
			    }
			    catch(e) {
			        try {
			            xmlRequestHeader = new ActiveXObject("Microsoft.XMLHTTP");
			        } catch(e) { }				        
			    }
				
				xmlRequestHeader.onreadystatechange = function() {
					if (xmlRequestHeader.readyState ==4 ) {													
						eval("c.columns = [" + xmlRequestHeader.responseText + "]");
						
						//document.getElementById('mainCalendar_main').width = '2000px';
						
						//if (c.columns.length>4) {
							//var mainCalendarHeaderObject 	= document.getElementById('mainCalendar_header');
							//var mainCalendarMainObject 		= document.getElementById('mainCalendar_main')	;
							/*
							var widthMax 	= c.columns.length * 100;
							widthMax 		= widthMax + 'px';
							
							mainCalendarHeaderObject.style.width 	= widthMax;
							mainCalendarMainObject.style.width 		= widthMax;
							mainCalendarHeaderObject.width 			= widthMax;
							mainCalendarMainObject.width 			= widthMax;
							*/
							//alert(mainCalendarHeaderObject.width); 
						//}
						
						//alert(c.columns.length);
						
						c.Init();						
					}
				};
					
				xmlRequestHeader.open("POST", 'ScheduleServlet?optype=EMPLIST&idlocation=' + c.LocationId + '&calendar=' + dateUtc + '&pageNum=' + c.pageNum);
				xmlRequestHeader.send(null);
										
				var xmlRequestEvents;
					
			    try {
			        xmlRequestEvents = new XMLHttpRequest();
			    }
			    catch(e) {
			        try {
			            xmlRequestEvents = new ActiveXObject("Microsoft.XMLHTTP");
			        } catch(e) { }				        
			    }
				
				xmlRequestEvents.onreadystatechange = function() {
					if (xmlRequestEvents.readyState ==4 ) {													
						eval("c.events = [" + xmlRequestEvents.responseText + "]");
						c.drawEvents();						
					}
				};
					
				xmlRequestEvents.open("POST", "ScheduleManager?optype=ALL&idlocation=" + c.LocationId + "&dateutc=" + dateUtc + '&pageNum=' + c.pageNum);
				xmlRequestEvents.send(null);
                c.Init();				                         
                return c;
            }
            
            var originalOnload = window.onload;
            var mainCalendar = null;
            
            if (typeof(Sys) != 'undefined' && Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance && Sys.WebForms.PageRequestManager.getInstance().get_isInAsyncPostBack()) {
                mainCalendar = mainCalendar_Init();
            } else {
                window.onload = function() {
                    mainCalendar = mainCalendar_Init();
                    if (originalOnload) originalOnload();
                };
            }
        </script>
        
    </body>
</html>