 <%@ page import="java.util.List" %>
 <%@ page import="java.util.*" %>
 <%@page import="com.salesApp.springs.utility.AppConstants"%>
 <%@page import="java.util.TimeZone"%>
 <%@page import="java.text.SimpleDateFormat"%>
 <%@page import="java.util.Date"%>
 <%@page import="java.util.Calendar"%>
 <%@page import="com.salesApp.springs.model.RegistrationVO"%>
 <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
 
  <%
    String path=request.getContextPath();
   // String type=(String)request.getAttribute("type");
    RegistrationVO userInfo=(RegistrationVO)session.getAttribute("userInfo");
    String empRole="";
    long senderId=0;
    if(userInfo !=null){ 
    	senderId=userInfo.getId();
    	empRole=userInfo.getEmpRole();
    }
    Calendar calender=Calendar.getInstance();
    int year=calender.get(Calendar.YEAR);
    int monthdefault=calender.get(Calendar.MONTH);
    Date date=calender.getTime();
    SimpleDateFormat format=new SimpleDateFormat("dd-mm-yyyy");
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
			 // $("#compareDivs1").hide(); 
			  $("#loading").show();
			  $("#priPanel").css("margin-top","-55px");
			  $('#year').val("<%=year%>");
			  var year=$("#year").val();
			 // var month=$("#month").val();
			  //alert(month);
			  var max =[];
			  chartTableMethod(year);
			  chartTableMethodPIEchart(year);
			  chartTableMethod2(year);	
			  chartTableMethodSubscribe2(year);
			  chartTableMethodExpire2(year);
			  var yearLeft=$("#yearLeft").val();
			  var yearRight=$("#yearRight").val();
			  //chartTableMethod3(yearLeft,counts);
			  chartTableMethodNew(yearRight);
			  //alert(yearLeft);
			  //alert(yearRight);
				$('[data-toggle="tooltip"]').tooltip();
				 
		});
	  
	var app = angular.module('appsReport', ['ui.bootstrap']);
	
	app.filter('offset', function() {
		  return function(input, start) {
		    start = parseInt(start, 10);
		    return input.slice(start);
		  };
	});
	
	
	app.factory('ajaxService', ['$http', function ($http) {
		 var urlBase="<%=path%>";
		  return {
			
				/*..................Find Data on the basis of Year.......................*/
				
				 getReportYear: function (year) {
					  var promise = $http({method:'GET', url:urlBase+'/getReportsYear/'+year})
					    .success(function (data, status, headers, config) {
					      return data;
					    })
					    .error(function (data, status, headers, config) {
					      return {"status": false};
					    });
					  
					  return promise;
				  },
				
				  
				 /*..................Find Data on the basis of Year AND month.......................*/
				  getReportYearMonth: function (year,month) {
					  var promise = $http({method:'GET', url:urlBase+'/getReportsYearMonth/'+year+'/'+month})
					  
					  
					    .success(function (data, status, headers, config) {
					      return data;
					    })
					    .error(function (data, status, headers, config) {
					      return {"status": false};
					    });
					  
					  return promise;
				  },
				  
				  
				  
				  getAppReportBusiness: function (ssId,year,month) {
					  var promise = $http({method:'GET', url:urlBase+'/getAppReportBusiness/'+ssId+'/'+year+'/'+month})
					  
					  
					    .success(function (data, status, headers, config) {
					      return data;
					    })
					    .error(function (data, status, headers, config) {
					      return {"status": false};
					    });
					  
					  return promise;
				  },
				  
				  getAppReportBusinessExpire: function (ssId,year,month) {
						  var promise = $http({method:'GET', url:urlBase+'/getAppReportBusinessExpire/'+ssId+'/'+year+'/'+month})
						  
						  
						    .success(function (data, status, headers, config) {
						      return data;
						    })
						    .error(function (data, status, headers, config) {
						      return {"status": false};
						    });
						  
						  return promise;
					  },
					  
					  getAppReportBusinessStartDate: function (ssId,year) {
							  var promise = $http({method:'GET', url:urlBase+'/getAppReportStartDateBusiness/'+ssId+'/'+year})
							  
							  
							    .success(function (data, status, headers, config) {
							      return data;
							    })
							    .error(function (data, status, headers, config) {
							      return {"status": false};
							    });
							  
							  return promise;
						  },
						  
					getAppReportPaid: function (year,month) {
						// alert(year+""+month);
							  var promise = $http({method:'GET', url:urlBase+'/getReportPaid/'+year+'/'+month})
							  
							  
							    .success(function (data, status, headers, config) {
							      return data;
							    })
							    .error(function (data, status, headers, config) {
							      return {"status": false};
							    });
							  
							  return promise;
						  },
						  
							getAppReportTrial: function (year,month) {
								// alert(year+""+month);
									  var promise = $http({method:'GET', url:urlBase+'/getReportTrial/'+year+'/'+month})
									  
									  
									    .success(function (data, status, headers, config) {
									      return data;
									    })
									    .error(function (data, status, headers, config) {
									      return {"status": false};
									    });
									  
									  return promise;
								  },
								  
								  getReportYearMonthAll: function (year,month) {
									  var promise = $http({method:'GET', url:urlBase+'/getReportsYearMonth/'+year+'/'+month})
									  
									  
									    .success(function (data, status, headers, config) {
									      return data;
									    })
									    .error(function (data, status, headers, config) {
									      return {"status": false};
									    });
									  
									  return promise;
								  },
								  
								  getReportYearytdpaid: function (year) {
									  var promise = $http({method:'GET', url:urlBase+'/getReportYearPaidYTD/'+year})
									    .success(function (data, status, headers, config) {
									      return data;
									    })
									    .error(function (data, status, headers, config) {
									      return {"status": false};
									    });
									  
									  return promise;
								  },
								  getReportYearytdtrial: function (year) {
									  var promise = $http({method:'GET', url:urlBase+'/getReportYeartRIALYTD/'+year})
									    .success(function (data, status, headers, config) {
									      return data;
									    })
									    .error(function (data, status, headers, config) {
									      return {"status": false};
									    });
									  
									  return promise;
								  },
								  
								  getReportYearYTDAll: function (year) {
									  var promise = $http({method:'GET', url:urlBase+'/getReportsYear/'+year})
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
	
	app.controller('appsReportController', function ($scope, $filter,$http,ajaxService) {
		
		var urlBase="<%=path%>";
		$scope.monthArray=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		$scope.yearItems=[2011,2012,2013,2014,2015,2016,2017,2018,2019,2020];
	    $scope.month='';
	    $scope.monData='';
	    //by aman
	    $scope.ssId='';
	    $scope.year='<%=year%>';
	    $scope.monthdefault=<%=monthdefault%>;
	    $scope.itemsPerPage = 6;
		$scope.currentPage = 0;
		$scope.allItems=[]; 
		//by aman
		$scope.allBusinessItems=[]; 
		$scope.plan='';
	    $scope.month= $scope.monthArray[parseInt($scope.monthdefault)];
		$scope.predicate ='-lastUpdateDate';
		$scope.allItemCopy=[];
		//by aman
		$scope.counts=0;
		$scope.subscribe=0;
		$scope.expire=0;
		$scope.allBusinessItemCopy=[];
	    $scope.totalAmount=0; 
	    var filterValue=[];
	    $scope.typeOfUsers='ALL';
	    $scope.IsVisible = true;
	    $scope.IsVisible1 = false;
	    $scope.orderByField = 'application_TYPE';
	    $scope.reverseSort = false;
	    $scope.IsVisiblebutton=true;
	    $scope.IsVisiblebuttonytd=false;	
	    
	    $scope.IsVisiblebuttonAll=true;
	    $scope.IsVisiblebuttonAll1=false;
	    
	    $scope.IsVisiblebuttonpaid=true;
	    $scope.IsVisiblebuttonpaid1=false;
	    
	    $scope.IsVisiblebuttontrial=true;
	    $scope.IsVisiblebuttontrial1=false;
	    
	    $scope.IsVisiblebuttonytdALL=false;
	    $scope.IsVisiblebuttonytdALL1=false;
	    
	    $scope.IsVisiblebuttonytdPAID=false;
	    $scope.IsVisiblebuttonytdPAID1=false;
	    
	    $scope.IsVisiblebuttonytdTRIAL=false;
	    $scope.IsVisiblebuttonytdTRIAL1=false;
	    
			ajaxService.getReportYearMonth($scope.year,$scope.month).then(function(promise) {
				
			 $scope.allItems =promise.data;
			 $scope.allItemCopy=promise.data;
			 $("#loadingimg").css("display","none");
			 $("#newReport").show();
			 
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
				    $scope.expire+=$scope.allItems[i].expire;
		    		$scope.counts+=$scope.allItems[i].counts;
		    	}
			 
			 chartTableMethod2($scope.year,$scope.month,$scope.counts);
			 chartTableMethodSubscribe2($scope.year,$scope.month,$scope.subscribe);
			 chartTableMethodExpire2($scope.year,$scope.month,$scope.expire);
			   $("ul.horizon").each(function(){
					$(this).find('li').removeClass('active');
				});
				$("li#horizmonth"+($scope.monthdefault)).addClass('active');
			
		});
			
			
			 $scope.search1=function(){
			    	$scope.currentPage=0;
			    	var searchText=$("#searchText").val();
			    	if(searchText==""){
			    		$scope.allBusinessItems=$scope.allBusinessItemCopy;
			    		
			    		if($scope.allBusinessItemCopy.length>0){
							$("#norecordRow").css("display","none");
							$("#paginationRow").show();
			    		}else if($scope.allBusinessItemCopy.length==0){
			    			$("#norecordRow").show();
							$("#paginationRow").css("display","none");
			    		}
			    	}else{
			    		$scope.allBusinessItems=$filter('filter')($scope.allBusinessItemCopy, searchText);
			    		if($scope.allBusinessItems.length>0){
							$("#norecordRow").css("display","none");
							$("#paginationRow").show();
			    		}else if($scope.allBusinessItems.length==0){
			    			$("#norecordRow").show();
							$("#paginationRow").css("display","none");
			    		}
					 }
			    }
			 
			  $scope.search2=function(){
			    	$scope.currentPage=0;
			    	$scope.subscribe=0;
			    	$scope.expire=0;
					$scope.counts=0;	
			    	var searchText=$("#searchText2").val();
			    	if(searchText==""){
			    		$scope.allItems=$scope.allItemCopy;
			    		
			    		if($scope.allItemCopy.length>0){
							$("#norecordRow").css("display","none");
							$("#paginationRow").show();
			    		}else if($scope.allItemCopy.length==0){
			    			$("#norecordRow").show();
							$("#paginationRow").css("display","none");
			    		}
			    	}else{
			    		$scope.allItems=$filter('filter')($scope.allItemCopy, searchText);
			    		if($scope.allItems.length>0){
							$("#norecordRow").css("display","none");
							$("#paginationRow").show();
			    		}else if($scope.allItems.length==0){
			    			$("#norecordRow").show();
							$("#paginationRow").css("display","none");
			    		}
					 }
			    	
			    	for(var i=0;i<$scope.allItems.length;i++){
			    		$scope.subscribe+=$scope.allItems[i].subs;
			    		$scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    	}
			    	
			    }
		
		 $scope.onYear=function(){
			// $("#compareDivs1").hide(); 
			//chartTableMethodPIEchart($scope.year);
			 $("#compareDivs").hide(); 
			 $("#dashBoardGraphDiv").show(); 
			 $("#priPanel").css("margin-top","-50px");
			 $scope.currentPage=0;
			 $scope.subscribe=0;
			 $scope.expire=0;
			 $scope.counts=0;
			 $scope.month=$scope.monthArray[parseInt($scope.monthdefault)];
			 ajaxService.getReportYearMonth($scope.year,$scope.month).then(function(promise) {
				 $scope.allItems =promise.data;
				 $scope.allItemCopy=promise.data;
				 $("#loadingimg").css("display","none");
				 $("#newReport").show();
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
					    $scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    	}
				 chartTableMethod2($scope.year,$scope.month,$scope.counts);
				 chartTableMethodSubscribe2($scope.year,$scope.month,$scope.subscribe);
				 chartTableMethodExpire2($scope.year,$scope.month,$scope.expire);
				 chartTableMethodPIEchart($scope.year);
				 $("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
					});
				 $("li#horizmonth"+($scope.monthdefault)).addClass('active');
				
			});
			 $scope.IsVisible = true;
			 $scope.IsVisible1 = false;
			// $scope.IsVisiblebutton=true;
		     $scope.IsVisiblebuttonytd=false;
		     
		     $scope.IsVisiblebuttonAll=true;
			 $scope.IsVisiblebuttonAll1=false;
			 
			 $scope.IsVisiblebuttonpaid=true;
			 $scope.IsVisiblebuttonpaid1=false;
			 
			 $scope.IsVisiblebuttontrial=true;
			 $scope.IsVisiblebuttontrial1=false;
			 $scope.IsVisiblebuttonytdALL=false;
			 $scope.IsVisiblebuttonytdALL1=false;
			 $scope.IsVisiblebuttonytdPAID=false;
			 $scope.IsVisiblebuttonytdPAID1=false;
			 $scope.IsVisiblebuttonytdTRIAL=false;
			 $scope.IsVisiblebuttonytdTRIAL1=false;
	  };
			 
		 $scope.clickOnMonth=function(monData){
			// $("#compareDivs1").hide(); 
			//chartTableMethodPIEchart($scope.year);
			 $("#compareDivs").hide(); 
			 $("#dashBoardGraphDiv").show(); 
			 $("#priPanel").css("margin-top","-50px");
			 $scope.currentPage=0;
			 $scope.subscribe=0;
			 $scope.expire=0;
			 $scope.counts=0;
			 $scope.monData=monData;
			 $scope.month= $scope.monthArray[parseInt(monData)-1]; 
			 $scope.busCount=0;
			 ajaxService.getReportYearMonth($scope.year,$scope.month).then(function(promise) {
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
					    $scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    	}
				 chartTableMethod2($scope.year,$scope.month,$scope.counts);
				 chartTableMethodSubscribe2($scope.year,$scope.month,$scope.subscribe);
				 chartTableMethodExpire2($scope.year,$scope.month,$scope.expire);
				 chartTableMethodPIEchart($scope.year);
				 $("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
					});
					$("li#horizmonth"+(monData-1)).addClass('active');
			 
			});
			    $scope.IsVisible = true;
			    $scope.IsVisible1 = false;
			   // $scope.IsVisiblebutton=true;
				$scope.IsVisiblebuttonytd=false;
				
				 $scope.IsVisiblebuttonAll=true;
				 $scope.IsVisiblebuttonAll1=false;
				 
				 $scope.IsVisiblebuttonpaid=true;
				 $scope.IsVisiblebuttonpaid1=false;
				 
				 $scope.IsVisiblebuttontrial=true;
				 $scope.IsVisiblebuttontrial1=false;
				 $scope.IsVisiblebuttonytdALL=false;
				 $scope.IsVisiblebuttonytdALL1=false;
				 $scope.IsVisiblebuttonytdPAID=false;
				 $scope.IsVisiblebuttonytdPAID1=false;
				 $scope.IsVisiblebuttonytdTRIAL=false;
				 $scope.IsVisiblebuttonytdTRIAL1=false;
			   
		};
		 
		 $scope.Year=function(){
			 //chartTableMethodPIEchart($scope.year);
			$("#compareDivs1").hide(); 
			 $("#compareDivs").hide(); 
			 $("#dashBoardGraphDiv").show(); 
			 $("#priPanel").css("margin-top","-50px");
			 
			 $scope.currentPage=0;
			 $scope.subscribe=0;
			 $scope.expire=0;
			 $scope.counts=0;
			 ajaxService.getReportYear($scope.year).then(function(promise) {
				 $scope.allItems =promise.data;
				 $scope.allItemCopy=promise.data;
				 $("#loadingimg").css("display","none");
				 $("#newReport").show();
				 
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
					    $scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    		
			    	}
				 chartTableMethod($scope.year,$scope.counts);
				 chartTableMethodPIEchart($scope.year);
				 
				
				 
				 $("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
					});
				 $("li#year").addClass('active');
			});
				
				
				 $scope.IsVisible = false;
				 $scope.IsVisible1 = true;
				// $scope.IsVisiblebutton=false;
				  $scope.IsVisiblebuttonAll=false;
				  $scope.IsVisiblebuttonpaid=false;
				  $scope.IsVisiblebuttontrial=false;
				  $scope.IsVisiblebuttonAll1=false;
				  $scope.IsVisiblebuttonpaid1=false;
				  $scope.IsVisiblebuttontrial1=false;
				 //$scope.IsVisiblebuttonytd=true;
				  $scope.IsVisiblebuttonytdALL=true;
				  $scope.IsVisiblebuttonytdALL1=false;
				  
				    $scope.IsVisiblebuttonytdPAID=true;
				    $scope.IsVisiblebuttonytdPAID1=false;
				    
				    $scope.IsVisiblebuttonytdTRIAL=true;
				    $scope.IsVisiblebuttonytdTRIAL1=false;
	             };
		 	 
		
		 $scope.appbusiness=function(ssId,year,month,plan){
			 $scope.currentPage = 0;
			 $scope.searchText='';
			 $scope.ssId=ssId;
			 $scope.year=year;
			 $scope.month=month;
			 $scope.plan=plan;
			 ajaxService.getAppReportBusiness($scope.ssId,$scope.year,$scope.month).then(function(promise) {
				 $scope.allBusinessItems=promise.data;
				 $scope.allBusinessItemCopy=promise.data; 
				
				 $("#loadingimg").css("display","none");
				 if($scope.allBusinessItems.length>0){
						$("#norecordRow").css("display","none");
						$("#paginationRow").show();
						 $("#totalamount").show();
		       	 }else if($scope.allBusinessItems.length==0){
		    			$("#norecordRow").show();
						$("#paginationRow").css("display","none");
						$("#totalamount").hide();
		    	 } 
			});	
			 
		};
		 
		 
		 $scope.appbusinessExpire=function(ssId,year,month,plan){
			 $scope.currentPage=0;
			 $scope.searchText='';
			 $scope.ssId=ssId;
			 $scope.year=year;
			 $scope.month=month;
			 $scope.plan=plan;
			 ajaxService.getAppReportBusinessExpire($scope.ssId,$scope.year,$scope.month).then(function(promise) {
				 $scope.allBusinessItems=promise.data;
				 $scope.allBusinessItemCopy=promise.data; 
				 $("#loadingimg").css("display","none");
				 if($scope.allBusinessItems.length>0){
						$("#norecordRow").css("display","none");
						$("#paginationRow").show();
						 $("#totalamount").show();
		       	 }else if($scope.allBusinessItems.length==0){
		    			$("#norecordRow").show();
						$("#paginationRow").css("display","none");
						$("#totalamount").hide();
		    	 } 
			});	   
		};
		
		
		 $scope.appbusinessStartDate=function(ssId,year,plan){
			 $scope.currentPage=0;
			 $scope.searchText='';
			 $scope.ssId=ssId;
			 $scope.year=year;
			 $scope.plan=plan;
			 ajaxService.getAppReportBusinessStartDate($scope.ssId,$scope.year).then(function(promise) {
				 $scope.allBusinessItems=promise.data;
				 $scope.allBusinessItemCopy=promise.data; 
				 $("#loadingimg").css("display","none");
				 if($scope.allBusinessItems.length>0){
						$("#norecordRow").css("display","none");
						$("#paginationRow").show();
						 $("#totalamount").show();
		       	 }else if($scope.allBusinessItems.length==0){
		    			$("#norecordRow").show();
						$("#paginationRow").css("display","none");
						$("#totalamount").hide();
		    	 } 
			});	   
		};
			
		
		
		
		 $scope.paid=function(year,month){
			// $("#compareDivs1").hide(); 
			 $("#compareDivs").hide(); 
			 $("#dashBoardGraphDiv").show(); 
			 $("#priPanel").css("margin-top","-50px");
			 
			 $scope.currentPage=0;
			 $scope.subscribe=0;
			 $scope.expire=0;
			 $scope.counts=0;
			 $scope.year=year;
			 $scope.month=month;
			 //$scope.month=$scope.monthArray[parseInt($scope.monthdefault)];
			 ajaxService.getAppReportPaid($scope.year,$scope.month).then(function(promise) {
				 $scope.allItems =promise.data;
				 $scope.allItemCopy=promise.data;
				 $("#loadingimg").css("display","none");
				 $("#newReport").show();
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
					    $scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    	}
				 chartTableMethod2($scope.year,$scope.month,$scope.counts);
				 chartTableMethodSubscribe2($scope.year,$scope.month,$scope.subscribe);
				 chartTableMethodExpire2($scope.year,$scope.month,$scope.expire);
					$("li#horizmonth"+(monData-1)).addClass('active');
				
				
			});
			 $scope.IsVisible = true;
			 $scope.IsVisible1 = false;
			 
			 
			 $scope.IsVisiblebuttonAll=false;
			 $scope.IsVisiblebuttonAll1=true;
			 
			 $scope.IsVisiblebuttonpaid=false;
			 $scope.IsVisiblebuttonpaid1=true;
			 
			 $scope.IsVisiblebuttontrial=true;
			 $scope.IsVisiblebuttontrial1=false;
	  };
		
	  
	  $scope.trial=function(year,month){
			// $("#compareDivs1").hide(); 
			 $("#compareDivs").hide(); 
			 $("#dashBoardGraphDiv").show(); 
			 $("#priPanel").css("margin-top","-50px");
			 
			 $scope.currentPage=0;
			 $scope.subscribe=0;
			 $scope.expire=0;
			 $scope.counts=0;
			 $scope.year=year;
			 $scope.month=month;
			 //$scope.month=$scope.monthArray[parseInt($scope.monthdefault)];
			 ajaxService.getAppReportTrial($scope.year,$scope.month).then(function(promise) {
				 $scope.allItems =promise.data;
				 $scope.allItemCopy=promise.data;
				 $("#loadingimg").css("display","none");
				 $("#newReport").show();
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
					    $scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    	}
				 chartTableMethod2($scope.year,$scope.month,$scope.counts);
				 chartTableMethodSubscribe2($scope.year,$scope.month,$scope.subscribe);
				 chartTableMethodExpire2($scope.year,$scope.month,$scope.expire);
					$("li#horizmonth"+(monData-1)).addClass('active');
				
				
			});
			 $scope.IsVisible = true;
			 $scope.IsVisible1 = false;
			 
			 $scope.IsVisiblebuttonAll=false;
			 $scope.IsVisiblebuttonAll1=true;
			 
			 $scope.IsVisiblebuttonpaid=true;
			 $scope.IsVisiblebuttonpaid1=false;
			 
			 $scope.IsVisiblebuttontrial=false;
			 $scope.IsVisiblebuttontrial1=true;
	  };
		
	  $scope.onYearAll=function(year,month){ 
			// $("#compareDivs1").hide(); 
			 $("#compareDivs").hide(); 
			 $("#dashBoardGraphDiv").show(); 
			 $("#priPanel").css("margin-top","-50px");
			 
			 $scope.currentPage=0;
			 $scope.subscribe=0;
			 $scope.expire=0;
			 $scope.counts=0;
			 $scope.year=year;
			 $scope.month=month;
			 ajaxService.getReportYearMonthAll($scope.year,$scope.month).then(function(promise) {
				 $scope.allItems =promise.data;
				 $scope.allItemCopy=promise.data;
				 $("#loadingimg").css("display","none");
				 $("#newReport").show();
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
					    $scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    	}
				 chartTableMethod2($scope.year,$scope.month,$scope.counts);
				 chartTableMethodSubscribe2($scope.year,$scope.month,$scope.subscribe);
				 chartTableMethodExpire2($scope.year,$scope.month,$scope.expire);
				 $("li#horizmonth"+(monData-1)).addClass('active');
				
			});
			 $scope.IsVisible = true;
			 $scope.IsVisible1 = false;
			 
			 $scope.IsVisiblebuttonAll=true;
			 $scope.IsVisiblebuttonAll1=false;
			 
			 $scope.IsVisiblebuttonpaid=true;
			 $scope.IsVisiblebuttonpaid1=false;
			 
			 $scope.IsVisiblebuttontrial=true;
			 $scope.IsVisiblebuttontrial1=false;
	  };
		
	  
	  
	  
	  $scope.paidytd=function(year){
			 //chartTableMethod($scope.year);
			 $("#compareDivs1").hide(); 
			 $("#compareDivs").hide(); 
			 $("#dashBoardGraphDiv").show(); 
			 $("#priPanel").css("margin-top","-50px");
			 
			 $scope.currentPage=0;
			 $scope.subscribe=0;
			 $scope.expire=0;
			 $scope.counts=0;
			 $scope.year=year;
			 ajaxService.getReportYearytdpaid($scope.year).then(function(promise) {
				 $scope.allItems =promise.data;
				 $scope.allItemCopy=promise.data;
				 $("#loadingimg").css("display","none");
				 $("#newReport").show();
				 
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
					    $scope.expire+=$scope.allItems[i].expire;
			    		$scope.counts+=$scope.allItems[i].counts;
			    		
			    	}
				 chartTableMethod($scope.year,$scope.counts);
				 $("ul.horizon").each(function(){
						$(this).find('li').removeClass('active');
					});
				 $("li#year").addClass('active');
			});
				
				
				 $scope.IsVisible = false;
				 $scope.IsVisible1 = true;
				 
				 $scope.IsVisiblebuttonytdALL=false;
				 $scope.IsVisiblebuttonytdALL1=true;
				 
				 $scope.IsVisiblebuttonytdPAID=false;
				 $scope.IsVisiblebuttonytdPAID1=true;
				 
				 $scope.IsVisiblebuttonytdTRIAL=true;
				 $scope.IsVisiblebuttonytdTRIAL1=false;
				 
	             };
	             
	             $scope.trialytd=function(year){
	    			 //chartTableMethod($scope.year);
	    			 $("#compareDivs1").hide(); 
	    			 $("#compareDivs").hide(); 
	    			 $("#dashBoardGraphDiv").show(); 
	    			 $("#priPanel").css("margin-top","-50px");
	    			 
	    			 $scope.currentPage=0;
	    			 $scope.subscribe=0;
	    			 $scope.expire=0;
	    			 $scope.counts=0;
	    			 $scope.year=year;
	    			 ajaxService.getReportYearytdtrial($scope.year).then(function(promise) {
	    				 $scope.allItems =promise.data;
	    				 $scope.allItemCopy=promise.data;
	    				 $("#loadingimg").css("display","none");
	    				 $("#newReport").show();
	    				 
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
	    					    $scope.expire+=$scope.allItems[i].expire;
	    			    		$scope.counts+=$scope.allItems[i].counts;
	    			    		
	    			    	}
	    				 chartTableMethod($scope.year,$scope.counts);
	    				 $("ul.horizon").each(function(){
	    						$(this).find('li').removeClass('active');
	    					});
	    				 $("li#year").addClass('active');
	    			});
	    				
	    				
	    				 $scope.IsVisible = false;
	    				 $scope.IsVisible1 = true;
	    				 
	    				    $scope.IsVisiblebuttonytdALL=false;
	    				    $scope.IsVisiblebuttonytdALL1=true;
	    				    
	    				    $scope.IsVisiblebuttonytdPAID=true;
	    				    $scope.IsVisiblebuttonytdPAID1=false;
	    				    
	    				    $scope.IsVisiblebuttonytdTRIAL=false;
	    					$scope.IsVisiblebuttonytdTRIAL1=true;
	    				 
	    	             };
	    	             
	    	             $scope.onYearAllytd=function(year){
	    	    			 //chartTableMethod($scope.year);
	    	    			 $("#compareDivs1").hide(); 
	    	    			 $("#compareDivs").hide(); 
	    	    			 $("#dashBoardGraphDiv").show(); 
	    	    			 $("#priPanel").css("margin-top","-50px");
	    	    			 
	    	    			 $scope.currentPage=0;
	    	    			 $scope.subscribe=0;
	    	    			 $scope.expire=0;
	    	    			 $scope.counts=0;
	    	    			 $scope.year=year;
	    	    			 ajaxService.getReportYearYTDAll($scope.year).then(function(promise) {
	    	    				 $scope.allItems =promise.data;
	    	    				 $scope.allItemCopy=promise.data;
	    	    				 $("#loadingimg").css("display","none");
	    	    				 $("#newReport").show();
	    	    				 
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
	    	    					    $scope.expire+=$scope.allItems[i].expire;
	    	    			    		$scope.counts+=$scope.allItems[i].counts;
	    	    			    		
	    	    			    	}
	    	    				 chartTableMethod($scope.year,$scope.counts);
	    	    				 $("ul.horizon").each(function(){
	    	    						$(this).find('li').removeClass('active');
	    	    					});
	    	    				 $("li#year").addClass('active');
	    	    			});
	    	    				
	    	    				
	    	    				 $scope.IsVisible = false;
	    	    				 $scope.IsVisible1 = true;
	    	    				 
	    	    				$scope.IsVisiblebuttonytdALL=true;
	 	    				    $scope.IsVisiblebuttonytdALL1=false;
	 	    				    
	 	    				    $scope.IsVisiblebuttonytdPAID=true;
	 	    				    $scope.IsVisiblebuttonytdPAID1=false;
	 	    				    
	 	    				     $scope.IsVisiblebuttonytdTRIAL=true;
	 	    					 $scope.IsVisiblebuttonytdTRIAL1=false;
	    	    	             };
	    	    	  
	    	  
	  
		
		$scope.refresh=function()
		{
			//location.reload(false);
		}
		
			
		//---------------------------Code for pagination -------------------------------
			$scope.range = function() {
					var rangeSize;
					if($scope.allBusinessItems.length <= $scope.itemsPerPage){
						rangeSize = 1;
						
					}
					else if($scope.allBusinessItems.length > $scope.itemsPerPage*5){
						rangeSize = 5;
					}
					else if($scope.allBusinessItems.length > $scope.itemsPerPage*10){
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
		    return Math.ceil($scope.allBusinessItems.length/$scope.itemsPerPage)-1;
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
		 $scope.appReportSubcribeExport = function() {
						    	 window.open('<%=path%>/exportAppreportSubcribe?&ssId='+$scope.ssId+'&year='+$scope.year+'&month='+$scope.month+'&plantype='+$scope.plan);
							      }
							      
		 $scope.appReportStartDateExport = function() {
	    	 window.open('<%=path%>/exportAppreportStartdate?&ssId='+$scope.ssId+'&year='+$scope.year+'&plantype='+$scope.plan);
		      }
		 $scope.appReportExpireExport = function() {
			 window.open('<%=path%>/exportAppreportExpire?&ssId='+$scope.ssId+'&year='+$scope.year+'&month='+$scope.month+'&plantype='+$scope.plan);
		      }
		 
	});
		
</script>

     </head>
<body ng-app="appsReport" ng-controller="appsReportController">

<div class="container" style="margin-top:10px;width: 100%;" >
	  		<jsp:include page="/header.jsp"></jsp:include>
   		<div id="menuHeader">
   			<jsp:include page="/headerMenu.jsp"></jsp:include>
   		</div>
   		<div class="form-group"  id="dashBoardGraphDiv" style="background-color: #0088cc;color:white;width:100%;height: 342px;margin-top: -15px;"> <!-- id="dashBoardGraphDiv" -->
   			<jsp:include page="/jsp/appsReport/appsReportGraph.jsp"></jsp:include>
   		</div> 
   		<br/>
   		 <div class="form-inline" id="compareDivs" style="display:none;">
   		 <div style="margin-top: -15px;background-color: green;">
   	    <div class="loading-spiner" id="loadingForDistributor" style="min-height: 500px;height:600;width: 49%;text-align: center;float:left;background-color: #0088cc">
				<span style="font-size: 12px;font-family: verdana;margin-top: 126px;position: absolute;font-weight: bold;margin-left: 15px;color:white">Loading...</span>
						<img class="loadingImg" src="<%=path%>/resources/images/loadingGraphImg.png" style="margin-top:90px;position:absolute;width: 95px;height: 95px;">
    	</div> 
   	    <div id="mainDataForDistributor" style="width:49%;float:left;">
   	      <table class="table borderless"  id="distributorChartTable" style="background-color: #0088cc;margin-bottom: 0px; ">
   		    
   		     <tr>
   			
   		    	 <td>  
   		    	 <!--  <div ng-show="true" class="form-group ng-show" style="margin-left: 1px;width: 125px;display: block;position: absolute;">--> 
   		    	  
					<span style="font-size:17px;color:white"><b>Year</b></span> 
				      <span>
					  
					  	  <select id="yearLeft" selectleft="selectleft"  onchange="compare(this)" style="border:1px solid #ddd;width:68px;height:28px;margin-top: 5px;">
							<option >2010</option>
							<option >2011</option>
							<option >2012</option>
							<option >2013</option>
							<option >2014</option>
							<option >2015</option>
							<option >2016</option>
							<option >2017</option>
							<option >2018</option>
							<option >2019</option>
							<option >2020</option>
							<option >2021</option>
							<option >2022</option>
							<option >2023</option>
							<option >2024</option>
							<option >2025</option>
						</select>  
						
					  </span> 
					 <!--  <span class='countYearTotalLeft'>
					  </span>-->
	  			<!--  </div> -->
	  			</td>
   			</tr>
   			
   		
   		 <tbody>
   			
   			<tr>
   			<td style="width: 39%;color:white;" class='countYearTotal'><center><b>Total User:</b>  <b id="countYearTotalLeft"></b></center></td>
   			<!--  <td style="width: 39%;color:white;" id="countYearTotalLeft">-->
   			<!--  -<span id='countYearTotalLeft'>
		    </span>-->
   			</td>
   			
   			</tr>
   			<tr style="height: 250px;">
   			
   			<td style="cursor: pointer;" id="Estimates1" onClick="bigGraphClick(this)"></td>
   			</tr>
   			
   		</tbody>
   	</table> 
   	 
</div>
 </div>
    <div style="margin-top: -23px;background-color: red">
    <div class="loading-spiner" id="loadingForCompare" style="min-height: 500px;height:600;width: 49%;text-align: center;float:right;background-color: #0088cc;"  >
				<span style="font-size: 12px;font-family: verdana;margin-top: 126px;position: absolute;font-weight: bold;margin-left: 15px;color:white">Loading...</span>
						<img class="loadingImg" src="<%=path%>/resources/images/loadingGraphImg.png" style="margin-top:90px;position:absolute;width: 95px;height: 95px;">
	</div>
	<div id="compareDistributor" style="width:49%;float:right">
	 <table class="table borderless"  id="compareTable2" style="background-color: #0088cc;margin-bottom: 0px; ">
   		
   		    <tr style="height:">
   			 <td>   
					<span style="font-size:17px;color:white"><b>Year</b></span> 
				      <span>
					  
						  <select id="yearRight" selectright="selectright" onchange="compare(this)" style="border:1px solid #ddd;width:68px;height:28px;margin-top: 5px;">
							<option >2010</option>
							<option >2011</option>
							<option >2012</option>
							<option >2013</option>
							<option >2014</option>
							<option >2015</option>
							<option >2016</option>
							<option >2017</option>
							<option >2018</option>
							<option >2019</option>
							<option >2020</option>
							<option >2021</option>
							<option >2022</option>
							<option >2023</option>
							<option >2024</option>
							<option >2025</option>
						</select>
						  </span> 
					<!--    <span class='countYearTotalRight'>
					  </span>-->
					  </span> 
	  			 </td>
   			</tr>
   		
   		<tbody>
   		   	<tr>
   			<td style="width: 39%;color:white;"><center><b>Total User:</b>  <b id="countYearTotalRight"></b></center></td>
   			</tr>
   			<tr style="height: 250px;">
   			
   			<td style="cursor: pointer;" id="Estimates2" onClick="bigGraphClick(this)"></td>
   			</tr>
   			
   		</tbody>
   	</table> 
   	
</div>
</div>
</div>
   		
   		
   		<!-- Ytd -->
   		
   		
   		 <div class="form-inline" id="compareDivs1" style="display:none;">
   		 <div style="margin-top: -23px;background-color: green;">
   	    
   	    <div class="loading-spiner" id="loadingForDistributor1" style="min-height: 500px;height:600;width: 49%;text-align: center;float:left;background-color: #0088cc">
				<span style="font-size: 12px;font-family: verdana;margin-top: 126px;position: absolute;font-weight: bold;margin-left: 15px;color:white">Loading...</span>
						<img class="loadingImg" src="<%=path%>/resources/images/loadingGraphImg.png" style="margin-top:90px;position:absolute;width: 95px;height: 95px;">
    	</div> 
   	    
   	    <div id="mainDataForDistributor1" style="width:49%;float:left;">
   	      <table class="table borderless"  id="distributorChartTable" style="background-color: #0088cc;margin-bottom: 0px; ">
   		    
   		     <tr>
   			
   		    	 <td>  
   		    	 <!--  <div ng-show="true" class="form-group ng-show" style="margin-left: 1px;width: 125px;display: block;position: absolute;">--> 
   		    	  
					<span style="font-size:17px;color:white"><b>Year</b></span> 
				      <span>
					  
					  	  <select id="yearLeft1" selectleft="selectleft"  onchange="compareytd(this)" style="border:1px solid #ddd;width:68px;height:28px;margin-top: 5px;">
							<option >2010</option>
							<option >2011</option>
							<option >2012</option>
							<option >2013</option>
							<option >2014</option>
							<option >2015</option>
							<option >2016</option>
							<option >2017</option>
							<option >2018</option>
							<option >2019</option>
							<option >2020</option>
							<option >2021</option>
							<option >2022</option>
							<option >2023</option>
							<option >2024</option>
							<option >2025</option>
						</select>  
						
					  </span> 
	  			<!--  </div> -->
	  			</td>
   			</tr>
   			
   		
   		 <tbody>
   			
   			<tr>
   			<td style="width: 39%;color:white;"><center><b>Total User:</b>  <b id="calculateSumYTDLeft"></b></center></td>
   			</tr>
   			<tr style="height: 250px;">
   			
   			<td style="cursor: pointer;" id="Estimates1" onClick="bigGraphClick(this)"></td>
   			</tr>
   			
   		</tbody>
   	</table> 
   	 
</div>
 </div>
    <div style="margin-top: -23px;background-color: red">
    <div class="loading-spiner" id="loadingForCompare1" style="min-height: 500px;height:600;width: 49%;text-align: center;float:right;background-color: #0088cc;"  >
				<span style="font-size: 12px;font-family: verdana;margin-top: 126px;position: absolute;font-weight: bold;margin-left: 15px;color:white">Loading...</span>
						<img class="loadingImg" src="<%=path%>/resources/images/loadingGraphImg.png" style="margin-top:90px;position:absolute;width: 95px;height: 95px;">
	</div>
	<div id="compareDistributor1" style="width:49%;float:right">
	 <table class="table borderless"  id="compareTable2" style="background-color: #0088cc;margin-bottom: 0px; ">
   		
   		    <tr style="height:">
   			 <td>   
					<span style="font-size:17px;color:white"><b>Year</b></span> 
				      <span>
					  
						  <select id="yearRight1" selectright="selectright" onchange="compareytd(this)" style="border:1px solid #ddd;width:68px;height:28px;margin-top: 5px;">
							<option >2010</option>
							<option >2011</option>
							<option >2012</option>
							<option >2013</option>
							<option >2014</option>
							<option >2015</option>
							<option >2016</option>
							<option >2017</option>
							<option >2018</option>
							<option >2019</option>
							<option >2020</option>
							<option >2021</option>
							<option >2022</option>
							<option >2023</option>
							<option >2024</option>
							<option >2025</option>
						</select>
						 
					  </span> 
	  			 </td>
   			</tr>
   		
   		<tbody>
   		   	<tr>
   			<td style="width: 39%;color:white;"><center><b>Total User:</b>  <b id="calculateSumYTDRight"></b></center></td>
   			</tr>
   			<tr style="height: 250px;">
   			
   			<td style="cursor: pointer;" id="Estimates2" onClick="bigGraphClick(this)"></td>
   			</tr>
   			
   		</tbody>
   	</table> 
   	
</div>
</div>
</div>
<br/>
   		<br/>
   		<div>
			<ul class="nav nav-pills">
					<%-- <li id="globalsearch" ><a  href="<%=path%>/workflowGlobalSearch" style="padding-left: 10px;padding-right: 10px;" >Global Search</a></li> --%>
			</ul>
		</div>
		
<div class="panel panel-primary" id="priPanel" >
   				<div class="panel-heading">
   					<h3 class="panel-title">AppsReport</h3>
   					
   					<span class="exportInExel" style="margin-top: -25px;float: right;">
                    <!--  
 	                <button ng-click="alignguideExport()" class="btn btn-warning" style="padding: 6px 12px; margin-bottom: 0px; font-size: 14px; font-weight: 400; line-height: 1.42857; text-align: center; white-space: nowrap; vertical-align: middle; cursor: pointer; -moz-user-select: none; background-image: none; border: 1px solid transparent; border-radius: 4px;margin:-1px -16px;" id="autoZoneExport"><span style="margin-right: 6px;" class="glyphicon glyphicon-save"></span>Export</button>
 	               -->
 	                </span>
   				</div>
   				
   				<div class="panel-body" style="padding: 15px 0px 15px 0px;min-height: 600px;">	 			   				
	   			<div>
   				<div class="loading-spiner" id="loadingimg" style="margin: 50px 50px 0px 0px;display: block;" >
						<img src="<%=path%>/resources/images/gif-load.gif" style="margin-left:584px;margin-top:-16px;position:absolute;" />
				</div>
				
   				<div id="newReport" style="display: none;">	
   				
   				<div ng-show="true" class="form-group ng-show" style="margin-left: 10px;width: 125px;display: block;position: absolute;"> 
					<span style="font-size:17px;">Year</span> 
				      <span>
					  
						  <select id="year" ng-model="year"  ng-change="onYear()" style="border:1px solid #ddd;width:68px;height:42px;margin-top: 5px;">
							<!-- <option value=""></option> -->
							<option ng-selected="item == {{year}}" ng-repeat="item in yearItems" id="{{item}}" value="{{item}}">{{item}}</option>
						</select>  
					  </span> 
	  			</div>
	  
			  <div class="col-sm-11 ng-show" ng-show="true" id="horizMonth"  style="top: 5px;margin-left: 130px;width:65%"> 
		      <ul class="nav nav-tabs horizon">
		        <li class="horizmonth0" id="horizmonth0"  ng-click="clickOnMonth(1)" ><a href="#">Jan</a></li>
		        <li class="horizmonth1" id="horizmonth1"  ng-click="clickOnMonth(2)"><a href="#">Feb</a></li>
		        <li class="horizmonth2" id="horizmonth2"  ng-click="clickOnMonth(3)"><a href="#">Mar</a></li>
		        <li class="horizmonth3" id="horizmonth3"  ng-click="clickOnMonth(4)"><a href="#">Apr</a></li>
		        <li class="horizmonth4" id="horizmonth4"  ng-click="clickOnMonth(5)"><a href="#">May</a></li>
		        <li class="horizmonth5" id="horizmonth5"  ng-click="clickOnMonth(6)"><a href="#">Jun</a></li>
		        <li class="horizmonth6" id="horizmonth6"  ng-click="clickOnMonth(7)"><a href="#">Jul</a></li>
		        <li class="horizmonth7" id="horizmonth7"  ng-click="clickOnMonth(8)"><a href="#">Aug</a></li>
		        <li class="horizmonth8" id="horizmonth8"  ng-click="clickOnMonth(9)"><a href="#">Sep</a></li>
		        <li class="horizmonth9" id="horizmonth9"  ng-click="clickOnMonth(10)"><a href="#">Oct</a></li>
		        <li class="horizmonth10" id="horizmonth10"  ng-click="clickOnMonth(11)"><a href="#">Nov</a></li>
		        <li class="horizmonth11" id="horizmonth11"  ng-click="clickOnMonth(12)"><a href="#">Dec</a></li>
		        <li class="horizmonth12" id="year" ng-model="year" ng-click="Year()"><a href="#">YTD</a></li>
		      </ul>
		      
		    </div>
		    
   			<!--	<div class="" style='float: right;margin-top:5px; margin-right:18px;'> 
   				<input type="hidden" ng-model="year"><button type="button" class="btn btn-primary" ng-click="Year()"  style="height:40px;width:80px;">YTD</button>
   				<ul>
   				<li><a href="#">YTD</a></li>
   				</ul>
   				</div>-->
			    
			  <!--  <div class="" style='float: right;margin-top:10px; margin-right:200px;'> 
   				<ul>
   				<li class="horizmonth11" id="horizmonth11"><a href="#">YTD</a></li>
   				</ul>
   				</div>-->
			    
			     <div style="float: right; font-size: 13px; font-weight: normal; margin-top: -5px; display: block; margin-right:5px;" id="type_of_users">
	   		    	 <button ng-click="onYearAll(year,month)" id="ALL" style="padding: 4px 12px;" class="btn btn-danger" ng-show ="IsVisiblebuttonAll">ALL</button>
	   		    	 <button ng-click="onYearAll(year,month)" id="ALL" style="padding: 4px 12px;" class="btn btn-primary" ng-show ="IsVisiblebuttonAll1">ALL</button>
	   		    	 
	   		    	 <button ng-click="paid(year,month)" id="PAID" style="padding: 4px 12px;" class="btn btn-primary"  ng-show ="IsVisiblebuttonpaid">PAID</button>
	   		    	 <button ng-click="paid(year,month)" id="PAID" style="padding: 4px 12px;" class="btn btn-danger"  ng-show ="IsVisiblebuttonpaid1">PAID</button>
	   		    	 
	   				<button ng-click="trial(year,month)" id="YEAR" style="padding: 4px 12px;" class="btn btn-primary" ng-show ="IsVisiblebuttontrial">TRIAL</button>
	   				<button ng-click="trial(year,month)" id="YEAR" style="padding: 4px 12px;" class="btn btn-danger" ng-show ="IsVisiblebuttontrial1">TRIAL</button>
	   				
	   				
	   				 <button ng-click="onYearAllytd(year)" id="ALL" style="padding: 4px 12px;" class="btn btn-danger" ng-show ="IsVisiblebuttonytdALL">ALL</button>
	   				 <button ng-click="onYearAllytd(year)" id="ALL" style="padding: 4px 12px;" class="btn btn-primary" ng-show ="IsVisiblebuttonytdALL1">ALL</button>
	   				 
	   		    	 <button ng-click="paidytd(year)" id="PAID" style="padding: 4px 12px;" class="btn btn-primary" ng-show ="IsVisiblebuttonytdPAID">PAID</button>
	   		    	 <button ng-click="paidytd(year)" id="PAID" style="padding: 4px 12px;" class="btn btn-danger" ng-show ="IsVisiblebuttonytdPAID1">PAID</button>
	   		    	 
	   				<button ng-click="trialytd(year)" id="TRIAL" style="padding: 4px 12px;" class="btn btn-primary" ng-show ="IsVisiblebuttonytdTRIAL">TRIAL</button>
	   				<button ng-click="trialytd(year)" id="TRIAL" style="padding: 4px 12px;" class="btn btn-danger" ng-show ="IsVisiblebuttonytdTRIAL1">TRIAL</button>
			    </div>
			    
			         
			        <div id="form" ng-hide="form" style="width: 100%;margin-top: 0px;"  >
				        
		   			<div style="width: 100%;float: left;">	
		   				<div class="col-lg-6" style="margin:12px 0px -5px 0px;padding-left: 7px;width: 100%;float: left;">
						    <div class="form-group" style="width:50%;float: left;" >    
						      <!-- <input type="text" class="form-control" id="searchText" ng-model="searchText.$" placeholder="Search" type="search" ng-keyup="searchMethod()" ng-keydown="searchMethod()" autofocus>
						     -->
						   
						    <!-- <input type="text" class="form-control"  ng-model="search" placeholder="Search"   style="width:450px;" ng-change="intitalizeCount();"> -->
						      <input  type="text" class="form-control" id="searchText2" ng-model="searchText2" placeholder="Search" type="search2"    style="width:350px;" ng-change="search2()" autofocus>
						    </div>
						  
						    
							<div id="totalamount" align="right">
                             <!--  <b style="font-size:18px;color:green">Total Amount : <span>{{totalAmount | currency}}</span> </b>-->
                           <!--   <button ng-click="alignguideExport()" class="btn btn-warning" style="padding: 6px 12px; margin-bottom: 0px;  font-size: 14px; font-weight: 400; line-height: 1.42857; text-align: center; white-space: nowrap; vertical-align: middle; cursor: pointer; -moz-user-select: none; background-image: none; border: 1px solid transparent; border-radius: 4px;margin:-1px -16px;" id="autoZoneExport"><span style="margin-right: 6px;" class="glyphicon glyphicon-save"></span>Export</button>-->
                            </div>
						  </div><!-- /.col-lg-6 -->
		   				</div>
		   			
		   				<div  class="form-control" style="width: 100%;float:left;height: auto;border: 0px;padding: 0px;min-height: 603px;">	
			   				<table  class="table table-bordered">
								<thead style="background-color: #0088cc;color: white;">
									<tr>
										<!--<th ng-click="predicate = 'businessName'; reverse=!reverse" style="width: 5%;font-size: 14px;">APPLICATION_ID</th>-->
										<th  ng-click="orderByField='application_TYPE'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Application</th>
										<th  ng-click="orderByField='plan_TYPE'; reverseSort = !reverseSort"style="width: 10%;font-size: 14px;">Plan</th>
										<th  ng-click="orderByField='status'; reverseSort = !reverseSort" style="width: 7%;font-size: 14px;">Plan Type</th>
										<th  ng-click="orderByField='subs'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;" ng-show = "IsVisible">Subscriber</th>
										<th  ng-click="orderByField='expire'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;" ng-show = "IsVisible">Expired</th>
										<th  ng-click="orderByField='counts'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Total</th>	
									</tr>
								</thead>
								<tbody ng-init="count.subscribe=0;count.expire=0;count.counts=0;xyz=0;count1.counts1=0;">
								<tr ng-repeat="item in allItems|orderBy:orderByField:reverseSort" > <!-- | offset: currentPage*itemsPerPage | limitTo: itemsPerPage | orderBy:predicate:reverse"  -->
									         
									         <td style="font-size: 14px;">
								             <span ng-if="item.application_TYPE != ''"> {{item.application_TYPE}}<br></span> 
								             </td>
								          								
									         <td style="font-size: 14px;">
								             <span ng-if="item.plan_TYPE != ''"> {{item.plan_TYPE}}<br></span>
								             </td>
								             
								             <td style="font-size: 14px;">
									         <span ng-if="item.status != ''">{{item.status}}</span>
									         </td>
									        
									          <td style="font-size: 14px; text-align:right;" ng-if="item.subs ==0">
									          0
									          </td>
									        
									         <td data-toggle="modal" data-target="#myModal"   ng-click="appbusiness(item.ssID,year,month,item.plan_TYPE);" style="font-size: 14px; text-align:right;cursor: pointer;color:blue;"  ng-show = "IsVisible" ng-if="item.subs !=0">
									         <span><a href="#" data-toggle="tooltip" data-placement="bottom" title="Click to details">{{item.subs}}</a></span>
									         </td>
									        
									          <td style="font-size: 14px; text-align:right;" ng-if="item.expire ==0">
									          0
									          </td>
									       	
									         <td data-toggle="modal" data-target="#myModal1" ng-click="appbusinessExpire(item.ssID,year,month,item.plan_TYPE);" style="font-size: 14px;text-align:right;cursor: pointer;color:blue;"    ng-show ="IsVisible" ng-if="item.expire !=0">
									         <span><a href="#" data-toggle="tooltip" data-placement="bottom" title="Click to details">{{item.expire}}</a></span>
									         </td>
									   
									         <td style="font-size: 14px;text-align:right;" ng-show ="IsVisible">
									         <span>{{item.counts}}</span>
									         </td>
									         
									         <td data-toggle="modal" data-target="#myModal2"   ng-click="appbusinessStartDate(item.ssID,year,item.plan_TYPE);" style="font-size: 14px;text-align:right;cursor: pointer;color:blue;"  ng-show="IsVisible1">
									         <span><a href="#" data-toggle="tooltip" data-placement="bottom" title="Click to details">{{item.counts}}</a></span>
									         </td>	               	
								</tr>
								<tr>
								 <td colspan="3" style="background: #dff0d8;font: 14px sans-serif; height:45px;color:#000000; "><h5 style="margin-left:500px;text-align: right;">TotalCount</h5> </td><td style="background: #dff0d8;font: 14px;text-align:right;" ng-show = "IsVisible"><h5>{{subscribe}}</h5></td><td style="background: #dff0d8;font: 14px;text-align:right;" ng-show = "IsVisible"><h5>{{expire}}</h5></td><td style="background: #dff0d8;font: 14px;text-align:right;"><h5>{{counts}}</h5></td>
								</tr>
								</tbody>
								<tfoot>
									<tr id="norecordRow"style="display: none;">
							         <td colspan="11">
								            <div class="redColorText" style="text-align: center;font-weight: bold;" ng-model="norecord" >No Record Found</div>
							         </td>
							        </tr>
							      <!--  <tr id="paginationRow">
							          <td colspan="11">
								          <div  style="text-align: center;">
								            <ul class="pagination pagination-lg">
								            	
								              <li ng-init="count=0">
								                <a href ng-click="setPage(0)">« First</a>
								              </li> 
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
							        </tr>-->
						      </tfoot>
							</table>	
							</div>
					</div>
        	</div>
        	</div>	   
</div>
</div>
</div>
 <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog modal-lg" style="width: 1200px;">
    
      <!-- Modal content-->
        <div class="modal-body">
        <div  class="form-control" style="width: 100%;float:left;height:auto ;min-height: 60px;margin-top:30px">
        
          <button type="button" class="close" data-dismiss="modal"  style="margin-top:5px;margin-right:10px;">&times;</button>
          <table style="margin-left:10px;margin-top:-5px;"> <tr><td>{{month}}, {{year}}</td><td><h4 style="margin-left:450px;color:black;">{{plan}}</h4></td></tr></table>
        
     <input type="text" class="form-control" id="searchText" ng-model="searchText.$" placeholder="Search" type="search" ng-change="search1()"  style="margin-top:-2px;margin-bottom:-10px;width:350px;"  autofocus>
     <span class="exportInExel" style="margin-top:-20px;margin-bottom:-6px;margin-right:25px;float: right;">
 	 <button ng-click="appReportSubcribeExport()" class="btn btn-warning" style="padding: 6px 12px; margin-bottom: 0px; font-size: 14px; font-weight: 400; line-height: 1.42857; text-align: center; white-space: nowrap; vertical-align: middle; cursor: pointer; -moz-user-select: none; background-image: none; border: 1px solid transparent; border-radius: 4px;margin:-1px -16px;" id="autoZoneExport"><span style="margin-right: 6px;" class="glyphicon glyphicon-save"></span>Export</button>
 	 </span>
     <!-- <input type="text" class="form-control" id="searchText" ng-model="search1" placeholder="Search" type="search"  style="margin-top:-2px;margin-bottom:-10px;width:350px;">-->
        <hr>
			   				<table  class="table table-bordered" style="margin-top:-10px;">
								<thead style="background-color: #0088cc;color: white;">
									<tr>
										<!--<th ng-click="predicate = 'businessName'; reverse=!reverse" style="width: 5%;font-size: 14px;">APPLICATION_ID</th>-->
										<th  ng-click="orderByField='business_NAME'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">BusinessName</th>
										<th  ng-click="orderByField='plan_TYPE'; reverseSort = !reverseSort"style="width: 10%;font-size: 14px;">Plan</th>
										<th  ng-click="orderByField='trial'; reverseSort = !reverseSort" style="width: 7%;font-size: 14px;">Plan Type</th>
										<th  ng-click="orderByField='cycle_START_DATE'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Startdate</th>
										<th  ng-click="orderByField='cycle_END_DATE'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Enddate</th>
										<th  ng-click="orderByField='daysLeft'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Leftdays</th>	
									</tr>
								</thead>
								<tbody ng-init="count.subscribe=0;count.expire=0;count.counts=0;xyz=0;count1.counts1=0;">
								<tr ng-repeat="itembusiness in allBusinessItems|offset: currentPage*itemsPerPage | limitTo: itemsPerPage|orderBy:orderByField:reverseSort">
									         
									         <td style="font-size: 14px;">
								             <span> 
								             {{itembusiness.business_NAME}}<br>
								             {{itembusiness.address}}<br>
								             {{itembusiness.city}} {{itembusiness.phone_NUMBER}} <br>
								             {{itembusiness.email}}
								             </span> 
								             </td>
								          								
									         <td style="font-size: 14px;">
								             <span>{{itembusiness.plan_TYPE}}<br></span>
								             </td>
								             
								             <td style="font-size: 14px;">
									         <span>{{itembusiness.trial}}</span>
									         </td>
									        
									         <td style="font-size: 14px;">
									         <span>{{itembusiness.cycle_START_DATE}}</span>
									         </td>
									        
									       	
									         <td style="font-size: 14px;">
									         <span>{{itembusiness.cycle_END_DATE}}</span>
									         </td>
									   
									         <td style="font-size: 14px;" >
									         <span>{{itembusiness.daysLeft}}</span>
									         </td>	               	
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
							 <button type="button" class="btn btn-default" data-dismiss="modal" style="margin-top:-10px;margin-right:10px;float:right;color:white;background-color: #f44336;">Close</button>	
							</div>
							</div>
  </div>
</div><!-- end of modal --> 






<div class="modal fade" id="myModal1" role="dialog">
    <div class="modal-dialog modal-lg" style="width: 1200px;">
    
      <!-- Modal content-->
        <div class="modal-body">
        <div  class="form-control" style="width: 100%;float:left;height:auto ;min-height: 60px;margin-top:30px">
        
          <button type="button" class="close" data-dismiss="modal"  style="margin-top:5px;margin-right:10px;">&times;</button>
          <table style="margin-left:10px;margin-top:-5px;"> <tr><td>{{month}}, {{year}}</td><td><h4 style="margin-left:450px;color:black;">{{plan}}</h4></td></tr></table>
        
       <input type="text" class="form-control" id="searchText" ng-model="searchText.$" placeholder="Search" type="search" ng-change="search1()"   style="margin-top:-2px;margin-bottom:-10px;width:350px;" autofocus>
       <!--<input type="text" class="form-control" id="searchText1" ng-model="search1" placeholder="Search" type="search"  style="margin-top:-2px;margin-bottom:-10px;width:350px;">-->
        <span class="exportInExel" style="margin-top:-20px;margin-bottom:-6px;margin-right:25px;float: right;">
 	    <button ng-click="appReportExpireExport()" class="btn btn-warning" style="padding: 6px 12px; margin-bottom: 0px; font-size: 14px; font-weight: 400; line-height: 1.42857; text-align: center; white-space: nowrap; vertical-align: middle; cursor: pointer; -moz-user-select: none; background-image: none; border: 1px solid transparent; border-radius: 4px;margin:-1px -16px;" id="autoZoneExport"><span style="margin-right: 6px;" class="glyphicon glyphicon-save"></span>Export</button>
 	    </span>
        <hr>
			   				<table  class="table table-bordered" style="margin-top:-10px;">
								<thead style="background-color: #0088cc;color: white;">
									<tr>
										<!--<th ng-click="predicate = 'businessName'; reverse=!reverse" style="width: 5%;font-size: 14px;">APPLICATION_ID</th>-->
										<th  ng-click="orderByField=''; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">BusinessName</th>
										<th  ng-click="orderByField=''; reverseSort = !reverseSort"style="width: 10%;font-size: 14px;">Plan</th>
										<th  ng-click="orderByField=''; reverseSort = !reverseSort" style="width: 7%;font-size: 14px;">Plan Type</th>
										<th  ng-click="orderByField=''; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Startdate</th>
										<th  ng-click="orderByField=''; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Enddate</th>
											
									</tr>
								</thead>
								<tbody ng-init="count.subscribe=0;count.expire=0;count.counts=0;xyz=0;count1.counts1=0;">
								<tr ng-repeat="itembusiness in allBusinessItems|offset: currentPage*itemsPerPage | limitTo: itemsPerPage|orderBy:orderByField:reverseSort">
									         
									         <td style="font-size: 14px;">
								             <span> 
								             {{itembusiness.business_NAME}}<br>
								             {{itembusiness.address}}<br>
								             {{itembusiness.city}} {{itembusiness.phone_NUMBER}} <br>
								             {{itembusiness.email}}
								             </span> 
								             </td>
								          								
									         <td style="font-size: 14px;">
								             <span>{{itembusiness.plan_TYPE}}<br></span>
								             </td>
								             
								             <td style="font-size: 14px;">
									         <span>{{itembusiness.trial}}</span>
									         </td>
									        
									         <td style="font-size: 14px;">
									         <span>{{itembusiness.cycle_START_DATE}}</span>
									         </td>
									        
									       	
									         <td style="font-size: 14px;">
									         <span>{{itembusiness.cycle_END_DATE}}</span>
									         </td>
									   
									                       	
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
							 <button type="button" class="btn btn-default" data-dismiss="modal" style="margin-top:-10px;margin-right:10px;float:right;color:white;background-color: #f44336;">Close</button>	
							</div>
							</div>
  </div>
</div><!-- end of modal --> 


  <div class="modal fade" id="myModal2" role="dialog">
    <div class="modal-dialog modal-lg" style="width: 1200px;">
    
      <!-- Modal content-->
        <div class="modal-body">
        <div  class="form-control" style="width: 100%;float:left;height:auto ;min-height: 60px;margin-top:30px">
        
          <button type="button" class="close" data-dismiss="modal"  style="margin-top:5px;margin-right:10px;">&times;</button>
          <table style="margin-left:10px;margin-top:-5px;"> <tr><td>{{year}}</td><td><h4 style="margin-left:450px;color:black;">{{plan}}</h4></td></tr></table>
        
     <input type="text" class="form-control" id="searchText" ng-model="searchText.$" placeholder="Search" type="search" ng-change="search1()"  style="margin-top:-2px;margin-bottom:-10px;width:350px;"  autofocus>
     <span class="exportInExel" style="margin-top:-20px;margin-bottom:-6px;margin-right:25px;float: right;">
 	 <button ng-click="appReportStartDateExport()" class="btn btn-warning" style="padding: 6px 12px; margin-bottom: 0px; font-size: 14px; font-weight: 400; line-height: 1.42857; text-align: center; white-space: nowrap; vertical-align: middle; cursor: pointer; -moz-user-select: none; background-image: none; border: 1px solid transparent; border-radius: 4px;margin:-1px -16px;" id="autoZoneExport"><span style="margin-right: 6px;" class="glyphicon glyphicon-save"></span>Export</button>
 	 </span>
     <!-- <input type="text" class="form-control" id="searchText" ng-model="search1" placeholder="Search" type="search"  style="margin-top:-2px;margin-bottom:-10px;width:350px;">-->
        <hr>
			   				<table  class="table table-bordered" style="margin-top:-10px;">
								<thead style="background-color: #0088cc;color: white;">
									<tr>
										<!--<th ng-click="predicate = 'businessName'; reverse=!reverse" style="width: 5%;font-size: 14px;">APPLICATION_ID</th>-->
										<th  ng-click="orderByField='business_NAME'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">BusinessName</th>
										<th  ng-click="orderByField='plan_TYPE'; reverseSort = !reverseSort"style="width: 10%;font-size: 14px;">Plan</th>
										<th  ng-click="orderByField='trial'; reverseSort = !reverseSort" style="width: 7%;font-size: 14px;">Plan Type</th>
										<th  ng-click="orderByField='cycle_START_DATE'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Startdate</th>
										<th  ng-click="orderByField='cycle_END_DATE'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Enddate</th>
										<th  ng-click="orderByField='daysLeft'; reverseSort = !reverseSort" style="width: 8%;font-size: 14px;">Leftdays</th>	
									</tr>
								</thead>
								<tbody ng-init="count.subscribe=0;count.expire=0;count.counts=0;xyz=0;count1.counts1=0;">
								<tr ng-repeat="itembusiness in allBusinessItems|offset: currentPage*itemsPerPage | limitTo: itemsPerPage|orderBy:orderByField:reverseSort">
									         
									         <td style="font-size: 14px;">
								             <span> 
								             {{itembusiness.business_NAME}}<br>
								             {{itembusiness.address}}<br>
								             {{itembusiness.city}} {{itembusiness.phone_NUMBER}} <br>
								             {{itembusiness.email}}
								             </span> 
								             </td>
								          								
									         <td style="font-size: 14px;">
								             <span>{{itembusiness.plan_TYPE}}<br></span>
								             </td>
								             
								             <td style="font-size: 14px;">
									         <span>{{itembusiness.trial}}</span>
									         </td>
									        
									         <td style="font-size: 14px;">
									         <span>{{itembusiness.cycle_START_DATE}}</span>
									         </td>
									        
									       	
									         <td style="font-size: 14px;">
									         <span>{{itembusiness.cycle_END_DATE}}</span>
									         </td>
									   
									         <td style="font-size: 14px;" >
									         <span>{{itembusiness.daysLeft}}</span>
									         </td>	               	
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
							 <button type="button" class="btn btn-default" data-dismiss="modal" style="margin-top:-10px;margin-right:10px;float:right;color:white;background-color: #f44336;">Close</button>	
							</div>
							</div>
  </div>
</div><!-- end of modal --> 




   <div id="footer"> 
    <jsp:include page="/footer.jsp"></jsp:include>
    </div>
</body>
<script type="text/javascript">
			
			$(".mainMenu").find("li").each(function(){
				var innerHtml=$(this).find("a").html();
				
				if(innerHtml=="Apps"){
					$(this).addClass("active");
					$(this).find("a").css("background-color","#0088cc");
				}
				else{
					$(this).removeClass("active");
					$(this).find("a").css("background-color","");
				}
			});
			
</script>

</html>
