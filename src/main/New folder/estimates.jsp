<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>  
 
 <%
 	String path=request.getContextPath();
 	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap.min.css"
	style="text/css">
<script type="text/javascript"
	src="<%=path%>/resources/js/jquery-1.11.2.min.js"></script>
<script type="text/javascript"
	src="<%=path%>/resources/js/angular.min.js"></script>
<script type="text/javascript"
	src="<%=path%>/resources/js/bootstrap.min.js"></script>
<script type="text/javascript">

var app = angular.module('dailyApp', []);
app.factory('ajaxService', ['$http', '$q', function ($http, $q) {
	var urlBase="<%=path%>";
	  return {
		 		 getEstimatePendingReportMonthly : function(year,month){
			 	 return $http({method:'GET', url:urlBase+'/estimatePendingReportMonthly?year='+year+'&month='+month})
			    .then(
			    function (response) {/* alert(JSON.stringify(response.data)); */
			      return response.data;
			    },
			    function (err) {
			      return $q.reject(err);
			    });
			  
			 
			  
		  },
		  
	  }
		 
}]);
/* 
END OF FACTORY
 */ 
 
 
 app.controller('dailyCtrl', function ($scope,ajaxService) {
	 	var urlBase="<%=path%>";
		$scope.month='<%=month%>';
		$scope.year='<%=year%>';
		$scope.estimateList='';
		$scope.totalLaborSum='';
		$scope.totalPartSum='';
		$scope.totalTaxSum='';
		$scope.totalDisSum='';
		$scope.totalSaleSum='';
			 
	 
	 $scope.getEstimatePendingReportMonthly=function(data){
		 	$scope.month=data;
			$scope.totalLaborSum=0;
			$scope.totalPartSum=0;
			$scope.totalTaxSum=0;
			$scope.totalDisSum=0;
			$scope.totalSaleSum=0;
			
			ajaxService.getEstimatePendingReportMonthly($scope.year,$scope.month).then(function(data) {
				
				$scope.estimateList=data.estimateList;
				
				
			
				
			console.log("chacha -----"+$scope.totalLaborSum);
				
				
				
			});
			
		};
	 
	 
 });
 

 </script>
</head>
<body ng-app="dailyApp" ng-controller="dailyCtrl">
	<div class="fluid-container">
		<jsp:include page="salesMain.jsp"></jsp:include>
		<div class="form-group" style="margin-top: -9px; margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Sales</div>

				</div>
				<div class="panel-body">
					<div style="display: inline; position: absolute; margin-top: -9px;">
						<span style="font-size: 17px;">Year</span> <span> 
						<select id="year" name="2016" style="border: 1px solid #ddd; width: 68px; height: 42px; margin-top: 5px;">
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
					<div class="col-sm-10" id="horizMonth"
						style="top: -5px; margin-left: 100px;">
						<ul class="nav nav-tabs">
							<li id="0" ng-click="getEstimatePendingReportMonthly(1)"><a
								href="#">Jan</a></li>
							<li id="1" ng-click="getEstimatePendingReportMonthly(2)"><a
								href="#">Feb</a></li>
							<li id="2" ng-click="getEstimatePendingReportMonthly(3)"><a
								href="#">Mar</a></li>
							<li id="3" ng-click="getEstimatePendingReportMonthly(4)"><a
								href="#">Apr</a></li>
							<li id="4" ng-click="getEstimatePendingReportMonthly(5)"><a
								href="#">May</a></li>
							<li id="5" ng-click="getEstimatePendingReportMonthly(6)"><a
								href="#">Jun</a></li>
							<li id="6" ng-click="getEstimatePendingReportMonthly(7)"><a
								href="#">Jul</a></li>
							<li id="7" ng-click="getEstimatePendingReportMonthly(8)"><a
								href="#">Aug</a></li>
							<li id="8" ng-click="getEstimatePendingReportMonthly(9)"><a
								href="#">Sep</a></li>
							<li id="9" ng-click="getEstimatePendingReportMonthly(10)"><a
								href="#">Oct</a></li>
							<li id="10" ng-click="getEstimatePendingReportMonthly(11)"><a
								href="#">Nov</a></li>
							<li id="11" ng-click="getEstimatePendingReportMonthly(12)"><a
								href="#">Dec</a></li>
						</ul>
					</div>

					<div id="tableContent">
						<table class="table table-bordered" style="margin-top: 20px;" >
							<thead style="background-color: #337ab7;color:white;">
								  <tr> 
									<th width="10%" nowrap="nowrap">Date</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Estimate#</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Doc#</th>
									<th width="35%" nowrap="nowrap" style="text-align: center;" class="nosort"><b style="font-size: 12px;">Customer</b>
										
									<th width="10%" nowrap="nowrap" style="text-align: center;">Labor $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Parts $</th>
									<th width="8%" nowrap="nowrap" style="text-align: center;">Sale Tax $</th>
									<th width="8%" nowrap="nowrap" style="text-align: center;">Total Discount $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;">Total Sale $</th>
								 </tr>
							  </thead>
							  <tbody>
							  
							<tr ng-repeat="item in estimateList">
								<td>{{item[0]}}</td>
								<td>{{item[1]}}</td>
								<td>{{item[9]}}</td>
								<td>{{item[6]}} <br> {{item[7]}}</td>
								<td>{{item[4]}}</td>
								<td>{{item[5]}}</td>
								<td>{{item[6]}}</td>
								<td>{{item[7]}}</td>
								<td>{{item[8]}}</td>
								<td>{{item[9]}}</td>
							</tr>
							<tr ng-if="estimateList.length==0">
								<td colspan="6" style="color: red; font-size: 16px; font-weight: bold; text-align: center;">No record found</td>
							</tr>
						</tbody>
						</table>
					</div>

					
					<!-- end of estimate body -->
				</div>
			</div>
			<div class="form-group">
				<jsp:include page="/footer.jsp"></jsp:include>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	$(".headerMenu").find("li").each(function(){
		var id=$(this).attr('id');
		//alert(id);
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
		//alert(id);
		if(id == "estimates"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
</script>
</html>