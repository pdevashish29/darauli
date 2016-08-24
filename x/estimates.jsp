<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	Date date = new Date();
	int month = date.getMonth();
	int year = date.getYear();
	int dat = date.getDate();
	year = year + 1900;
	SimpleDateFormat format = new SimpleDateFormat("MM/dd/YYYY");
	Calendar c = Calendar.getInstance();
	c.set(year, month, 1);
	c.set(Calendar.DAY_OF_MONTH,
			c.getActualMaximum(Calendar.DAY_OF_MONTH));
	String toDate = format.format(c.getTime());
	String fromDate = (month + 1) + "/" + 01 + "/" + year;
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
<script type="text/javascript"
	src="<%=path%>/resources/js/kendo.all.min.js"></script>
<link rel="stylesheet"
	href="<%=path%>/resources/css/bootstrap-datetimepicker.css"
	style="text/css">
<script type="text/javascript"
	src="<%=path%>/resources/js/moment-with-locales.js"></script>
<script type="text/javascript"
	src="<%=path%>/resources/js/bootstrap-datetimepicker.js"></script>




<script type="text/javascript">
var app = angular.module('dailyApp', []);


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
	   /*  console.log(input+"-----"+start); */
	    return input.slice(start);
	  };
});


app.filter('toArray', function() { return function(obj) {
    if (!(obj instanceof Object)) return obj;
    return _.map(obj, function(val, key) {
        return Object.defineProperty(val, '$key', {__proto__: null, value: key});
    });
}});

app.factory('ajaxService', ['$http', '$q', function ($http, $q) {
	var urlBase="<%=path%>";
	  return {
		 		 getEstimatePendingReportMonthly : function(year,month){
			 	 return $http({method:'GET', url:urlBase+'/estimatePendingReportMonthly?year='+year+'&month='+month})
			    .then(
			    function (response) {/*  alert(JSON.stringify(response.data)); */
			      return response.data;
			    },
			    function (err) {
			      return $q.reject(err);
			    });
		  },
		  
		  // end of  report factory function 
		  getReportByDateRange : function(fromDate,toDate){
  				return $http({method :'GET',url :urlBase+'/estimatePendingReportMonthly?fromDate='+fromDate+'&toDate='+toDate+''})
  				.then(
  				function(response){
  					return response.data;
  					},
  				function(err){
  					return $q.reject(err);
  			});
  			
  			},
  		  // end of  report factory function 
  		  getReportQuarterly : function(quarter,year){
				return $http({method :'GET',url :urlBase+'/estimatePendingReportMonthly?quater='+quarter+'&year='+year})
				.then(
				function(response){
					return response.data;
					},
				function(err){
					return $q.reject(err);
			});
			
			},
  		  // end of  report factory function 
  		  
  		  getReportInExcelByCriteria : function(year, month){
  			  return $http({method:'GET',url:urlBase+'/estimatePendingExportToExcel?year='+year+'&month='+month})
  			  .then(
  				function(response){
  					
  					return response.data;
  				},
  				function(err){
  					return $q.reject(err);
  				});
  			  
  		  }
			 // end of  report factory function  
			 
	  }
		 
}]);
 
//END OF FACTORY
 
 
 
 app.controller('dailyCtrl', function ($scope,ajaxService,graphFactory) {
	 	$scope.monthArray=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
	 	//$scope.yearItems=[2011,2012,2013,2014,2015,2016,2017,2018,2019,2020];
	 	var urlBase="<%=path%>";
		$scope.month='<%=month%>';
		$scope.year='<%=year%>';
		$scope.quarter='';
		$scope.fromDate='<%=fromDate%>';
		$scope.toDate='<%=toDate%>';
		
		$scope.estimateList=[];
		$scope.totalLaborSum=0;
		$scope.totalPartSum=0;
		$scope.totalTaxSum=0;
		$scope.totalDisSum=0;
		$scope.totalSaleSum=0;
		
		$scope.quarter=0;
		$scope.reportFooter='';
		
		
		$scope.itemsPerPage = 10;
		$scope.currentPage = 0;
		
		$('#loadingimg').show();
		$("#paginationRow").css("display","none");
		$("#tableContent").css("display","none");
		
		ajaxService.getEstimatePendingReportMonthly($scope.year,$scope.month).then(function(data){
				$scope.estimateList=data.estimateList;
				$scope.reportFooter=data.reportFooterString;
				$("#paginationRow").show();
				$('#loadingimg').hide();
				$("#tableContent").show();
				angular.forEach($scope.estimateList,function(value,key){
					$scope.totalLaborSum +=value[2];
					$scope.totalPartSum+=value[3];
		    		$scope.totalTaxSum+=value[4];
		    		$scope.totalDisSum+=value[8];
		    		$scope.totalSaleSum+=value[5];
					
				});
				
				 $("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
					});
					$("li#horizmonth"+($scope.month)).addClass('active').css;
					
					
		});
		// end of first time invokeeesss
		
		
		
	 	$scope.getEstimatePendingReportMonthly=function(data){
	 			
	 			$scope.estimateList=[];
			 	$scope.month=data;
		
				$scope.totalLaborSum=0;
				$scope.totalPartSum=0;
				$scope.totalTaxSum=0;
				$scope.totalDisSum=0;
				$scope.totalSaleSum=0;
		
				
				$('#loadingimg').show();
				$("#paginationRow").css("display","none");
				$("#tableContent").css("display","none");
				$("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
					});
				$("li#horizmonth"+($scope.month)).addClass('active');
					
				
				
		ajaxService.getEstimatePendingReportMonthly($scope.year,$scope.month).then(function(data) {
		$scope.estimateList=data.estimateList;
		$scope.reportFooter=data.reportFooterString;
		
		$("#paginationRow").show();
		$('#loadingimg').hide();
		$("#tableContent").show();
		
		angular.forEach($scope.estimateList, function(value, key){
				$scope.totalLaborSum +=value[2];
				$scope.totalPartSum+=value[3];
	    		$scope.totalTaxSum+=value[4];
	    		$scope.totalDisSum+=value[8];
	    		$scope.totalSaleSum+=value[5];
			});
			
		});
};


		$scope.getReportByDateRange= function(){
			$scope.estimateList=[];
			
			$scope.totalLaborSum=0;
			$scope.totalPartSum=0;
			$scope.totalTaxSum=0;
			$scope.totalDisSum=0;
			$scope.totalSaleSum=0;
			
			var fromDate=$('input#fromDate').val();
			var toDate=$('input#toDate').val();
		
			$('#loadingimg').show();
			$("#paginationRow").css("display","none");
			$("#tableContent").css("display","none");
			
			
			ajaxService.getReportByDateRange(fromDate,toDate).then(function(data){
				$scope.estimateList=data.estimateList;
				$scope.reportFooter=data.reportFooterString;
				
				$("#paginationRow").show();
				$('#loadingimg').hide();
				$("#tableContent").show();
				
				
				angular.forEach($scope.estimateList, function(value, key){
						$scope.totalLaborSum +=value[2];
						$scope.totalPartSum+=value[3];
			    		$scope.totalTaxSum+=value[4];
			    		$scope.totalDisSum+=value[8];
			    		$scope.totalSaleSum+=value[5];
				});
				
				 $("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
					});
					$("li#horizmonth"+($scope.month)).addClass('active').css;
				
				
				
			});
			
		};
		
		// end of above function
		$scope.getReportQuarterly=function(quarter){
			$scope.estimateList=[];
			
				$scope.totalLaborSum=0;
				$scope.totalPartSum=0;
				$scope.totalTaxSum=0;
				$scope.totalDisSum=0;
				$scope.totalSaleSum=0;
				
				$scope.quarter=quarter;
				
				
				$('#loadingimg').show();
				$("#paginationRow").css("display","none");
				$("#tableContent").css("display","none");
				
				 $("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
				});
				$("li#horizmonth"+($scope.month)).addClass('active').css
				
				$('.qtr').each(function(){
					$(this).removeClass('btn-primary');
					$(this).addClass('btn-default');
					if($(this).attr('data-id')==quarter){
						$(this).addClass('btn-primary');
						$(this).removeClass('btn-default');
					}
				});
				
				
				
			ajaxService.getReportQuarterly(quarter,$scope.year).then(function(data){
				$scope.estimateList=data.estimateList;
				$scope.reportFooter=data.reportFooterString;
				
				$("#paginationRow").show();
				$('#loadingimg').hide();
				$("#tableContent").show();
				
				
				angular.forEach($scope.estimateList, function(value, key){
					$scope.totalLaborSum +=value[2];
					$scope.totalPartSum+=value[3];
		    		$scope.totalTaxSum+=value[4];
		    		$scope.totalDisSum+=value[8];
		    		$scope.totalSaleSum+=value[5];
			});
				
			;
					
					
						
					 
			});
			
			
		};		// end of above function
		
		
		
		$scope.onYearChange=function(){
			$scope.estimateList=[];
				$scope.totalLaborSum=0;
				$scope.totalPartSum=0;
				$scope.totalTaxSum=0;
				$scope.totalDisSum=0;
				$scope.totalSaleSum=0;
				
				$('#loadingimg').show();
				$("#paginationRow").css("display","none");
				$("#tableContent").css("display","none");
				
				
			ajaxService.getEstimatePendingReportMonthly($scope.year,$scope.month).then(function(data){
				$scope.estimateList=data.estimateList;
				$scope.reportFooter=data.reportFooterString;
				
				$("#paginationRow").show();
				$('#loadingimg').hide();
				$("#tableContent").show();
				
				angular.forEach($scope.estimateList, function(value, key){
							$scope.totalLaborSum +=value[2];
							$scope.totalPartSum+=value[3];
				    		$scope.totalTaxSum+=value[4];
				    		$scope.totalDisSum+=value[8];
				    		$scope.totalSaleSum+=value[5];
						});
			});
			
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
			
		};
		
		// end of above function
		
		$scope.getReportInExcelMonthly= function(){
	
			window.open(urlBase+'/estimatePendingExportToExcel?year='+$scope.year+'&month='+$scope.month);
			
		};
		// end of above function
		
		$scope.getReportInExcelByDateRange= function(){
			
			var fromDate=$('input#fromDate').val();
			var toDate=$('input#toDate').val();
			
			window.open(urlBase+'/estimatePendingExportToExcel?fromDate='+fromDate+'&toDate='+toDate);
		};
		
		
		// end of above function
		
				
		
	$scope.getReportInExcelQuarterly= function(){
			
			window.open(urlBase+'/estimatePendingExportToExcel?quater='+$scope.quarter+'&year='+$scope.year);
			
			
		};
		
		
		// end of above function
		
		  //---------------------------Code for pagination -------------------------------
		$scope.range = function() {
				var rangeSize;
				if($scope.estimateList.length < $scope.itemsPerPage){
					rangeSize = 1;
				}
				else if($scope.estimateList.length > $scope.itemsPerPage*5){
					rangeSize = 5;
				}
				else if($scope.estimateList.length > $scope.itemsPerPage*10){
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
	    return Math.ceil($scope.estimateList.length/$scope.itemsPerPage)-1;
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

	
			$scope.printSale = function(printSectionId) {
			        var innerContents = document.getElementById(printSectionId).innerHTML;
			        var popupWinindow = window.open();
			        popupWinindow.document.open();
			        popupWinindow.document.write('<html><head></head><body onload="window.print()">' + innerContents + '</body></html>');
			        popupWinindow.document.close();
			      };
			
		
 });
 

 </script>
<style>
@media print {
	#header,#footer,#nav {
		display: none !important;
	}
	table {
		width: 500px;
	}
	.no-print,.no-print * {
		display: none !important;
	}
}
</style>
</head>
<body ng-app="dailyApp" ng-controller="dailyCtrl">
	<div class="fluid-container">
		<div class="no-print">
			<jsp:include page="salesMain.jsp">
				<jsp:param name="year" value="{{year}}" />
			</jsp:include>
		</div>
		<div class="form-group" style="margin-top: -9px; margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Sales</div>

				</div>
				<div class="panel-body">

					<ul class="nav nav-tabs no-print ">
						<li class="active"><a data-toggle="tab" href="#home">Monthly</a></li>
						<li><a data-toggle="tab" href="#menu1">Date Range</a></li>
						<li><a data-toggle="tab" href="#menu2">Quarterly</a></li>
					</ul>

					<div class="tab-content no-print" style="margin-bottom: -15px;">
						<div id="home" class="tab-pane fade in active"
							style="margin-bottom: 10px">
							<table width="100%" border="0" cellspacing="0" class="no-print">
								<tr>
									<td><span style="font-size: 17px;">Year</span> <span>
											<select id="year" ng-model="year" ng-change="onYearChange()"
											style="width: 68px; height: 34px; margin-top: 5px;">
												<%
													for (int i = year - 5; i < year + 5; i++) {
												%>
												<option id="<%=i%>"><%=i%></option>
												<%
													}
												%>
												<!-- 		<option ng-selected="item == {{year}}" ng-repeat="item in yearItems" id="{{item}}" value="{{item}}">{{item}}</option> -->
										</select>
									</span></td>
									<td style="margin-left: 2px" width="80%">
										<ul class="nav nav-tabs horizon"
											style="margin-top: 2px; margin-bottom: 0px; float: left; margin-left: 2px">
											<li class="horizmonth0" id="horizmonth0"
												ng-click="getEstimatePendingReportMonthly(0)"><a
												href="#">Jan</a></li>
											<li class="horizmonth1" id="horizmonth1"
												ng-click="getEstimatePendingReportMonthly(1)"><a
												href="#">Feb</a></li>
											<li class="horizmonth2" id="horizmonth2"
												ng-click="getEstimatePendingReportMonthly(2)"><a
												href="#">Mar</a></li>
											<li class="horizmonth3" id="horizmonth3"
												ng-click="getEstimatePendingReportMonthly(3)"><a
												href="#">Apr</a></li>
											<li class="horizmonth4" id="horizmonth4"
												ng-click="getEstimatePendingReportMonthly(4)"><a
												href="#">May</a></li>
											<li class="horizmonth5" id="horizmonth5"
												ng-click="getEstimatePendingReportMonthly(5)"><a
												href="#">Jun</a></li>
											<li class="horizmonth6" id="horizmonth6"
												ng-click="getEstimatePendingReportMonthly(6)"><a
												href="#">Jul</a></li>
											<li class="horizmonth7" id="horizmonth7"
												ng-click="getEstimatePendingReportMonthly(7)"><a
												href="#">Aug</a></li>
											<li class="horizmonth8" id="horizmonth8"
												ng-click="getEstimatePendingReportMonthly(8)"><a
												href="#">Sep</a></li>
											<li class="horizmonth9" id="horizmonth9"
												ng-click="getEstimatePendingReportMonthly(9)"><a
												href="#">Oct</a></li>
											<li class="horizmonth10" id="horizmonth10"
												ng-click="getEstimatePendingReportMonthly(10)"><a
												href="#">Nov</a></li>
											<li class="horizmonth11" id="horizmonth11"
												ng-click="getEstimatePendingReportMonthly(11)"><a
												href="#">Dec</a></li>
										</ul>
									</td>
									<td><span style="margin-left: -44px;"><input
											type="button" ng-click="getReportInExcelMonthly()"
											style="width: 68px; height: 34px; margin-top: 5px;"
											class="btn btn-primary" value="Export" /></span></td>

									<td><span><input type="button"
											onclick="window.print()"
											style="width: 68px; height: 34px; margin-top: 5px;"
											class="btn btn-primary" value="Print" /></span></td>
								</tr>
							</table>



						</div>
						<div id="menu1" class="tab-pane fade" style="margin-top: 10px;">


							<div class="row">
								<div class="col-sm-10">

									<div style="margin-top: 15px; display: inline-flex;">
										<span
											style="margin-left: 2px; font-size: 13.5px; color: #000; height: 24px; padding: 5px; font-weight: bold;">From
											Date</span>
										<div class='input-group date' id="fromDateSpan"
											style="width: 156px;">
											<input type="text" class="form-control" name="fromDate"
												style="width: 120px; margin-left: 0px; padding-left: 4px;"
												id="fromDate" ng-modal="fromDate" /> <span
												class="input-group-addon"><span
												class="glyphicon glyphicon-calendar"></span></span>
										</div>
										<span
											style="margin-left: 10px; font-size: 13.5px; color: #000; height: 24px; padding: 5px; font-weight: bold;">To
											Date</span>
										<div class='input-group date' id="toDateSpan"
											style="width: 156px;">
											<input type="text" name="toDate" class="form-control "
												id="toDate"
												style="width: 120px; margin-left: 0px; padding-left: 4px;"
												ng-modal="toDate" /> <span class="input-group-addon"><span
												class="glyphicon glyphicon-calendar"></span></span>
										</div>
										<span><input type="button"
											ng-click="getReportByDateRange()" style="margin-left: 10px;"
											class="btn btn-primary" value="Search" /></span>
									</div>


								</div>
								<div class="col-sm-2" style="margin-top: 8px">
									<span><input type="button"
										ng-click="getReportInExcelByDateRange()"
										style="width: 68px; height: 34px; margin-top: 5px;"
										class="btn btn-primary" value="Export" /></span> <span><input
										type="button" onclick="window.print()"
										style="width: 68px; height: 34px; margin-top: 5px; margin-right: -30px"
										class="btn btn-primary" value="Print" /></span>


								</div>

							</div>
						</div>




						<div id="menu2" class="tab-pane fade" style="margin-top: 10px;">

							<div class="row">

								<div class="col-sm-10" style="margin-top: 5px;">

									<span style="font-size: 17px;float: left;margin-top: 6px;">Year</span> 
									<span style="float: left;margin: -5px 8px 0px 6px;"> <select
										id="year" ng-model="year" ng-change="onYearChange()"
										style="width: 68px; height: 34px; margin-top: 5px;">
											<%
												for (int i = year - 5; i < year + 5; i++) {
											%>
											<option id="<%=i%>"><%=i%></option>
											<%
												}
											%>
											<!-- 		<option ng-selected="item == {{year}}" ng-repeat="item in yearItems" id="{{item}}" value="{{item}}">{{item}}</option> -->
									</select>
									</span>


							<div >
							<button class="btn btn-default qtr" data-id="1" ng-click="getReportQuarterly(1)" >Q1: Jan-Mar</button> 
					        <button class="btn btn-default qtr" data-id="2" ng-click="getReportQuarterly(2)" >Q2: Apr-Jun</button> 
					        <button class="btn btn-default qtr" data-id="3" ng-click="getReportQuarterly(3)" >Q3: Jul-Sep</button> 
					        <button class="btn btn-default qtr" data-id="4" ng-click="getReportQuarterly(4)" >Q4: Oct-Dec</button>
					       </div>
							
							
							<!-- 
									<div id="qtrly">
										<button class=" btn btn-default qtr" data-id="0"
											style="width: 100px;; height: 34px;" name="Q1" id="quarterly"
											value=1; ng-model="quarter" ng-click="getReportQuarterly(1)">Q1:
											Jan-Mar</button>
										<button class=" btn btn-default qtr" data-id="1"
											style="width: 100px;; height: 34px;" name="Q2" id="quarterly"
											ng-click="getReportQuarterly(2)">Q2: Apr-Jun</button>
										<button btn btn-default qtr" data-id="2"
											style="width: 100x;; height: 34px;" name="Q3" id="quarterly"
											ng-click="getReportQuarterly(3)">Q3: Jul-Sep</button>
										<button btn btn-default qtr" data-id="3"
											style="width: 100px;; height: 34px;" name="Q4" id="quarterly"
											ng-click="getReportQuarterly(4)">Q4: Oct-Dec</button>
									</div>
 -->

								</div>
								<div class="col-sm-2">
									<span><input type="button"
										ng-click="getReportInExcelQuarterly()"
										style="width: 68px; height: 34px; margin-top: 5px;"
										class="btn btn-primary" value="Export" /></span> <span><input
										type="button" onclick="window.print()"
										style="width: 68px; height: 34px; margin-top: 5px; margin-right: -30px"
										class="btn btn-primary" value="Print" /></span>
								</div>
							</div>
						</div>





					</div>
					<!--  end  of content  -->
					<div class="form-group">
						<div class="loading-spiner" id="loadingimg"
							style="margin: 50px 50px 0px 0px; display: block; margin-bottom: 50px">
							<img src="<%=path%>/resources/image/gif-load.gif"
								style="margin-left: 584px; margin-top: -16px; position: absolute;" />
						</div>
					</div>
					
					<div class="col-sm-10" id ="col-sm10walatable">
					
					</div>
					<div class="tableData" id="tableContent" style="margin-top: 20px">


						<table class="table  table-bordered "  style="margin-top: 30px;"
							border="0" cellspacing="0" cell>
							<thead style="background-color: #337ab7; color: white;">
								<tr>
									<th ng-click="orderByField='[0]'; reverseSort = !reverseSort"
										width="8%" nowrap="nowrap">Date</th>
									<th ng-click="orderByField='[1]'; reverseSort = !reverseSort"
										width="5%" nowrap="nowrap" style="text-align: right;">Estimate#</th>
									<th ng-click="orderByField='[2]'; reverseSort = !reverseSort"
										width="5%" nowrap="nowrap" style="text-align: right;">Doc#</th>
									<th ng-click="orderByField='[3]'; reverseSort = !reverseSort"
										width="20%" nowrap="nowrap" style="text-align: left;"
										class="nosort"><b style="font-size: 12px;">Customer</b>

										<th ng-click="orderByField='[4]'; reverseSort = !reverseSort"
										width="10%" nowrap="nowrap" style="text-align: right;">Labor
										$</th>
									<th ng-click="orderByField='[5]'; reverseSort = !reverseSort"
										width="10%" nowrap="nowrap" style="text-align:right;">Parts $</th>
									<th ng-click="orderByField='[6]'; reverseSort = !reverseSort"
										width="10%" nowrap="nowrap" style="text-align:right;">Sale Tax $</th>
									<th ng-click="orderByField='[7]'; reverseSort = !reverseSort"
										width="10%" nowrap="nowrap" style=text-align:right;">Discount $</th>
									
									
									<th ng-click="orderByField='[8]'; reverseSort = !reverseSort"
										width="10%" nowrap="nowrap" style="text-align: right;">Total Sale  $</th>
								 </tr>
							  </thead>
							  <tbody>
							  
							<tr id="tableData  id ="example"
									ng-repeat="item in estimateList | filter:searchText | offset: currentPage*itemsPerPage | limitTo: itemsPerPage |orderBy:orderByField:reverseSort"" >
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[0] |dateFormat:item[0]}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[1]}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[9]}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: left;">{{item[6]}} <br> {{item[7]}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[2] | number:2}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[3] | number:2}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[4] | number:2}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[8] | number:2}}</td>
								<td
										style="vertical-align: top;padding-left: 10px;text-align: right;">{{item[5] | number:2}}</td>
							</tr>
							<tr ng-if="estimateList.length>0">
							
								 	<td colspan="4"
										style="text-align: right;font-weight: bold; font-size: 14px; "> {{reportFooter}} </td>
									<td width="10%"
										style="text-align: right;font-weight: bold;font-size: 14px;">  {{totalLaborSum |currency}}</td>
									<td
										style="text-align: right;font-weight: bold;font-size: 14px;">  {{totalPartSum  |currency}}</td>
									<td
										style="text-align: right;font-weight: bold;font-size: 14px;"> {{totalTaxSum |currency}} </td>
									<td
										style="text-align: right;font-weight: bold;font-size: 14px;">  {{totalDisSum|currency}}</td>
									<td id="totalSaleid"
										style="text-align: right;font-weight: bold;font-size: 14px;"> {{totalSaleSum |currency}}</td>
							
							<!-- width: 5%;  position: relative;text-align: -webkit-left;font-size: 12px; padding-left: 6px; -->
							
							</tr>
							  
							<tr ng-if="estimateList.length==0" ng-show="true">
								<td colspan="9"
										style="color: red; font-size: 16px; font-weight: bold; text-align: center;">No record found</td>
							</tr>
								
								
								<tr ng-if="estimateList.length>0" id="paginationRow" class ="no-print">
						          <td colspan="15">
							          <div style="text-align: center;">
							            <ul class="pagination pagination-lg" class ="">
							            	
							             <!--  <li ng-init="count=0">
							                <a href ng-click="setPage(0)">« First</a>
							              </li> -->	
							              <li ng-class="prevPageDisabled()">
							                <a href ng-click="prevPage()">« Prev</a>
							              </li>
							              <li ng-repeat="n in range()"
													ng-class="{active: n == currentPage}" ng-click="setPage(n)">
							                <a href="#" {{count=n+1}}>{{n+1}}</a>
							              </li>
							              <li ng-class="nextPageDisabled()">
							                <a href ng-click="nextPage()">Next »</a>
							              </li>
							              
							            </ul>
							          </div>
						          </td>
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
$(function () {
	
	  $("#loading").show();
	
    $('#fromDateSpan').datetimepicker({
    	format: 'MM/DD/YYYY',
    	defaultDate: '<%=fromDate%>'
    });
    
    
    $('#toDateSpan').datetimepicker({
    	format: 'MM/DD/YYYY',
    	defaultDate: '<%=toDate%>'
	});
	});

	$(".headerMenu").find("li").each(function() {
		var id = $(this).attr('id');
		//alert(id);
		if (id == "sales") {
			$(this).addClass("active");
			$(this).find("a").css("background-color", "#0088cc");
		} else {
			$(this).removeClass("active");
			$(this).find("a").css("background-color", "");
		}
	});
	$(".salesMenu").find("li").each(function() {
		var id = $(this).attr('id');
		//alert(id);
		if (id == "estimates") {
			$(this).addClass("active");
			$(this).find("a").css("background-color", "#0088cc");
		} else {
			$(this).removeClass("active");
			$(this).find("a").css("background-color", "");
		}
	});

	
	
	
	/* 	function 
	 printSales() {
	 var oldPage = document.body.innerHTML;
	 $('#paginationRow').hide();
	 var printDiv = $("#tableContent").html();
	 $(document.body).html(
	 "<html><head><title></title></head><body>" + printDiv
	 + "</body></html>");
	 window.print();
	 $(document.body).html(oldPage);
	 $('#paginationRow').show();
	 location.reload();
	 }; */
</script>
</html>