<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>  
<% 

	String path = request.getContextPath();
	Calendar cal = Calendar.getInstance();
	Date date=new Date();	
	int month=date.getMonth();
	int year=date.getYear();
	int dat=date.getDate();
	year=year+1900;
	SimpleDateFormat format = new SimpleDateFormat("MM/dd/YYYY");
	Calendar c = Calendar.getInstance();    
	c.set(year,month,1); 
	c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
	String toDate=format.format(c.getTime());
	String fromDate=(month+1)+"/"+01+"/"+year;
	request.setAttribute("page", 0);

%>

<!DOCTYPE html>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Angular navigatting</title>
<title>Estimates</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
  <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular-route.js"></script>
  <style>
    /* Set height of the grid so .sidenav can be 100% (adjust if needed) */
    .row.content {height: 1500px}
    
    /* Set gray background color and 100% height */
    .sidenav {
      background-color: #f1f1f1;
      height: 100%;
    }
    
    /* Set black background color, white text and some padding */
    footer {
      background-color: #555;
      color: white;
      padding: 15px;
    }
    
    /* On small screens, set height to 'auto' for sidenav and grid */
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        padding: 15px;
      }
      .row.content {height: auto;}
    }
  </style>
  <script>
var app = angular.module("myApp", ["ngRoute"]);

app.config(function($routeProvider) {
    $routeProvider
    .when("/view1", {
        templateUrl : "<%=path%>/view1"
    })
    .when("/view2", {
        templateUrl : "<%=path%>/view2"
    })
    .when("/view3", {
        templateUrl : "<%=path%>/view3"
    })
    .when("/view4", {
        templateUrl : "<%=path%>/view4"
    });
});






app.controller("view1Cntroller", function ($scope) {
    $scope.msg = "<h1>view1Cntroller<h1> ";
    
    
});
app.controller("view2Cntroller", function ($scope) {
    $scope.msg = "<h1>view2Cntroller<h1> ";
});


app.controller("view3Cntroller", function ($scope) {
    $scope.msg = "<h1>view3Cntroller<h1> ";
});

app.controller("view4Cntroller", function ($scope) {
    $scope.msg = "<h1>view4Cntroller<h1> ";
});

</script>
  
  
  
</head>
<body ng-app="myApp" >

<div class="container-fluid">
  <div class="row content">
    <div class="col-sm-3 sidenav">
      <h4>John's Blog</h4>
      <ul class="nav nav-pills nav-stacked">
        <li class="active"><a href="#section1">Home</a></li>
        <li><a href="#section2">Friends</a></li>
        <li><a href="#section3">Family</a></li>
        <li><a href="#section3">Photos</a></li>
      </ul><br>
      <div class="input-group">
        <input type="text" class="form-control" placeholder="Search Blog..">
        <span class="input-group-btn">
          <button class="btn btn-default" type="button">
            <span class="glyphicon glyphicon-search"></span>
          </button>
        </span>
      </div>
    </div>

    <div class="col-sm-9">
		<ul class="nav nav-tabs">
    		<li  class="{page==0 ? 'active': ''}"><a href="#">Home</a></li>
    		<li class="{page==1 ? 'active': ''}"><a href="#view1">Menu 1</a></li>
    		<li class="{page==2 ? 'active': ''}"><a href="#view2">Menu 2</a></li>
    		<li class="{page==3 ? 'active': ''}"><a href="#view3">Menu 3</a></li>
    		<li class="{page==4 ? 'active': ''}"><a href="#view4">Menu 3</a></li>
  		</ul>
     </div>
      <br>
       <div class="col-sm-9" ng-view  >
     </div>
      
      
    </div>
  </div>
<footer class="container-fluid">
  <p>Footer Text</p>
</footer>

</body>
</html>

