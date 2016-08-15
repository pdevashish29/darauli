<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%
    String path=request.getContextPath();
    String type=(String)request.getAttribute("type");
    Calendar calender=Calendar.getInstance();
    int year=calender.get(Calendar.YEAR);
    int monthdefault=calender.get(Calendar.MONTH);
    Date date=calender.getTime();
    SimpleDateFormat format=new SimpleDateFormat("MM-dd-yyyy");
    format.setTimeZone(TimeZone.getTimeZone("UTC"));
    String dateUTC=format.format(date);
    %>
<html>
	<head>
	<title>SalesApp</title>
	<LINK REL="SHORTCUT ICON" HREF="<%=path %>/resources/images/favicon.ico">
	<script src="<%=path%>/resources/js/angular.min.js"></script>
	<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap.min.css" type="text/css"/>
	<script src="<%=path%>/resources/js/jquery-1.11.2.min.js"></script>
	<!--Including files Date time picker -->
	<link rel="stylesheet" href="<%=path%>/resources/css/bootstrap-datetimepicker.css" type="text/css" />
	<script src="<%=path%>/resources/js/moment-with-locales.js"></script>
	<script src="<%=path%>/resources/js/bootstrap-datetimepicker.js"></script>
	<!--End files for Date time picker -->
	<script src="<%=path%>/resources/js/bootstrap.min.js"></script>
	<script src="<%=path%>/resources/js/ui-bootstrap-tpls.min.js"></script>
	
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<script src="<%=path%>/resources/js/jquery.tablesorter.js"></script>
	<script src="<%=path %>/resources/js/kendo.all.min.js" ></script>
  	<script src="<%=path%>/resources/js/jquery.number.js"></script>
  	<script src="<%=path%>/resources/js/jquery-ui-1.10.4.custom.js"></script>
  	<script src="<%=path%>/resources/js/stupidtable.js"></script>
  	<script src="<%=path%>/resources/js/dashBoard/dashboard.js"></script>
	
	<style type="text/css">
		.redColorText{
			color:red;
		
		}
		.greenColorText{
			color: green;
		}

		.rowWithColor{
			background-color:#DDF6DD;
			
		}
		.rowWithoutColor{
			background-color: #fff;
		}
	</style>
	<script type="text/javascript">
	$(document).ready(function(){
		  $("html, body").animate({ scrollTop: 0 }, "slow");
		  $("#compareDivs").hide(); 
		  $("#loading").show();
		  $("#priPanel").css("margin-top","-24px");
		  $('#year').val("<%=year%>");
			var year=$("#year").val();
			
			
			var max =[];
			//chartTableMethod(year,'ALL');
			
			$(".breadcrumb #Year1").click(function(){
	  			$('#horizMonth').find("ul li.active").removeClass('active');
	  		
	  	  		$("#search").hide();
	  	  		$(".breadcrumb").find("li:eq(1) a").text("");
				$(".breadcrumb").find("li:eq(2) a").text("");	
				$("#showGraph").hide();
	  		});
		  	
	});
	
var app = angular.module('vehiclesearch', ['ui.bootstrap']);
	
	app.filter('offset', function() {
		  return function(input, start) {
		    start = parseInt(start, 10);
		    return input.slice(start);
		  };
	});
	
	
	app.factory('ajaxService', ['$http', function ($http) {

		 var urlBase="<%=path%>";
		  return {
				
				 getVehiclesearch: function (year) {
					  var promise = $http({method:'POST', url:urlBase+'/VehicleSearch/'+year})
					    .success(function (data, status, headers, config) {
					      return data;
					    })
					    .error(function (data, status, headers, config) {
					      return {"status": false};
					    });
					  
					  return promise;
				  },
				  
				  getReportYearMonth: function (month,year) {
					  var promise = $http({method:'POST', url:urlBase+'/vehicleMonthdatacountbyMonth/'+month+'/'+year})
					  
					  
					    .success(function (data, status, headers, config) {
					      return data;
					    })
					    .error(function (data, status, headers, config) {
					      return {"status": false};
					    });
					  
					  return promise;
				  },
				  
				  getReportYearMonthMakedetail: function (month,year,senderId) {
					  var promise = $http({method:'POST', url:urlBase+'/vehicleMonthdataMake/'+month+'/'+year+'/'+senderId})
					  
					  
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
	
	
	var TableCtrl = app.controller('vehiclesearchController', function ($scope,$http,ajaxService) {
		var urlBase="<%=path%>";
		$scope.monthArray=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		$scope.mon=["0","1","2","3","4","5","6","7","8","9","10","11"];
		$scope.yearItems=[2011,2012,2013,2014,2015,2016,2017,2018,2019,2020];
	    $scope.month='';
	    $scope.monData='';
	    $scope.monthlist='';
	    $scope.year='<%=year%>';
	    $scope.monthdefault=<%=monthdefault%>;
	    $scope.itemsPerPage = 10;
		$scope.currentPage = 0;
		$scope.allItems=[]; 
		$scope.allItems1=[]; 
	    $scope.month= $scope.monthArray[parseInt($scope.monthdefault)];
		$scope.predicate ='-lastUpdateDate';//'businessName';
		$scope.allItemCopy=[];
	    $scope.totalAmount=0;
	    var filterValue=[];
	    $scope.counts=0;
	    $scope.typeOfUsers='ALL';
	    $scope.senderId='';
	    //$scope.monthname='';
		 ajaxService.getVehiclesearch($scope.year).then(function(promise) {	
			 $("#form").show();
			 $("#form1").hide();
			 $("#form2").hide();
			// $('#Year1').html(year1);
			 $scope.allItems =promise.data;
			//alert(promise.data);
			 $scope.allItemCopy=promise.data;
			 $("#loadingimg").css("display","none");
			 for(var i=0;i<$scope.allItems.length;i++){
		    		$scope.counts+=$scope.allItems[i].counts;
		    	}
			// getyear($scope.year);
			/* $("ul.horizon").each(function(){
					$(this).find('li').removeClass('active');
				});
				$("li#horizmonth"+($scope.monthdefault)).addClass('active');*/
		});
		 
		 
		 $scope.onYear=function(){
			 $("#form").show();
			 $("#form1").hide();
			 $("#form2").hide();
				 $scope.counts=0;
				 $scope.month=$scope.monthArray[parseInt($scope.monthdefault)];
				 ajaxService.getVehiclesearch($scope.year).then(function(promise) {
					 $scope.allItems =promise.data;
					 $scope.allItemCopy=promise.data;
					 $("#loadingimg").css("display","none");
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
					 for(var i=0;i<$scope.allItems.length;i++){
						    $scope.subscribe+=$scope.allItems[i].subs;
						   
				    	}
					 
				});
				
		  };
		  
		  $scope.clickOnMonth=function(monData,monthname){
			    $("#form").hide();
				 $("#form1").show();
				 $("#form2").hide();
				// alert(monData+""+monthname);
				
				 $scope.month=monData;
				 $scope.monthname=monthname;
				 $scope.busCount=0;
				 $scope.counts=0;
				 ajaxService.getReportYearMonth($scope.month,$scope.year).then(function(promise) {
					 $scope.allItems =promise.data;
					 $scope.allItemCopy=promise.data;
					 $("#loadingimg").css("display","none");
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
					 for(var i=0;i<$scope.allItems.length;i++){
				    		$scope.counts+=$scope.allItems[i].counts;
				    	}
					 $("ul.horizon").each(function(){
							$(this).find('li').removeClass('active');
						});
					 $("li#horizmonth"+(monData)).addClass('active');
				 
				});
				   
				   
			};
			
			 $scope.makedetail=function(monData,year,senderId,firstname,lastname){
				    $("#form").hide();
					 $("#form1").hide();
					 $("#form2").show();
					 $scope.month=monData;
					 $scope.year=year;
					 $scope.senderId=senderId;
					 $scope.firstname=firstname;
					 $scope.lastname=lastname;
					 $scope.busCount=0;
					 $scope.counts=0;
					 ajaxService.getReportYearMonthMakedetail($scope.month,$scope.year,$scope.senderId).then(function(promise) {
						 $scope.allItems =promise.data;
						 $scope.allItemCopy=promise.data;
						 $("#loadingimg").css("display","none");
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
						 for(var i=0;i<$scope.allItems.length;i++){
					    		$scope.counts+=$scope.allItems[i].counts;
					    	}
						 $("ul.horizon").each(function(){
								$(this).find('li').removeClass('active');
							});
						 $("li#horizmonth"+(monData)).addClass('active');
					 
					});
					   
					   
				};
		  
		  
		 
	});
	</script>
	
     </head>
<body ng-app="vehiclesearch" ng-controller="vehiclesearchController">
<div class="container" style="margin-top:10px;width: 100%;" >

<
   		<br/>

<div class="panel panel-primary" id="priPanel" >
   				<div class="panel-heading">
   					<h3 class="panel-title">AppsReport</h3>				
   				</div>
   				
   				<div class="panel-body" style="padding: 15px 0px 15px 0px;min-height: 600px;">	 			   				
	   			
   				  <div class="loading-spiner" id="loadingimg" style="margin: 50px 50px 0px 0px;display: block;" >
				 <img src="<%=path%>/resources/images/gif-load.gif" style="margin-left:584px;margin-top:-16px;position:absolute;" />
				 </div>
				
   					
   				
   				<div ng-show="true" class="form-group ng-show" style="margin-left: 10px;width: 125px;display:;position: absolute;"> 
					<span style="font-size:17px;">Year</span> 
				      <span>
						  <select id="year" ng-model="year"  ng-change="onYear()" style="width:68px;height:42px;margin-top: 5px;">
							<option ng-selected="item == {{year}}" ng-repeat="item in yearItems" id="{{item}}" value="{{item}}">{{item}}</option>
						</select>  
					  </span> 
	  			</div>
	  
			  <div class="col-sm-11 ng-show" ng-show="true" id="horizMonth"  style="top: 5px;margin-left: 130px;width:65%"> 
		      <ul class="nav nav-tabs horizon">
		        <li class="horizmonth0" id="horizmonth0"  ng-click="clickOnMonth(0,'Jan')" ><a href="#">Jan</a></li>
		        <li class="horizmonth1" id="horizmonth1"  ng-click="clickOnMonth(1,'Feb')"><a href="#">Feb</a></li>
		        <li class="horizmonth2" id="horizmonth2"  ng-click="clickOnMonth(2,'Mar')"><a href="#">Mar</a></li>
		        <li class="horizmonth3" id="horizmonth3"  ng-click="clickOnMonth(3,'Apr')"><a href="#">Apr</a></li>
		        <li class="horizmonth4" id="horizmonth4"  ng-click="clickOnMonth(4,'May')"><a href="#">May</a></li>
		        <li class="horizmonth5" id="horizmonth5"  ng-click="clickOnMonth(5,'Jun')"><a href="#">Jun</a></li>
		        <li class="horizmonth6" id="horizmonth6"  ng-click="clickOnMonth(6,'Jul')"><a href="#">Jul</a></li>
		        <li class="horizmonth7" id="horizmonth7"  ng-click="clickOnMonth(7,'Aug')"><a href="#">Aug</a></li>
		        <li class="horizmonth8" id="horizmonth8"  ng-click="clickOnMonth(8,'Sep')"><a href="#">Sep</a></li>
		        <li class="horizmonth9" id="horizmonth9"  ng-click="clickOnMonth(9,'Oct')"><a href="#">Oct</a></li>
		        <li class="horizmonth10" id="horizmonth10"  ng-click="clickOnMonth(10,'Nov')"><a href="#">Nov</a></li>
		        <li class="horizmonth11" id="horizmonth11"  ng-click="clickOnMonth(11,'Dec')"><a href="#">Dec</a></li>
		      </ul>
		      
		    </div>
		      
			         <div id="form" ng-hide="form" style="width: 100%;margin-top: 15px;">
		   			
		   				
		   				<br/><br/>
		   				<div class="form-group">
    	                <div class="col-sm-8" style="left: 10px;height: 36px;">
    		            <ol class="breadcrumb" style="color:#337ab7;margin-bottom: 8px;padding: 3px 15px;">
  							<li class='active' ng-click="onYear()"><a href='#'>{{year}}></a></li>
  							<li class='active' ng-click="clickOnMonth()"><a href='#'></a></li>
  							<!-- <li  id='business'><a href='#'></a></li>-->
  						</ol>
  		            </div>
  		
                   </div>
			   				<table style="margin-left:20px;margin-right:-25px;width:1210px;" class="table table-bordered">
								<thead style="background-color: #337ab7;color:white;">
									<tr>
										<th style="text-align:left;">Month</th>
										<th style="text-align:center;">Count</th>
										
									</tr>
								</thead>
								<tbody>
								
								<tr ng-repeat="item in allItems"> 
									         
									        
									         <td style="font-size: 14px; text-align:left;" ng-if="item.counts ==0">
									          {{item.monthname}}
									          </td>
									         <td style="font-size: 14px; cursor: pointer;" ng-if="item.counts !=0" ng-click="clickOnMonth(monthdefault,item.monthname)">
								             <span>{{item.monthname}}<br></span> 
								             </td>
								          	
								          	  <td style="font-size: 14px; text-align:center;" ng-if="item.counts ==0">
									          0
									          </td>							
									         <td style="font-size: 14px;text-align:center;width:40px;cursor: pointer;"  ng-if="item.counts !=0" ng-click="clickOnMonth(monthdefault,item.monthname)">
								             <span> {{item.counts}}<br></span>
								             </td>
								             
								              	
								</tr>
								<tr>
								 <td colspan="" style="background: #dff0d8;font: 14px sans-serif; height:45px;color:#000000; "><h5 style="margin-left:30px;text-align: right;">Total</h5> </td><td style="background: #dff0d8;font: 14px;text-align:center;"><h5>{{counts}}</h5></td>
								</tr>
								</tbody>
								<tfoot>
									<tr id="norecordRow"style="display: none;">
							         <td colspan="11">
								            <div class="redColorText" style="text-align: center;font-weight: bold;" ng-model="norecord" >No Record Found</div>
							         </td>
							        </tr>
						      </tfoot>
							</table>	
							</div>
							
							
							
							
							<div id="form1" ng-hide="form" style="width: 100%;margin-top: 15px;">
		   			
		   				
		   				<br/><br/>
		   				<div class="form-group">
    	                <div class="col-sm-8" style="left: 10px;height: 36px;">
    		            <ol class="breadcrumb" style="color:#337ab7;margin-bottom: 8px;padding: 3px 15px;">
  							<li class='active' ng-click="onYear()"><a href='#'>{{year}}></a></li>
  							<li class='active'><a href='#'>{{monthname}}></a></li>
  							<!-- <li  id='business'><a href='#'></a></li>-->
  						</ol>
  		            </div>
  		
                   </div>
			   				<table style="margin-left:20px;margin-right:-25px;width:1210px;" class="table table-bordered">
								<thead style="background-color: #337ab7;color:white;">
									<tr>
										<th style="text-align:left;">Business</th>
										<th style="text-align:center;">Visit Count</th>
										
									</tr>
								</thead>
								<tbody>
								
								<tr ng-repeat="item in allItems"> 
									         
									         <td style="font-size: 14px;cursor: pointer;" ng-click="makedetail(month,year,item.rid,item.firstname,item.lastname)">
								             <span>{{item.firstname}}  {{item.lastname}}<br>
								                   {{item.address}} {{item.city}}<br>
								                   {{item.country}} {{item.zipcode}}<br>
								                   {{item.phonenumbe}} {{item.emaile}}<br>
								             
								             </span> 
								             </td>
								          								
									         <td style="font-size: 14px;text-align:center;width:40px;cursor: pointer;" ng-click="makedetail(month,year,item.rid)">
								             <span> {{item.counts}}<br></span>
								             </td>
								             
								              	
								</tr>
								<tr>
								 <td colspan="" style="background: #dff0d8;font: 14px sans-serif; height:45px;color:#000000; "><h5 style="margin-left:30px;text-align: right;">Total</h5> </td><td style="background: #dff0d8;font: 14px;text-align:center;"><h5>{{counts}}</h5></td>
								</tr>
								</tbody>
								<tfoot>
									<tr id="norecordRow"style="display: none;">
							         <td colspan="11">
								            <div class="redColorText" style="text-align: center;font-weight: bold;" ng-model="norecord" >No Record Found</div>
							         </td>
							        </tr>
						      </tfoot>
							</table>	
							</div>
							
							
							
							
									<div id="form2" ng-hide="form" style="width: 100%;margin-top: 15px;">
		   			
		   				
		   				<br/><br/>
		   				<div class="form-group">
    	                <div class="col-sm-8" style="left: 10px;height: 36px;">
    		            <ol class="breadcrumb" style="color:#337ab7;margin-bottom: 8px;padding: 3px 15px;">
  							<li class='active' ng-click="onYear()"><a href='#'>{{year}}></a></li>
  							<li class='active' ng-click="clickOnMonth(monthdefault,monthname)"><a href='#'>{{monthname}}></a></li>
  							<li  id='business'><a href='#'>{{firstname}} {{lastname}}</a></li>
  						</ol>
  		            </div>
  		
                   </div>
			   				<table style="margin-left:20px;margin-right:-25px;width:1210px;" class="table table-bordered">
								<thead style="background-color: #337ab7;color:white;">
									<tr>
										<th style="text-align:left;">Make</th>
										<th style="text-align:left;">Model</th>
										<th style="text-align:left;">Sub Model</th>
										<th style="text-align:left;">Engine</th>
										<th style="text-align:left;">Date</th>
									</tr>
								</thead>
								<tbody>
								
								<tr ng-repeat="item in allItems"> 
									         
									         <td style="font-size: 14px;">
								             {{item.make}}
								             </td>
								             
								             <td style="font-size: 14px;">
								             {{item.model}}
								             </td>
								             
								              <td style="font-size: 14px;">
								               {{item.submodel}} 
								             </td>
								             
								              <td style="font-size: 14px;">
								               {{item.engine}}
								             </td>
								          								
									         <td style="font-size: 14px;text-align:left;width:350px;">
								                {{item.entrydate}}
								             </td>
								             
								              	
								</tr>
								<!--  
								<tr>
								 <td colspan="" style="background: #dff0d8;font: 14px sans-serif; height:45px;color:#000000; "><h5 style="margin-left:30px;text-align: right;">Total</h5> </td><td style="background: #dff0d8;font: 14px;text-align:center;"><h5>{{counts}}</h5></td>
								</tr>-->
								</tbody>
								<tfoot>
									<tr id="norecordRow"style="display: none;">
							         <td colspan="11">
								            <div class="redColorText" style="text-align: center;font-weight: bold;" ng-model="norecord" >No Record Found</div>
							         </td>
							        </tr>
						      </tfoot>
							</table>	
							</div>
					
        	
							
							
							
							
					</div>
        	</div>
        	</div>	   
        	
        	
        	
        		   

<!--  </div>-->

<!--  </div>-->
</body>
</html>