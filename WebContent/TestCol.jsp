
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<script type="text/javascript">
var ReadtState_Unitialized=0;
var ReadtState_Loading=1;
var ReadtState_Loaded=2;
var ReadtState_Interactive=3;
var ReadtState_Complete=4;
var HttpStatus_OK=200;
var date="2008/09/02";
function CreateXmlHttpObject()
{
    var XMLHttpObject = null;
    if(window.XMLHttpRequest)
    {
        XMLHttpObject =new XMLHttpRequest();
    }
    else
    {
        try
        {
            XMLHttpObject=new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch(e)
        {
            XMLHttpObject=new ActiveXObject("Msxml2.XMLHTTP");
        }
        
    }
    return XMLHttpObject;
}


function GetColumns()
{
    var xmlHttpObj;
    var location;
    try
    {
        xmlHttpObj=CreateXmlHttpObject();
        
        if(xmlHttpObj)
        {
        
        	var start = new Date();
			var newStartUTC = start.getUTCFullYear() + "/" + (start.getUTCMonth() + 1) + "/" + start.getUTCDate() + " " + start.getUTCHours()+":"+start.getUTCMinutes();
						
            var strUrl='ScheduleServlet?optype=EMPLIST&idlocation=1&calendar='+newStartUTC;
            xmlHttpObj.open("GET", strUrl, true);
           	
           	
           
            xmlHttpObj.onreadystatechange = function()
			{
				if (xmlHttpObj.readyState == ReadtState_Complete) 
				{
					if (xmlHttpObj.status == HttpStatus_OK)
					{						
					
					    var xmlDoc = xmlHttpObj.responseText;
					   	alert(xmlDoc);
					  //CreateColumns(xmlDoc);
					}
				}
			}
			xmlHttpObj.send(null);
			
        }
        else
        {
             alert("Your browser does not support AJAX!");
        }
    }
    catch(e)
    {
        alert(e);
    }
}
function CreateColumns(xmlDoc)
{
     var columns=new Array();
    
    var items = xmlDoc.getElementsByTagName("Employee");
    for( i=0;i<items.length;i++)
    {
       var FullName=items[i].getAttribute("FirstName")+" "+items[i].getAttribute("LastName");
      
      // c.columns[c.length]={"Width":"33","ToolTip":null,"Name":FullName,"InnerHTML":FullName,"Date":"September 1, 2008 00:00:00 +0000","Value":"A","BackColor":"#ECE9D8"};
      columns[i]=
      {"Width":"33","ToolTip":null,"Name":FullName,"InnerHTML":FullName,"Date":"September 1, 2008 00:00:00 +0000","Value":"A","BackColor":"#ECE9D8"};
     
         alert(columns[i]);
      
    }
}
</script>
<body>
<input type="hidden" id="locationId" name="locationId" value="1" />
<button value="Test" onclick="GetColumns()"></button>
</body>
</html>