//.x.m.
function sendcomfrimEmail(appointmentID, idEmployee, idCustomer){
		console.log("Function:sendcomfrimEmail(idEmployee:"+idEmployee+", idCustomer:"+idCustomer+", appointmentID:"+appointmentID+")");
		
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
					title: "Send Email Confirmation",
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
										});
								});	
								
							}
						}
					}},
					btn2: {text:"Cancel"},
					btn3: {text:"More", callback: function(form, close){
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
					}},
					visiable: true
				}
				pop.form(options);
		}
	);
	
}

function sendCheckoutEmail(custoumerId, location, transactionCode, doOther){
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
			
			var pop = new popup;
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
