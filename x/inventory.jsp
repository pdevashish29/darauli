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
	<script type="text/javascript" src="<%=path%>/resources/js/kendo.all.min.js"></script>
	<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap-datetimepicker.css" type="text/css" />
	<script src="<%=path%>/resources/js/moment-with-locales.js"></script>
	<script src="<%=path%>/resources/js/bootstrap-datetimepicker.js"></script>
	
	<style type="text/css">
		tt{
			font-size: 15px;
		}
		
		td{
			font-size: 15px;
		}
		
	#summaryTableView tr th, #descptionTableView tr th, #view tr th{
	    background-color: #499bea;
	    color:white;
	}
	
	#summaryTableView tr,#descptionTableView tr, #view tr{
		height: 46px;
	}
	
	</style>
	<%-- 
	<link rel="stylesheet" type="text/css" href="<%=path %>/resources/css/jquery.ui.all.css"/> --%>

<script type="text/javascript">
	var app = angular.module('dailyApp', []);
	
	/* app.filter('dateFormat', function() {
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
	 */
	app.factory('ajaxService', ['$http', function ($http) {
		 var urlBase="<%=path%>";
		 return {
			getInventoryUsage:function(month, year, fromDate, toDate){  //alert(month + " " + year + " " + fromDate + " " + toDate); 
				var promise = $http({method:'POST', url:urlBase +'/getInventoryUsage?monthParam='+month+'&yearParam='+year+'&fromDateParam='+fromDate+'&toDateParam='+toDate, async:false})
			    .success(function (data, status, headers, config) {
			      return data;
			    })
			    .error(function (data, status, headers, config) {
			      return {"status": false};
			    });
			  return promise;
			},
			viewInvDetail:function(ids){ 
				var promise = $http({method:'POST', url:urlBase +'/inventoryUsageConsolidatedReport?jsonString='+ids, async:false})
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
	
	var TableCtrl = app.controller('dailyCtrl', function ($scope, $filter,$http,ajaxService,graphFactory) {
		var urlBase="<%=path%>";
		$scope.mainMap={};
		$scope.itemsPerPage = 10;
		$scope.orderByField = 'date';
		$scope.reverseSort = false;
		$scope.currentPage = 0;
		$scope.valueForM="0";
		$scope.year="<%=year%>";
		$scope.valueForMMap={};
		$scope.refundMapD={};
		$scope.returnMapD={};
		$scope.taxMapD={};
		$scope.listD=[];
		$scope.cashList=[];
		$scope.checkList=[];
		$scope.transactionList=[];
		$scope.referencePoList=[];
		$scope.depositList=[];
		
		$scope.month = '';
		$scope.year = ''; 
		$scope.fromDate = '';
		$scope.toDate = '';
		$scope.consumedMapList=[];
		$scope.mainMapList=[];
		$scope.viewList=[];
		
		
		
		ajaxService.getInventoryUsage($scope.month, $scope.year, $scope.fromDate, $scope.toDate).then(function(promise) { 
			$('#summary').show();
			//alert(JSON.stringify(promise.data));
			$scope.consumedMapList=(promise.data['consumedMapList'])==null?[]:promise.data['consumedMapList'];
			$scope.mainMapList=(promise.data['mainMapList'])==null?[]:promise.data['mainMapList'];
			//alert(JSON.stringify($scope.consumedMapList));
			console.log(JSON.stringify($scope.consumedMapList));
			console.log(JSON.stringify($scope.mainMapList));
		});
		
		$scope.viewInvDetail = function(ids){
			$("#dateDiv").hide();
			$("#monthDiv").hide();
			ajaxService.viewInvDetail(ids).then(function(promise) { 
				$('#summary').hide();
				$('#view').show();
				$scope.viewList = promise.data;
				//alert(JSON.stringify($scope.viewList));
				console.log(JSON.stringify($scope.viewList));
			});
		}
		
		$scope.showSummary = function(){
			//$("#dateDiv").show();
			$('#summary').show();
			$('#view').hide();
			
			$('#monthDiv').show();
			$('#dateDiv').hide();
				
		}
		
		
		$scope.showTraceByYear = function(year){
			//alert(year);
			$scope.year=year;
			
			var toDate=$('#toDate').val();
			var fromDate=$('#fromDate').val();
		    $scope.spinner=true;
			if(year!=undefined){
				toDate=toDate.substr(0, 6) +year;
				fromDate=fromDate.substr(0, 6) +year;
				$('#toDate').val(toDate);
				$('#fromDate').val(fromDate);
				$scope.spinner=false;
			}
			
			ajaxService.getInventoryUsage($scope.month, $scope.year, '', '').then(function(promise) { 
				$('#summary').show();
				$scope.consumedMapList=(promise.data['consumedMapList'])==null?[]:promise.data['consumedMapList'];
				$scope.mainMapList=(promise.data['mainMapList'])==null?[]:promise.data['mainMapList'];
			});
			
			$("#div-loading-spiner").show();
			$("#div-graph-content").hide();
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
		
		$scope.showTrace = function(e){
			var id = $(e.currentTarget).attr("data-id");
			$scope.month=Number(id);//+Number(1);
			
			$('.month').each(function(){
				$(this).removeClass('active');
				if($(this).attr('data-id')==id){
					$(this).addClass('active');	
				}
			});
			
			var year=$scope.year;
			var month=$scope.month+Number(1);
			var toDate=$('#toDate').val();
			var fromDate=$('#fromDate').val();
			
			if(month<10){
				month="0"+month;
			}
			
			toDate=month+toDate.substr(2, 8);
			fromDate=month+fromDate.substr(2, 8);
			
			
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
			
			ajaxService.getInventoryUsage($scope.month, $scope.year, '', '').then(function(promise) { 
				$('#summary').show();
				$scope.consumedMapList=(promise.data['consumedMapList'])==null?[]:promise.data['consumedMapList'];
				$scope.mainMapList=(promise.data['mainMapList'])==null?[]:promise.data['mainMapList'];
			}); 
		}
		
		
		
		
		/* $scope.getDailyCloseEstimate=function(year){
			var toDate=$('#toDate').val();
			var fromDate=$('#fromDate').val();
			//alert(toDate + " " + fromDate);
		    $scope.spinner=true;
			console.log(year);
			if(year!=undefined){
				$scope.year=year;
				toDate=toDate.substr(0, 6) +year;
				fromDate=fromDate.substr(0, 6) +year;
				$('#toDate').val(toDate);
				$('#fromDate').val(fromDate);
				$scope.spinner=false;
			}
			  
			ajaxService.getDailyCloseEstimates(toDate,fromDate).then(function(promise) {
				$scope.allItems=promise.data;
				$scope.spinner=false;
				 if($scope.allItems.length>0){
						$("#norecordRow").css("display","none");
						$("#paginationRow").show();
						 $("#totalamount").show();
						$scope.totalAmount=$scope.allItems[0].sum;
		       	 }else if($scope.allItems.length==0){
		    			$("#norecordRow").show();
						$("#paginationRow").css("display","none");
						$("#totalamount").hide();
		    	 } 
				
				$scope.labourcount=0;
		        $scope.partcount=0;
		        $scope.taxcount=0;
		        $scope.totalsalecount=0;
				 for(var i=0;i<$scope.allItems.length;i++){
					 $scope.labourcount+=$scope.allItems[i][3];
					$scope.partcount+=$scope.allItems[i][4];
					 $scope.taxcount+=$scope.allItems[i][12];
			    	}
				 $scope.totalsalecount=$scope.labourcount+$scope.partcount+$scope.taxcount;
				
				
				$scope.totalCard="0";
				angular.forEach($scope.mainMap, function(value, key) {
					  angular.forEach($scope.valueForMMap, function(value1, key1) {
						  if(key1==key){
							  $scope.totalCard="0";
							 if(value[3]!=null){
								$scope.totalCard=Number((value[3])['Visa'])+Number((value[3])['AmericanExpress'])+Number((value[3])['DiscoverCard'])+Number((value[3])['MasterCard']);
							 }
							 $scope.totalRevenue=Number($scope.totalRevenue)+(Number(value[0]!=null?value[0]:"0")+Number(value[1]!=null?value[1]:"0")+Number(value[2]!=null?value[2]:"0")+Number(value[4]!=null?value[4]:"0")+Number($scope.totalCard!=null?$scope.totalCard:"0"))-Number(value1!=null?value1:"0");
						 }
						  
					  });
				});
				if(year!=undefined){
					$("#div-loading-spiner").show();
					$("#div-graph-content").hide();
					graphFactory.getGraphDataList($scope.year).then(
							function(data){
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
							}
					);
				}
			});
		}; */
		
		
		
		$scope.applyFilter = function(){
			$scope.month = '';//$("#searchDiv li.selected a").attr("id");
			$scope.year = $("#year").val();
			$scope.fromDate = $("#fromDate").val();
			$scope.toDate=$("#toDate").val();
			
			ajaxService.getInventoryUsage($scope.month, $scope.year, $scope.fromDate, $scope.toDate).then(function(promise) { //alert("ddd");
				$('#summary').show();
				//alert(JSON.stringify(promise.data));
				$scope.consumedMapList=promise.data['consumedMapList'];
				$scope.mainMapList=promise.data['mainMapList'];
				//alert($scope.consumedMapList);
			});
		}
		
		
		<%-- function applyFilter(){
			var month = $("#searchDiv li.selected a").attr("id");
			var year = $("#year").val();
			var fromDate = $("#fromDate").val();
			var toDate=$("#toDate").val();
			if(typeof(month) == 'undefined' && (fromDate == "" || toDate == "" ) ){
				alert("Please select range date");
				return false;
			}
			if(typeof(month) =='undefined'){
				month = "";
			}
			var filterType = $("input.activeSelectedBut").val();
			console.log(filterType);
			if(filterType == "Sub-Category"){
				filterType = "SubCategory";
			}else if(filterType == "Part#"){
				filterType = "partNumber";
			}
			var searchKeywoard = $("input#searchAnyFromInv").val();
			//console.log(month+"---------"+year+"---fromDate---"+fromDate+"-----toDate----"+toDate);
			$('div#overlayDiv').show();
			$.ajax({
				dataType:'Html',
				url:"<%=path%>/inventory-usage-report.action",
				data:{year:year,month:month,fromDate:fromDate,toDate:toDate,
					filterType:filterType,
					filter:"yes",
					searchKeywoard:searchKeywoard
					<%if(req != null && !"null".equals(req) && "reports".equals(req)){%>
					,req:"reports"
					<%}%>
					},
				success:function(response){
					$('div#overlayDiv').hide();
					<%if(req != null && !"null".equals(req) && "reports".equals(req)){%>
						$("#reportsDetailMenu").html("");
						$("#reportsDetailMenu").html(response);
					<%}else{%>
						$("div#inventoryReportByVendorDiv").html("");
						$("div#inventoryReportByVendorDiv").html(response);	
					<%}%>
					
				},error:function(){
					$('div#overlayDiv').hide();
					alert("Service not available");
				}
			});	
		} --%>
		
		
		
	});
</script>

</head>
<body ng-app="dailyApp" ng-controller="dailyCtrl" > <!-- data-ng-init="getDailyCloseEstimate()" -->
 
    <div class="form-group">
		<jsp:include page="/header.jsp"></jsp:include>
	</div>
	<div class="form-group">
		<jsp:include page="/headerMenu.jsp"></jsp:include>
	</div>
	<div class="form-group" style="margin-top: -15px;margin-left: 2px;">
		<jsp:include page="../graph.jsp"></jsp:include>
	</div>
	

     <%-- <div style="display: inline-block;" id="searchBlocksDiv"> 
  		<input type="text" class="form-control" name="searchAnyFromInv" placeholder="Search.." id="searchAnyFromInv" />
  		<img alt="" src="<%=path %>/images/slider.png" style="margin-left:10px;cursor: pointer;" title="Filter" onclick="ImgFilters();"/>
  	 </div>	  --%>
  	 
  	 
  	 <div class="form-group" style="margin-top: -9px;margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Inventory Usage</div>
				</div>
			  	   <div class="panel-body">
				            <div>
								<ul class="nav nav-tabs" id="showReport" >
						        	<li data-id="month" onclick="showReport(this)" class="active"><a href="#">Monthly</a></li>
						        	<li data-id="date" onclick="showReport(this)"><a href="#">Date Range</a></li>
						        </ul>
						    </div>
			            
							<!--  <div style="margin-bottom: 15px;">-->
							<div id="monthDiv" style="margin-top: 15px;height: 40px;" >
								<div style="display: inline;position: absolute;margin-top: -9px;"id="ye"> 
									<span style="font-size:17px;">Year</span> 
								      <span>
										 <select id="year" name="2016" ng-change="showTraceByYear(year)" ng-model="year" style="border:1px solid #ddd;width:68px;height:42px;margin-top: 5px;">
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
								<div class="col-sm-10" id="horizMonth" style="top: -5px;margin-left: 100px;width:55%;"> 
							      <ul class="nav nav-tabs">
							        <li data-id="0" ng-click="showTrace($event)" class="month"><a href="#">Jan</a></li>
							        <li data-id="1" ng-click="showTrace($event)" class="month"><a href="#">Feb</a></li>
							        <li data-id="2" ng-click="showTrace($event)" class="month"><a href="#">Mar</a></li>
							        <li data-id="3" ng-click="showTrace($event)" class="month"><a href="#">Apr</a></li>
							        <li data-id="4" ng-click="showTrace($event)" class="month"><a href="#">May</a></li>
							        <li data-id="5" ng-click="showTrace($event)" class="month"><a href="#">Jun</a></li>
							        <li data-id="6" ng-click="showTrace($event)" class="month"><a href="#">Jul</a></li>
							        <li data-id="7" ng-click="showTrace($event)" class="month"><a href="#">Aug</a></li>
							        <li data-id="8" ng-click="showTrace($event)" class="month"><a href="#">Sep</a></li>
							        <li data-id="9" ng-click="showTrace($event)" class="month" ><a href="#">Oct</a></li>
							        <li data-id="10" ng-click="showTrace($event)" class="month"><a href="#">Nov</a></li>
							        <li data-id="11" ng-click="showTrace($event)" class="month"><a href="#">Dec</a></li>
							      </ul>
							    </div>
							    <div style="float:right;">
							    	<!-- <input type="text" class="form-control" ng-model="searchT.$" placeholder="Search.."  /> -->
							    	<input type="text" class="form-control" id="searchText" ng-model="searchText.$" placeholder="Search" type="search" ng-change="search()"  autofocus>
							    </div>
							   </div>
							    <div style="margin-top: 15px;display: inline-flex;display: none;" id="dateDiv">
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
									<span><input type="button"  ng-click="applyFilter();"  style="margin-left: 10px;" class="btn btn-primary" value="Search" /></span>
								</div>
								
								
								<div class="form-group" ng-show="spinner">
									<div class="loading-spiner" id="loadingimg" style="margin: 50px 0px 0px; text-align: center;display: block;">
										<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
				  					</div>
								</div>
								<div id="tableContent" ng-hide="spinner" style="margin: 12px -15px;">
								 
								 <!-- Table content Start -->
								 
								 <div id="summary" style="display: none;">	
			  		<table style="width: 100%;border-collapse: collapse;" id="summaryTableView">
			  			<thead>
			  				<tr><th style="text-align: center;font-weight: bold;font-size: 20px;border-bottom: 1px solid #ccc;" colspan="8">Summary</th></tr>
				  			<tr>
				  				<th style="text-align: left;width: 20%;padding-left: 10px;">Parts</th>
				  				<th style="text-align: right;width: 12%;padding-right:4px;">Stock On Hand</th>
				  				<th style="text-align: right;width: 12%;padding-right:4px;">$Value</th>
				  				<th style="text-align: right;width: 12%;padding-right:4px;">Stock Consumed</th>
				  				<th style="text-align: right;width: 12%;padding-right:4px;">$Consumed</th>
				  				<th style="text-align: right;width: 12%;padding-right: 4px;white-space: nowrap;">Total Sales</th>
				  				<th style="text-align: right;width: 10%;padding-right:4px;">%Consumed</th>
				  				<th style="text-align: right;width: 10%;padding-right:4px;">%Margin</th>
				  			</tr>
			  			</thead>
			  			<tbody>
			  				<tr ng-style="{'font-weight' : item.partName=='consumedFooter'?'bold':'normal'}" ng-repeat="item in consumedMapList | filter:searchText">
								<td style="text-align: left;padding-right:4px;" ng-style="{'text-align' : item.partName=='consumedFooter'?'right':'left'}">{{item.partName=='consumedFooter'?'Total Value':item.partName}}</td>
								<td style="text-align: right;padding-right:4px;">{{item.stockQty}}</td>
								<td style="text-align: right;padding-right:4px;">{{'$'+ item.stockValue}}</td>
								<td style="text-align: right;padding-right:4px;">{{item.consumedQty}}</td>
								<td style="text-align: right;padding-right:4px;">{{'$'+item.consumedPrice}}</td>
								<td style="text-align: right;padding-right:4px;">{{'$'+item.totalSales}}</td>
								<td style="text-align: right;padding-right:4px;">{{item.stockAndConsumedQty + (item.stockAndConsumedQty=='' || item.partName=='consumedFooter'?'':'%' )}}</td>
								<td style="text-align: right;padding-right:4px;">{{item.totalSalesAndConsumedPrice  + (item.totalSalesAndConsumedPrice=='' || item.partName=='consumedFooter'?'':'%')}}</td>
								<!-- <td style="text-align: right;padding-right:4px;">{{item.id}}</td>
								<td style="text-align: right;padding-right:4px;">{{item.value}}</td> -->
							</tr>
							<!-- <tr></tr> -->
							<tr ng-show="consumedMapList.length<1" style="color:red;font-weight: bold;font-size: 12px;"><td colspan="8" style="text-align: center;">No Record Found</td></tr>
			  			</tbody>
			  		</table>	
			  		
			  		<table style="width: 100%;margin-top: 20px;border-collapse: collapse;" id="descptionTableView">
			  			<thead>
				  			<tr>
				  				<th style="text-align: left;width: 15%;padding-left: 10px;">Part#</th>
				  				<th style="text-align: left;width: 25%">Description</th>
				  				<th style="text-align: left;width: 15%;">Brand</th>
				  				<th style="text-align: left;width: 15%;">Distributor</th>
				  				<th style="width: 10%;padding-right: 5px;">Total QTY</th>
				  				<th style="width: 10%;padding-right: 5px;white-space: nowrap;">Total Amount</th>
				  				<th style="width: 10%;">Action</th>
				  			</tr>
			  			</thead>
			  			<tbody>
			  				<tr ng-style="{'font-weight' : item.partNumber=='consumedFooter'?'bold':'normal'}" ng-repeat="item in mainMapList | filter:searchText">
			  					<td>{{item.partNumber!='consumedFooter'?item.partNumber:''}}</td>
			  					<td>{{item.partNumber!='consumedFooter'?item.partName:''}}</td>
			  					<td>{{item.partNumber!='consumedFooter'?item.brand:''}}</td>
			  					<td ng-style="{'text-align' : item.partNumber=='consumedFooter'?'right':'left'}" >{{item.partNumber=='consumedFooter'?'Total Value':item.distributor}}</td>
			  					<td style="text-align: right;padding-right:5px;">{{item.qty}}</td>
			  					<td style="text-align: right;padding-right:5px;">{{item.totalAmount}}</td>
			  					<!-- <td>{{item.id}}</td>
			  					<td>{{item.value}}</td> -->
			  					<td data-ng-hide="item.partNumber=='consumedFooter'" style="text-align: center;"><span style="font-weight: bold;top:0px;cursor: pointer;color:#499bea;" class="view" ids="{{item.partNumber!='consumedFooter'?item.ids:''}}" data-ng-click="viewInvDetail(item.partNumber!='consumedFooter'?item.ids:'');">View</span></td>
			  				</tr>
			  				<tr ng-show="mainMapList.length<1" style="color:red;font-weight: bold;font-size: 12px;"><td colspan="8" style="text-align: center;">No Record Found</td></tr>
			  			</tbody>
			  		</table>
			  	</div>
			  	<div id="view" style="display: none;margin-top: 13px;">
			  	    <div style="width: 100%;background-color: #499bea;height: 46px;margin-bottom: 13px;">
			  	    	<div style="padding-top: 7px;float: left;">
			  	      	 <img data-ng-click="showSummary();" style="margin-top: -7px;cursor: pointer;" src="<%=path%>/resources/image/home_icon.png"  >
			  	      	 <span style="color: white;font-weight: bold;font-size: 19px;margin-top: 85px;">Inventory Usage</span>
			  	         </div>
			  	      	 <span id="reportsBackBtn" data-ng-click="showSummary();" style="float: right; margin-top: 7px;color:white;margin-right: 5px;"><button class="btn" style="color:black;">Back</button></span>
			  	    </div>
			  		<table style="border-collapse: collapse;width:100%;" id="consolidatedTable">
						<thead>
							<tr>
								<th width="10%" style="text-align: left;padding-left: 5px">Date</th>
								<th width="10%" style="text-align: left;padding-right: 5px">Invoice#</th>
								<th width="24%" style="text-align: left;padding-left: 5px">Description</th>
								<th width="15%" style="text-align: left;padding-left: 5px">Brand</th>
								<th width="15%" style="text-align: left;padding-left: 5px">Distributor</th>
								<th width="10%" style="white-space: nowrap;">Quantity</th>
								<th width="8%" style="white-space: nowrap;">Price</th>
								<th width="8%" style="white-space: nowrap;">Total Amount</th>
							</tr>
						</thead >
						<tbody>
			  				<tr ng-style="{'font-weight' : item.creationDate=='viewFooter'?'bold':'normal'}" ng-repeat="item in viewList | filter:searchText">
			  					<td ng-style="{'text-align' : item.creationDate=='consumedFooter'?'right':'left'}">{{item.creationDate!='viewFooter'?item.creationDate:''}}</td>
			  					<td>{{item.creationDate!='viewFooter'?item.estimateId:''}}</td>
			  					<td>{{item.creationDate!='viewFooter'?item.partName:''}}</td>
			  					<td>{{item.creationDate!='viewFooter'?item.brand:''}}</td>
			  					<td style="padding-right:5px;" ng-style="{'text-align' : item.creationDate=='viewFooter'?'right':'left'}">{{item.creationDate=='viewFooter'?'Total Value':item.distributor}}</td>
			  					<td style="text-align: right;padding-right:5px;">{{item.qty}}</td>
			  					<td style="text-align: right;padding-right:5px;">{{item.creationDate!='viewFooter'?item.unitPrice:''}}</td>
			  					<td style="text-align: right;padding-right:5px;">{{item.amount}}</td>
			  				</tr>
			  				<tr ng-show="viewList.length<1" style="color:red;font-weight: bold;font-size: 12px;"><td colspan="8" style="text-align: center;">No Record Found</td></tr>
			  			</tbody>
					</table>
			  	</div>
  	
				    <!-- Table content End -->	
				</div>
			</div>     
		</div>
	</div>
				
  	<div class="form-group">
			<jsp:include page="/footer.jsp"></jsp:include>
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
		if(id == "inventory"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
	
	/* $(".salesMenu").find("li").each(function(){
		var id=$(this).attr('id');
		if(id == "dailyClose"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	}); */
	
	 function showReport(that){
		var clas=$(that).attr('data-id');
		$('#showReport').find('li').each(function(){
			$(this).removeClass('active');
		});
		$(that).addClass('active');
		if(clas=="month"){
			$('#monthDiv').show();
			$('#dateDiv').hide();
		}else{
			$('#monthDiv').hide();
			$('#dateDiv').css('display','flex');
			//$('#dateDiv').css('margin-left', '120px');
		}
		$('#summary').show();
		$("#view").hide();
	} 
	
	
</script>

</html>