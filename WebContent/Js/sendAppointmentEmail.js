//.x.m.
function sendcomfrimEmail(idEmployee, idCustomer){
		console.log("Function:sendcomfrimEmail(idEmployee:"+idEmployee+", idCustomer:"+idCustomer+")");
		
		jQuery.get("customerData", {"getCustomer": idCustomer, "timestamp" : new Date().getTime()}, 
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
												pop.tip({message:"success","visiable" : false, "type": "success", "showLocation" : "center",});
											}else{
												pop.tip({message:response.responseText,"visiable" : false, "type": "error", "showLocation" : "center",});
											}
											close();
										});
								});	
								
							}
						}
					}},
					btn2: {text:"Cancel"},
					visiable: true
				}
				pop.form(options);
		}
	);
	
}