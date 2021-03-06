/*

CUSTOM FORM ELEMENTS

Created by Ryan Fait
www.ryanfait.com

The only thing you need to change in this file is the following
variables: checkboxHeight, radioHeight2 and selectWidth2.

Replace the first two numbers with the height of the checkbox and
radio button. The actual height of both the checkbox and radio
images should be 4 times the height of these two variables. The
selectWidth2 value should be the width of your select list image.

You may need to adjust your images a bit if there is a slight
vertical movement during the different stages of the button
activation.

Visit http://ryanfait.com/ for more information.

*/

var checkboxHeight4 = "25";
var radioHeight4 = "25";
var selectWidth4 = "177";

/* No need to change anything after this */

document.write('<style type="text/css">input.styled4 { display: none; } select.styled4 { position: relative; width: ' + selectWidth4 + 'px; opacity: 0; filter: alpha(opacity=0); z-index: 5; }</style>');

var Custom4 = {
	init: function() {
		var inputs = document.getElementsByTagName("input"), span = Array(), textnode, option, active;
		for(a = 0; a < inputs.length; a++) {
			if((inputs[a].type == "checkbox" || inputs[a].type == "radio") && inputs[a].className.match(".*styled4.*")) {
				span[a] = document.createElement("span");
				span[a].id = inputs[a].type + inputs[a].id;
				span[a].className = inputs[a].type+"4";

				if(inputs[a].checked == true) {
					if(inputs[a].type == "checkbox") {
						position = "0 -" + (checkboxHeight2*2) + "px";
						span[a].style.backgroundPosition = position;
					} else {
						position = "0 -" + (radioHeight4*2) + "px";
						span[a].style.backgroundPosition = position;
					}
				}
				inputs[a].parentNode.insertBefore(span[a], inputs[a]);
				inputs[a].onchange = Custom4.clear;
				span[a].onmousedown = Custom4.pushed;
				span[a].onmouseup = Custom4.check;
				document.onmouseup = Custom4.clear;
			}
		}
		inputs = document.getElementsByTagName("select");
		for(a = 0; a < inputs.length; a++) {
			if(inputs[a].className.match(".*styled4.*")) {
				option = inputs[a].getElementsByTagName("option");
				active = option[0].childNodes[0].nodeValue;
				textnode = document.createTextNode(active);
				for(b = 0; b < option.length; b++) {
					if(option[b].selected == true) {
						textnode = document.createTextNode(option[b].childNodes[0].nodeValue);
					}
				}
				span[a] = document.createElement("span");
				span[a].className = "select4";
				span[a].id = "select" + inputs[a].name;
                span[a].style.lineHeight = "15px";
				span[a].appendChild(textnode);
				inputs[a].parentNode.insertBefore(span[a], inputs[a]);
				inputs[a].onchange = Custom4.choose;
			}
		}
	},
	pushed: function() {
		element = this.nextSibling;
		if(element.checked == true && element.type == "checkbox") {
			this.style.backgroundPosition = "0 -" + checkboxHeight2*3 + "px";
		} else if(element.checked == true && element.type == "radio") {
			this.style.backgroundPosition = "0 -" + radioHeight4*3 + "px";
		} else if(element.checked != true && element.type == "checkbox") {
			this.style.backgroundPosition = "0 -" + checkboxHeight2 + "px";
		} else {
			this.style.backgroundPosition = "0 -" + radioHeight4 + "px";
		}
	},
	check: function() {
		element = this.nextSibling;
		if(element.checked == true && element.type == "checkbox") {
			this.style.backgroundPosition = "0 0";
			element.checked = false;
		} else {
			if(element.type == "checkbox") {
				this.style.backgroundPosition = "0 -" + checkboxHeight2*2 + "px";
			} else {
				this.style.backgroundPosition = "0 -" + radioHeight4*2 + "px";
				group = this.nextSibling.name;
				inputs = document.getElementsByTagName("input");
				for(a = 0; a < inputs.length; a++) {
					if(inputs[a].name == group && inputs[a] != this.nextSibling) {
						inputs[a].previousSibling.style.backgroundPosition = "0 0";
					}
				}
			}
//			if (edit_REFUND){
//                setREFvalue(element);
//            } else {
                setPIOvalue(element);
//            }
			element.checked = true;
		}
	},
	clear: function() {
		inputs = document.getElementsByTagName("input");
		for(var b = 0; b < inputs.length; b++) {
			if(inputs[b].type == "checkbox" && inputs[b].checked == true && inputs[b].className.match(".*styled4.*")) {
				inputs[b].previousSibling.style.backgroundPosition = "0 -" + checkboxHeight2*2 + "px";
			} else if(inputs[b].type == "checkbox" && inputs[b].className.match(".*styled4.*")) {
				inputs[b].previousSibling.style.backgroundPosition = "0 0";
			} else if(inputs[b].type == "radio" && inputs[b].checked == true && inputs[b].className.match(".*styled4.*")) {
				inputs[b].previousSibling.style.backgroundPosition = "0 -" + radioHeight4*2 + "px";
			} else if(inputs[b].type == "radio" && inputs[b].className.match(".*styled4.*")) {
				inputs[b].previousSibling.style.backgroundPosition = "0 0";
			}
		}
	},
	choose: function() {
		option = this.getElementsByTagName("option");
		for(d = 0; d < option.length; d++) {
			if(option[d].selected == true) {
				document.getElementById("select" + this.name).childNodes[0].nodeValue = option[d].childNodes[0].nodeValue;
			}
		}
	}
}
