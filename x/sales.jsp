<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
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
	<script type="text/javascript" src="<%=path%>/resources/js/kendo.all.min.js"></script>
	<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap-datetimepicker.css" type="text/css" />
	<script src="<%=path%>/resources/js/moment-with-locales.js"></script>
	<script src="<%=path%>/resources/js/bootstrap-datetimepicker.js"></script>
	
	<script type="text/javascript">
		var app = angular.module('salesApp', []);
		
		app.filter('dateFormat', function() {
			  return function(item) {
			        var result ="";
			        var month=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			        var date=new Date(item);
			        var dd=date.getDate();
			        var mm=date.getMonth();
			        var yy=date.getFullYear();
			        result=month[mm]+" "+dd+", "+yy;
			        return result;
			    };
		});
		
		app.filter('offset', function() {
			  return function(input, start) {
			    start = parseInt(start, 10);
			    if(start>0){
			    	return input.slice(start);
			    }else{
			    	return input;
			    }
			  };
		});
		
		app.factory('ajaxService', ['$http', function ($http) {
			 var urlBase="<%=path%>";
			 return {
					getSales: function (toDate,fromDate) {
						 var dataArray = {'toDate':toDate,'fromDate':fromDate};
						 var promise = $http({method:'POST', url:urlBase +'/salesReports',data:dataArray,async:false})
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
		
		var TableCtrl = app.controller('salesCtrl', function ($scope, $filter,$http,ajaxService,graphFactory) {
			$scope.year="<%=year%>";
			$scope.itemsPerPage = 10;
			$scope.currentPage = 0;
			$scope.refList=[];
			$scope.orderByField = 'date';
			$scope.reverseSort = false;
			$scope.getSalesEstimate=function(year){
				$('#tableContent').hide();
				$('#loadingimg').show();
				var toDate=$('#toDate').val();
				$scope.currentPage = 0;
				$scope.refList=[];
				$scope.totalLabor="0";
				$scope.totalParts="0";
				$scope.totalSalesTax="0";
				$scope.totalLaborDiscount="0";
				$scope.totalPartDiscount="0";
				$scope.totalDiscount="0";
				$scope.totalRefund="0";
				$scope.totalSales="0";
				var fromDate=$('#fromDate').val();
				if(year!=undefined){
					$scope.year=year;
					toDate=toDate.substr(0, 6) +year;
					fromDate=fromDate.substr(0, 6) +year;
					if(year%4==0){
						toDate=toDate.substr(0, 3)+29+toDate.substr(5, 5);
					}else{
						toDate=toDate.substr(0, 3)+28+toDate.substr(5, 5);
					}
					$('#toDate').val(toDate);
					$('#fromDate').val(fromDate);
					
				}
				 ajaxService.getSales(toDate,fromDate).then(function(promise) {
					$scope.map=promise.data;
					$scope.refundMap=$scope.map.refundMap;
					$scope.list=$scope.map.list;
					//console.log("Year"+$scope.refundMap);
					angular.forEach($scope.list, function(item) {
						$scope.totalLabor=Number($scope.totalLabor)+Number(item[2]);
						$scope.totalParts=Number($scope.totalParts)+Number(item[3]);
						$scope.totalSalesTax=Number($scope.totalSalesTax)+Number(item[4]);
						$scope.totalLaborDiscount=Number($scope.totalLaborDiscount)+Number(item[5]);
						$scope.totalPartDiscount=Number($scope.totalPartDiscount)+Number(item[6]);
						$scope.totalDiscount=Number($scope.totalDiscount)+Number(item[7]);
						$scope.totalSales=Number($scope.totalSales)+Number(item[8]);
						angular.forEach($scope.refundMap, function(value, key) {
							 if(key==item[1]){
								 $scope.refList.push(key);
								 $scope.totalRefund=Number($scope.totalRefund)+Number(value);
							 }
						});
					});
					$('#loadingimg').hide();
					$('#tableContent').show();
				}); 
				
				$("#div-loading-spiner").show();
				$("#div-graph-content").hide();
				if(year!=undefined){
						graphFactory.getGraphDataList($scope.year).then(function(data){
							$scope.estimate=data.estimateData;
							$scope.sales=data.salesData;
							$scope.purchase=data.purchaseData;
							$scope.max=data.max;
							$("#div-loading-spiner").hide();
							$("#div-graph-content").show();
							createChart($scope.estimate, $scope.max, 'estimateOptions','Open Estimates');
							createChart($scope.sales, $scope.max, 'salesOptions','Invoices');
							createChart($scope.purchase, $scope.max, 'purchaseOptions','Purchases');
							$scope.totalCustomer=data.totalCustomer;
							$scope.totalVehicle=data.totalVehicle;
							$scope.cvRatio=data.cvRatio;
						});
				}
				
				
			};
			
			$scope.getSalesEstimateByMonth=function(e){
				var id = $(e.currentTarget).attr("data-id");
				$scope.refList=[];
				$('#loadingimg').show();
				$('#tableContent').hide();
				var month=Number(id)+Number(1);
				var toDate=$('#toDate').val();
				$scope.currentPage = 0;
				$scope.totalLabor="0";
				$scope.totalParts="0";
				$scope.totalSalesTax="0";
				$scope.totalLaborDiscount="0";
				$scope.totalPartDiscount="0";
				$scope.totalDiscount="0";
				$scope.totalRefund="0";
				$scope.totalSales="0";
				var fromDate=$('#fromDate').val();
				
				$('.month').each(function(){
					$(this).removeClass('active');
					if($(this).attr('data-id')==id){
						$(this).addClass('active');	
					}
				});
				
				if(month<10){
					month="0"+month;
				}
				
				toDate=month+toDate.substr(2, 8);
				fromDate=month+fromDate.substr(2, 8);
				var year=$('#year').val();
				if(month==2){
					if(year%4==0){
						toDate=toDate.substr(0, 3)+29+toDate.substr(5, 5);
					}else{
						toDate=toDate.substr(0, 3)+28+toDate.substr(5, 5);
					}
				}
				if(month==4 || month==6  ||month==9 || month==11){
					toDate=toDate.substr(0, 3)+30+toDate.substr(5, 5);
				}
				if(month==1 || month==3  ||month==5 || month==7 || month==8 || month==10 || month==12){
					toDate=toDate.substr(0, 3)+31+toDate.substr(5, 5);
				}
				
				$('#toDate').val(toDate);
				$('#fromDate').val(fromDate);
				
				ajaxService.getSales(toDate,fromDate).then(function(promise) {
					$scope.map=promise.data;
					$scope.refundMap=$scope.map.refundMap;
					$scope.list=$scope.map.list;
					//console.log("Month"+$scope.refundMap);
					angular.forEach($scope.list, function(item) {
						$scope.totalLabor=Number($scope.totalLabor)+Number(item[2]);
						$scope.totalParts=Number($scope.totalParts)+Number(item[3]);
						$scope.totalSalesTax=Number($scope.totalSalesTax)+Number(item[4]);
						$scope.totalLaborDiscount=Number($scope.totalLaborDiscount)+Number(item[5]);
						$scope.totalPartDiscount=Number($scope.totalPartDiscount)+Number(item[6]);
						$scope.totalDiscount=Number($scope.totalDiscount)+Number(item[7]);
						$scope.totalSales=Number($scope.totalSales)+Number(item[8]);
						angular.forEach($scope.refundMap, function(value, key) {
							 if(key==item[1]){
								 $scope.refList.push(key);
								 $scope.totalRefund=Number($scope.totalRefund)+Number(value);
							 }
						});
					});
					$('#loadingimg').hide();
					$('#tableContent').show();
				});
				
			};
			
			$scope.getSalesEstimateByQtr=function(e){
				var id = $(e.currentTarget).attr("data-id");
				var qtr=Number(id);
				$('#loadingimg').show();
				$('#tableContent').hide();
				$scope.refList=[];
				$scope.currentPage = 0;
				$scope.totalLabor="0";
				$scope.totalParts="0";
				$scope.totalSalesTax="0";
				$scope.totalLaborDiscount="0";
				$scope.totalPartDiscount="0";
				$scope.totalDiscount="0";
				$scope.totalRefund="0";
				$scope.totalSales="0";
				$('.qtr').each(function(){
					$(this).removeClass('btn-success');
					$(this).addClass('btn-default');
					if($(this).attr('data-id')==id){
						$(this).addClass('btn-success');
						$(this).removeClass('btn-default');
					}
				});
				var fromDate = "";
				var toDate ="";
				var year=$('#year').val();
				if(qtr ==0){
					fromDate = "01/01/"+year;
					toDate = "03/31/"+year;
					
				}else if(qtr ==1){
					fromDate = "04/01/"+year;
					toDate =  "06/30/"+year;
				}else if(qtr ==2){
					fromDate = "07/01/"+year;
					toDate ="09/30/"+year;
				}else {
					fromDate ="10/01/"+year; 
					toDate ="12/31/"+year;
				}
					
				$('#toDate').val(toDate);
				$('#fromDate').val(fromDate);
				ajaxService.getSales(toDate,fromDate).then(function(promise) {
					$scope.map=promise.data;
					$scope.refundMap=$scope.map.refundMap;
					$scope.list=$scope.map.list;
					//console.log("Qtr"+$scope.refundMap);
					angular.forEach($scope.list, function(item) {
						$scope.totalLabor=Number($scope.totalLabor)+Number(item[2]);
						$scope.totalParts=Number($scope.totalParts)+Number(item[3]);
						$scope.totalSalesTax=Number($scope.totalSalesTax)+Number(item[4]);
						$scope.totalLaborDiscount=Number($scope.totalLaborDiscount)+Number(item[5]);
						$scope.totalPartDiscount=Number($scope.totalPartDiscount)+Number(item[6]);
						$scope.totalDiscount=Number($scope.totalDiscount)+Number(item[7]);
						$scope.totalSales=Number($scope.totalSales)+Number(item[8]);
						angular.forEach($scope.refundMap, function(value, key) {
							 if(key==item[1]){
								 $scope.refList.push(key);
								 $scope.totalRefund=Number($scope.totalRefund)+Number(value);
							 }
						});
					});
					$('#loadingimg').hide();
					$('#tableContent').show();
				});
				
			};
			
			
		$scope.exportData=function(){
			var fromDate = $("#fromDate").val();
			var toDate = $("#toDate").val();
			window.open("<%=path%>/salesReportsExport?fromDate="+fromDate+"&toDate="+toDate);
		};
		
		$scope.orderField=function(column){
			$scope.orderByField=column;
		};
//---------------------------Code for pagination -------------------------------
		$scope.range = function() {
				var rangeSize;
				if($scope.list.length < $scope.itemsPerPage){
					rangeSize = 1;
				}
				else if($scope.list.length > $scope.itemsPerPage*5){
					rangeSize = 5;
				}
				else if($scope.list.length > $scope.itemsPerPage*10){
					rangeSize=10;
				}
				else{
					rangeSize=2;
				}
			    //var rangeSize = 2;
			    var ret = [];
			    var start;

			    start = $scope.currentPage;
			    if ( start > $scope.pageCount()-rangeSize ) {
			      start = $scope.pageCount()-rangeSize+1;
			    }
				if(start<0){
					start=0;
				}
			    for (var i=start; i<start+rangeSize; i++) {
			      ret.push(i);
			    }
			    return ret;
		};

		  $scope.prevPage = function() {
		    if ($scope.currentPage > 0) {
		      $scope.currentPage--;
		    }
		  };

		  $scope.prevPageDisabled = function() {
		    return $scope.currentPage === 0 ? "disabled" : "";
		  };

		  $scope.pageCount = function() {
		    return Math.ceil($scope.list.length/$scope.itemsPerPage)-1;
		  };

		  $scope.nextPage = function() {
		    if ($scope.currentPage < $scope.pageCount()) {
		      $scope.currentPage++;
		    }
		  };

		  $scope.nextPageDisabled = function() {
		    return $scope.currentPage === $scope.pageCount() ? "disabled" : "";
		  };

		  $scope.setPage = function(n) {
		    $scope.currentPage = n;
		  };
	 	
//---------------------------End pagination code---------------------------------
		});
			</script>
</head>
<body ng-app="salesApp" ng-controller="salesCtrl" data-ng-init="getSalesEstimate()">
	<div class="fluid-container">
		<jsp:include page="salesMain.jsp"></jsp:include>
		<div class="form-group" style="margin-top: -9px;margin-left: 2px;">
				<div class="panel panel-primary" style="min-height: 500px;">
					<div class="panel-heading">
						<div class="panel-title">Sales</div>
					</div>
					<div class="panel-body">
						<div>
							<ul class="nav nav-tabs" id="showReport" >
					        	<li data-id="month" onclick="showReport(this)" class="active"><a href="#">Monthly</a></li>
					        	<li data-id="date" onclick="showReport(this)"><a href="#">Date Range</a></li>
					        	<li data-id="qtr" onclick="showReport(this)"><a href="#">Quarterly</a></li>
					        </ul>
					    </div>
						<div id="monthDiv" style="margin-top: 15px;margin-bottom: 65px;" >
							<div style="display: inline-table;position: absolute;margin-top: -9px;" > 
								<span style="font-size:17px;">Year</span> 
							      <span>
									 <select id="year" name="2016" ng-change="getSalesEstimate(year)" ng-model="year" style="border:1px solid #ddd;width:68px;height:42px;margin-top: 5px;">
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
							<div class="col-sm-7" id="horizMonth" style="top: -5px;margin-left: 100px;"> 
						      <ul class="nav nav-tabs">
						        <li data-id="0" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Jan</a></li>
						        <li data-id="1" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Feb</a></li>
						        <li data-id="2" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Mar</a></li>
						        <li data-id="3" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Apr</a></li>
						        <li data-id="4" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">May</a></li>
						        <li data-id="5" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Jun</a></li>
						        <li data-id="6" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Jul</a></li>
						        <li data-id="7" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Aug</a></li>
						        <li data-id="8" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Sep</a></li>
						        <li data-id="9" ng-click="getSalesEstimateByMonth($event)" class="month" ><a href="#">Oct</a></li>
						        <li data-id="10" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Nov</a></li>
						        <li data-id="11" ng-click="getSalesEstimateByMonth($event)" class="month"><a href="#">Dec</a></li>
						      </ul>
						    </div>
						    <div class="col-sm-3" id="exportDiv"> 
								<button   ng-click="exportData();" style="margin-left: 10px;" class="btn btn-primary"  >
									<i class="glyphicon glyphicon-download-alt"></i>&nbsp;Export
								</button>
								<button   onclick="printSales()" style="margin-left: 10px;" class="btn btn-primary"  >
									<i class="glyphicon glyphicon-print"></i>&nbsp;Print
								</button>
							 </div>
						   
						</div>
					    <div class="col-sm-10" id="qtrly" style="margin-left: -15px;display: none;margin-bottom: 10px;margin-top: -47px;" >
					    	<button class="btn btn-default qtr" data-id="0" ng-click="getSalesEstimateByQtr($event)" >Q1: Jan-Mar</button> 
					        <button class="btn btn-default qtr" data-id="1" ng-click="getSalesEstimateByQtr($event)" >Q2: Apr-Jun</button> 
					        <button class="btn btn-default qtr" data-id="2" ng-click="getSalesEstimateByQtr($event)" >Q3: Jul-Sep</button> 
					        <button class="btn btn-default qtr" data-id="3" ng-click="getSalesEstimateByQtr($event)" >Q4: Oct-Dec</button>
					        <span>
								<button   ng-click="exportData();" style="margin-left: 10px;" class="btn btn-primary"  >
									<i class="glyphicon glyphicon-download-alt"></i>&nbsp;Export
								</button>
							</span>
							<span>
								<button   onclick="printSales()" style="margin-left: 10px;" class="btn btn-primary"  >
									<i class="glyphicon glyphicon-print"></i>&nbsp;Print
								</button>
							</span> 
					    </div>
					    <div style="margin-top: 15px;display: inline-flex;display: none;" id="dateDiv" >
							<span style="margin-left: 2px;font-size: 13.5px;color: #000;height: 24px;padding: 5px;font-weight: bold;" >From Date</span>
							<div class='input-group date' id="fromDateSpan" style="width: 156px;"> 
								<input type="text" class="form-control"  name="fromDate" style="width: 120px;margin-left: 0px;padding-left: 4px;" id="fromDate"  ng-modal="fromDate"  />
								<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
							</div>
							<span style="margin-left: 10px;font-size: 13.5px;color: #000;height: 24px;padding: 5px;font-weight: bold;">To Date</span>
							<div class='input-group date' id="toDateSpan" style="width: 156px;">
								<input type="text"  name="toDate" class="form-control " id="toDate" style="width:120px;margin-left: 0px;padding-left: 4px;"  ng-modal="toDate"  />
								<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
							</div>
							<span>
								<input type="button"  ng-click="getSalesEstimate(year);" style="margin-left: 10px;" class="btn btn-primary" value="Search" />
							</span>
							<span>
								<button   ng-click="exportData();" style="margin-left: 10px;" class="btn btn-primary"  >
									<i class="glyphicon glyphicon-download-alt"></i>&nbsp;Export
								</button>
							</span>
							<span>
								<button   onclick="printSales()" style="margin-left: 10px;" class="btn btn-primary"  >
									<i class="glyphicon glyphicon-print"></i>&nbsp;Print
								</button>
							</span>
						</div>
						<div class="loading-spiner" id="loadingimg" style="margin: 80px 0px 0px; text-align: center;display: none;">
							<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
	  					</div>
						<div id="tableContent" style="display: none;">
							<table class="table table-bordered item" style="margin-top: 12px;" id="table">
								<thead style="background-color: #337ab7;color:white;">
									  <tr style="font-size: 12px;"> 
										<th style="width: 10%;cursor: pointer;" nowrap="nowrap" ng-click="orderByField='0'; reverseSort = !reverseSort" > Date<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '0', 'glyphicon-chevron-up' : orderProperty == '0' }"></span></th>
										<th style="width: 7%;cursor: pointer;" nowrap="nowrap"  ng-click="orderByField='1'; reverseSort = !reverseSort">Inv#<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '1', 'glyphicon-chevron-up' : orderProperty == '1' }"></span></th>
										<th style="width: 7%;cursor: pointer;" nowrap="nowrap" ng-click="orderByField='9'; reverseSort = !reverseSort">Doc#<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '9', 'glyphicon-chevron-up' : orderProperty == '9' }"></span></th>
										<th  style="width: 7%;cursor: pointer;" nowrap="nowrap"  ng-click="orderByField='2'; reverseSort = !reverseSort">Labor($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '2', 'glyphicon-chevron-up' : orderProperty == '2' }"></span></th>
										<th  style="width: 9%;cursor: pointer;" nowrap="nowrap" ng-click="orderByField='3'; reverseSort = !reverseSort">Parts($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '3', 'glyphicon-chevron-up' : orderProperty == '3' }"></span></th>
										<th style="width: 8%;cursor: pointer;" nowrap="nowrap" ng-click="orderByField='4'; reverseSort = !reverseSort">Sales Tax($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '4', 'glyphicon-chevron-up' : orderProperty == '4' }"></span></th>
										<th style="width: 10%;cursor: pointer;" nowrap="nowrap"  ng-click="orderByField='5'; reverseSort = !reverseSort">Labor Discount($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '5', 'glyphicon-chevron-up' : orderProperty == '5' }"></span></th>
										<th  style="width: 10%;cursor: pointer;" nowrap="nowrap"  ng-click="orderByField='6'; reverseSort = !reverseSort">Parts Discount($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '6', 'glyphicon-chevron-up' : orderProperty == '6' }"></span></th>
										<th  style="width: 10%;cursor: pointer;" nowrap="nowrap" ng-click="orderByField='7'; reverseSort = !reverseSort">Total Discount($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '7', 'glyphicon-chevron-up' : orderProperty == '7' }"></span></th>
										<th style="width: 7%;text-align: right;cursor: pointer;" nowrap="nowrap"  class="asc" eq="9" onclick="sortColumn(this)" >Refund($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '8', 'glyphicon-chevron-up' : orderProperty == '8' }"></span></th>
										<th style="width: 8%;cursor: pointer;"  nowrap="nowrap" ng-click="orderByField='8'; reverseSort = !reverseSort">Total Sale($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '8', 'glyphicon-chevron-up' : orderProperty == '8' }"></span></th>
										<th style="width: 11%;cursor: pointer;"  nowrap="nowrap" ng-click="orderByField='8'; reverseSort = !reverseSort">Net Sale($)<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '8', 'glyphicon-chevron-up' : orderProperty == '8' }"></span></th>
									  </tr>
								  </thead>
								  <tbody >
								  		<tr ng-if="list!=null" ng-repeat="item in list | offset: currentPage*itemsPerPage | limitTo: itemsPerPage |orderBy:orderByField:reverseSort " >
								  			<td >{{item[0] |date :'MMM dd, yyyy'}}</td>
								  			<td  style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[1] }}</td>
								  			<td  style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[9] }}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[2] |currency}}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[3] |currency}}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[4] |currency}}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[5] |currency}}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[6] |currency}}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[7] |currency}}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
								  				<span ng-repeat="(key,value) in refundMap" >
								  					<span ng-if="key==item[1]">{{value!=null?value:"0" |currency}}</span>
								  				</span>
								  				<span ng-if="refList.indexOf(item[1].toString())==-1">{{"0" |currency}}</span>
								  			</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[8] |currency}}</td>
								  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[8]-item[4] |currency}}</td>
								  		</tr>
								  		<tr ng-if="list==null" >
								  			<td colspan="11" style="color: red;text-align: center;font-size: 15px;font-weight: 600;">No Record Found</td>
								  		</tr>
								  </tbody>
								  <tfoot>
									<tr ng-if="list!=null" list="{{list}}" >
								  		<td style="text-align: right;" colspan="3"><b>Total</b></td>
								  		<td style="text-align: right;"><b>{{totalLabor|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalParts|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalSalesTax|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalLaborDiscount|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalPartDiscount|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalDiscount|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalRefund|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalSales-totalRefund|currency}}</b></td>
								  		<td style="text-align: right;"><b>{{totalSales-totalRefund-totalSalesTax|currency}}</b></td>
								  	</tr>
								  	<tr id="paginationRow" ng-if="list!=null">
							          <td colspan="15">
								          <div  style="text-align: center;">
								            <ul class="pagination pagination-lg">
								              <li ng-class="prevPageDisabled()">
								                <a href ng-click="prevPage()">« Prev</a>
								              </li>
								              <li ng-repeat="n in range()" ng-class="{active: n == currentPage}" ng-click="setPage(n)">
								                <a href="#" {{count=n+1}}>{{n+1}}</a>
								              </li>
								              <li ng-class="nextPageDisabled()">
								                <a href ng-click="nextPage()">Next »</a>
								              </li>
								              
								            </ul>
								          </div>
							          </td>
							        </tr>
								  	
								  </tfoot>
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
		$('.month').each(function(){
			if($(this).attr('data-id')==<%=month%>){
				$(this).addClass('active');	
			}
		});
		
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
		//alert(id);
		if(id == "sales"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
</script>

<script type="text/javascript">
	function printSales(){
		var oldPage = document.body.innerHTML;
		$('#paginationRow').hide();
		var printDiv=$("#tableContent").html();
		$(document.body).html("<html><head><title></title></head><body>"+printDiv+"</body></html>"); 
		window.print();
		$(document.body).html(oldPage);
		$('#paginationRow').show();
		location.reload();
	}
	
	function showReport(that){
		var clas=$(that).attr('data-id');
		$('#showReport').find('li').each(function(){
			$(this).removeClass('active');
		});
		$(that).addClass('active');
		if(clas=="month"){
			$('#horizMonth').show();
			$('#exportDiv').show();
			$('#monthDiv').show();
			$('#dateDiv').hide();
			$('#qtrly').hide();
		}else if(clas=="date"){
			$('#monthDiv').hide();
			$('#dateDiv').css('display','flex');
			$('#qtrly').hide();
		}else{
			$('#horizMonth').hide();
			$('#monthDiv').show();
			$('#exportDiv').hide();
			$('#dateDiv').hide();
			$('#qtrly').show();
			$('#qtrly').css('margin-left', '120px');
		}
	}
	
	
</script>
<script type="text/javascript">
	 function sortColumn(that){
		var eq=$(that).attr('eq');
		var ascDesc=$(that).attr('class');
		$(that).parent().parent().next().find('tr').each(function(){ 
		    var tdold = $(this).find('td:eq("'+eq+'")').text().trim(); 
		    $(that).parent().parent().next().find('tr').each(function(){ 
			    var tdnew = $(this).find('td:eq("'+eq+'")').text().trim(); 
			       if(ascDesc=='asc'){
			    	   if(tdold!=""){
					       if(tdold > tdnew){
					    	   var newRow= $(this).html();
					    	   var oldRow= $(this).prev().html();
					    	   $(this).prev().html(newRow);
					    	   $(this).html(oldRow);
					       }
			    	   }
			       }
			       if(ascDesc=='desc'){
			    	   if(tdold!=""){
				    	   if(tdold < tdnew){
					    	   var newRow= $(this).html();
					    	   var oldRow= $(this).prev().html();
					    	   $(this).prev().html(newRow);
					    	   $(this).html(oldRow);
					    	   
					       }
			    	   }
			       }
		    });
		});
		if(ascDesc=='asc'){
			$(that).addClass('desc');
			$(that).removeClass('asc');
		}else{
			$(that).addClass('asc');
			$(that).removeClass('desc');
		}
	}  
</script>
</html>