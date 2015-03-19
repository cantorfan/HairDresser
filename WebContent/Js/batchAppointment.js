/**
 * 
 */

var batchAppointment = function(appID){
	var pop = new popup();
	
	jQuery.get("batchAppointment", {"action": "batch_type", "appointmentID": appID, "timestamp" : new Date().getTime()}, 
		function(data, textStatus, response){
			var jsonData = jQuery.parseJSON(response.responseText);
			
			var date = new Date();
			var from = (date.getMonth()+1)+"/"+date.getDate()+"/"+date.getFullYear();
			
			if(jsonData.status){
				
				var batchType = jsonData.batchType;
				var batchOptions = {
					title: "Standing Appointment",
					tip: "select a item & date not null",
					visiable: true,
					form:[
					    {type:"radio",name: "standing_app_item", className:"standing_app_item", "value": ["Weekly", "Monthly", "Remove"]},
						//{type:"text", label:"from", placeholder:"from date time", className:"standing_app_from tcal"},
						{type:"text", label:"to", placeholder:"to date time", className:"standing_app_to tcal"}
					],
					btn1: {text:"Approve", callback : function(form, close){
						//pop.enter({message:"this tip message!","visiable" : true});
						if(form.length>0){
							var select = jQuery('input:radio[name="standing_app_item"]:checked').val();
							//var from = jQuery(".standing_app_from").val();
							var to = jQuery(".standing_app_to").val();
							if(!select){
								pop.enter({message:"please select a item!","visiable" : true, "type": "warning"});
							}else if(select=="Remove"){
								remove(close);
							//}else if(!from){
							//	pop.enter({message:"from is null","visiable" : true, "type": "warning"});
							}else if(!to){
								pop.enter({message:"to is null","visiable" : true, "type": "warning"});
							}else {
								if(select=="Weekly"){
									batchOfWeekly(close, from, to);
								}else if(select=="Monthly"){
									batchOfMonthly(close, from, to);
								}else if(select=="Remove"){
									remove(close);
								}
							}
						}
					}},
					btn2: {text:"Cancel", callback: function(closePop){
						closePop();
					}},
					before : function(){
						if(jsonData.batchType){
							jQuery('input:radio[value="Weekly"]').attr("disabled", "disabled");
							jQuery('input:radio[value="Monthly"]').attr("disabled", "disabled");
						}else{
							jQuery('input:radio[value="Remove"]').attr("disabled", "disabled");
						}
						
						jQuery("input:radio").live("change", function(){
							jQuery(".standing_app_to").val("");
						});
						
					}
				}
				pop.form(batchOptions);
				f_tcalCancel();
				f_tcalInit();
					
			}else{
				pop.tip({message: jsonData.message, "visiable" : false, "type": "error", "showLocation" : "center"});
			}
		}
	);
	
	var batchOfWeekly = function(closePop, from, to){
		jQuery.get("batchAppointment", {"action": "weekly","fromTime": from, "toTime": to, "appointmentID": appID, "timestamp" : new Date().getTime()}, 
			function(data, textStatus, response){
				var jsonData = jQuery.parseJSON(response.responseText);
				if(jsonData.status){
					pop.tip({message: jsonData.message, "visiable" : false, "type": "success", "showLocation" : "center"});
					sendMail(jsonData.customerId, jsonData.batchId);
					closePop();;
				}else{
					pop.tip({message: jsonData.message, "visiable" : false, "type": "error", "showLocation" : "center"});
				}
			});
	};
	
	var batchOfMonthly = function(closePop, from, to){
		jQuery.get("batchAppointment", {"action": "monthly", "fromTime": from, "toTime": to,  "appointmentID": appID, "timestamp" : new Date().getTime()}, 
			function(data, textStatus, response){
				var jsonData = jQuery.parseJSON(response.responseText);
				if(jsonData.status){
					pop.tip({message: jsonData.message, "visiable" : false, "type": "success", "showLocation" : "center"});
					sendMail(jsonData.customerId, jsonData.batchId);
					closePop();
				}else{
					pop.tip({message: jsonData.message, "visiable" : false, "type": "error", "showLocation" : "center"});
				}
			}
		);
	};
	
	var remove=  function(closePop){
		jQuery.get("batchAppointment", {"action": "remove", "appointmentID": appID, "timestamp" : new Date().getTime()}, 
			function(data, textStatus, response){
				var jsonData = jQuery.parseJSON(response.responseText);
				if(jsonData.status){
					pop.tip({message: jsonData.message, "visiable" : false, "type": "success", "showLocation" : "center"});
				}else{
					pop.tip({message: jsonData.message, "visiable" : false, "type": "error", "showLocation" : "center"});
				}
				closePop();
			}
		);
	}
	
	var sendMail = function(customerId, batchId){
		jQuery.get("customerData", {"getCustomer": customerId, "timestamp" : new Date().getTime()}, 
			function(data, textStatus, response){
			
				console.log(response.responseText);
				var customer = null;
				customer = jQuery.parseJSON(response.responseText);
				
				var email = null;
				if(customer){
					email = customer.email;
				}
				
				var pop = new popup();
				options = {
					title: "Send Email Confirmation To: "+customer.fname+" "+customer.lname,
					tip: "please check the e-mail address!",
					form:[
						{type:"text", label:"E-mail", value: email, placeholder:"e-amil address", className:"emailInput"}
					],
					btn1: {text:"Send", callback : function(form, close){
						//pop.enter({message:"this tip message!","visiable" : true});
											
						if(form.length>0){
							var emailVal = jQuery(".emailInput").val();
							if(emailVal.length==0){
								pop.enter({message:"please enter the e-mail address!","visiable" : true, "type": "warning"});
							}else{
								pop.loading(function(closeloading){
									jQuery.get("batchAppointment", {"action": "send_batch_appointment_email", "customerId":customerId, "batchId":batchId, "email":emailVal, "timestamp" : new Date().getTime()}, 
										function(data, textStatus, response){
											var jsonResult = jQuery.parseJSON(response.responseText);
										
											closeloading();
											pop.tip({message:jsonResult.message,"visiable" : false, "type": "warning", "showLocation" : "buttom"});
											close();
										});
								});	
							}
						}
					}},
					btn2: {text:"Cancel", callback: function(close){
						close();
					}},
					visiable: true
				}
				pop.form(options);
			}
		);
	}
	
} 
