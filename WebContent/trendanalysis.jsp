<%@page import="java.util.Arrays"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String diseaseName="Botulism";
int stateId = 0;
if(request.getParameter("sel1") != null){
	stateId = Integer.parseInt(request.getParameter("sel1"));	
}
if(stateId == 0){
	stateId = 1;
}
diseaseName = (String)request.getParameter("disease");
if(diseaseName == null){
	diseaseName = "Botulism";
}
ArrayList yearList = new ArrayList();
ArrayList valuesList = new ArrayList();
%>
<%! public static String toJavascriptArray(String[] arr){ StringBuffer sb = new StringBuffer(); sb.append("["); for(int i=0; i<arr.length; i++){ sb.append("\"").append(arr[i]).append("\""); if(i+1 < arr.length){ sb.append(","); } } sb.append("]"); return sb.toString(); } %>

<%! public static Connection connectToDatabase(){
	Connection connect = null;
	if(connect == null){
		try {
			Class.forName("com.mysql.jdbc.Driver");// loading MySQL driver
			connect = DriverManager.getConnection("jdbc:mysql://cmpe272.cn1huhw7fmgm.us-west-1.rds.amazonaws.com:3306/CMPE272DB?user=root&password=rootcmpe");
			

			//Set up connection with DB, username, password
		} catch (Exception e) {
			System.out.println("Exception in Login::"+e.getMessage());
			e.printStackTrace();
		}
	}
	return connect;
}
%>







<%! public static void consolidateForSingleDisease(String diseaseName, int stateID,ArrayList year, ArrayList sum)
{
	
	Statement stmt = null;
	//String qType = "select sum_for_year,year from statedisease sd,diseases d where sd.diseaseid=d.diseaseid and d.disease='Botulism' and sd.stateid=1;";
	String qType = "select sum_for_year,year from statedisease sd,diseases d where sd.diseaseid=d.diseaseid and d.disease= '" + diseaseName + "' and sd.stateid= "+stateID+";";
	System.out.println(qType);
	Connection conn = null;
	conn = connectToDatabase();
	try {
		stmt = conn.createStatement();
		// Statements allow to issue SQL queries to the database
		ResultSet rs = stmt.executeQuery(qType);
		/* while(rs.next()){
			System.out.println("SUM OF STATE>>>>>>>>>>>>>>>"+rs.getString("sum_for_year"));
			System.out.println("year>>>>>>>>>>>>>>>"+rs.getString("year"));
		} */
		
	//	yearList
	
	
		//System.out.println("Size="+rs.getFetchSize());
		//ResultSet resultset = null;
		//ArrayList<String> arrayList = new ArrayList<String>(); 
		int i = 1;
		while (rs.next()) {
				
			/* year.add(rs.getString("year"));
			sum.add(rs.getString("sum_for_year"));
			 */
			
			year.add(rs.getInt("year"));
			sum.add(rs.getInt("sum_for_year"));
			
			
			System.out.println(sum);
		}
		
		System.out.println(year.get(0));
		
		
	} catch (Exception e) {
		System.out.println("Error in execute query::"+e.getMessage());
		e.printStackTrace();
	}
	finally{
		try{
		stmt.close();
		conn.close();
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
	}
}


%>



<%!
public static String toJavascriptArray(ArrayList arr)
{ 
	StringBuilder sb = new StringBuilder(); 
	sb.append('['); 
	for(int i=0; i<arr.size(); i++){ 
	//	sb.append("'\").append(arr.get(i)).append("\"); 
	sb.append(arr.get(i));
		if(i+1 < arr.size()){ 
			sb.append(","); 
		} 
	} 
	sb.append(']'); 
	return sb.toString(); 
}
%>
<html>
<head>
<meta charset="utf-8">
<title>Travel Health Guide</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">
<link href="inspiritas.css" rel="stylesheet">
<script type='text/javascript' src='//code.jquery.com/jquery-1.9.1.js'></script>
<link rel="stylesheet" type="text/css" href="/css/result-light.css">
<script type='text/javascript'>
	//<![CDATA[ 
       
	 
	           
	           
 $(function() {
		// var weekNoArray = [], retailerNameArray = [ 'a', 'b', 'c','a', 'b', 'c','a', 'b', 'c'], clicksArray = [ 43, 48, 62, 63, 43, 39 ], series = [];
		//var clicksArray = [ 43, 48, 62, 63, 43, 39 ];
		//var clicksArray = [ 1,7,4,4 ];
		var diseaseName="Botulism";
	       <% consolidateForSingleDisease(diseaseName,1,yearList, valuesList); %>
	       
	       
	       //var weekNoArray = yearList,  clicksArray = valueList, series = [];
	       var series = [];
	       
	       var retailerNameArray =[]; 
	       //retailerNameArray = new Array();
	       /* for(i=0;i<yearList.size();i++)
	    	   {
	    	   retailerNameArray[i]=diseaseName;
	    	   } */
	          
	       
	        <%-- <% printSomething(yearList, valuesList); %> --%>
	    
	    
	        //weekNoArray = new Array();
	        var weekNoArray=[];
			weekNoArray = <%= toJavascriptArray(yearList) %>;
			for(var j=0;j<weekNoArray.length;j++)
	    	   {
	    	   retailerNameArray[j]=diseaseName;
	    	   }
			
			
		var clicksArray =[];
			//clicksArray= new Array();
		 clicksArray = <%= toJavascriptArray(valuesList) %>;
		series = generateData(weekNoArray, retailerNameArray, clicksArray);

		
		function generateData(cats, names, points) {
			var ret = {}, ps = [], series = [], len = cats.length;

			//concat to get points
			for (var i = 0; i < len; i++) {
				ps[i] = {
					x : cats[i],
					y : points[i],
					n : names[i]
				};
			}
			names = [];
			//generate series and split points
			for (i = 0; i < len; i++) {
				var p = ps[i], sIndex = $.inArray(p.n, names);

				if (sIndex < 0) {
					sIndex = names.push(p.n) - 1;
					series.push({
						name : p.n,
						data : []
					});
				}
				series[sIndex].data.push(p);
			}
			return series;
		}
		$('#container').highcharts({
	        title: {
	            text: 'Disease Prediction',
	            x: -20 //center
	        },
	        subtitle: {
	            text: 'Date',
	            x: -20
	        },
	        xAxis: {
	            title: {
	                text: 'Year'
	            },
	            plotLines: [{
	                value: 0,
	                width: 1,
	                color: '#808080'
	            }]
	        },
	        yAxis: {
	            title: {
	                text: 'Occurances'
	            },
	            plotLines: [{
	                value: 0,
	                width: 1,
	                color: '#808080'
	            }]
	        },
	        tooltip: {
	            valueSuffix: ''
	        },
	        legend: {
	            layout: 'vertical',
	            align: 'right',
	            verticalAlign: 'middle',
	            borderWidth: 0
	        },
	        series: series
	    } );
	}); 
	           
	//]]>
</script>
</head>
<body>
	<script src="http://code.highcharts.com/highcharts.js"></script>
	<script src="http://code.highcharts.com/modules/exporting.js"></script>
	<div class="navbar navbar-static-top navbar-inverse">
		<div class="navbar-inner">
			<div class="container">
				<a class="btn btn-navbar" data-toggle="collapse"
					data-target=".nav-collapse"> <span class="icon-bar"></span> <span
					class="icon-bar"></span> <span class="icon-bar"></span>
				</a> <a class="brand" href="#">Travel Health Guide</a> <span
					class="tagline">Travel Safe...Travel Healthy !!!</span>

				<div class="nav-collapse collapse" id="main-menu">
					<div class="auth pull-right">
						<span class="name"><a
							href="http://littke.com/2012/11/06/inspiritas-bootstrap-theme-by-ripple.html">Read
								more.</a></span><br />
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container">
		<table>
			<tr>
				<td><div id="container"></div></td>
				<td><div id="container1" align="center" style="top: 0px;"right: 5100px">
					<iframe id="I1" frameborder="0" height="450" name="I1" 
                    src="https://www.google.com/maps/embed/v1/search?q=hospitals+california&amp;key=AIzaSyDcmBdo4yC-eBeKwj2kKA-WsELq48TYCEU" 
                    style="border-style: none; border-color: inherit; border-width: 0; width: 560px; align: center;">
                    </iframe>					</div></td>
			</tr>
		</table>
	</div>
</body>
</html>