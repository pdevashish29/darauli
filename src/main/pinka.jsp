<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%
    	String path=request.getContextPath();
   	 	Date date=new Date();	
    	int month=date.getMonth();
    	int year=date.getYear();
    	int dat=date.getDate();
    	year=year+1900;
    	SimpleDateFormat format = new SimpleDateFormat("MM/dd/YYYY");
    	Calendar c = Calendar.getInstance();    
    	c.set(year,month,1); 
    	c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
    	String endDate=format.format(c.getTime());
    	String startDate=(month+1)+"/"+01+"/"+year;
    	
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>ServiceNetwork</title>
	<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap.min.css" style="text/css">
	
	<script type="text/javascript" src="<%=path%>/resources/js/jquery-1.11.2.min.js"></script>
	<script type="text/javascript" src="<%=path%>/resources/js/angular.min.js"></script>
	<script type="text/javascript" src="<%=path%>/resources/js/bootstrap.min.js"></script> 
	<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap-datetimepicker.css" type="text/css" />
	<script src="<%=path%>/resources/js/moment-with-locales.js"></script>
	<script src="<%=path%>/resources/js/bootstrap-datetimepicker.js"></script>
	
	<%-- 
	<link rel="stylesheet" type="text/css" href="<%=path %>/resources/css/jquery.ui.all.css"/> --%>

<script type="text/javascript">
	var app = angular.module('dailyApp', []);
	
	app.factory('ajaxService', ['$http', function ($http) {
		 var urlBase="<%=path%>";
		 return {
			 getDailyCloseEstimates: function (toDate,fromDate) {
				  var promise = $http({method:'POST', url:urlBase +'/c2mReports'+'/'+toDate+'/'+fromDate,async:false})
				    .success(function (data, status, headers, config) {
				      return data;
				    })
				    .error(function (data, status, headers, config) {
				      return {"status": false};
				    });
				  return promise;
				},
		 }
	}]);
	
	var TableCtrl = app.controller('dailyCtrl', function ($scope, $filter,$http,ajaxService) {
		var urlBase="<%=path%>";
		$scope.getDailyCloseEstimate=function(){
			var toDate=$('#toDate').val();
			var fromDate=$('#fromDate').val();
			toDate=toDate.replace('/','-').replace('/','-').replace('/','-');
			fromDate=fromDate.replace('/','-').replace('/','-').replace('/','-');
			console.log(fromDate+"=="+toDate);
			ajaxService.getDailyCloseEstimates(toDate,fromDate).then(function(promise) {
				console.log(promise+"====");
			});
			
		};
	});
</script>

</head>
<body ng-app="dailyApp" ng-controller="dailyCtrl">
<div class="fluid-container">
	<jsp:include page="salesMain.jsp"></jsp:include>
	<div class="form-group" style="margin-top: -9px;margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Daily Close</div>
				</div>
				<div class="panel-body">
					<div style="display: inline;position: absolute;margin-top: -9px;"> 
						<span style="font-size:17px;">Year</span> 
					      <span>
							 <select id="year" name="2016" onchange="traceDataByYear()" style="border:1px solid #ddd;width:68px;height:42px;margin-top: 5px;">
							  	<option id="2011">2011</option>
							  	<option id="2012">2012</option>
							  	<option id="2013">2013</option>
							  	<option id="2014">2014</option>
							  	<option id="2015">2015</option>
							  	<option id="2016">2016</option>
							  	<option id="2017">2017</option>
							  	<option id="2018">2018</option>
							  	<option id="2019">2019</option>
							  	<option id="2020">2020</option>
							</select>
						  </span> 
					</div>
					<div class="col-sm-10" id="horizMonth" style="top: -5px;margin-left: 100px;"> 
				      <ul class="nav nav-tabs">
				        <li id="0" onclick="horizMonth(this)"><a href="#">Jan</a></li>
				        <li id="1" onclick="horizMonth(this)"><a href="#">Feb</a></li>
				        <li id="2" onclick="horizMonth(this)"><a href="#">Mar</a></li>
				        <li id="3" onclick="horizMonth(this)"><a href="#">Apr</a></li>
				        <li id="4" onclick="horizMonth(this)"><a href="#">May</a></li>
				        <li id="5" onclick="horizMonth(this)"><a href="#">Jun</a></li>
				        <li id="6" onclick="horizMonth(this)"><a href="#">Jul</a></li>
				        <li id="7" onclick="horizMonth(this)"><a href="#">Aug</a></li>
				        <li id="8" onclick="horizMonth(this)"><a href="#">Sep</a></li>
				        <li id="9" onclick="horizMonth(this)" ><a href="#">Oct</a></li>
				        <li id="10" onclick="horizMonth(this)"><a href="#">Nov</a></li>
				        <li id="11" onclick="horizMonth(this)"><a href="#">Dec</a></li>
				      </ul>
				    </div>
				    <div style="margin-top: 15px;display: inline-flex;">
						<span style="margin-left: 2px;font-size: 13.5px;color: #000;height: 24px;padding: 5px;font-weight: bold;" >From Date</span>
						<div class='input-group date' id="fromDateSpan" style="width: 156px;"> 
							<input type="text" class="form-control"  name="fromDate" style="width: 120px;margin-left: 0px;padding-left: 4px;" id="fromDate"  ng-modal="fromDate"  />
							<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
						</div>
						<span style="margin-left: 20px;font-size: 13.5px;color: #000;height: 24px;padding: 5px;font-weight: bold;">To Date</span>
						<div class='input-group date' id="toDateSpan" style="width: 156px;">
							<input type="text"  name="toDate" class="form-control " id="toDate" style="width:120px;margin-left: 0px;padding-left: 4px;"  ng-modal="toDate"  />
							<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
						</div>
						<span><input type="button"  ng-click="getDailyCloseEstimate();" style="margin-left: 48px;" class="btn btn-primary" value="Search" /></span>
					</div>
					
					<div id="tableContent">
						<table class="table table-bordered" style="margin-top: 20px;" >
							<thead style="background-color: #337ab7;color:white;">
								  <tr> 
									<th width="10%" nowrap="nowrap">Date</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Cash $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Check $</th>
									<th width="35%" nowrap="nowrap" style="text-align: center;" class="nosort"><b style="font-size: 12px;">Credit Cards $</b>
										<div style="width: 100%;border-top: 1px solid;">
											<span style="font-size: 11px; width: 20%;text-align: center;border: none;padding-right: 5px;">Visa</span>
								 			<span style=" font-size: 11px; white-space: nowrap; width: 27%;text-align: center;border: none;margin-left: 26px;">Master Card</span>
								 			<span style="font-size: 11px; white-space: nowrap; width: 28%;text-align: center;border: none;margin-left: 25px;">AMEX</span>
								 			<span style=" font-size: 11px; width: 25%; border-right:none;text-align: center;border: none;margin-left: 25px;">Discover</span>	
										</div>
									</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">P.O. $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Balance $</th>
									<th width="8%" nowrap="nowrap" style="text-align: center;">Return $</th>
									<th width="8%" nowrap="nowrap" style="text-align: center;">Refund $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Total Tax $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Total Revenue $</th>
								  	<th width="5%" nowrap="nowrap" style="text-align: center;" class="nosort">Details</th>
								  </tr>
							  </thead>
							  <tbody>
							  
							  </tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="form-group">
			<jsp:include page="/footer.jsp"></jsp:include>
		</div>
</div>
</body>
<script type="text/javascript">
	
	$(function () {
		$('#'+<%=month%>).addClass('active');
		$('#'+<%=year%>).attr('selected','selected');
		
        $('#toDateSpan').datetimepicker({
        	format: 'MM/DD/YYYY',
        	defaultDate: '<%=endDate%>'
        });
        
        $('#fromDateSpan').datetimepicker({
        	format: 'MM/DD/YYYY',
        	defaultDate: '<%=startDate%>'
        });
    });
	
	$(".headerMenu").find("li").each(function(){
		var id=$(this).attr('id');
		if(id == "sales"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
	
	$(".salesMenu").find("li").each(function(){
		var id=$(this).attr('id');
		if(id == "dailyClose"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
</script>

</html>
