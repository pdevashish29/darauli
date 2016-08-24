<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	String message="success";
			
%>
<html>
<head>
		<base href="<%=basePath%>">
				<script src="<%=path%>/bootstrap/js/jquery-1.11.2.min.js"></script>
				<link rel="stylesheet"href="<%=path%>/bootstrap/css/bootstrap.min.css">
				<script src="<%=path%>/bootstrap/js/bootstrap.min.js"></script>
				<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
				<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
				<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
				<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  				<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  				<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  				<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular.js"></script>
			    <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-animate.js"></script>
			    <script src="//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-2.0.2.js"></script>
			    <link href="//netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">

<title>SHIFTMobility</title>
	<style>
			.w3-card-8{
		float: right;
        width: 345px;
        height: 445px;
		margin: 100px 0;
		padding: px;
		margin-right: 30px;
		}
		.w3-card-4{
		float: right;
        width: 400px;
        height: 650px;
		margin: 100px 0;
		padding: px;
		margin-right: 30px;
		}
		#w3-card-8-chg{
		float: right;
        width: 345px;
        height: 400px;
		margin: 100px 0;
		padding: px;
		margin-right: 30px;
		}
		

</style>
<script type="text/javascript">
$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
   
});
			function signup(){
				/* alert("hello"); */
			html='';
			html+='<div class="w3-container" id="singnUp">'+
			      '<div class="w3-card-4  w3-hover-shadow w3-animate-zoom">'+
			     '<header class="w3-container w3-light-grey">'+
			       '<h3>Sign Up'+
			       '<span class="w3-closebtn" id="cancelbtn" onclick="cancelEdit()">x</span>'+
			       '</h3>'+
			      '</header><br>'+
				 '<form action="/register"class="w3-container" >'+
				 '<label >First Name</label>' +
				  '<input class="w3-input" type="text" name="fname" required><br>'+
				  '<label >Last Name</label>'+
			      '<input class="w3-input" type="text" name="lname" ><br>'+
			      '<label >Phone Number</label>'+
			      '<input class="w3-input" type="text" name="phone" ><br>'+
				     '<label >Email</label>'+
				     '<input class="w3-input" type="text" name="email" required><br>'+
				    '<label>Password</label>' +
				    '<input class="w3-input" type="password" name="pwd" required><br>'+
				   ' <label>Required Password</label>'+
					'<input class="w3-input" type="password" id="pwd1" required><br>'+
					'<input type="submit" class="w3-btn w3-green" value="Register"/>'+
					'<button class="w3-btn w3-red" style="margin-left: 15px">Cancel</button>'+
				  '</form>'+
				'</div>'+
		'</div>';
		$('#newUser').html(html);
		$("#logIn").hide();
}
			
			function changePwd() {
				html='';
				html+='<div class="w3-container" id="chngPwd" >'+
	               '<header class="w3-container w3-light-grey">'+
				      '<h3>Change Password'+
				     '<span onclick="removebtn()" class="w3-closebtn">x</span>'+
				     '</h3>'+
				'</header><br><br>'+
				'<form class="w3-container" >'+
			       '<label >Old Password</label>'+
				   '<input class="w3-input" type="text" name="oldpwd" required><br>'+
					'<label>New Password</label>'+
					'<input class="w3-input" type="password" id="newpwd" required><br>'+
                     '<label>Confirm Password</label>'+
					'<input class="w3-input" type="password" id="conpwd" required><br>'+
					'<button class="w3-btn w3-green">Change Password</button>'+
	          '</form>'+
          ' </div>'+
     '</div>';
  
				$('#newUser').html(html);
				$("#logIn").hide();	
	}
			  function newLogIn() {
				  html=''; 
				  html+='<div class="w3-container" id="showLogin">'+
                         '<div class="w3-card-8  w3-hover-shadow w3-animate-zoom">'+
		                  '<header class="w3-container w3-light-grey">'+
					      '<h3>Log In'+
					      '<span onclick="closebtn()" class="w3-closebtn">x</span>'+
					      '</h3>'+
					'</header><br><br>'+
					'<form name="loginform"class="w3-container" ng-controller="LoginContainer">'+
					   '<label >Email</label>'+
					   '<input class="w3-input" type="text" name="email"ng-model="example.email" ng-pattern="example.word" required ng-trim="false"><br>'+
						 '<label>Password</label>'+
						'<input class="w3-input" type="password" id="pwd" required><br>'+
						'<button class="w3-btn w3-green" onclick="validate(this);">Sign In</button>'+
						'<span><a  onclick="signup();" data-toggle="tooltip" title="Sign Up!" style="margin-left: 10px; cursor: pointer;">Register</a></span>'+
						'<span><a  onclick="changePwd();" data-toggle="tooltip" title="Change Password!" style="margin-left: 15px; color: red; cursor: pointer;">Forget your password?</a></span>'+
                        '<div>'+						
          	'<input class="w3-check w3-margin-top" type="checkbox" checked="checked"> Remember me'+
       	'</div>'+
       '<label style="margin-top: 32px;">Follow us on'+	
          	'</label>'+
		'</form>'+
		'<footer class="w3-container w3-light-grey">'+
		 ' <h5 style="display: flex;">'+
		 '<a href="https:www.facebook.com" data-toggle="tooltip" title="Share facebook!"><img style="width: 35px" class="img-responsive" src="<%=path%>/images/facebook.png" alt="socialSite"/></a>'+
		  '<a href="https:www.instagram.com" data-toggle="tooltip" title="Share instagram!"><img style="width: 35px; margin-left: 22px;" class="img-responsive" src="<%=path%>/images/instagram.png" alt="socialSite"/></a>'+
		'<a href="https:www.twitter.com" data-toggle="tooltip" title="Share twitter!"><img style="width: 35px; margin-left: 22px;" class="img-responsive" src="<%=path%>/images/twitter.png" alt="socialSite"/></a>'+
		 '<a href="https:www.googl+.com" data-toggle="tooltip" title="Share googl+!"><img style="width: 35px; margin-left: 22px;" class="img-responsive" src="<%=path%>/images/googl+.png" alt="socialSite"/></a>'+ 
		  '</h5>'+
		 '</footer>'+
	  '</div>'+
	 '</div>';	  
	        $("#logIn").html(html);	
				  
			}
			   function cancelEdit() {
				$("#singnUp").hide();
				$("#logIn").show();
			}
			   
			   function removebtn() {
					$("#chngPwd").hide();
					$("#logIn").show();
				}
			   
			   function closebtn() {
					$("#showLogin").hide();
				}
			   
</script>
</head>
<body >
  <div class="navbar navbar-default navbar-fixed-top" style="background:#008CBA;">
   <div class="cantainer">
   <div class="navbar-header">
   <h1>
     <a href="myCar.png"><img class="img-responsive w3-animate-left" src="/main/webapp/WEB-INF/images/myCar.png" style="height: 60px; width: 70px; margin-left: 30px;" alt="myCar"/></a>
  </h1>
   </div>
			   <div>
			    <span><a class="navbar-brand w3-animate-top w3-tag w3-xlarge w3-padding w3-red" href="#" style="margin-top: 18px; margin-left:10px; transform:rotate(-10deg)">ShopLite</a></span>
			  </div>
			                                                                                              
			   <div>
			    <span><a class="navbar-brand" onclick="newLogIn();" style="color: white; float: right;margin-top: 35px;margin-right: 58px; cursor: pointer;">Log IN</a></span>
			  </div>
      </div>
  </div>
        <div id="newUser"></div>
        <div  id="logIn" ></div>
    
 </body>
</html>