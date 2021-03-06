//.x.m.
function sendcomfrimEmail(appointmentID, idEmployee, idCustomer, isLater){
		console.log("Function:sendcomfrimEmail(idEmployee:"+idEmployee+", idCustomer:"+idCustomer+", appointmentID:"+appointmentID+", isLater:"+isLater+")");
		
		jQuery.get("customerData", {"getCustomer": idCustomer, "timestamp" : new Date().getTime()}, 
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
									jQuery.get("ScheduleManager", {"optype": "send_email_comfirmation", "employeeId":idEmployee, "customerId":idCustomer, "email":emailVal, "timestamp" : new Date().getTime()}, 
										function(data, textStatus, response){
											closeloading();
											if(response.responseText =='true'){
												pop.tip({message:"success","visiable" : false, "type": "success", "showLocation" : "center"});
											}else{
												pop.tip({message:response.responseText,"visiable" : false, "type": "error", "showLocation" : "center"});
											}
											close();
											clearCustomerData(); //CustomerControl.js
										});
								});	
								
							}
						}
					}},
					btn2: {text:"Cancel", callback: function(close){
						jQuery.get("ScheduleManager",{"optype": "can_not_send_mail", "appointment_id":appointmentID, "timestamp" : new Date().getTime()},
								function(data, status, response){
									if(response.responseText =='true'){
										pop.tip({message:"success","visiable" : false, "type": "success", "showLocation" : "center"});
									}else{
										pop.tip({message:response.responseText,"visiable" : false, "type": "error", "showLocation" : "center"});
									}
									close();
								}
							);
					}},
					visiable: true
				}
				
				if(isLater){
					options.btn3 = {text:"More", callback: function(form, close){
						jQuery.get("ScheduleManager",{"optype": "do_later_send_mail", "appointment_id":appointmentID, "timestamp" : new Date().getTime()},
							function(data, status, response){
								if(response.responseText =='true'){
									pop.tip({message:"success","visiable" : false, "type": "success", "showLocation" : "center"});
								}else{
									pop.tip({message:response.responseText,"visiable" : false, "type": "error", "showLocation" : "center"});
								}
								close();
							}
						);
					}}
				}
				pop.form(options);
		}
	);
	
}

//.x.m.
/*
var pop = new popup();
jQuery.get("ScheduleManager", {"optype": "canceled_send_email", "appointmentID" : app_id, "timestamp" : new Date().getTime()}, 
	function(data, textStatus, response){
			pop.tip({message:response.responseText, "visiable" : false, "type": "warning", "showLocation" : "buttom"});
		});
*/
function resendConfirmEmail(appID, hidden){
	jQuery.get("customerData", {"getCustomerByAppID": appID, "timestamp" : new Date().getTime()}, 
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
								jQuery.get("ScheduleManager", {"optype": "resend_confirm_email", "appointmentID" : appID, "email": email, "timestamp" : new Date().getTime()}, 
									function(data, textStatus, response){
										pop.tip({message:response.responseText, "visiable" : false, "type": "warning", "showLocation" : "buttom"});
										closeloading();
										hidden();
										close();
									});
							});	
							
						}
					}
				}},
				btn2: {text:"Cancel", callback: 
					function(close){
						close();
					}
				},
				visiable: true
			}
			pop.form(options);
		}
	);
}

function deleteAppintmentSendMail(appID){
	jQuery.get("customerData", {"getCustomerByAppID": appID, "timestamp" : new Date().getTime()}, 
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
				title: "Delete Appointment Send Email",
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
								jQuery.get("ScheduleManager", {"optype": "delete_send_mail", "appointmentID" : appID, "email": email, "timestamp" : new Date().getTime()}, 
									function(data, textStatus, response){
										pop.tip({message:response.responseText, "visiable" : false, "type": "warning", "showLocation" : "buttom"});
										closeloading();
										close();
									});
							});	
							
						}
					}
				}},
				btn2: {text:"Cancel", callback: 
					function(close){
						close();
					}
				},
				visiable: true
			}
			pop.form(options);
		}
	);
}


function sendCheckoutEmail(customerId, location, transactionCode, isprint, doOther){
	console.log("Function:sendCheckoutEmail(customer id:"+customerId+", transactionCode:"+transactionCode+", location:"+location+", isprint:"+isprint+")");
	
	if(isprint){
		if(doOther)
			doOther();
		return;
	}
	
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
				title: "Send Check Out e-mail",
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
								jQuery.get("chkqry", {"action": "send_checkout_email", "location":location, "transactionCode":transactionCode, "customerId":custoumerId, "email":emailVal, "timestamp" : new Date().getTime()}, 
									function(data, textStatus, response){
										closeloading();
										pop.tip({message:response.responseText,"visiable" : false, "type": "warning", "showLocation" : "buttom"});
										close();
										
										setTimeout(function(){
											doOther();
										}, 1500);
										
									});
							});	
						}
					}
				}},
				btn2: {text:"Cancel", callback: function(closePop){
					doOther();
					closePop();
				}},
				visiable: true
			}
			pop.form(options);
		}
	);
	
}

function sendInvoiceEmail(custoumerId, location, transactionCode){
	console.log("Function:sendCheckoutEmail(customer id:"+custoumerId+", transactionCode:"+transactionCode+", location:"+location+")");
	
	jQuery.get("customerData", {"getCustomer": custoumerId, "timestamp" : new Date().getTime()}, 
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
				title: "Send Check Out e-mail",
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
								jQuery.get("chkqry", {"action": "send_checkout_email", "location":location, "transactionCode":transactionCode, "customerId":custoumerId, "email":emailVal, "timestamp" : new Date().getTime()}, 
									function(data, textStatus, response){
										closeloading();
										pop.tip({message:response.responseText,"visiable" : false, "type": "warning", "showLocation" : "buttom"});
										close();
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



