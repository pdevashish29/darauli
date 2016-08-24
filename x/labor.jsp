<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%
    	String path=request.getContextPath();
    Calendar calendar=Calendar.getInstance();
    int month=calendar.get(Calendar.MONTH);
    int year=calendar.get(Calendar.YEAR);
    calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
    Date firstDay=calendar.getTime();
    SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
    calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
    Date lastDay=calendar.getTime();
   // System.out.println(format.format(firstDay)+".....................DDDDDDDDDDDDD.........."+format.format(lastDay));
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
<style type="text/css">
	.table-bordered tbody tr:nth-child(even){
		background: #ddd;
	}
</style>
<script type="text/javascript">
var app=angular.module('laborApp', []);
app.factory('laborFactory',['$http','$q', function($http, $q){
	return{
		'laborDataByMonth':function(year, month){
			return $http({
				method:'post',
				url:'<%=path%>/laborData',
				data:{month:month, year:year}
			}).then(
				function(response){
					return response.data;
				},		
				function(errResponse){
					return $q.reject(errResponse);
				}
			);
		},
		
		'laborDataByDate':function(from, to){
			return $http({
				method:'post',
				url:'<%=path%>/laborData',
				data:{from:from, to:to}
			}).then(
				function(response){
					return response.data;
				},		
				function(errResponse){
					return $q.reject(errResponse);
				}
			);
		},
		
		'saveTechHour':function(json){
			return $http({
				method:'post',
				data:json,
				url:'<%=path%>/saveTechHour'
			}).then(
				function(response){
					return response.data;
				}		,
				function(errResponse){
					return $q.reject(errResponse);
				}
			);
		}
	}
}]);
app.controller('laborCtrl', function($scope, laborFactory, graphFactory, $filter){
	$scope.year='<%=year %>';
	$scope.month='<%=month %>';
	$scope.yearList=[];
	$scope.laborList='';
	$scope.laborListCopy='';
	$scope.spinner=true;
	for(var i=$scope.year-5;i<Number($scope.year)+5;i++){
		$scope.yearList.push(i);
	}
	laborFactory.laborDataByMonth($scope.year,$scope.month).then(
		function(data){
			//alert(JSON.stringify(data));
			
			$scope.laborList=data;
			$scope.laborListCopy=$scope.laborList;
			$scope.laborList=$filter('orderBy')($scope.laborList, $scope.predicate, $scope.reverse);
			$scope.search($scope.laborList);
			$scope.spinner=false;
		}		
	);
	
	$scope.clickOnMonth=function(month){
		$scope.month=month;
		$scope.calendarDef=0; 
		$scope.calendarShow=true;
		$scope.spinner=true;
		laborFactory.laborDataByMonth( $scope.year,$scope.month).then(
				function(data){
					
					$scope.laborList=data;
					$scope.laborListCopy=$scope.laborList;
					$scope.laborList=$filter('orderBy')($scope.laborList, $scope.predicate, $scope.reverse);
					$scope.search($scope.laborList);
					$scope.spinner=false;
				}		
			);
	};
	
	$scope.fromDate='';
	$scope.toDate='';
	$scope.getLaborByDateSearch=function(){
		$scope.spinner=true;
		$scope.fromDate=$("#fromDate").val();
		$scope.toDate=$("#toDate").val();
		//alert($scope.fromDate+'.........'+$scope.toDate);
		laborFactory.laborDataByDate($scope.fromDate, $scope.toDate).then(
				function(data){
					
					$scope.laborList=data;
					$scope.laborListCopy=$scope.laborList;
					$scope.laborList=$filter('orderBy')($scope.laborList, $scope.predicate, $scope.reverse);
					$scope.search($scope.laborList); 
					$scope.spinner=false;
				}		
			);
	};
	
	$scope.predicate='creationDate';
	$scope.reverse=true;
	$scope.ordering=function(predicate){
		$scope.laborList=$filter('orderBy')($scope.laborListCopy, predicate, $scope.reverse);
		 $scope.search($scope.laborList);
		 $scope.reverse = ($scope.predicate === predicate) ? !$scope.reverse : false;
	     $scope.predicate = predicate;
	};
	
	$scope.saveTime=function(json, idx){
		var startTime=$('div#datetimepicker2'+idx).find('input').val();
		var endTime=$('div#datetimepicker3'+idx).find('input').val();
		var totalHr=0;
		if(typeof startTime !='null' && typeof startTime!='undefined' && typeof startTime!='' && typeof endTime !='null' && typeof endTime!='undefined' && typeof endTime!=''){
			totalHr=$scope.totalTimeCalculate(startTime, endTime, json, true);
			
		}
		//alert(totalHr); 
		//alert(JSON.stringify($scope.laborList[idx])+'............'+JSON.stringify(json));
		var dataJson={
				startTime:json.flag==true?json.startTime:startTime,
				endTime:json.flag==true?json.endTime:endTime,
				totalHr:json.flag==true?json.totalHr:totalHr,
				isPackage:json.isPackage,
				serviceId:json.descriptionId
		}
		laborFactory.saveTechHour(dataJson).then(
			function(data){
				alert(JSON.stringify(data))
			}		
		);
	};
	
	$scope.totalTimeCalculate=function(startTime, endTime, json, flag){
		var start=[];
		var end=[];
		var total="";
		if(flag==true){
			start=startTime.split(':');
			end=endTime.split(':');
		}else{
			start=json.startTime.split(':');
			end=json.endTime.split(':');
		}
		var startDate=new Date(0,0,0,start[0],start[1],0 );
		var endDate=new Date(0,0,0,end[0],end[1],0 );
		 var diff = endDate.getTime() - startDate.getTime();
		var hours = Math.floor(diff / 1000 / 60 / 60);
	    diff -= hours * 1000 * 60 * 60;
	    var minutes = Math.floor(diff / 1000 / 60);
		total=(hours < 9 ? "0" : "") + hours + ":" + (minutes < 9 ? "0" : "") + minutes;
		json.totalHr=total;
		return total;
	};
	$scope.searchTechnician='';
	$scope.filtering=function(){
		if($scope.searchTechnician.length>1){
			$scope.laborList=$filter('filter')($scope.laborListCopy, $scope.searchTechnician);
			 $scope.search($scope.laborList);
		}else{
			 $scope.search($scope.laborListCopy);
			 //alert($scope.laborListCopy.length)
		}
		
	}
	
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

function clickForTimeSelect(that){
	$(that).parent().parent().datetimepicker({
		format: 'HH:mm'
    });
}
</script>
</head>
<body ng-app="laborApp" ng-controller="laborCtrl">
<div class="fluid-container">
	<jsp:include page="timeLaborMain.jsp"></jsp:include>
	<div class="panel panel-primary" style="margin-top: -9px;">
		<div class="panel-heading">
			<h4 class="panel-title">Time and Labor</h4>
		</div>
		<div class="panel-body" data-ng-init="calendarDef=0; calendarShow=true" style="min-height: 400px;">
			<div class="form-group">
				<ul class="nav nav-tabs" >
				        <li data-id="0" data-ng-class="{'active':calendarDef==0}" data-ng-click="clickOnMonth('<%=month %>')"><a href="#">Monthly</a></li>
				        <li data-id="1" data-ng-class="{'active':calendarDef==1}" data-ng-click="calendarDef=1; calendarShow=false"><a href="#">Date Range</a></li>
				</ul>
			</div>
			<div class="form-group" id="div_year_month_list" style="width: 100%;height: 42px;" data-ng-show="calendarShow">
				<div id="div_year_list" style="float: left;width: 10%;">
					<span style="float: left;margin-right: 5px;font-size: 20px;margin-top: 2px;">Year</span>
					<select ng-model="year" class="form-control" style="width: 80px;height: 40px;">
						 <option ng-repeat="option in yearList" ng-selected="year==option" value="{{option}}">{{option}}</option>
					</select>
				</div>
				<div id="div_month_list" style="width: 90%;float: left;">
					<ul class="nav nav-tabs" >
				        <li data-id="0" data-ng-class="{'active':month==0}" data-ng-click="clickOnMonth(0)"><a href="#">Jan</a></li>
				        <li data-id="1" data-ng-class="{'active':month==1}" data-ng-click="clickOnMonth(1)"><a href="#">Feb</a></li>
				        <li data-id="2" data-ng-class="{'active':month==2}" data-ng-click="clickOnMonth(2)"><a href="#">Mar</a></li>
				        <li data-id="3" data-ng-class="{'active':month==3}" data-ng-click="clickOnMonth(3)"><a href="#">Apr</a></li>
				        <li data-id="4" data-ng-class="{'active':month==4}" data-ng-click="clickOnMonth(4)"><a href="#">May</a></li>
				        <li data-id="5" data-ng-class="{'active':month==5}" data-ng-click="clickOnMonth(5)"><a href="#">Jun</a></li>
				        <li data-id="6" data-ng-class="{'active':month==6}" data-ng-click="clickOnMonth(6)"><a href="#">Jul</a></li>
				        <li data-id="7" data-ng-class="{'active':month==7}" data-ng-click="clickOnMonth(7)"><a href="#">Aug</a></li>
				        <li data-id="8" data-ng-class="{'active':month==8}" data-ng-click="clickOnMonth(8)"><a href="#">Sep</a></li>
				        <li data-id="9" data-ng-class="{'active':month==9}" data-ng-click="clickOnMonth(9)"><a href="#">Oct</a></li>
				        <li data-id="10" data-ng-class="{'active':month==10}" data-ng-click="clickOnMonth(10)"><a href="#">Nov</a></li>
				        <li data-id="11" data-ng-class="{'active':month==11}" data-ng-click="clickOnMonth(11)"><a href="#">Dec</a></li>
				      </ul>	
				</div>	
			</div><!-- End div_year_month_list -->
			<div class="form-group" style="height: 34px;" data-ng-hide="calendarShow">
					<div style="display: inline-flex;">
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
						<span><input type="button"  data-ng-click="getLaborByDateSearch();" style="margin-left: 10px;" class="btn btn-primary" value="Search" /></span>
					</div>
					
				</div>
				
				<button class="btn btn-primary" style="float: right;" onclick="window.print();">Print</button>
			<div class="form-group" id="div_input_textbox" >
					<input style="width: 40%;" type="text" class="form-control" data-ng-model="searchTechnician" data-ng-change="filtering()" placeholder="Search by technician">
				</div>
			<div ng-show="spinner">
				<div class="loading-spiner" id="loadingimg" style="margin: 40px 0px 0px; text-align: center;">
						<img src="<%=path%>/resources/image/gif-load.gif" style="margin-top:-16px;position:absolute;">
  					</div>	
			</div>
			<div class="form-group" style="margin: 0px -15px;" ng-show="!spinner">
				<table class="table table-bordered">
					<thead>
						<tr>
							<th data-ng-click="ordering('technician')" rowspan="2" style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">Technician</th>
							<th data-ng-click="ordering('creationDate')" rowspan="2" style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">Date</th>
							<th data-ng-click="ordering('id')" rowspan="2" style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">WO#</th>
							<th data-ng-click="ordering('description')" rowspan="2" style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">Jobs</th>
							<th data-ng-click="ordering('hour')" rowspan="2" style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">Billable</th>
							<th colspan="2" style="background: rgb(0, 136, 204);color:#fff;">Time</th>
							<th data-ng-click="ordering('totalHr')" rowspan="2" style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">Actual hr</th>
							<th rowspan="2" style="vertical-align: middle;background: rgb(0, 136, 204);color:#fff;">Action</th>
						</tr>
						<tr>
							<th data-ng-click="ordering('startTime')" style="background: rgb(0, 136, 204);color:#fff;">Start</th>
							<th data-ng-click="ordering('endTime')" style="background: rgb(0, 136, 204);color:#fff;">End</th>
						</tr>
					</thead>
					<tbody>
						<tr data-ng-repeat="labor in pagedItems[currentPage] | orderBy:predicate:reverse">
							<td>{{labor.technician}}</td>
							<td>{{labor.creationDate |date:'MMM dd, yyyy'}}</td>
							<td>{{labor.id}}</td>
							<td>{{labor.description}}</td>
							<td>{{labor.hour|number}}</td>
							<td style="width: 95px;"><!-- onclick="clickForTimeSelect(this)" -->
								<div class="form-group" style="margin-bottom: 0px;" ng-if="labor.startTime==null && labor.flag==false">
					                <div class='input-group date' id='datetimepicker2{{$index}}'>
					                    <input type='text' class="form-control" style="padding: 5px;" ng-model="labor.startTime"  />
					                    <span class="input-group-addon" style="padding: 6px;">
					                        <span class="glyphicon glyphicon-time" onclick="clickForTimeSelect(this)"></span>
					                    </span>
					                </div>
					            </div>
								<!-- <input type="text" ng-model="labor.startTime" ng-if="labor.startTime==null && labor.flag==false" class="form-control" style="height: 30px;padding: 6px 6px;" /> -->
								<span ng-if="labor.startTime!=null && labor.flag==false">{{labor.startTime}}</span>
								<input type="text" ng-model="labor.startTime" ng-if="labor.flag==true" data-ng-change="totalTimeCalculate(labor.startTime,labor.endTime, labor, false )" class="form-control"  style="height: 30px;padding: 6px 6px;" />
								
							</td>
							<td style="width: 95px;">
								<div class="form-group" style="margin-bottom: 0px;" ng-if="labor.endTime==null && labor.flag==false">
					                <div class='input-group date' id='datetimepicker3{{$index}}'>
					                    <input type='text' class="form-control" style="padding: 5px;"  ng-model="labor.endTime" />
					                    <span class="input-group-addon" style="padding: 6px;">
					                        <span class="glyphicon glyphicon-time" onclick="clickForTimeSelect(this)"></span>
					                    </span>
					                </div>
					            </div>
								<!-- <input type="text" ng-model="labor.endTime" ng-if="labor.endTime==null && labor.flag==false" class="form-control" style="height: 30px;padding: 6px 6px;" /> -->
								<span ng-if="labor.endTime!=null && labor.flag==false">{{labor.endTime}}</span>	
								<input type="text" ng-model="labor.endTime" ng-if="labor.flag==true" class="form-control" data-ng-change="totalTimeCalculate(labor.startTime,labor.endTime, labor, false )" style="height: 30px;padding: 6px 6px;" />
								
							</td>
							<td style="width: 75px;">
								<input type="text" ng-model="labor.totalHr" ng-if="labor.totalHr==null && labor.flag==false" class="form-control" style="height: 30px;padding: 6px 6px;" />
								<span ng-if="labor.totalHr!=null && labor.flag==false">{{labor.totalHr}}</span>	
								<input type="text" ng-model="labor.totalHr"  ng-if="labor.flag==true" class="form-control" style="height: 30px;padding: 6px 6px;" />
								
							</td>
							<td>
								<span ng-if="labor.endTime!=null && labor.flag==false">
									<button class="btn btn-success" data-ng-click="labor.flag=true">Edit</button>
								</span>
								<span ng-if="labor.endTime==null || labor.flag==true">
									<button class="btn btn-primary" data-ng-click="saveTime(labor, $index)">Save</button>
								</span>
							</td>
						</tr>
					</tbody>
					<tfoot >
				  	<!-- <tr style='display:none' id='noRecTR'><td colspan='10' style='text-align:center;color:red;'><b >No Record Found<b></b></td></tr>
				 --><tr>	
                    <td colspan="9">
                        <div  style="text-align: center;">
                            <ul class="pagination pagination-lg">
                                <li ng-class="{disabled: currentPage == 0}">
                                    <a href ng-click="prevPage()">« Prev</a>
                                </li>
                                <li ng-repeat="n in range(pagedItems.length,currentPage)"
                                    ng-class="{active: n == currentPage}"
                                ng-click="setPage()">
                                    <a href ng-bind="n + 1">1</a>
                                </li>
                                <li ng-class="{disabled: currentPage == pagedItems.length - 1}">
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
</body>
<script type="text/javascript">
$(function () {
	 $('#taskStartDate').datetimepicker({
	    	format: 'MM/DD/YYYY',
	    	defaultDate: '<%=format.format(lastDay)%>'
	    });
    $('#toDateSpan').datetimepicker({
    	format: 'MM/DD/YYYY',
    	defaultDate: '<%=format.format(lastDay)%>'
    });
    
    $('#fromDateSpan').datetimepicker({
    	format: 'MM/DD/YYYY',
    	defaultDate: '<%=format.format(firstDay)%>'
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
</script>
</html>