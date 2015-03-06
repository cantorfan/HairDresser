document.write('<div class="pop-container"></div>');

var i18n_resources ={
	zh_CN:{
		enter : "确&nbsp;&nbsp;定", close : "关&nbsp;&nbsp;闭"
	},
	en_US:{
		enter : "Yes", close : "No"
	},
	getI18N: function(language){
		if(!language) return this.en_US;
		return language == "zh_CN" ? this.zh_CN : this.en_US; 
	}
}

var popup = function(){
	if (arguments.length == 0) {
		this.i18n = i18n_resources.getI18N();
	}else
		this.i18n = i18n_resources.getI18N(arguments[0]);
	
	this.windowHeight = jQuery(window).height();
	this.windowWidth = jQuery(window).width();	
	
	this.container = jQuery(".pop-container");
	this.layoutIndex = 0;
	this.pops = [];
	this.tips = [];
}

popup.prototype = {
	init : function(){
		//init
		this.layoutIndex++;
		var className = "pop-instance-"+new Date().getTime();
		var html = "<div class=\""+className+"\"></div>";
		this.container.append(html);
		this.pops.push(className);	
		return className;
	},
	visiableLayout : function(visiable, boxClassName){
		if(visiable){
			var box = jQuery("."+boxClassName);
			var _this = this;
			box.append("<div class=\"pop-layout\"><div class=\"pop-close\"><div>X</div></div></div>");
			box.delegate(".pop-close", "click", function(){
				_this.close(boxClassName);
			});
		}
	},
	setZindex : function(modelBox){
		//set z-index
		var zindex = modelBox.css("z-index");
		modelBox.css("z-index", (parseInt(zindex)+this.layoutIndex));
	},
	setLocation : function(modelBox){
		//this.setLocation();
		var boxheight = modelBox.height()==0 ? 300 : modelBox.height();
		var height = this.windowHeight/2 - boxheight/2;
		height = height < 0 ? 50 : height;
		var width = this.windowWidth/2 - modelBox.width()/2;
		//alert("window height:"+this.windowHeight+"; window width:"+this.windowWidth+"\nbox height:"+modelBox.height()+"; box width:"+modelBox.width());
		height = parseInt(height);
		width = parseInt(width);
		//还要加上滚动条高度
		var scrollheight = parseInt(jQuery(window).scrollTop());//垂直
		var initHeight = (height + scrollheight)*0.8;
		modelBox.css("top", initHeight+"px").css("left", width+"px");
		
		var _this = this;
		//alert("width:"+width+"; height:"+height)
		//注册滚动事件，当滚动条滚动时候，弹窗层也跟着滚动，
		jQuery(window).bind("scroll", function(){ 
			//当滚动条滚动时
			var lazyheight = parseInt(jQuery(window).scrollTop())+height; //垂直
			//alert(lazyheight);
			var lazywidth = parseInt(jQuery(window).scrollLeft())+width; //水平
			//alert(lazyheight+":"+lazywidth);
			modelBox.css("top",lazyheight+"px").css("left",lazywidth+"px");
		});
	},
	
	show : function(box, modelBox){
		//show
		this.setLocation(modelBox);
		box.fadeIn("slow");
	},
	close : function(boxClassName){
		jQuery("."+boxClassName).fadeOut("slow");
		this.pops.pop();
		jQuery("."+boxClassName +" a").undelegate();
		jQuery("."+boxClassName +" input").undelegate();
		if(this.pops.length==0)
			jQuery(window).unbind("scroll");
		jQuery("div").remove("."+boxClassName);
	},
	closeTip : function(){
		if(this.tips.length>0){
			var className = this.tips[0];
			jQuery("."+className).fadeOut("slow");
			if(this.pops.length==0)
				jQuery(window).unbind("scroll");
			jQuery("div").remove("."+className);
			this.tips.splice(0,1)
		}
	}
}

/*
弹一个带有确定按钮的提示信息窗口
args为一个长度为三的数组,
	index 0: 提示信息
	index 1: success/error/warning  (消息的三种类型)
	index 2: function(){			(点击确定时，需要做一些其它事的函数),如果没有传: null
				//do something
			}
	var options = {
		"message": "这个是提示的信息", 					//提示信息
		"type" : "warning", 							//信息类型：分为三种：success/error/warning
		"callback" : function(){alert("show enter");},	//(点击确定时，需要做一些其它事的函数),如果没有传: null
		"visiable" : true								//是不是显示遮罩层: true/false
	};
*/
popup.prototype.enter = function(options){
	this.index ++ ;
	var _this = this;
	
	var boxClassName = this.init();
	
	var box = jQuery("."+boxClassName);
	
	//check params
	if(typeof(options.ec) == 'undefined')
		options["ec"] = false;
	if(typeof(options.visiable) == 'undefined')
		options["visiable"] = true;
	if(typeof(options.type) == 'undefined')
		options["type"] = "warning";
	
	var closeHtml = "";
	if(options.ec == true)
		closeHtml = "			<a class=\"pop-close-btn\" href=\"#this\">"+this.i18n.close+"</a>\n";
	
	this.visiableLayout(options.visiable, boxClassName);
		
	var varhtml = "";
	varhtml+="<div class=\"pop-box\">\n"+
			"	<div class=\"pop-enter\">\n"+
			"		<div class=\"text clearfix\">\n"+
			"			<div class=\"icon clearfix\"></div>\n"+
			"			<div class=\"message clearfix\">"+options.message+"</div>\n"+
			"		</div>\n"+
			"		<ul class=\"pop-hr\"><li class=\"pop-hr-top\"></li><li class=\"pop-hr-bottom\"></li></ul>\n"+
			"		<div class=\"pop-btn-area\">\n"+
			"			<a class=\"pop-enter-btn\" href=\"#this\">"+this.i18n.enter+"</a>\n"+
			closeHtml+
			"		</div>\n"+
			"	</div>\n"+
			"</div>";
	box.append(varhtml);

	iconTypes = {"success" : "-64px 0px", "error" : "-128px 0px", "warning" : "0px 0px"};
	jQuery(".pop-enter div.icon").css("background-position", iconTypes[options.type]);
	
	var modelBox = jQuery("."+boxClassName + " > .pop-box");
	this.setZindex(modelBox);
	this.show(box, modelBox);
	
	box.delegate(".pop-enter-btn", "click", function(){
		if(options.callback != null && typeof(options.callback)=="function")
			options.callback();
		_this.close(boxClassName);
	});
	
	return boxClassName;
}

/*
弹一个带有确定按钮的提示信息窗口
 var options = {
		"message": "这个是提示的信息", 							//提示信息
		"type" : "warning", 									//信息类型：分为三种：success/error/warning
		"callback" : function(){alert("show enter");},			//(点击确定时，需要做一些其它事的函数),如果传：null或者没有传
		"closeCallback" : function(){alert("show close");},		//(点击确定时，需要做一些其它事的函数),如果传：null或者没有传
		"visiable" : false										//是不是显示遮罩层: true/false
	};
*/
popup.prototype.enterAndclose = function(options){
	this.init();
	var _this = this;
	options["ec"] = true;
	var boxClassName = this.enter(options);	
	
	jQuery("."+boxClassName).delegate(".pop-close-btn", "click", function(){
		if(options.closeCallback != null && typeof(options.closeCallback)=="function")
			options.closeCallback();
		_this.close(boxClassName);
	});
}

/*
一种提示信息，显示一段时间后，会自动消失
	var options = {
		"message" : "提交成功",		//要显示的信息
		"type" : "warning",			//信息类型： success/error/warning
		"showLocation" : "bottom",	//显示在屏幕上的位置： top/center/button
		"showTime" : 2000,			//自动消失的时间，以毫秒为单位
		"visiable" : false			//是不是显示遮罩层: true/false
	};
	示例：
	var pop = new popup();
	pop.tip(options);
*/
popup.prototype.tip = function(options){
	var _this = this;
	var boxClassName = this.init();
	//显示遮罩层，如果显示了，则返回一个true, 如果没有显示，则返回一个false
	if(typeof(options.visiable) == 'undefined')
		options["visiable"] = false;
	if(typeof(options.showLocation) == 'undefined')
		options["showLocation"] = "bottom";
	if(typeof(options.showTime) == 'undefined')
		options["showTime"] = 2000;
	
	this.visiableLayout(options.visiable, boxClassName);
	
	var box = jQuery("."+boxClassName);
	box.append("<div class=\"pop-tip\"><div class=\"tip-style\"></div><div class=\"tip-message\">"+options.message+"</div></div>");

	//设置显示信息的类型
	var tip; //= jQuery(".pop-tip");
	this.modelBox = tip = jQuery(".pop-tip");
	var tipStyles = jQuery(".pop-tip .tip-style");
	var styles = {"success" : "-32px 0px", "error" : "-64px 0px", "warning" : "0px 0px"};
	tipStyles.css("background-position", styles[options.type]);
	
	//设置显示位置
	//this.setLocation();
	var locations = {
		"top" 	 : parseInt(_this.windowHeight*0.2),
		"center" : parseInt(_this.windowHeight*0.5),
		"bottom" : parseInt(_this.windowHeight*0.8),
	}
	var pointY = locations[options.showLocation];
	//字体大小为16px,popup.css里面tip-message
	//alert("font-length:"+options.message.length*16+", x:"+((_this.windowWidth-100-16*(options.message.length))/2)+", windowHeight:"+_this.windowHeight+", height:"+mylocation);
	//还要加上滚动条的高度
	var pointX = (_this.windowWidth-100-16*(options.message.length))/2;
	var scrollheight = parseInt(jQuery(window).scrollTop()*0.9);//垂直
	
	tip.css("top",(pointX+scrollheight)+"px").css("left", pointX+"px");
	this.setZindex(jQuery("."+boxClassName+" > .pop-tip"));
	
	box.fadeIn("slow");
	
	//在指定的时间内，关闭
	this.tips.push(boxClassName);
	setTimeout(function(){
		_this.closeTip();
	}, options.showTime);
}

/**
options = {
	title: "Login",
	btn1: {text:"login", function(){
		new popup().enter({message:"this tip message!"});
	}},
	btn2: {text:"cancel"},
	form:[
		{type:"text", label:"username", placeholder:"phone/e-mail/username"},
		{type:"password", label:"password", placeholder:"your password!"}
	]
}

**/
popup.prototype.form = function(options){
	var _this = this;
	var boxClassName = this.init();
	var box = jQuery("."+boxClassName);
	
	//options.visiable
	this.visiableLayout(options.visiable, boxClassName);
		
	var html = "";
	html+="<div class=\"pop-box\">\n";
	html+="	<div class=\"pop-form-box\">\n";
	html+="		<div class=\"pop-form-title\">"+options.title+"</div>\n";
	html+="		<div class=\"pop-form-tip\">"+options.tip+"</div>\n";
	html+="		<ul class=\"pop-form\">\n";

	var inputClasses = [];
	for(var i =0; i<options.form.length; i++){
		var input = options.form[i];
		var className = "pop-input-"+i;
		inputClasses.push(className);
		
		if(input.type=="radio"){
			html+="			<li class=\"pop-form-item\" style=\"padding: 12px 0px; color: #999;\">\n";
			for(var j=0; j<input.value.length; j++){
				html+="				<input style=\"margin-left:20px;\" value=\""+input.value[j]+"\" type=\""+input.type+"\" name=\""+input.name+"\" class=\""+className+" "+input.className+"\"/>"+input.value[j]+"\n";
			}
			html+="			</li>\n";
			
		}else{
			var labelLen = input.label.length;
			console.log("input length:"+labelLen);
			size = 34-((labelLen > 10 ? 10 : labelLen)-3);
			
			var value = "";
			if(input.value)
				value = input.value;

			html+="			<li class=\"pop-form-item\">\n";
			html+="				<span class=\"pop-form-label\" >"+input.label+" :</span>\n";
			html+="				<input type=\""+input.type+"\" value=\""+value+"\" size=\""+size+"\" name=\""+className+"\" class=\""+input.className+" "+className+"\" placeholder=\""+input.placeholder+"\"/>\n";
			html+="			</li>\n";
		}
		
	}
	html+="		</ul>\n";
	html+="		<ul class=\"pop-hr\">\n";
	html+="			<li class=\"pop-hr-top\"></li>\n";
	html+="			<li class=\"pop-hr-bottom\"></li>\n";
	html+="		</ul>\n";
	html+="		<div class=\"pop-btn-area\">\n";
	html+="			<a class=\"pop-enter-btn\" href=\"#this\">"+options.btn1.text+"</a>\n";
	if(options.btn3){
		html+="			<a class=\"pop-other-btn\" href=\"#this\">"+options.btn3.text+"</a>\n";
	}
	html+="			<a class=\"pop-close-btn\" href=\"#this\">"+options.btn2.text+"</a>\n";
	html+="		</div>\n";
	html+="	</div>\n";
	html+="</div>\n";
	
	box.append(html);
	
	//before
	if(options.before != null && typeof(options.before)=="function"){
		options.before();	
	}
	
	if(options.btn3){
		jQuery("."+boxClassName+ " .pop-btn-area a").css("padding", "10px 15px");
		jQuery("."+boxClassName+ " a.pop-other-btn").css("background", "#f7ce4f");
		jQuery("."+boxClassName+ " a.pop-other-btn:hover").css("background", "#f8d465");
	}
	
	var modelBox = jQuery("."+boxClassName + " > .pop-box");
	this.setZindex(modelBox);
	this.show(box, modelBox);
	
	jQuery("."+boxClassName).delegate(".pop-enter-btn", "click", function(){
		if(options.btn1.callback != null && typeof(options.btn1.callback)=="function"){
			options.btn1.callback(inputClasses, function(){
				_this.close(boxClassName);
			});			
		}
	});
	
	jQuery("."+boxClassName).delegate(".pop-close-btn", "click", function(){
		if(options.btn2.callback && typeof(options.btn2.callback)=="function"){
			options.btn2.callback(function(){
				_this.close(boxClassName);
			});			
		}else{
			_this.close(boxClassName);
		}
	});
	
	jQuery("."+boxClassName).delegate(".pop-other-btn", "click", function(){
		if(options.btn3.callback && typeof(options.btn3.callback)=="function"){
			options.btn3.callback(inputClasses, function(){
				_this.close(boxClassName);
			});		
		}
	});
	
}

popup.prototype.loading = function(callback){
	var _this = this;
	var boxClassName = this.init();
	var box = jQuery("."+boxClassName);
	
	box.append("<div class=\"pop-loading\"><div>");
	this.visiableLayout(true, boxClassName);
	
	var modelBox = jQuery("."+boxClassName + " > .pop-loading");
	this.setZindex(modelBox);
	this.show(box, modelBox);
		
	if(callback != null && typeof(callback)=="function"){
		callback(function(){
			_this.close(boxClassName);
		});
	}else{
		setTimeout(function(){_this.close(boxClassName)}, 3000)
	}
}
