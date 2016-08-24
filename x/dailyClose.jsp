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
	
	</style>
	<%-- 
	<link rel="stylesheet" type="text/css" href="<%=path %>/resources/css/jquery.ui.all.css"/> --%>

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
			getDailyCloseEstimates: function (toDate,fromDate) {
				 var dataArray = {'toDate':toDate,'fromDate':fromDate};
				 var promise = $http({method:'POST', url:urlBase +'/dailyCloseReports',data:dataArray,async:false})
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
		$scope.getDailyCloseEstimate=function(year){
			$scope.currentPage = 0;
			$('#loadingimg').show();
			$('#tableContent').hide();
			var toDate=$('#toDate').val();
			var fromDate=$('#fromDate').val();
			console.log(toDate+"++++++"+fromDate);
			$scope.totalCash="0";
			$scope.totalCheck="0";
			$scope.totalPO="0";
			$scope.totalBal="0";
			$scope.totalReturn="0";
			$scope.totalRefund="0";
			$scope.totalTax="0";
			$scope.totalTrnt1="0";
			$scope.totalTrnt2="0";
			$scope.totalTrnt3="0";
			$scope.totalTrnt4="0";
			$scope.totalRevenue="0";
			//console.log(year);
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
			//console.log(fromDate+"=="+toDate);
			ajaxService.getDailyCloseEstimates(toDate,fromDate).then(function(promise) {
				$scope.map=promise.data;
				$scope.tempMap={};
				$scope.refundMaps={};
				$scope.returnMaps={};
				$scope.mainMap=$scope.map.mainMap;
				$scope.refundMap=$scope.map.refundMap;
				$scope.returnMap=$scope.map.returnMap;
				$scope.taxMap=$scope.map.taxMap;
				$scope.valueForMMap={};
				$scope.retrnList=[];
				$scope.refndList=[];
				console.log($scope.mainMap);
				angular.forEach($scope.mainMap, function(value) {
					  $scope.valueForM="0";
					  $scope.totalCash=Number($scope.totalCash)+Number(value[0]!=null?value[0]:"0");
					  $scope.totalCheck=Number($scope.totalCheck)+Number(value[1]!=null?value[1]:"0");
					  $scope.totalPO=Number($scope.totalPO)+Number(value[2]!=null?value[2]:"0");
					  $scope.totalBal=Number($scope.totalBal)+Number(value[4]!=null?value[4]:"0");
					  angular.forEach($scope.refundMap, function(value1, key1) {
						  if(key1==value[6]){
							  $scope.valueForM=value1;
							  $scope.refndList.push(value[6]); 
							  $scope.totalRefund=Number($scope.totalRefund)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  angular.forEach($scope.returnMap, function(value1, key1) {
						  if(key1==value[6]){
							  $scope.valueForM=$scope.valueForM+value1;
							  $scope.retrnList.push(value[6]);
							  $scope.totalReturn=Number($scope.totalReturn)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  angular.forEach($scope.taxMap, function(value1, key1) {
						  if(key1==value[6]){
							  $scope.totalTax=Number($scope.totalTax)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  
					  angular.forEach(value[3], function(value1, key1) {
						  if(key1=='Visa'){
							  $scope.totalTrnt1=Number($scope.totalTrnt1)+Number(value1!=null?value1:"0");
						  }
						  if(key1=='MasterCard'){
							  $scope.totalTrnt2=Number($scope.totalTrnt2)+Number(value1!=null?value1:"0");
						  }
						  if(key1=='DiscoverCard'){
							  $scope.totalTrnt4=Number($scope.totalTrnt4)+Number(value1!=null?value1:"0");
						  }
						  if(key1=='AmericanExpress'){
							  $scope.totalTrnt3=Number($scope.totalTrnt3)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  $scope.valueForMMap[value[6]]=[$scope.valueForM];
					 
				});
				
				$scope.totalCard="0";
				angular.forEach($scope.mainMap, function(value) {
					  angular.forEach($scope.valueForMMap, function(value1, key1) {
						  if(key1==value[6]){
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
				$('#loadingimg').hide();
				$('#tableContent').show();
			});
			
			
			
		};
		
		
		$scope.getDailyCloseEstimateByMonth=function(e){
			var toDate=$('#toDate').val();
			$('#loadingimg').show();
			$('#tableContent').hide();
			$scope.currentPage = 0;
			var fromDate=$('#fromDate').val();
			$scope.totalCash="0";
			$scope.totalCheck="0";
			$scope.totalPO="0";
			$scope.totalBal="0";
			$scope.totalReturn="0";
			$scope.totalRefund="0";
			$scope.totalTax="0";
			$scope.totalRevenue="0";
			$scope.totalTrnt1="0";
			$scope.totalTrnt2="0";
			$scope.totalTrnt3="0";
			$scope.totalTrnt4="0";
			
			var id = $(e.currentTarget).attr("data-id");
			var month=Number(id)+Number(1);
			
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
			
			console.log(fromDate+"=="+toDate);
			 ajaxService.getDailyCloseEstimates(toDate,fromDate).then(function(promise) {
				$scope.map=promise.data;
				$scope.refundMaps={};
				$scope.returnMaps={};
				$scope.tempMap={};
				$scope.mainMap=$scope.map.mainMap;
				$scope.refundMap=$scope.map.refundMap;
				$scope.returnMap=$scope.map.returnMap;
				$scope.taxMap=$scope.map.taxMap;
				$scope.valueForMMap={};
				$scope.retrnList=[];
				$scope.refndList=[];
				//alert(JSON.stringify($scope.mainMap));
				angular.forEach($scope.mainMap, function(value) {
					  $scope.valueForM="0";
					  $scope.totalCash=Number($scope.totalCash)+Number(value[0]!=null?value[0]:"0");
					  $scope.totalCheck=Number($scope.totalCheck)+Number(value[1]!=null?value[1]:"0");
					  $scope.totalPO=Number($scope.totalPO)+Number(value[2]!=null?value[2]:"0");
					  $scope.totalBal=Number($scope.totalBal)+Number(value[4]!=null?value[4]:"0");
					 angular.forEach($scope.refundMap, function(value1, key1) {
						  if(key1==value[6]){
							  $scope.valueForM=value1;
							  $scope.refndList.push(value[6]); 
							  $scope.totalRefund=Number($scope.totalRefund)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  angular.forEach($scope.returnMap, function(value1, key1) {
						  if(key1==value[6]){
							  $scope.valueForM=$scope.valueForM+value1;
							  $scope.retrnList.push(value[6]);
							  $scope.totalReturn=Number($scope.totalReturn)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  angular.forEach($scope.taxMap, function(value1, key1) {
						  if(key1==value[6]){
							  $scope.totalTax=Number($scope.totalTax)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  angular.forEach(value[3], function(value1, key1) {
						  if(key1=='Visa'){
							  $scope.totalTrnt1=Number($scope.totalTrnt1)+Number(value1!=null?value1:"0");
						  }
						  if(key1=='MasterCard'){
							  $scope.totalTrnt2=Number($scope.totalTrnt2)+Number(value1!=null?value1:"0");
						  }
						  if(key1=='DiscoverCard'){
							  $scope.totalTrnt4=Number($scope.totalTrnt4)+Number(value1!=null?value1:"0");
						  }
						  if(key1=='AmericanExpress'){
							  $scope.totalTrnt3=Number($scope.totalTrnt3)+Number(value1!=null?value1:"0");
						  }
						  
					  });
					  
					  $scope.valueForMMap[value[6]]=[$scope.valueForM];
					  
					  
					 
				});
				
				angular.forEach($scope.mainMap, function(value) {
					  angular.forEach($scope.valueForMMap, function(value1, key1) {
						  if(key1==value[6]){
							  $scope.totalCard="0";
							 if(value[3]!=null){
								 $scope.totalCard=Number((value[3])['Visa'])+Number((value[3])['AmericanExpress'])+Number((value[3])['DiscoverCard'])+Number((value[3])['MasterCard']);
							 }
							  $scope.totalRevenue=Number($scope.totalRevenue)+(Number(value[0]!=null?value[0]:"0")+Number(value[1]!=null?value[1]:"0")+Number(value[2]!=null?value[2]:"0")+Number(value[4]!=null?value[4]:"0")+Number($scope.totalCard!=null?$scope.totalCard:"0"))-Number(value1!=null?value1:"0");
						 }
						  
					  });
				});
				$('#loadingimg').hide();
				$('#tableContent').show();
			}); 
			
			
		};
		
		$scope.showDetailsPayment=function(e){
			var orderId = $(e.currentTarget).attr("orderId");
			$('#loadingimg2').show();
			 $('#modelTable').hide();
			$scope.refundMapD={};
			$scope.returnMapD={};
			 ajaxService.getDailyCloseEstimatesDetails(orderId).then(function(promise) {
				 $scope.mapD=promise.data;
				 $scope.refundMapD=$scope.mapD.refundMap;
				 $scope.returnMapD=$scope.mapD.returnMap;
				 $scope.taxMapD=$scope.mapD.taxMap;
				 $scope.listD=$scope.mapD.list;
				 $scope.cashList=$scope.mapD.cashList;
				 $scope.checkList=$scope.mapD.checkList;
				 $scope.transactionList=$scope.mapD.transactionList;
				 $scope.referencePoList=$scope.mapD.referencePoList;
				 $scope.depositList=$scope.mapD.depositList;
				 $scope.totalCash1="0";
				 $scope.totalCheck1="0";
				 $scope.totalPo1="0";
				 $scope.totalBal1="0";
				 $scope.totalTran1="0";
				 $scope.totalTran2="0";
				 $scope.totalTran3="0";
				 $scope.totalTran4="0";
				 $scope.totalRetrn1="0";
				 $scope.totalRefnd1="0";
				 $scope.totalRevenues1="0";
				 $scope.totalTax1="0";
				 $scope.cashLists=[];
				 $scope.checkLists=[];
				 $scope.poLists=[];
				 $scope.balLists=[];
				 $scope.revenues=[];
				 $scope.retLists=[];
				 $scope.refLists=[];
				 $scope.taxLists=[];
				 $scope.tr1Lists=[];
				 $scope.tr2Lists=[];
				 $scope.tr3Lists=[];
				 $scope.tr4Lists=[];
				 angular.forEach($scope.listD, function(list) {
					 $scope.cash="0";
					 $scope.check="0";
					 $scope.po="0";
					 $scope.bal="0";
					 $scope.tran="0";
					 $scope.retrn="0";
					 $scope.refnd="0";
					 angular.forEach($scope.cashList, function(cash) {
						  if(list[0]==cash[0]){
							  $scope.cash=Number(cash[1]);
							  $scope.totalCash1=Number($scope.totalCash1)+Number(cash[1]);
							  $scope.cashLists.push(cash[0]);
						 }
						  
					  });
					  angular.forEach($scope.checkList, function(cash) {
						  if(list[0]==cash[0]){
							  $scope.check=Number(cash[1]);
							  $scope.totalCheck1=Number($scope.totalCheck1)+Number(cash[1]);
							  $scope.checkLists.push(cash[0]);
						 }
						  
					  });
					  angular.forEach($scope.referencePoList, function(cash) {
						  if(list[0]==cash[0]){
							  $scope.po=Number(cash[1]);
							  $scope.totalPo1=Number($scope.totalPo1)+Number(cash[1]);
							  $scope.poLists.push(cash[0]);
						 }
						  
					  });
					  angular.forEach($scope.depositList, function(cash) {
						  if(list[0]==cash[0]){
							  $scope.Bal=Number(cash[1]);
							  $scope.totalBal1=Number($scope.totalBal1)+Number(cash[1]);
							  $scope.balLists.push(cash[0]);
						 }
						  
					  });
					  angular.forEach($scope.transactionList, function(cash) {
						  if(cash[2]=='Visa'){
							  if(list[0]==cash[0]){
								  $scope.tran=Number(cash[1]);
								  $scope.totalTran1=Number($scope.totalTran1)+Number(cash[1]);
								  $scope.tr1Lists.push(cash[0]);
							  }
						  }
						  if(cash[2]=='MasterCard'){
							  if(list[0]==cash[0]){
								  $scope.tran=Number(cash[1]);
								  $scope.totalTran2=Number($scope.totalTran2)+Number(cash[1]);
								  $scope.tr2Lists.push(cash[0]);
							  }
						  }
						  if(cash[2]=='AmericanExpress'){
							  if(list[0]==cash[0]){
								  $scope.tran=Number(cash[1]);
								  $scope.totalTran3=Number($scope.totalTran3)+Number(cash[1]);
								  $scope.tr3Lists.push(cash[0]);
							  }
						  }
						  if(cash[2]=='DiscoverCard'){
							  if(list[0]==cash[0]){
								  $scope.tran=Number(cash[1]);
								  $scope.totalTran4=Number($scope.totalTran4)+Number(cash[1]);
								  $scope.tr4Lists.push(cash[0]);
							  }
						  }
						  
					  });
					  
					  angular.forEach($scope.returnMapD, function(value,key) {
						 
						  if(list[0]==key){
							  $scope.retrn=Number(value);
							  $scope.totalRetrn1=Number($scope.totalRetrn1)+Number(value);
							  $scope.retLists.push(key);
							  console.log($scope.retLists+"==");
						 }
						  
					  });
					  
					  angular.forEach($scope.refundMapD, function(value,key) {
							// console.log(key +":"+value);
							  if(list[2]==key){
								  $scope.refnd=Number((value[2]!=null && value[2]!="0")?value[2]:value[1]);
								  $scope.totalRefnd1=Number($scope.totalRefnd1)+Number(value[2]!=null?value[2]:value[1]);
								  $scope.refLists.push(key);
							 }
							  
						});
					  
					  angular.forEach($scope.taxMapD, function(value,key) {
						 console.log(key +":"+value);
						  if(list[2]==key){
							  $scope.totalTax1=Number($scope.totalTax1)+Number(value);
							  $scope.taxLists.push(key);
						 }
						  
					  });
					  $scope.totalRevenues1=Number($scope.totalRevenues1)+Number($scope.cash)+Number($scope.check)+Number($scope.tran)+Number($scope.po)+Number($scope.bal)-Number($scope.retrn);
					  $scope.revenues.push(Number($scope.cash)+Number($scope.check)+Number($scope.tran)+Number($scope.po)+Number($scope.bal)-Number($scope.retrn)-Number($scope.refnd));
					  
				 });
				 
				$('#loadingimg2').hide();
				$('#modelTable').show();
				 
			 });
			 
		};
		
		    
		  //---------------------------Code for pagination -------------------------------
			$scope.range = function() {
					var rangeSize;
					if($scope.mainMap.length < $scope.itemsPerPage){
						rangeSize = 1;
					}
					else if($scope.mainMap.length > $scope.itemsPerPage*5){
						rangeSize = 5;
					}
					else if($scope.mainMap.length > $scope.itemsPerPage*10){
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
		    return Math.ceil($scope.mainMap.length/$scope.itemsPerPage)-1;
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
<body ng-app="dailyApp" ng-controller="dailyCtrl" data-ng-init="getDailyCloseEstimate()">
<div class="fluid-container">
	<jsp:include page="salesMain.jsp" ></jsp:include>
	<div class="form-group" style="margin-top: -9px;margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Daily Close</div>
				</div>
				<div class="panel-body">
					<div>
						<ul class="nav nav-tabs" id="showReport" >
				        	<li data-id="month" onclick="showReport(this)" class="active"><a href="#">Monthly</a></li>
				        	<li data-id="date" onclick="showReport(this)"><a href="#">Date Range</a></li>
				        </ul>
				    </div>
				    <div id="monthDiv" style="margin-top: 15px;margin-bottom: 65px;" >
						<div style="display: inline-table;position: absolute;margin-top: -9px;"> 
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
						<div class="col-sm-7" id="horizMonth" style="top: -5px;margin-left: 100px;"> 
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
				    <div style="margin-top: 15px;display: none;"  id="dateDiv">
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
						<span><input type="button"  ng-click="getDailyCloseEstimate();" style="margin-left: 10px;" class="btn btn-primary" value="Search" /></span>
					</div>
					<div class="loading-spiner" id="loadingimg" style="margin: 80px 0px 0px; text-align: center;display: none;">
						<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
  					</div>	
					<div id="tableContent">
						<table class="table table-bordered value" style="margin-top: 12px;" id="table">
							<thead style="background-color: #337ab7;color:white;">
								  <tr> 
									<th width="10%" style="cursor: pointer;" nowrap="nowrap" ng-click="orderByField='6'; reverseSort = !reverseSort">Date<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '6', 'glyphicon-chevron-up' : orderProperty == '6' }"></span></th>
									<th width="10%" style="cursor: pointer;" nowrap="nowrap" style="text-align: center;" ng-click="orderByField='0'; reverseSort = !reverseSort">Cash $<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '0', 'glyphicon-chevron-up' : orderProperty == '0' }"></span></th>
									<th width="10%" style="cursor: pointer;" nowrap="nowrap" style="text-align: center;" ng-click="orderByField='1'; reverseSort = !reverseSort">Check $<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '1', 'glyphicon-chevron-up' : orderProperty == '1' }"></span></th>
									<th width="35%" nowrap="nowrap" style="text-align: center;"  ><b style="font-size: 12px;">Credit Cards $</b>
										<div style="width: 100%;border-top: 1px solid;">
											<span style="font-size: 11px; width: 20%;text-align: center;border: none;padding-right: 5px;">Visa</span>
								 			<span style=" font-size: 11px; white-space: nowrap; width: 27%;text-align: center;border: none;margin-left: 26px;">Master Card</span>
								 			<span style="font-size: 11px; white-space: nowrap; width: 28%;text-align: center;border: none;margin-left: 25px;">AMEX</span>
								 			<span style=" font-size: 11px; width: 25%; border-right:none;text-align: center;border: none;margin-left: 25px;">Discover</span>	
										</div>
									</th>
									<th width="10%" style="cursor: pointer;" nowrap="nowrap" style="text-align: center;" ng-click="orderByField='2'; reverseSort = !reverseSort">P.O. $<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '2', 'glyphicon-chevron-up' : orderProperty == '2' }"></span></th>
									<th width="10%" style="cursor: pointer;" nowrap="nowrap" style="text-align: center;" ng-click="orderByField='4'; reverseSort = !reverseSort">Balance $<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '4', 'glyphicon-chevron-up' : orderProperty == '4' }"></span></th>
									<th width="8%" nowrap="nowrap" style="text-align: center;" class="asc" eq="10" onclick="sortColumn(this)">Return $</th>
									<th width="8%" nowrap="nowrap" style="text-align: center;" class="asc" eq="11" onclick="sortColumn(this)">Refund $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;" class="asc" eq="12" onclick="sortColumn(this)">Total Tax $</th>
									<th width="10%" nowrap="nowrap" style="text-align: center;" class="asc" eq="13" onclick="sortColumn(this)">Total Revenue $</th>
								  	<th width="5%" nowrap="nowrap" style="text-align: center;" >Details</th>
								  </tr>
							  </thead>
							  <tbody >
							  	 <tr ng-if="mainMap!=null" style="font-size: 11px;" ng-repeat="value in mainMap | filter:searchText | offset: currentPage*itemsPerPage | limitTo: itemsPerPage  |orderBy:orderByField:reverseSort "     > 
							  		<td style="vertical-align: top;padding-left: 10px;white-space: nowrap;" >{{value[6] | dateFormat:value[6]}}</td>
									<td style="text-align: right;padding-right: 5px;">{{value[0]!=null?value[0]:"0.00"|currency}}</td>
									<td style="text-align: right;padding-right: 5px;">{{value[1]!=null?value[1]:"0.00"|currency}}</td>
									<td >
										<table style="width: 100%;" cellspacing="1" >
								  			<tr style="height: 22px;">
								  				<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;"  > 
											  		<span ng-repeat='(key1,value1) in value[3]' >
											  			<tt ng-if="key1=='Visa'" >{{value1!=0?value1:"0.00"|currency}}</tt>
											  		</span>
											  		<span  ng-if="value[3]==null" >
											  			<tt  >$0.00</tt>
											  		</span>
											  	</td>
											  	<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;" > 
											  		<span ng-repeat='(key1,value1) in value[3]'>
											  			<tt ng-if="key1=='MasterCard'">{{value1!=0?value1:"0.00"|currency}}</tt>
											  		</span>
											  		<span  ng-if="value[3]==null">
											  			<tt  >$0.00</tt>
											  		</span>
											  	</td>	
											  	<td style="text-align: right;border-right: 1px solid lightgray;width: 30%;"  > 
											  		<span ng-repeat='(key1,value1) in value[3]'">
											  			<tt ng-if="key1=='AmericanExpress'">{{value1!=0?value1:"0.00"|currency}}</tt>
											  		</span>
											  		<span  ng-if="value[3]==null" >
											  			<tt  >$0.00</tt>
											  		</span>
											  	</td>
											  	<td style="text-align: right;width: 30%;"  > 
											  		<span ng-repeat='(key1,value1) in value[3]' >
											  			<tt ng-if="key1=='DiscoverCard'">{{value1!=0?value1:"0.00"|currency}}</tt>
											  		</span>
											  		<span  ng-if="value[3]==null"  >
											  			<tt  >$0.00</tt>
											  		</span>
											  	</td>
								  			</tr>
								  		</table>
									</td>
									<td style="text-align: right;padding-right: 5px;">{{value[2]!=null?value[2]:"0.00"|currency}}</td>
								  	<td style="text-align: right;padding-right: 5px;">{{value[4]!=null?value[4]:"0.00"|currency}}</td>
								  	<td style="text-align: right;padding-right: 5px;" > 
								  		<span ng-repeat='(keys,values) in returnMap'>
								  			<tt ng-if="value[6]==keys">{{values!=null?values:"0.00"|currency}}</tt>
								  		</span>
								  		<span>
								  			<tt ng-if="retrnList.indexOf(value[6])==-1" ll="{{retrnList}}" mm="{{value[6].toString()}}">$0.00</tt>
								  		</span>
								  	</td>
								  	<td style="text-align: right;padding-right: 5px;" > 
								  		<span ng-repeat='(keys,values) in refundMap'>
								  			<tt  ng-if="value[6]==keys" >{{values!=null?values:"0.00"|currency}}</tt>
								  		</span>
								  		<span>
								  			<tt ng-if="refndList.indexOf(value[6])==-1">$0.00</tt>
								  		</span>
								  	</td>	
								  	<td style="text-align: right;padding-right: 5px;"  > 
								  		<span ng-repeat='(keys,values) in taxMap' >
								  			<tt  ng-if="value[6]==keys">{{values!=null?values:"0.00"|currency}}</tt>
								  		</span>
								  		<span  ng-if="taxMap==null"  >
								  			<tt  >$0.00</tt>
								  		</span>
								  	</td>
								  	<td style="text-align: right;padding-right: 5px;">
								  		<span>
								  			<span ng-repeat='(keys,values) in valueForMMap'>
								  				<tt ng-if="value[6]==keys">$</tt><tt ng-if="value[6]==keys" >{{(value[0]+value[1]+value[2]+value[4]+(value[3])['Visa']+(value[3])['AmericanExpress']+(value[3])['DiscoverCard']+(value[3])['MasterCard']-values).toFixed(2)}}</tt>
								  			</span>
								  		</span>
								  	</td>
									<td style="text-align: center;" class="nosort">
										<span class="show novalue" style="color: rgb(211, 52, 44); position: relative;font-size: 16px;cursor: pointer;" ng-click="showDetailsPayment($event);" orderId="{{value[5]}}" title="View detail" data-toggle="modal" data-target="#myModal">view</span>
									</td>
									 		
							  	</tr>
							  	<tr style="font-size: 11px;"  ng-if="mainMap==null" > 
							  		<td colspan="12" style="text-align: center;color: red;font-size: 15px;" ><b>No Record Found</b></td>
							  	</tr>
							  </tbody>
							  <tfoot>
							  	<tr ng-if="mainMap!=null" >
							  		<td style="text-align: right;"><b>Total</b></td>
							  		<td style="text-align: right;"><b>{{totalCash|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalCheck|currency}}</b></td>
							  		<td style="text-align: right;">
							  			<table  style="width: 100%;" cellspacing="1" >
							  				<tr>
							  					<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;"  > 
							  					<b>{{totalTrnt1|currency}}</b>
							  					</td>
							  					<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;"  > 
							  					<b>{{totalTrnt2|currency}}</b>
							  					</td>
							  					<td style="text-align: right;border-right: 1px solid lightgray;width: 30%;"  > 
							  					<b>{{totalTrnt3|currency}}</b>
							  					</td>
							  					<td style="text-align: right;width: 30%;"  > 
							  					<b>{{totalTrnt4|currency}}</b>
							  					</td>
							  				</tr>
							  			</table>
							  		</td>
							  		<td style="text-align: right;"><b>{{totalPO|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalBal|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalReturn|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalRefund|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalTax|currency}}</b></td>
							  		<td style="text-align: right;"><b>$</b><b>{{totalRevenue.toFixed(2)}}</b></td>
							  		<td style="text-align: right;"></td>
							  	</tr>
							  	
							  	<tr id="paginationRow">
						          <td colspan="15">
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
		<div class="modal fade" id="myModal" role="dialog">
		    <div class="modal-dialog modal-lg" style="width: 90%;">
		      <div class="modal-content">
		        <div class="modal-header">
		          <button type="button" class="close" data-dismiss="modal">&times;</button>
		          <h4 class="modal-title">Daily Close Estimate Details</h4>
		        </div>
		        <div class="modal-body" style="min-height: 130px;">
			        	<div class="loading-spiner" id="loadingimg2" style="margin: 50px 0px 0px; text-align: center;display: none;">
							<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
	  					</div>
		          		<table class="table table-bordered" id="modelTable" style="display: none;" >
							<thead style="background-color: #337ab7;color:white;">
								  <tr> 
									<th  >Date</th>
									<th >Invoice #</th>
									<th   style="text-align: center;">Cash $</th>
									<th   style="text-align: center;">Check $</th>
									<th  style="text-align: center;" class="nosort"><b style="font-size: 12px;">Credit Cards $</b>
										<div style="width: 100%;border-top: 1px solid;">
											<span style="font-size: 11px; width: 20%;text-align: center;border: none;padding-right: 5px;">Visa</span>
								 			<span style=" font-size: 11px; white-space: nowrap; width: 27%;text-align: center;border: none;margin-left: 26px;">Master Card</span>
								 			<span style="font-size: 11px; white-space: nowrap; width: 28%;text-align: center;border: none;margin-left: 25px;">AMEX</span>
								 			<span style=" font-size: 11px; width: 25%; border-right:none;text-align: center;border: none;margin-left: 25px;">Discover</span>	
										</div>
									</th>
									<th   style="text-align: center;">P.O. $</th>
									<th   style="text-align: center;">Balance $</th>
									<th  style="text-align: center;">Return $</th>
									<th  style="text-align: center;">Refund $</th>
									<th   style="text-align: center;">Note</th>
									<th   style="text-align: center;">Total Tax $</th>
									<th   style="text-align: center;">Total Revenue $</th>
								  </tr>
							  </thead>
							  <tbody id="revenue" >
							  		<tr style="font-size: 11px;" ng-repeat='list in listD' ng-if="listD!=null" > 
							  			<td style="vertical-align: top;padding-left: 10px;white-space: nowrap;">{{list[1] | date:'MMM dd, yyyy'}}</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;">{{list[2]}}</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="cash in cashList">
							  					<tt ng-if="cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
							  				</span>
							  				<span>
							  					<tt ng-if="cashLists.indexOf(list[0])==-1">$0.00</tt>
							  				</span>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="cash in checkList">
							  					<tt ng-if="cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
							  				</span>
							  				<span>
							  					<tt ng-if="checkLists.indexOf(list[0])==-1">$0.00</tt>
							  				</span>
							  				
							  			</td>
							  			<td>
							  				<table style="width: 100%;" cellspacing="1" >
									  			<tr style="height: 22px;">
									  				<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;"  > 
												  		<span ng-repeat="cash in transactionList">
										  					<tt ng-if="cash[2]=='Visa' && cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
										  				</span>
										  				<span>
										  					<tt ng-if="tr1Lists.indexOf(list[0])==-1">$0.00</tt>
										  				</span>
												  	</td>
												  	<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;" > 
												  		<span ng-repeat="cash in transactionList">
										  					<tt ng-if="cash[2]=='MasterCard' && cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
										  				</span>
										  				<span>
										  					<tt ng-if="tr2Lists.indexOf(list[0])==-1">$0.00</tt>
										  				</span>
												  	</td>	
												  	<td style="text-align: right;border-right: 1px solid lightgray;width: 30%;"  > 
												  		<span ng-repeat="cash in transactionList">
										  					<tt ng-if="cash[2]=='AmericanExpress' && cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
										  				</span>
										  				<span>
										  					<tt ng-if="tr3Lists.indexOf(list[0])==-1">$0.00</tt>
										  				</span>
												  	</td>
												  	<td style="text-align: right;width: 30%;"  > 
												  		<span ng-repeat="cash in transactionList">
										  					<tt ng-if="cash[2]=='DiscoverCard' && cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
										  				</span>
										  				<span>
										  					<tt ng-if="tr4Lists.indexOf(list[0])==-1">$0.00</tt>
										  				</span>
												  	</td>
									  			</tr>
									  		</table>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="cash in referencePoList">
							  					<tt ng-if="cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
							  				</span>
							  				<span>
							  					<tt ng-if="poLists.indexOf(list[0])==-1">$0.00</tt>
							  				</span>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="cash in depositList">
							  					<tt ng-if="cash[0]==list[0]" >{{cash[1]!=null?cash[1]:"0"|currency}}</tt >
							  				</span>
							  				<span>
							  					<tt ng-if="balLists.indexOf(list[0])==-1" hh="{{balLists}}" df="{{list[0]}}">$0.00</tt>
							  				</span>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="(key,value) in returnMapD">
							  					<tt ng-if="key==list[0]" >{{value!=null?value:"0"|currency}}</tt >
							  				</span>
							  				<span  >
							  					<tt ng-if="retLists.indexOf(list[0].toString())==-1" ll="{{list[0].toString()}}" jj="{{retLists}}" kk="{{retLists.indexOf(list[0])}}"  kl="{{retLists.indexOf('list[0]')}}">$0.00</tt>
							  				</span>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="(key,value) in refundMapD">
							  					<b key="{{key}}" list="{{list[2]}}" val1="{{value[1]}}" val2="{{value[2]}}"></b>
							  					<tt ng-if="key==list[2] && value[1]!=null" >{{value[1]!=null?value[1]:"0"|currency}}</tt >
							  					<span ng-if="value[2]!='0'">
							  						<tt ng-else-if="key==list[2] && value[2]!=null" >{{value[2]!=null?value[2]:"0"|currency}}</tt >
							  					</span>
							  					
							  				</span>
							  				<span>
							  					<tt ng-if="refLists.indexOf(list[2].toString())==-1">$0.00</tt>
							  				</span>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="(key,value) in refundMapD">
							  					<tt ng-if="key==list[2]" >{{value[5]!=null?value[5]:""}}</tt >
							  				</span>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" >
							  				<span ng-repeat="(key,value) in taxMapD">
							  					<tt ng-if="key==list[2]" >{{value!=null?value:"0"|currency}}</tt >
							  				</span>
							  				<span>
							  					<tt ng-if="taxLists.indexOf(list[2].toString())==-1" >$0.00</tt>
							  				</span>
							  			</td>
							  			<td style="vertical-align: top;padding-left: 10px;text-align: right;" id="revTd" >
							  				<span >{{revenues[$index]|currency}}</span>
							  			</td>
							  		</tr>
							  </tbody>
							  <tfoot>
							  	<tr>
							  		<td style="text-align: right;" colspan="2"><b>Total</b></td>
							  		<td style="text-align: right;"><b>{{totalCash1|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalCheck1|currency}}</b></td>
							  		<td style="text-align: right;">
							  			<table  style="width: 100%;" cellspacing="1" >
							  				<tr>
							  					<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;"  > 
							  					<b>{{totalTran1|currency}}</b>
							  					</td>
							  					<td style="text-align: right;border-right: 1px solid lightgray;width: 20%;"  > 
							  					<b>{{totalTran2|currency}}</b>
							  					</td>
							  					<td style="text-align: right;border-right: 1px solid lightgray;width: 30%;"  > 
							  					<b>{{totalTran3|currency}}</b>
							  					</td>
							  					<td style="text-align: right;width: 30%;"  > 
							  					<b>{{totalTran4|currency}}</b>
							  					</td>
							  				</tr>
							  			</table>
							  		</td>
							  		<td style="text-align: right;"><b>{{totalPo1|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalBal1|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalRetrn1|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalRefnd1|currency}}</b></td>
							  		<td style="text-align: right;"><b></b></td>
							  		<td style="text-align: right;"><b>{{totalTax1|currency}}</b></td>
							  		<td style="text-align: right;"><b>{{totalRevenues1|currency}}</b></td>
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
		if(id == "dailyClose"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
	
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
					       if(Number(tdold.replace('$','')) > Number(tdnew.replace('$',''))){
					    	   var newRow= $(this).html();
					    	   var oldRow= $(this).prev().html();
					    	   $(this).prev().html(newRow);
					    	   $(this).html(oldRow);
					       }
			    	   }
			       }
			       if(ascDesc=='desc'){
			    	   if(tdold!=""){
				    	   if(Number(tdold.replace('$','')) < Number(tdnew.replace('$',''))){
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