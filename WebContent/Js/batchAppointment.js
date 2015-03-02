/**
 * 
 */

var batchAppointment = function(){
	var pop = new popup();
	this.batchOfWeekly = function(hiddenWin2, appID){
		var endtime = jQuery("#endAppointmentTime").val();
		if(!endtime)
			pop.enter({message:"END APP TIME not null!","visiable" : true, "type": "warning"});
		else{
			jQuery.get("batchAppointment", {"action": "weekly", "endTime": endtime, "appointmentID": appID, "timestamp" : new Date().getTime()}, 
				function(data, textStatus, response){
					var jsonData = jQuery.parseJSON(response.responseText);
					if(jsonData.status){
						pop.tip({message: jsonData.message, "visiable" : false, "type": "success", "showLocation" : "center"});
						sendMail(jsonData.customerId, jsonData.batchId, hiddenWin2);
					}else{
						pop.tip({message: jsonData.message, "visiable" : false, "type": "error", "showLocation" : "center"});
					}
				});
		}
	};
	
	this.batchOfMonthly = function(hiddenWin2, appID){
		var endtime = jQuery("#endAppointmentTime").val();
		if(!endtime)
			pop.enter({message:"END APP TIME not null!","visiable" : true, "type": "warning"});
		else{
			jQuery.get("batchAppointment", {"action": "monthly", "endTime": endtime, "appointmentID": appID, "timestamp" : new Date().getTime()}, 
				function(data, textStatus, response){
					var jsonData = jQuery.parseJSON(response.responseText);
					if(jsonData.status){
						pop.tip({message: jsonData.message, "visiable" : false, "type": "success", "showLocation" : "center"});
						sendMail(jsonData.customerId, jsonData.batchId, hiddenWin2);
					}else{
						pop.tip({message: jsonData.message, "visiable" : false, "type": "error", "showLocation" : "center"});
					}
				});
		}
	};
	
	this.remove=  function(hiddenWin2, appID){
		jQuery.get("batchAppointment", {"action": "remove", "appointmentID": appID, "timestamp" : new Date().getTime()}, 
			function(data, textStatus, response){
				var jsonData = jQuery.parseJSON(response.responseText);
				if(jsonData.status){
					pop.tip({message: jsonData.message, "visiable" : false, "type": "success", "showLocation" : "center"});
					hiddenWin2();
				}else{
					pop.tip({message: jsonData.message, "visiable" : false, "type": "error", "showLocation" : "center"});
				}
			});
	}
	
	var sendMail = function(customerId, batchId, hiddenWin2){
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
							var emailVal = jQuery("."+form[0]).val();
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
											hiddenWin2();
										});
								});	
							}
						}
					}},
					btn2: {text:"Cancel", callback: function(closePop){
						closePop();
					}},
					visiable: true
				}
				pop.form(options);
			}
		);
	}
	
} 
