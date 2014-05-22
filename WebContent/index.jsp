<%@page import="com.proj.util.Util"%>
<%@page import="com.proj.pojo.State"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	Util utilObj = new Util();
	ArrayList<State> alStates = new ArrayList<State>();
	alStates = utilObj.getStates();
	if (alStates == null) {
		alStates = new ArrayList<State>();
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

<link href="inspiritas.css" rel="stylesheet">

</head>

<body>

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
				<aside> <nav>
				<ul class="nav">
					<li><a href=""><i class="icon-th-list icon-white"></i>
							Home</a></li>
					<li><a href=""><i class="icon-font icon-white"></i>
							Predictions </a></li>
					<li><a href="trendanalysis.jsp"><i
							class="icon-user icon-white"></i> Trend Analysis </a></li>
					<li><a href=""><i class="icon-retweet icon-white"></i> How
							it works? </a></li>
				</ul>
				</nav> </aside>
			</div>
			<div class="span9" id="content-wrapper">
				<div id="content">

					<!-- Navbar
                ================================================== -->
					<section id="stats"> <header>
					<h4>WANT TO KNOW HOW FIT YOU WOULD BE?</h4>
					</header> </section>

					<!-- Forms
                ================================================== -->
					<section id="forms">
					<div class="sub-header">
						<h2>
							<b>Enter details below:</b>
						</h2>
					</div>

					<div class="row-fluid">
						<div class="span12">
							<form method="post" action="select.jsp">
								<input type="hidden" name="hidden" value="0"> Pick a
								Month of Travel <select name="sel" >
									<option name="january">January</option>
									<option name="february">February</option>
									<option name="march">March</option>
									<option name="april">April</option>
									<option name="may">May</option>
									<option name="june">June</option>
									<option name="july">July</option>
									<option name="august">August</option>
									<option name="september">September</option>
									<option name="october">October</option>
									<option name="november">November</option>
									<option name="december">December</option>
								</select> <br> Pick a Place of Travel <select name="sel1">
									<option value="select">Please Select a State</option>
									<%
										for (int i = 0; i < alStates.size(); i++) {
									%>
									<option value="<%=alStates.get(i).getiStateId()%>"><%=alStates.get(i).getStrStateName()%></option>
									<%
										}
									%>
									
								</select> <br>
								<input type="hidden" name="hiddenFld" id="hiddenFld" />
								 <input class="btn btn-primary" type="Submit"
									value="Submit">
							</form>
					</section>

					<!-- Buttons
                    <!-- Placed at the end of the document so the pages load faster -->
					<script
						src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
					<script src="js/highcharts.js"></script>
					<script src="js/inspiritas.js"></script>
					<script src="bootstrap/js/bootstrap-dropdown.js"></script>
					<script src="bootstrap/js/bootstrap-collapse.js"></script>
</body>
</html>
