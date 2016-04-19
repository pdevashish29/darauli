<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE html>
<html>
<head>

<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>

<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>

<script type="text/javascript" 
		src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>

<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	
	
	 <link href="resources/css/blog.css" rel="stylesheet">

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><tiles:getAsString name="title" /></title>
	
</head>
<body>	

<%@ taglib uri="http://tiles.apache.org/tags-tiles-extras" prefix="tilesx" %>

	<tilesx:useAttribute name="current"/>





<nav class="navbar navbar-inverse">
 <tiles:insertAttribute name ="header"/>
</nav>



<div class="container-fluid text-center">    
  <div class="row content">
    <div class="col-sm-2 sidenav">
    Adds
      <tiles:insertAttribute name ="leftmenu"/>
    </div>
  


    	<div class="col-sm-8 text-left"> 
    			<tiles:insertAttribute name="body" />
       </div>
       
       
    <div class="col-sm-2 sidenav">
    Adds
			<tiles:insertAttribute name="rightmenu" />
       </div>

  </div>

</div>
<br><br><br>

<br><br><br>

<br><br><br>

<br><br><br>

<br><br><br>

<br><br><br>

<br><br><br>

<br><br><br>

<br><br><br>


<footer class="container-fluid text-center">
	<tiles:insertAttribute name="footer" />
</footer>




</body>
</html>