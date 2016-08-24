<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%
    	
    	String path=request.getContextPath();
    	Calendar calendar=Calendar.getInstance();
    	SimpleDateFormat format=new SimpleDateFormat("MMM dd, yyyy");
	    String date = format.format(calendar.getTime());
        %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ServiceNetwork</title>
<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap.min.css" style="text/css">
<script type="text/javascript" src="<%=path%>/resources/js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="<%=path%>/resources/js/angular.min.js"></script>
<script type="text/javascript" src="<%=path%>/resources/js/kendo.all.min.js"></script>
<script type="text/javascript" src="<%=path%>/resources/js/bootstrap.min.js"></script>


<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap-datetimepicker.css" style="text/css">
<script type="text/javascript" src="<%=path%>/resources/js/moment-with-locales.js"></script>
<script type="text/javascript" src="<%=path%>/resources/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript">
var app=angular.module('laborApp', []);
 app.factory('laborFactory',['$http','$q', function($http, $q){
	 var urlBase="<%=path%>";
	return{
		'dailyTimeSheet':function(date){
			return $http({
				method:'POST',
				url:'<%=path%>/dailyTimeSheet',
				data:{date:date}
			}).then(
				function(response){/* alert(JSON.stringify(response.data)); */
					return response.data;
					
				},		
				function(errResponse){
					return $q.reject(errResponse);
				});
			}
	
	}
}]);
app.controller('laborCtrl', function($scope, laborFactory, graphFactory, $filter){
	$scope.date ='';
	$scope.techList=[];
	$scope.totalSales=0;
	$scope.totalPayRoll=0;
	$scope.payrollPercentSales=0;
	
	
	
	$('#loadingimg').show();
	$("#paginationRow").css("display","none");
	$("#tableContent").css("display","none");
	
	laborFactory.dailyTimeSheet($scope.date).then(
		function(data){
			//
			/*  alert(JSON.stringify(data));  */
			
				$("#paginationRow").show();
				$('#loadingimg').hide();
				$("#tableContent").show();
			
			
			$scope.techList=data.listOfTech;
			$scope.totalSales=data.todaysTotal;
			$scope.totalPayRoll=data.totalPayRoll;
			$scope.payrollPercentSales=data.totalPayRollPercetage;
			
		});
	
	

	$scope.dailyTimeSheet= function(){
		$scope.totalSales=0;
		$scope.totalPayRoll=0;
		$scope.payrollPercentSales=0;
		
		$scope.date = $('#todayDate').val();
		
		$('#loadingimg').show();
		$("#paginationRow").css("display","none");
		$("#tableContent").css("display","none");
		
		/* alert($scope.date); */
		laborFactory.dailyTimeSheet($scope.date).then(
				function(data){
					
					$("#paginationRow").show();
					$('#loadingimg').hide();
					$("#tableContent").show();
					
					
					$scope.techList=data.listOfTech;
					$scope.totalSales=data.todaysTotal;
					$scope.totalPayRoll=data.totalPayRoll;
					$scope.payrollPercentSales=data.totalPayRollPercetage;
					
					
					
				});
	};
	
  
	
		
	

	/*................Added Pagination.................*/
	$scope.gap = 5;
    $scope.filteredItems = [];
    $scope.groupedItems = [];
    $scope.itemsPerPage = 10;
    $scope.pagedItems = [];
    $scope.currentPage = 0;
	 var searchMatch = function (haystack, needle) {
	        if (!needle) {
	            return true;
	        }
	        return haystack.toLowerCase().indexOf(needle.toLowerCase()) !== -1;
	    };
	    // init the filtered items
	 	$scope.search = function (dataList) {
	        $scope.filteredItems = $filter('filter')(dataList, function (summary) {

	           
	        	for(var attr in summary) {
	                if (searchMatch(summary[attr], $scope.query))
	                    return true;
	            }
	            return false;
	        });
	       //alert($scope.filteredItems);
	        $scope.currentPage = 0;
	        
	        $scope.groupToPages();
	        
	    };
	    
	   
	  
	    // calculate page in place
	    $scope.groupToPages = function () {
	        $scope.pagedItems = [];
	        
	        for (var i = 0; i < $scope.filteredItems.length; i++) {
	            if (i % $scope.itemsPerPage === 0) {
	                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [ $scope.filteredItems[i] ];
	            } else {
	                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
	            }
	        };
	    };
	    
	    $scope.range = function (size,start) {
	        var ret = [];  
	        var end=1;
	       // $scope.itemsPerPage
	        // var len= $scope.businessDetails.length; 
	        
	        if(size>5){
	        	end=start+5;
	        }else{
	        	end=size;
	        }
	        
	        if (size < end) {
	            end = size;
	            start = size-$scope.gap;
	        }
	        for (var i = start; i < end; i++) {
	            ret.push(i);
	        }  
	        //alert(size+"    "+start+"  "+end);
	         //console.log(ret);        
	        return ret;
	    };
	    
	    $scope.prevPage = function () {
	        if ($scope.currentPage > 0) {
	            $scope.currentPage--;
	        }
	    };
	    
	    $scope.nextPage = function () {
	        if ($scope.currentPage < $scope.pagedItems.length - 1) {
	            $scope.currentPage++;
	        }
	    };
	    
	    $scope.setPage = function () {
	        $scope.currentPage = this.n;
	    };

	    /*................End pagination.........................*/
});

</script>
</head>
<body ng-app="laborApp" ng-controller="laborCtrl">
<div class="fluid-container">
	<jsp:include page="timeLaborMain.jsp"></jsp:include>
	<div class="panel panel-primary" style="margin-top: -9px;">
		<div class="panel-heading">
			<h4 class="panel-title">Daily Time Sheet</h4>
		</div>
		<div class="panel-body"">
	
	<div class ="row">
			<div class ="col-sm-2">
				<div class="form-group" style="height: 34px;" data-ng-hide="calendarShow">
					<div style="display: inline-flex;">
						<div class='input-group date' id="todayDateSpan" style="width: 156px;"> 
							<input type="text" class="form-control"  name="fromDate" style="width: 120px;margin-left: 0px;padding-left: 4px;" id="todayDate"   />
							<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
						</div>
						
						<span><input type="button"  data-ng-click="dailyTimeSheet()" style="margin-left: 10px;" class="btn btn-primary" value="Search" /></span>
					</div>
				
				</div>
			</div>

					<div class='list-group col-sm-8' style="background-color: #e8f2fe; border: 1px solid #c7dffe; margin-left: 40px">
						<div class="row">
							<label class="control-label totalSales col-sm-4 text-center" style="color:#0578A7;font-size: 20px;font-family: Lucida Sans Unicode;"></label>
							<label class="control-label totalPayroll col-sm-4 text-center" style="color:#0578A7;font-size: 20px;font-family: Lucida Sans Unicode;"></label>
							<label class="control-label totalPercent col-sm-4 text-center" style="color:#0578A7;font-size: 20px;font-family: Lucida Sans Unicode;"></label>
						</div>
						<div class="row">
							<label class="control-label totalSalesLabel col-sm-4 text-center" style="font-size: 14px;font-family: Lucida Sans Unicode;">{{totalSales |currency}}</label>
							<label class="control-label totalPayrollLabel col-sm-4 text-center" style="font-size: 14px;font-family: Lucida Sans Unicode;">{{totalPayRoll | currency}}</label>
							<label class="control-label totalPercentLabel col-sm-4 text-center" style="font-size: 14px;font-family: Lucida Sans Unicode;">{{payrollPercentSales>0 ? payrollPercentSales  : 0 |number:2}}%</label>
						</div>
						<div class="row">
							<label class="control-label totalSalesLabel col-sm-4 text-center" style="font-size: 14px;font-family: Lucida Sans Unicode;">Total Sales</label>
							<label class="control-label totalPayrollLabel col-sm-4 text-center" style="font-size: 14px;font-family: Lucida Sans Unicode;">Total Payroll</label>
							<label class="control-label totalPercentLabel col-sm-4 text-center" style="font-size: 14px;font-family: Lucida Sans Unicode;">Total Payroll % Sales</label>
						</div>
					</div>
	
	</div>
	
					<div class="form-group">
						<div class="loading-spiner" id="loadingimg"
							style="margin: 50px 50px 0px 0px; display: block; margin-bottom: 50px">
							<img src="<%=path%>/resources/image/gif-load.gif"
								style="margin-left: 584px; margin-top: -16px; position: absolute;" />
						</div>
					</div>
	
	
		
			<div class="form-group" style="margin: -25px -15px;" id ="myTable">
				<table class="table table-bordered">
					<thead>
						<tr>
							<th data-ng-click=""  style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">Technician</th>
							<th data-ng-click=""  style="text-align:right;background: rgb(0, 136, 204);color:#fff;">Work Hour</th>
							<th data-ng-click="" style="text-align:right;background: rgb(0, 136, 204);color:#fff;"> Payroll</th>
							<th data-ng-click="" style=" text-align:right; ;background: rgb(0, 136, 204);color:#fff;">Payroll % Sales</th>
						</tr>
					</thead>
					
					
					<tbody>
						<tr data-ng-repeat="tech in techList  ">
							<td >{{tech[0]}} <br> {{tech[1]}}</td>
							<td style="text-align:right;">{{tech[2] | number:2}}</td>
							<td style="text-align:right;">{{tech[3] | currency}}</td>
							
							<td style="text-align:right;">{{tech[4]>0 ? tech[4]  : 0 |number:2}}%</td>
							
						</tr>
					</tbody>
					<tfoot >	
					</tfoot>
				</table>
			</div>
	
	
			
	

		</div>
	</div>
</div>
</body>
<script type="text/javascript">
$(function () {
	 $('#todayDateSpan').datetimepicker({
	    	format: 'MMM DD, YYYY',
	    	defaultDate: '<%=date%>',
	    });
    
   
});
$(".headerMenu").find("li").each(function(){
	var id=$(this).attr('id');
	if(id == "timeLabor"){
		$(this).addClass("active");
		$(this).find("a").css("background-color","#0088cc");
	}else{
		$(this).removeClass("active");
		$(this).find("a").css("background-color","");
	}
});
$(".timeLaborMenu").find("li").each(function(){
	var id=$(this).attr('id');
	//alert(id);
	if(id == "dailyTimeSheet"){
		$(this).addClass("active");
		$(this).find("a").css("background-color","#0088cc");
	}else{
		$(this).removeClass("active");
		$(this).find("a").css("background-color","");
	}
});


</script>
</html>