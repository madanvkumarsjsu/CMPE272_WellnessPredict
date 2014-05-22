<%@page import="java.util.Arrays"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
ArrayList arrPlot = new ArrayList();
arrPlot.add(10);
arrPlot.add(20);
arrPlot.add(30);
arrPlot.add(40);
arrPlot.add(50);
arrPlot.add(60);
arrPlot.add(70);
arrPlot.add(80);
arrPlot.add(90);
int arrPlotSize = arrPlot.size();
ArrayList yearList = new ArrayList();
ArrayList valuesList = new ArrayList();
ArrayList stateList = new ArrayList();
ArrayList stateIDList = new ArrayList();

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







<%! public static void consolidateForSingleDisease(String diseaseName,ArrayList year, ArrayList sum,ArrayList stateName,ArrayList stateID)
{
	
	Statement stmt;
	//String qType = "select sum_for_year,year from statedisease sd,diseases d where sd.diseaseid=d.diseaseid and d.disease='Botulism' and sd.stateid=1;";
	//select sum_for_year,year , s.states   from statedisease sd,diseases d , states as s where sd.diseaseid=d.diseaseid and d.disease='Campylobacter' and sd.stateid = s.stateid  ;
	String qType = "select sum_for_year,year , s.states, sd.stateid from statedisease sd,diseases d , states as s where sd.diseaseid=d.diseaseid and d.disease='"+ diseaseName+ "' and sd.stateid = s.stateid";
	System.out.println(qType);
	Connection conn = connectToDatabase();
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
			stateName.add(rs.getString("states"));
			stateID.add(rs.getInt("stateid"));
			
			
		}
		
		System.out.println(year);
		System.out.println(sum);
		System.out.println(stateName);
		System.out.println(stateID);
		
	} catch (Exception e) {
		System.out.println("Error in execute query::"+e.getMessage());
		e.printStackTrace();
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
	System.out.println(sb.toString());
	return sb.toString(); 
}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>High Plot</title>
<script type='text/javascript' src='//code.jquery.com/jquery-1.9.1.js'></script>
<link rel="stylesheet" type="text/css" href="/css/result-light.css">
<style type='text/css'>
</style>
<script type='text/javascript'>
	//<![CDATA[ 
       
	 
	           
	           
 $(function() {
		// var weekNoArray = [], retailerNameArray = [ 'a', 'b', 'c','a', 'b', 'c','a', 'b', 'c'], clicksArray = [ 43, 48, 62, 63, 43, 39 ], series = [];
		//var clicksArray = [ 43, 48, 62, 63, 43, 39 ];
		//var clicksArray = [ 1,7,4,4 ];
		//var diseaseName="Campylobacter";
		//alert("dsdsd");
		
	    <%--    <% consolidateForSingleDisease("Campylobacter",yearList, valuesList,stateList,stateIDList); %> --%>
	    	       <% consolidateForSingleDisease("Mumps",yearList, valuesList,stateList,stateIDList); %>
	       var series = [];
	       
	      
	    
	        //weekNoArray = new Array();
	        var weekNoArray=[];
        // weekNoArray= new Array();
			weekNoArray = <%= toJavascriptArray(yearList) %>;	    
			alert(weekNoArray);

			
			var clicksArray =[];
			//clicksArray= new Array();
		 clicksArray = <%= toJavascriptArray(valuesList) %>;
		 alert(clicksArray);
			
				
			
			var retailerNameArray=[]; 
	    	   retailerNameArray = <%= toJavascriptArray(stateIDList) %>;
				alert(retailerNameArray);  
	    	   
				
				
		
			
		
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
	            text: 'Disease Trend For all states',
	            x: -20 //center
	        },
	        subtitle: {
	            text: 'Year',
	            x: -20
	        },
	        yAxis: {
	            title: {
	                text: 'Occurance Count'
	            },
	            plotLines: [{
	                value: 0,
	                width: 1,
	                color: '#808080'
	            }]
	        },
	        tooltip: {
	            valueSuffix: '°C'
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

	<div id="container"
		style="min-width: 310px; height: 400px; margin: 0 auto"></div>


</body>
</html>