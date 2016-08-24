<%@page import="java.util.List"%>
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
		var app = angular.module('purchaseApp', []);
		
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
		
		app.filter('limitObjectFromTo', function() {
		      return function(obj, limitFrom, limitTo) {
		         var newObj = {},
		          i = 0;
		          for (var p in obj) {
		            if (i >= limitFrom) newObj[p] = obj[p];
		            if (++i === limitTo) break;
		          }
		        return newObj;
		      };
		  });
		
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
		
		app.factory('ajaxService', ['$http', function ($http) {
			 var urlBase="<%=path%>";
			return{
				getPurchaseRecord: function (toDate,fromDate,vendorIdS) {
					 var dataArray = {'toDate':toDate,'fromDate':fromDate,'vendorIdS':vendorIdS};
					 var promise = $http({method:'POST', url:urlBase +'/getPurchaseRecord',data:dataArray,async:false})
					    .success(function (data, status, headers, config) {
					      return data;
					    })
					    .error(function (data, status, headers, config) {
					      return {"status": false};
					    });
					  return promise;
				},
				findSelectedChannelList: function () {
					 var promise = $http({method:'POST', url:urlBase +'/findSelectedChannelList',async:false})
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
		
		var TableCtrl = app.controller('purchaseCtrl', function ($scope, $filter,$http,ajaxService,graphFactory) {
			$scope.itemsPerPage = 5;
			$scope.currentPage = 0; 
			$scope.itemLength=0;
			var toDate='';
			var fromDate='';
			
			$scope.findSelectedChannelList=function(){
				ajaxService.findSelectedChannelList().then(function(promise) {
					$scope.listVendor=promise.data;
				});
			};
			
			$scope.returnPurchaseChanges=function($event){
				$scope.returnInvoiceNum=$event.currentTarget.id.split('#')[0];
				$scope.returnPart=$event.currentTarget.name;
				$scope.returnPartNumber=$event.currentTarget.alt;
				$scope.returnVendor=$event.currentTarget.title;
				$scope.returnSellPrice=$event.currentTarget.id.split('#')[1].split('$')[0];
				$scope.returnMyPrice=$event.currentTarget.id.split('$')[1];
			};
			
			$scope.getPurchaseRecord=function(year){
				$('#tableContent').hide();
				$('#loadingimg').show();
				$scope.currentPage = 0;
				toDate=$('#toDate').val();
				fromDate=$('#fromDate').val();
				if(toDate==""){
					toDate='<%=endDate%>';
					fromDate='<%=startDate%>';
				}
				var vendorIdS="";
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
				ajaxService.getPurchaseRecord(toDate,fromDate,vendorIdS).then(function(promise) {
					$scope.map=promise.data;
					//alert(JSON.stringify($scope.map));
					$scope.itemLength=Object.keys($scope.map).length;
					$scope.findSelectedChannelList();
					$('#loadingimg').hide();
					$('#tableContent').show();
				}); 
				
				if(year!=undefined){
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
				
				
			};
			
			$scope.getPurchaseRecordByMonth=function(e){
				var id = $(e.currentTarget).attr("data-id");
				$scope.currentPage = 0;
				$('#loadingimg').show();
				$('#tableContent').hide();
				var month=Number(id)+Number(1);
				toDate=$('#toDate').val();
				fromDate=$('#fromDate').val();
				var vendorIdS="";
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
				
				ajaxService.getPurchaseRecord(toDate,fromDate,vendorIdS).then(function(promise) {
					$scope.map=promise.data;
					$scope.itemLength=Object.keys($scope.map).length;
					$scope.findSelectedChannelList();
					$('#loadingimg').hide();
					$('#tableContent').show();
				});
				
			};
			
			$scope.getPurchaseRecordByQtr=function(e){
				var id = $(e.currentTarget).attr("data-id");
				$scope.currentPage = 0;
				var qtr=Number(id);
				$('#loadingimg').show();
				$('#tableContent').hide();
				$('.qtr').each(function(){
					$(this).removeClass('btn-success');
					$(this).addClass('btn-default');
					if($(this).attr('data-id')==id){
						$(this).addClass('btn-success');
						$(this).removeClass('btn-default');
					}
				});
				var vendorIdS="";
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
				ajaxService.getPurchaseRecord(toDate,fromDate,vendorIdS).then(function(promise) {
					$scope.map=promise.data;
					$scope.itemLength=Object.keys($scope.map).length;
					$scope.findSelectedChannelList();
					$('#loadingimg').hide();
					$('#tableContent').show();
				});
				
			};
			
	//---------------------------Code for pagination -------------------------------
			$scope.range = function() {
					var rangeSize;
					if($scope.itemLength< $scope.itemsPerPage){
						rangeSize = 1;
					}
					else if($scope.itemLength > $scope.itemsPerPage*5){
						rangeSize = 5;
					}
					else if($scope.itemLength > $scope.itemsPerPage*10){
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
			    return Math.ceil($scope.itemLength/$scope.itemsPerPage)-1;
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
<body ng-app="purchaseApp" ng-controller="purchaseCtrl" data-ng-init="getPurchaseRecord()">
<div class="fluid-container">
	<jsp:include page="purchaseMain.jsp"></jsp:include>
	<div class="form-group" style="margin-top: -9px;margin-left: 2px;">
			<div class="panel panel-primary" style="min-height: 500px;">
				<div class="panel-heading">
					<div class="panel-title">Purchase</div>
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
									 <select id="year" name="2016" ng-change="getPurchaseRecord(year)" ng-model="year" style="border:1px solid #ddd;width:68px;height:42px;margin-top: 5px;">
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
						        <li data-id="0" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Jan</a></li>
						        <li data-id="1" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Feb</a></li>
						        <li data-id="2" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Mar</a></li>
						        <li data-id="3" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Apr</a></li>
						        <li data-id="4" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">May</a></li>
						        <li data-id="5" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Jun</a></li>
						        <li data-id="6" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Jul</a></li>
						        <li data-id="7" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Aug</a></li>
						        <li data-id="8" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Sep</a></li>
						        <li data-id="9" ng-click="getPurchaseRecordByMonth($event)" class="month" ><a href="#">Oct</a></li>
						        <li data-id="10" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Nov</a></li>
						        <li data-id="11" ng-click="getPurchaseRecordByMonth($event)" class="month"><a href="#">Dec</a></li>
						      </ul>
						    </div>
						    
						   
						</div>
					    <div class="col-sm-10" id="qtrly" style="margin-left: -15px;display: none;margin-bottom: 10px;margin-top: -47px;" >
					    	<button class="btn btn-default qtr" data-id="0" ng-click="getPurchaseRecordByQtr($event)" >Q1: Jan-Mar</button> 
					        <button class="btn btn-default qtr" data-id="1" ng-click="getPurchaseRecordByQtr($event)" >Q2: Apr-Jun</button> 
					        <button class="btn btn-default qtr" data-id="2" ng-click="getPurchaseRecordByQtr($event)" >Q3: Jul-Sep</button> 
					        <button class="btn btn-default qtr" data-id="3" ng-click="getPurchaseRecordByQtr($event)" >Q4: Oct-Dec</button>
					       
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
								<input type="button"  ng-click="getPurchaseRecord();" style="margin-left: 10px;" class="btn btn-primary" value="Search" />
							</span>
							
						</div>
						<div class="loading-spiner" id="loadingimg" style="margin: 80px 0px 0px; text-align: center;display: none;">
							<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
	  					</div>
				
					<div id="tableContent" style="margin-top: 15px;" >
						<table class="table table-bordered" id="table">
							<thead style="background-color: #337ab7;color:white;"> 
								<tr>	
									<th style="width: 10%;cursor: pointer;" nowrap="nowrap" class="asc" eq="0" onclick="sortColumn(this)" > Date<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '0', 'glyphicon-chevron-up' : orderProperty == '0' }"></span></th>
									<th style="width: 7%;cursor: pointer;" nowrap="nowrap" class="asc" eq="1" onclick="sortColumn(this)">Invoice#<span class="glyphicon pull-right" ng-class="{ 'glyphicon-chevron-down': orderProperty != '1', 'glyphicon-chevron-up' : orderProperty == '1' }"></span></th>
									<th style="width: 25%;cursor: pointer;" nowrap="nowrap"  > Parts Description</th>
									<th style="width: 12%;cursor: pointer;" nowrap="nowrap" > Part#</th>
									<th style="width: 16%;cursor: pointer;" nowrap="nowrap"> Vendor</th>
									<th style="width: 6%;cursor: pointer;" nowrap="nowrap"  > P.O.#</th>
									<th style="width: 6%;cursor: pointer;" nowrap="nowrap"  > Sell Price</th>
									<th style="width: 6%;cursor: pointer;" nowrap="nowrap"  > MyPrice</th>
									<th style="width: 5%;cursor: pointer;" nowrap="nowrap" > Margin%</th>
									<th style="width: 7%;cursor: pointer;" nowrap="nowrap" ></th>
								</tr>
							</thead>
							<tbody>
								<tr ng-repeat="(key,value) in map | limitObjectFromTo: currentPage*itemsPerPage:(currentPage+1)*itemsPerPage "">
									<td>{{key.split("~")[0] |dateFormat}}</td>
									<td style="text-align: right;">{{key.split("~")[1]}}</td>
									<td style="text-align: right;">
										<div ng-repeat="list in value" style="height: 28px;margin: 2px;">
										{{list[2]}}
										</div>
									</td>
									<td style="text-align: right;">
										<div ng-repeat="list in value" style="height: 28px;margin: 2px;">
										{{list[3]}}
										</div>
									</td>
									<td style="text-align: right;" >
										<div ng-repeat="list in value">
											<div  style="height: 28px;margin: 2px;" ng-if="list[4]!=null" >
											{{list[4]}}
											</div>
											<select  class="form-control"  ng-if="list[4]==null" style="height: 28px;margin: 2px;">
												<option >Select Vendor</option>
												<option ng-repeat="item in listVendor"  >
													{{item[1]}}
												</option>
											</select>
										</div>
										
									</td>
									<td style="text-align: right;">
										<div ng-repeat="list in value" >
											<input value="{{list[7]}}" class="form-control" style="height: 28px;margin: 2px;" >
										</div>
									</td>
									<td style="text-align: right;">
										<div ng-repeat="list in value" style="height: 28px;margin: 2px;">
										{{list[6]!=null?list[6]:list[8]}}
										</div>
									</td>
									<td style="text-align: right;">
										<div ng-repeat="list in value">
											<input value="{{list[5]}}" class="form-control" style="height: 28px;margin: 2px;">
										</div>
									</td>
									<td style="text-align: right;">
										<div style="height: 28px;margin: 2px;" ng-repeat="list in value">
											<div  ng-if="list[6]!=null && list[5]!=null" >
											{{(list[6]!=null?((list[6]-list[5])/list[6])*100:"").toFixed(2)}}
											</div>
										</div>
										<!-- <div style="height: 28px;margin: 2px;" ng-repeat="list in value">
											<div ng-if="list[8]!=null && list[5]!=null && list[6]==null" >
											{{(list[8]!=null?((list[8]-list[5])/list[8])*100:"").toFixed(2)}}
											</div>
										</div> -->
									</td>
									<td>
										<div ng-repeat="list in value" style="cursor: pointer;" >
											<img src="<%=path %>/resources/image/tick_img.png" style="height: 28px;margin: 2px;" invoice="{{list[2]}}" desc="{{list[3]}}" part="{{list[4]}}"  ng-click="savePurchaseChanges($event)"/>
											<img src="<%=path %>/resources/image/edit-icon.png" style="height: 28px;margin: 2px;position: absolute;" id="{{(key.split('~')[1])+'#'+(list[6]!=null?list[6]:list[8])+'$'+(list[5])}}" name="{{list[2]}}" alt="{{list[3]}}" title="{{list[4]!=null?list[4]:'Select'}}" height="{{list[6]!=null?list[6]:list[8]}}" ng-click="returnPurchaseChanges($event)" data-toggle="modal" data-target="#myModal" ng-if="(list[6]!=null || list[8]!=null) && list[5]!=null"/>
										</div>
									</td>
								</tr>
							</tbody>
							<tfoot>
								<tr id="paginationRow" ng-if="itemLength!='0'">
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
		<div class="modal fade" id="myModal" role="dialog">
		    <div class="modal-dialog modal-lg" style="width: 40%;">
		      <div class="modal-content">
		        <div class="modal-header">
		          <button type="button" class="close" data-dismiss="modal">&times;</button>
		          <h4 class="modal-title">Part Returns</h4>
		        </div>
		        <div class="modal-body" style="min-height: 130px;">
			        	<div class="loading-spiner" id="loadingimg2" style="margin: 50px 0px 0px; text-align: center;display: none;">
							<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
	  					</div>
		          		<table style="line-height: 45px;width: 90%;"  id="modelTable" style="display: none;" >
							<tr>
								<td colspan="2" id="retunMSG"></td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">Date</td>
								<td>
									<div class='input-group date' id="returnDateSpan" style="margin-left: 10px;">
										<input type="text"  name="returnDate" class="form-control " id="returnDate" placeholder="MM/DD/YYYY" style="margin-left: 0px;padding-left: 4px;"  ng-modal="toDate"  />
										<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
									</div>
								</td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">Invoice#</td>
								<td id="returnInvoiceNum" ><span  style="margin-left: 10px;">{{returnInvoiceNum}}</span></td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">Description</td>
								<td id="returnPart"><span  style="margin-left: 10px;">{{returnPart}}</span></td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">Part#</td>
								<td id="returnPartNumber"><span  style="margin-left: 10px;">{{returnPartNumber}}</span></td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">Vendor</td>
								<td id="returnVendor"><span  style="margin-left: 10px;">{{returnVendor}}</span></td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">RA#</td>
								<td><input type="text" style="margin-left: 10px;" name="returnRANumber" value="" id="returnRANumber" class="form-control" placeholder="Return Authorization" /></td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">Sell Price $:</td>
								<td><input type="text" style="margin-left: 10px;" name="returnSellPrice" value="{{returnSellPrice}}" id="returnSellPrice" class="form-control" onkeyup="onlyDigits(this);" maxlength="10"/></td>
							</tr>
							<tr>
								<td style="text-align: right;font-size: 14px;font-weight: bold;">My Price $:</td>
								<td><input type="text" style="margin-left: 10px;" name="returnMyPrice" value="{{returnMyPrice}}" id="returnMyPrice" class="form-control" onkeyup="onlyDigits(this);" maxlength="10"/></td>
							</tr>
							<tr>
								<td></td>
								<td>
									<input type="reset" name="cancelbtn" value="Cancel" class="btn btn-danger" style="margin-left: 20%;" >
			  						<input type="button" name="savebtn" value="Save" class="btn btn-success" onclick="savePurchaseReturn()" >
								</td>
							</tr>
						</table>
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
	    
	    $('#returnDateSpan').datetimepicker({
	    	format: 'MM/DD/YYYY'
	    });
	    
	    $('#fromDateSpan').datetimepicker({
	    	format: 'MM/DD/YYYY',
	    	defaultDate: '<%=startDate%>'
	    });
	});
	
	$(".headerMenu").find("li").each(function(){
		var id=$(this).attr('id');
		//alert(id);
		if(id == "purchases"){
			$(this).addClass("active");
			$(this).find("a").css("background-color","#0088cc");
		}else{
			$(this).removeClass("active");
			$(this).find("a").css("background-color","");
		}
	});
	
	$(".purchaseMenu").find("li").each(function(){
		var id=$(this).attr('id');
		//alert(id);
		if(id == "purchaseReport"){
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
	
	function sortColumn(that){
		var eq=$(that).attr('eq');
		var ascDesc=$(that).attr('class');
		$(that).parent().parent().next().find('tr').each(function(){ 
		    var tdold = $(this).find('td:eq("'+eq+'")').text().trim(); 
		    var parentThis=$(this);
		    $(that).parent().parent().next().find('tr').each(function(){ 
			    var tdnew = $(this).find('td:eq("'+eq+'")').text().trim(); 
			       if(ascDesc=='asc'){
			    	   if(tdold!=""){
					       if(Number(tdold) > Number(tdnew)){
					    	   var newRow= $(this).html();
					    	   var oldRow= parentThis.html();
					    	   parentThis.html(newRow);
					    	   $(this).html(oldRow);
					       }
			    	   }
			       }
			       if(ascDesc=='desc'){
			    	   if(tdold!=""){
				    	   if(Number(tdold) < Number(tdnew)){
					    	   var newRow= $(this).html();
					    	   var oldRow= parentThis.html();
					    	   parentThis.html(newRow);
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