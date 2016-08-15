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

%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Estimates</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script src ="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/2.0.1/ui-bootstrap-tpls.js"> </script>
<script type="text/javascript">

var app=angular.module('myApp', []);

app.filter('startFrom', function() {
    return function(input, start) {
    	if (!input || !input.length) { return; }
        start = +start; //parse to int
        return input.slice(start);
    }
});


app.factory('ajaxService', ['$http', function ($http) {
	 var urlBase="<%=path%>";
	 return {
			
		 geEstimateReport: function () {
				  var promise = $http({method:'GET', url:urlBase+'/estimatePendingReportMonthly'})
				    .success(function (data, status, headers, config) {
				      return data;
				    })
				    .error(function (data, status, headers, config) {
				      return {"status": false};
				    });
				  
				  return promise;
			  },
	 
	 geEstimateReportByCriteria :function(year,month){
		 	var promise = $http({
				 			method:'GET',
				 			url:urlBase+'/estimatePendingReportByCriteria?month='+month+'&year='+year})
				 			 .success(function (data, status, headers, config) {
							      return data;
							    })
							    .error(function (data, status, headers, config) {
							      return {"status": false};
							    });
							  
							  return promise;	
	 }
	
	 }

}]);

app.controller('MyCtrl', function($scope, $http,$filter,ajaxService) {
	    var urlBase="<%=path%>";
		$scope.estimateList=[];
		$scope.totalLaborSum =0;
		$scope.totalPartSum=0;
		$scope.totalServiceTaxSum=0;
		$scope.totalDisSum=0;
		$scope.totalSum=0;
		
			 $scope.currentPage = 0;
		     $scope.pageSize = 10;
		     $scope.q = '';
		
		     $scope.year= <%=year%>;
		     $scope.month=<%=month+1%>;
		     
		     
		     ajaxService.geEstimateReportByCriteria($scope.year,$scope.month).then(function(promise){
		 		$scope.estimateList=promise.data;
		 		  angular.forEach($scope.estimateList, function(value, key){
		 		      $scope.totalLaborSum+=value.labor_charge;
		 		      $scope.totalPartSum+=value.part_charge;
		 		      $scope.totalServiceTaxSum+=value.service_tax;
		 		  	  $scope.totalDisSum+=value.discount;
		 		      $scope.totalSum+=value.total;
		 		   });
		 		
		 		
		 	});
		     
		     
		     $scope.geEstimateReportMonthly=function(month){
		    	$scope.month=month;
		 		$scope.totalLaborSum =0;
		 		$scope.totalPartSum=0;
		 		$scope.totalServiceTaxSum=0;
		 		$scope.totalDisSum=0;
		 		$scope.totalSum=0;
		 		ajaxService.geEstimateReportByCriteria($scope.year,$scope.month).then(function(promise){
		 			$scope.estimateList=promise.data;
		 			 angular.forEach($scope.estimateList, function(value, key){
		 			      $scope.totalLaborSum+=value.labor_charge;
		 			      $scope.totalPartSum+=value.part_charge;
		 			      $scope.totalServiceTaxSum+=value.service_tax;
		 			  	  $scope.totalDisSum+=value.discount;
		 			      $scope.totalSum+=value.total;
		 			   });
		 		});
		 		
		 	};
		 	
		 	
	  
	  
	  $scope.getData = function () {
	      return $filter('filter')($scope.estimateList, $scope.q)
	    }
	  
	  
	  $scope.numberOfPages=function(){
	        return Math.ceil($scope.getData().length/$scope.pageSize);                
	    }
	});
 
</script>



</head>
  <style>
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
    padding-right:10px
      background-color: #555;
      color: white;
      padding: 15px;
    }
    
    /* On small screens, set height to 'auto' for sidenav and grid */
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        width:auto;
        padding: 15px;
      }
      .row.content {height: auto;}
    }
  </style>
</head>
<body ng-app="myApp" ng-controller="MyCtrl">

<div class="container-fluid">
  <div class="row content">
    <div class="col-sm-2 sidenav">
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
<br>

    <div class="col-sm-9">
    	<div class="row">
		<div class="col-sm-10">

<ul class="nav nav-pills  horizon ">
		    <li ng-click="geEstimateReportMonthly(1)"><a href="#">Jan</a></li>
		    <li ng-click="geEstimateReportMonthly(2)"><a href="#">Feb </a></li>
		    <li ng-click="geEstimateReportMonthly(3)"><a href="#">Mar </a></li>
		    <li ng-click="geEstimateReportMonthly(4)"><a href="#">Apr</a></li>
		    <li ng-click="geEstimateReportMonthly(5)"><a href="#">May</a></li>
		    <li ng-click="geEstimateReportMonthly(6)"><a href="#">Jun</a></li>
		    <li ng-click="geEstimateReportMonthly(7)"><a href="#">Jul</a></li>
		    <li ng-click="geEstimateReportMonthly(8)"><a href="#">Aug</a></li>
		    <li ng-click="geEstimateReportMonthly(9)"><a href="#">Sep </a></li>
		    <li ng-click="geEstimateReportMonthly(10)"><a href="#">Oct </a></li>
		    <li ng-click="geEstimateReportMonthly(11)"><a href="#">Nov </a></li>
		    <li ng-click="geEstimateReportMonthly(12)"><a href="#">Dec </a></li>
  </ul>
</div>


  <div class="col-sm-2">
  <table >
  <tr>
  <td><label style="font-size: 15px; margin-right: 5px">Year </label></td>
  <td style="margin-left: 2px">
  <select ng-model="year" class="form-control" id="sel1"  >
  		<% for(int i =year-5;i <year+5;i++ ) {%>  
    			<option value="<%=i %>"><%=i %></option>
 		 <%}%>
  </select>
  
  </td>
  </tr>
  </table>
  
  </div>
</div>
     	
      <hr>
    </div>
    
    
    
    
    <div class="col-sm-9">
		
		
		
    <div class="col-sm-9" ng-if="estimateList.length>0">
      <table  class="table table-striped table-bordered">
    <thead >
      <tr>
       <th><span style="font-size: 15px; text-align: right; width: 5px;!important;">Date</span></th>
       <th><span style="font-size: 15px; text-align: right; width: 5px;">Estimate# </span></th>
       <th><span style="font-size: 15px; text-align: left; width: 10px;">Customer </span></th>
       <th><span style="font-size: 15px; text-align: right; width: 5px;">Labour </span></th>
       <th><span style="font-size: 15px; text-align: right; width: 5px;">Part </span></th>
       <th><span style="font-size: 15px; text-align: right; width: 5px;">Service Tax </span></th>
       <th><span style="font-size: 15px; text-align: right; width: 5px;">Discount </span></th>
        <th><span style="font-size: 15px; text-align: right; width: 5px;">Total </span></th>
      </tr>
    </thead>
    <tbody   >
    
      <tr  ng-repeat="estimate in estimateList | filter:q | startFrom:currentPage*pageSize | limitTo:pageSize"">
        	 <td>{{estimate.estimate_date | date : 'MMM dd,yyyy'}}</td>
        	 <td><span style="text-align: right">{{estimate.estimate_id}}</span></td>
        	 <td><span style="text-align: right">{{estimate.name}}</span></td>
        	 <td><span style="text-align: right">{{estimate.labor_charge | number :'2'}}</span></td>
        	 <td><span style="text-align: right">{{estimate.part_charge | number :'2'}}</span></td>
        	 <td><span style="text-align: right">{{estimate.service_tax | number :'2'}}</span></td>
        	 <td><span style="text-align: right">{{estimate.discount | number :'2'}}</span></td>
        	 <td><span style="text-align: right">{{estimate.total | number :'2'}}</span></td>
      </tr>
  <tr>
  		<td colspan="3">Total</td>
  		 <td>{{totalLaborSum}}</td>
        <td>{{totalPartSum}}</td>
        <td>{{totalServiceTaxSum}}</td>
         <td>{{totalDisSum}}</td>
        <td>{{totalSum}}</td>
        
  </tr>
  <tr>
  
 
  
  <tr>
     
      <input ng-model="q" id="search" class="form-control" placeholder="Filter text">
    <select ng-model="pageSize" id="pageSize" class="form-control">
        <option value="5">5</option>
        <option value="10">10</option>
        <option value="15">15</option>
        <option value="20">20</option>
     </select>
    <ul>
        <li ng-repeat="item in data | filter:q | startFrom:currentPage*pageSize | limitTo:pageSize">
            {{item.name}}
        </li>
    </ul>
    <button ng-disabled="currentPage == 0" ng-click="currentPage=currentPage-1">
        Previous
    </button>
    {{currentPage+1}}/{{numberOfPages()}}
    <button ng-disabled="currentPage >= getData().length/pageSize - 1" ng-click="currentPage=currentPage+1">
        Next
    </button>
  
   
     
  </tr>
    
      
    </tbody>
  </table>
     
    
		
 
    
  <div class="col-sm-9" ng-if="estimateList.length==0">  
  <div class="row">
		<div class="col-sm-10">
  <h2 style="font-size: 17px; text-align: center; color: red; margin-top: 5px">No Record Found</h2>
  </div>
</div>
</div>
<footer class="container-fluid">
  <p>Footer Text</p>
</footer>
</div>
  </div>
</body>
</html>

