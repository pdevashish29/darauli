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
	.redColorText{
			color:red;
		
		}
	</style>
	<%-- 
	<link rel="stylesheet" type="text/css" href="<%=path %>/resources/css/jquery.ui.all.css"/> --%>
	<script>
	/*function change()
	{
//alert("hello");
		//$('#tableContent').css("margin-top","-450px");
		
	
	}*/
	
	
	</script>

<script type="text/javascript">
var app = angular.module('fleetsale', []);

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
	    return input.slice(start);
	  };
});

app.filter('toArray', function() { return function(obj) {
    if (!(obj instanceof Object)) return obj;
    return _.map(obj, function(val, key) {
        return Object.defineProperty(val, '$key', {__proto__: null, value: key});
    });
}});


app.factory('ajaxService', ['$http', function ($http) {
	 var urlBase="<%=path%>";
	 return {
		getDailyCloseEstimates: function (toDate,fromDate) {
			 var dataArray = {'toDate':toDate,'fromDate':fromDate};
			 var promise = $http({method:'POST', url:urlBase +'/FleetsalesReportsYear/',data:dataArray,async:false})
			    .success(function (data, status, headers, config) {
			      return data;
			    })
			    .error(function (data, status, headers, config) {
			      return {"status": false};
			    });
			  return promise;
		},
			
		getDailyCloseEstimatesDetails:function(orderId){
			var promise = $http({method:'POST', url:urlBase +'/dailyCloseReportDetails/'+orderId,async:false})
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

var TableCtrl = app.controller('fleetsalecontroller', function ($scope, $filter,$http,ajaxService,graphFactory) {
	var urlBase="<%=path%>";
	
	
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
	$scope.allItems=[];
	$scope.labourcount=0;
	$scope.partcount=0;
	$scope.taxcount=0;
	$scope.totalsalecount=0;
	$scope.item=[];
	$scope.itemsPerPage = 20;
	$scope.currentPage = 0;
	$scope.orderByField = '[0]';
	//$scope.IsVisible = true;
	//$scope.IsVisible1=false;
	$scope.spinner=true;
	$scope.getDailyCloseEstimate=function(year){
		
		var toDate=$('#toDate').val();
		var fromDate=$('#fromDate').val();
	   // $('#tableContent').css("margin-top","55px");
	   $scope.spinner=true;
		console.log(year);
		if(year!=undefined){
			$scope.year=year;
			toDate=toDate.substr(0, 6) +year;
			fromDate=fromDate.substr(0, 6) +year;
			$('#toDate').val(toDate);
			$('#fromDate').val(fromDate);
			$scope.spinner=false;
			//$('#tableContent').css("margin-bottom","60px");
		}
		  
		//console.log(fromDate+"=="+toDate);
		ajaxService.getDailyCloseEstimates(toDate,fromDate).then(function(promise) {
			$scope.allItems=promise.data;
			//console.log($scope.allItems);
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
			
			//count
			$scope.labourcount=0;
	        $scope.partcount=0;
	        $scope.taxcount=0;
	        $scope.totalsalecount=0;
			 for(var i=0;i<$scope.allItems.length;i++){
				 $scope.labourcount+=$scope.allItems[i][3];
				$scope.partcount+=$scope.allItems[i][4];
				 $scope.taxcount+=$scope.allItems[i][12];
				 //$scope.totalsalecount+=$scope.allItems[i][5];
		    	}
			 $scope.totalsalecount=$scope.labourcount+$scope.partcount+$scope.taxcount;
			//console.log($scope.mainMap);
			
			
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
							//alert(JSON.stringify(data)+"=========="+$scope.year);
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
		
		//$('#loadingimg').hide();
		
	};
	
	$scope.getDailyCloseEstimateByMonth=function(e){
		$scope.spinner=true;
		var toDate=$('#toDate').val();
		var fromDate=$('#fromDate').val();
		// $('#tableContent').css("margin-top","60px");
		
		
		var id = $(e.currentTarget).attr("data-id");
		var month=Number(id)+Number(1);
		
		console.log(month);
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
		
		if(month==2){
			toDate=toDate.substr(0, 3)+28+toDate.substr(5, 5);
		}
		if(month==4 || month==6  ||month==9 || month==11){
			toDate=toDate.substr(0, 3)+30+toDate.substr(5, 5);
		}
		if(month==1 || month==3  ||month==5 || month==7 || month==8 || month==10 || month==12){
			toDate=toDate.substr(0, 3)+31+toDate.substr(5, 5);
		}
		
		$('#toDate').val(toDate);
		$('#fromDate').val(fromDate);
		
		console.log(fromDate+"=="+toDate);
		 ajaxService.getDailyCloseEstimates(toDate,fromDate).then(function(promise) {
			 $scope.allItems=promise.data;
			 //console.log($scope.allItems);
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
					 //$scope.totalsalecount+=$scope.allItems[i][5];
		    	}
			 $scope.totalsalecount=$scope.labourcount+$scope.partcount+$scope.taxcount;
			 
			//alert(JSON.stringify($scope.mainMap));
				
				
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
			
		}); 
		 //$('#loadingimg').hide();
	};
	
	
	
	
/*	$scope.hidediv=function()
	{ 
		$('#tableContent').css("margin-top","5%");
		$scope.IsVisible = true;
		$scope.IsVisible1=false;
	};
	
	$scope.hidediv1=function()
	{
		$('#tableContent').css("margin-top","-1%");
		$scope.IsVisible = false;
		$scope.IsVisible1=true;
	}
	*/
	
	
	
	
	
	
	//---------------------------Code for pagination -------------------------------
	$scope.range = function() {
		
		var rangeSize;
		if($scope.allItems.length <= $scope.itemsPerPage){
			rangeSize = 1;
			
		}
		else if($scope.allItems.length > $scope.itemsPerPage*5){
			rangeSize = 5;
		}
		else if($scope.allItems.length > $scope.itemsPerPage*10){
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
return Math.ceil($scope.allItems.length/$scope.itemsPerPage)-1;
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
	
	
	
	
	
});




</script>
</head>
<body ng-app="fleetsale" ng-controller="fleetsalecontroller" data-ng-init="getDailyCloseEstimate()">
<div class="fluid-container">
	<jsp:include page="salesMain.jsp">
	<jsp:param name="year" value="{{year}}"/>
	</jsp:include>
	<div class="form-group" style="margin-top: -9px;margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Fleet Sales: Monthly Report</div>
				</div>
				<div class="panel-body">
				 	
				
			             <div>
							<ul class="nav nav-tabs" id="showReport" >
					        	<li data-id="month" onclick="showReport(this)" class="active"><a href="#">Monthly</a></li>
					        	<li data-id="date" onclick="showReport(this)"><a href="#">Date Range</a></li>
					        </ul>
					    </div>
            
				<!--  <div style="margin-bottom: 15px;">-->
				<div id="monthDiv" style="margin-top: 15px;height: 34px;" >
					<div style="display: inline;position: absolute;margin-top: -9px;"id="ye"> 
						<span style="font-size:17px;">Year</span> 
					      <span>
							 <select id="year" name="2016" ng-change="getDailyCloseEstimate(year)" ng-model="year" style="border:1px solid #ddd;width:68px;height:42px;margin-top: 5px;">
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
				        <li data-id="0" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Jan</a></li>
				        <li data-id="1" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Feb</a></li>
				        <li data-id="2" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Mar</a></li>
				        <li data-id="3" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Apr</a></li>
				        <li data-id="4" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">May</a></li>
				        <li data-id="5" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Jun</a></li>
				        <li data-id="6" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Jul</a></li>
				        <li data-id="7" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Aug</a></li>
				        <li data-id="8" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Sep</a></li>
				        <li data-id="9" ng-click="getDailyCloseEstimateByMonth($event)" class="month" ><a href="#">Oct</a></li>
				        <li data-id="10" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Nov</a></li>
				        <li data-id="11" ng-click="getDailyCloseEstimateByMonth($event)" class="month"><a href="#">Dec</a></li>
				      </ul>
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
						<span><input type="button"  ng-click="getDailyCloseEstimate();"  style="margin-left: 10px;" class="btn btn-primary" value="Search" /></span>
					</div>
					
					
					<div class="form-group" ng-show="spinner">
					<div class="loading-spiner" id="loadingimg" style="margin: 50px 0px 0px; text-align: center;display: block;">
						<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
  					</div>
					</div>
					<div id="tableContent" ng-hide="spinner">
					 
						<table class="table table-bordered " style="margin-top: 20px;" id="table">
							<thead style="background-color: #337ab7;color:white;">
								  <tr> 
									<th ng-click="orderByField='[0]'; reverseSort = !reverseSort" width="15%" style="cursor: pointer;text-align: left;" nowrap="nowrap">Date <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[0]', 'glyphicon-chevron-up' : orderProperty == '[0]' }"></span></th>
									<th ng-click="orderByField='[1]'; reverseSort = !reverseSort" width="10%" style="cursor: pointer;text-align: left;" nowrap="nowrap" style="">Invoice# <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[1]', 'glyphicon-chevron-up' : orderProperty == '[1]' }"></span></th>
									<th ng-click="orderByField='[2]'; reverseSort = !reverseSort" width="20%" style="cursor: pointer;text-align: left;" nowrap="nowrap" style="">Business <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[2]', 'glyphicon-chevron-up' : orderProperty == '[2]' }"></span></th>
									<th ng-click="orderByField='[3]'; reverseSort = !reverseSort" width="10%" style="cursor: pointer;text-align: left;" nowrap="nowrap" style="">Labor($) <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[3]', 'glyphicon-chevron-up' : orderProperty == '[3]' }"></span></th>
									<th ng-click="orderByField='[4]'; reverseSort = !reverseSort" width="10%" style="cursor: pointer;text-align: left;" nowrap="nowrap" style="">Part($) <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[4]', 'glyphicon-chevron-up' : orderProperty == '[4]' }"></span></th>
									<th ng-click="orderByField='[12]'; reverseSort = !reverseSort" width="10%" style="cursor: pointer;text-align: left;" nowrap="nowrap" style="">Tax($) <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[12]', 'glyphicon-chevron-up' : orderProperty == '[12]' }"></span></th>
									<th ng-click="orderByField='[5]'; reverseSort = !reverseSort" width="15%" style="cursor: pointer;text-align: left;" nowrap="nowrap" style="">Total Sale($) <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[5]', 'glyphicon-chevron-up' : orderProperty == '[5]' }"></span></th>
									<th ng-click="orderByField='[6]'; reverseSort = !reverseSort" width="10%" style="cursor: pointer;text-align: left;" nowrap="nowrap" style="">Status <span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '[6]', 'glyphicon-chevron-up' : orderProperty == '[6]' }"></span></th>
								  </tr>
							  </thead>
							  <tbody >
							  	<tr style="font-size: 11px;" ng-repeat="item in allItems|offset: currentPage*itemsPerPage | limitTo: itemsPerPage|orderBy:orderByField:reverseSort" >	 
							  		<td style="font-size: 14px;text-align:left;">
								     {{item[0]| dateFormat:item[0]}}
								    </td>
								    <td style="font-size: 14px;text-align:right;">
								     {{item[1]}}
								    </td>
								     <td style="font-size: 14px;text-align:left;margin-left:3px;">
								    {{item[2]}}
								    </td>
								    
								     <td style="font-size: 14px;text-align:right;"  ng-if="item[3] !=null">
								     {{item[3]|currency}}
								    </td>
								    <td style="font-size: 14px;text-align:right;" ng-if="item[3] ==null">
								     $0.00
								    </td>
								    <td style="font-size: 14px;text-align:right;" ng-if="item[4] !=null">
								     {{item[4]|currency}}
								    </td>
								    <td style="font-size: 14px;text-align:right;" ng-if="item[4] ==null">
								     $0.00
								    </td>
								     <td style="font-size: 14px;text-align:right;" ng-if="item[12] !=null">
								     {{item[12]|currency}}
								    </td>
								    <td style="font-size: 14px;text-align:right;" ng-if="item[12] ==null">
								     $0.00
								    </td>
								     <td style="font-size: 14px;text-align:right;" ng-if="item[5] !=null">
								     {{item[5]|currency}}
								    </td>
								     <td style="font-size: 14px;text-align:right;" ng-if="item[5] == null">
								     $0.00
								    </td>
								     <td style="font-size: 14px;text-align:center; color: Green;font-weight: bold;" ng-if="item[6] == 'Y' && item[6] !=null && item[6] != 'N' ">
								     Paid
								    </td>
								    <td style="font-size: 14px;text-align:center; color: red;font-weight: bold;" ng-if="item[6] != 'Y'  && item[6] ==null ||item[6] == 'N'">
								     Pending
								    </td>   
							 </tr>
							 <tr>
						    <td colspan="3"  style="font: 14px sans-serif; ;color:#000000;"><h5 style="margin-left:500px;text-align: right;font-weight: bold;white-space: nowrap;">Total $</h5> </td><td style="background:;font: 14px;text-align:right;"><h5 style="font-weight:bold;">{{labourcount.toFixed(2)|currency}}</h5></td><td style="background:;font: 14px;text-align:right;"><h5 style="font-weight:bold;">{{partcount.toFixed(2)|currency}}</h5></td><td style="background: ;font: 14px;text-align:right;"><h5 style="font-weight:bold;">{{taxcount.toFixed(2)|currency}}</h5></td><td style="background: ;font: 14px;text-align:right;"><h5 style="font-weight:bold;">{{totalsalecount.toFixed(3)|currency}}</h5></td><td></td>
						    
							</tr>
							</tbody>
							
							<tfoot>
							<tr id="norecordRow"style="display: none;">
							 <td colspan="11">
						     <div class="redColorText" style="text-align: center;font-weight: bold;" ng-model="norecord" >No Record Found</div>
							 </td>
							 </tr>
							 
							  <tr id="paginationRow">
							          <td colspan="11">
								          <div  style="text-align: center;">
								            <ul class="pagination pagination-lg">
								            	
								             <!--  <li ng-init="count=0">
								                <a href ng-click="setPage(0)">« First</a>
								              </li> -->	
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
		if(id == "fleetSales"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
</script>

<script type="text/javascript">

function showReport(that){
	
	var clas=$(that).attr('data-id');
	$('#showReport').find('li').each(function(){
		$(this).removeClass('active');
	});
	$(that).addClass('active');
	if(clas=="month"){
		$('#horizMonth').show();
		
		$('#monthDiv').show();
		$('#dateDiv').hide();
		
	}else if(clas=="date"){
		$('#monthDiv').hide();
		$('#dateDiv').css('display','flex');
		
	}else{
		$('#horizMonth').show();
		$('#monthDiv').show();
		
		$('#dateDiv').hide();
		
	}
}

</script>
</html>