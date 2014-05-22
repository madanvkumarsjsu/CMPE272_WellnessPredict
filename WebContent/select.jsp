<!DOCTYPE html >
<%@page import="com.proj.pojo.State"%>
<%@page import="com.proj.util.Util"%>
<%@page import="com.proj.pojo.Disease"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%
Util utilObj = new Util();
ArrayList<State> alStates = new ArrayList<State>();
alStates = utilObj.getStates();
if (alStates == null) {
	alStates = new ArrayList<State>();
}
int stateId = Integer.parseInt(request.getParameter("sel1"));
//****
if(stateId == 0){
	stateId = 1;
} 
String stateNameChosen = "";
for(int j=0;j<alStates.size();j++)
{
	if ((alStates.get(j)).getiStateId()==stateId)
		stateNameChosen = (alStates.get(j)).getStrStateName();
		
}

String[] monthsSmall={"january","february","march","april","may","june","july","august","september","october","november","december"};

String[] monthsCapital={"January","February","March","April","May","June","July","August","September","October","November","December"};



System.out.println(monthsSmall[9]);
System.out.println(monthsCapital[11]);

System.out.println(stateNameChosen);
//******
String strMonth = (String)request.getParameter("sel");
System.out.println(stateId+" "+strMonth);
if(strMonth == null){
	strMonth = "january";
}
String firstLetterCap = Character.toUpperCase(strMonth.charAt(0)) + strMonth.substring(1);
System.out.println("cap"+firstLetterCap);
int monthNum=0 ;

int[] monthNumber={1,2,3,4,5,6,7,8,9,10,11,12};

for(int k=0;k<monthsSmall.length;k++)
{
	if((monthsSmall[k]).equals(strMonth))
		monthNum = monthNumber[k];
}

System.out.println("Chosen month is :"+ monthNum);

ArrayList diseaseList = new ArrayList();
ArrayList diseaseCountList = new ArrayList();
String month = strMonth;
int stateid= stateId;

%>
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
<%! public static void consolidateForSingleDisease(String month, int stateID,ArrayList disName, ArrayList disCount,int monthNumber,boolean criticality)
{
	Statement stmt = null;
	String monthSmall= month;
	String qType = "";	
	if(criticality)
		qType = "select "+month+" as month,d.disease from diseases as d,statedisease as sd where sd.diseaseid in (select distinct diseaseid from Disease_criticality as dc where dc.mnth = "+ monthNumber+ " and dc.stateid= " + stateID + " and dc.critical= 'YES') and d.diseaseid=sd.diseaseid and sd.year=2014 and stateid= "+ stateID;
	else
		qType = "select "+month+" as month,d.disease from diseases as d,statedisease as sd where sd.diseaseid in (select distinct diseaseid from Disease_criticality as dc where dc.mnth = "+ monthNumber+ " and dc.stateid= " + stateID + " and dc.critical= 'NO') and d.diseaseid=sd.diseaseid and sd.year=2014 and stateid= "+ stateID;		
	
	System.out.println(qType);
	Connection conn = connectToDatabase();
	try {
		stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(qType);
	 int i = 1;
		while (rs.next()) {
			disCount.add(rs.getInt("month"));
			disName.add(rs.getString("disease"));
			System.out.println(disCount);
			System.out.println(disName);
		}
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
	sb.append(arr.get(i));
		if(i+1 < arr.size()){ 
			sb.append(","); 
		} 
	} 
	sb.append(']'); 
	return sb.toString(); 
}
%>
<%!
public static String getFormattedString(ArrayList name, ArrayList count)
{ 
	String conString = "[";
	for(int i = 0;i<name.size();i++){
		Disease dis = new Disease((String)name.get(i), (Integer)count.get(i));
		if(i==name.size()-1)
			conString = conString + dis.toJSON() + "]";
		else
			conString = conString + dis.toJSON()+",";
	}
	 	return conString;
}
%>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Travel Health Guide</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
<!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
<script type='text/javascript' src='//code.jquery.com/jquery-1.9.1.js'></script>
<link href="inspiritas.css" rel="stylesheet">
<script type='text/javascript'>
	//<![CDATA[ 
 $(function() {
		<% consolidateForSingleDisease(month,stateId,diseaseList , diseaseCountList,monthNum,true); %>
		
		//For non-critical, use
		<%--  <% consolidateForSingleDisease(month,stateId,diseaseList , diseaseCountList,monthNum,false); %> --%>
	
	var values = <%= getFormattedString(diseaseList,diseaseCountList)%>;
	//alert (values);
	RenderPieChart('container', values);     

	function RenderPieChart(elementId, dataList) {
		//alert("test");
        new Highcharts.Chart({
            chart: {
                renderTo: elementId,
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            }, title: {
                text: 'Critical Diseases in 2014 for the chosen month'
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.point.name + '</b>: ' + this.percentage.toFixed(2) + ' %';
                }
            },
            plotOptions: {
                pie: {allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + this.percentage.toFixed(2) + ' %';
                        }
                    },
                    showInLegend: true
                }
            },
            series: [{
                type: 'pie',
                name: 'Browser share',
                data: dataList
            }]
        });
    };
		
	
	}); 
	           
	//]]>
</script>
</head>
<body>
	<script
		src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
	<script src="js/highcharts.js"></script>
	<script src="js/inspiritas.js"></script>
	<script src="bootstrap/js/bootstrap-dropdown.js"></script>
	<script src="bootstrap/js/bootstrap-collapse.js"></script>
	<script src="http://code.highcharts.com/highcharts.js"></script>
	<script src="http://code.highcharts.com/modules/exporting.js"></script>
	<!-- Navbar
  ================================================== -->
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
		<div class="row-fluid">
			<div class="span3">
				<aside>
					<nav>
						<ul class="nav">
							<li><a href="index.jsp"><i
									class="icon-th-list icon-white"></i> Home</a></li>
							<li><a href=""><i class="icon-font icon-white"></i>
									Predictions </a></li>
							<li><a href="trendanalysis.jsp"><i
									class="icon-user icon-white"></i> Trend Analysis </a></li>
							<li><a href=""><i class="icon-retweet icon-white"></i>
									How it works? </a></li>
						</ul>
					</nav>
				</aside>
			</div>
			<div class="span9" id="content-wrapper">
				<div id="content">
					<!-- Navbar
                ================================================== -->
					<section id="stats">
						<header>
							<h4>State Level Information</h4>
						</header>
					</section>
					<!-- Forms
                ================================================== -->
					<section id="forms">

						<div class="row-fluid">
							<div class="span12">
								<form method="post" action="select.jsp">
									Pick a Month of Travel <select name="sel">
									<%
										for (int j = 0; j < monthsSmall.length; j++) 
										{
											if ((monthsSmall[j].equals(strMonth))) 
											{
												
									%>
									<option value="<%=monthsSmall[j]%>" Selected><%=monthsCapital[j]%></option>								
									<%
											} else {
									
									%>
										<option value="<%=monthsSmall[j]%>"><%=monthsCapital[j]%></option>
									<%
									} }
									%>	
										
									</select> &nbsp;&nbsp;&nbsp;&nbsp; Pick a Place of Travel <select
										name="sel1">
										
									<%
										for (int i = 0; i < alStates.size(); i++) 
										{
											if ((alStates.get(i)).getiStateId()==stateId)
											{
												
									%>
									<option value="<%=alStates.get(i).getiStateId()%>" Selected><%=alStates.get(i).getStrStateName()%></option>								
									<%
											} else {
									
									%>
										<option value="<%=alStates.get(i).getiStateId()%>"><%=alStates.get(i).getStrStateName()%></option>
									<%
									} }
									%>
									
									</select> <input class="btn btn-primary" type="Submit" value="Submit">
								</form>
					</section>
					<form action="">
						<div id="container"
							style="min-width: 310px; height: 400px; margin: 0 auto"></div>
						<div align="center">
							<br>
							<form>
										<input type="radio" name="option" value="Critical">Critical
										&nbsp;&nbsp;&nbsp;&nbsp; <input type="radio" name="option"
											value="All Diseases">All Diseases
									</form>
						</div>
					</form>
</body>
</html>

